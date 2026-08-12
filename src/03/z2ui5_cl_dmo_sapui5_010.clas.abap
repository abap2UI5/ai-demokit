"! <p class="shorttext">sap.ui.vbm - AnalyticMap</p>
"!
"! SAPUI5-only control: it ships with SAPUI5, not with OpenUI5, so there is no
"! demo kit original in this repo's sample universe and no 1:1 port (AGENTS §3).
"! Collected here as orientation - how the control is expressed in abap2UI5.
"!
"! SAPUI5 demo kit: https://ui5.sap.com/#/entity/sap.ui.vbm.AnalyticMap
CLASS z2ui5_cl_dmo_sapui5_010 DEFINITION PUBLIC.

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

    DATA mt_spot TYPE STANDARD TABLE OF ty_s_spot WITH EMPTY KEY.

    DATA
      mt_route TYPE STANDARD TABLE OF ty_s_route WITH EMPTY KEY.

    DATA mt_legend TYPE STANDARD TABLE OF ty_s_legend WITH EMPTY KEY.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_dmo_sapui5_010 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      mt_spot = VALUE #(
        ( pos = `9.98336;53.55024;0`         contentoffset = `0;-6` scale = `1;1;1` key = `Hamburg`     tooltip = `Hamburg`     type = `Default` icon = `factory` )
        ( pos = `11.5820;48.1351;0`          contentoffset = `0;-5` scale = `1;1;1` key = `Munich`      tooltip = `Munich`      type = `Default` icon = `factory` )
        ( pos = `8.683340000;50.112000000;0` contentoffset = `0;-6` scale = `1;1;1` key = `Frankfurt`   tooltip = `Frankfurt`   type = `Default` icon = `factory` ) ).

      mt_route = VALUE #(
        (  position = `2.3522219;48.856614;0; -74.0059731;40.7143528;0`   routetype = `Geodesic` linedash = `10;5` color = `92,186,230` colorborder = `rgb(255,255,255)` linewidth = `25` ) ).

      mt_legend = VALUE #(
        (   text = `Dashed flight route` color = `rgb(92,186,230)` )
        (   text = `Flight route` color = `rgb(92,186,35)` ) ).
    ENDIF.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
            )->page(
                    title          = `abap2UI5 - Map Container`
                    navbuttonpress = client->_event_nav_app_leave( )
                    shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(map) = page->map_container( autoadjustheight = abap_true
         )->content( `vk`
             )->container_content(
               title = `Analytic Map`
               icon  = `sap-icon://geographic-bubble-chart`
                 )->content( `vk`
                     )->analytic_map(
                       initialposition = `9.933573;50;0`
                       initialzoom     = `6` ).

    map->vos(
      )->spots( client->_bind( mt_spot )
      )->spot(
        position      = `{POS}`
        contentoffset = `{CONTENTOFFSET}`
        type          = `{TYPE}`
        scale         = `{SCALE}`
        tooltip       = `{TOOLTIP}` ).

    map->routes( client->_bind( mt_route ) )->route(
      position      = `{POSITION}`
        routetype   = `{ROUTETYPE}`
        linedash    = `{LINEDASH}`
        color       = `{COLOR}`
        colorborder = `{COLORBORDER}`
      linewidth     = `{LINEWIDTH}`
      ).

    map->legend_area( )->legend(
        items   = client->_bind( mt_legend )
        caption = `Legend`
      )->legenditem(
      text    = `{TEXT}`
        color = `{COLOR}`
      ).
    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
