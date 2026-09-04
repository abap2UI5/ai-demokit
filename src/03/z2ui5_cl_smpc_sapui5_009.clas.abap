" @keywords statusindicator.statusindicator html shell panel text slider responsivescale flexbox statusindicator propertythreshold shapegroup libraryshape
" @summary sap.suite.ui.commons.statusindicator.StatusIndicator expressed in abap2UI5 - a SAPUI5-only control, so the demo kit original is outside OpenUI5 and this is orientation rather than a 1:1 port.
"! <p class="shorttext">sap.suite.ui.commons - statusindicator.StatusIndicator</p>
"!
"! SAPUI5-only control: it ships with SAPUI5, not with OpenUI5, so there is no
"! demo kit original in this repo's sample universe and no 1:1 port (AGENTS section 3).
"! Collected here as orientation - how the control is expressed in abap2UI5.
"!
"! SAPUI5 demo kit: https://ui5.sap.com/#/entity/sap.suite.ui.commons.statusindicator.StatusIndicator
CLASS z2ui5_cl_smpc_sapui5_009 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_shape,
       id TYPE string,
      END OF ty_s_shape.

    DATA mv_slider_value TYPE i.

    TYPES temp1_585620f2fa TYPE STANDARD TABLE OF ty_s_shape WITH DEFAULT KEY.
DATA mt_shapes TYPE temp1_585620f2fa.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS initialize.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_smpc_sapui5_009 IMPLEMENTATION.

  METHOD initialize.
    DATA temp1 LIKE mt_shapes.
    DATA temp2 LIKE LINE OF temp1.

    mv_slider_value = 0.

    
    CLEAR temp1.
    
    temp2-id = `arrow_down`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `arrow_left`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `arrow_right`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `arrow_up`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `attention_1`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `attention_2`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `building`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `bulb`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `bull`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `calendar`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `car`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `cart`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `cereals`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `circle`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `clock`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `cloud`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `conveyor`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `desk`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `document`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `documents`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `dollar`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `donut`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `drop`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `envelope`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `euro`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `factory`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `female`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `fish`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `flag`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `folder_1`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `folder_2`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `gear`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `heart`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `honey`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `house`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `information`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `letter`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `lung`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `machine`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `male`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `pen`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `person`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `pin`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `plane`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `printer`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `progress`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `question`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `robot`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `sandclock`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `speed`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `stomach`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `success`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `tank_diesel`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `tank_lpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `thermo`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `tool`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `transfusion`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `travel`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `turnip`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `vehicle_construction`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `vehicle_tank`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `vehicle_tractor`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `vehicle_truck_1`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `vehicle_truck_2`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `vehicle_truck_3`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `warehouse`.
    INSERT temp2 INTO TABLE temp1.
    mt_shapes = temp1.

  ENDMETHOD.

  METHOD view_display.


    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE xsdboolean.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    temp1 = boolc( client->get( )-check_launchpad_active = abap_false ).
    view->ele( n = `View` ns = `mvc`
        )->a( n = `displayBlock` v = `true`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:si`     v = `sap.suite.ui.commons.statusindicator`

        " the stylesheet travels as the CONTENT of a core:HTML control: the
        " builder re-escapes it on stringify, so the literal markup is written
        " here, and the CSS braces are escaped for the XMLView parser
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>`                          && |\n| &&
                                    `.SICursorStyle:hover \{`          && |\n| &&
                                    `  cursor: pointer;`               && |\n| &&
                                    `\}`                               && |\n| &&
                                    `.SIBorderStyle \{`                && |\n| &&
                                    `  border: 1px solid #cccccc;`     && |\n| &&
                                    `\}`                               && |\n| &&
                                    `.SIPanelStyle .sapMPanelContent\{` && |\n| &&
                                    `  overflow: visible;`             && |\n| &&
                                    `\}`                               && |\n| &&
                                    `</style>`

        )->ele( `Shell`
            )->ele( `Page`
                )->a( n = `title`          v = `abap2UI5 - Status Indicators Library`
                )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
                )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                )->a( n = `showHeader`     b = temp1

                )->ele( `Panel`
                    )->a( n = `class` v = `sapUiResponsiveMargin SIPanelStyle`
                    )->a( n = `width` v = `95%`

                    )->tag( `Text`
                        )->a( n = `text` v = `Use the slider for adjusting the fill`

                    )->ele( `Slider`
                        )->a( n = `class`           v = `sapUiLargeMarginBottom`
                        )->a( n = `value`           v = client->_bind( mv_slider_value )
                        )->a( n = `enableTickmarks` b = abap_true

                        )->tag( `ResponsiveScale`
                            )->a( n = `tickmarksBetweenLabels` v = `10`

                    )->end(

                    )->ele( `FlexBox`
                        )->a( n = `wrap`  v = `Wrap`
                        )->a( n = `items` v = client->_bind( mt_shapes )

                        )->ele( `items`
                            )->ele( `FlexBox`
                                )->a( n = `direction` v = `Column`
                                )->a( n = `class`     v = `sapUiTinyMargin SIBorderStyle`

                                )->ele( `items`
                                    )->ele( n = `StatusIndicator` ns = `si`
                                        )->a( n = `value`  v = client->_bind( mv_slider_value )
                                        )->a( n = `width`  v = `120px`
                                        )->a( n = `height` v = `120px`
                                        )->a( n = `class`  v = `sapUiTinyMargin SICursorStyle`

                                        )->ele( n = `propertyThresholds` ns = `si`
                                            )->tag( n = `PropertyThreshold` ns = `si`
                                                )->a( n = `fillColor` v = `Error`
                                                )->a( n = `toValue`   v = `25`
                                            )->tag( n = `PropertyThreshold` ns = `si`
                                                )->a( n = `fillColor` v = `Critical`
                                                )->a( n = `toValue`   v = `60`
                                            )->tag( n = `PropertyThreshold` ns = `si`
                                                )->a( n = `fillColor` v = `Good`
                                                )->a( n = `toValue`   v = `100`

                                        )->end(

                                        )->ele( n = `ShapeGroup` ns = `si`
                                            )->tag( n = `LibraryShape` ns = `si`
                                                )->a( n = `shapeId` v = `{ID}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.

      initialize( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
