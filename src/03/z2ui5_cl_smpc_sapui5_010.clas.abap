" @keywords analyticmap shell mapcontainer containercontent spots spot routes route legend legenditem
" @summary sap.ui.vbm.AnalyticMap expressed in abap2UI5 - a SAPUI5-only control, so the demo kit original is outside OpenUI5 and this is orientation rather than a 1:1 port.
"! <p class="shorttext">sap.ui.vbm - AnalyticMap</p>
"!
"! SAPUI5-only control: it ships with SAPUI5, not with OpenUI5, so there is no
"! demo kit original in this repo's sample universe and no 1:1 port (AGENTS section 3).
"! Collected here as orientation - how the control is expressed in abap2UI5.
"!
"! SAPUI5 demo kit: https://ui5.sap.com/#/entity/sap.ui.vbm.AnalyticMap
CLASS z2ui5_cl_smpc_sapui5_010 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_spot,
        tooltip       TYPE string,
        type          TYPE string,
        pos           TYPE string,
        scale         TYPE string,
        contentoffset TYPE string,
        key           TYPE string,
        icon          TYPE string,
      END OF ty_s_spot.

    TYPES:
      BEGIN OF ty_s_route,
        position    TYPE string,
        routetype   TYPE string,
        linedash    TYPE string,
        color       TYPE string,
        colorborder TYPE string,
        linewidth   TYPE string,
      END OF ty_s_route.

    TYPES: BEGIN OF ty_s_legend,
             text  TYPE string,
             color TYPE string,
           END OF ty_s_legend.

    DATA mt_spot TYPE STANDARD TABLE OF ty_s_spot WITH DEFAULT KEY.

    DATA
      mt_route TYPE STANDARD TABLE OF ty_s_route WITH DEFAULT KEY.

    DATA mt_legend TYPE STANDARD TABLE OF ty_s_legend WITH DEFAULT KEY.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_smpc_sapui5_010 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA temp1 LIKE mt_spot.
      DATA temp2 LIKE LINE OF temp1.
      DATA temp3 LIKE mt_route.
      DATA temp4 LIKE LINE OF temp3.
      DATA temp5 LIKE mt_legend.
      DATA temp6 LIKE LINE OF temp5.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.

    " No check_on_navigated( ) branch, and that is not an oversight: the view
    " below is built and displayed OUTSIDE the lifecycle IF, so every
    " roundtrip re-displays it - including the navigated one. The IF only
    " seeds the model, which has to happen once.
    IF client->check_on_init( ) IS NOT INITIAL.

      
      CLEAR temp1.
      
      temp2-pos = `9.98336;53.55024;0`.
      temp2-contentoffset = `0;-6`.
      temp2-scale = `1;1;1`.
      temp2-key = `Hamburg`.
      temp2-tooltip = `Hamburg`.
      temp2-type = `Default`.
      temp2-icon = `factory`.
      INSERT temp2 INTO TABLE temp1.
      temp2-pos = `11.5820;48.1351;0`.
      temp2-contentoffset = `0;-5`.
      temp2-scale = `1;1;1`.
      temp2-key = `Munich`.
      temp2-tooltip = `Munich`.
      temp2-type = `Default`.
      temp2-icon = `factory`.
      INSERT temp2 INTO TABLE temp1.
      temp2-pos = `8.683340000;50.112000000;0`.
      temp2-contentoffset = `0;-6`.
      temp2-scale = `1;1;1`.
      temp2-key = `Frankfurt`.
      temp2-tooltip = `Frankfurt`.
      temp2-type = `Default`.
      temp2-icon = `factory`.
      INSERT temp2 INTO TABLE temp1.
      mt_spot = temp1.

      
      CLEAR temp3.
      
      temp4-position = `2.3522219;48.856614;0; -74.0059731;40.7143528;0`.
      temp4-routetype = `Geodesic`.
      temp4-linedash = `10;5`.
      temp4-color = `92,186,230`.
      temp4-colorborder = `rgb(255,255,255)`.
      temp4-linewidth = `25`.
      INSERT temp4 INTO TABLE temp3.
      mt_route = temp3.

      
      CLEAR temp5.
      
      temp6-text = `Dashed flight route`.
      temp6-color = `rgb(92,186,230)`.
      INSERT temp6 INTO TABLE temp5.
      temp6-text = `Flight route`.
      temp6-color = `rgb(92,186,35)`.
      INSERT temp6 INTO TABLE temp5.
      mt_legend = temp5.
    ENDIF.

    
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `displayBlock` v = `true`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:vk`     v = `sap.ui.vk`
        )->a( n = `xmlns:vbm`    v = `sap.ui.vbm`

        )->ele( `Shell`
            )->ele( `Page`
                )->a( n = `title`          v = `abap2UI5 - Map Container`
                )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
                )->a( n = `showNavButton`  b = client->check_app_prev_stack( )

                )->ele( n = `MapContainer` ns = `vk`
                    )->a( n = `autoAdjustHeight` b = abap_true

                    )->ele( n = `content` ns = `vk`
                        )->ele( n = `ContainerContent` ns = `vk`
                            )->a( n = `title` v = `Analytic Map`
                            )->a( n = `icon`  v = `sap-icon://geographic-bubble-chart`

                            )->ele( n = `content` ns = `vk`
                                )->ele( n = `AnalyticMap` ns = `vbm`
                                    )->a( n = `initialPosition` v = `9.933573;50;0`
                                    )->a( n = `initialZoom`     v = `6`

                                    )->ele( n = `vos` ns = `vbm`
                                        )->ele( n = `Spots` ns = `vbm`
                                            )->a( n = `items` v = client->_bind( mt_spot )

                                            )->tag( n = `Spot` ns = `vbm`
                                                )->a( n = `position`      v = `{POS}`
                                                )->a( n = `contentOffset` v = `{CONTENTOFFSET}`
                                                )->a( n = `type`          v = `{TYPE}`
                                                )->a( n = `scale`         v = `{SCALE}`
                                                )->a( n = `tooltip`       v = `{TOOLTIP}`

                                        )->end(
                                    )->end(

                                    )->ele( n = `Routes` ns = `vbm`
                                        )->a( n = `items` v = client->_bind( mt_route )

                                        )->tag( n = `Route` ns = `vbm`
                                            )->a( n = `position`    v = `{POSITION}`
                                            )->a( n = `routetype`   v = `{ROUTETYPE}`
                                            )->a( n = `lineDash`    v = `{LINEDASH}`
                                            )->a( n = `linewidth`   v = `{LINEWIDTH}`
                                            )->a( n = `color`       v = `{COLOR}`
                                            )->a( n = `colorBorder` v = `{COLORBORDER}`

                                    )->end(

                                    )->ele( n = `legend` ns = `vbm`
                                        )->ele( n = `Legend` ns = `vbm`
                                            )->a( n = `caption` v = `Legend`
                                            )->a( n = `items`   v = client->_bind( mt_legend )

                                            )->tag( n = `LegendItem` ns = `vbm`
                                                )->a( n = `text`  v = `{TEXT}`
                                                )->a( n = `color` v = `{COLOR}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
