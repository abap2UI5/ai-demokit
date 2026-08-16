"! <p class="shorttext">sap.viz - ui5.controls.VizFrame</p>
"!
"! SAPUI5-only control: it ships with SAPUI5, not with OpenUI5, so there is no
"! demo kit original in this repo's sample universe and no 1:1 port (AGENTS section 3).
"! Collected here as orientation - how the control is expressed in abap2UI5.
"!
"! SAPUI5 demo kit: https://ui5.sap.com/#/entity/sap.viz.ui5.controls.VizFrame
CLASS z2ui5_cl_smpc_sapui5_012 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_data_chart,
        week    TYPE string,
        revenue TYPE string,
        cost    TYPE string,
      END OF ty_s_data_chart.
    TYPES ty_t_data_chart TYPE STANDARD TABLE OF ty_s_data_chart WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_s_screen,
        viztype    TYPE string,
        viztypesel TYPE string,
      END OF ty_s_screen.

    DATA mt_data_chart     TYPE ty_t_data_chart.

    DATA ms_screen         TYPE ty_s_screen.

    DATA mv_prop           TYPE string.
    DATA mt_feed_values    TYPE STANDARD TABLE OF string WITH EMPTY KEY.

    DATA mt_viztypes       TYPE z2ui5_if_types=>ty_t_name_value.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_rendering.
    METHODS on_event.
    METHODS on_init.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_smpc_sapui5_012 IMPLEMENTATION.

  METHOD on_event.

    CASE client->get_event( ).
      WHEN `EVT_DATA_SELECT`.
        client->message_toast_display( client->get_event_arg( ) ).
      WHEN `EVT_VIZTYPE_CHANGE`.
        ms_screen-viztype = ms_screen-viztypesel.
        on_rendering( ).
    ENDCASE.

  ENDMETHOD.

  METHOD on_init.

    " ---------- Set vizframe chart data --------------------------------------------------------------
    mt_data_chart = VALUE #( ( week    = `Week 1 - 4`
                               revenue = `431000.22`
                               cost    = `230000.00` )
                             ( week    = `Week 5 - 8`
                               revenue = `494000.30`
                               cost    = `238000.00` )
                             ( week    = `Week 9 - 12`
                               revenue = `491000.17`
                               cost    = `221000.00` )
                             ( week    = `Week 13 - 16`
                               revenue = `536000.34`
                               cost    = `280000.00` ) ).
    " ---------- Set vizframe properties (optional) ---------------------------------------------------
    mv_prop = |\{| && |\n| &&
      |"plotArea": \{| && |\n| &&
        |"dataLabel": \{| && |\n| &&
            |"formatString": "",| && |\n| &&
            |"visible": true| && |\n| &&
        |\}| && |\n| &&
      |\},| && |\n| &&
      |"valueAxis": \{| && |\n| &&
        |"label": \{| && |\n| &&
            |"formatString": ""| && |\n| &&
        |\},| && |\n| &&
        |"title": \{| && |\n| &&
            |"visible": true| && |\n| &&
        |\}| && |\n| &&
      |\},| && |\n| &&
      |"categoryAxis": \{| && |\n| &&
        |"title": \{| && |\n| &&
            |"visible": true| && |\n| &&
        |\}| && |\n| &&
      |\},| && |\n| &&
      |"title": \{| && |\n| &&
        |"visible": true,| && |\n| &&
        |"text": "Vizframe Charts for 2UI5"| && |\n| &&
      |\}| && |\n| &&
      |\}|.

    " ---------- Set vizframe feed item values for value axis -----------------------------------------
    mt_feed_values = VALUE #( ( `Revenue` )
                              ( `Cost` ) ).

    " ---------- Set viz type default -----------------------------------------------------------------
    ms_screen-viztype    = `column`.
    ms_screen-viztypesel = `column`.

    " ---------- Set VizFrame types -------------------------------------------------------------------
    mt_viztypes = VALUE #( ( n = `column`
                             v = `column` )
                           ( n = `bar`
                             v = `bar` )
                           ( n = `stacked_bar`
                             v = `stacked_bar` )
                           ( n = `stacked_column`
                             v = `stacked_column` )
                           ( n = `line`
                             v = `line` )
                           ( n = `combination`
                             v = `combination` )
                           ( n = `bullet`
                             v = `bullet` )
                           ( n = `vertical_bullet`
                             v = `vertical_bullet` )
                           ( n = `100_stacked_bar`
                             v = `100_stacked_bar` )
                           ( n = `100_stacked_column`
                             v = `100_stacked_column` )
                           ( n = `stacked_combination`
                             v = `stacked_combination` )
                           ( n = `horizontal_stacked_combination`
                             v = `horizontal_stacked_combination` )
                           ( n = `waterfall`
                             v = `waterfall` )
                           ( n = `horizontal_waterfall`
                             v = `horizontal_waterfall` )
                           ( n = `area`
                             v = `area` )
                           ( n = `radar`
                             v = `radar` ) ).

  ENDMETHOD.

  METHOD on_rendering.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `displayBlock`     v = `true`
        )->a( n = `height`           v = `100%`
        )->a( n = `xmlns`            v = `sap.m`
        )->a( n = `xmlns:mvc`        v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`       v = `sap.ui.core`
        )->a( n = `xmlns:f`          v = `sap.f`
        )->a( n = `xmlns:fb`         v = `sap.ui.comp.filterbar`
        )->a( n = `xmlns:viz`        v = `sap.viz.ui5.controls`
        )->a( n = `xmlns:viz.data`   v = `sap.viz.ui5.data`
        )->a( n = `xmlns:viz.feeds`  v = `sap.viz.ui5.controls.common.feeds`

        )->ele( `Shell`
            )->ele( n = `DynamicPage` ns = `f`
                )->a( n = `showFooter` b = abap_false

                )->ele( n = `title` ns = `f`
                    )->ele( n = `DynamicPageTitle` ns = `f`
                        )->ele( n = `heading` ns = `f`
                            )->tag( `Title`
                                )->a( n = `text` v = `abap2UI5 - VizFrame Charts`

                        )->end(
                    )->end(
                )->end(

                )->ele( n = `header` ns = `f`
                    )->ele( n = `DynamicPageHeader` ns = `f`
                        )->a( n = `pinnable` b = abap_true

                        )->ele( n = `content` ns = `f`
                            )->tag( `Button`
                                )->a( n = `text`    v = `back`
                                )->a( n = `press`   v = client->_event_nav_app_leave( )
                                )->a( n = `visible` b = client->check_app_prev_stack( )

                            )->ele( n = `FilterBar` ns = `fb`
                                )->a( n = `useToolbar` v = `false`

                                )->ele( n = `filterGroupItems` ns = `fb`
                                    )->ele( n = `FilterGroupItem` ns = `fb`
                                        )->a( n = `name`               v = `VizFrameType`
                                        )->a( n = `label`              v = `VizFrame type`
                                        )->a( n = `groupName`          v = |GroupVizFrameType|
                                        )->a( n = `visibleInFilterBar` v = `true`

                                        )->ele( n = `control` ns = `fb`
                                            )->ele( `ComboBox`
                                                )->a( n = `selectedKey`   v = client->_bind( ms_screen-viztypesel )
                                                )->a( n = `change`        v = client->_event( `EVT_VIZTYPE_CHANGE` )
                                                )->a( n = `items`         v = client->_bind( mt_viztypes )
                                                )->a( n = `showClearIcon` b = abap_true

                                                )->tag( n = `Item` ns = `core`
                                                    )->a( n = `key`  v = `{N}`
                                                    )->a( n = `text` v = `{V}`

                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( n = `content` ns = `f`
                    )->ele( n = `VizFrame` ns = `viz`
                        )->a( n = `id`            v = `idVizFrame`
                        )->a( n = `vizProperties` v = mv_prop
                        )->a( n = `vizType`       v = client->_bind( ms_screen-viztype )
                        )->a( n = `height`        v = `500px`
                        )->a( n = `width`         v = `100%`
                        )->a( n = `selectData`    v = client->_event( val   = `EVT_DATA_SELECT`
                                                                      t_arg = VALUE #( ( `${$parameters>/data/0/data/}` ) ) )

                        )->ele( n = `dataset` ns = `viz`
                            )->ele( n = `FlattenedDataset` ns = `viz.data`
                                )->a( n = `data` v = client->_bind( mt_data_chart )

                                )->ele( n = `dimensions` ns = `viz.data`
                                    )->tag( n = `DimensionDefinition` ns = `viz.data`
                                        )->a( n = `name`  v = `Week`
                                        )->a( n = `value` v = `{WEEK}`

                                )->end(

                                )->ele( n = `measures` ns = `viz.data`
                                    )->tag( n = `MeasureDefinition` ns = `viz.data`
                                        )->a( n = `name`  v = `Revenue`
                                        )->a( n = `value` v = `{REVENUE}`
                                    )->tag( n = `MeasureDefinition` ns = `viz.data`
                                        )->a( n = `name`  v = `Cost`
                                        )->a( n = `value` v = `{COST}`

                                )->end(
                            )->end(
                        )->end(

                        )->ele( n = `feeds` ns = `viz`
                            )->tag( n = `FeedItem` ns = `viz.feeds`
                                )->a( n = `id`     v = `valueAxisFeed`
                                )->a( n = `uid`    v = `valueAxis`
                                )->a( n = `type`   v = `Measure`
                                )->a( n = `values` v = client->_bind( mt_feed_values )
                            )->tag( n = `FeedItem` ns = `viz.feeds`
                                )->a( n = `id`     v = `categoryAxisFeed`
                                )->a( n = `uid`    v = `categoryAxis`
                                )->a( n = `type`   v = `Dimension`
                                )->a( n = `values` v = `Week` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
      on_rendering( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
