"! <p class="shorttext">sap.viz - ui5.controls.VizFrame</p>
"!
"! SAPUI5-only control: it ships with SAPUI5, not with OpenUI5, so there is no
"! demo kit original in this repo's sample universe and no 1:1 port (AGENTS §3).
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

    CASE client->get( )-event.
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

    DATA(lr_view) = z2ui5_cl_xml_view=>factory( )->shell( ).

    " ---------- Set dynamic page ---------------------------------------------------------------------
    DATA(lr_dyn_page) = lr_view->dynamic_page( showfooter = abap_false ).

    " ---------- Get header title ---------------------------------------------------------------------
    DATA(lr_header_title) = lr_dyn_page->title( ns = `f` )->get( )->dynamic_page_title( ).

    " ---------- Set header title text ----------------------------------------------------------------
    lr_header_title->heading( `f` )->title( `abap2UI5 - VizFrame Charts` ).

    " ---------- Get page header area ----------------------------------------------------------------
    DATA(lr_header) = lr_dyn_page->header( `f` )->dynamic_page_header( abap_true )->content( `f` ).

    lr_header->button( text    = `back`
                       press   = client->_event_nav_app_leave( )
                       visible = client->check_app_prev_stack( ) ).

    " ---------- Set Filter bar -----------------------------------------------------------------------
    DATA(lr_filter_bar) = lr_header->filter_bar( usetoolbar = `false` )->filter_group_items( ).

    " ---------- Set filter ---------------------------------------------------------------------------
    DATA(lr_filter) = lr_filter_bar->filter_group_item( name               = `VizFrameType`
                                                        label              = `VizFrame type`
                                                        groupname          = |GroupVizFrameType|
                                                        visibleinfilterbar = `true`
                                                         )->filter_control( ).

    " ---------- Set combo box input field ------------------------------------------------------------
    lr_filter->combobox( selectedkey   = client->_bind( ms_screen-viztypesel )
                         change        = client->_event( `EVT_VIZTYPE_CHANGE` )
                         showclearicon = abap_true
                         items         = client->_bind( mt_viztypes )
                              )->item( key  = `{N}`
                                       text = `{V}` ).

    " ---------- Get page content area ----------------------------------------------------------------
    DATA(lr_content) = lr_dyn_page->content( `f` ).

    " ---------- Set vizframe chart -------------------------------------------------------------------
    DATA(lr_vizframe) = lr_content->viz_frame(
                            id            = `idVizFrame`
                            vizproperties = mv_prop
                            viztype       = client->_bind( ms_screen-viztype )
                            height        = `500px`
                            width         = `100%`
                            selectdata    = client->_event( val   = `EVT_DATA_SELECT`
                                                            t_arg = VALUE #( ( `${$parameters>/data/0/data/}` ) ) ) ).

    " ---------- Set vizframe dataset -----------------------------------------------------------------
    DATA(lr_dataset) = lr_vizframe->viz_dataset( ).

    " ---------- Set vizframe flattened dataset --------------------------------------------------------
    DATA(lr_flatteneddataset) = lr_dataset->viz_flattened_dataset( client->_bind( mt_data_chart ) ).

    " ---------- Set vizframe dimensions ---------------------------------------------------------------
    DATA(lr_dimensions) = lr_flatteneddataset->viz_dimensions( ).

    " ---------- Set vizframe dimension ----------------------------------------------------------------
    lr_dimensions->viz_dimension_definition(
                                                                       name  = `Week`
                                                                       value = `{WEEK}` ).

    " ---------- Set vizframe measures ----------------------------------------------------------------
    DATA(lr_measures) = lr_flatteneddataset->viz_measures( ).

    " ---------- Set vizframe measure definition 1 ----------------------------------------------------
    lr_measures->viz_measure_definition(
                                                                  name  = `Revenue`
                                                                  value = `{REVENUE}` ).

    " ---------- Set vizframe measure definition 2 ----------------------------------------------------
    lr_measures->viz_measure_definition(
                                                                  name  = `Cost`
                                                                  value = `{COST}` ).

    " ---------- Set vizframe feeds -------------------------------------------------------------------
    DATA(lr_feeds) = lr_vizframe->viz_feeds( ).

    " ---------- Set vizframe feed for value axis -----------------------------------------------------
    lr_feeds->viz_feed_item( id     = `valueAxisFeed`
                                                      uid    = `valueAxis`
                                                      type   = `Measure`
                                                      values = client->_bind( mt_feed_values ) ).

    " ---------- Set vizframe feed for category axis --------------------------------------------------
    lr_feeds->viz_feed_item( id     = `categoryAxisFeed`
                                                      uid    = `categoryAxis`
                                                      type   = `Dimension`
                                                      values = `Week` ).

    client->view_display( lr_view->stringify( ) ).

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
