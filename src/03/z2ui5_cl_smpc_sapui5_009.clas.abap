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

    DATA mt_shapes TYPE STANDARD TABLE OF ty_s_shape WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS initialize.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_smpc_sapui5_009 IMPLEMENTATION.

  METHOD initialize.

    mv_slider_value = 0.

    mt_shapes = VALUE #(
                        ( id = `arrow_down` )
                        ( id = `arrow_left` )
                        ( id = `arrow_right` )
                        ( id = `arrow_up` )
                        ( id = `attention_1` )
                        ( id = `attention_2` )
                        ( id = `building` )
                        ( id = `bulb` )
                        ( id = `bull` )
                        ( id = `calendar` )
                        ( id = `car` )
                        ( id = `cart` )
                        ( id = `cereals` )
                        ( id = `circle` )
                        ( id = `clock` )
                        ( id = `cloud` )
                        ( id = `conveyor` )
                        ( id = `desk` )
                        ( id = `document` )
                        ( id = `documents` )
                        ( id = `dollar` )
                        ( id = `donut` )
                        ( id = `drop` )
                        ( id = `envelope` )
                        ( id = `euro` )
                        ( id = `factory` )
                        ( id = `female` )
                        ( id = `fish` )
                        ( id = `flag` )
                        ( id = `folder_1` )
                        ( id = `folder_2` )
                        ( id = `gear` )
                        ( id = `heart` )
                        ( id = `honey` )
                        ( id = `house` )
                        ( id = `information` )
                        ( id = `letter` )
                        ( id = `lung` )
                        ( id = `machine` )
                        ( id = `male` )
                        ( id = `pen` )
                        ( id = `person` )
                        ( id = `pin` )
                        ( id = `plane` )
                        ( id = `printer` )
                        ( id = `progress` )
                        ( id = `question` )
                        ( id = `robot` )
                        ( id = `sandclock` )
                        ( id = `speed` )
                        ( id = `stomach` )
                        ( id = `success` )
                        ( id = `tank_diesel` )
                        ( id = `tank_lpg` )
                        ( id = `thermo` )
                        ( id = `tool` )
                        ( id = `transfusion` )
                        ( id = `travel` )
                        ( id = `turnip` )
                        ( id = `vehicle_construction` )
                        ( id = `vehicle_tank` )
                        ( id = `vehicle_tractor` )
                        ( id = `vehicle_truck_1` )
                        ( id = `vehicle_truck_2` )
                        ( id = `vehicle_truck_3` )
                        ( id = `warehouse` ) ).

  ENDMETHOD.

  METHOD view_display.


    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

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
                )->a( n = `showHeader`     b = xsdbool( client->get( )-check_launchpad_active = abap_false )

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
    IF client->check_on_init( ).

      initialize( ).
      view_display( ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
