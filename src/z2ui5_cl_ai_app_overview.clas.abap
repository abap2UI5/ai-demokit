"! Generated overview app - lists every abap2UI5 api sample app in a table.
"! A Switch in the header toggles between the table and a module -> control ->
"! sample tree (sap.m.Tree, expanded by default) showing the same samples - both
"! views are bound and their visibility is an expression binding over the two-way
"! show_tree flag, so the toggle runs entirely on the client (no round-trip). The
"! search field filters the table on the client (binding_call Contains, no
"! round-trip); the tree is not filtered. Each tree leaf has the same jump
"! popover as the table's Open column.
"! The title carries the ported-app count in parentheses. There are two sortable
"! Since columns: the first (next to Control) shows the UI5 release the CONTROL
"! appeared in (from ui5/universe.json; blank when older than tracking / since
"! forever); the second (next to Sample) shows the direct release the whole SAMPLE
"! needs (control since raised by any kept post-1.71 member) and is shown only when
"! HIGHER than the control's own since. Both since values are coloured orange
"! (ObjectStatus Warning) when newer than UI5 1.71; a deprecated control's name is
"! struck through (FormattedText htmlText, so the strikethrough can vary per row).
"! The Version column badges rows whose control is not part of OpenUI5 with an
"! orange SAPUI5 status. Three header checkboxes (default all on) filter the table
"! entirely on the client via each row's visible expression: Hide non-OpenUI5,
"! Hide newer than 1.71 (2020), Hide deprecated. A Shell switch toggles the
"! sap.m.Shell letterboxing (appWidthLimited), a Tree view switch toggles table vs
"! tree - both client-side. Navigation lives in the trailing Open column, which
"! carries two buttons: the first opens an anchored popover with the four reference
"! links (OpenUI5 API, OpenUI5 source, live fullscreen sample, the generated ABAP
"! class on GitHub, each opening in a new tab) AND the port's generation info -
"! checked status, a post-1.71 note, and the generation notes; the second starts
"! this abap2UI5 app directly in a new tab (open_new_tab; the start URL is
"! same-origin). The same two buttons sit on every tree sample leaf (links only,
"! the tree model carries no info). The Rating column is a 1-5 "by feel" score of
"! how much attention a port deserves (not coloured): app complexity, how heavily
"! it was reworked/corrected (IMPROVISED/DROPPED_171/SUBSET_DATA/NOTE), whether it
"! was reviewed/discussed (it carries a checked block), and how important a live
"! re-test is (pending LIVE_TESTs, roundtrip-free wiring, popups, needs-newer-UI5);
"! 1 = simple faithful 1:1, 5 = complex/reworked/worth a close look. Sort it
"! descending to surface the samples worth a closer manual look. The Audit
"! column shows, always, one badge per framework-wiring fact the port uses (read
"! from its ABAP source): _event_client and its t_arg form, follow_up_action and
"! its t_arg form, whether it opens a Popup or Popover, and whether it binds a
"! path by literal name in clear text ({FIELD}/{/Path}) rather than via _bind.
"! The search field above the table filters all rows by a
"! substring over the text columns (module, control, since, sample, release,
"! class) only, and each sortable column header carries ascending/
"! descending sort icons - both run entirely on the frontend
"! (cs_event-binding_call via _event_client, no server round-trip). Do not edit
"! by hand - regenerate with scripts/generate-overview.mjs
CLASS z2ui5_cl_ai_app_overview DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_app,
        module    TYPE string,
        control   TYPE string,
        ctrl_name TYPE string,
        name      TYPE string,
        class     TYPE string,
        path      TYPE string,
        api_url   TYPE string,
        js_url    TYPE string,
        ui5_url   TYPE string,
        abap_url  TYPE string,
        start_url TYPE string,
        checked   TYPE string,
        has_check TYPE abap_bool,
        notes     TYPE string,
        has_notes TYPE abap_bool,
        post171   TYPE string,
        has_p171  TYPE abap_bool,
        since         TYPE string,
        since_post171 TYPE abap_bool,
        release       TYPE string,
        release_post171 TYPE abap_bool,
        ui5_only      TYPE abap_bool,
        is_post171    TYPE abap_bool,
        is_deprecated TYPE abap_bool,
        dep_text  TYPE string,
        ctrl_html TYPE string,
        score       TYPE i,
        score_tip   TYPE string,
        use_ec      TYPE abap_bool,
        use_ec_arg  TYPE abap_bool,
        use_fua     TYPE abap_bool,
        use_fua_arg TYPE abap_bool,
        use_popup   TYPE abap_bool,
        use_popover TYPE abap_bool,
        use_name    TYPE abap_bool,
        filter    TYPE string,
      END OF ty_s_app.
    TYPES ty_t_app TYPE STANDARD TABLE OF ty_s_app WITH EMPTY KEY.

    " nested tree model (module -> control -> sample); sap.m.Tree recurses on the
    " nodes tables. The sample leaves carry the same links as the table's Open column
    TYPES:
      BEGIN OF ty_s_sample,
        text      TYPE string,
        api_url   TYPE string,
        js_url    TYPE string,
        ui5_url   TYPE string,
        abap_url  TYPE string,
        start_url TYPE string,
        has_link  TYPE abap_bool,
      END OF ty_s_sample,
      BEGIN OF ty_s_control,
        text  TYPE string,
        nodes TYPE STANDARD TABLE OF ty_s_sample WITH EMPTY KEY,
      END OF ty_s_control,
      BEGIN OF ty_s_module,
        text  TYPE string,
        nodes TYPE STANDARD TABLE OF ty_s_control WITH EMPTY KEY,
      END OF ty_s_module.
    TYPES ty_t_tree TYPE STANDARD TABLE OF ty_s_module WITH EMPTY KEY.

    DATA t_app TYPE ty_t_app.
    DATA t_tree TYPE ty_t_tree.
    " table/tree toggle (drives the visible expression bindings)
    DATA show_tree TYPE abap_bool.
    " sap.m.Shell letterboxing toggle (two-way, drives Shell appWidthLimited)
    DATA shell_on  TYPE abap_bool.
    " header filter checkboxes (two-way; each row's visible expression binding
    " hides it when the matching flag is set and the row carries that trait)
    DATA hide_non_ui5   TYPE abap_bool.
    DATA hide_post171   TYPE abap_bool.
    DATA hide_deprecated TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS get_catalog
      RETURNING
        VALUE(result) TYPE ty_t_app.
    METHODS build_tree
      IMPORTING
        it_app        TYPE ty_t_app
      RETURNING
        VALUE(result) TYPE ty_t_tree.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_overview IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      " default filtering (all on) + Shell on, set once so later round-trips keep
      " whatever the user toggled (the flags are two-way bound)
      shell_on        = abap_true.
      hide_non_ui5    = abap_true.
      hide_post171    = abap_true.
      hide_deprecated = abap_true.
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `LINKS`.
        " the four reference links plus the port's generation info (checked /
        " post-1.71 / notes) for the pressed row; resolved client-side and passed
        " via t_arg, opened in a popover anchored to the pressed button (arg 8)
        DATA(lv_api)     = client->get_event_arg( ).
        DATA(lv_js)      = client->get_event_arg( 2 ).
        DATA(lv_ui5)     = client->get_event_arg( 3 ).
        DATA(lv_abap)    = client->get_event_arg( 4 ).
        DATA(lv_checked) = client->get_event_arg( 5 ).
        DATA(lv_post171) = client->get_event_arg( 6 ).
        DATA(lv_notes)   = client->get_event_arg( 7 ).

        DATA(links) = z2ui5_cl_ai_xml=>factory( ).
        DATA(box) = links->open( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`

            )->open( `Popover`
                )->a( n = `title`        v = `Links & info`
                )->a( n = `placement`    v = `Auto`
                )->a( n = `contentWidth` v = `26rem`

                )->open( `VBox`
                    )->a( n = `class` v = `sapUiContentPadding` ).

        box->leaf( `Link`
            )->a( n = `text`   v = `Control - OpenUI5 API reference`
            )->a( n = `href`   v = lv_api
            )->a( n = `target` v = `_blank`
            )->a( n = `class`  v = `sapUiTinyMarginBottom` ).
        box->leaf( `Link`
            )->a( n = `text`   v = `Sample - OpenUI5 source`
            )->a( n = `href`   v = lv_js
            )->a( n = `target` v = `_blank`
            )->a( n = `class`  v = `sapUiTinyMarginBottom` ).
        box->leaf( `Link`
            )->a( n = `text`   v = `Sample - live fullscreen runner`
            )->a( n = `href`   v = lv_ui5
            )->a( n = `target` v = `_blank`
            )->a( n = `class`  v = `sapUiTinyMarginBottom` ).
        box->leaf( `Link`
            )->a( n = `text`   v = `abap2UI5 - class on GitHub`
            )->a( n = `href`   v = lv_abap
            )->a( n = `target` v = `_blank` ).

        IF lv_checked IS NOT INITIAL.
          box->leaf( `ObjectStatus`
              )->a( n = `text`  v = lv_checked
              )->a( n = `state` v = `Success`
              )->a( n = `class` v = `sapUiSmallMarginTop` ).
        ENDIF.

        IF lv_post171 IS NOT INITIAL.
          box->leaf( `ObjectStatus`
              )->a( n = `text`  v = |Needs a UI5 release newer than 1.71: { lv_post171 }|
              )->a( n = `state` v = `Warning`
              )->a( n = `class` v = `sapUiTinyMarginTop` ).
        ENDIF.

        IF lv_notes IS NOT INITIAL.
          box->leaf( `Title`
              )->a( n = `text`  v = `Generation notes`
              )->a( n = `level` v = `H5`
              )->a( n = `class` v = `sapUiSmallMarginTop` ).
          " render the notes as an HTML bullet list (FormattedText): each
          " ` // `-separated bullet becomes one <li> with its leading LABEL
          " (NOTE / IMPROVISED / POST-1.71 / ...) in bold. The note text is
          " HTML-escaped first (it can contain <, >, & - e.g. id="x", a<b, or a
          " literal <strong> mention); the builder's xml_escape escapes it a
          " second time and UI5 un-escapes once, so FormattedText shows it verbatim.
          SPLIT lv_notes AT ` // ` INTO TABLE DATA(lt_line).
          DATA(lv_html) = `<ul>`.
          LOOP AT lt_line INTO DATA(lv_line).
            DATA(lv_esc) = lv_line.
            REPLACE ALL OCCURRENCES OF `&` IN lv_esc WITH `&amp;`.
            REPLACE ALL OCCURRENCES OF `<` IN lv_esc WITH `&lt;`.
            REPLACE ALL OCCURRENCES OF `>` IN lv_esc WITH `&gt;`.
            DATA(lv_col) = find( val = lv_esc sub = `:` ).
            IF lv_col > 0.
              lv_html = |{ lv_html }<li><strong>{ substring( val = lv_esc len = lv_col + 1 ) }</strong>{ substring( val = lv_esc off = lv_col + 1 ) }</li>|.
            ELSE.
              lv_html = |{ lv_html }<li>{ lv_esc }</li>|.
            ENDIF.
          ENDLOOP.
          lv_html = |{ lv_html }</ul>|.
          box->leaf( `FormattedText`
              )->a( n = `htmlText` v = lv_html ).
        ENDIF.

        client->popover_display( xml   = links->stringify( )
                                 by_id = client->get_event_arg( 8 ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    " base url to launch an abap2UI5 app in a new browser tab
    DATA(start) = |{ client->get( )-s_config-origin }{ client->get( )-s_config-pathname }?app_start=|.

    t_app = get_catalog( ).
    LOOP AT t_app ASSIGNING FIELD-SYMBOL(<app>).

      DATA(libpath) = replace( val = <app>-module
                               sub = `.`
                               with = `/`
                               occ = 0 ).

      " display only the bare control, without its namespace (sap.f.GridList -> GridList)
      DATA(dot) = find( val = <app>-control sub = `.` occ = -1 ).
      <app>-ctrl_name = COND #( WHEN dot >= 0 THEN substring( val = <app>-control off = dot + 1 ) ELSE <app>-control ).

      <app>-api_url   = |https://sdk.openui5.org/api/{ <app>-control }|.
      <app>-js_url    = |https://github.com/SAP/openui5/tree/master/src/{ <app>-module }| &&
                        |/test/{ libpath }/demokit/sample/{ <app>-name }|.
      <app>-ui5_url   = |https://sdk.openui5.org/resources/sap/ui/documentation/sdk/index.html| &&
                        |?sap-ui-xx-sample-id={ <app>-module }.sample.{ <app>-name }| &&
                        |&sap-ui-xx-sample-lib={ <app>-module }|.
      <app>-abap_url  = |https://github.com/abap2UI5/api/blob/main/{ <app>-path }|.
      <app>-start_url = |{ start }{ to_upper( <app>-class ) }|.
      <app>-has_check = xsdbool( <app>-checked IS NOT INITIAL ).
      <app>-has_notes = xsdbool( <app>-notes IS NOT INITIAL ).
      <app>-has_p171  = xsdbool( <app>-post171 IS NOT INITIAL ).

      " control name: struck through when the control is deprecated, otherwise
      " plain - never coloured (carried as FormattedText htmlText so the
      " strikethrough can vary per row); a plain control is rendered as-is
      <app>-ctrl_html = COND string(
          WHEN <app>-dep_text IS NOT INITIAL
          THEN |<span style="text-decoration:line-through">{ <app>-ctrl_name }</span>|
          ELSE <app>-ctrl_name ).

      " one blob per row, bound as the FILTER column that the table search's
      " client-side Contains filter (binding_call) matches against. Only the
      " VISIBLE text columns feed it - Module, Control (bare name), Since,
      " Sample, Release, abap2UI5 (class) - so a query like "Date" no longer
      " matches hidden text buried in the notes/checked/post-1.71 fields
      <app>-filter = <app>-module && ` ` && <app>-ctrl_name && ` ` &&
                     <app>-since  && ` ` && <app>-name      && ` ` &&
                     <app>-release && ` ` && <app>-class.

    ENDLOOP.

    " the tree lists the full, unfiltered catalog (search filters only the table)
    t_tree = build_tree( t_app ).

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( `Shell`
            " Shell on/off = letterboxing (limited app width); two-way bound so the
            " header Switch toggles it live on the client
            )->a( n = `appWidthLimited` v = |\{= !!${ client->_bind( shell_on ) } \}|
            )->open( `Page`
                )->a( n = `title`          v = |abap2UI5 Demo Kit ({ lines( t_app ) })|
                )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
                )->a( n = `showNavButton`  v = z2ui5_cl_ai_xml=>as_bool( client->check_app_prev_stack( ) )

                )->open( `subHeader`
                    )->open( `OverflowToolbar`
                        " client-side filter over the table only: liveChange/search run
                        " a binding_call Contains filter via _event_client (no round-trip);
                        " the tree is intentionally left unfiltered
                        )->leaf( `SearchField`
                            )->a( n = `placeholder` v = `Search the table - module, control, since, sample, class`
                            )->a( n = `width`       v = `24rem`
                            " disabled while the tree is shown (search filters only the table)
                            )->a( n = `enabled`     v = |\{= !${ client->_bind( show_tree ) } \}|
                            )->a( n = `liveChange`  v = client->_event_client( val = client->cs_event-binding_call t_arg = VALUE #( ( `idOverviewTable` ) ( `items` ) ( `filter` ) ( `FILTER` ) ( `Contains` ) ( `${$parameters>/newValue}` ) ) )
                            )->a( n = `search`      v = client->_event_client( val = client->cs_event-binding_call t_arg = VALUE #( ( `idOverviewTable` ) ( `items` ) ( `filter` ) ( `FILTER` ) ( `Contains` ) ( `${$parameters>/query}` ) ) )
                        " default-on filter checkboxes; each is two-way bound and the row
                        " visible expression reacts live (no round-trip). Disabled while the
                        " tree is shown (the filters act on the table only)
                        )->leaf( `CheckBox`
                            )->a( n = `text`     v = `Hide non-OpenUI5`
                            )->a( n = `selected` v = client->_bind( hide_non_ui5 )
                            )->a( n = `enabled`  v = |\{= !${ client->_bind( show_tree ) } \}|
                            )->a( n = `tooltip`  v = `Hide samples whose control is not part of OpenUI5`
                        )->leaf( `CheckBox`
                            )->a( n = `text`     v = `Hide newer than 1.71 (2020)`
                            )->a( n = `selected` v = client->_bind( hide_post171 )
                            )->a( n = `enabled`  v = |\{= !${ client->_bind( show_tree ) } \}|
                            )->a( n = `tooltip`  v = `Hide samples that need a UI5 release newer than 1.71`
                        )->leaf( `CheckBox`
                            )->a( n = `text`     v = `Hide deprecated`
                            )->a( n = `selected` v = client->_bind( hide_deprecated )
                            )->a( n = `enabled`  v = |\{= !${ client->_bind( show_tree ) } \}|
                            )->a( n = `tooltip`  v = `Hide samples whose control is deprecated`
                        )->leaf( `ToolbarSpacer`
                        )->leaf( `Label`
                            )->a( n = `text` v = `Shell`
                        " Shell on/off = sap.m.Shell letterboxing (two-way, drives appWidthLimited)
                        )->leaf( `Switch`
                            )->a( n = `state`   v = client->_bind( shell_on )
                            )->a( n = `tooltip` v = `Toggle the Shell letterboxing (limited app width)`
                        )->leaf( `Label`
                            )->a( n = `text` v = `Tree view`
                        " Switch toggles table vs tree entirely on the client (two-way
                        " bound show_tree drives both views' visible expression bindings)
                        )->leaf( `Switch`
                            )->a( n = `state`   v = client->_bind( show_tree )
                            )->a( n = `tooltip` v = `Switch between the table and a module -> control -> sample tree`

                    )->shut(
                )->shut(

                )->open( `Table`
                    )->a( n = `id`      v = `idOverviewTable`
                    )->a( n = `sticky`  v = `ColumnHeaders`
                    )->a( n = `visible` v = |\{= !${ client->_bind( show_tree ) } \}|
                    )->a( n = `items`   v = client->_bind( t_app )

                    )->open( `columns`
                        )->open( `Column`
                            )->open( `HBox`
                                )->a( n = `alignItems` v = `Center`

                                )->leaf( `Text`
                                    )->a( n = `text` v = `Module`
                                )->leaf( `core:Icon`
                                    )->a( n = `src`     v = `sap-icon://sort-ascending`
                                    )->a( n = `tooltip` v = `Sort by Module ascending`
                                    )->a( n = `class`   v = `sapUiTinyMarginBegin`
                                    )->a( n = `press`   v = client->_event_client( val = client->cs_event-binding_call t_arg = VALUE #( ( `idOverviewTable` ) ( `items` ) ( `sort` ) ( `MODULE` ) ) )
                                )->leaf( `core:Icon`
                                    )->a( n = `src`     v = `sap-icon://sort-descending`
                                    )->a( n = `tooltip` v = `Sort by Module descending`
                                    )->a( n = `press`   v = client->_event_client( val = client->cs_event-binding_call t_arg = VALUE #( ( `idOverviewTable` ) ( `items` ) ( `sort` ) ( `MODULE` ) ( `X` ) ) )

                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->open( `HBox`
                                )->a( n = `alignItems` v = `Center`

                                )->leaf( `Text`
                                    )->a( n = `text` v = `Control`
                                )->leaf( `core:Icon`
                                    )->a( n = `src`     v = `sap-icon://sort-ascending`
                                    )->a( n = `tooltip` v = `Sort by Control ascending`
                                    )->a( n = `class`   v = `sapUiTinyMarginBegin`
                                    )->a( n = `press`   v = client->_event_client( val = client->cs_event-binding_call t_arg = VALUE #( ( `idOverviewTable` ) ( `items` ) ( `sort` ) ( `CTRL_NAME` ) ) )
                                )->leaf( `core:Icon`
                                    )->a( n = `src`     v = `sap-icon://sort-descending`
                                    )->a( n = `tooltip` v = `Sort by Control descending`
                                    )->a( n = `press`   v = client->_event_client( val = client->cs_event-binding_call t_arg = VALUE #( ( `idOverviewTable` ) ( `items` ) ( `sort` ) ( `CTRL_NAME` ) ( `X` ) ) )

                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->open( `HBox`
                                )->a( n = `alignItems` v = `Center`

                                )->leaf( `Text`
                                    )->a( n = `text` v = `Since`
                                )->leaf( `core:Icon`
                                    )->a( n = `src`     v = `sap-icon://sort-ascending`
                                    )->a( n = `tooltip` v = `Sort by Since ascending`
                                    )->a( n = `class`   v = `sapUiTinyMarginBegin`
                                    )->a( n = `press`   v = client->_event_client( val = client->cs_event-binding_call t_arg = VALUE #( ( `idOverviewTable` ) ( `items` ) ( `sort` ) ( `SINCE` ) ) )
                                )->leaf( `core:Icon`
                                    )->a( n = `src`     v = `sap-icon://sort-descending`
                                    )->a( n = `tooltip` v = `Sort by Since descending`
                                    )->a( n = `press`   v = client->_event_client( val = client->cs_event-binding_call t_arg = VALUE #( ( `idOverviewTable` ) ( `items` ) ( `sort` ) ( `SINCE` ) ( `X` ) ) )

                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->open( `HBox`
                                )->a( n = `alignItems` v = `Center`

                                )->leaf( `Text`
                                    )->a( n = `text` v = `Sample`
                                )->leaf( `core:Icon`
                                    )->a( n = `src`     v = `sap-icon://sort-ascending`
                                    )->a( n = `tooltip` v = `Sort by Sample ascending`
                                    )->a( n = `class`   v = `sapUiTinyMarginBegin`
                                    )->a( n = `press`   v = client->_event_client( val = client->cs_event-binding_call t_arg = VALUE #( ( `idOverviewTable` ) ( `items` ) ( `sort` ) ( `NAME` ) ) )
                                )->leaf( `core:Icon`
                                    )->a( n = `src`     v = `sap-icon://sort-descending`
                                    )->a( n = `tooltip` v = `Sort by Sample descending`
                                    )->a( n = `press`   v = client->_event_client( val = client->cs_event-binding_call t_arg = VALUE #( ( `idOverviewTable` ) ( `items` ) ( `sort` ) ( `NAME` ) ( `X` ) ) )

                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->open( `HBox`
                                )->a( n = `alignItems` v = `Center`

                                )->leaf( `Text`
                                    )->a( n = `text` v = `Since`
                                )->leaf( `core:Icon`
                                    )->a( n = `src`     v = `sap-icon://sort-ascending`
                                    )->a( n = `tooltip` v = `Sort by Since ascending`
                                    )->a( n = `class`   v = `sapUiTinyMarginBegin`
                                    )->a( n = `press`   v = client->_event_client( val = client->cs_event-binding_call t_arg = VALUE #( ( `idOverviewTable` ) ( `items` ) ( `sort` ) ( `RELEASE` ) ) )
                                )->leaf( `core:Icon`
                                    )->a( n = `src`     v = `sap-icon://sort-descending`
                                    )->a( n = `tooltip` v = `Sort by Since descending`
                                    )->a( n = `press`   v = client->_event_client( val = client->cs_event-binding_call t_arg = VALUE #( ( `idOverviewTable` ) ( `items` ) ( `sort` ) ( `RELEASE` ) ( `X` ) ) )

                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->open( `HBox`
                                )->a( n = `alignItems` v = `Center`

                                )->leaf( `Text`
                                    )->a( n = `text` v = `abap2UI5`
                                )->leaf( `core:Icon`
                                    )->a( n = `src`     v = `sap-icon://sort-ascending`
                                    )->a( n = `tooltip` v = `Sort by abap2UI5 ascending`
                                    )->a( n = `class`   v = `sapUiTinyMarginBegin`
                                    )->a( n = `press`   v = client->_event_client( val = client->cs_event-binding_call t_arg = VALUE #( ( `idOverviewTable` ) ( `items` ) ( `sort` ) ( `CLASS` ) ) )
                                )->leaf( `core:Icon`
                                    )->a( n = `src`     v = `sap-icon://sort-descending`
                                    )->a( n = `tooltip` v = `Sort by abap2UI5 descending`
                                    )->a( n = `press`   v = client->_event_client( val = client->cs_event-binding_call t_arg = VALUE #( ( `idOverviewTable` ) ( `items` ) ( `sort` ) ( `CLASS` ) ( `X` ) ) )

                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->a( n = `width` v = `6rem`
                            )->a( n = `hAlign` v = `Center`

                            )->leaf( `Text`
                                )->a( n = `text` v = `Version`

                        )->shut(
                        )->open( `Column`
                            )->open( `HBox`
                                )->a( n = `alignItems` v = `Center`

                                )->leaf( `Text`
                                    )->a( n = `text` v = `Rating`
                                )->leaf( `core:Icon`
                                    )->a( n = `src`     v = `sap-icon://sort-ascending`
                                    )->a( n = `tooltip` v = `Sort by Rating ascending`
                                    )->a( n = `class`   v = `sapUiTinyMarginBegin`
                                    )->a( n = `press`   v = client->_event_client( val = client->cs_event-binding_call t_arg = VALUE #( ( `idOverviewTable` ) ( `items` ) ( `sort` ) ( `SCORE` ) ) )
                                )->leaf( `core:Icon`
                                    )->a( n = `src`     v = `sap-icon://sort-descending`
                                    )->a( n = `tooltip` v = `Sort by Rating descending`
                                    )->a( n = `press`   v = client->_event_client( val = client->cs_event-binding_call t_arg = VALUE #( ( `idOverviewTable` ) ( `items` ) ( `sort` ) ( `SCORE` ) ( `X` ) ) )

                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->a( n = `width` v = `15rem`

                            )->leaf( `Text`
                                )->a( n = `text` v = `Audit`

                        )->shut(
                        )->open( `Column`
                            )->a( n = `width` v = `7rem`
                            )->a( n = `hAlign` v = `Center`

                            )->leaf( `Text`
                                )->a( n = `text` v = `Open`

                        )->shut(
                    )->shut(

                    )->open( `items`
                        )->open( `ColumnListItem`
                            " header checkboxes filter the table entirely on the client: a
                            " row is hidden when a hide-flag (two-way bound model-root) is set
                            " AND the row carries that trait (UI5_ONLY / IS_POST171 /
                            " IS_DEPRECATED). Expression binding, re-evaluated live on toggle,
                            " no round-trip - like the tree/table Switch.
                            )->a( n = `visible` v = |\{= !(${ client->_bind( hide_non_ui5 ) } && $\{UI5_ONLY\}) && !(${ client->_bind( hide_post171 ) } && $\{IS_POST171\}) && !(${ client->_bind( hide_deprecated ) } && $\{IS_DEPRECATED\}) \}|
                            )->open( `cells`
                                )->leaf( `Text`
                                    )->a( n = `text` v = `{MODULE}`
                                " control name, struck through when deprecated (never
                                " coloured); FormattedText so the strikethrough can vary per row
                                )->leaf( `FormattedText`
                                    )->a( n = `htmlText` v = `{CTRL_HTML}`
                                    )->a( n = `tooltip`  v = `{DEP_TEXT}`
                                " Since: the release the control appeared in; coloured orange
                                " (Warning) when it is newer than UI5 1.71
                                )->leaf( `ObjectStatus`
                                    )->a( n = `text`    v = `{SINCE}`
                                    )->a( n = `state`   v = |\{= $\{SINCE_POST171\} ? 'Warning' : 'None' \}|
                                    )->a( n = `tooltip` v = `{DEP_TEXT}`
                                )->leaf( `Text`
                                    )->a( n = `text` v = `{NAME}`
                                " second Since: the direct UI5 release the whole sample needs,
                                " shown only when higher than the control's own since; same
                                " orange-when-newer-than-1.71 colouring
                                )->leaf( `ObjectStatus`
                                    )->a( n = `text`  v = `{RELEASE}`
                                    )->a( n = `state` v = |\{= $\{RELEASE_POST171\} ? 'Warning' : 'None' \}|
                                )->leaf( `Text`
                                    )->a( n = `text` v = `{CLASS}`
                                " Version: the control does not exist in OpenUI5 (SAPUI5- /
                                " demo-kit-only); an orange SAPUI5 badge only on those rows
                                )->leaf( `ObjectStatus`
                                    )->a( n = `text`    v = `SAPUI5`
                                    )->a( n = `state`   v = `Warning`
                                    )->a( n = `tooltip` v = `This control is not part of OpenUI5 - it cannot render on an OpenUI5 stack`
                                    )->a( n = `visible` v = `{UI5_ONLY}`
                                " rating 1-5 (by feel): how much attention the port
                                " deserves - complexity, rework, review, test-priority
                                " (not coloured); tooltip lists the drivers
                                )->leaf( `Text`
                                    )->a( n = `text`    v = `{SCORE} / 5`
                                    )->a( n = `tooltip` v = `{SCORE_TIP}`

                                " audit column: one badge per framework-wiring fact the
                                " port uses (read from its ABAP source at generation time),
                                " always shown so the table shows at a glance which apps use
                                " _event_client / follow_up_action (and their t_arg form),
                                " open a Popup or Popover, or bind a path by literal name
                                )->open( `HBox`
                                    )->a( n = `wrap`       v = `Wrap`
                                    )->a( n = `alignItems` v = `Center`

                                    )->leaf( `ObjectStatus`
                                        )->a( n = `text`    v = `_event_client`
                                        )->a( n = `state`   v = `Information`
                                        )->a( n = `tooltip` v = `Uses _event_client - a roundtrip-free client event wired directly in the view`
                                        )->a( n = `visible` v = `{USE_EC}`
                                        )->a( n = `class`   v = `sapUiTinyMarginEnd`
                                    )->leaf( `ObjectStatus`
                                        )->a( n = `text`    v = `_event_client t_arg`
                                        )->a( n = `state`   v = `Information`
                                        )->a( n = `tooltip` v = `Uses _event_client with t_arg (passes positional arguments to the client event)`
                                        )->a( n = `visible` v = `{USE_EC_ARG}`
                                        )->a( n = `class`   v = `sapUiTinyMarginEnd`
                                    )->leaf( `ObjectStatus`
                                        )->a( n = `text`    v = `follow_up_action`
                                        )->a( n = `state`   v = `Success`
                                        )->a( n = `tooltip` v = `Uses follow_up_action - a frontend action scheduled after the backend response`
                                        )->a( n = `visible` v = `{USE_FUA}`
                                        )->a( n = `class`   v = `sapUiTinyMarginEnd`
                                    )->leaf( `ObjectStatus`
                                        )->a( n = `text`    v = `follow_up_action t_arg`
                                        )->a( n = `state`   v = `Success`
                                        )->a( n = `tooltip` v = `Uses follow_up_action with t_arg (passes positional arguments to the follow-up action)`
                                        )->a( n = `visible` v = `{USE_FUA_ARG}`
                                        )->a( n = `class`   v = `sapUiTinyMarginEnd`
                                    )->leaf( `ObjectStatus`
                                        )->a( n = `text`    v = `Popup`
                                        )->a( n = `state`   v = `Warning`
                                        )->a( n = `tooltip` v = `Opens a Popup (popup_display)`
                                        )->a( n = `visible` v = `{USE_POPUP}`
                                        )->a( n = `class`   v = `sapUiTinyMarginEnd`
                                    )->leaf( `ObjectStatus`
                                        )->a( n = `text`    v = `Popover`
                                        )->a( n = `state`   v = `Warning`
                                        )->a( n = `tooltip` v = `Opens a Popover (popover_display)`
                                        )->a( n = `visible` v = `{USE_POPOVER}`
                                        )->a( n = `class`   v = `sapUiTinyMarginEnd`
                                    )->leaf( `ObjectStatus`
                                        )->a( n = `text`    v = `literal binding`
                                        )->a( n = `state`   v = `Error`
                                        )->a( n = `tooltip` v = `Binds a path by literal name in clear text ({FIELD} or {/Path}) instead of via client->_bind - breaks on a variable rename`
                                        )->a( n = `visible` v = `{USE_NAME}`
                                        )->a( n = `class`   v = `sapUiTinyMarginEnd`

                                )->shut(
                                " Open column: two buttons. First opens an anchored popover with
                                " the reference links AND the port's generation info (checked,
                                " post-1.71, notes) - the pressed button's runtime id
                                " ($event.oSource.sId) anchors it; second launches the abap2UI5
                                " app directly in a new tab (open_new_tab - the start URL is
                                " same-origin, so it passes isValidRedirectURL)
                                )->open( `HBox`
                                    )->leaf( `Button`
                                        )->a( n = `icon`    v = `sap-icon://chain-link`
                                        )->a( n = `type`    v = `Transparent`
                                        )->a( n = `tooltip` v = `Reference links & info: OpenUI5 API, source, live sample, ABAP class, generation notes`
                                        )->a( n = `press`   v = client->_event( val = `LINKS` t_arg = VALUE #(
                                            ( `${API_URL}` ) ( `${JS_URL}` ) ( `${UI5_URL}` ) ( `${ABAP_URL}` )
                                            ( `${CHECKED}` ) ( `${POST171}` ) ( `${NOTES}` ) ( `$event.oSource.sId` ) ) )
                                    )->leaf( `Button`
                                        )->a( n = `icon`    v = `sap-icon://action`
                                        )->a( n = `type`    v = `Transparent`
                                        )->a( n = `tooltip` v = `Start this abap2UI5 app in a new tab`
                                        )->a( n = `press`   v = client->_event_client( val = client->cs_event-open_new_tab t_arg = VALUE #( ( `${START_URL}` ) ) )

                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(

                " tree view (module -> control -> sample) - shown instead of the
                " table when the header Switch is on (client-side visible binding);
                " numberOfExpandedLevels expands every level by default; sibling of
                " the Table under the Page (NOT nested in the Table's items)
                )->open( `Tree`
                        )->a( n = `id`      v = `idOverviewTree`
                        )->a( n = `visible` v = |\{= ${ client->_bind( show_tree ) } \}|
                        )->a( n = `items`   v = |\{ path: '{ client->_bind( val = t_tree path = abap_true ) }', parameters: \{ numberOfExpandedLevels: 10 \} \}|

                        " expand-all / collapse-all act on the tree by id, client-side
                        )->open( `headerToolbar`
                            )->open( `Toolbar`
                                )->leaf( `Button`
                                    )->a( n = `text`  v = `Expand all`
                                    )->a( n = `icon`  v = `sap-icon://expand-group`
                                    )->a( n = `press` v = client->_event_client( val = client->cs_event-control_by_id t_arg = VALUE #( ( `idOverviewTree` ) ( `expandToLevel` ) ( `10` ) ) )
                                )->leaf( `Button`
                                    )->a( n = `text`  v = `Collapse all`
                                    )->a( n = `icon`  v = `sap-icon://collapse-group`
                                    )->a( n = `press` v = client->_event_client( val = client->cs_event-control_by_id t_arg = VALUE #( ( `idOverviewTree` ) ( `collapseAll` ) ) )

                            )->shut(
                        )->shut(

                        )->open( `CustomTreeItem`
                            )->open( `HBox`
                                )->a( n = `alignItems` v = `Center`

                                )->leaf( `Text`
                                    )->a( n = `text` v = `{TEXT}`
                                " same two buttons as the table's Open column - only on sample
                                " leaves: the reference-links popover, then the direct app launch.
                                " The tree model carries no notes/checked, so the info args are
                                " empty (the popover then just shows the four links).
                                )->leaf( `Button`
                                    )->a( n = `icon`    v = `sap-icon://chain-link`
                                    )->a( n = `type`    v = `Transparent`
                                    )->a( n = `tooltip` v = `Reference links: OpenUI5 API, source, live sample, ABAP class`
                                    )->a( n = `class`   v = `sapUiTinyMarginBegin`
                                    )->a( n = `visible` v = `{HAS_LINK}`
                                    )->a( n = `press`   v = client->_event( val = `LINKS` t_arg = VALUE #( ( `${API_URL}` ) ( `${JS_URL}` ) ( `${UI5_URL}` ) ( `${ABAP_URL}` ) ( `` ) ( `` ) ( `` ) ( `$event.oSource.sId` ) ) )
                                )->leaf( `Button`
                                    )->a( n = `icon`    v = `sap-icon://action`
                                    )->a( n = `type`    v = `Transparent`
                                    )->a( n = `tooltip` v = `Start this abap2UI5 app in a new tab`
                                    )->a( n = `visible` v = `{HAS_LINK}`
                                    )->a( n = `press`   v = client->_event_client( val = client->cs_event-open_new_tab t_arg = VALUE #( ( `${START_URL}` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD get_catalog.

    result = VALUE #(
      ( module = `sap.f`              control = `sap.f.Card`                          name = `Card`                                class = `z2ui5_cl_ai_app_117` path = `src/04/b01/z2ui5_cl_ai_app_117.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `IMPROVISED: Breadth-probe: sap.f.Card with a sap.f.cards.Header and a simplified content body (the original's named-model From/To ComboBoxes + DatePicker are represented by a Text + Button for the` &&
                 ` render probe).` )
      ( module = `sap.f`              control = `sap.f.DynamicPage`                   name = `DynamicPageFreeStyle`                class = `z2ui5_cl_ai_app_170` path = `src/04/b07/z2ui5_cl_ai_app_170.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `IMPROVISED: The controller's Card popover (onPressOpenPopover, wired to the GenericTag press and the 'Button with layoutData' press) is dropped: it Fragment.loads Card.fragment.xml (a Popover >` &&
                 ` sap.f.Card > sap.f.cards.NumericHeader with two NumericSideIndicators) and opens it by the pressed control. This is a controller-built popup fragment with no view-declared equivalent; the` &&
                 ` GenericTag.press attribute is therefore also dropped. sap.f.Card / NumericHeader are already covered by app 117 (sap.f.sample.Card), so no coverage is lost. Accounts for the structural-diff 'control` &&
                 ` missing' on Popover / f:Card / card:NumericHeader / card:NumericSideIndicator and 'attr missing' GenericTag.press. // IMPROVISED: The Edit button's press='.toggleAreaPriority' is dropped. The handler` &&
                 ` flips the DynamicPageTitle.areaShrinkRatio between its default and '1.6:1:1.6' - an imperative title-layout tweak with no bindable path (areaShrinkRatio is settable but the toggle reads the metadata` &&
                 ` default at runtime); cosmetic, no data impact. // NOTE: showFooter is two-way bound to a model flag ({/SHOWFOOTER}, default false) and the 'Toggle Footer' button flips it via a TOGGLE_FOOTER` &&
                 ` round-trip + re-render; the original toggles it imperatively (setShowFooter). headerExpanded and toggleHeaderOnTitleClick are likewise bound to model flags (both default true) - the original binds` &&
                 ` {/headerExpanded}/{/titleClickable} against a model that never sets them, so they fall back to the control defaults, reproduced here explicitly. // NOTE: The shared 123-row demo ProductCollection` &&
                 ` (sap/ui/demo/mock/products.json) is inlined with the columns the table binds (Name, ProductId, SupplierName, Width, Depth, Height, DimUnit, Price, CurrencyCode). The Price/CurrencyCode Currency` &&
                 ` composite type binding and the items sorter (path 'Name') are kept 1:1 as raw binding-info strings.`
        use_name = abap_true )
      ( module = `sap.f`              control = `sap.f.GridContainer`                 name = `GridContainer`                       class = `z2ui5_cl_ai_app_168` path = `src/04/b07/z2ui5_cl_ai_app_168.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `IMPROVISED: The original binds two named models inside the cards (cities> for the ComboBoxes, products> for the revenue List); abap2UI5 keeps one default model, so those bind directly` &&
                 ` ({cities>/cities} -> {/CITIES}, {products>/productItems} -> {/PRODUCTITEMS}, prefix dropped, last segment identical). The RevealGrid toggle, the three property Switches, the GridContainer` &&
                 ` columnsChange, the GenericTile press and the f:Card header press are controller handlers in the original; here each raises a client MESSAGE_TOAST. // NOTE: The ComboBox items keep a plain {/CITIES}` &&
                 ` binding (the original's sorter:{path:'text'} is a client-only ordering, dropped). The sap.ui.integration Card keeps its original external manifest reference (cardManifest.json). The two long` &&
                 ` lorem-ipsum filler Texts are abbreviated to short placeholders. cities.json (7) and products.json (3) are inlined in full.`
        use_ec = abap_true
        use_ec_arg = abap_true
        use_name = abap_true )
      ( module = `sap.f`              control = `sap.f.GridList`                      name = `GridListBasic`                       class = `z2ui5_cl_ai_app_111` path = `src/04/b01/z2ui5_cl_ai_app_111.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: The Slider drives the panel width via a roundtrip-free expression binding ({= ${slider} + '%' }) over the two-way slider value, instead of the original onSliderMoved setWidth handler;` &&
                 ` Slider.liveChange is therefore not wired (the width tracks the slider client-side). The full 27-row item set is inlined.`
        use_name = abap_true )
      ( module = `sap.f`              control = `sap.f.GridList`                      name = `GridListBoxContainer`                class = `z2ui5_cl_ai_app_144` path = `src/04/b04/z2ui5_cl_ai_app_144.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `LIVE-TEST: The Slider liveChange recomputes the host Panel.width (bound) as value + '%' server-side; the original set byId('panelForGridList').setWidth imperatively. Slider.value carries a binding to` &&
                 ` carry the value back. // NOTE: GridList with a grid:GridBoxLayout (boxMinWidth 17rem) and a GridListItem template (VBox + FlexItemData, Title, Label). The 27 items are inlined from model/items.json;` &&
                 ` the template binds {TITLE}/{SUBTITLE} 1:1.`
        use_name = abap_true )
      ( module = `sap.f`              control = `sap.f.GridList`                      name = `GridListDragAndDrop`                 class = `z2ui5_cl_ai_app_148` path = `src/04/b05/z2ui5_cl_ai_app_148.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `LIVE-TEST: The dragDropConfig (dnd:DragInfo + GridDropInfo) reorders items on drop; the drop event is wired to a backend event but the reorder logic (splice + setProperty) is not reproduced. The` &&
                 ` GridDropInfo control from sap.f.dnd keeps a hyphen-free 'dndgrid' xmlns alias instead of the original 'dnd-grid' (the alias only names the same sap.f.dnd URI; it makes the control statically visible` &&
                 ` to the checks). // NOTE: 27 items inlined from model/data.json; absent enum fields defaulted (highlight None, type Inactive) so the bound GridListItem properties stay valid. Template binds` &&
                 ` counter/highlight/type/unread + title/subtitle 1:1.`
        use_name = abap_true )
      ( module = `sap.f`              control = `sap.f.GridList`                      name = `GridListModes`                       class = `z2ui5_cl_ai_app_133` path = `src/04/b02/z2ui5_cl_ai_app_133.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `LIVE-TEST: SegmentedButton.selectionChange reproduces onModeChange server-side: GridList.mode is two-way bound to the same field as SegmentedButton.selectedKey and the headerText (bound) is recomputed` &&
                 ` as 'GridList with mode ' + key on a backend round-trip. The GridList delete / selectionChange and the GridListItem press / detailPress are wired to client-side MessageToasts (the original toasted the` &&
                 ` affected item's runtime id). mode/headerText/selectedKey carry bindings the original set statically. // NOTE: The 11 product rows are inlined from the sample's model/data.json. Fields the original` &&
                 ` JSON omits are given their UI5 defaults so the bound enum-ish properties stay valid: GridListItem.type -> 'Inactive' (8 rows), highlight/Status -> 'None' (5 rows). Both render identically to the` &&
                 ` original's undefined values; structural-diff compares only binding paths, not data.`
        use_ec = abap_true
        use_ec_arg = abap_true
        use_name = abap_true )
      ( module = `sap.f`              control = `sap.f.ProductSwitch`                 name = `ProductSwitchNavigation`             class = `z2ui5_cl_ai_app_165` path = `src/04/b07/z2ui5_cl_ai_app_165.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `IMPROVISED: The shipped view is only the trigger Button plus two explanatory Texts in a VerticalLayout - rebuilt 1:1. The ProductSwitch is built in the sample's JS controller (fnOpen) inside a` &&
                 ` ResponsivePopover fragment (ResponsivePopover > ProductSwitch > ProductSwitchItem) and opened on press. abap2UI5 has no JS controller, so the button press raises a client MESSAGE_TOAST in place of` &&
                 ` the controller-built ResponsivePopover; the ProductSwitch and ProductSwitchItem controls are therefore not rendered (a controller-only sample).`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.f`              control = `sap.f.semantic.SemanticPage`         name = `SemanticPage`                        class = `z2ui5_cl_ai_app_166` path = `src/04/b07/z2ui5_cl_ai_app_166.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `IMPROVISED: The original keeps header/object data in nested paths on one JSON model (title, showFooter, titleSnappedContent/text, titleExpandedContent/text,` &&
                 ` objectDescription/category|center|email|status). abap2UI5 keeps one default model and render-smoke does not mock nested structures, so those paths are folded to flat fields bound via _bind (last path` &&
                 ` segment identical, which structural-diff matches). Both the snapped and expanded subheading Text controls bind the same flat 'text' field. The full 125-row ProductCollection mock is inlined. //` &&
                 ` IMPROVISED: The semantic action press handlers (titleMainAction onEdit, footerMainAction onSave, footerCustomActions Cancel onCancel, messagesIndicator onMessagesButtonPress) are controller methods` &&
                 ` in the original (opening popovers / navigating); here each press raises a client MESSAGE_TOAST. The DiscussInJam / SendEmail / SendMessage semantic actions keep their built-in behaviour, and the` &&
                 ` DraftIndicator shows state Saved.`
        use_ec = abap_true
        use_ec_arg = abap_true
        use_name = abap_true )
      ( module = `sap.f`              control = `sap.f.ShellBar`                      name = `ShellBar`                            class = `z2ui5_cl_ai_app_110` path = `src/04/b01/z2ui5_cl_ai_app_110.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: First sap.f port. Static ShellBar with a sap.m Menu and a profile Avatar; the homeIcon points at the OpenUI5 host. No controller events are wired in the original view.` )
      ( module = `sap.f`              control = `sap.f.ShellBar`                      name = `ShellBarWithMenuButton`              class = `z2ui5_cl_ai_app_152` path = `src/04/b06/z2ui5_cl_ai_app_152.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: Static sap.f.ShellBar with menu/nav/search/notifications/copilot toggles, homeIcon, notificationsNumber and a profile Avatar (initials), reproduced 1:1.` )
      ( module = `sap.f`              control = `sap.f.SidePanel`                     name = `SidePanelSingle`                     class = `z2ui5_cl_ai_app_136` path = `src/04/b03/z2ui5_cl_ai_app_136.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `LIVE-TEST: SidePanel.toggle shows a client-side MessageToast. The original onToggle inspected the preventExpand/preventCollapse switches and called event.preventDefault() to veto the expand/collapse;` &&
                 ` that veto logic is a live interaction not reproduced here (the switches are kept as static controls).`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.ActionListItem`                name = `ActionListItem`                      class = `z2ui5_cl_ai_app_001` path = `src/01/b05/z2ui5_cl_ai_app_001.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port` )
      ( module = `sap.m`              control = `sap.m.Bar`                           name = `Page`                                class = `z2ui5_cl_ai_app_002` path = `src/01/b05/z2ui5_cl_ai_app_002.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port` )
      ( module = `sap.m`              control = `sap.m.Breadcrumbs`                   name = `Breadcrumbs`                         class = `z2ui5_cl_ai_app_003` path = `src/01/b01/z2ui5_cl_ai_app_003.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a` &&
                 ` close look.`
        since = `1.34`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed); RESTAMP after the 2026-07-16 rework (link toast +` &&
                 ` instant separator switch confirmed)`
        notes = `NOTE: the original wires a change handler on the separator Select (SEP_CHANGE round-trip, removed 2026-07-16): selectedKey and separatorStyle share one two-way model path, so the Select.change` &&
                 ` attribute is deliberately MISSING vs the original view. Instant switching confirmed in the 2026-07-20 live check (restamp). // LIVE-TEST: the link toast was switched from a message_toast_display` &&
                 ` round-trip to a roundtrip-free client-composed toast on 2026-07-22 (control_global MESSAGE_TOAST.show, template ``{0} has been activated`` filled by ${$source>/text}; on_event dropped) - re-verify` &&
                 ` each breadcrumb link toasts "<text> has been activated".`
        use_ec = abap_true
        use_ec_arg = abap_true
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.BusyDialog`                    name = `BusyDialog`                          class = `z2ui5_cl_ai_app_004` path = `src/01/b05/z2ui5_cl_ai_app_004.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a` &&
                 ` close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `NOTE: the BusyDialog fragment is rebuilt 1:1 as a core:FragmentDefinition shown via client->popup_display (the framework's displayFragment calls .open() on the fragment root, the equivalent of the` &&
                 ` controller's Fragment.load + oBusyDialog.open()); one attribute is added vs the original fragment: id="busyDialog", needed so the backend timer event can close the dialog via the whitelisted` &&
                 ` control_by_id 'close' method (CONTROL_METHODS in FrontendAction.js, no-arg; the id resolves in the POPUP slot via Fragment.byId('popupId', ...)) - the equivalent of the controller's` &&
                 ` oBusyDialog.close(). // NOTE: the controller's simulateServerRequest (setTimeout 3000ms) becomes the framework timer: follow_up_action( cs_event-start_timer, callbackEvent TIMER_FINISHED, 3000 )` &&
                 ` started with the popup. A running frontend timer cannot be cleared from ABAP (the original's clearTimeout in onDialogClosed), so after a cancel the timer still fires one backend round-trip; a` &&
                 ` protected guard flag (check_busy) ignores it - same visible behavior (no second toast, dialog already closed), one extra no-op round-trip. // NOTE: the controller's syncStyleClass('sapUiSizeCompact',` &&
                 ` view, dialog) is dropped: it only copies the compact-density class when the view itself carries it, which the sample view does not; abap2UI5's popup slot has no per-view density sync, so there is` &&
                 ` nothing to propagate.`
        use_fua = abap_true
        use_fua_arg = abap_true
        use_popup = abap_true )
      ( module = `sap.m`              control = `sap.m.Button`                        name = `Button`                              class = `z2ui5_cl_ai_app_005` path = `src/01/b03/z2ui5_cl_ai_app_005.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        checked = `CHECKED (2026-07-15): manually verified in a running system - each press toasts the pressed button's client-side control id, read via the event arg $event.oSource.sId, exactly like the original.`
        notes = `LIVE-TEST: the toast was switched from a message_toast_display round-trip to a roundtrip-free client-composed toast on 2026-07-22 (control_global MESSAGE_TOAST.show, template ``{0} Pressed`` filled by` &&
                 ` $event.oSource.sId; the app is now init-only) - re-verify each button still toasts "<id> Pressed".`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.Carousel`                      name = `CarouselWithControls`                class = `z2ui5_cl_ai_app_006` path = `src/01/b04/z2ui5_cl_ai_app_006.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        release = `1.125`
        release_post171 = abap_true
        is_post171 = abap_true
        checked = `CHECKED (2026-07-15): manually verified in a running system - renders and scrolls like the original (see the note below on the flattened image model).`
        notes = `IMPROVISED: the three carousel images bind to a separate named model in the original (img>/products/pic1..3 from sap/ui/demo/mock/img.json); resolved here to static image URLs, as abap2UI5 serves a` &&
                 ` single default model. // POST-1.71: ariaLabelledBy on the Carousel (since UI5 1.125) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.125 to render it.`
        post171 = `ariaLabelledBy on the Carousel (since UI5 1.125) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.125 to render it.`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.CheckBox`                      name = `CheckBox`                            class = `z2ui5_cl_ai_app_155` path = `src/01/b15/z2ui5_cl_ai_app_155.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: Fifteen CheckBoxes across all states (selected, partiallySelected, required, enabled, valueState Warning/Error/Information, wrapping) plus a SimpleForm with GridData-laid-out CheckBoxes,` &&
                 ` reproduced 1:1.` )
      ( module = `sap.m`              control = `sap.m.CheckBox`                      name = `CheckBoxTriState`                    class = `z2ui5_cl_ai_app_007` path = `src/01/b02/z2ui5_cl_ai_app_007.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-15): manually verified in a running system - the select-all parent checkbox and its tri-state expression bindings behave like the original.; live-checked reference example for:` &&
                 ` expression bindings, two-way bind, boolean event arg` )
      ( module = `sap.m`              control = `sap.m.ColorPalette`                  name = `ColorPalette`                        class = `z2ui5_cl_ai_app_008` path = `src/01/b02/z2ui5_cl_ai_app_008.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.54`
        notes = `LIVE-TEST: the color-select toast was switched to a roundtrip-free client-composed toast on 2026-07-22 (control_global MESSAGE_TOAST.show, template with {0}/{1} filled by ${$parameters>/value} and` &&
                 ` ${$parameters>/defaultAction}; on_event dropped, init-only) - re-verify selecting a color toasts the value and true/false defaultAction.`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.Column`                        name = `Table`                               class = `z2ui5_cl_ai_app_009` path = `src/01/b05/z2ui5_cl_ai_app_009.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 5 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.12`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `IMPROVISED: the shared demo kit mock model sap/ui/demo/mock/products.json (/ProductCollection, snapshotted in ui5/mock/products.json) is flattened into the default model: all 123 rows are kept` &&
                 ` verbatim, but only the bound columns (ProductId, Name, SupplierName, WeightMeasure, WeightUnit, Width, Depth, Height, DimUnit, Price, CurrencyCode) are ported - the unbound columns (Category,` &&
                 ` MainCategory, TaxTarifCode, Description, DateOfSale, ProductPicUrl, Status, Quantity, UoM) of the shared mock model are dropped. // IMPROVISED: the controller's onPopinLayoutChanged (ComboBox change` &&
                 ` handler running a PopinLayout switch with a Block default) is expressed as bound properties instead of a round-trip (AGENTS 'prefer a bindable property'): the ComboBox's change attribute is dropped,` &&
                 ` its selectedKey is bound two-way, and the Table gains a popinLayout expression binding that reproduces the switch including its Block default. // IMPROVISED: the controller's onToggleInfoToolbar` &&
                 ` (ToggleButton press handler calling getInfoToolbar().setVisible(!pressed)) is expressed as bound properties instead of a round-trip: the ToggleButton's press attribute is dropped, its pressed` &&
                 ` property is bound two-way, and the infoToolbar's OverflowToolbar gains a visible={= !pressed } expression binding. // IMPROVISED: the controller's onSelect (imperative oTable.setSticky array` &&
                 ` maintenance from the CheckBox text + selected parameter) becomes a sticky property on the Table bound to a plain string table: each CheckBox select event round-trips ${$source>/text} and` &&
                 ` ${$parameters>/selected}, the ABAP handler inserts/removes that option and pushes the model back via view_model_update. // 1.71: the p:ColumnAIAction column plugin (sap.m.plugins, since UI5 1.136 -` &&
                 ` far newer than 1.71) is dropped with its dependents aggregation, the xmlns:p namespace and the press toast - the plugin class does not exist on a 1.71 runtime, so keeping it would break view creation` &&
                 ` there (same decision as app 022). // NOTE: the original derives the ObjectNumber weight state in its frontend Formatter.js (weightState: KG conversion + Success/Warning/Error thresholds). That is` &&
                 ` business logic, so - abap2UI5 being a thin frontend - it is computed in ABAP model_init into a WEIGHT_STATE field and bound state="{WEIGHT_STATE}", not via a frontend formatter (core:require` &&
                 ` dropped). Visually 1:1 with the original.`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.ColumnListItem`                name = `TableTest`                           class = `z2ui5_cl_ai_app_010` path = `src/01/b05/z2ui5_cl_ai_app_010.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        since = `1.12`
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port`
        notes = `NOTE: the sample is an OPA-test demo: only the UI app under applicationUnderTest/ (Table.view.xml, Table.controller.js, Formatter.js, products.json) is ported 1:1; the qunit/OPA harness files` &&
                 ` (OpaTableTest.qunit.js, Test.qunit.html, testsuite.qunit.*) are test infrastructure without UI and are not ported. // IMPROVISED: the controller's onPopinLayoutChanged` &&
                 ` (byId(idProductsTable).setPopinLayout per the ComboBox selectedKey switch) is a pure client-side path: two-way bound ComboBox selectedKey feeding a popinLayout expression binding with the same` &&
                 ` GridLarge/GridSmall-else-Block fallback (extra attributes vs the original view, original change handler dropped) - no round-trip, same pattern as app 009; the expression can never emit an empty enum` &&
                 ` value. // NOTE: the controller-built sap.m.Dialog of onMessageDialogPress (title Message, type Message, a Text 'Success' as content, an OK beginButton Button that closes it) is rebuilt 1:1 as a` &&
                 ` core:FragmentDefinition shown via client->popup_display on the ColumnListItem press event; the OK Button closes roundtrip-free via the frontend action _event_client( cs_event-popup_close ), and the` &&
                 ` original's afterClose destroy is the framework's popup lifecycle. The Dialog, its Text and its Button are extra controls vs the original view.xml (controller-created there). // IMPROVISED: model` &&
                 ` flattening: the sample's LOCAL applicationUnderTest/products.json (123 rows) is moved into the default model verbatim, unbound columns dropped. Note: the local file is NOT identical to the shared` &&
                 ` mock ui5/mock/products.json - same 123 ProductIds, but HT-9995 differs in content (local: Smartphone Cover / 15 EUR vs mock: Tablet Pouch / 20 EUR); the port follows the local file, the sample's` &&
                 ` actual model source. // NOTE: the original derives the ObjectNumber weight state in its frontend Formatter.js (weightState: KG conversion + Success/Warning/Error thresholds). That is business logic,` &&
                 ` so - abap2UI5 being a thin frontend - it is computed in ABAP model_init into a WEIGHT_STATE field and bound state="{WEIGHT_STATE}", not via a frontend formatter (core:require dropped). Visually 1:1` &&
                 ` with the original.`
        use_ec = abap_true
        use_popup = abap_true
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.ComboBox`                      name = `ComboBox`                            class = `z2ui5_cl_ai_app_011` path = `src/01/b02/z2ui5_cl_ai_app_011.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.ComparisonPattern`             name = `ComparisonPattern`                   class = `z2ui5_cl_ai_app_012` path = `src/01/b05/z2ui5_cl_ai_app_012.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 5 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        ui5_only = abap_true
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `IMPROVISED: the pattern's three views (App.view with sap.m.App id=rootControl, Main.view, Comparison.view) plus manifest routing are merged into ONE view: the App hosts the Main Page and the` &&
                 ` Comparison f:DynamicPage (id page-comparison added) directly as its pages; the router's navTo("page2") is mapped to the documented NavContainer frontend action follow_up_action(` &&
                 ` cs_event-control_by_id, rootControl//to/page-comparison ) with the default slide transition (CAPABILITIES nav row); hash-based routing / browser-back navigation is not wired; the view controllerName` &&
                 ` attributes are dropped. // IMPROVISED: named models flattened into the single default model: the Comparison view's settings> model becomes the bound PAGES_COUNT/IS_DESKTOP fields (pagesCount` &&
                 ` initialized to 1, the CarouselLayout.visiblePagesCount UI5 default, instead of the original's undefined-until-routeMatched), and its products> model (Products/Props) becomes` &&
                 ` T_COMP_PRODUCTS/T_COMP_PROPS; the shared mock products.json default model is flattened into a flat upper-cased row type (all 20 JSON columns kept; rows without DateOfSale carry an empty string where` &&
                 ` the original JSON omits the key - a harmless string property, no enum/default override). // IMPROVISED: the '.formatter.url' iconSrc formatter flattened to absolute https://sdk.openui5.org image URLs` &&
                 ` - source-verified against the now-archived app/model/formatter.js (it only prefixes '../../../../../../', i.e. resolves to the test-resources root), so the absolute URLs are the faithful equivalent.` &&
                 ` // NOTE: compare button: the controller's onSelection setText/setVisible is replaced by bound COMPARE_TEXT/COMPARE_VISIBLE model properties updated in the SELECTION handler (same count>1 logic, text` &&
                 ` only refreshed while shown, like the original); the ColumnListItem gains a selected="{SELECTED}" two-way binding - the sanctioned selection-read pattern (CAPABILITIES 'Controller-read list` &&
                 ` selection') replacing getSelectedContextPaths - which is an extra attribute vs the original template, and the initial visible="false"/absent text of the Button become bindings. // IMPROVISED: the` &&
                 ` ResizeHandler-driven pagesCount/isDesktop recalculation (_onResize/_getPagesCount) is replaced by a one-shot computation at COMPARE time from client->get( )-s_device-resize-width using the original's` &&
                 ` 600/1024 thresholds and the cap at the selected-items count; no live recalculation on window resize. // NOTE: Panel expand: the controller's onPanelExpanded (walking the sibling HBox controls and` &&
                 ` calling setVisible) is replaced by a bound VISIBLE flag per comparison value row, toggled in the PANEL_EXPANDED event via t_arg ${KEY} + ${$parameters>/expand}; the description HBox's literal` &&
                 ` visible="false" becomes the {VISIBLE} binding (initial false). // IMPROVISED: snapped/expanded Carousel re-sync stays dropped although Carousel.setActivePage is whitelisted upstream since 2026-07-20` &&
                 ` (pr/control-methods-openby-setactivepage): the carousels' pages are aggregation-template CLONES whose ids (templateId-parentId-index, view-prefixed; nondeterministic under extended change detection)` &&
                 ` are not addressable from the backend - restoring the re-sync would need an index-based page-resolution mechanism, a new framework idea if more samples turn out to need it. // NOTE: the` &&
                 ` DynamicPageTitle stateChange handler (.onStateChange, add/removeSnappedContent of the snapped Carousel as a Carousel-animation workaround) is dropped together with its stateChange attribute -` &&
                 ` imperative aggregation surgery with no framework equivalent; the snapped/expanded content still switches natively with the DynamicPage header state. // NOTE: comparison Props are built from a fixed` &&
                 ` 19-key list in the mock JSON key order (the original iterates the FIRST selected product's own keys, skipping ProductPicUrl - so a first product without DateOfSale would drop that row, and missing` &&
                 ` values rendered '<strong>undefined</strong>' where the port renders an empty <strong></strong>); selected products are taken in model row order, not click order; the original's per-product` &&
                 ` information cache is unnecessary server-side. The controller's handleButtonPress (MessageBox) is dead code referenced by no view and not ported.`
        use_fua = abap_true
        use_fua_arg = abap_true
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.CookieSettingsDialogPattern`   name = `CookieSettingsDialogPattern`         class = `z2ui5_cl_ai_app_013` path = `src/01/b05/z2ui5_cl_ai_app_013.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 4 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        ui5_only = abap_true
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `IMPROVISED: the i18n> ResourceModel (i18n/i18n.properties) has no framework i18n mechanism here - all texts (dialog title, section titles/summaries/details, button labels) are inlined as the resolved` &&
                 ` English literals from the properties file; this covers every i18n>-bound text incl. the Panel headerText 'More Info'. // IMPROVISED: the cookieData> named JSON model is flattened into the default` &&
                 ` model: /showCookieDetails becomes the bound abap_bool show_cookie_details; every visible binding and expression binding keeps its original shape over the flattened path (named ABAP-fed JSON models` &&
                 ` are not expressible, CAPABILITIES.md). // IMPROVISED: custom:DivContainer (xmlns:custom="sap.ui.documentation", a demo-kit-internal plain-div wrapper control not shipped in any UI5 library) is` &&
                 ` rebuilt as a sap.m.VBox with the same class sapUiSmallMargin. // IMPROVISED: the controller's toggleStyleClass/addStyleClass/removeStyleClass('cookiesDetailedView') on the dialog is dropped because` &&
                 ` the class's CSS is not part of the sample's shipped files (manifest references css/style.css but does not list it under sample files, and it is not archived), so toggling the class has no visible` &&
                 ` effect. Since 2026-07-22 add/remove/toggleStyleClass ARE whitelisted in CONTROL_METHODS (pr/style-class-toggle), so the toggle could be wired via follow_up_action( cs_event-control_by_id,` &&
                 ` toggleStyleClass ) once the CSS is present; it stays dropped here only for the missing CSS. // NOTE: the controller's lazy Fragment.load + cached-instance open()/close() lifecycle maps to` &&
                 ` client->popup_display (the fragment XML is rebuilt per open, forcing showCookieDetails=false like the original's openCookieSettingsDialog) and client->popup_destroy in the close handlers; the` &&
                 ` original's empty 'insert your ... logic here' placeholders remain as backend event branches (ACCEPT_ALL_COOKIES/REJECT_ALL_COOKIES/SAVE_COOKIES) that only close the dialog.`
        use_fua = abap_true
        use_fua_arg = abap_true
        use_popup = abap_true )
      ( module = `sap.m`              control = `sap.m.CustomListItem`                name = `CustomListItem`                      class = `z2ui5_cl_ai_app_014` path = `src/01/b05/z2ui5_cl_ai_app_014.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `IMPROVISED: the shared mock model /ProductCollection (ui5/mock/products.json) is flattened into the default model with only the three bound columns (ProductId, Name, ProductPicUrl); all unbound` &&
                 ` columns are dropped. The full 123-row set is kept verbatim. // NOTE: the ProductPicUrl values point at the OpenUI5 host (https://sdk.openui5.org/test-resources/...) per the asset-URL rule; they are` &&
                 ` rebuilt per row from ProductId in a LOOP in model_init - path and file name are identical to the mock values, only the host prefix is added. // NOTE: the controller-built Dialog of handlePress (Image` &&
                 ` + Close button, afterClose destroy) is rebuilt 1:1 as a core:FragmentDefinition -> Dialog shown via client->popup_display (the CAPABILITIES.md pattern, app 042). The Link press ships the row's` &&
                 ` ProductPicUrl via t_arg ${PRODUCT_PIC_URL} - the original reads evt.getSource().getTarget(), whose target property is bound to the same column. The Close button maps to client->_event_client(` &&
                 ` popup_close ); the original's afterClose destroy is handled by the framework's popup lifecycle and is not wired separately.`
        use_ec = abap_true
        use_popup = abap_true
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.CustomTreeItem`                name = `CustomTreeItem`                      class = `z2ui5_cl_ai_app_015` path = `src/01/b05/z2ui5_cl_ai_app_015.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.48.0`
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port`
        notes = `NOTE: the original binds the Tree's items to the whole JSON model root (items="{path: '/'}", the model IS the node array from Tree.json); abap2UI5 serves a single default model, so the array is` &&
                 ` flattened into it as the bound table T_TREE and the binding-info keeps its shape with the bound path substituted for '/' (nested tree binding is expressible per CAPABILITIES.md, proven by app 054).` &&
                 ` // NOTE: the flat ABAP row types serialize an empty NODES array on leaf rows where the original Tree.json simply omits the 'nodes' property (levels 1-4; the level-5 row type carries no NODES field at` &&
                 ` all); ClientTreeBinding treats an empty child array as a childless node, so the rendered tree matches. TEXT and REF are present on every original node - no absent-property/empty-string enum risk.`
        use_ec = abap_true
        use_ec_arg = abap_true
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.DatePicker`                    name = `DatePickerHidden`                    class = `z2ui5_cl_ai_app_016` path = `src/01/b05/z2ui5_cl_ai_app_016.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.22.0`
        release = `1.97`
        release_post171 = abap_true
        is_post171 = abap_true
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed); live-checked reference example for: frontend action` &&
                 ` (openBy/domRef), $event.oSource.sId anchor transport, POST_171 discipline`
        notes = `LIVE-TEST: on 2026-07-22 both interactions went roundtrip-free (openBy via _event_client instead of follow_up_action; date-changed toast client-composed via control_global) and the app became` &&
                 ` init-only - re-verify each anchor opens the hidden DatePicker and picking a date toasts "Date selected: <value>". // POST-1.71: Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for` &&
                 ` the 1:1 port on both Buttons - the app needs a UI5 release >= 1.84 to render it. // POST-1.71: Link.ariaHasPopup (since UI5 1.86) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5` &&
                 ` release >= 1.86 to render it. // POST-1.71: DatePicker.hideInput (since UI5 1.97) is newer than 1.71 but kept for the 1:1 port - the sample's central property (the picker input stays hidden, opened` &&
                 ` only via the anchor controls); openBy is also since 1.97, so the app needs a UI5 release >= 1.97 to render this sample's behavior.`
        post171 = `Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port on both Buttons - the app needs a UI5 release >= 1.84 to render it. // Link.ariaHasPopup (since UI5 1.86) is newer` &&
                 ` than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.86 to render it. // DatePicker.hideInput (since UI5 1.97) is newer than 1.71 but kept for the 1:1 port - the sample's central` &&
                 ` property (the picker input stays hidden, opened only via the anchor controls); openBy is also since 1.97, so the app needs a UI5 release >= 1.97 to render this sample's behavior.`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.DateRangeSelection`            name = `DateRangeSelection`                  class = `z2ui5_cl_ai_app_017` path = `src/01/b06/z2ui5_cl_ai_app_017.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.22.0`
        release = `1.95`
        release_post171 = abap_true
        is_post171 = abap_true
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `NOTE: the original controller's JSON model carries UI5Date objects; the ABAP model carries the same dates as ISO 'yyyy-MM-dd' strings, and each sap.ui.model.type.Date part of the DateInterval value` &&
                 ` bindings gets an added formatOptions.source pattern 'yyyy-MM-dd' so the strings are parsed to Dates and written back as strings (source-verified: DateInterval sets bUseInternalValues and` &&
                 ` Date.getModelFormat returns the source format; CAPABILITIES: Date types over ISO strings need a source pattern). Same rows/values as the sample, only the value type differs. // NOTE: the original` &&
                 ` controller's onInit oDRS2.setMinDate(2016-01-01)/setMaxDate(2016-12-31) become minDate/maxDate view attributes on DRS2, bound over ISO strings with formatter 'Formatter.DateCreateObject'` &&
                 ` (CAPABILITIES date-object-properties row) - two extra attributes vs the original view.xml. // POST-1.71: core:require (UI5 >= 1.74) on the view root loads z2ui5/model/formatter for the DRS2` &&
                 ` minDate/maxDate Formatter.DateCreateObject bindings - the app needs a UI5 release >= 1.74 to render it. // POST-1.71: showCurrentDateButton (since UI5 1.95) on DRS3 is newer than 1.71 but kept for` &&
                 ` the 1:1 port - the app needs a UI5 release >= 1.95 to render it. // NOTE: the change handler's imperative oEventSource.setValueState(None/Error) becomes a two-way bound valueState attribute on each` &&
                 ` of the five DateRangeSelections (prefer a bindable property over imperative calls); the backend maps the event-source id to the matching field - five extra valueState attributes vs the original` &&
                 ` view.xml, initialized to 'None' (enum property, never an empty string). // NOTE: the change handler's imperative oText.setText(...) becomes a bound text attribute on the TextEvent Text - one extra` &&
                 ` attribute vs the original view.xml (there the Text has no text attribute). // NOTE: the controller's _iEvent counter is omitted - it is incremented in handleChange but never displayed or otherwise` &&
                 ` used in the sample.`
        post171 = `core:require (UI5 >= 1.74) on the view root loads z2ui5/model/formatter for the DRS2 minDate/maxDate Formatter.DateCreateObject bindings - the app needs a UI5 release >= 1.74 to render it. //` &&
                 ` showCurrentDateButton (since UI5 1.95) on DRS3 is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.95 to render it.` )
      ( module = `sap.m`              control = `sap.m.DateTimePicker`                name = `DateTimePicker`                      class = `z2ui5_cl_ai_app_018` path = `src/01/b06/z2ui5_cl_ai_app_018.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.38.0`
        release = `1.99`
        release_post171 = abap_true
        is_post171 = abap_true
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `IMPROVISED: the JSON model's UI5Date instances become date strings in the flat ABAP model: the sap.ui.model.type.DateTime bindings (DTP2/3/4/5/8) get an added source pattern 'yyyy-MM-dd HH:mm:ss'` &&
                 ` format option so the type parses the model string (CAPABILITIES: Date types over ISO strings need a source pattern), and the sap.ui.model.odata.type.DateTimeOffset parts of DTP10/DTP11 get added` &&
                 ` constraints {V4: true} so the DateTimeWithTimezone composite receives a parsed Date internal value (source-verified in DateTimeOffset.js getModelFormat/CompositeBinding internal values); valueDTP10` &&
                 ` is the UTC string '2023-03-31T10:32:30Z' instead of the original's local-time UI5Date, and DTP3/DTP5 'now' comes from server sy-datum/sy-uzeit instead of the browser clock. // IMPROVISED: the` &&
                 ` controller's byId('DTP6').setInitialFocusedDateValue(UI5Date.getInstance(2017, 5, 13, 11, 12, 13)) is expressed as a bound initialFocusedDateValue property with the Formatter.DateCreateObject module` &&
                 ` formatter over the model string '2017-06-13T11:12:13' (CAPABILITIES date-object row) - extra initialFocusedDateValue attribute on DTP6 plus xmlns:core and core:require on the view root vs the` &&
                 ` original view.xml. // IMPROVISED: the controller's handleChange becomes a CHANGE round-trip: the source control id, entered value and valid flag travel via $event.oSource.sId / ${$parameters>/value}` &&
                 ` / ${$parameters>/valid}; the textResult Text.text becomes a binding and every change-firing picker (DTP1/2/3/4/6/7) gets an added bound valueState attribute, initialized to 'None' so no empty string` &&
                 ` reaches the enum-typed property - the original sets both imperatively on the controls. // NOTE: the view-level attachParseError/attachValidationSuccess handlers of the original controller (valueState` &&
                 ` Error/None on binding parse errors in the data-binding panel) are covered by the framework's automatic handleValidation registration on every view slot (CAPABILITIES MessageManager row,` &&
                 ` pr/message-model) - no port code needed. // NOTE: model flattening: the original model's valueDTP9 is bound by no control in the view and is dropped; valueDTP11 (null in the original) serializes as` &&
                 ` an empty string in the flat ABAP model, which the V4 DateTimeOffset model format parses back to null, so DTP11 renders timezone-only like the original. // POST-1.71: showCurrentDateButton (since UI5` &&
                 ` 1.95) on DTP2 is kept for the 1:1 port. // POST-1.71: showCurrentTimeButton (since UI5 1.98) on DTP2 and DTP11 is kept for the 1:1 port. // POST-1.71: showTimezone (since UI5 1.99) on DTP8 and DTP11` &&
                 ` is kept for the 1:1 port. // POST-1.71: timezone (since UI5 1.99) on DTP8 is kept for the 1:1 port. // POST-1.71: core:require of the z2ui5/model/formatter module on the view root needs UI5 >= 1.74,` &&
                 ` and the sap.ui.model.odata.type.DateTimeWithTimezone binding type of DTP10/DTP11 (since UI5 1.99) is kept 1:1 - the app needs a UI5 release >= 1.99 overall.`
        post171 = `showCurrentDateButton (since UI5 1.95) on DTP2 is kept for the 1:1 port. // showCurrentTimeButton (since UI5 1.98) on DTP2 and DTP11 is kept for the 1:1 port. // showTimezone (since UI5 1.99) on DTP8` &&
                 ` and DTP11 is kept for the 1:1 port. // timezone (since UI5 1.99) on DTP8 is kept for the 1:1 port. // core:require of the z2ui5/model/formatter module on the view root needs UI5 >= 1.74, and the` &&
                 ` sap.ui.model.odata.type.DateTimeWithTimezone binding type of DTP10/DTP11 (since UI5 1.99) is kept 1:1 - the app needs a UI5 release >= 1.99 overall.` )
      ( module = `sap.m`              control = `sap.m.Dialog`                        name = `DialogConfirm`                       class = `z2ui5_cl_ai_app_019` path = `src/01/b06/z2ui5_cl_ai_app_019.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed); live-checked reference example for: fragment-popup` &&
                 ` dialogs, roundtrip-free live-enable expression, popup_close paths`
        notes = `NOTE: the original builds its four Dialogs imperatively in the controller (new Dialog({...}).open()); the port expresses each as a core:FragmentDefinition popup shown via client->popup_display on the` &&
                 ` button press event - the CAPABILITIES.md 1:1 path for controller-built Dialogs. The four Dialog fragments are therefore extra vs the archived V.view.xml, which holds only the four trigger Buttons;` &&
                 ` every fragment control is EXTRA vs the archived V.view.xml (only the four trigger Buttons exist there): Dialog, Text, TextArea, Label, Button and the l:VerticalLayout / l:HorizontalLayout wrappers` &&
                 ` inside the dialogs. // NOTE: the controller reads each note imperatively (Element.getElementById(...).getValue()); the port two-way binds the three TextArea values` &&
                 ` (reject_note/submit_note/confirm_note) and builds the 'Note is: ...' toasts from the synced ABAP fields in on_event - an extra value attribute per TextArea vs the original construction. // NOTE: the` &&
                 ` submission dialog's liveChange handler (enable the Submit button while the note is non-empty, enabled: false initially) is replaced round-trip-free by valueLiveUpdate=true on the TextArea plus an` &&
                 ` expression binding {= ${...}.length > 0 } on the begin button's enabled - same behavior, starts disabled with the empty note (CAPABILITIES.md: prefer a pure expression binding over an event` &&
                 ` round-trip). // NOTE: Cancel: the approve dialog (no inputs) closes client-side via _event_client popup_close; the three note dialogs cancel through a backend DIALOG_CANCEL event + popup_destroy so` &&
                 ` the two-way model sync keeps the typed note across a reopen, matching the original's reused cached dialog instances.`
        use_ec = abap_true
        use_popup = abap_true )
      ( module = `sap.m`              control = `sap.m.DisplayListItem`               name = `DisplayListItem`                     class = `z2ui5_cl_ai_app_020` path = `src/01/b06/z2ui5_cl_ai_app_020.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port`
        notes = `IMPROVISED: the shared mock model sap/ui/demo/mock/supplier.json is flattened into the default model: the row type keeps only the six bound columns (SupplierName, Street, HouseNumber, ZIPCode, City,` &&
                 ` Country) of the single /SupplierCollection record and drops the unbound columns (Url, Twitter, Tel, Sms, Mobile, Pager, Fax, Email, Rating, Prime, Disposable); the record itself is kept verbatim. //` &&
                 ` NOTE: the sample controller loads the shared mock sap/ui/demo/mock/supplier.json - snapshotted byte-identical into ui5/mock/supplier.json (2026-07-20, git sparse checkout of SAP/openui5 master); one` &&
                 ` SupplierCollection record, full row set, values verifiable offline. // NOTE: element binding binding="{/T_SUPPLIERS/0}" with relative DisplayListItem value bindings - the binding= context mechanism` &&
                 ` is already live-verified via app 041 (checked 2026-07-19); the /0 array-index path variant is a plain JSONModel path resolution, source-decidable, so no LIVE_TEST is carried.`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.DraftIndicator`                name = `DraftIndicator`                      class = `z2ui5_cl_ai_app_021` path = `src/01/b06/z2ui5_cl_ai_app_021.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.32.0`
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port`
        notes = `IMPROVISED: the controller's imperative DraftIndicator calls (showDraftSaving/showDraftSaved/clearDraftState on byId('draftIndi')) are not in the FrontendAction CONTROL_METHODS whitelist; per AGENTS` &&
                 ` 'prefer a bindable property over a frontend action' the port two-way binds the control's public state property (sap.m.DraftIndicatorState, since 1.32) and sets Saving/Saved/Clear in the three event` &&
                 ` handlers. Source-verified equivalent: a binding update calls the public mutator (ManagedObjectBindingSupport.updateProperty -> _sMutator), and DraftIndicator.setState queues exactly what the three` &&
                 ` methods queue (setState('Saving') queues Saving+Clear like showDraftSaving, sap/m/DraftIndicator.js). Adds the state attribute on the DraftIndicator vs the original view.xml. // NOTE: pressing the` &&
                 ` same button twice in direct succession does not re-run the indicator - the model value is unchanged, so no binding change fires and setState is not called again (the original re-queues on every` &&
                 ` method call); pressing a different button in between restores the behaviour.` )
      ( module = `sap.m`              control = `sap.m.FacetFilter`                   name = `FacetFilterLight`                    class = `z2ui5_cl_ai_app_022` path = `src/01/b04/z2ui5_cl_ai_app_022.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed); live-checked reference example for: compound` &&
                 ` binding_call filter, curated formatter module, two-way facet selection`
        notes = `NOTE: the bound lists="{/ProductCollectionStats/Filters}" collection is represented as two static FacetFilterLists (Category, SupplierName) - the original's stats model yields exactly these two lists,` &&
                 ` so this is a faithful equivalent; the facet values inside each list stay bound to a FacetFilterItem template. A doubly-nested variant (bind the FacetFilter lists aggregation to a nested table,` &&
                 ` FacetFilterList template with a relative items binding over each filter's values) is source-plausible now that nested binding is expressible, but no port proves that aggregation-of-aggregation` &&
                 ` template shape yet - LIVE_TEST before adopting it. // NOTE: selection transport - every FacetFilterItem binds selected two-way; on listClose/reset the backend reads/clears the flags and re-filters.` &&
                 ` This is the documented 1:1 path (CAPABILITIES.md marks controller-read FacetFilter/List multi-select as expressible with app 022 as its evidence port), not a workaround; the model is applied before` &&
                 ` on_event runs. // IMPROVISED: the original controller appends the sap.m.sample.Table component's table with its first cell swapped for an ObjectIdentifier {Name}/{Category}; that table is rebuilt` &&
                 ` inline. The price column keeps the original sap.ui.model.type.Currency composite binding 1:1 (raw binding-info string over a numeric PRICE field). // NOTE: the appended table's header toolbar is` &&
                 ` restored except for the sticky controls: the popin-layout ComboBox keeps its core:Item entries and binds selectedKey two-way in place of the original's change handler (the controller switch is a pure` &&
                 ` key-to-property pass-through; the Table's added popinLayout expression binding maps an empty selection to the Block default), and the Hide/Show ToggleButton binds pressed two-way in place of its` &&
                 ` press handler, with the restored infoToolbar's OverflowToolbar carrying a visible expression binding over the same flag - both per the prefer-a-bindable-property rule, no round-trip. // IMPROVISED:` &&
                 ` the sticky options Label and the three sticky CheckBox controls (with their select handlers) are dropped - Table.sticky is an array-valued property the controller mutates via setSticky, and neither` &&
                 ` an array property binding nor a setSticky whitelist entry is a proven path; a bound-array LIVE_TEST port could disprove this later. // 1.71: the p:ColumnAIAction column plugin (sap.m.plugins, far` &&
                 ` newer than UI5 1.71) is dropped with its dependents aggregation and press toast - the plugin class does not exist on a 1.71 runtime, so keeping it would crash view creation there. // NOTE: the` &&
                 ` original's nested items-binding filter (ORs inside each facet group, AND across the groups, model untouched) is expressed 1:1 as a declarative compound filter: apply_filter builds the groups JSON` &&
                 ` from the two-way bound selected flags and schedules follow_up_action cs_event-binding_call filter on idProductsTable/items (compound groups implemented upstream 2026-07-20,` &&
                 ` pr/binding-call-compound-filters); the earlier ABAP-side model rebuild and the t_products_all mirror are gone. // NOTE: the original derives the ObjectNumber weight state in its frontend Formatter.js` &&
                 ` (weightState: KG conversion + Success/Warning/Error thresholds). That is business logic, so - abap2UI5 being a thin frontend - it is computed in ABAP model_init into a WEIGHT_STATE field and bound` &&
                 ` state="{WEIGHT_STATE}", not via a frontend formatter (core:require dropped). Visually 1:1 with the original.`
        use_fua = abap_true
        use_fua_arg = abap_true
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.FeedContent`                   name = `FeedContent`                         class = `z2ui5_cl_ai_app_023` path = `src/01/b06/z2ui5_cl_ai_app_023.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.FeedInput`                     name = `Feed`                                class = `z2ui5_cl_ai_app_024` path = `src/01/b06/z2ui5_cl_ai_app_024.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.22`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `IMPROVISED: the controller's client-side DateFormat.getDateTimeInstance({ style: 'medium' }).format(new Date()) for the new entry's Date is rebuilt server-side in ABAP from sy-datum/sy-uzeit as an` &&
                 ` English medium-style timestamp (e.g. 'Jul 20, 2026, 1:23:45 PM') - the locale-dependent client formatter is not available in the backend round-trip; the value is a plain model string exactly like in` &&
                 ` the original; note the source differs too: sy-datum/sy-uzeit is the SERVER date/time and timezone, while the original renders the browser-local new Date() - around midnight or across timezones the` &&
                 ` displayed timestamp of a new entry can differ from a client-side clock.`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.FeedListItem`                  name = `FeedListItem`                        class = `z2ui5_cl_ai_app_025` path = `src/01/b06/z2ui5_cl_ai_app_025.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `NOTE: the original's removeItem derives the entry index from the item's binding-context path (getBindingContext().getPath().split('/').pop()); the port transports the List's indexOfItem(item) instead` &&
                 ` - the aggregation index equals the model index for this bound list, so the spliced row is the same. // NOTE: feed.json entries 2 and 4 have no Actions property; the flat ABAP row type serializes` &&
                 ` ACTIONS as an empty array ([] instead of undefined) - the actions aggregation renders no actions either way, and an empty array is not an empty-string/enum hazard. // NOTE: the relative AuthorPicUrl` &&
                 ` asset paths (test-resources/sap/m/images/*.jpg) are rewritten to absolute https://sdk.openui5.org/test-resources/... per the project rule for runtime asset URLs.`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.FlexBox`                       name = `FlexBoxGap`                          class = `z2ui5_cl_ai_app_158` path = `src/01/b16/z2ui5_cl_ai_app_158.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: Three Panels demonstrating FlexBox gap / columnGap / rowGap (wrap=Wrap), each with nine typed Buttons, reproduced 1:1.` )
      ( module = `sap.m`              control = `sap.m.FlexBox`                       name = `FlexBoxNested`                       class = `z2ui5_cl_ai_app_026` path = `src/01/b04/z2ui5_cl_ai_app_026.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-19): verified in a running system - human visual pass 2026-07-19 over all apps: the six flex items and the h2 headings render with their injected-CSS background colours like the` &&
                 ` original.`
        notes = `NOTE: the original colours .item1..item6 and the h2 headings via a separate style.css; here it is injected as a core:HTML content attribute (a style tag, minified - see CAPABILITIES.md; the EXTRA` &&
                 ` core:HTML control vs the original view). Confirmed rendering via the human visual pass 2026-07-19.` )
      ( module = `sap.m`              control = `sap.m.FormattedText`                 name = `FormattedText`                       class = `z2ui5_cl_ai_app_154` path = `src/01/b15/z2ui5_cl_ai_app_154.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.38.0`
        notes = `NOTE: FormattedText.htmlText bound to a model field holding the original controller's demo HTML string (headings, link, list, pre, code, cite, dl) 1:1.` )
      ( module = `sap.m`              control = `sap.m.GenericTag`                    name = `GenericTag`                          class = `z2ui5_cl_ai_app_027` path = `src/01/b06/z2ui5_cl_ai_app_027.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.62.0`
        release = `1.97`
        release_post171 = abap_true
        is_post171 = abap_true
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port`
        notes = `POST-1.71: ariaLabelledBy (since UI5 1.97) on the labeled GenericTag is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.97 to render it. // NOTE: the sample's` &&
                 ` Page.controller.js defines a press handler (MessageToast 'The GenericTag is pressed.') that is not referenced anywhere in Page.view.xml - no GenericTag carries a press attribute - so the port wires` &&
                 ` no event; the rendered view is a faithful 1:1 rebuild.`
        post171 = `ariaLabelledBy (since UI5 1.97) on the labeled GenericTag is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.97 to render it.` )
      ( module = `sap.m`              control = `sap.m.GenericTile`                   name = `GenericTileAsKPITile`                class = `z2ui5_cl_ai_app_028` path = `src/01/b01/z2ui5_cl_ai_app_028.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        since = `1.34.0`
        release = `1.92`
        release_post171 = abap_true
        is_post171 = abap_true
        checked = `CHECKED (2026-07-19): verified in a running system - human visual pass 2026-07-19 over all apps: the KPI tiles float left via the injected tileLayout CSS and render like the original.`
        notes = `POST-1.71: frameType values OneByHalf / TwoByHalf (since UI5 1.83) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.83 to render them; OneByOne / TwoByOne (1.71) were` &&
                 ` never affected. // POST-1.71: systemInfo and appShortcut (since UI5 1.92) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.92 to render them. // POST-1.71: url on the` &&
                 ` link tiles (since UI5 1.76) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.76 to render it. // IMPROVISED: the relative test-resources image and backgroundImage paths` &&
                 ` are resolved to absolute sdk.openui5.org URLs so the tile images load standalone. // NOTE: the custom CSS class tileLayout (float: left) is kept and its style.css injected via a core:HTML content` &&
                 ` attribute (see CAPABILITIES.md; the EXTRA core:HTML control vs the original view). Confirmed rendering via the human visual pass 2026-07-19.`
        post171 = `frameType values OneByHalf / TwoByHalf (since UI5 1.83) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.83 to render them; OneByOne / TwoByOne (1.71) were never` &&
                 ` affected. // systemInfo and appShortcut (since UI5 1.92) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.92 to render them. // url on the link tiles (since UI5 1.76)` &&
                 ` is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.76 to render it.`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.HeaderContainer`               name = `HeaderContainer`                     class = `z2ui5_cl_ai_app_029` path = `src/01/b06/z2ui5_cl_ai_app_029.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.44.0`
        notes = `NOTE: the Select's literal selectedKey="1" is replaced by a two-way binding {SELECTED_KEY} (seeded '1'); scrollStepByItem on both HeaderContainers is now a pure client-side expression binding over it` &&
                 ` ({= ${SELECTED_KEY} === 'px' ? 0 : +${SELECTED_KEY} }), so the original Select's change handler (onScrollByItemChange) is dropped - no round-trip. This is the prefer-a-bindable-property/expression` &&
                 ` pattern (like the app 019). The original controller reads oEvent.getParameter('selectedItem').getKey(), which has no public $parameters path (selectedItem is a control; reading private control` &&
                 ` internals is banned). // NOTE: the controller's setScrollStepByItem(0 | Number(key)) on both containers is reproduced by the scrollStepByItem expression binding above (px -> 0, else the number);` &&
                 ` seeded via SELECTED_KEY='1' it matches the UI5 property default (HeaderContainer.js defaultValue: 1), so the initial arrow scroll is one item and selecting px sets 0 (px stepping via scrollStep),` &&
                 ` exactly like the controller - all client-side, no scroll_step_by_item field. // NOTE: the NumericContent press ('Fire press' MessageToast) is wired roundtrip-free via client->_event_client(` &&
                 ` cs_event-control_global, MESSAGE_TOAST/show ) - the original's client-side MessageToast.show 1:1; the app is now init-only (no on_event). An unused xmlns:l namespace was dropped. // LIVE-TEST: the` &&
                 ` scroll-step selection and the tile-press toast were switched from server round-trips to client-side expression binding / _event_client( control_global ) on 2026-07-22 - re-verify in a running system` &&
                 ` that selecting an item/px still changes the arrow scroll step on both containers and that pressing a NumericContent still toasts 'Fire press'.`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.HeaderContainer`               name = `HeaderContainerVM`                   class = `z2ui5_cl_ai_app_157` path = `src/01/b16/z2ui5_cl_ai_app_157.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.44.0`
        notes = `LIVE-TEST: NumericContent presses show a client MessageToast (original press handler). Two vertical HeaderContainers — one of eight NumericContents, one of five TileContents (each wrapping a` &&
                 ` NumericContent) — reproduced 1:1.`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.IconTabBar`                    name = `IconTabBarStretchContent`            class = `z2ui5_cl_ai_app_030` path = `src/01/b04/z2ui5_cl_ai_app_030.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed); incl. the phone-emulation device> check`
        notes = `NOTE: the original binds expanded="{device>/isNoPhone}" (a demo-kit helper model); expressed over the framework's device> model as the expression {= !${device>/system/phone} } - same truth value,` &&
                 ` different binding text. Confirmed on desktop and phone emulation in the 2026-07-20 live check.`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.IconTabHeader`                 name = `IconTabHeader`                       class = `z2ui5_cl_ai_app_055` path = `src/01/b07/z2ui5_cl_ai_app_055.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.15` )
      ( module = `sap.m`              control = `sap.m.Image`                         name = `ImageModeBackground`                 class = `z2ui5_cl_ai_app_031` path = `src/01/b01/z2ui5_cl_ai_app_031.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed); incl. the phone-emulation device> check`
        notes = `IMPROVISED: the original binds src/mode to a JSONModel (img>/products, /imageMode); these fixed sample values are inlined here as literals (mode Background, the HT-7777 / HT-6100 demo images).` &&
                 ` height/width are restored over the device> model, see below. // NOTE: the custom CSS class imageContainer (light blue background) of the box4 HBox is kept and the sample's styles.css injected via a` &&
                 ` core:HTML content attribute (CAPABILITIES.md CSS row, as apps 028/026; the EXTRA core:HTML control vs the original view). Confirmed rendering via the human visual pass 2026-07-19.` )
      ( module = `sap.m`              control = `sap.m.ImageContent`                  name = `ImageContent`                        class = `z2ui5_cl_ai_app_056` path = `src/01/b07/z2ui5_cl_ai_app_056.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.38`
        notes = `NOTE: the profile-image and logo ImageContent keep the sample's original demokit test-resources asset paths (test-resources/sap/m/demokit/sample/ImageContent/images/*.png) as the src literal 1:1;` &&
                 ` abap2UI5 does not serve those static assets, so only the first (sap-icon://area-chart) icon renders offline. The images are archived under ui5/sap.m/ImageContent/images/.`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.Input`                         name = `InputTypes`                          class = `z2ui5_cl_ai_app_159` path = `src/01/b16/z2ui5_cl_ai_app_159.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: Five Inputs demonstrating the input types Text / Email / Tel / Number / Url with labelFor Labels, reproduced 1:1.` )
      ( module = `sap.m`              control = `sap.m.Input`                         name = `InputValueState`                     class = `z2ui5_cl_ai_app_032` path = `src/01/b02/z2ui5_cl_ai_app_032.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        release = `1.94`
        release_post171 = abap_true
        is_post171 = abap_true
        notes = `POST-1.71: showClearIcon (since UI5 1.94) on three inputs is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.94 to render it. // POST-1.71: the two formattedValueStateText` &&
                 ` aggregations (a FormattedText carrying Links, since UI5 1.78) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.78 to render them. // NOTE: the Links' press` &&
                 ` (.onFormattedTextLinkPress) round-trips as event LINK_PRESS and shows the controller's toast text, docked at CenterCenter 1:1 via message_toast_display( my = 'center center' at = 'center center' )` &&
                 ` (the client method exposes the MessageToast options object - source-verified in Messages.js). The original's preventDefault is not needed: the Links carry no href, so there is no default navigation` &&
                 ` to suppress.`
        post171 = `showClearIcon (since UI5 1.94) on three inputs is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.94 to render it. // the two formattedValueStateText aggregations (a` &&
                 ` FormattedText carrying Links, since UI5 1.78) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.78 to render them.` )
      ( module = `sap.m`              control = `sap.m.InputListItem`                 name = `InputListItem`                       class = `z2ui5_cl_ai_app_057` path = `src/01/b07/z2ui5_cl_ai_app_057.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` )
      ( module = `sap.m`              control = `sap.m.InputModelUpdate`              name = `InputModelUpdate`                    class = `z2ui5_cl_ai_app_102` path = `src/01/b12/z2ui5_cl_ai_app_102.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        ui5_only = abap_true
        notes = `IMPROVISED: The original demonstrates late binding of an Input over an OData v2 mock server: fnRebind calls view.bindElement('/Employees(1)') and, on dataReceived (~3s), rebinds the input to FirstName` &&
                 ` if the value is still untouched. abap2UI5 has no ODataModel roundtrip here, so the OData mock is reduced to ABAP: the button starts a 3s timer (cs_event-start_timer) and the callback sets the bound` &&
                 ` value to the Employees(1) FirstName ('Nancy') only when the input still equals its initial value ('Martin'), reproducing the initialValue===currentValue guard. // NOTE: The input value is a two-way` &&
                 ` binding on the single default model (the original's named 'initialData' JSONModel /currentValue is flattened). liveChange is wired but the current value already flows back via the two-way binding on` &&
                 ` each roundtrip, so the handler is a no-op (the original setProperty('/currentValue', ...) keeps it live between keystrokes).`
        use_fua = abap_true
        use_fua_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.Label`                         name = `LabelProperties`                     class = `z2ui5_cl_ai_app_058` path = `src/01/b07/z2ui5_cl_ai_app_058.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `IMPROVISED: the four controller handlers (onDisplayOnlyChange/onWrappingChange/onHyphenationChange/onWidthChange) are replaced by a roundtrip-free binding model, so the Switch ``change`` and Slider` &&
                 ` ``liveChange`` event attributes are dropped: the three Switches bind their ``state`` two-way to display_only/wrapping/hyphenation, the two result Labels bind ``displayOnly`` and ``wrapping`` to the` &&
                 ` same variables, and ``wrappingType`` (added on the two Labels, not present in the sample view) plus both container ``width`` values derive live via ``{= }`` expression bindings (wrappingType =` &&
                 ` hyphenation ? 'Hyphenated' : 'Normal'; width = slider_value + '%'). Same technique as app 007.` )
      ( module = `sap.m`              control = `sap.m.LightBox`                      name = `LightBox`                            class = `z2ui5_cl_ai_app_059` path = `src/01/b07/z2ui5_cl_ai_app_059.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: the Image src and LightBoxItem imageSrc keep the sample's original demokit sdk asset paths (test-resources/sap/ui/documentation/sdk/images/...) as literals 1:1; abap2UI5 does not serve those` &&
                 ` static assets, so the thumbnails/large images do not display offline. The LightBox still opens on image click (built-in Image.detailBox behaviour, no controller). The last item deliberately points` &&
                 ` imageSrc at a non-existent file to show the LightBox load-error state, exactly as in the sample. // NOTE: the six identical filler paragraphs use the same ABAP literal via a local ``lorem`` variable;` &&
                 ` XML attribute whitespace (newlines/tabs in the sample's indented multi-line text) is normalised to single spaces (visually identical).` )
      ( module = `sap.m`              control = `sap.m.Link`                          name = `Link`                                class = `z2ui5_cl_ai_app_160` path = `src/01/b16/z2ui5_cl_ai_app_160.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        notes = `LIVE-TEST: The 'Open message box' / 'Show more information' link presses show a client MessageToast (original handleLinkPress opened a MessageBox). Six Links across two layouts — plain, disabled,` &&
                 ` href/target, and icon/endIcon variants — reproduced 1:1.`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.Link`                          name = `LinkEmphasized`                      class = `z2ui5_cl_ai_app_033` path = `src/01/b01/z2ui5_cl_ai_app_033.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        checked = `CHECKED (2026-07-19): verified in a running system - human visual pass 2026-07-19 over all apps: the Currency composite binding renders the formatted price per currency (raw binding-info string over` &&
                 ` PRICE TYPE p).`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.List`                          name = `ListCounter`                         class = `z2ui5_cl_ai_app_034` path = `src/01/b04/z2ui5_cl_ai_app_034.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        release = `1.117`
        release_post171 = abap_true
        is_post171 = abap_true
        checked = `CHECKED (2026-07-21): verified in a running system - human visual check 2026-07-21: the Products list renders the 11 rows with their Quantity counters (display-only app, no interaction to exercise).`
        notes = `POST-1.71: headerLevel="H2" on the List (since UI5 1.117) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.117 to render it.`
        post171 = `headerLevel="H2" on the List (since UI5 1.117) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.117 to render it.`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.List`                          name = `ListNoData`                          class = `z2ui5_cl_ai_app_035` path = `src/01/b04/z2ui5_cl_ai_app_035.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` )
      ( module = `sap.m`              control = `sap.m.MaskInput`                     name = `MaskInput`                           class = `z2ui5_cl_ai_app_153` path = `src/01/b15/z2ui5_cl_ai_app_153.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34.0`
        notes = `NOTE: Six MaskInputs across two SimpleForms with mask/placeholderSymbol/placeholder and MaskInputRule (maskFormatSymbol/regex) sub-rules; the {/showClearIcon} bindings are wired to a boolean model` &&
                 ` field (initial true), reproducing the original.` )
      ( module = `sap.m`              control = `sap.m.Menu`                          name = `Menu`                                class = `z2ui5_cl_ai_app_060` path = `src/01/b07/z2ui5_cl_ai_app_060.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        release = `1.84`
        release_post171 = abap_true
        is_post171 = abap_true
        checked = `CHECKED (2026-07-22): verified in a running system 2026-07-22: the Menu opens anchored to the button (openBy) and the selected item text resolves via ${$parameters>/item}.getText().`
        notes = `POST-1.71: Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it. // IMPROVISED: the sample loads the Menu from` &&
                 ` Menu.fragment.xml on first press and toggles it in the controller (oMenu.isOpen() ? close() : openBy(button)). The port declares the Menu 1:1 inside the Button's ``dependents`` aggregation and` &&
                 ` toggles it via client->roundtrip-free _event_client( cs_event-control_by_id, toggleBy ) anchored to the button's DOM ref ($event.oSource.sId) - toggleBy (open-if-closed / close-if-open) was added` &&
                 ` upstream 2026-07-20 (pr/menu-toggle-openby) precisely so the client-side open state need not be mirrored server-side, making the press-to-toggle 1:1. Frontend-action pattern as app 016. //` &&
                 ` IMPROVISED: onMenuAction builds a breadcrumb path by walking the selected MenuItem's parent chain (e.g. 'Create New Site > Official Store'); the server cannot walk the client-side control tree, so` &&
                 ` the toast shows only the selected item's own text, transported via ${$parameters>/item}.getText(). // NOTE: the selected item's text is read with ${$parameters>/item}.getText() (a method call on the` &&
                 ` resolved MenuItem control), NOT ${$parameters>/item/text}: the $parameters model exposes 'item' as the control object and UI5 keeps properties in the control's internal property store, so the path` &&
                 ` .../item/text reads an undefined direct field and the toast arrives empty. // NOTE: live-verified 2026-07-22 - confirm in a running system that the Menu opens anchored to the button (openBy) and that` &&
                 ` ${$parameters>/item}.getText() delivers the clicked MenuItem's text to the toast. // NOTE: the Menu open/close is wired roundtrip-free via client->_event_client( cs_event-control_by_id, toggleBy ) on` &&
                 ` the button press (anchored by $event.oSource.sId) - the original's client-side toggle 1:1; the item-selected toast is now roundtrip-free too, composed on the frontend via control_global` &&
                 ` MESSAGE_TOAST.show (template + ${$parameters>/item}.getText()), so the app has no on_event at all (init-only). // LIVE-TEST: the menu toggle was switched from a follow_up_action round-trip to` &&
                 ` roundtrip-free _event_client on 2026-07-22 - re-verify the button opens/closes the Menu. // LIVE-TEST: the item-selected toast was switched from a message_toast_display round-trip to a roundtrip-free` &&
                 ` client-composed toast on 2026-07-22 (control_global MESSAGE_TOAST.show, template ``Action triggered on item: {0}`` filled by ${$parameters>/item}.getText()) - re-verify selecting a menu item toasts` &&
                 ` "Action triggered on item: <text>".`
        post171 = `Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it.`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.MenuButton`                    name = `MenuButton`                          class = `z2ui5_cl_ai_app_061` path = `src/01/b07/z2ui5_cl_ai_app_061.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        release = `1.94`
        release_post171 = abap_true
        is_post171 = abap_true
        checked = `CHECKED (2026-07-22): verified in a running system 2026-07-22: itemSelected/press/defaultAction/beforeMenuOpen all fire their toasts and the item text resolves.`
        notes = `POST-1.71: the MenuButton ``beforeMenuOpen`` event (since UI5 1.94) is kept 1:1 on the split-mode buttons that use it. menuPosition (1.56), buttonMode and useDefaultActionOnly are <= 1.71. //` &&
                 ` IMPROVISED: onMenuAction builds a breadcrumb path by walking the selected MenuItem's parent chain (e.g. 'basic > add'); the server cannot walk the client-side control tree, so the toast shows only` &&
                 ` the selected item's own text, transported via ${$parameters>/item}.getText(). // NOTE: onPress toasts the pressed MenuItem's control id (the sample's evt.getSource().getId() + ' Pressed'),` &&
                 ` transported via $event.oSource.sId. The Edit item's core:CustomData (key=target, value=p1) is kept 1:1 as inert view metadata. // NOTE: the selected item's text is read with` &&
                 ` ${$parameters>/item}.getText() (a method call on the resolved MenuItem control), NOT ${$parameters>/item/text}: the $parameters model exposes 'item' as the control object and UI5 keeps properties in` &&
                 ` the control's internal property store, so the path .../item/text reads an undefined direct field and the toast arrives empty. // NOTE: live-verified 2026-07-22 - confirm in a running system that` &&
                 ` itemSelected/press/defaultAction/beforeMenuOpen all fire their toasts and that ${$parameters>/item}.getText() delivers the selected MenuItem text. // LIVE-TEST: all toasts were switched from` &&
                 ` message_toast_display round-trips to roundtrip-free client-composed control_global toasts on 2026-07-22 (the app is now init-only) - re-verify each button/menu still toasts its text.`
        post171 = `the MenuButton ``beforeMenuOpen`` event (since UI5 1.94) is kept 1:1 on the split-mode buttons that use it. menuPosition (1.56), buttonMode and useDefaultActionOnly are <= 1.71.`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.MessageBox`                    name = `MessageBoxInitialFocus`              class = `z2ui5_cl_ai_app_036` path = `src/01/b03/z2ui5_cl_ai_app_036.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.21.2`
        release = `1.124`
        release_post171 = abap_true
        is_post171 = abap_true
        notes = `NOTE: the sample opens a sap.m.MessageBox from its controller; there is no such control in the view. It is driven by two buttons wired to events that call client->message_box_display - the documented` &&
                 ` 1:1 path (CAPABILITIES.md marks sap.m.MessageBox as expressible with app 036 as its evidence port), not a workaround. // POST-1.71: ariaHasPopup="Dialog" on both buttons (since UI5 1.84) is newer` &&
                 ` than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it. // POST-1.71: the MessageBox emphasizedAction option (since UI5 1.75) is newer than 1.71 but kept for the 1:1` &&
                 ` port - the app needs a UI5 release >= 1.75 to render it. // POST-1.71: the MessageBox dependentOn option (since UI5 1.124) is restored via message_box_display's dependenton parameter, pointing at the` &&
                 ` view layout (id messageBoxHost); the app needs a UI5 release >= 1.124 to render it.`
        post171 = `ariaHasPopup="Dialog" on both buttons (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it. // the MessageBox emphasizedAction option (since` &&
                 ` UI5 1.75) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.75 to render it. // the MessageBox dependentOn option (since UI5 1.124) is restored via message_box_display's` &&
                 ` dependenton parameter, pointing at the view layout (id messageBoxHost); the app needs a UI5 release >= 1.124 to render it.` )
      ( module = `sap.m`              control = `sap.m.MessagePopover`                name = `MessagePopover`                      class = `z2ui5_cl_ai_app_066` path = `src/01/b08/z2ui5_cl_ai_app_066.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        since = `1.28`
        release = `1.84`
        release_post171 = abap_true
        is_post171 = abap_true
        checked = `CHECKED (2026-07-22): verified in a running system 2026-07-22: the button toggles the MessagePopover open/closed (toggleBy) and lists the five messages.`
        notes = `POST-1.71: Button.ariaHasPopup (since UI5 1.84) kept on the message-popover button. The Button.type value 'Negative' (a sap.m.ButtonType value since 1.73) is what the sample's buttonTypeFormatter` &&
                 ` returns for the highest-severity Error message. // IMPROVISED: the MessagePopover (built in the controller and addDependent'ed to the button) is declared 1:1 in the button's ``dependents``` &&
                 ` aggregation; the controller's oMessagePopover.toggle(button) becomes a roundtrip-free client->_event_client( cs_event-control_by_id, toggleBy ) on the button press (anchored by id), and` &&
                 ` onActiveTitlePress's MessageToast.show becomes a roundtrip-free client->_event_client( cs_event-control_global, MESSAGE_TOAST/show ); the app is now init-only (no on_event). Previously` &&
                 ` client->follow_up_action( cs_event-control_by_id, toggleBy ) anchored to the button's DOM ref ($event.oSource.sId) - open-if-closed / close-if-open. // NOTE: the sample's three severity formatters` &&
                 ` (buttonIconFormatter/buttonTypeFormatter/highestSeverityMessages) compute the button icon/type/count from the highest-severity message; the mock data is static, so the results are precomputed in ABAP` &&
                 ` (error icon, Negative type, count 2 for the two Error messages) and bound as scalars. The sample's root-array JSON model (items path '/') is carried under a /T_MESSAGES field of the single default` &&
                 ` model. // NOTE: live-verified 2026-07-22 - confirm in a running system that the button toggles the MessagePopover open/closed (toggleBy) and lists the five messages with their MessageItem link, and` &&
                 ` that activeTitlePress toasts on the active (first Error) title. // LIVE-TEST: the toggle and the active-title toast were switched from server round-trips to roundtrip-free _event_client(` &&
                 ` control_global / control_by_id ) on 2026-07-22 - re-verify in a running system that the button still toggles the MessagePopover and that pressing an active title still toasts.`
        post171 = `Button.ariaHasPopup (since UI5 1.84) kept on the message-popover button. The Button.type value 'Negative' (a sap.m.ButtonType value since 1.73) is what the sample's buttonTypeFormatter returns for the` &&
                 ` highest-severity Error message.`
        use_ec = abap_true
        use_ec_arg = abap_true
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.MessagePopover`                name = `MessagePopoverAsyncMessageHandling`  class = `z2ui5_cl_ai_app_067` path = `src/01/b08/z2ui5_cl_ai_app_067.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        since = `1.28`
        release = `1.84`
        release_post171 = abap_true
        is_post171 = abap_true
        checked = `CHECKED (2026-07-22): verified in a running system 2026-07-22: the button toggles the MessagePopover (toggleBy) and the first Error message renders its HTML markupDescription.`
        notes = `POST-1.71: Button.ariaHasPopup (since UI5 1.84) kept on the message-popover button; the Button.type value 'Negative' is a sap.m.ButtonType value since 1.73. MessageItem.markupDescription (renders the` &&
                 ` HTML description) is kept for the async sample's rich-text messages. // IMPROVISED: the MessagePopover (built in the controller) is declared 1:1 in the button's ``dependents``; the controller's` &&
                 ` toggle(button) becomes a roundtrip-free client->_event_client( cs_event-control_by_id, toggleBy ) on the button press (anchored by id), and onActiveTitlePress's MessageToast.show becomes` &&
                 ` roundtrip-free client->_event_client( cs_event-control_global, MESSAGE_TOAST/show ); the app is now init-only. Anchored to $event.oSource.sId. // IMPROVISED: the sample's` &&
                 ` oMessagePopover.setAsyncURLHandler(...) - a client-side JS callback that asynchronously validates each link URL (disabling absolute http links, allowing relative ones) before navigation - has no` &&
                 ` abap2UI5 equivalent and is dropped; the messages and their markupDescription HTML (with the two demo <a> links) render, but the async URL-validation gate is not reproduced. // NOTE: the three` &&
                 ` severity formatters are precomputed in ABAP from the static mock (error icon, Negative type, count 2); the root-array JSON model is carried under /T_MESSAGES on the single default model. // NOTE:` &&
                 ` live-verified 2026-07-22 - confirm the button toggles the MessagePopover (toggleBy) and the first Error message renders its HTML markupDescription (h2/p/ul/ol + links); activeTitlePress toasts. //` &&
                 ` LIVE-TEST: the toggle and the active-title toast were switched to roundtrip-free _event_client on 2026-07-22 - re-verify the button toggles the MessagePopover and an active title toasts.`
        post171 = `Button.ariaHasPopup (since UI5 1.84) kept on the message-popover button; the Button.type value 'Negative' is a sap.m.ButtonType value since 1.73. MessageItem.markupDescription (renders the HTML` &&
                 ` description) is kept for the async sample's rich-text messages.`
        use_ec = abap_true
        use_ec_arg = abap_true
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.MessagePopover`                name = `MessagePopoverMessageHandling`       class = `z2ui5_cl_ai_app_065` path = `src/01/b08/z2ui5_cl_ai_app_065.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        since = `1.28`
        release = `1.84`
        release_post171 = abap_true
        is_post171 = abap_true
        checked = `CHECKED (2026-07-21): verified in a running system - human live check 2026-07-21: startup toast at native height; Save opens the MessagePopover with 3 Errors + 1 Warning marking John Miller (Name) /` &&
                 ` Stefan Bosch (ZIP) / Maria Fontes (Email) + employment weekly hours; group headers Personal, Information / Personal, Contact; message-title press scrolls to and focuses the field; toggleBy` &&
                 ` opens/closes. Known cosmetic gap: the injected non-numeric ZIP shows empty (not "AAA") because the Integer-typed field cannot format it via the model->view path.`
        notes = `POST-1.71: two post-1.71 members are kept for the 1:1 port: Button.ariaHasPopup (since UI5 1.84) on the MessagePopover button, and MessagePopover.groupItems (since UI5 1.73). // IMPROVISED: the` &&
                 ` controller's manual MessageManager handling is replaced by two framework mechanisms: (1) the typed value bindings with constraints (sap.ui.model.type.Integer/String, ZIP_CODE Integer, WEEKLYHOURS` &&
                 ` Integer maximum 40, EMAIL search regex) collect/clear their validation messages AUTOMATICALLY into the message> model (no app code) - replacing onChange/handleRequiredField/checkInputConstraints; (2)` &&
                 ` app-authored messages go through the new z2ui5.cc.MessageManager companion control (items bound to /T_MESSAGES), which reconciles them into the message manager with a target + processor. Save ports` &&
                 ` generateInvalidUserInput 1:1 in effect: since abap2UI5 auto-collects validation messages only from USER input (not from programmatically-set model values), Save INJECTS the four demo issues on the` &&
                 ` SAME rows the original targets (formContainer.getItems()[4/5/6] = John Miller Name empty, Stefan Bosch ZIP 'AAA', Maria Fontes email malformed, plus the employment weekly hours 400) AND authors the` &&
                 ` matching four messages (3 Errors + 1 Warning) with their /T_FORMS/4|5|6 and /T_EMPLOYMENT/0 targets, then opens the MessagePopover via follow_up_action( control_by_id openBy ) anchored to` &&
                 ` messagePopoverBtn. // IMPROVISED: the sample's nested JSON model (street/name, zip/code, phone/number) is flattened into a flat ABAP row (STREET_NAME, ZIP_CODE, PHONE_NUMBER, ...) - abap2UI5 serves` &&
                 ` one default model; the bindings use the flattened field names. The three f:ColumnElementData layoutData hints (cellsSmall/cellsLarge column spans on the street-number, zip-code and one employment` &&
                 ` Input) are dropped - responsive-span cosmetics with no data/behaviour. // 1.71: controller-only pieces with no view/binding equivalent are dropped:` &&
                 ` buttonIconFormatter/buttonTypeFormatter/highestSeverityMessages (the button's severity-based icon/type/count) is reduced to text={=${message>/}.length}, type=Emphasized; core:CommandExecution (the` &&
                 ` Ctrl+Shift+M focus shortcut); isPositionable. // NOTE: the controller's handleMessagePopoverPress (this.oMP.toggle(oEvent.getSource())) becomes a roundtrip-free client->_event_client(` &&
                 ` cs_event-control_by_id, toggleBy ) wired on the button press (anchored to the button by its id 'messagePopoverBtn'), matching the original's client-side toggle 1:1 - no SHOW_MESSAGES round-trip's DOM` &&
                 ` ref ($event.oSource.sId), the MessagePopover carrying id=messagePopover - open-if-closed / close-if-open, same frontend-action pattern as apps 066/067. // NOTE: all 8 forms of the mock` &&
                 ` FormsModel.json are loaded verbatim (Julie Armstrong, Denise Smith, Richard Wilson, Gerd Becker, John Miller with the built-in invalid ZIP AAA, Stefan Bosch, Maria Fontes with empty email + malformed` &&
                 ` website, Antonio Ferrari) plus the single employment row - the full data set, not a subset. // NOTE: activeTitlePress scroll-to-control navigation is RESTORED (activeTitle=true): pressing a message` &&
                 ` title fires ACTIVE_TITLE with the message's target control id (${$parameters>/item}.getBindingContext('message').getObject().getControlIds()[0]), and the handler runs follow_up_action(` &&
                 ` scroll_into_view ) + control_by_id close + set_focus on it - the 1:1 equivalent of the sample's scrollToElement + close + focus. Needs the upstream fix that lets SET_FOCUS/SCROLL_INTO_VIEW resolve a` &&
                 ` fully-qualified control id (resolveById), since a UI5 Message carries the view-prefixed id. // NOTE: onInit's MessageToast.show('Press "Save" to trigger validation.') is ported as` &&
                 ` client->message_toast_display( ... ) in the check_on_init branch. // NOTE: MessageItem grouping (groupItems=true + the 'Personal, <section>' group headers) is RESTORED: the original derives groupName` &&
                 ` in its controller (getGroupName). That is a domain classification, so - abap2UI5 being a thin frontend - it is computed in the ABAP backend (COND on additionaltext: Email -> 'Personal, Contact', else` &&
                 ` 'Personal, Information') and carried on the Message code field (sap.ui.core.message.Message has no groupName slot), bound groupName="{message>code}" - no frontend expression. Only Email sits in the` &&
                 ` Contact group, all others in Information, matching the original's headers.`
        post171 = `two post-1.71 members are kept for the 1:1 port: Button.ariaHasPopup (since UI5 1.84) on the MessagePopover button, and MessagePopover.groupItems (since UI5 1.73).`
        use_ec = abap_true
        use_ec_arg = abap_true
        use_fua = abap_true
        use_fua_arg = abap_true
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.MessageStrip`                  name = `MessageStripWithEnableFormattedText` class = `z2ui5_cl_ai_app_062` path = `src/01/b07/z2ui5_cl_ai_app_062.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.30`
        release = `1.129`
        release_post171 = abap_true
        is_post171 = abap_true
        notes = `POST-1.71: the MessageStrip ``controls`` aggregation (since UI5 1.129) is kept 1:1 for the fifth strip's %%0/%%1/%%2 multi-link formatted text (three sap.m.Link). enableFormattedText itself is since` &&
                 ` 1.50 (<= 1.71). // POST-1.71: core:require="{Formatter: 'z2ui5/model/formatter'}" wires the curated formatter module (since UI5 1.74) so the inlineIconsHelper strip can use` &&
                 ` Formatter.expandInlineIcons; the two added namespace decls (xmlns:core, core:require on the view root) are not in the sample view. // NOTE: the sample's controller builds inlineIconsHelper from` &&
                 ` sap.m.MessageStripUtilities.getInlineIcon() concatenations; the port stores the text with %%icon:sap-icon://<name>%% placeholders (the real icon names message-success/sys-enter-2/stethoscope) and` &&
                 ` binds it through formatter 'Formatter.expandInlineIcons' - added upstream 2026-07-20 (pr/formatter-inline-icon), it resolves each glyph via IconPool and emits the same sapMMsgStripInlineIcon markup,` &&
                 ` so no icon codepoints are guessed. The inlineIconsUnicode strip keeps the sample's own literal &#x....; entities 1:1. // NOTE: the sample's JSONModel of static formatted-text strings is rebuilt as` &&
                 ` ABAP string fields on the single default model and bound 1:1 (text={/...}); field names differ from the JSON keys (default->default_text etc.) but values are display-only, so the binding-value diff` &&
                 ` does not apply.`
        post171 = `the MessageStrip ``controls`` aggregation (since UI5 1.129) is kept 1:1 for the fifth strip's %%0/%%1/%%2 multi-link formatted text (three sap.m.Link). enableFormattedText itself is since 1.50 (<=` &&
                 ` 1.71). // core:require="{Formatter: 'z2ui5/model/formatter'}" wires the curated formatter module (since UI5 1.74) so the inlineIconsHelper strip can use Formatter.expandInlineIcons; the two added` &&
                 ` namespace decls (xmlns:core, core:require on the view root) are not in the sample view.` )
      ( module = `sap.m`              control = `sap.m.MessageToast`                  name = `MessageToast`                        class = `z2ui5_cl_ai_app_037` path = `src/01/b03/z2ui5_cl_ai_app_037.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.9.2` )
      ( module = `sap.m`              control = `sap.m.MessageView`                   name = `MessageViewMessageManager`           class = `z2ui5_cl_ai_app_038` path = `src/01/b03/z2ui5_cl_ai_app_038.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.46`
        notes = `NOTE: the original registers its four messages on the sap.ui.core.message.MessageManager and the MessageView binds them via the message> model. abap2UI5 DOES carry the message> model on every view` &&
                 ` slot since pr/message-model (2026-07-18, auto-collecting control validation messages), but there is no ABAP API to push an arbitrary static message set into it - so for this render-only sample the` &&
                 ` messages are bound as a plain ABAP table on MessageView items with a MessageItem template (client->_bind( t_messages )), the path CAPABILITIES.md explicitly endorses for static message sets. Same` &&
                 ` rendering as the original. Proven by the curated sample z2ui5_cl_demo_app_038 (MessageView + MessageItem + MessagePopover over a bound table).`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.MultiComboBox`                 name = `MultiComboBoxGrouping`               class = `z2ui5_cl_ai_app_039` path = `src/01/b02/z2ui5_cl_ai_app_039.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `NOTE: the custom groupHeaderFactory '.getGroupHeader' (controller code) is replaced by UI5's default group headers - the sample's factory builds a SeparatorItem with the group key, which is exactly` &&
                 ` what the default renders anyway (CAPABILITIES.md group-sorter row, source-verified on both sides), so this is a faithful 1:1, not a workaround. The items are a bound template with the original's` &&
                 ` sorter (path SUPPLIER_NAME, group: true) as a raw binding-info string.`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.MultiInput`                    name = `MultiInput`                          class = `z2ui5_cl_ai_app_040` path = `src/01/b02/z2ui5_cl_ai_app_040.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        release = `1.94`
        release_post171 = abap_true
        is_post171 = abap_true
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed); live-checked reference example for: cc control` &&
                 ` (MultiInputExt), bound aggregation, tokens, sorter binding-info`
        notes = `NOTE: the controller's onInit pre-sets the tokens on both MultiInputs (Token 1..6 and one long token); they are declared statically in the view's tokens aggregation instead - same rendering` &&
                 ` (CAPABILITIES.md marks controller-filled aggregations as expressible, the tokens aggregation is public since UI5 1.16), so this is a faithful 1:1, not a workaround. // NOTE: the controller's onInit` &&
                 ` addValidator on multiInput1 and multiInput2 (typing free text + Enter -> new Token({key: text, text})) is wired via the bundled invisible companion control z2ui5.cc.MultiInputExt` &&
                 ` (xmlns:z2ui5="z2ui5.cc"): one MultiInputExt per input, referencing it by MultiInputId - the control installs exactly the original's validator (source-verified in app/webapp/cc/MultiInputExt.js). The` &&
                 ` two MultiInputExt elements are extra vs the original view.xml (there the validator lives in the controller); first cc-control usage in these ports (converted 2026-07-18). // NOTE: The original's` &&
                 ` stray placeholder attributes on the two Labels (not a Label property) are dropped. // POST-1.71: showClearIcon (since UI5 1.94) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5` &&
                 ` release >= 1.94 to render it.`
        post171 = `showClearIcon (since UI5 1.94) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.94 to render it.`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.NewsContent`                   name = `NewsContent`                         class = `z2ui5_cl_ai_app_063` path = `src/01/b07/z2ui5_cl_ai_app_063.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.NotificationListGroup`         name = `NotificationListGroup`               class = `z2ui5_cl_ai_app_077` path = `src/01/b09/z2ui5_cl_ai_app_077.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        notes = `IMPROVISED: static notifications: onItemClose's client-side removeItem is not mirrored (toast only); group 3's onAcceptErrors is simplified to the accept toast. // NOTE: the original's` &&
                 ` showCloseButton="falseue" typo on two items is corrected to false, otherwise UI5 boolean parsing rejects it.`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.NotificationListItem`          name = `NotificationListItem`                class = `z2ui5_cl_ai_app_076` path = `src/01/b09/z2ui5_cl_ai_app_076.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.34`
        notes = `IMPROVISED: the notifications are static (not model-bound), so onItemClose's client-side removeItem is not mirrored (close fires a toast only); onErrorPress's setProcessingMessage MessageStrip on the` &&
                 ` item is shown as a toast. // LIVE-TEST: all toasts were switched to roundtrip-free client-composed control_global toasts on 2026-07-22 (the app is now init-only) - re-verify` &&
                 ` press/close/accept/reject/error each toast their text.`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.NumericContent`                name = `NumericContentDifColors`             class = `z2ui5_cl_ai_app_156` path = `src/01/b15/z2ui5_cl_ai_app_156.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        notes = `LIVE-TEST: The NumericContent / GenericTile presses show a client MessageToast ('The numeric content is pressed.'), matching the original press handler. Four NumericContents (value colors` &&
                 ` Good/Critical/Error, indicators) plus a GenericTile > TileContent > NumericContent are reproduced 1:1.`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.NumericContent`                name = `NumericContentIcon`                  class = `z2ui5_cl_ai_app_064` path = `src/01/b07/z2ui5_cl_ai_app_064.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        notes = `NOTE: the second NumericContent keeps the sample's original demokit test-resources image path (test-resources/sap/m/demokit/sample/NumericContentIcon/images/grass.jpg) as the icon literal 1:1;` &&
                 ` abap2UI5 does not serve that static asset, so it does not render offline (the first tile's sap-icon://travel-expense does). The image is archived under ui5/sap.m/NumericContentIcon/images/.`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.ObjectAttribute`               name = `ObjectAttributes`                    class = `z2ui5_cl_ai_app_073` path = `src/01/b09/z2ui5_cl_ai_app_073.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.12`
        release = `1.97`
        release_post171 = abap_true
        is_post171 = abap_true
        notes = `NOTE: element binding kept 1:1 - the two display ObjectAttributes bind a one-record structure /S_PRODUCT instead of {/ProductCollection/0}; record 0 fields verbatim. // IMPROVISED:` &&
                 ` handleSAPLinkPressed's URLHelper.redirect maps to the URLHELPER REDIRECT frontend action (cs_event-urlhelper); handleFeedbacklinkPressed's Dialog (a RatingIndicator + TextArea with Submit/Cancel` &&
                 ` Button) is rebuilt via popup_display, the Submit button's 2s setBusy delay dropped. // POST-1.71: ObjectAttribute.ariaHasPopup (since UI5 1.97) is kept 1:1 on the feedback attribute; needs UI5 >=` &&
                 ` 1.97.`
        post171 = `ObjectAttribute.ariaHasPopup (since UI5 1.97) is kept 1:1 on the feedback attribute; needs UI5 >= 1.97.`
        use_ec = abap_true
        use_ec_arg = abap_true
        use_popup = abap_true
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.ObjectHeader`                  name = `ObjectHeader`                        class = `z2ui5_cl_ai_app_041` path = `src/01/b01/z2ui5_cl_ai_app_041.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        checked = `CHECKED (2026-07-19): verified in a running system - human visual pass 2026-07-19 over all apps: the element binding {/S_PRODUCT} resolves all relative field bindings incl. the Currency number - the` &&
                 ` ObjectHeader renders fully populated.`
        notes = `NOTE: the ObjectHeader keeps the original element binding and relative field bindings 1:1 (title, numberUnit, the ObjectAttribute composite texts and the sap.ui.model.type.Currency number binding);` &&
                 ` only the binding context path changes - a one-record structure /S_PRODUCT in the default model instead of {/ProductCollection/0}, since the port does not carry the whole collection. // NOTE: the` &&
                 ` model holds exactly the bound record /ProductCollection/0 (Notebook Basic 15) of ui5/mock/products.json, verbatim - this is the original sample's own single-record binding {/ProductCollection/0}, not` &&
                 ` a shortened data set. // NOTE: the active ObjectAttribute 'www.sap.com' opens via the URLHELPER REDIRECT frontend action (cs_event-urlhelper, { URL, NEW_WINDOW } object param) - not open_new_tab,` &&
                 ` which is same-origin-only.`
        use_ec = abap_true
        use_ec_arg = abap_true
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.ObjectIdentifier`              name = `ObjectIdentifier`                    class = `z2ui5_cl_ai_app_071` path = `src/01/b09/z2ui5_cl_ai_app_071.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        notes = `NOTE: element binding kept 1:1 - the VerticalLayout binds a one-record structure /S_PRODUCT in the default model instead of {/ProductCollection/0}; titleClicked's MessageBox.alert becomes` &&
                 ` message_box_display. // NOTE: the model holds exactly the bound record /ProductCollection/0 (Notebook Basic 15) of ui5/mock/products.json, verbatim - the original's own single-record binding.`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.ObjectListItem`                name = `ObjectListItem`                      class = `z2ui5_cl_ai_app_074` path = `src/01/b09/z2ui5_cl_ai_app_074.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.12`
        notes = `IMPROVISED: the ObjectStatus '.formatter.status' (Status -> ValueState) is precomputed into the STATUS_STATE model field (Available->Success, Out of Stock->Warning, Discontinued->Error, else None). //` &&
                 ` LIVE-TEST: the press toast was switched to a roundtrip-free client-composed toast on 2026-07-22 (control_global MESSAGE_TOAST.show, template ``Pressed : {0}`` filled by ${NAME}; on_event dropped,` &&
                 ` init-only) - re-verify pressing an item toasts "Pressed : <name>".`
        use_ec = abap_true
        use_ec_arg = abap_true
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.ObjectNumber`                  name = `ObjectNumber`                        class = `z2ui5_cl_ai_app_072` path = `src/01/b09/z2ui5_cl_ai_app_072.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        release = `1.86`
        release_post171 = abap_true
        is_post171 = abap_true
        notes = `NOTE: the original binds records {/ProductCollection/0..5} of the shared mock; the port carries exactly those 6 records as a default-model table T_PRODUCTS and element-binds each ObjectNumber to` &&
                 ` /T_PRODUCTS/0..5 (index binding), Price+CurrencyCode verbatim. // POST-1.71: ObjectNumber.inverted, ObjectNumber.active and ObjectNumber.press (all since UI5 1.86) are kept 1:1 for the` &&
                 ` inverted/interactive variants; needs UI5 >= 1.86.`
        post171 = `ObjectNumber.inverted, ObjectNumber.active and ObjectNumber.press (all since UI5 1.86) are kept 1:1 for the inverted/interactive variants; needs UI5 >= 1.86.`
        use_ec = abap_true
        use_ec_arg = abap_true
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.ObjectStatus`                  name = `ObjectStatus`                        class = `z2ui5_cl_ai_app_042` path = `src/01/b01/z2ui5_cl_ai_app_042.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a` &&
                 ` close look.`
        release = `1.120`
        release_post171 = abap_true
        is_post171 = abap_true
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `POST-1.71: the ObjectStatus state values Indication06-Indication08 (since UI5 1.75) and Indication09-Indication20 (since UI5 1.120) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5` &&
                 ` release >= 1.120 to render them all (>= 1.75 for Indication06-Indication08). // NOTE: the active status press opens the controller-built Dialog 1:1 (core:FragmentDefinition + popup_display): the` &&
                 ` Dialog with its VBox, the two content Texts (one EXTRA Text vs the original view) and the Close Button are EXTRA controls vs the archived view.xml, which only holds the ObjectStatus rows. Confirmed` &&
                 ` working in the 2026-07-20 live check.`
        post171 = `the ObjectStatus state values Indication06-Indication08 (since UI5 1.75) and Indication09-Indication20 (since UI5 1.120) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >=` &&
                 ` 1.120 to render them all (>= 1.75 for Indication06-Indication08).`
        use_ec = abap_true
        use_popup = abap_true )
      ( module = `sap.m`              control = `sap.m.OverflowToolbar`               name = `ToolbarDesign`                       class = `z2ui5_cl_ai_app_086` path = `src/01/b10/z2ui5_cl_ai_app_086.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.28`
        notes = `IMPROVISED: the Select ``change`` handlers onSelectDesign/onSelectStyle (setDesign/setStyle) become two-way bound design/style; bActionContext (design != Info) becomes an expression binding on the` &&
                 ` Buttons' visible.`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.OverflowToolbar`               name = `ToolbarResponsive`                   class = `z2ui5_cl_ai_app_163` path = `src/01/b17/z2ui5_cl_ai_app_163.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16`
        notes = `NOTE: The original drives the footer toolbar button visibility from a separate 'range' media JSON model ({range>/isNoPhone}, isNotPhoneOrTablet, isTablet, isPhoneOrTablet). abap2UI5 has one default` &&
                 ` model, so the flags live flat in it and visible binds them directly - the 'range>' prefix is dropped; the last path segment is identical, which structural-diff matches. Values use the desktop media` &&
                 ` ranges (the original filled them from Device.media - a client-only decision). Button presses show client toasts (original onPress/onOpen).`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.Page`                          name = `PageStandardClasses`                 class = `z2ui5_cl_ai_app_089` path = `src/01/b11/z2ui5_cl_ai_app_089.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: element binding kept 1:1 - a one-record structure /S_PRODUCT instead of {/ProductCollection/0}; the IconTabBar expanded stays bound to {device>/isNoPhone} (runtime device model).`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.Panel`                         name = `PanelExpanded`                       class = `z2ui5_cl_ai_app_043` path = `src/01/b04/z2ui5_cl_ai_app_043.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `NOTE: the original controller toggles the third panel imperatively (onOverflowToolbarPress -> oPanel.setExpanded(!oPanel.getExpanded())). Reproduced 1:1 since the whitelist extension (2026-07-18, see` &&
                 ` pr/control-call-whitelist): the TOOLBAR_PRESSED handler inverts a server-side mirror of the state and calls the whitelisted setExpanded on the panel via client->follow_up_action(` &&
                 ` cs_event-control_by_id ) - the view no longer carries the improvised two-way ``expanded`` binding, matching the original view.xml exactly.`
        use_fua = abap_true
        use_fua_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.PDFViewer`                     name = `PDFViewerPopup`                      class = `z2ui5_cl_ai_app_044` path = `src/01/b03/z2ui5_cl_ai_app_044.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        since = `1.48`
        release = `1.121`
        release_post171 = abap_true
        is_post171 = abap_true
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `NOTE: the original onInit creates a popup-mode sap.m.PDFViewer and adds it as a view dependent; it is declared 1:1 in the view's mvc:dependents aggregation (an extra PDFViewer element vs the original` &&
                 ` view.xml, which never carries it - there it lives in the controller). onPress' setSource/setTitle/open() becomes a bound source updated per click, the constant title declared in the view, and the` &&
                 ` whitelisted open via client->follow_up_action( cs_event-control_by_id ) after render - popup mode 1:1, the earlier Dialog embedding workaround is gone (whitelist extended upstream 2026-07-18, see` &&
                 ` pr/control-call-whitelist). // IMPROVISED: the per-image JSONModels of onInit (a Source/Preview URL pair per Image) have no server-side equivalent; the Image src (original {/Preview}) is resolved to` &&
                 ` static absolute sdk.openui5.org URLs and the Source travels through the one bound pdf_source field - same family as pr/named-json-models. // POST-1.71: the PDFViewer property isTrustedSource (since` &&
                 ` UI5 1.121, backported to maintenance patches down to 1.71.63; the original controller passes isTrustedSource: true) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.121` &&
                 ` (or a patched maintenance release) to render it.`
        post171 = `the PDFViewer property isTrustedSource (since UI5 1.121, backported to maintenance patches down to 1.71.63; the original controller passes isTrustedSource: true) is newer than 1.71 but kept for the` &&
                 ` 1:1 port - the app needs a UI5 release >= 1.121 (or a patched maintenance release) to render it.`
        use_fua = abap_true
        use_fua_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.PlanningCalendar`              name = `PlanningCalendarSingle`              class = `z2ui5_cl_ai_app_108` path = `src/01/b14/z2ui5_cl_ai_app_108.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        release = `1.74`
        release_post171 = abap_true
        is_post171 = abap_true
        notes = `NOTE: The object-typed calendar date properties (PlanningCalendar.startDate, CalendarAppointment.startDate/endDate) are fed from plain ISO strings in the model and converted at the point of use with` &&
                 ` Formatter.DateCreateObject from the curated module (core:require='{Formatter: z2ui5/model/formatter}'). The original's UI5Date.getInstance(year, month0, day, ...) values are normalized to ISO 1:1` &&
                 ` (month is 0-based; day/month overflow rolled forward exactly as the JS Date constructor does). // NOTE: appointmentSelect / intervalSelect / the ToggleButton toggleDayNamesLine are wired to simple` &&
                 ` toasts. The original opens a MessageBox with the selected appointment title + count, appends a new appointment on interval select, and toggles the day-names line — those interactive behaviors are` &&
                 ` simplified here (the appointment/date event parameters are control references). // POST-1.71: Formatter.DateCreateObject is referenced via core:require, which needs UI5 >= 1.74.` &&
                 ` sap.m.PlanningCalendar itself is since 1.34 (in scope).`
        post171 = `Formatter.DateCreateObject is referenced via core:require, which needs UI5 >= 1.74. sap.m.PlanningCalendar itself is since 1.34 (in scope).`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.Popover`                       name = `PopoverControllingCloseBehavior`     class = `z2ui5_cl_ai_app_094` path = `src/01/b11/z2ui5_cl_ai_app_094.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        release = `1.86`
        release_post171 = abap_true
        is_post171 = abap_true
        notes = `POST-1.71: Link.ariaHasPopup (since 1.86) is kept 1:1 on the popover link; needs UI5 >= 1.86. // IMPROVISED: the row Popover reproduces the original bindElement: it is built per-press with relative` &&
                 ` bindings ({PRODUCT_ID} title, {NAME}, {PRODUCT_PIC_URL}) and follow_up_action( cs_event-bind_element, view=cs_view-popover ) element-binds the popover slot to t_products/<index>, where the index` &&
                 ` comes from the pressed row's binding context ($event.oSource.getBindingContext().getPath()); the popover is anchored by $event.oSource.sId and the Action button reproduces handleActionPress 1:1 (a` &&
                 ` toast 'Action has been pressed' + follow_up_action( cs_event-popover_close )). The disable/enable-pointer-events-while-open behavior is dropped.`
        post171 = `Link.ariaHasPopup (since 1.86) is kept 1:1 on the popover link; needs UI5 >= 1.86.`
        use_fua = abap_true
        use_fua_arg = abap_true
        use_popover = abap_true
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.ProgressIndicator`             name = `ProgressIndicator`                   class = `z2ui5_cl_ai_app_070` path = `src/01/b09/z2ui5_cl_ai_app_070.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.13.1`
        release = `1.73`
        release_post171 = abap_true
        is_post171 = abap_true
        notes = `IMPROVISED: the two interactive ProgressIndicators (pi-with-animation / pi-without-animation) are set to 0/100 via two-way bound percentValue/displayValue fields updated in a SET event, replacing the` &&
                 ` original's controller byId(...).setPercentValue/setDisplayValue calls. // POST-1.71: ProgressIndicator.displayAnimation (since UI5 1.73) is kept 1:1 on the no-animation ProgressIndicator; needs UI5` &&
                 ` >= 1.73.`
        post171 = `ProgressIndicator.displayAnimation (since UI5 1.73) is kept 1:1 on the no-animation ProgressIndicator; needs UI5 >= 1.73.` )
      ( module = `sap.m`              control = `sap.m.PullToRefresh`                 name = `PullToRefresh`                       class = `z2ui5_cl_ai_app_081` path = `src/01/b10/z2ui5_cl_ai_app_081.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.9.2`
        notes = `NOTE: the incremental backend load is reproduced 1:1: the model starts with the first product and each pull-to-refresh (REFRESH) appends the next until the full /ProductCollection is shown (fill_all +` &&
                 ` shown counter).`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.QuickView`                     name = `QuickView`                           class = `z2ui5_cl_ai_app_100` path = `src/01/b12/z2ui5_cl_ai_app_100.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.28.11`
        release = `1.84`
        release_post171 = abap_true
        is_post171 = abap_true
        notes = `IMPROVISED: The original binds four separate named JSONModels (CompanyModel / EmployeeModel / GenericModel / GenericModelNoHeader) and swaps the model on the shared QuickView before openBy. abap2UI5` &&
                 ` serves a single default model, so the four data sets are flattened into four ABAP tables (kept in PROTECTED) and the pressed button copies the relevant one into the bound t_pages before the popover` &&
                 ` is opened. Named ABAP-fed JSON models are not expressible (CAPABILITIES). // NOTE: The QuickView popover is built per press and shown 1:1 via client->popover_display( xml, by_id ), anchored to the` &&
                 ` pressed button (the original oQuickView.openBy(oButton)). The nested pages/groups/elements are a nested ABAP table; relative child aggregations (groups, elements) keep the original binding-info form.` &&
                 ` // NOTE: The navigate toast is simplified to a fixed message (the original shows the clicked link's text via navOrigin, a control reference that is not transportable as an event arg). Elements` &&
                 ` without an elementType (Generic pages, and the Address/Slogan rows) get the QuickViewGroupElementType default 'text', and pages without displayShape (Generic) get the AvatarShape default 'Circle', so` &&
                 ` no enum property serializes as an empty string. The EmployeeData icon (a test-resources image) points at the OpenUI5 host. // POST-1.71: sap.m.Avatar (and the QuickViewPage avatar aggregation) is` &&
                 ` since 1.73; it is kept 1:1 as the page icon, so the app needs UI5 >= 1.73 to render the avatar. // POST-1.71: sap.m.Button.ariaHasPopup (since 1.84) is kept 1:1 on the four trigger buttons; needs UI5` &&
                 ` >= 1.84.`
        post171 = `sap.m.Avatar (and the QuickViewPage avatar aggregation) is since 1.73; it is kept 1:1 as the page icon, so the app needs UI5 >= 1.73 to render the avatar. // sap.m.Button.ariaHasPopup (since 1.84) is` &&
                 ` kept 1:1 on the four trigger buttons; needs UI5 >= 1.84.`
        use_popover = abap_true
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.QuickViewCard`                 name = `QuickViewCard`                       class = `z2ui5_cl_ai_app_099` path = `src/01/b12/z2ui5_cl_ai_app_099.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.28.11`
        release = `1.73`
        release_post171 = abap_true
        is_post171 = abap_true
        notes = `NOTE: The QuickViewCard fragment is inlined into the main view instead of a separate core:Fragment include, so the port has no core:Fragment control. The nested pages/groups/elements are a nested ABAP` &&
                 ` table (t_pages) bound 1:1; relative child aggregations (groups, elements) keep the original binding-info form. // NOTE: The external Navigate-Back button drives the card 1:1 via follow_up_action(` &&
                 ` cs_event-control_by_id, navigateBack ) — navigateBack was whitelisted in the paired abap2UI5 change. afterNavigate forwards the public isTopPage parameter and enables the button while the card is not` &&
                 ` on its top page. The navigate toast is simplified to a fixed message (the original distinguishes the clicked link's text vs the back button via navOrigin, a control reference that is not` &&
                 ` transportable as an event arg). // NOTE: Elements without an elementType in the source JSON (Address, Slogan) are filled with the QuickViewGroupElementType default 'text' so the enum-typed type` &&
                 ` property never serializes as an empty string (which validateProperty rejects). onAfterRendering's 320px maxWidth tweak is dropped. // POST-1.71: sap.m.Avatar (and the QuickViewPage avatar` &&
                 ` aggregation) is since 1.73; it is kept 1:1 as the page icon, so the app needs UI5 >= 1.73 to render the avatar.`
        post171 = `sap.m.Avatar (and the QuickViewPage avatar aggregation) is since 1.73; it is kept 1:1 as the page icon, so the app needs UI5 >= 1.73 to render the avatar.`
        use_fua = abap_true
        use_fua_arg = abap_true
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.RadioButton`                   name = `RadioButton`                         class = `z2ui5_cl_ai_app_069` path = `src/01/b09/z2ui5_cl_ai_app_069.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        release = `1.126`
        release_post171 = abap_true
        is_post171 = abap_true
        notes = `POST-1.71: RadioButton.wrapping and RadioButton.wrappingType (both since UI5 1.126) are kept 1:1 on the wrapping-demo group; the app needs a UI5 release >= 1.126 to render them.`
        post171 = `RadioButton.wrapping and RadioButton.wrappingType (both since UI5 1.126) are kept 1:1 on the wrapping-demo group; the app needs a UI5 release >= 1.126 to render them.` )
      ( module = `sap.m`              control = `sap.m.RangeSlider`                   name = `RangeSlider`                         class = `z2ui5_cl_ai_app_045` path = `src/01/b02/z2ui5_cl_ai_app_045.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.38`
        notes = `NOTE: the sample binds the composite RangeSlider "range" property (an array [low, high] - range="{/RS1}" / range="0,100"). abap2UI5 binds scalar ABAP fields, so each range is expressed as the` &&
                 ` equivalent value / value2 properties the control keeps in sync - identical rendering.` )
      ( module = `sap.m`              control = `sap.m.ScrollContainer`               name = `ScrollContainer`                     class = `z2ui5_cl_ai_app_046` path = `src/01/b04/z2ui5_cl_ai_app_046.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed); incl. the phone-emulation device> check`
        notes = `IMPROVISED: the Image src binds {img>/products/pic1} in the original, a JSON image model not available server-side; a static demo image URL is used instead.` )
      ( module = `sap.m`              control = `sap.m.SearchField`                   name = `DialogSearch`                        class = `z2ui5_cl_ai_app_090` path = `src/01/b11/z2ui5_cl_ai_app_090.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: the Dialog (loaded from a fragment in the original) is built and shown via popup_display on the button press; its content is static text, so the bindElement /ProductCollection/0 is a no-op and` &&
                 ` dropped.`
        use_ec = abap_true
        use_popup = abap_true )
      ( module = `sap.m`              control = `sap.m.SegmentedButton`               name = `SegmentedButton`                     class = `z2ui5_cl_ai_app_047` path = `src/01/b03/z2ui5_cl_ai_app_047.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `NOTE: the original reads the selected item via oEvent.getParameter("item").getText() / getSelectedItem(). Here the items get keys (one/two/three - an addition, SB1 has none in the sample) and` &&
                 ` selectedKey is two-way bound, so the selection arrives with the event and no private event path is needed - the documented 1:1 path for controller-read selection (CAPABILITIES.md), not a workaround.` )
      ( module = `sap.m`              control = `sap.m.Select`                        name = `Select`                              class = `z2ui5_cl_ai_app_048` path = `src/01/b02/z2ui5_cl_ai_app_048.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.SelectDialog`                  name = `SelectDialog`                        class = `z2ui5_cl_ai_app_103` path = `src/01/b12/z2ui5_cl_ai_app_103.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        release = `1.110`
        release_post171 = abap_true
        is_post171 = abap_true
        notes = `IMPROVISED: The original configures one shared SelectDialog imperatively per button (oButton.data() CustomData ->` &&
                 ` setMultiSelect/setGrowing/setGrowingThreshold/setRememberSelections/setShowClearButton/setConfirmButtonText/setDraggable/setResizable/toggleStyleClass). abap2UI5 binds those SelectDialog properties` &&
                 ` two-way and each button's handler sets them before opening (responsivePadding toggles the style class via control_by_id addStyleClass/removeStyleClass). The core:CustomData is kept on the buttons for` &&
                 ` fidelity; the dialog is declared once in mvc:dependents and opened via follow_up_action( cs_event-control_by_id, open ). // NOTE: Search filters the dialog's items binding client-side via` &&
                 ` _event_client( cs_event-binding_call, filter NAME Contains ${$parameters>/value} ). The valueHelpRequest opens a second SelectDialog (also in dependents) after preselecting the row matching the input` &&
                 ` value. The confirm / value-help-close toasts are simplified — selectedContexts / selectedItem are control references not transportable as event args (original composes the chosen product names /` &&
                 ` copies the selected title into the input). // IMPROVISED: The StandardListItem icon binds ProductPicUrl, which is derived in ABAP from the product id (the mock's test-resources/<id>.jpg) built from a` &&
                 ` shared base pointing at the OpenUI5 host, like app 006's image flattening. The full 123-row /ProductCollection is inlined. // LIVE-TEST: The per-button dialog configuration` &&
                 ` (multi/growing/remember/clear/confirm text/draggable/resizable), the client-side search filter and the value-help selection need an in-system check; machine gates only verify the views are valid. //` &&
                 ` POST-1.71: sap.m.SelectDialog.searchPlaceholder (since 1.110) is kept 1:1 on the value-help dialog; needs UI5 >= 1.110.`
        post171 = `sap.m.SelectDialog.searchPlaceholder (since 1.110) is kept 1:1 on the value-help dialog; needs UI5 >= 1.110.`
        use_ec = abap_true
        use_ec_arg = abap_true
        use_fua = abap_true
        use_fua_arg = abap_true
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.SelectList`                    name = `SelectList`                          class = `z2ui5_cl_ai_app_075` path = `src/01/b09/z2ui5_cl_ai_app_075.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26.0`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.semantic.SemanticPage`         name = `SemanticPage`                        class = `z2ui5_cl_ai_app_107` path = `src/01/b13/z2ui5_cl_ai_app_107.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.30.0`
        notes = `NOTE: onSemanticButtonPress toasts each action's class name, reproduced by passing the name as a t_arg literal. The SortSelect change toasts the two-way selectedKey (sort_key); PagingButton` &&
                 ` positionChange transports ${$parameters>/newPosition}; the custom footer / share buttons transport $event.oSource.sId. The MultiSelectAction and MessagesIndicator toasts are simplified to fixed` &&
                 ` messages (the original toggles a MultiSelect state / opens a MessagePopover). // NOTE: The SortSelect items are bound to a 2-row filter-type table reproducing /ProductCollectionStats/Filters (the two` &&
                 ` ``type`` values Category and SupplierName; the per-type ``values`` sub-arrays are unused by the Select). The binding keeps the original sorter { path: 'Name' } 1:1 — a no-op there too, since the` &&
                 ` Filters entries carry ``type``, not ``Name``.`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.semantic.SemanticPage`         name = `SemanticPageFloatingFooter`          class = `z2ui5_cl_ai_app_106` path = `src/01/b13/z2ui5_cl_ai_app_106.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.30.0`
        notes = `NOTE: onSemanticButtonPress toasts each action's class name, reproduced by passing the name as a t_arg literal. The SortSelect change toasts the two-way selectedKey (sort_key); PagingButton` &&
                 ` positionChange transports ${$parameters>/newPosition}; the custom footer / share buttons transport $event.oSource.sId. The MultiSelectAction and MessagesIndicator toasts are simplified to fixed` &&
                 ` messages (the original toggles a MultiSelect state / opens a MessagePopover). // NOTE: The SortSelect items are bound to a 2-row filter-type table reproducing /ProductCollectionStats/Filters (the two` &&
                 ` ``type`` values Category and SupplierName; the per-type ``values`` sub-arrays are unused by the Select). The binding keeps the original sorter { path: 'Name' } 1:1 — a no-op there too, since the` &&
                 ` Filters entries carry ``type``, not ``Name``. // NOTE: Same as SemanticPage but the MasterPage and DetailPage carry floatingFooter='true' and the MasterPage drops the PageAccessibleLandmarkInfo` &&
                 ` (matching the SemanticPageFloatingFooter variant).`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.semantic.SemanticPage`         name = `SemanticPageFullScreen`              class = `z2ui5_cl_ai_app_105` path = `src/01/b13/z2ui5_cl_ai_app_105.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.30.0`
        notes = `NOTE: onSemanticButtonPress toasts the pressed control's class name (getMetadata().getName() minus the library); reproduced by passing each semantic action's name as a t_arg literal ('AddAction',` &&
                 ` 'EditAction', ...) and toasting 'Pressed: <name>'. The custom footer buttons toast the pressed control id via $event.oSource.sId (original onPress). The MessagesIndicator toast is simplified to a` &&
                 ` fixed message (the original opens a MessagePopover, dropped here).` )
      ( module = `sap.m`              control = `sap.m.SinglePlanningCalendar`        name = `SinglePlanningCalendarDateSelection` class = `z2ui5_cl_ai_app_109` path = `src/01/b14/z2ui5_cl_ai_app_109.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.61`
        release = `1.74`
        release_post171 = abap_true
        is_post171 = abap_true
        notes = `NOTE: The object-typed date properties (SinglePlanningCalendar.startDate, CalendarAppointment.startDate/endDate) are fed from ISO strings and converted with Formatter.DateCreateObject (core:require).` &&
                 ` The original UI5Date.getInstance values are normalized to ISO 1:1 (0-based months). The first appointment used UI5Date.getInstance() (the current time); it is pinned to the calendar's start date` &&
                 ` (2018-07-09) so the port is deterministic. // NOTE: viewChange / selectedDatesChange / weekNumberPress / startDateChange are wired to toasts echoing the event name (the original toasts the same). The` &&
                 ` MultiSelect ToggleButton toast stands in for the original setDateSelectionMode SingleSelect/MultiSelect toggle + tooltip swap. // POST-1.71: Formatter.DateCreateObject is referenced via core:require` &&
                 ` (UI5 >= 1.74). sap.m.SinglePlanningCalendar and its DayView/WorkWeekView/WeekView/MonthView are since 1.61 (in scope).`
        post171 = `Formatter.DateCreateObject is referenced via core:require (UI5 >= 1.74). sap.m.SinglePlanningCalendar and its DayView/WorkWeekView/WeekView/MonthView are since 1.61 (in scope).`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.Slider`                        name = `Slider`                              class = `z2ui5_cl_ai_app_068` path = `src/01/b09/z2ui5_cl_ai_app_068.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` )
      ( module = `sap.m`              control = `sap.m.SlideTile`                     name = `SlideTile`                           class = `z2ui5_cl_ai_app_082` path = `src/01/b10/z2ui5_cl_ai_app_082.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        notes = `NOTE: the sample's demo-kit backgroundImage paths are resolved to absolute sdk.openui5.org URLs.` )
      ( module = `sap.m`              control = `sap.m.SplitApp`                      name = `SplitApp`                            class = `z2ui5_cl_ai_app_097` path = `src/01/b12/z2ui5_cl_ai_app_097.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: Master-detail navigation is driven 1:1 via follow_up_action( cs_event-control_by_id ) on the newly whitelisted SplitApp methods: to (Go-to-Detail button), backDetail/backMaster (page` &&
                 ` navButtonPress), toMaster (master list item), toDetail (master2 list items) and setMode (RadioButtonGroup). The methods were added to the abap2UI5 framework in the same change set (CONTROL_METHODS).` &&
                 ` // NOTE: The master2 list navigates via a per-item press event that carries the target page id as a t_arg literal ('detail'/'detailDetail'/'detail2'); the original reads the pressed item's custom:to` &&
                 ` CustomData in one List.itemPress handler, which is not transportable as an event arg. custom:to is kept on the items for fidelity. // NOTE: The split mode is selected via a two-way selectedIndex` &&
                 ` binding on the RadioButtonGroup (mode_idx) and mapped to the SplitAppMode string in ABAP; the original reads the selected RadioButton's custom:splitAppMode CustomData. custom:splitAppMode is kept on` &&
                 ` the buttons for fidelity. The onInit setHomeIcon and the onOrientationChange toast are dropped (device-specific cosmetics). // LIVE-TEST: SplitApp as the root view plus the control_by_id navigation` &&
                 ` (to/toDetail/toMaster/backDetail/backMaster/setMode) need an in-system check — machine gates only verify view validity, not the runtime navigation roundtrip.`
        use_fua = abap_true
        use_fua_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.SplitContainer`                name = `SplitContainer`                      class = `z2ui5_cl_ai_app_096` path = `src/01/b12/z2ui5_cl_ai_app_096.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: Master-detail navigation is driven 1:1 via follow_up_action( cs_event-control_by_id ) on the newly whitelisted SplitContainer methods: to (Go-to-Detail button), backDetail/backMaster (page` &&
                 ` navButtonPress), toMaster (master list item), toDetail (master2 list items) and setMode (RadioButtonGroup). The methods were added to the abap2UI5 framework in the same change set (CONTROL_METHODS).` &&
                 ` // NOTE: The master2 list navigates via a per-item press event that carries the target page id as a t_arg literal ('detail'/'detailDetail'/'detail2'); the original reads the pressed item's custom:to` &&
                 ` CustomData in one List.itemPress handler, which is not transportable as an event arg. custom:to is kept on the items for fidelity. // NOTE: The split mode is selected via a two-way selectedIndex` &&
                 ` binding on the RadioButtonGroup (mode_idx) and mapped to the SplitAppMode string in ABAP; the original reads the selected RadioButton's custom:splitAppMode CustomData. custom:splitAppMode is kept on` &&
                 ` the buttons for fidelity. The onAfterRendering parent-height fix and the device-model onInit setup (device model is global in abap2UI5) are dropped. // LIVE-TEST: SplitContainer as the root view plus` &&
                 ` the control_by_id navigation (to/toDetail/toMaster/backDetail/backMaster/setMode) need an in-system check — machine gates only verify view validity, not the runtime navigation roundtrip.`
        use_fua = abap_true
        use_fua_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.StandardListItem`              name = `StandardListItemAvatar`              class = `z2ui5_cl_ai_app_083` path = `src/01/b10/z2ui5_cl_ai_app_083.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: the List element binding {/ProductCollection} and the items' index paths ({0/Name}..{3/Name}) are kept 1:1 against the default-model table /T_PRODUCTS (full 123-row mock inlined).` )
      ( module = `sap.m`              control = `sap.m.StepInput`                     name = `StepInput`                           class = `z2ui5_cl_ai_app_049` path = `src/01/b02/z2ui5_cl_ai_app_049.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.40`
        notes = `IMPROVISED: the sample binds a List to the JSON model /modelData and renders one templated CustomListItem per row. The rows are unrolled into static list items here because every row sets a different` &&
                 ` subset of the StepInput properties - an empty ABAP model field would bind as "" instead of leaving the property at its default, so a bound template would not render 1:1. Template properties no row` &&
                 ` ever sets (valueState) are dropped with it. // LIVE-TEST: the change toast was switched to a roundtrip-free client-composed toast on 2026-07-22 (control_global MESSAGE_TOAST.show, template ``Value` &&
                 ` changed to '{0}'`` with get_t_arg single-quote escaping; on_event dropped, init-only) - re-verify changing a StepInput toasts "Value changed to '<value>'" with the quotes intact.`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.Switch`                        name = `Switch`                              class = `z2ui5_cl_ai_app_050` path = `src/01/b02/z2ui5_cl_ai_app_050.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` )
      ( module = `sap.m`              control = `sap.m.TabContainer`                  name = `TabContainer`                        class = `z2ui5_cl_ai_app_093` path = `src/01/b11/z2ui5_cl_ai_app_093.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        notes = `NOTE: addNewButtonPress appends an empty employee (bound /T_EMPLOYEES); itemClose in the original calls preventDefault (keeps the tab) and would confirm - here it toasts and the tab is kept.`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.Table`                         name = `TableAutoPopin`                      class = `z2ui5_cl_ai_app_092` path = `src/01/b11/z2ui5_cl_ai_app_092.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16`
        release = `1.77`
        release_post171 = abap_true
        is_post171 = abap_true
        notes = `POST-1.71: Table.popinChanged (since 1.77) and Column.importance (since 1.76), the core of the auto-pop-in demo, are kept 1:1; needs UI5 >= 1.77. // IMPROVISED: onSelectionFinish` &&
                 ` (setHiddenInPopin(getSelectedKeys())) is reproduced 1:1: the MultiComboBox selectedKeys are two-way bound to t_hidden and the selectionFinish round-trip forwards them as a JSON Priority array through` &&
                 ` follow_up_action( cs_event-control_by_id, setHiddenInPopin ), so the matching columns hide while in pop-in. The added selectedKeys binding has no counterpart in the original (the controller reads` &&
                 ` getSelectedKeys imperatively). onSliderMoved (byId(idProductsTable).setWidth(value + '%')) is now reproduced 1:1 without a round-trip: the Slider value is two-way bound to width_pct and the Table` &&
                 ` gains a width expression binding width={= ${width_pct} + '%' }, so moving the Slider shrinks the table live and drives the auto-pop-in (the added Table width attribute and the Slider value binding` &&
                 ` have no counterpart in the original view, where setWidth is imperative; the original Slider liveChange handler is dropped). autoPopinMode + Column.importance stay declarative and 1:1; popinChanged` &&
                 ` still toasts. // NOTE: the original derives the ObjectNumber weight state in its frontend Formatter.js (weightState: KG conversion + Success/Warning/Error thresholds). That is business logic, so -` &&
                 ` abap2UI5 being a thin frontend - it is computed in ABAP model_init into a WEIGHT_STATE field and bound state="{WEIGHT_STATE}", not via a frontend formatter (core:require dropped). Visually 1:1 with` &&
                 ` the original.`
        post171 = `Table.popinChanged (since 1.77) and Column.importance (since 1.76), the core of the auto-pop-in demo, are kept 1:1; needs UI5 >= 1.77.`
        use_fua = abap_true
        use_fua_arg = abap_true
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.TableSelectDialog`             name = `TableSelectDialog`                   class = `z2ui5_cl_ai_app_104` path = `src/01/b12/z2ui5_cl_ai_app_104.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16`
        release = `1.110`
        release_post171 = abap_true
        is_post171 = abap_true
        notes = `IMPROVISED: The original configures a single shared dialog imperatively per button (oButton.data() CustomData ->` &&
                 ` setMultiSelect/setDraggable/setResizable/setRememberSelections/setConfirmButtonText/addStyleClass). abap2UI5 binds those SelectDialog properties two-way and each button's handler sets them before` &&
                 ` opening (responsivePadding toggles the style class via control_by_id addStyleClass/removeStyleClass). The core:CustomData is kept on the buttons for fidelity; the dialog is declared once in` &&
                 ` mvc:dependents and opened via follow_up_action( cs_event-control_by_id, open ). // IMPROVISED: The ObjectNumber weightState is business logic (parseFloat thresholds), so it is computed in ABAP` &&
                 ` (WEIGHT_STATE, thin-frontend principle) and bound state='{WEIGHT_STATE}' instead of the frontend Formatter.weightState; core:require is therefore dropped and the Currency binding keeps the full` &&
                 ` standard type path 'sap.ui.model.type.Currency' 1:1. The full 123-row /ProductCollection is inlined (ProductPicUrl is not needed — the table cells carry no icon). // NOTE: Search filters the dialog's` &&
                 ` items binding client-side via _event_client( cs_event-binding_call, filter NAME Contains ${$parameters>/value} ). The valueHelpRequest opens a second TableSelectDialog (also in dependents) after` &&
                 ` preselecting the row matching the input value. The confirm/valueHelpClose toasts are simplified — selectedContexts / selectedItem are control references not transportable as event args (original` &&
                 ` composes the chosen product names / copies the selected title into the input). // LIVE-TEST: The per-button dialog configuration, the client-side search filter, multi-select confirm and the` &&
                 ` value-help selection copy-back need an in-system check; machine gates only verify the views are valid. // POST-1.71: sap.m.TableSelectDialog.searchPlaceholder (since 1.110) is kept 1:1 on the` &&
                 ` value-help dialog; needs UI5 >= 1.110.`
        post171 = `sap.m.TableSelectDialog.searchPlaceholder (since 1.110) is kept 1:1 on the value-help dialog; needs UI5 >= 1.110.`
        use_ec = abap_true
        use_ec_arg = abap_true
        use_fua = abap_true
        use_fua_arg = abap_true
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.Text`                          name = `Text`                                class = `z2ui5_cl_ai_app_051` path = `src/01/b01/z2ui5_cl_ai_app_051.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` )
      ( module = `sap.m`              control = `sap.m.TextArea`                      name = `TextArea`                            class = `z2ui5_cl_ai_app_052` path = `src/01/b01/z2ui5_cl_ai_app_052.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.9.0` )
      ( module = `sap.m`              control = `sap.m.TileContent`                   name = `TileContent`                         class = `z2ui5_cl_ai_app_078` path = `src/01/b10/z2ui5_cl_ai_app_078.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34.0` )
      ( module = `sap.m`              control = `sap.m.TimePicker`                    name = `TimePickerHidden`                    class = `z2ui5_cl_ai_app_091` path = `src/01/b11/z2ui5_cl_ai_app_091.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.32`
        release = `1.97`
        release_post171 = abap_true
        is_post171 = abap_true
        notes = `NOTE: openTimePicker (byId('HiddenTP').openBy(source.getDomRef())) is the app-016 openBy pattern: the source sId is transported via $event.oSource.sId and replayed as a control_by_id/openBy follow-up` &&
                 ` action. // POST-1.71: Button.ariaHasPopup (since 1.84), Link.ariaHasPopup (since 1.86) and TimePicker.hideInput (since 1.97) are kept 1:1; needs a UI5 release providing them. // NOTE: the hidden` &&
                 ` TimePicker openBy is wired roundtrip-free via client->_event_client( cs_event-control_by_id, openBy ) on each anchor press ($event.oSource.sId) - the original's byId('HiddenTP').openBy(getDomRef())` &&
                 ` 1:1; the change toast is now roundtrip-free too (control_global MESSAGE_TOAST.show), so the app is init-only. // LIVE-TEST: the openBy was switched to roundtrip-free _event_client on 2026-07-22 -` &&
                 ` re-verify each anchor opens the hidden TimePicker. // LIVE-TEST: the change toast was switched to a roundtrip-free client-composed toast on 2026-07-22 (control_global MESSAGE_TOAST.show, template` &&
                 ` ``Time selected: {0}`` filled by ${$parameters>/value}; on_event dropped, init-only) - re-verify picking a time toasts "Time selected: <value>".`
        post171 = `Button.ariaHasPopup (since 1.84), Link.ariaHasPopup (since 1.86) and TimePicker.hideInput (since 1.97) are kept 1:1; needs a UI5 release providing them.`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.TimePickerSliders`             name = `TimePickerSliders`                   class = `z2ui5_cl_ai_app_095` path = `src/01/b12/z2ui5_cl_ai_app_095.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.54`
        notes = `NOTE: The picked time is transported to the backend via a two-way value binding on TimePickerSliders (an extra attribute; the original reads it imperatively with oTP.getValue()). OK composes the` &&
                 ` result text from the current time_value, Cancel restores the pre-open value captured on OPEN_DIALOG (the attachAfterOpen equivalent). // NOTE: The result text uses the static control id 'TPS2'` &&
                 ` because the original's runtime-generated oTP.getId() cannot be reproduced. The cosmetic collapseAll() on the sliders as the dialog closes is dropped (no visible effect on a closing dialog).`
        use_popup = abap_true )
      ( module = `sap.m`              control = `sap.m.Title`                         name = `TitleLink`                           class = `z2ui5_cl_ai_app_079` path = `src/01/b10/z2ui5_cl_ai_app_079.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.27.0`
        use_ec = abap_true
        use_ec_arg = abap_true
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.ToggleButton`                  name = `ToggleButton`                        class = `z2ui5_cl_ai_app_080` path = `src/01/b10/z2ui5_cl_ai_app_080.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: onPress toasts the source control id + Pressed/Unpressed; both arrive via $event.oSource (sId and getPressed()) - the earlier ${$source>/pressed} binding did not resolve at runtime. //` &&
                 ` LIVE-TEST: the press toast was switched to a roundtrip-free client-composed toast on 2026-07-22 using the conditional placeholder (control_global MESSAGE_TOAST.show, template ``{0}` &&
                 ` {1?Pressed:Unpressed}``; on_event dropped, init-only) - re-verify pressing a ToggleButton toasts "<id> Pressed" when down and "<id> Unpressed" when up.`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.Tokenizer`                     name = `TokenizerBasic`                      class = `z2ui5_cl_ai_app_085` path = `src/01/b10/z2ui5_cl_ai_app_085.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22`
        notes = `IMPROVISED: the first Tokenizer's tokens are now model-bound (t_tokens): onAddToken appends the input value, onTokenDelete removes by key (the deleted key arrives via` &&
                 ` $event.getParameter('tokens')[0].getKey()); the second, disabled Tokenizer keeps its 3 static tokens, so the port shows one bound Token template + 3 static Token vs the original's 3+3. // NOTE: the` &&
                 ` CheckBox select handler becomes a live two-way selected/editable bind on the first Tokenizer.`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.Toolbar`                       name = `ToolbarShrinkable`                   class = `z2ui5_cl_ai_app_053` path = `src/01/b03/z2ui5_cl_ai_app_053.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `NOTE: the sample's controller onSliderLiveChange resizes the toolbars in JS; there is no width in the source XML (the port adds the width attribute, the original wires liveChange instead). Rebuilt as` &&
                 ` a client-side expression binding {= slider + '%' } on each Toolbar width - no event round-trip, resizes instantly like the original; the documented preferred path (CAPABILITIES.md), not a workaround.` )
      ( module = `sap.m`              control = `sap.m.Tree`                          name = `Tree`                                class = `z2ui5_cl_ai_app_054` path = `src/01/b04/z2ui5_cl_ai_app_054.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.42`
        checked = `CHECKED (2026-07-19): verified in a running system - human visual pass 2026-07-19 over all apps: the nested-table hierarchy renders as an expandable Tree like the original.`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.upload.UploadSet`              name = `UploadSet`                           class = `z2ui5_cl_ai_app_121` path = `src/01/b13/z2ui5_cl_ai_app_121.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.63`
        is_deprecated = abap_true
        dep_text = `Deprecated since 1.129: replaced by sap.m.plugins.UploadSetwithTable`
        notes = `IMPROVISED: Breadth-probe: a minimal sap.m.upload.UploadSet (file upload list) with 3 pre-populated items + a toolbar. The actual upload backend, the full toolbar and the item action buttons are` &&
                 ` simplified; upload here would target the abap2UI5 FileUploader path in a live system.`
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.URLHelper`                     name = `UrlHelper`                           class = `z2ui5_cl_ai_app_084` path = `src/01/b10/z2ui5_cl_ai_app_084.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.10`
        notes = `NOTE: element binding kept 1:1 - a one-record structure /S_SUPPLIER instead of {/SupplierCollection/0}. // NOTE: URLHelper.triggerTel/triggerSms/triggerEmail/redirect map 1:1 to the URLHELPER frontend` &&
                 ` action (cs_event-urlhelper): TRIGGER_TEL/TRIGGER_SMS take the number as a plain string param, TRIGGER_EMAIL/REDIRECT take a { EMAIL/URL, ... } object-literal t_arg (get_t_arg emits {-prefixed args` &&
                 ` raw as UI5 event-handler object literals). open_new_tab is NOT used - it is same-origin-only (isValidRedirectURL).`
        use_ec = abap_true
        use_ec_arg = abap_true
        use_name = abap_true )
      ( module = `sap.m`              control = `sap.m.ViewSettingsDialog`            name = `ViewSettingsDialog`                  class = `z2ui5_cl_ai_app_098` path = `src/01/b12/z2ui5_cl_ai_app_098.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16`
        notes = `NOTE: The three controller-loaded fragments (Dialog / DialogPreselected / DialogPreset) are declared in the view's mvc:dependents aggregation and opened 1:1 via follow_up_action(` &&
                 ` cs_event-control_by_id, open [pageKey] ) — the whitelisted ViewSettingsDialog open with the optional page key ('filter'). confirm forwards the public filterString event parameter` &&
                 ` (${$parameters>/filterString}) and toasts it when non-empty, like the original handleConfirm. // IMPROVISED: The DialogPreset presetFilterItems are declared as three ViewSettingsItem entries (text +` &&
                 ` key) instead of the original _presetFiltersInit which adds them imperatively with sap.ui.model.Filter arrays as CustomData. The Filter payload is inert in this sample (no list is bound — confirm only` &&
                 ` shows the filterString), so only the three visible preset filter options are reproduced. This adds 3 ViewSettingsItem over the original fragment count.`
        use_fua = abap_true
        use_fua_arg = abap_true )
      ( module = `sap.m`              control = `sap.m.Wizard`                        name = `Wizard`                              class = `z2ui5_cl_ai_app_101` path = `src/01/b12/z2ui5_cl_ai_app_101.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.30`
        notes = `IMPROVISED: Step validation (additionalInfoValidation) is reproduced in ABAP: on the ProductName/ProductWeight liveChange (and ProductInfoStep activate) the name-length>=6 / weight-numeric checks set` &&
                 ` the two valueStates and the ProductInfoStep validated property, which is bound two-way (step2_validated) instead of the original imperative validateStep/invalidateStep. The other steps keep their` &&
                 ` literal validated='true'. // NOTE: The step-1 SegmentedButton gets item keys (Mobile/Desktop/Other) and a two-way selectedKey binding so the chosen product type reaches the model directly; the` &&
                 ` original reads evt.getParameters().item.getText() in setProductTypeFromSegmented. selectionChange is still wired. The PricingStep activate/complete handlers (which only toggle the unused` &&
                 ` navApiEnabled flag) are wired for fidelity but do nothing. // NOTE: Navigation is 1:1 via follow_up_action( cs_event-control_by_id ): Wizard complete -> NavContainer 'to' the review page; each Edit` &&
                 ` link -> 'to' the content page then Wizard 'goToStep' the target step (whitelisted). Cancel and Submit open a MessageBox (warning/confirm) with YES/NO; on YES the wizard resets via 'to' the content` &&
                 ` page + 'discardProgress' ProductTypeStep, matching _handleMessageBoxOpen. // LIVE-TEST: The full wizard flow — step validation gating the Next button, complete/edit navigation, the goToStep scroll` &&
                 ` and the cancel/submit reset — needs an in-system check; machine gates only verify the view is valid.`
        use_fua = abap_true
        use_fua_arg = abap_true )
      ( module = `sap.m`              control = `sap.ui.core.ContainerPadding`        name = `ContainerNoPadding`                  class = `z2ui5_cl_ai_app_087` path = `src/01/b10/z2ui5_cl_ai_app_087.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: the /ProductCollectionStats/Counts values are flattened to the default model fields /TOTAL, /OK, /HEAVY, /OVERWEIGHT (verbatim counts).` )
      ( module = `sap.m`              control = `sap.ui.core.StandardMargins`         name = `StandardMarginsAll`                  class = `z2ui5_cl_ai_app_088` path = `src/01/b11/z2ui5_cl_ai_app_088.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` )
      ( module = `sap.tnt`            control = `sap.f.DynamicPage`                   name = `InfoLabelInDynamicPage`              class = `z2ui5_cl_ai_app_143` path = `src/05/b05/z2ui5_cl_ai_app_143.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `LIVE-TEST: The 'Edit' (toggleAreaPriority) and 'Toggle Footer' actions are wired to backend events; the original toggled title-area priority and footer visibility imperatively — not reproduced` &&
                 ` server-side. // NOTE: f:DynamicPage with title (heading, expanded/snapped tnt:InfoLabel, actions), pinnable header (ObjectAttributes), content (two long Texts) and footer. The footer message Button` &&
                 ` binds text and visible='{= !!${/MESSAGESLENGTH}}' to a model field (initial 0), reproducing the original {/messagesLength} wiring.` )
      ( module = `sap.tnt`            control = `sap.tnt.InfoLabel`                   name = `InfoLabel`                           class = `z2ui5_cl_ai_app_113` path = `src/05/b01/z2ui5_cl_ai_app_113.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: Breadth-probe (cross-library test). Ten sap.tnt InfoLabels across color schemes / render modes / icon / displayOnly, in FlexBox rows.` )
      ( module = `sap.tnt`            control = `sap.tnt.NavigationList`              name = `NavigationList`                      class = `z2ui5_cl_ai_app_123` path = `src/05/b02/z2ui5_cl_ai_app_123.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `LIVE-TEST: The two toolbar buttons reproduce the original controller behaviour server-side: 'Toggle Collapse/Expand' flips NavigationList.expanded (bound to a boolean model field), 'Show/Hide SubItem` &&
                 ` 3' flips subItemThree.visible. The original used byId().setExpanded/setVisible; here the properties are two-way bound and toggled on a backend round-trip. The 'expanded' attribute on NavigationList` &&
                 ` and the 'visible' attribute on subItemThree are added to carry these bindings (the original set them imperatively).` )
      ( module = `sap.tnt`            control = `sap.tnt.SideNavigation`              name = `SideNavigation`                      class = `z2ui5_cl_ai_app_128` path = `src/05/b02/z2ui5_cl_ai_app_128.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        release = `1.116`
        release_post171 = abap_true
        is_post171 = abap_true
        notes = `LIVE-TEST: The two buttons reproduce the controller behaviour server-side: 'Toggle Collapse/Expand' flips SideNavigation.expanded (bound to a boolean model field, initial false as in the original) and` &&
                 ` 'Show/Hide "Walked"' flips the 'walked' NavigationListItem.visible. The original used byId().setExpanded/setVisible; here the properties are two-way bound and toggled on a backend round-trip. The` &&
                 ` 'visible' attribute added to the walked item carries that binding (the original toggled it imperatively). // POST-1.71: NavigationListItem.selectable (@since 1.116) is kept 1:1 from the original` &&
                 ` (selectable=false on the parent items). Newer than UI5 1.71; declared per the property-171 policy. Was previously undeclared because the property gate is blind to sap.tnt (properties.json holds sap.m` &&
                 ` only); found and corrected by the app-172 cold-read probe 2026-07-24.`
        post171 = `NavigationListItem.selectable (@since 1.116) is kept 1:1 from the original (selectable=false on the parent items). Newer than UI5 1.71; declared per the property-171 policy. Was previously undeclared` &&
                 ` because the property gate is blind to sap.tnt (properties.json holds sap.m only); found and corrected by the app-172 cold-read probe 2026-07-24.` )
      ( module = `sap.tnt`            control = `sap.tnt.SideNavigation`              name = `SideNavigationUnselectableParents`   class = `z2ui5_cl_ai_app_172` path = `src/05/b06/z2ui5_cl_ai_app_172.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        release = `1.116`
        release_post171 = abap_true
        is_post171 = abap_true
        notes = `POST-1.71: sap.tnt.NavigationListItem.selectable (@since 1.116) is used 1:1 on the unselectable parent items (Building/Mileage/Transport) and the fixed External Link item - it is the whole point of` &&
                 ` this sample. Kept per the members-newer-than-1.71 fidelity policy; @since verified by hand against fork-openui5/src/sap.tnt/src/sap/tnt/NavigationListItem.js line 101-103 (property gate is blind to` &&
                 ` sap.tnt). Requires a UI5 release >= 1.116 to render. // LIVE-TEST: onCollapseExpandPress reproduced server-side: SideNavigation.expanded is two-way bound (initial false as in the original` &&
                 ` expanded="false") and flipped on a backend round-trip (TOGGLE_EXPAND) instead of the original imperative byId().setExpanded(!expanded). Same technique as app 128. The literal expanded="false"` &&
                 ` becoming a {/EXPANDED} binding needs a live render check. // LIVE-TEST: onItemSelect reproduced roundtrip-free: the SideNavigation itemSelect event fires a client-composed MessageToast` &&
                 ` (control_global MESSAGE_TOAST/show, template 'Item selected: {0}' filled by the client-resolved ${$parameters>/item}.getText()) - the 1:1 equivalent of the original MessageToast.show(``Item selected:` &&
                 ` ${sText}``). Same idiom as app 060; CAPABILITIES marks it expressible, live render/click check pending.`
        post171 = `sap.tnt.NavigationListItem.selectable (@since 1.116) is used 1:1 on the unselectable parent items (Building/Mileage/Transport) and the fixed External Link item - it is the whole point of this sample.` &&
                 ` Kept per the members-newer-than-1.71 fidelity policy; @since verified by hand against fork-openui5/src/sap.tnt/src/sap/tnt/NavigationListItem.js line 101-103 (property gate is blind to sap.tnt).` &&
                 ` Requires a UI5 release >= 1.116 to render.`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.tnt`            control = `sap.tnt.SideNavigation`              name = `SideNavigationWithTags`              class = `z2ui5_cl_ai_app_132` path = `src/05/b03/z2ui5_cl_ai_app_132.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        release = `1.116`
        release_post171 = abap_true
        is_post171 = abap_true
        notes = `LIVE-TEST: The 'Toggle Collapse/Expand' button flips SideNavigation.expanded (bound to a boolean model field, initial true as in the original). The original toggled it imperatively via` &&
                 ` byId().setExpanded; the property is two-way bound here and toggled on a backend round-trip. Every tnt:tag ObjectStatus (IndicationColor states 15-20, inverted) and the NavigationListGroup / fixedItem` &&
                 ` structure are reproduced 1:1. // POST-1.71: NavigationListItem.selectable (@since 1.116) is kept 1:1 from the original (selectable=false on parent items). Newer than UI5 1.71; declared per the` &&
                 ` property-171 policy. Previously undeclared because the property gate is blind to sap.tnt (properties.json holds sap.m only); found and corrected by the app-172 cold-read probe 2026-07-24.`
        post171 = `NavigationListItem.selectable (@since 1.116) is kept 1:1 from the original (selectable=false on parent items). Newer than UI5 1.71; declared per the property-171 policy. Previously undeclared because` &&
                 ` the property gate is blind to sap.tnt (properties.json holds sap.m only); found and corrected by the app-172 cold-read probe 2026-07-24.` )
      ( module = `sap.tnt`            control = `sap.tnt.ToolHeader`                  name = `ToolHeader`                          class = `z2ui5_cl_ai_app_134` path = `src/05/b04/z2ui5_cl_ai_app_134.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `LIVE-TEST: The SAP-logo Image and profile Avatar presses show client-side MessageToasts ('Logo pressed!' / 'Avatar pressed!'), matching the original onLogoPressed / onAvatarPressed. The original's` &&
                 ` Device.media handler (which toggles productName/secondTitle/searchField/searchButton visibility per screen range) is a device-responsive behaviour not reproduced server-side; those controls keep` &&
                 ` their static initial visibility (searchButton visible='false'). // NOTE: Both ToolHeaders, all OverflowToolbarLayoutData priorities/groups, the ToolHeaderUtilitySeparator and the` &&
                 ` OverflowToolbarButtons are reproduced 1:1, including the original's Cyrillic-o typo in 'Prоduct Name'.`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.tnt`            control = `sap.tnt.ToolPage`                    name = `ToolPage`                            class = `z2ui5_cl_ai_app_167` path = `src/05/b06/z2ui5_cl_ai_app_167.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        release = `1.84`
        release_post171 = abap_true
        is_post171 = abap_true
        notes = `IMPROVISED: NavigationListItem.selectable is the expression binding {= ${items}.length > 3} in the original; per the thin-frontend rule that presentation logic is computed in ABAP into a flat` &&
                 ` 'selectable' field (children count > 3) and bound directly. The controller event handlers (onSideNavButtonPress toggling the side, onItemPress, onItemSelect navigating the NavContainer via to(),` &&
                 ` handleUserNamePress opening a popover, fixed-item quickActionPress) are raised as client MESSAGE_TOAST here; the NavContainer shows its initialPage (page2) but page-to-page navigation is not wired` &&
                 ` (would need a backend roundtrip). // POST-1.71: ariaHasPopup is bound on the header Button (Alan Smith) and the fixed NavigationListItem, exactly as the original sample - sap.m.Button.ariaHasPopup` &&
                 ` exists since UI5 1.84 (> 1.71), kept for faithfulness. // NOTE: The full 14-item navigation tree (with its nested child lists, incl. Root Item 3's 38 children) and the 4-item fixed navigation are` &&
                 ` inlined from data.json. The page2 ScrollContainer's multi-paragraph lorem-ipsum filler text is abbreviated to a short placeholder.`
        post171 = `ariaHasPopup is bound on the header Button (Alan Smith) and the fixed NavigationListItem, exactly as the original sample - sap.m.Button.ariaHasPopup exists since UI5 1.84 (> 1.71), kept for` &&
                 ` faithfulness.`
        use_ec = abap_true
        use_ec_arg = abap_true
        use_name = abap_true )
      ( module = `sap.ui.codeeditor`  control = `sap.ui.codeeditor.CodeEditor`        name = `CodeEditor`                          class = `z2ui5_cl_ai_app_114` path = `src/02/b01/z2ui5_cl_ai_app_114.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: Breadth-probe: the ACE-based sap.ui.codeeditor CodeEditor (a wrapped third-party editor). JSON value shortened to a representative snippet; literal braces escaped so the XMLView parser does not` &&
                 ` read them as a binding.` )
      ( module = `sap.ui.codeeditor`  control = `sap.ui.codeeditor.CodeEditor`        name = `CodeEditorIconTabHeader`             class = `z2ui5_cl_ai_app_150` path = `src/02/b08/z2ui5_cl_ai_app_150.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `LIVE-TEST: The IconTabHeader select is wired to a backend event; the original swapped the CodeEditor content per selected tab (A/B) imperatively. The ce:CodeEditor (javascript) renders 1:1.` )
      ( module = `sap.ui.core`        control = `sap.ui.core.BusyIndicator`           name = `BusyIndicator`                       class = `z2ui5_cl_ai_app_147` path = `src/02/b07/z2ui5_cl_ai_app_147.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `LIVE-TEST: Each button opened the global sap.ui.core.BusyIndicator with a different delay/duration (show(delay) + setTimeout(hide)); reproduced here as client-side MessageToasts describing the` &&
                 ` intended delay/duration (the global busy overlay and timers are not reproduced server-side).`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.ui.core`        control = `sap.ui.core.Control`                 name = `ControlBusyIndicator`                class = `z2ui5_cl_ai_app_130` path = `src/02/b03/z2ui5_cl_ai_app_130.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `LIVE-TEST: The 'Toggle Busy State' button flips a boolean model field bound to Panel1.busy and the Icon.busy (both added to carry the binding; the original set busy imperatively via byId().setBusy).` &&
                 ` The original set both busy=true then cleared them after a 5s setTimeout; the client-side auto-reset is simplified to a server-side toggle.` )
      ( module = `sap.ui.core`        control = `sap.ui.core.HTML`                    name = `Html`                                class = `z2ui5_cl_ai_app_120` path = `src/02/b01/z2ui5_cl_ai_app_120.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: Breadth-probe: raw HTML injected via the sap.ui.core.HTML content attribute (the builder xml-escapes the markup into the attribute value). Lorem text shortened.` )
      ( module = `sap.ui.core`        control = `sap.ui.core.hyphenation.Hyphenation` name = `HyphenationAPI`                      class = `z2ui5_cl_ai_app_146` path = `src/02/b07/z2ui5_cl_ai_app_146.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `LIVE-TEST: The three core:HTML panels are filled by the original controller with hyphenated text via the Hyphenation API (per language); here the HTML content is left empty (the hyphenation happens` &&
                 ` client-side against the API). The width Slider liveChange is wired to a backend event (original resized the container imperatively).` )
      ( module = `sap.ui.core`        control = `sap.ui.core.Icon`                    name = `Icon`                                class = `z2ui5_cl_ai_app_122` path = `src/02/b02/z2ui5_cl_ai_app_122.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `LIVE-TEST: The stethoscope Icon press is wired client-side to MessageToast.show('Over budget!') via the control_global frontend action, matching the original controller's handleStethoscopePress` &&
                 ` (MessageToast.show).`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.ui.core`        control = `sap.ui.core.InvisibleMessage`        name = `InvisibleMessage`                    class = `z2ui5_cl_ai_app_141` path = `src/02/b05/z2ui5_cl_ai_app_141.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `LIVE-TEST: The four buttons announce the pressed button's type+text to the sap.ui.core.InvisibleMessage a11y service and echo it into the status Text; here a press updates the bound status Text with a` &&
                 ` generic confirmation (the a11y live-region announce and the per-button identity are not reproduced server-side). The original's 'Infromation' button-text typo is kept 1:1.` )
      ( module = `sap.ui.core`        control = `sap.ui.core.InvisibleText`           name = `InvisibleText`                       class = `z2ui5_cl_ai_app_127` path = `src/02/b02/z2ui5_cl_ai_app_127.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `LIVE-TEST: All twelve Button presses are wired to a single client-side MessageToast.show('Pressed') via the control_global frontend action. The original onPress toasted source.getId() + ' Pressed'` &&
                 ` (the runtime-generated control id); the id is not reproducible statically, so a fixed 'Pressed' toast stands in. The ariaLabelledBy / ariaDescribedBy associations and the six core:InvisibleText` &&
                 ` targets are reproduced 1:1.`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.ui.core`        control = `sap.ui.core.theming.Parameters`      name = `BasicThemeParameters`                class = `z2ui5_cl_ai_app_131` path = `src/02/b03/z2ui5_cl_ai_app_131.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: The sample itself is just a MessageStrip + Link pointing at the Theme Parameter Toolbox (the real demo content lives in that external tool); reproduced 1:1.` )
      ( module = `sap.ui.core`        control = `sap.ui.model.type.Currency`          name = `TypeCurrency`                        class = `z2ui5_cl_ai_app_135` path = `src/02/b04/z2ui5_cl_ai_app_135.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: Composite data-type binding paradigm: the Currency type is pulled in via core:require and every Input/Text binds a composite parts:['/amount','/currency'] with type:'CurrencyType' plus` &&
                 ` formatOptions (showMeasure/showNumber/preserveDecimals/currencyCode/style) 1:1. The two model fields amount ('123456789.123') and currency ('USD') are serialized by abap2UI5 as /AMOUNT and /CURRENCY;` &&
                 ` the paths are generated via _bind (never hardcoded).` )
      ( module = `sap.ui.core`        control = `sap.ui.model.type.Integer`           name = `TypeInteger`                         class = `z2ui5_cl_ai_app_129` path = `src/02/b03/z2ui5_cl_ai_app_129.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: Data-type binding paradigm: the Integer type module is pulled in with core:require='{IntegerType: sap/ui/model/type/Integer}' and the Input/Text bindings carry type:'IntegerType' plus` &&
                 ` formatOptions (min/maxIntegerDigits) 1:1. The single model field 'number' (initial '123') is serialized by abap2UI5 as /NUMBER, so the original raw '/number' paths are written as '/NUMBER'.` )
      ( module = `sap.ui.integration` control = `sap.ui.integration.Card`             name = `CardsLayout`                         class = `z2ui5_cl_ai_app_118` path = `src/02/b01/z2ui5_cl_ai_app_118.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `IMPROVISED: Breadth-probe of the declarative-card paradigm: a sap.ui.integration.widgets.Card whose whole UI comes from a JSON manifest. The manifest is carried as an ABAP string and bound to the` &&
                 ` Card. The original binds several manifests from a named model; here one inline List-card manifest probes whether abap2UI5 can drive an integration card at all.` )
      ( module = `sap.ui.integration` control = `sap.ui.integration.widgets.Card`     name = `CardExplorer`                        class = `z2ui5_cl_ai_app_149` path = `src/02/b08/z2ui5_cl_ai_app_149.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: The sample itself is a Link + Image pointing at the Card Explorer tool (the actual integration Cards live in that tool); reproduced 1:1. The Image press shows a client MessageToast (original` &&
                 ` onImagePress opened the tool).`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.BlockLayout`           name = `BlockLayoutCustomBackground`         class = `z2ui5_cl_ai_app_140` path = `src/02/b05/z2ui5_cl_ai_app_140.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        release = `1.98`
        release_post171 = abap_true
        is_post171 = abap_true
        notes = `NOTE: BlockLayout with six rows / seven cells across background color shades A-F; the Select (11 ColorSet items) and every cell's backgroundColorSet are two-way bound to one model field (initial` &&
                 ` ColorSet5), reproducing the original {/colorSet} wiring. Cell body texts are reproduced 1:1 (long ones split with &&). // POST-1.71: sap.m.Label.showColon is used (since UI5 1.98). The BlockLayout` &&
                 ` entity itself is in scope; showColon renders the label's trailing colon 1:1.`
        post171 = `sap.m.Label.showColon is used (since UI5 1.98). The BlockLayout entity itself is in scope; showColon renders the label's trailing colon 1:1.` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.cssgrid.CSSGrid`       name = `CSSGrid`                             class = `z2ui5_cl_ai_app_124` path = `src/02/b02/z2ui5_cl_ai_app_124.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `LIVE-TEST: The Slider liveChange reproduces onSliderMoved server-side: Slider.value is two-way bound and the CSSGrid host Panel.width (bound to a model field) is recomputed as value + '%' on a backend` &&
                 ` round-trip. The original set Slider.value=100 statically and drove byId('gridLayout').setWidth imperatively; here value and width carry bindings to carry that behaviour. // NOTE: The five core:HTML` &&
                 ` tiles carry raw HTML in the content attribute (the builder xml-escapes it, matching the original's escaped &lt;header&gt;/&lt;aside&gt;/&lt;article&gt;/&lt;footer&gt; content 1:1, including the` &&
                 ` original's quirks: the double space in '<aside  ...>Navigation</aside >' and the mismatched '<aside ...>Related Links</article>' close tag).` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.cssgrid.CSSGrid`       name = `GridAutoFlow`                        class = `z2ui5_cl_ai_app_145` path = `src/02/b06/z2ui5_cl_ai_app_145.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `LIVE-TEST: The RadioButtonGroup select is wired to a backend event; the original switched CSSGrid.gridAutoFlow (Column/ColumnDense/Row/RowDense) imperatively per selected index. The 'Reveal Grid'` &&
                 ` ToggleButton used a demo-only RevealGrid helper module (grid outline overlay) — reduced to a backend event. // NOTE: grid:CSSGrid with gridAutoFlow + 10 VBox demo boxes, four carrying` &&
                 ` GridItemLayoutData row/column spans, 1:1.` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.DynamicSideContent`    name = `DynamicSideContent`                  class = `z2ui5_cl_ai_app_138` path = `src/02/b05/z2ui5_cl_ai_app_138.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `LIVE-TEST: The Toggle button, the width Slider (liveChange) and the DynamicSideContent breakpointChanged are wired to backend events; the original drove them imperatively (toggle(), $().width(),` &&
                 ` getCurrentBreakpoint()) — device/DOM behaviours not reproduced server-side. // NOTE: The hint Text.visible is bound to a boolean model field (initial true); the original used a literal` &&
                 ` visible='getVisible()' (a sample quirk) toggled per Device.system.phone in onBeforeRendering. The two long body texts are shortened representative Lorem (not gate-compared, static).` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.FixFlex`               name = `FixFlexVertical`                     class = `z2ui5_cl_ai_app_119` path = `src/02/b01/z2ui5_cl_ai_app_119.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `IMPROVISED: Breadth-probe: sap.ui.layout.FixFlex (fixed image + flexible text). The named-model image path (img>/products/pic1) is resolved to a static OpenUI5 product image.` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.Form`             name = `FormToolbar`                         class = `z2ui5_cl_ai_app_142` path = `src/02/b06/z2ui5_cl_ai_app_142.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: sap.ui.layout.form.Form with two FormContainers, per-container toolbars, ResponsiveGridLayout, FormElements with GridData layoutData and a Select. The original bound an element context` &&
                 ` (/SupplierCollection/0 from the shared demo supplier.json); flattened here to top-level model fields the {…} bindings resolve against.`
        use_name = abap_true )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.Grid`                  name = `GridData`                            class = `z2ui5_cl_ai_app_169` path = `src/02/b10/z2ui5_cl_ai_app_169.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `IMPROVISED: The eight Sliders' liveChange='.onSliderMoved' handler is dropped. The original controller resizes the next grid wrapper via jQuery DOM traversal` &&
                 ` (oSlider.$().parent().next().find('.gridWrapper'), then Element.closestTo(...).setWidth(value + '%')) - a live DOM manipulation with no server-reachable or bindable equivalent (it addresses a sibling` &&
                 ` by rendered DOM position, not by control id or model path). The Sliders render 1:1 but do not resize the grids; the responsive GridData behaviour is still observable by resizing the browser window.` &&
                 ` // NOTE: The sample's styles.css (.GridDataSample .exampleDiv / .propertiesDisplay / p) is injected via a single core:HTML <style> leaf as the first child of the outer VerticalLayout (abap2UI5 ships` &&
                 ` no separate css file). CSS braces are escaped \{ \} in a backtick literal so the backslash survives to the serialized attribute, otherwise the XMLView binding parser would read them as bindings and` &&
                 ` crash view creation. This adds one core:HTML control not present in the original view.xml. // NOTE: The core:HTML 'content' divs and the FormattedText 'htmlText' are written as the decoded literal` &&
                 ` markup (e.g. <div class=exampleDiv></div>); the original view.xml carries them HTML-entity-encoded (&lt;div ...&gt;) and the builder re-escapes the literal on stringify. Multi-line div contents in` &&
                 ` the original are written single-line here (whitespace-only difference, not a binding).` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.HorizontalLayout`      name = `HorizontalLayout`                    class = `z2ui5_cl_ai_app_162` path = `src/02/b09/z2ui5_cl_ai_app_162.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: The original uses a separate 'img' JSON model for the image src ({img>/products/pic1}) alongside the default model for the widths. abap2UI5 has one default model, so the picture path is folded` &&
                 ` into it and the src binds it directly - the 'img>' prefix is dropped and the path flattened to a single field (pic1); the last path segment is identical, which structural-diff matches. Widths use the` &&
                 ` desktop values (the original's phone branch is a client-only Device decision).` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.Splitter`              name = `Splitter2`                           class = `z2ui5_cl_ai_app_125` path = `src/02/b02/z2ui5_cl_ai_app_125.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` )
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                  name = `Basic`                               class = `z2ui5_cl_ai_app_115` path = `src/02/b01/z2ui5_cl_ai_app_115.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `IMPROVISED: Breadth-probe: a minimal sap.ui.table.Table (grid table, distinct from sap.m.Table) with 3 columns + template cells over a small ABAP model. The original's full column set, the` &&
                 ` p:ColumnAIAction plugin (post-1.71) and paste handling are omitted for the probe.`
        use_name = abap_true )
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                  name = `MultiHeader`                         class = `z2ui5_cl_ai_app_137` path = `src/02/b05/z2ui5_cl_ai_app_137.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: sap.ui.table grid Table with multi-level column headers (multiLabels + headerSpan '3,2'/'2') and an extension OverflowToolbar. The 5 contact rows are inlined from the controller's JSON model;` &&
                 ` column templates bind {SUPPLIER}/{STREET}/{CITY}/{PHONE}/{OPENORDERS} 1:1.`
        use_name = abap_true )
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                  name = `RowModes`                            class = `z2ui5_cl_ai_app_164` path = `src/02/b10/z2ui5_cl_ai_app_164.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: The original splits UI state into a separate 'ui' JSON model and binds the row mode from it ({ui>/rowMode}) in two places - the Table's rowMode aggregation and the footer SegmentedButton's` &&
                 ` selectedKey - while the grid rows come from the default model ({/ProductCollection}). abap2UI5 has one default model, so the row mode is folded into it and both places bind it directly - the 'ui>'` &&
                 ` prefix is dropped and the path flattened to a single field (rowMode); the last path segment is identical, which structural-diff matches. // NOTE: The shared 123-row demo ProductCollection` &&
                 ` (sap/ui/demo/mock/products.json) is inlined into model_init with the five columns the sample binds (Name, Category, ProductPicUrl, Quantity, DeliveryDate). The original computes DeliveryDate from` &&
                 ` Date.now() with an i-mod-10 offset; a fixed base date (2026-07-23) is used here so the port is deterministic - a client-only display decision. The Quantity and DeliveryDate columns keep the original` &&
                 ` typed complex bindings (sap.ui.model.type.Integer / .Date with timestamp source).`
        use_name = abap_true )
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Calendar`             name = `CalendarCalendarType`                class = `z2ui5_cl_ai_app_151` path = `src/02/b08/z2ui5_cl_ai_app_151.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `LIVE-TEST: Calendar with primaryCalendarType Islamic / secondaryCalendarType Gregorian. select and 'Focus Today' are wired to backend events that write the current server date (Gregorian yyyy-MM-dd)` &&
                 ` into the bound Text; the original formatted the selected day / focused today via DateFormat + UI5Date.` )
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Calendar`             name = `CalendarSingleDaySelection`          class = `z2ui5_cl_ai_app_139` path = `src/02/b05/z2ui5_cl_ai_app_139.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `LIVE-TEST: Calendar.select and the 'Select Today' button are wired to backend events that write the current server date (yyyy-MM-dd) into the bound status Text. The original formatted` &&
                 ` getSelectedDates()[0].getStartDate() / added a DateRange(today) with DateFormat + UI5Date; reading the actually clicked day out of the transpiled event is simplified to the server date.` )
      ( module = `sap.ui.unified`     control = `sap.ui.unified.ColorPicker`          name = `ColorPickerSimplified`               class = `z2ui5_cl_ai_app_112` path = `src/02/b01/z2ui5_cl_ai_app_112.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: Breadth-probe (cross-library capability test). Inline sap.ui.unified ColorPicker (HSL / Simplified). The button's ResponsivePopover-with-ColorPicker is simplified to a toast.` )
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Currency`             name = `CurrencyInTable`                     class = `z2ui5_cl_ai_app_171` path = `src/02/b10/z2ui5_cl_ai_app_171.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `LIVE-TEST: u:Currency binds a nested object path (value={transactionAmount/size}, currency={transactionAmount/currency}). Ported as a nested ABAP structure TRANSACTION_AMOUNT (fields SIZE/CURRENCY),` &&
                 ` bound {TRANSACTION_AMOUNT/SIZE} / {TRANSACTION_AMOUNT/CURRENCY}. CAPABILITIES.md documents nested TABLES/trees but not a nested single (non-array) structure within a row, so the nested-object` &&
                 ` serialization + relative sub-path binding needs a live render check.`
        use_name = abap_true )
      ( module = `sap.ui.unified`     control = `sap.ui.unified.FileUploader`         name = `FileUploaderBasic`                   class = `z2ui5_cl_ai_app_126` path = `src/02/b02/z2ui5_cl_ai_app_126.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `LIVE-TEST: The full upload cycle is backend/endpoint dependent, so it is reduced to client-side MessageToasts: 'Upload File' press shows an upload-started toast (original handleUploadPress ran` &&
                 ` checkFileReadable().then(upload)), and FileUploader.uploadComplete shows the hardcoded success message the original built (handleUploadComplete parsed a hardcoded 'Status: 200' response and toasted` &&
                 ` '(Upload Success)'). The uploadUrl='upload/' is kept 1:1.`
        use_ec = abap_true
        use_ec_arg = abap_true )
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`           name = `ObjectPageSubSection`                class = `z2ui5_cl_ai_app_116` path = `src/03/b01/z2ui5_cl_ai_app_116.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `IMPROVISED: Breadth-probe: a minimal sap.uxap.ObjectPageLayout (header title + section + two subsections). The original's blocks are custom JS view controls (sample:MultiViewBlock) — not expressible` &&
                 ` in the declarative builder — so they are replaced with sap.m.Text content for the rendering probe.` )
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`           name = `SingleView`                          class = `z2ui5_cl_ai_app_161` path = `src/03/b02/z2ui5_cl_ai_app_161.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `IMPROVISED: Wall-break for sap.uxap: the original blocks aggregation holds a custom BlockBase control (blockcolor:BlockBlue from the sample's SharedBlocks JS). A BlockBase is only a lazy-loading` &&
                 ` wrapper around a view; its content (a single coloured div) is inlined here as core:HTML, since ObjectPageSubSection.blocks accepts any sap.ui.core.Control. This removes the need for a custom JS` &&
                 ` control - the whole uxap ObjectPage renders with the thin generic frontend. The blockcolor:BlockBlue control is therefore absent and a core:HTML is present in its place.` ) ).

  ENDMETHOD.


  METHOD build_tree.

    " group the (already module/control/sample-sorted) apps into the nested tree;
    " each sample leaf keeps the links so its popover can jump the same places.
    " Read the last row only after an explicit lines( ) > 0 guard on its own
    " statement - a table expression behind a short-circuit OR ( result IS
    " INITIAL OR result[ ... ] ) is hoisted ahead of the guard by the 7.02
    " downport, which then reads the still-empty table on the first pass and
    " dumps. build_tree runs on the transpiled Node backend too, so keep the
    " emptiness check separate.
    LOOP AT it_app INTO DATA(ls_app).

      DATA(lv_new_module) = abap_true.
      IF lines( result ) > 0.
        ASSIGN result[ lines( result ) ] TO FIELD-SYMBOL(<last_module>).
        IF <last_module>-text = ls_app-module.
          lv_new_module = abap_false.
        ENDIF.
      ENDIF.
      IF lv_new_module = abap_true.
        APPEND VALUE #( text = ls_app-module ) TO result.
      ENDIF.
      ASSIGN result[ lines( result ) ] TO FIELD-SYMBOL(<module>).

      DATA(lv_new_control) = abap_true.
      IF lines( <module>-nodes ) > 0.
        ASSIGN <module>-nodes[ lines( <module>-nodes ) ] TO FIELD-SYMBOL(<last_control>).
        IF <last_control>-text = ls_app-ctrl_name.
          lv_new_control = abap_false.
        ENDIF.
      ENDIF.
      IF lv_new_control = abap_true.
        APPEND VALUE #( text = ls_app-ctrl_name ) TO <module>-nodes.
      ENDIF.
      ASSIGN <module>-nodes[ lines( <module>-nodes ) ] TO FIELD-SYMBOL(<control>).

      APPEND VALUE #( text      = |{ ls_app-name } - { ls_app-class }|
                      api_url   = ls_app-api_url
                      js_url    = ls_app-js_url
                      ui5_url   = ls_app-ui5_url
                      abap_url  = ls_app-abap_url
                      start_url = ls_app-start_url
                      has_link  = abap_true ) TO <control>-nodes.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
