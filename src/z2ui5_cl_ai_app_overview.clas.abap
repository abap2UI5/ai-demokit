"! Generated overview app - lists every abap2UI5 api sample app in a table.
"! The search field filters the table on the client (binding_call Contains, no
"! round-trip); its query is two-way bound (search_query), so it survives a
"! round-trip or an app state restore (draft) and view_display re-applies the
"! filter via follow_up_action.
"! The title carries the ported-app count in parentheses. The sortable Since
"! column (next to Control) shows the UI5 release the CONTROL appeared in (from
"! ui5/universe.json; blank when older than tracking / since forever). It is
"! coloured orange (ObjectStatus Warning) when newer than UI5 1.71; a deprecated
"! control's name is struck through (FormattedText htmlText, so the strikethrough
"! can vary per row). There is no per-SAMPLE Since column - whether a sample needs
"! a release newer than 1.71 is carried by the Hide-newer-than-1.71 filter and
"! spelled out in the Open column's info popover.
"! Three header checkboxes (default all on) filter the table
"! entirely on the client via each row's visible expression: Hide non-OpenUI5,
"! Hide newer than 1.71 (2020), Hide deprecated (the ui5_only flag behind the
"! first one has no column of its own - the badge column was dropped 2026-07-29).
"! A Shell switch toggles the
"! sap.m.Shell letterboxing (appWidthLimited), client-side. Navigation lives in
"! the trailing Open column, which carries three buttons, each anchored to its
"! own runtime id. The chain-link one opens the LINKS popover: four full-width
"! Transparent Buttons - Control API Reference, Sample Link, Sample Source Code,
"! abap2UI5 Source Code, each opening its target in a new tab through the
"! URLHELPER REDIRECT frontend action (a Button carries no href, and open_new_tab
"! is same-origin only). The second starts
"! this abap2UI5 app directly in a new tab (open_new_tab; the start URL is
"! same-origin, so it passes isValidRedirectURL) - the overview stays open in its
"! own tab. The trailing information one opens the INFO popover with the
"! port's generation notes - live-check status, the members that need a release
"! newer than 1.71, and the deviation list as a bullet list; it renders only on a
"! row that carries at least one of the three.
"! The Rating column is a 1-5 "by feel" score of
"! how much attention a port deserves (not coloured): app complexity, how heavily
"! it was reworked/corrected (IMPROVISED/DROPPED_171/SUBSET_DATA/NOTE), whether it
"! was reviewed/discussed (it carries a checked block), and how important a live
"! re-test is (pending LIVE_TESTs, roundtrip-free wiring, popups, needs-newer-UI5);
"! 1 = simple faithful 1:1, 5 = complex/reworked/worth a close look. Sort it
"! descending to surface the samples worth a closer manual look.
"! The search field above the table filters all rows by a
"! substring over the text columns (module, control, since, sample,
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
        ui5_only      TYPE abap_bool,
        is_post171    TYPE abap_bool,
        is_deprecated TYPE abap_bool,
        dep_text  TYPE string,
        ctrl_html TYPE string,
        score       TYPE i,
        score_tip   TYPE string,
        filter    TYPE string,
      END OF ty_s_app.
    TYPES ty_t_app TYPE STANDARD TABLE OF ty_s_app WITH EMPTY KEY.

    DATA t_app TYPE ty_t_app.
    " the search field's text (two-way, so it survives a round-trip and the
    " draft): the filter itself runs on the client, but only a value that is
    " part of the MODEL comes back when the app is restored. view_display
    " re-applies the filter for a non-initial query via follow_up_action.
    DATA search_query TYPE string.
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
    METHODS link_press
      IMPORTING
        url           TYPE string
      RETURNING
        VALUE(result) TYPE string.

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
        " the four link buttons for the pressed row; resolved client-side and
        " passed via t_arg, opened in a popover anchored to the button (arg 5)
        DATA(lv_api)  = client->get_event_arg( ).
        DATA(lv_js)   = client->get_event_arg( 2 ).
        DATA(lv_ui5)  = client->get_event_arg( 3 ).
        DATA(lv_abap) = client->get_event_arg( 4 ).

        DATA(links) = z2ui5_cl_ai_xml=>factory( ).
        DATA(box) = links->open( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`

            )->open( `Popover`
                )->a( n = `title`        v = `Links`
                )->a( n = `placement`    v = `Auto`
                )->a( n = `contentWidth` v = `26rem`

                )->open( `VBox`
                    )->a( n = `class` v = `sapUiContentPadding` ).

        " One full-width Transparent Button per target, stacked in the VBox. A
        " Button cannot carry an href, and cs_event-open_new_tab is same-origin
        " only (isValidRedirectURL), so the press goes through the URLHELPER
        " REDIRECT frontend action with { URL, NEW_WINDOW: true } - the same
        " new-tab behaviour a Link target="_blank" had, client-side and with no
        " round-trip. The URL is also the tooltip, so it stays readable/copyable.
        " The three OpenUI5 targets are empty for a ui5_only row (the control is
        " not in the OpenUI5 checkout), so each renders only when it resolves.
        IF lv_api IS NOT INITIAL.
          box->leaf( `Button`
              )->a( n = `text`    v = `Control API Reference`
              )->a( n = `icon`    v = `sap-icon://document-text`
              )->a( n = `type`    v = `Transparent`
              )->a( n = `width`   v = `100%`
              )->a( n = `tooltip` v = lv_api
              )->a( n = `class`   v = `sapUiTinyMarginBottom`
              )->a( n = `press`   v = link_press( lv_api ) ).
        ENDIF.
        IF lv_ui5 IS NOT INITIAL.
          box->leaf( `Button`
              )->a( n = `text`    v = `Sample Link`
              )->a( n = `icon`    v = `sap-icon://sys-monitor`
              )->a( n = `type`    v = `Transparent`
              )->a( n = `width`   v = `100%`
              )->a( n = `tooltip` v = lv_ui5
              )->a( n = `class`   v = `sapUiTinyMarginBottom`
              )->a( n = `press`   v = link_press( lv_ui5 ) ).
        ENDIF.
        IF lv_js IS NOT INITIAL.
          box->leaf( `Button`
              )->a( n = `text`    v = `Sample Source Code`
              )->a( n = `icon`    v = `sap-icon://source-code`
              )->a( n = `type`    v = `Transparent`
              )->a( n = `width`   v = `100%`
              )->a( n = `tooltip` v = lv_js
              )->a( n = `class`   v = `sapUiTinyMarginBottom`
              )->a( n = `press`   v = link_press( lv_js ) ).
        ENDIF.
        box->leaf( `Button`
            )->a( n = `text`    v = `abap2UI5 Source Code`
            )->a( n = `icon`    v = `sap-icon://syntax`
            )->a( n = `type`    v = `Transparent`
            )->a( n = `width`   v = `100%`
            )->a( n = `tooltip` v = lv_abap
            )->a( n = `press`   v = link_press( lv_abap ) ).

        " say why the reference links are missing rather than leaving a gap
        IF lv_api IS INITIAL.
          box->leaf( `MessageStrip`
              )->a( n = `text`      v = `This control is in no OpenUI5 checkout, so this sample has no Control API Reference, Sample Link or Sample Source Code.`
              )->a( n = `type`      v = `Information`
              )->a( n = `showIcon`  v = `true`
              )->a( n = `class`     v = `sapUiSmallMarginTop` ).
        ENDIF.

        client->popover_display( xml   = links->stringify( )
                                 by_id = client->get_event_arg( 5 ) ).

      WHEN `INFO`.
        " everything the generator knows ABOUT the port (as opposed to where it
        " points): the live-check status, the members that need a UI5 release
        " newer than 1.71, and the deviation notes. Own popover behind the info
        " button, anchored to it (arg 4); the button only renders on a row that
        " carries at least one of the three.
        DATA(lv_checked) = client->get_event_arg( ).
        DATA(lv_post171) = client->get_event_arg( 2 ).
        DATA(lv_notes)   = client->get_event_arg( 3 ).

        DATA(info) = z2ui5_cl_ai_xml=>factory( ).
        DATA(ibox) = info->open( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`

            )->open( `Popover`
                )->a( n = `title`        v = `Generation notes`
                )->a( n = `placement`    v = `Auto`
                )->a( n = `contentWidth` v = `30rem`

                )->open( `VBox`
                    )->a( n = `class` v = `sapUiContentPadding` ).

        IF lv_checked IS NOT INITIAL.
          ibox->leaf( `ObjectStatus`
              )->a( n = `text`  v = lv_checked
              )->a( n = `state` v = `Success` ).
        ENDIF.

        IF lv_post171 IS NOT INITIAL.
          ibox->leaf( `ObjectStatus`
              )->a( n = `text`  v = |Needs a UI5 release newer than 1.71: { lv_post171 }|
              )->a( n = `state` v = `Warning`
              )->a( n = `class` v = `sapUiTinyMarginTop` ).
        ENDIF.

        IF lv_notes IS NOT INITIAL.
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
          ibox->leaf( `FormattedText`
              )->a( n = `htmlText` v = lv_html ).
        ENDIF.

        client->popover_display( xml   = info->stringify( )
                                 by_id = client->get_event_arg( 4 ) ).

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

      " the three reference links point into OpenUI5 - API reference, sample
      " source, live runner - so they only exist for a library OpenUI5 ships.
      " A ui5_only row (control not in the OpenUI5 checkout) has none of the
      " three there: leaving them built would hand out four links of which three
      " 404, and the commercial host is not an option (pattern-lint
      " commercial-ui5-host).
      " They stay empty and the popover renders only what resolves - the ABAP
      " class link is repository-local and always correct
      IF <app>-ui5_only = abap_false.
        <app>-api_url = |https://sdk.openui5.org/api/{ <app>-control }|.
        <app>-js_url  = |https://github.com/SAP/openui5/tree/master/src/{ <app>-module }| &&
                        |/test/{ libpath }/demokit/sample/{ <app>-name }|.
        <app>-ui5_url = |https://sdk.openui5.org/resources/sap/ui/documentation/sdk/index.html| &&
                        |?sap-ui-xx-sample-id={ <app>-module }.sample.{ <app>-name }| &&
                        |&sap-ui-xx-sample-lib={ <app>-module }|.
      ENDIF.
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
      " Sample, abap2UI5 (class) - so a query like "Date" no longer
      " matches hidden text buried in the notes/checked/post-1.71 fields
      <app>-filter = <app>-module && ` ` && <app>-ctrl_name && ` ` &&
                     <app>-since  && ` ` && <app>-name      && ` ` &&
                     <app>-class.

    ENDLOOP.

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
                        " client-side filter over the table: liveChange/search run
                        " a binding_call Contains filter via _event_client (no round-trip)
                        )->leaf( `SearchField`
                            )->a( n = `placeholder` v = `Search the table - module, control, since, sample, class`
                            )->a( n = `width`       v = `24rem`
                            " two-way bound so the typed query is part of the model and
                            " comes back with the app state (round-trip, draft restore);
                            " the filtering itself stays client-side (below)
                            )->a( n = `value`       v = client->_bind( search_query )
                            )->a( n = `liveChange`  v = client->_event_client( val = client->cs_event-binding_call t_arg = VALUE #( ( `idOverviewTable` ) ( `items` ) ( `filter` ) ( `FILTER` ) ( `Contains` ) ( `${$parameters>/newValue}` ) ) )
                            )->a( n = `search`      v = client->_event_client( val = client->cs_event-binding_call t_arg = VALUE #( ( `idOverviewTable` ) ( `items` ) ( `filter` ) ( `FILTER` ) ( `Contains` ) ( `${$parameters>/query}` ) ) )
                        " default-on filter checkboxes; each is two-way bound and the row
                        " visible expression reacts live (no round-trip)
                        )->leaf( `CheckBox`
                            )->a( n = `text`     v = `Hide non-OpenUI5`
                            )->a( n = `selected` v = client->_bind( hide_non_ui5 )
                            )->a( n = `tooltip`  v = `Hide samples whose control is not part of OpenUI5`
                        )->leaf( `CheckBox`
                            )->a( n = `text`     v = `Hide newer than 1.71 (2020)`
                            )->a( n = `selected` v = client->_bind( hide_post171 )
                            )->a( n = `tooltip`  v = `Hide samples that need a UI5 release newer than 1.71`
                        )->leaf( `CheckBox`
                            )->a( n = `text`     v = `Hide deprecated`
                            )->a( n = `selected` v = client->_bind( hide_deprecated )
                            )->a( n = `tooltip`  v = `Hide samples whose control is deprecated`
                        )->leaf( `ToolbarSpacer`
                        )->leaf( `Label`
                            )->a( n = `text` v = `Shell`
                        " Shell on/off = sap.m.Shell letterboxing (two-way, drives appWidthLimited)
                        )->leaf( `Switch`
                            )->a( n = `state`   v = client->_bind( shell_on )
                            )->a( n = `tooltip` v = `Toggle the Shell letterboxing (limited app width)`

                    )->shut(
                )->shut(

                )->open( `Table`
                    )->a( n = `id`      v = `idOverviewTable`
                    )->a( n = `sticky`  v = `ColumnHeaders`
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
                            )->a( n = `width` v = `9rem`
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
                            " no round-trip - like the Shell Switch.
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
                                )->leaf( `Text`
                                    )->a( n = `text` v = `{CLASS}`
                                " rating 1-5 (by feel): how much attention the port
                                " deserves - complexity, rework, review, test-priority
                                " (not coloured); tooltip lists the drivers
                                )->leaf( `Text`
                                    )->a( n = `text`    v = `{SCORE} / 5`
                                    )->a( n = `tooltip` v = `{SCORE_TIP}`

                                " Open column: three buttons, each anchored to its own runtime
                                " id ($event.oSource.sId). First opens the links popover (the
                                " four reference targets); second launches the abap2UI5 app
                                " directly in a new tab (open_new_tab - the start URL is
                                " same-origin, so it passes isValidRedirectURL), leaving the
                                " overview open in its own tab; third opens the
                                " generation-notes popover - shown only on a row that HAS
                                " something to say (checked / post-1.71 / notes)
                                )->open( `HBox`
                                    )->leaf( `Button`
                                        )->a( n = `icon`    v = `sap-icon://chain-link`
                                        )->a( n = `type`    v = `Transparent`
                                        )->a( n = `tooltip` v = `Links: Control API Reference, Sample Link, Sample Source Code, abap2UI5 Source Code`
                                        )->a( n = `press`   v = client->_event( val = `LINKS` t_arg = VALUE #(
                                            ( `${API_URL}` ) ( `${JS_URL}` ) ( `${UI5_URL}` ) ( `${ABAP_URL}` ) ( `$event.oSource.sId` ) ) )
                                    )->leaf( `Button`
                                        )->a( n = `icon`    v = `sap-icon://action`
                                        )->a( n = `type`    v = `Transparent`
                                        )->a( n = `tooltip` v = `Start this abap2UI5 app in a new tab`
                                        )->a( n = `press`   v = client->_event_client( val = client->cs_event-open_new_tab t_arg = VALUE #( ( `${START_URL}` ) ) )
                                    )->leaf( `Button`
                                        )->a( n = `icon`    v = `sap-icon://information`
                                        )->a( n = `type`    v = `Transparent`
                                        )->a( n = `tooltip` v = `Generation notes: how this port was built - live-check status, post-1.71 members, deviations`
                                        " a backtick literal, not a |…| template: ABAP ends a string
                                        " template at the next |, so the expression binding's || would
                                        " close it mid-way. Nothing here needs interpolation anyway.
                                        )->a( n = `visible` v = `{= ${HAS_CHECK} || ${HAS_P171} || ${HAS_NOTES} }`
                                        )->a( n = `press`   v = client->_event( val = `INFO` t_arg = VALUE #(
                                            ( `${CHECKED}` ) ( `${POST171}` ) ( `${NOTES}` ) ( `$event.oSource.sId` ) ) )

                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut( ).

    client->view_display( view->stringify( ) ).

    " Re-apply the client-side table filter for a restored query. The filter is
    " a frontend-only binding operation (the model keeps all rows), so a rebuilt
    " view starts unfiltered - while the SearchField, being two-way bound, does
    " show the query again. follow_up_action runs the very same binding_call
    " after the view was rendered, so both are back in sync.
    IF search_query IS NOT INITIAL.
      client->follow_up_action( val   = client->cs_event-binding_call
                                t_arg = VALUE #( ( `idOverviewTable` ) ( `items` ) ( `filter` ) ( `FILTER` ) ( `Contains` ) ( search_query ) ) ).
    ENDIF.

  ENDMETHOD.


  METHOD get_catalog.

    " A single VALUE #( ) holding every catalog row exceeds the maximum permitted
    " ABAP statement length, so the generator emits the catalog in size-bounded
    " chunks (a few rows each); every chunk after the first appends to the
    " previous ones via VALUE #( BASE result ). Texts too long to fit into their
    " own row are assigned to lv_textN just ahead of it - such a row is always
    " alone in its statement, because the next hoisting row reuses the variable.
    DATA lv_text1 TYPE string.
    DATA lv_text2 TYPE string.

    result = VALUE #(
      ( module = `sap.f`              control = `sap.f.Card`                            name = `Card`                                class = `z2ui5_cl_ai_app_117` path = `src/04/b01/z2ui5_cl_ai_app_117.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.64`
        notes = `IMPROVISED: Breadth-probe: sap.f.Card with a sap.f.cards.Header and a simplified content body - the original's From/To ComboBoxes (cities> named model), DatePicker and Book button are represented by a` &&
                 ` Text + a 'Buy Now' Button, and the sample's entire second Card (Project Cloud Transformation: List of CustomListItems over the products> named model with Title/Text/ObjectStatus) is dropped. Review` &&
                 ` 2026-07-27: both named models fold into the default model per CAPABILITIES 'Named JSON models' (the mocks are archived under ui5/sap.f/Card/model/), so the full sample is expressible - needs rework` &&
                 ` to a faithful rebuild.` ) ).

    lv_text1 = `NOTE: The controller's Card popover (onPressOpenPopover, wired to the GenericTag press and the 'Button with layoutData' press) is reproduced 1:1 since 2026-07-30: both presses fire OPEN_POPOVER with` &&
               ` $event.oSource.sId and the backend rebuilds view/Card.fragment.xml verbatim (Popover placement Bottom / showHeader false / contentWidth 300px > f:Card > card:NumericHeader 'Sales Revenue' with the` &&
               ` two card:NumericSideIndicator Target/Deviation rows) shown via popover_display( by_id = pressed control ) - the Fragment.load + openBy equivalent. The fragment's Popover, Card, NumericHeader and` &&
               ` NumericSideIndicator controls are counted by structural-diff against the union that includes the original's own Card.fragment.xml, so the counts match; both press attributes are restored 1:1. //` &&
               ` NOTE: The Edit button's press='.toggleAreaPriority' is reproduced since 2026-07-30: DynamicPageTitle.areaShrinkRatio is two-way bound ({/AREASHRINKRATIO}, an added attribute vs the original view -` &&
               ` declared here) seeded with the metadata default 1:1.6:1.6, and the TOGGLE_AREA_PRIORITY round-trip flips it to 1.6:1:1.6 and back (the controller read the default from`.
    lv_text1 = lv_text1 && ` getMetadata().getProperty('areaShrinkRatio').getDefaultValue(); the port seeds the same literal - re-verify should UI5 ever change the default). // NOTE: showFooter is two-way bound to a model flag` &&
               ` ({/SHOWFOOTER}, default false) and the 'Toggle Footer' button flips it via a TOGGLE_FOOTER round-trip + re-render; the original toggles it imperatively (setShowFooter). headerExpanded and` &&
               ` toggleHeaderOnTitleClick are likewise bound to model flags (both default true) - the original binds {/headerExpanded}/{/titleClickable} against a model that never sets them, so they fall back to the` &&
               ` control defaults, reproduced here explicitly. // NOTE: The shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json) is inlined with the columns the table binds (Name, ProductId,` &&
               ` SupplierName, Width, Depth, Height, DimUnit, Price, CurrencyCode). The Price/CurrencyCode Currency composite type binding and the items sorter (path 'Name') are kept 1:1 as raw binding-info strings.` &&
               ` // NOTE: Width/Depth/Height are TYPE string (not i): the mock carries decimal dimensions (40.8, 3.1) and they bind display-only into a text template ({WIDTH} x {DEPTH} x {HEIGHT} {DIMUNIT}), so a`.
    lv_text1 = lv_text1 && ` string keeps the exact value; TYPE i would truncate (an earlier version did, via json-to-abap's first-row inference — tool since fixed). Price stays packed (DECIMALS 2) for the Currency type binding,` &&
               ` decimals preserved.`.
    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.DynamicPage`                     name = `DynamicPageFreeStyle`                class = `z2ui5_cl_ai_app_170` path = `src/04/b07/z2ui5_cl_ai_app_170.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.42`
        notes = lv_text1 ) ).

    lv_text1 = `POST-1.71: sap.m.Avatar (control @since 1.73, incl. its src/class/press members) is used 1:1 in snappedContent and the DynamicPageHeader; needs UI5 >= 1.73. DynamicPage is the in-scope headline` &&
               ` control (@1.42); Avatar is a secondary control kept 1:1 per the post-1.71 member policy. // POST-1.71: sap.f.DynamicPage.breakpointChange (@since 1.147, incl. its currentRange/currentWidth` &&
               ` parameters) is the whole point of this sample and is wired 1:1 since 2026-07-30 as a view attribute (an added attr - the original attaches it imperatively in onInit via attachBreakpointChange):` &&
               ` BREAKPOINT_CHANGE transports ${$parameters>/currentRange} and ${$parameters>/currentWidth}, the backend maps Phone->M / Tablet->L / else XL into the two-way bound Avatar displaySize ({/AVATAR_SIZE},` &&
               ` an added attribute on both Avatars, seeded XL) and toasts Media Range: <range> (<width>px) exactly like onBreakpointChange. @since verified fork-openui5/src/sap.f/src/sap/f/DynamicPage.js:315.` &&
               ` Requires a UI5 release >= 1.147; on older releases the event never fires and the Avatars keep the seeded XL (the property gate is blind to sap.f event params). // LIVE-TEST: showFooter is two-way`.
    lv_text1 = lv_text1 && ` bound ({/SHOW_FOOTER}, default true) and the Toggle Footer button flips it on a round-trip (view_model_update) - the faithful abap2UI5 form of the controller's setShowFooter(!getShowFooter()); the` &&
               ` scalar literal showFooter="true" -> binding is not a structural diff. The Home/Examples/Avatar presses raise client-composed MessageToasts via _event_client control_global MESSAGE_TOAST` &&
               ` (roundtrip-free, apps 005/060). Both the footer round-trip and the toast wiring are unverified in a running system. // NOTE: The two Avatar src values point at the sdk.openui5.org host` &&
               ` (https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_275314.png) per the offline asset-URL rule; the original uses the relative ./test-resources path. Literal src values are not compared` &&
               ` by structural-diff.`.
    lv_text2 = `sap.m.Avatar (control @since 1.73, incl. its src/class/press members) is used 1:1 in snappedContent and the DynamicPageHeader; needs UI5 >= 1.73. DynamicPage is the in-scope headline control (@1.42);` &&
               ` Avatar is a secondary control kept 1:1 per the post-1.71 member policy. // sap.f.DynamicPage.breakpointChange (@since 1.147, incl. its currentRange/currentWidth parameters) is the whole point of this` &&
               ` sample and is wired 1:1 since 2026-07-30 as a view attribute (an added attr - the original attaches it imperatively in onInit via attachBreakpointChange): BREAKPOINT_CHANGE transports` &&
               ` ${$parameters>/currentRange} and ${$parameters>/currentWidth}, the backend maps Phone->M / Tablet->L / else XL into the two-way bound Avatar displaySize ({/AVATAR_SIZE}, an added attribute on both` &&
               ` Avatars, seeded XL) and toasts Media Range: <range> (<width>px) exactly like onBreakpointChange. @since verified fork-openui5/src/sap.f/src/sap/f/DynamicPage.js:315. Requires a UI5 release >= 1.147;` &&
               ` on older releases the event never fires and the Avatars keep the seeded XL (the property gate is blind to sap.f event params).`.
    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.DynamicPage`                     name = `DynamicPageResponsiveAvatar`         class = `z2ui5_cl_ai_app_244` path = `src/04/b10/z2ui5_cl_ai_app_244.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.42`
        is_post171 = abap_true
        notes = lv_text1
        post171 = lv_text2 ) ).

    lv_text1 = `NOTE: showFooter is two-way bound to a model flag ({/SHOWFOOTER}, default false) and the 'Toggle Footer' button flips it via a TOGGLE_FOOTER round-trip + re-render; the original controller toggles it` &&
               ` imperatively (onToggleFooter -> setShowFooter). The original view has no showFooter attribute (it defaults false), so adding the bound attribute is the faithful thin-frontend form of the imperative` &&
               ` toggle and structural-diff does not flag it (it only flags missing attributes). toggleHeaderOnTitleClick keeps the original {/titleClickable} binding (default true - the original binds it against a` &&
               ` model that never sets it, so it falls back to the control default). // NOTE: onGenericTagPress lazily Fragment.loads Card.fragment.xml (a Popover > sap.f.Card > sap.f.cards.NumericHeader with two` &&
               ` sap.f.cards.NumericSideIndicator) and openBy(the pressed GenericTag). The port builds that same popover server-side on the GENERIC_TAG_PRESS round-trip and shows it anchored to the pressed GenericTag` &&
               ` via client->popover_display( xml = ..., by_id = $event.oSource.sId ) - the popover XML parameter is named ``xml`` (not ``val`` like popup_display). Faithful (lazy either way), matches app 229; the`.
    lv_text1 = lv_text1 && ` GenericTag.press attribute is kept (rewired to the abap2UI5 event). All Card/NumericHeader/NumericSideIndicator controls of the fragment are present in the port (built in popover_card), so the` &&
               ` fragment union in structural-diff is satisfied. // NOTE: The shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json) is inlined with the columns the Products table binds (Name,` &&
               ` ProductId, SupplierName, Width, Depth, Height, DimUnit, Price, CurrencyCode). The items sorter (path 'Name') and the Price/CurrencyCode Currency composite type binding are kept 1:1 as raw` &&
               ` binding-info strings (path upper-cased to the ABAP field names). Width/Depth/Height are TYPE string because the mock carries decimal values (40.8, 3.1) bound display-only into a text template` &&
               ` ({WIDTH} x {DEPTH} x {HEIGHT} {DIMUNIT}); Price stays packed (DECIMALS 2) for the Currency type binding. // NOTE: stickySubheaderProvider='iconTabBar' is kept 1:1 as the association to the content` &&
               ` IconTabBar (id='iconTabBar'); it is a control-id association resolved by XMLView.create within the same view. stickySubheaderProvider is @since 1.65 (<= 1.71, base) - no POST_171 needed. All`.
    lv_text1 = lv_text1 && ` Card/NumericHeader/GenericTag members used are <= 1.71. // LIVE-TEST: unverified in a running system: that the Card popover opens anchored to the pressed GenericTag (popover_display by_id =` &&
               ` $event.oSource.sId), and that the Toggle Footer round-trip flips showFooter and reveals/hides the DynamicPage footer. **e2e-verified 2026-07-30** (transpiled-framework interaction,` &&
               ` scripts/e2e-smoke.mjs): the GenericTag press opens the Card popover with the NumericHeader rendering ('Sales Revenue'; asserted on text - the popover box measures empty headless); the` &&
               ` layoutData-button variant is the identical wire.`.
    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.DynamicPage`                     name = `DynamicPageWithStickySubheader`      class = `z2ui5_cl_ai_app_238` path = `src/04/b09/z2ui5_cl_ai_app_238.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.42`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: the sample is NOT a pure-routing showcase - it uses an EventBus (no sap.ui.core.routing Router/Targets) and drives the column visibility purely through the FlexibleColumnLayout's own layout` &&
               ` property (setLayout). So it is expressed as ONE view: the three column views (List, Detail, DetailDetail) are inlined into the FlexibleColumnLayout's beginColumnPages/midColumnPages/endColumnPages` &&
               ` aggregations. Consequently the original's nested mvc:XMLView reference (in beginColumnPages) is dropped - its List page content is placed inline instead. // NOTE: FlexibleColumnLayout is emitted with` &&
               ` the f: namespace prefix (f:FlexibleColumnLayout) because the merged single view uses sap.m as its default xmlns for the pages, whereas the original FlexibleColumnLayout.view.xml declares sap.f as the` &&
               ` default xmlns and writes the control unprefixed. Same control, prefix-only difference from merging four views (with two different default namespaces) into one. // NOTE: each column view holds 26` &&
               ` static, byte-identical navigation rows (List: 'Open mid column', Detail: 'Open end column', DetailDetail: 'No more columns') hardcoded in the XML - there is no JSON model. This is reproduced`.
    lv_text1 = lv_text1 && ` faithfully as a bound aggregation over a 26-row model table per column (one ColumnListItem/Text template each): same 26 rendered rows, so the ColumnListItem count (78 originals) and Text count (78` &&
               ` originals) collapse to the three templates. No data is lost or subset. // NOTE: the controller's imperative setLayout(TwoColumnsBeginExpanded/ThreeColumnsMidExpanded) is replaced by binding the` &&
               ` FlexibleColumnLayout layout property two-way ({/LAYOUT}, initial OneColumn) and changing it server-side in the press handlers (prefer-a-bindable-property over a frontend action; setLayout is not a` &&
               ` whitelisted CONTROL_METHOD). The column-switch round-trip behaviour is not verified in a running system. The lazy view loading (runAsOwner/XMLView.create on demand) is a pure framework optimization` &&
               ` with no user-visible effect and is not reproduced - all three pages exist from the start. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): pressing the first` &&
               ` master list item round-trips LIST_PRESS and the mid column renders (the two-way bound layout flipped to TwoColumnsBeginExpanded).`.
    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.FlexibleColumnLayout`            name = `FlexibleColumnLayoutSimple`          class = `z2ui5_cl_ai_app_234` path = `src/04/b08/z2ui5_cl_ai_app_234.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.46`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: The original binds two named models inside the cards (cities> for the ComboBoxes, products> for the revenue List); abap2UI5 keeps one default model, so those bind directly` &&
               ` ({cities>/cities} -> {/CITIES}, {products>/productItems} -> {/PRODUCTITEMS}, prefix dropped, last segment identical). The RevealGrid toggle (a sample-local JS debug overlay module), the three` &&
               ` property Switches, the GridContainer columnsChange, the GenericTile press and the f:Card header press are controller handlers in the original; here each raises a STATIC-text client MESSAGE_TOAST. The` &&
               ` controller's onInit attachLayoutChange handler (swapping sapUiSmallMargin/sapUiTinyMargin on layoutXS/S) is dropped entirely. Review 2026-07-27: several of these substitutions under-deliver against` &&
               ` CAPABILITIES - the three Switches set BINDABLE GridContainer properties (snapToRow/allowDenseFill/inlineBlockLayout could be two-way bound to the Switch states, prefer-a-bindable-property rule, app` &&
               ` 048 idiom), the press toasts fake values readable from the event ($event.oSource metadata name), and columnsCountText could carry the columns parameter - flagged for rework, not promoted. // NOTE:`.
    lv_text1 = lv_text1 && ` The ComboBox items keep the original binding-info sorter 1:1 ({path:'/CITIES', sorter:{path:'TEXT'}} - restored 2026-07-27; an earlier version had dropped it although CAPABILITIES marks binding` &&
               ` sorters expressible). The sap.ui.integration Card keeps its original external manifest reference (cardManifest.json). The two long lorem-ipsum filler Texts are abbreviated to short placeholders.` &&
               ` cities.json (7) and products.json (3) are inlined in full (the unbound 'status' mock column stays out of the row type per the rows-not-columns rule). // NOTE: Faked-event-value audit fix` &&
               ` (2026-07-30): the four substituted handlers are now the original behaviours. onSnapToRowChange / onAllowDenseFillChange / onInlineBlockLayoutChange: each Switch state is two-way bound and the` &&
               ` GridContainer binds snapToRow/allowDenseFill/inlineBlockLayout (added attrs) to the same fields, so the toggles drive the grid entirely client-side (the 007/128 pattern) - the three Switch change` &&
               ` attributes are DROPPED for the binding (they only carried the imperative setter). onGridColumnsChange: the columnsChange wire round-trips ${$parameters>/columns} and recomputes the bound`.
    lv_text1 = lv_text1 && ` columnsCountText text ('Current grid columns count: <n>'; text is an added attr on the Text). onPress (tiles + card): client-composed toast 'Press was fired on - {0}' filled by` &&
               ` $event.oSource.getMetadata().getName(), the original's exact text. onRevealGrid: the Reveal Grid button's press attribute is DROPPED, undecorated - RevealGrid is a sample-local JS helper (grid` &&
               ` outline overlay) with no declarative equivalent (the app-145 precedent); the earlier static toasts ('Reveal Grid', 'Snap to row', 'Allow dense fill', 'Inline block layout', 'Columns changed', 'Tile` &&
               ` pressed', 'Card pressed') are gone. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the first GenericTile press toasts 'Press was fired on - sap.m.GenericTile'` &&
               ` (the getMetadata().getName() expression resolves); the switch bindings and columns counter remain unexercised.`.
    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.GridContainer`                   name = `GridContainer`                       class = `z2ui5_cl_ai_app_168` path = `src/04/b07/z2ui5_cl_ai_app_168.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.65`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.GridList`                        name = `GridListBasic`                       class = `z2ui5_cl_ai_app_111` path = `src/04/b01/z2ui5_cl_ai_app_111.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        notes = `NOTE: The Slider drives the panel width via a roundtrip-free expression binding ({= ${slider} + '%' }) over the two-way slider value, instead of the original onSliderMoved setWidth handler;` &&
                 ` Slider.liveChange is therefore not wired (the width tracks the slider client-side). The full 27-row item set is inlined.` )
      ( module = `sap.f`              control = `sap.f.GridList`                        name = `GridListBoxContainer`                class = `z2ui5_cl_ai_app_144` path = `src/04/b04/z2ui5_cl_ai_app_144.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        notes = `LIVE-TEST: The Slider liveChange recomputes the host Panel.width (bound) as value + '%' server-side; the original set byId('panelForGridList').setWidth imperatively. Slider.value carries a binding to` &&
                 ` carry the value back. // NOTE: GridList with a grid:GridBoxLayout (boxMinWidth 17rem) and a GridListItem template (VBox + FlexItemData, Title, Label). The 27 items are inlined from model/items.json;` &&
                 ` the template binds {TITLE}/{SUBTITLE} 1:1.` ) ).

    lv_text1 = `LIVE-TEST: The Slider ``liveChange`` handler (original onSliderMoved: byId('panelForGridList').setWidth(value + '%')) is dropped and replaced by a roundtrip-free expression binding on the host` &&
               ` Panel.width (``{= ${/SLIDER_VALUE} + '%'}``), with Slider.value bound two-way to carry the value; per AGENTS.md 5 / CAPABILITIES 'prefer a pure expression binding over an event round-trip' (app 007` &&
               ` pattern). The width expression rendering is unverified in a running system. // NOTE: GridList with a group sorter on items ({path, sorter:{path:'GROUP', descending:false, group:true}}, default group` &&
               ` headers), an empty grid:GridBoxLayout customLayout, growing/growingThreshold, and a custom f:headerToolbar (Toolbar with Title, ToolbarSpacer, SearchField - the SearchField has no handler in the` &&
               ` original). The 27 items are inlined 1:1 from the sample's own model/items.json; the GridListItem template (VBox>VBox+FlexItemData, Title, Label) binds {TITLE}/{SUBTITLE} 1:1.`.
    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.GridList`                        name = `GridListBoxContainerGrouping`        class = `z2ui5_cl_ai_app_176` path = `src/04/b07/z2ui5_cl_ai_app_176.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.GridList`                        name = `GridListBreakPoints`                 class = `z2ui5_cl_ai_app_213` path = `src/04/b07/z2ui5_cl_ai_app_213.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        notes = `LIVE-TEST: The Slider's ``liveChange`` attribute is dropped: Slider.value is two-way bound to /SLIDER_VALUE and the Panel's width is an expression binding {= ${/SLIDER_VALUE} + '%' } that reproduces` &&
                 ` the controller's onSliderMoved setWidth entirely client-side (thin-frontend, no round-trip). Panel width is added (the original set it imperatively). Binding/render behaviour unverified in a running` &&
                 ` system. // NOTE: GridResponsiveLayout.layoutChange is wired to a client-composed MessageToast (control_global MESSAGE_TOAST, template 'Layout changed to {0}' filled by ${$parameters>/layout})` &&
                 ` reproducing onLayoutChange 1:1 without a backend round-trip. The layoutChange attribute itself is kept, so structural-diff sees no difference.` ) ).

    lv_text1 = `NOTE: The drop now reorders the list for real. CAPABILITIES marks drag & drop reorder expressible, so the earlier 'reorder logic not reproduced' was a wrong improvisation: the drop event ships the two` &&
               ` row indices and the insert position as client-side resolved $-args (${$parameters>/draggedControl/oParent}.indexOfItem(${$parameters>/draggedControl}), the same for droppedControl, and` &&
               ` ${$parameters>/dropPosition}), and on_event rebuilds the original onDrop arithmetic 1:1 in ABAP - remove the dragged row, decrement the drop index when dragging downwards, insert Before or After -` &&
               ` then view_model_update. Client indices are 0-based, ABAP table rows 1-based, which is the only difference to the JS splice. Both indices are range-checked before use: they arrive from the frontend,` &&
               ` and where JS would splice a nonsense index harmlessly, an ABAP table read on it dumps. Before this rework the drop fired a DROP event this class never dispatched (a dead wire, pattern-lint` &&
               ` dead-event-wire). // NOTE: The GridDropInfo control from sap.f.dnd keeps a hyphen-free 'dndgrid' xmlns alias instead of the original 'dnd-grid' (the alias only names the same sap.f.dnd URI; it makes`.
    lv_text1 = lv_text1 && ` the control statically visible to the checks). // NOTE: 27 items inlined from model/data.json; absent enum fields defaulted (highlight None, type Inactive) so the bound GridListItem properties stay` &&
               ` valid. Template binds counter/highlight/type/unread + title/subtitle 1:1.`.
    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.GridList`                        name = `GridListDragAndDrop`                 class = `z2ui5_cl_ai_app_148` path = `src/04/b05/z2ui5_cl_ai_app_148.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: SegmentedButton.selectionChange reproduces onModeChange server-side: GridList.mode is two-way bound to the same field as SegmentedButton.selectedKey and the headerText (bound) is recomputed as` &&
               ` 'GridList with mode ' + key on a backend round-trip. The GridList delete / selectionChange and the GridListItem press / detailPress are wired to client-side MessageToasts (the original toasted the` &&
               ` affected item's runtime id). mode/headerText/selectedKey carry bindings the original set statically. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): selecting` &&
               ` 'MultiSelect' round-trips the two-way bound mode and the list renders checkboxes. // NOTE: The 11 product rows are inlined from the sample's model/data.json. Fields the original JSON omits are given` &&
               ` their UI5 defaults so the bound enum-ish properties stay valid: GridListItem.type -> 'Inactive' (8 rows), highlight/Status -> 'None' (5 rows). Both render identically to the original's undefined` &&
               ` values; structural-diff compares only binding paths, not data.`.
    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.GridList`                        name = `GridListModes`                       class = `z2ui5_cl_ai_app_133` path = `src/04/b02/z2ui5_cl_ai_app_133.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: The ToggleButton drops its press=onRevealGrid handler (a client-side debug overlay from the sample's RevealGrid.js that visualises the grid tracks - imperative-only, no bindable` &&
               ` equivalent) and the Slider drops its liveChange=onSliderMoved handler. Review correction 2026-07-27: the earlier claim that onSliderMoved targets a non-existent id ('gridList') is WRONG - the` &&
               ` controller sets width on byId('panelForGridList'), and the Panel id='panelForGridList' exists in the view, so the original Slider really resizes the Panel. That behaviour is expressible client-side` &&
               ` exactly as in app 213 (Slider.value two-way bound + Panel width expression binding {= value + '%' }); open rework before promotion. Both controls are currently kept but rendered inert. // POST-1.71:` &&
               ` The GridList customLayout uses sap.ui.layout.cssgrid.ResponsiveColumnLayout and per-item ResponsiveColumnItemLayoutData with columns/rows (control + members since 1.72), kept 1:1; requires a UI5` &&
               ` release >= 1.72. // NOTE: Fully static view reproduced 1:1: a ToggleButton, a Slider (value=100), and a Panel (headerToolbar Toolbar+Title) hosting an f:GridList with a ResponsiveColumnLayout and`.
    lv_text1 = lv_text1 && ` five static f:GridListItems (columns/rows 4/4, 3/2, 3/2, 1/1, 1/1), each a VBox with a Title and 1..5 Labels; no bound data.`.
    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.GridList`                        name = `GridListResponsiveColumnLayout`      class = `z2ui5_cl_ai_app_222` path = `src/04/b07/z2ui5_cl_ai_app_222.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `The GridList customLayout uses sap.ui.layout.cssgrid.ResponsiveColumnLayout and per-item ResponsiveColumnItemLayoutData with columns/rows (control + members since 1.72), kept 1:1; requires a UI5` &&
                 ` release >= 1.72.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.ProductSwitch`                   name = `ProductSwitchNavigation`             class = `z2ui5_cl_ai_app_165` path = `src/04/b07/z2ui5_cl_ai_app_165.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.72`
        since_post171 = abap_true
        is_post171 = abap_true
        notes = `IMPROVISED: The shipped view is only the trigger Button plus two explanatory Texts in a VerticalLayout - rebuilt 1:1. The ProductSwitch is built in the sample's ProductSwitchPopover.fragment.xml` &&
                 ` (core:FragmentDefinition > ResponsivePopover > ProductSwitch > ProductSwitchItem, items bound to model/data.json) and opened on press (fnOpen). The port raises a client MESSAGE_TOAST instead; the` &&
                 ` ResponsivePopover, ProductSwitch and ProductSwitchItem controls are not rendered and the fnChange toast + URLHelper.redirect are lost. Review 2026-07-27: the original 'no JS controller' rationale is` &&
                 ` refuted by CAPABILITIES - a fragment popover opens 1:1 via popover_display/dependents+openBy and URLHelper redirect is expressible (cs_event-urlhelper); flagged for rework.` ) ).

    lv_text1 = `IMPROVISED: The original keeps header/object data in nested paths on one JSON model (title, showFooter, titleSnappedContent/text, titleExpandedContent/text,` &&
               ` objectDescription/category|center|email|status). abap2UI5 keeps one default model and render-smoke does not mock nested structures, so those paths are folded to flat fields bound via _bind (last path` &&
               ` segment identical, which structural-diff matches). Both the snapped and expanded subheading Text controls bind the same flat 'text' field. The full 125-row ProductCollection mock is inlined. //` &&
               ` IMPROVISED: The semantic action press handlers (titleMainAction onEdit, footerMainAction onSave, footerCustomActions Cancel onCancel, messagesIndicator onMessagesButtonPress) are controller methods` &&
               ` in the original (toggling showFooter/edit visibility, a MessageBox alert, a message popover); here each press raises a client MESSAGE_TOAST. The controller's onInit Messaging.addMessages seed (one` &&
               ` Error message 'Something wrong happened' that gives the MessagesIndicator its count and popover content) is not reproduced, so the indicator carries no messages. The DiscussInJam / SendEmail /`.
    lv_text1 = lv_text1 && ` SendMessage semantic actions keep their built-in behaviour, and the DraftIndicator shows state Saved.`.
    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.semantic.SemanticPage`           name = `SemanticPage`                        class = `z2ui5_cl_ai_app_166` path = `src/04/b07/z2ui5_cl_ai_app_166.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.46.0`
        is_deprecated = abap_true
        dep_text = `Deprecated since 1.54: `
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.ShellBar`                        name = `ShellBar`                            class = `z2ui5_cl_ai_app_110` path = `src/04/b01/z2ui5_cl_ai_app_110.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.63`
        is_post171 = abap_true
        notes = `NOTE: First sap.f port. Static ShellBar with a sap.m Menu and a profile Avatar; the homeIcon points at the OpenUI5 host (https://sdk.openui5.org/resources/sap/ui/documentation/sdk/images/logo_sap.png)` &&
                 ` per the asset-URL rule; the original uses the relative ./resources/... path. No controller events are wired in the original view (the controller's handleHomeIconPress is unreferenced there too). //` &&
                 ` POST-1.71: sap.m.Avatar (control @since 1.73) is used 1:1 as the profile avatar (m:Avatar initials='UI'). Newer than UI5 1.71; declared per the property-171 policy (app 152 precedent, same ShellBar` &&
                 ` profile Avatar), so the app needs UI5 >= 1.73 to render the avatar. Added at the 2026-07-27 review sweep - the control-level @since is invisible to the member-level property gate.`
        post171 = `sap.m.Avatar (control @since 1.73) is used 1:1 as the profile avatar (m:Avatar initials='UI'). Newer than UI5 1.71; declared per the property-171 policy (app 152 precedent, same ShellBar profile` &&
                 ` Avatar), so the app needs UI5 >= 1.73 to render the avatar. Added at the 2026-07-27 review sweep - the control-level @since is invisible to the member-level property gate.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.ShellBar`                        name = `ShellBarWithMenuButton`              class = `z2ui5_cl_ai_app_152` path = `src/04/b06/z2ui5_cl_ai_app_152.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.63`
        is_post171 = abap_true
        notes = `NOTE: Static sap.f.ShellBar with menu/nav/search/notifications/copilot toggles, homeIcon, notificationsNumber and a profile Avatar (initials), reproduced 1:1. The homeIcon points at the OpenUI5 host` &&
                 ` (https://sdk.openui5.org/resources/sap/ui/documentation/sdk/images/logo_sap.png) per the asset-URL rule; the original uses the relative ./resources/... path (app 110 precedent, same ShellBar` &&
                 ` homeIcon). // POST-1.71: sap.m.Avatar (control @since 1.73) is used 1:1 as the profile avatar - the profile aggregation's m:Avatar with initials. Newer than UI5 1.71; declared per the property-171` &&
                 ` policy (apps 099/244 precedent), so the app needs UI5 >= 1.73 to render the avatar.`
        post171 = `sap.m.Avatar (control @since 1.73) is used 1:1 as the profile avatar - the profile aggregation's m:Avatar with initials. Newer than UI5 1.71; declared per the property-171 policy (apps 099/244` &&
                 ` precedent), so the app needs UI5 >= 1.73 to render the avatar.` ) ).

    lv_text1 = `NOTE: suggest handler (handlerSearchSuggestEvent): the original builds two sap.ui.model.Filter objects with custom JS test functions (case-insensitive substring on ProductId and Name) and applies them` &&
               ` to the SearchManager's suggestionItems binding, then calls oSF.suggest() to reopen the suggestion popup. The custom JS filter functions are inexpressible (control-side JS), but their semantics is the` &&
               ` whitelisted 'Contains' operator (case-insensitive on client bindings when Filter.caseSensitive is unset), so the filter is reproduced 1:1 via cs_event-binding_call (compound OR group over` &&
               ` PRODUCTID/NAME Contains the typed value), CAPABILITIES 'Controller-applied binding filter' / app 022. The typed text is transported as the ${$parameters>/suggestValue} event arg and read with` &&
               ` get_event_arg. Since 2026-07-30 the imperative oSF.suggest() popup-reopen is wired too, as a second follow_up_action( control_by_id, searchField/suggest ) - sap.f.SearchManager.suggest() is a public` &&
               ` non-denied method via the generalized allowlist (closing the 2026-07-27 review-flagged gap). // LIVE-TEST: Unverified in a running system: (a) the search and liveChange handlers are client-composed`.
    lv_text1 = lv_text1 && ` MessageToast.show calls via cs_event-control_global (template '{0} search event is fired' / '{0} liveChange event value is: {1}' filled by $event.oSource.sId and ${$parameters>/newValue}), app 005` &&
               ` idiom; (b) the suggest->binding_call compound Contains filter roundtrip and its effect on the SearchManager suggestion list. Rendering (render-smoke) is green; runtime event/roundtrip behaviour needs` &&
               ` a live check. // NOTE: The ShellBar homeIcon asset URL './resources/sap/ui/documentation/sdk/images/logo_sap.png' is repointed to the OpenUI5 host 'https://sdk.openui5.org/resources/...' per the` &&
               ` asset-URL rule (same as app 110). The mock's per-row ProductPicUrl values are kept byte-identical to sap/ui/demo/mock/products.json (unbound display data, never rendered by this view). Rows without a` &&
               ` DateOfSale in the mock carry an empty string (the property is not bound). Review finding 2026-07-27: the row type inlines all 20 mock keys although the view binds only Name, Price, CurrencyCode and` &&
               ` ProductId - against AGENTS.md par.5 'unbound mock keys stay out of the row type'; the unbound columns (category, maincategory, taxtarifcode, suppliername, weightmeasure, weightunit, description,`.
    lv_text1 = lv_text1 && ` dateofsale, productpicurl, status, quantity, uom, width, depth, height, dimunit) should be trimmed.`.
    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.ShellBar`                        name = `ShellBarWithSearch`                  class = `z2ui5_cl_ai_app_218` path = `src/04/b07/z2ui5_cl_ai_app_218.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.63`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.SidePanel`                       name = `SidePanelSingle`                     class = `z2ui5_cl_ai_app_136` path = `src/04/b03/z2ui5_cl_ai_app_136.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.107`
        since_post171 = abap_true
        is_post171 = abap_true
        notes = `IMPROVISED: SidePanel.toggle shows a client-side MessageToast on every toggle. The original onToggle inspected the preventExpand/preventCollapse switches and called event.preventDefault() to veto the` &&
                 ` expand/collapse (toasting only when a veto fired, then resetting the switch); an event veto is not expressible in abap2UI5, so that behaviour is lost and the switches are kept as static controls.` )
      ( module = `sap.m`              control = `sap.m.ActionListItem`                  name = `ActionListItem`                      class = `z2ui5_cl_ai_app_001` path = `src/01/b05/z2ui5_cl_ai_app_001.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port` )
      ( module = `sap.m`              control = `sap.m.Bar`                             name = `Page`                                class = `z2ui5_cl_ai_app_002` path = `src/01/b05/z2ui5_cl_ai_app_002.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port` )
      ( module = `sap.m`              control = `sap.m.Bar`                             name = `ToolbarVsBar`                        class = `z2ui5_cl_ai_app_189` path = `src/01/b17/z2ui5_cl_ai_app_189.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` ) ).

    lv_text1 = `NOTE: the original wires a change handler on the separator Select (SEP_CHANGE round-trip, removed 2026-07-16): selectedKey and separatorStyle share one two-way model path, so the Select.change` &&
               ` attribute is deliberately MISSING vs the original view. Instant switching confirmed in the 2026-07-20 live check (restamp). // NOTE: the link toast was switched from a message_toast_display` &&
               ` round-trip to a roundtrip-free client-composed toast on 2026-07-22 (control_global MESSAGE_TOAST.show, template ``{0} has been activated`` filled by ${$source>/text}; on_event dropped) - re-verify` &&
               ` each breadcrumb link toasts "<text> has been activated". **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the overflow-picker entry 'Products' fires the link` &&
               ` press and toasts 'Products has been activated' (the headless layout collapses the links into the Breadcrumbs overflow Select; the picker path exercises the same press wire).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Breadcrumbs`                     name = `Breadcrumbs`                         class = `z2ui5_cl_ai_app_003` path = `src/01/b01/z2ui5_cl_ai_app_003.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed); RESTAMP after the 2026-07-16 rework (link toast +` &&
                 ` instant separator switch confirmed)`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: the BusyDialog fragment is rebuilt 1:1 as a core:FragmentDefinition shown via client->popup_display (the framework's displayFragment calls .open() on the fragment root, the equivalent of the` &&
               ` controller's Fragment.load + oBusyDialog.open()); one attribute is added vs the original fragment: id="busyDialog", needed so the backend timer event can close the dialog via the whitelisted` &&
               ` control_by_id 'close' method (CONTROL_METHODS in FrontendAction.js, no-arg; the id resolves in the POPUP slot via Fragment.byId('popupId', ...)) - the equivalent of the controller's` &&
               ` oBusyDialog.close(). // NOTE: the controller's simulateServerRequest (setTimeout 3000ms) becomes the framework timer: follow_up_action( cs_event-start_timer, callbackEvent TIMER_FINISHED, 3000 )` &&
               ` started with the popup. A running frontend timer cannot be cleared from ABAP (the original's clearTimeout in onDialogClosed), so after a cancel the timer still fires one backend round-trip; a` &&
               ` protected guard flag (check_busy) ignores it - same visible behavior (no second toast, dialog already closed), one extra no-op round-trip. // NOTE: the controller's syncStyleClass('sapUiSizeCompact',`.
    lv_text1 = lv_text1 && ` view, dialog) is dropped: it only copies the compact-density class when the view itself carries it, which the sample view does not; abap2UI5's popup slot has no per-view density sync, so there is` &&
               ` nothing to propagate.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.BusyDialog`                      name = `BusyDialog`                          class = `z2ui5_cl_ai_app_004` path = `src/01/b05/z2ui5_cl_ai_app_004.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a` &&
                 ` close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: BusyDialog.fragment.xml is inlined into the l:dependents aggregation - the core:Fragment reference element ('core:Fragment' fragmentName sap.m.sample.BusyDialogLight.BusyDialog) is dropped for` &&
               ` the inlined BusyDialog, per the fragment-inlining rule. handlePress is the app-147 idiom: the SHOW_BUSY round-trip issues follow_up_action control_by_id BusyDialog open plus START_TIMER CLOSE_BUSY` &&
               ` 3000, and the timer round-trip closes the dialog - the setTimeout(close, 3000) equivalent with one round-trip latency added to the 3s. // NOTE: unverified in a running system: the open + 3s timer +` &&
               ` close chain on the dependents-declared BusyDialog. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the full chain runs green - the button opens the BusyDialog` &&
               ` (attached) and the CLOSE_BUSY timer round-trip detaches it after ~3s.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.BusyDialog`                      name = `BusyDialogLight`                     class = `z2ui5_cl_ai_app_251` path = `src/01/b19/z2ui5_cl_ai_app_251.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Button`                          name = `Button`                              class = `z2ui5_cl_ai_app_005` path = `src/01/b03/z2ui5_cl_ai_app_005.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-15): manually verified in a running system - each press toasts the pressed button's client-side control id, read via the event arg $event.oSource.sId, exactly like the original.`
        notes = `NOTE: the toast was switched from a message_toast_display round-trip to a roundtrip-free client-composed toast on 2026-07-22 (control_global MESSAGE_TOAST.show, template ``{0} Pressed`` filled by` &&
                 ` $event.oSource.sId; the app is now init-only) - re-verify each button still toasts "<id> Pressed". **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the 'Default'` &&
                 ` button press toasts 'Pressed' (the $event.oSource.sId template resolves); the other buttons are the identical wire.` ) ).

    lv_text1 = `POST-1.71: The badge API is newer than 1.71 and kept 1:1 per the fidelity-first member policy: sap.m.BadgeCustomData (control @since 1.80, secondary control - sap.m.Button is the in-scope headline` &&
               ` entity, the app-244 Avatar precedent), Button.badgeStyle (@since 1.132) and the BadgeEnabler methods setBadgeMinValue/setBadgeMaxValue driven via control_by_id. The app needs a UI5 release >= 1.132` &&
               ` to render the badgeStyle; the badge itself needs >= 1.80. // NOTE: Thin-frontend rewires, all declared: (a) the StepInput's change='.currentChangeHandler' attribute is DROPPED - StepInput.value and` &&
               ` BadgeCustomData.value are two-way bound to the same /BADGECURRENT field, so the badge follows the stepper client-side (the 007/128 pattern; the original copied the value imperatively via` &&
               ` getBadgeCustomData().setValue()); BadgeCustomData.value is that binding instead of the original's empty literal, and its empty visible literal is the explicit default true. (b)` &&
               ` minChangeHandler/maxChangeHandler run server-side (business logic in ABAP): the two-way bound min/max round-trip on change, the accepted-range check (1 <= min <= max <= 9999) mirrors the original`.
    lv_text1 = lv_text1 && ` incl. resetting the field to the last accepted value on an invalid entry, and the accepted value reaches the button via follow_up_action control_by_id setBadgeMin/MaxValue (public BadgeEnabler` &&
               ` methods via the generalized allowlist). Not copied: the original maxChangeHandler's quirk of calling setBadgeMaxValue once BEFORE validating - the accepted path is identical. (c) onInit's initial` &&
               ` currentChangeHandler() call is unnecessary - the binding seeds the badge. (d) badgeMin/badgeMax are TYPE i - the original model carries them as strings, but the bound values are numeric-only and the` &&
               ` numeric-bound-as-string lint (app-053 lesson) wants the model to serialize real numbers; Input.value coerces either way. // LIVE-TEST: unverified in a running system: (a) the shared /BADGECURRENT` &&
               ` binding driving badge and StepInput; (b) the icon/text expression bindings over /BUTTONWITHICON//BUTTONWITHTEXT; (c) the MIN_CHANGE/MAX_CHANGE validation round-trips incl. the reset-on-invalid path` &&
               ` and the setBadgeMin/MaxValue follow-ups. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): (a) is covered - the badge renders data-badge 1 and follows the`.
    lv_text1 = lv_text1 && ` StepInput to 2 after ArrowUp+Enter (the change event carries the two-way write); the MIN/MAX validation round-trips remain unexercised.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Button`                          name = `ButtonWithBadge`                     class = `z2ui5_cl_ai_app_249` path = `src/01/b19/z2ui5_cl_ai_app_249.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `The badge API is newer than 1.71 and kept 1:1 per the fidelity-first member policy: sap.m.BadgeCustomData (control @since 1.80, secondary control - sap.m.Button is the in-scope headline entity, the` &&
                 ` app-244 Avatar precedent), Button.badgeStyle (@since 1.132) and the BadgeEnabler methods setBadgeMinValue/setBadgeMaxValue driven via control_by_id. The app needs a UI5 release >= 1.132 to render the` &&
                 ` badgeStyle; the badge itself needs >= 1.80.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Carousel`                        name = `CarouselWithControls`                class = `z2ui5_cl_ai_app_006` path = `src/01/b04/z2ui5_cl_ai_app_006.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-15): manually verified in a running system - renders and scrolls like the original (see the note below on the flattened image model).`
        notes = `IMPROVISED: the three carousel images bind to a separate named model in the original (img>/products/pic1..3 from sap/ui/demo/mock/img.json); resolved here to static image URLs, as abap2UI5 serves a` &&
                 ` single default model. // POST-1.71: ariaLabelledBy on the Carousel (since UI5 1.125) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.125 to render it.`
        post171 = `ariaLabelledBy on the Carousel (since UI5 1.125) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.125 to render it.` ) ).

    lv_text1 = `POST-1.71: Members newer than 1.71 kept 1:1: sap.m.Carousel.ariaLabelledBy (@1.125) and sap.m.CarouselLayout.scrollMode (@1.121); the CarouselLayout control itself is @1.62. The app needs a UI5` &&
               ` release >= 1.125 to render both. // NOTE: The two named models are folded onto the one default model (pure prefix-drops, same leaf names): products>/ProductCollection -> /T_PRODUCTS (the full 123-row` &&
               ` sap/ui/demo/mock/products.json with the nine bound fields; onInit's oProductsModel.setSizeLimit(10) rides 1:1 as follow_up_action cs_event-set_size_limit 10 MAIN, so exactly 10 pages render like the` &&
               ` original) and settings>/pagesCount -> /PAGES_COUNT. The Device.system pagesCount branch (desktop 4 / tablet 2 / else 1) is resolved statically to the desktop default 4. ProductPicUrl values are` &&
               ` host-absolutized to https://sdk.openui5.org/ per the offline asset rule. // NOTE: Thin-frontend folds, both attribute drops declared: onNumberOfPages - the Input's liveChange attribute is DROPPED,` &&
               ` Input.value is two-way bound with an added valueLiveUpdate='true' and CarouselLayout.visiblePagesCount binds the same /PAGES_COUNT field, so typing drives the carousel client-side exactly like the`.
    lv_text1 = lv_text1 && ` original's per-keystroke setVisiblePagesCount. OnScrollModeChange - the Switch's change attribute is DROPPED, Switch.state is two-way bound and scrollMode is the expression binding {= state ?` &&
               ` 'VisiblePages' : 'SinglePage' } over the same field - the original's imperative setScrollMode as a binding. // NOTE: unverified in a running system: the set_size_limit(10, MAIN) follow-up capping the` &&
               ` pages binding, the shared /PAGES_COUNT driving Input and visiblePagesCount, and the scrollMode expression flip. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs):` &&
               ` exactly 10 carousel items render from the 123 bound rows (the set_size_limit(10, MAIN) follow-up caps the binding) with the first product card visible; the pages-count input and scrollMode flip` &&
               ` remain unexercised but are the proven 007/128 client-side class.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Carousel`                        name = `CarouselWithMorePages`               class = `z2ui5_cl_ai_app_252` path = `src/01/b19/z2ui5_cl_ai_app_252.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Members newer than 1.71 kept 1:1: sap.m.Carousel.ariaLabelledBy (@1.125) and sap.m.CarouselLayout.scrollMode (@1.121); the CarouselLayout control itself is @1.62. The app needs a UI5 release >= 1.125` &&
                 ` to render both.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.CheckBox`                        name = `CheckBox`                            class = `z2ui5_cl_ai_app_155` path = `src/01/b15/z2ui5_cl_ai_app_155.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = `NOTE: Fifteen CheckBoxes across all states (selected, partiallySelected, required, enabled, valueState Warning/Error/Information, wrapping) plus a SimpleForm with GridData-laid-out CheckBoxes,` &&
                 ` reproduced 1:1. // POST-1.71: CheckBox.required (@since 1.121, the 'Required option' CheckBox) is used 1:1. Newer than UI5 1.71; declared per the property-171 policy, so the app needs UI5 >= 1.121 to` &&
                 ` render the required state.`
        post171 = `CheckBox.required (@since 1.121, the 'Required option' CheckBox) is used 1:1. Newer than UI5 1.71; declared per the property-171 policy, so the app needs UI5 >= 1.121 to render the required state.` )
      ( module = `sap.m`              control = `sap.m.CheckBox`                        name = `CheckBoxTriState`                    class = `z2ui5_cl_ai_app_007` path = `src/01/b02/z2ui5_cl_ai_app_007.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-15): manually verified in a running system - the select-all parent checkbox and its tri-state expression bindings behave like the original.; live-checked reference example for:` &&
                 ` expression bindings, two-way bind, boolean event arg` )
      ( module = `sap.m`              control = `sap.m.ColorPalette`                    name = `ColorPalette`                        class = `z2ui5_cl_ai_app_008` path = `src/01/b02/z2ui5_cl_ai_app_008.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.54`
        notes = `LIVE-TEST: the color-select toast was switched to a roundtrip-free client-composed toast on 2026-07-22 (control_global MESSAGE_TOAST.show, template with {0}/{1} filled by ${$parameters>/value} and` &&
                 ` ${$parameters>/defaultAction}; on_event dropped, init-only) - re-verify selecting a color toasts the value and true/false defaultAction.` ) ).

    lv_text1 = `NOTE: The controller lazily builds six differently configured ColorPalettePopover instances and openBy()s them; the port declares all six 1:1 in the view's mvc:dependents (ColorPalettePopover x6 -` &&
               ` extra controls vs the original view.xml, controller-built there) with the original ids/configurations, and every button press opens its popover roundtrip-free via _event_client control_by_id openBy` &&
               ` ($event.oSource.sId). handleColorSelect is the app-008 client-composed toast: 'Color Selected: value - {0}, \n defaultAction - {1}' filled by ${$parameters>/value} and ${$parameters>/defaultAction}.` &&
               ` The original's same-instance quirk (both displayMode buttons share oColorPaletteDisplayMode) is kept - both open the same declared popover. // POST-1.71: Members newer than 1.71 kept 1:1 per the` &&
               ` fidelity-first policy: sap.m.ColorPalettePopover.selectedColor (@1.122) and showRecentColorsSection (@1.74) on the selected-color popover, and sap.m.Button.ariaHasPopup (@1.84) on all seven action` &&
               ` buttons. The app needs a UI5 release >= 1.122 for the selectedColor variant; the control itself is @1.54. // NOTE: Two of the custom colors cannot ride an XML string[] attribute - the parser splits`.
    lv_text1 = lv_text1 && ` on commas, so hsl(0,100%,71%) and rgb(255,234,234) become their exact hex equivalents #ff6b6b and #ffeaea (same rendered swatches, different notation; sap.ui.core.CSSColor validation rejects any` &&
               ` comma-escaping workaround). // IMPROVISED: handleLiveChange is DROPPED (the liveChange wire on the shared displayMode popover): the original paints the pressed button's icon via raw DOM styling` &&
               ` (getDomRef().firstChild.firstChild.style.color = rgba(r,g,b,alpha) from the liveChange parameters) - direct DOM manipulation outside any bindable property, not expressible in the thin frontend. The` &&
               ` popover itself (shared with the non-liveChange button) works 1:1; only the icon recoloring effect is lost. Also NOT ported: onExit's popover destroy calls - the declared dependents die with the view.` &&
               ` // LIVE-TEST: unverified in a running system: the six dependents-declared ColorPalettePopover configurations opening anchored via openBy and the colorSelect toast argument resolution. **e2e-verified` &&
               ` 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the first action button opens its ColorPalettePopover anchored (palette content attached); the other five configurations are`.
    lv_text1 = lv_text1 && ` the identical wire.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ColorPalette`                    name = `ColorPalettePopover`                 class = `z2ui5_cl_ai_app_250` path = `src/01/b19/z2ui5_cl_ai_app_250.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.54`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Members newer than 1.71 kept 1:1 per the fidelity-first policy: sap.m.ColorPalettePopover.selectedColor (@1.122) and showRecentColorsSection (@1.74) on the selected-color popover, and` &&
                 ` sap.m.Button.ariaHasPopup (@1.84) on all seven action buttons. The app needs a UI5 release >= 1.122 for the selectedColor variant; the control itself is @1.54.` ) ).

    lv_text1 = `IMPROVISED: the shared demo kit mock model sap/ui/demo/mock/products.json (/ProductCollection, snapshotted in ui5/mock/products.json) is flattened into the default model: all 123 rows are kept` &&
               ` verbatim, but only the bound columns (ProductId, Name, SupplierName, WeightMeasure, WeightUnit, Width, Depth, Height, DimUnit, Price, CurrencyCode) are ported - the unbound columns (Category,` &&
               ` MainCategory, TaxTarifCode, Description, DateOfSale, ProductPicUrl, Status, Quantity, UoM) of the shared mock model are dropped. // IMPROVISED: the controller's onPopinLayoutChanged (ComboBox change` &&
               ` handler running a PopinLayout switch with a Block default) is expressed as bound properties instead of a round-trip (AGENTS 'prefer a bindable property'): the ComboBox's change attribute is dropped,` &&
               ` its selectedKey is bound two-way, and the Table gains a popinLayout expression binding that reproduces the switch including its Block default. // IMPROVISED: the controller's onToggleInfoToolbar` &&
               ` (ToggleButton press handler calling getInfoToolbar().setVisible(!pressed)) is expressed as bound properties instead of a round-trip: the ToggleButton's press attribute is dropped, its pressed`.
    lv_text1 = lv_text1 && ` property is bound two-way, and the infoToolbar's OverflowToolbar gains a visible={= !pressed } expression binding. // IMPROVISED: the controller's onSelect (imperative oTable.setSticky array` &&
               ` maintenance from the CheckBox text + selected parameter) becomes a sticky property on the Table bound to a plain string table: each CheckBox select event round-trips ${$source>/text} and` &&
               ` ${$parameters>/selected}, the ABAP handler inserts/removes that option and pushes the model back via view_model_update. // 1.71: the p:ColumnAIAction column plugin (sap.m.plugins, since UI5 1.136 -` &&
               ` far newer than 1.71) is dropped with its dependents aggregation, the xmlns:p namespace and the press toast - the plugin class does not exist on a 1.71 runtime, so keeping it would break view creation` &&
               ` there (same decision as app 022). // NOTE: the original derives the ObjectNumber weight state in its frontend Formatter.js (weightState: KG conversion + Success/Warning/Error thresholds). That is` &&
               ` business logic, so - abap2UI5 being a thin frontend - it is computed in ABAP model_init into a WEIGHT_STATE field and bound state="{WEIGHT_STATE}", not via a frontend formatter (core:require`.
    lv_text1 = lv_text1 && ` dropped). Visually 1:1 with the original.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Column`                          name = `Table`                               class = `z2ui5_cl_ai_app_009` path = `src/01/b05/z2ui5_cl_ai_app_009.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 5 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.12`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: the sample is an OPA-test demo: only the UI app under applicationUnderTest/ (Table.view.xml, Table.controller.js, Formatter.js, products.json) is ported 1:1; the qunit/OPA harness files` &&
               ` (OpaTableTest.qunit.js, Test.qunit.html, testsuite.qunit.*) are test infrastructure without UI and are not ported. // IMPROVISED: the controller's onPopinLayoutChanged` &&
               ` (byId(idProductsTable).setPopinLayout per the ComboBox selectedKey switch) is a pure client-side path: two-way bound ComboBox selectedKey feeding a popinLayout expression binding with the same` &&
               ` GridLarge/GridSmall-else-Block fallback (extra attributes vs the original view, original change handler dropped) - no round-trip, same pattern as app 009; the expression can never emit an empty enum` &&
               ` value. // NOTE: the controller-built sap.m.Dialog of onMessageDialogPress (title Message, type Message, a Text 'Success' as content, an OK beginButton Button that closes it) is rebuilt 1:1 as a` &&
               ` core:FragmentDefinition shown via client->popup_display on the ColumnListItem press event; the OK Button closes roundtrip-free via the frontend action _event_client( cs_event-popup_close ), and the`.
    lv_text1 = lv_text1 && ` original's afterClose destroy is the framework's popup lifecycle. The Dialog, its Text and its Button are extra controls vs the original view.xml (controller-created there). // IMPROVISED: model` &&
               ` flattening: the sample's LOCAL applicationUnderTest/products.json (123 rows) is moved into the default model verbatim, unbound columns dropped. Note: the local file is NOT identical to the shared` &&
               ` mock ui5/mock/products.json - same 123 ProductIds, but HT-9995 differs in content (local: Smartphone Cover / 15 EUR vs mock: Tablet Pouch / 20 EUR); the port follows the local file, the sample's` &&
               ` actual model source. // NOTE: the original derives the ObjectNumber weight state in its frontend Formatter.js (weightState: KG conversion + Success/Warning/Error thresholds). That is business logic,` &&
               ` so - abap2UI5 being a thin frontend - it is computed in ABAP model_init into a WEIGHT_STATE field and bound state="{WEIGHT_STATE}", not via a frontend formatter (core:require dropped). Visually 1:1` &&
               ` with the original.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ColumnListItem`                  name = `TableTest`                           class = `z2ui5_cl_ai_app_010` path = `src/01/b05/z2ui5_cl_ai_app_010.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        since = `1.12`
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ComboBox`                        name = `ComboBox`                            class = `z2ui5_cl_ai_app_011` path = `src/01/b02/z2ui5_cl_ai_app_011.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22` )
      ( module = `sap.m`              control = `sap.m.ComboBox`                        name = `ComboBox2Columns`                    class = `z2ui5_cl_ai_app_193` path = `src/01/b17/z2ui5_cl_ai_app_193.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22` )
      ( module = `sap.m`              control = `sap.m.ComboBox`                        name = `ComboBoxGrouping`                    class = `z2ui5_cl_ai_app_199` path = `src/01/b17/z2ui5_cl_ai_app_199.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22` ) ).

    lv_text1 = `IMPROVISED: the pattern's three views (App.view with sap.m.App id=rootControl, Main.view, Comparison.view) plus manifest routing are merged into ONE view: the App hosts the Main Page and the` &&
               ` Comparison f:DynamicPage (id page-comparison added) directly as its pages; the router's navTo("page2") is mapped to the documented NavContainer frontend action follow_up_action(` &&
               ` cs_event-control_by_id, rootControl//to/page-comparison ) with the default slide transition (CAPABILITIES nav row); hash-based routing / browser-back navigation is not wired; the view controllerName` &&
               ` attributes are dropped. // IMPROVISED: named models flattened into the single default model: the Comparison view's settings> model becomes the bound PAGES_COUNT/IS_DESKTOP fields (pagesCount` &&
               ` initialized to 1, the CarouselLayout.visiblePagesCount UI5 default, instead of the original's undefined-until-routeMatched), and its products> model (Products/Props) becomes` &&
               ` T_COMP_PRODUCTS/T_COMP_PROPS; the shared mock products.json default model is flattened into a flat upper-cased row type (all 20 JSON columns kept; rows without DateOfSale carry an empty string where`.
    lv_text1 = lv_text1 && ` the original JSON omits the key - a harmless string property, no enum/default override). // IMPROVISED: the '.formatter.url' iconSrc formatter flattened to absolute https://sdk.openui5.org image URLs` &&
               ` - source-verified against the now-archived app/model/formatter.js (it only prefixes '../../../../../../', i.e. resolves to the test-resources root), so the absolute URLs are the faithful equivalent.` &&
               ` // NOTE: compare button: the controller's onSelection setText/setVisible is replaced by bound COMPARE_TEXT/COMPARE_VISIBLE model properties updated in the SELECTION handler (same count>1 logic, text` &&
               ` only refreshed while shown, like the original); the ColumnListItem gains a selected="{SELECTED}" two-way binding - the sanctioned selection-read pattern (CAPABILITIES 'Controller-read list` &&
               ` selection') replacing getSelectedContextPaths - which is an extra attribute vs the original template, and the initial visible="false"/absent text of the Button become bindings. // IMPROVISED: the` &&
               ` ResizeHandler-driven pagesCount/isDesktop recalculation (_onResize/_getPagesCount) is replaced by a one-shot computation at COMPARE time from client->get( )-s_device-resize-width using the original's`.
    lv_text1 = lv_text1 && ` 600/1024 thresholds and the cap at the selected-items count; no live recalculation on window resize. // NOTE: Panel expand: the controller's onPanelExpanded (walking the sibling HBox controls and` &&
               ` calling setVisible) is replaced by a bound VISIBLE flag per comparison value row, toggled in the PANEL_EXPANDED event via t_arg ${KEY} + ${$parameters>/expand}; the description HBox's literal` &&
               ` visible="false" becomes the {VISIBLE} binding (initial false). // IMPROVISED: snapped/expanded Carousel re-sync stays dropped although Carousel.setActivePage is whitelisted upstream since 2026-07-20` &&
               ` (pr/control-methods-openby-setactivepage): the carousels' pages are aggregation-template CLONES whose ids (templateId-parentId-index, view-prefixed; nondeterministic under extended change detection)` &&
               ` are not addressable from the backend - restoring the re-sync would need an index-based page-resolution mechanism, a new framework idea if more samples turn out to need it. // NOTE: the` &&
               ` DynamicPageTitle stateChange handler (.onStateChange, add/removeSnappedContent of the snapped Carousel as a Carousel-animation workaround) is dropped together with its stateChange attribute -`.
    lv_text1 = lv_text1 && ` imperative aggregation surgery with no framework equivalent; the snapped/expanded content still switches natively with the DynamicPage header state. // NOTE: comparison Props are built from a fixed` &&
               ` 19-key list in the mock JSON key order (the original iterates the FIRST selected product's own keys, skipping ProductPicUrl - so a first product without DateOfSale would drop that row, and missing` &&
               ` values rendered '<strong>undefined</strong>' where the port renders an empty <strong></strong>); selected products are taken in model row order, not click order; the original's per-product` &&
               ` information cache is unnecessary server-side. The controller's handleButtonPress (MessageBox) is dead code referenced by no view and not ported.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ComparisonPattern`               name = `ComparisonPattern`                   class = `z2ui5_cl_ai_app_012` path = `src/01/b05/z2ui5_cl_ai_app_012.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 5 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        ui5_only = abap_true
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: the i18n> ResourceModel (i18n/i18n.properties) has no framework i18n mechanism here - all texts (dialog title, section titles/summaries/details, button labels) are inlined as the resolved` &&
               ` English literals from the properties file; this covers every i18n>-bound text incl. the Panel headerText 'More Info'. // IMPROVISED: the cookieData> named JSON model is flattened into the default` &&
               ` model: /showCookieDetails becomes the bound abap_bool show_cookie_details; every visible binding and expression binding keeps its original shape over the flattened path (named ABAP-fed JSON models` &&
               ` are not expressible, CAPABILITIES.md). // IMPROVISED: custom:DivContainer (xmlns:custom="sap.ui.documentation", a demo-kit-internal plain-div wrapper control not shipped in any UI5 library) is` &&
               ` rebuilt as a sap.m.VBox with the same class sapUiSmallMargin. // IMPROVISED: the controller's toggleStyleClass/addStyleClass/removeStyleClass('cookiesDetailedView') on the dialog is dropped because` &&
               ` the class's CSS is not part of the sample's shipped files (manifest references css/style.css but does not list it under sample files, and it is not archived), so toggling the class has no visible`.
    lv_text1 = lv_text1 && ` effect. Since 2026-07-22 add/remove/toggleStyleClass ARE whitelisted in CONTROL_METHODS (pr/style-class-toggle), so the toggle could be wired via follow_up_action( cs_event-control_by_id,` &&
               ` toggleStyleClass ) once the CSS is present; it stays dropped here only for the missing CSS. // NOTE: the controller's lazy Fragment.load + cached-instance open()/close() lifecycle maps to` &&
               ` client->popup_display (the fragment XML is rebuilt per open, forcing showCookieDetails=false like the original's openCookieSettingsDialog) and client->popup_destroy in the close handlers; the` &&
               ` original's empty 'insert your ... logic here' placeholders remain as backend event branches (ACCEPT_ALL_COOKIES/REJECT_ALL_COOKIES/SAVE_COOKIES) that only close the dialog.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.CookieSettingsDialogPattern`     name = `CookieSettingsDialogPattern`         class = `z2ui5_cl_ai_app_013` path = `src/01/b05/z2ui5_cl_ai_app_013.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 4 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        ui5_only = abap_true
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: the shared mock model /ProductCollection (ui5/mock/products.json) is flattened into the default model with only the three bound columns (ProductId, Name, ProductPicUrl); all unbound` &&
               ` columns are dropped. The full 123-row set is kept verbatim. // NOTE: the ProductPicUrl values point at the OpenUI5 host (https://sdk.openui5.org/test-resources/...) per the asset-URL rule; they are` &&
               ` rebuilt per row from ProductId in a LOOP in model_init - path and file name are identical to the mock values, only the host prefix is added. // NOTE: the controller-built Dialog of handlePress (Image` &&
               ` + Close button, afterClose destroy) is rebuilt 1:1 as a core:FragmentDefinition -> Dialog shown via client->popup_display (the CAPABILITIES.md pattern, app 042). The Link press ships the row's` &&
               ` ProductPicUrl via t_arg ${PRODUCT_PIC_URL} - the original reads evt.getSource().getTarget(), whose target property is bound to the same column. The Close button maps to client->_event_client(` &&
               ` popup_close ); the original's afterClose destroy is handled by the framework's popup lifecycle and is not wired separately.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.CustomListItem`                  name = `CustomListItem`                      class = `z2ui5_cl_ai_app_014` path = `src/01/b05/z2ui5_cl_ai_app_014.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.CustomTreeItem`                  name = `CustomTreeItem`                      class = `z2ui5_cl_ai_app_015` path = `src/01/b05/z2ui5_cl_ai_app_015.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.48.0`
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port`
        notes = `NOTE: the original binds the Tree's items to the whole JSON model root (items="{path: '/'}", the model IS the node array from Tree.json); abap2UI5 serves a single default model, so the array is` &&
                 ` flattened into it as the bound table T_TREE and the binding-info keeps its shape with the bound path substituted for '/' (nested tree binding is expressible per CAPABILITIES.md, proven by app 054).` &&
                 ` // NOTE: the flat ABAP row types serialize an empty NODES array on leaf rows where the original Tree.json simply omits the 'nodes' property (levels 1-4; the level-5 row type carries no NODES field at` &&
                 ` all); ClientTreeBinding treats an empty child array as a childless node, so the rendered tree matches. TEXT and REF are present on every original node - no absent-property/empty-string enum risk.` ) ).

    lv_text1 = `LIVE-TEST: on 2026-07-22 both interactions went roundtrip-free (openBy via _event_client instead of follow_up_action; date-changed toast client-composed via control_global) and the app became` &&
               ` init-only - re-verify each anchor opens the hidden DatePicker and picking a date toasts "Date selected: <value>". // POST-1.71: Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for` &&
               ` the 1:1 port on both Buttons - the app needs a UI5 release >= 1.84 to render it. // POST-1.71: Link.ariaHasPopup (since UI5 1.86) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5` &&
               ` release >= 1.86 to render it. // POST-1.71: DatePicker.hideInput (since UI5 1.97) is newer than 1.71 but kept for the 1:1 port - the sample's central property (the picker input stays hidden, opened` &&
               ` only via the anchor controls); openBy is also since 1.97, so the app needs a UI5 release >= 1.97 to render this sample's behavior. // LIVE-TEST: headless e2e finding (2026-07-30): clicking an openBy` &&
               ` anchor DOES open the calendar popover, but then Popover.onfocusin recurses (Maximum call stack size exceeded) because the focus restore bounces off the hideInput DatePicker input. The port wiring is`.
    lv_text1 = lv_text1 && ` 1:1 with the original (hideInput=true), so this is either headless-only or a UI5 1.150 quirk the original sample shares - verify in a real browser that the popover opens without the console` &&
               ` recursion; the e2e interaction is deliberately not armed for this app (app 091 covers the hidden-picker openBy class).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.DatePicker`                      name = `DatePickerHidden`                    class = `z2ui5_cl_ai_app_016` path = `src/01/b05/z2ui5_cl_ai_app_016.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.22.0`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed); live-checked reference example for: frontend action` &&
                 ` (openBy/domRef), $event.oSource.sId anchor transport, POST_171 discipline`
        notes = lv_text1
        post171 = `Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port on both Buttons - the app needs a UI5 release >= 1.84 to render it. // Link.ariaHasPopup (since UI5 1.86) is newer` &&
                 ` than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.86 to render it. // DatePicker.hideInput (since UI5 1.97) is newer than 1.71 but kept for the 1:1 port - the sample's central` &&
                 ` property (the picker input stays hidden, opened only via the anchor controls); openBy is also since 1.97, so the app needs a UI5 release >= 1.97 to render this sample's behavior.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.DatePicker`                      name = `DatePickerValueState`                class = `z2ui5_cl_ai_app_253` path = `src/01/b19/z2ui5_cl_ai_app_253.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0`
        notes = `NOTE: The onInit-seeded JSON model rides 1:1 in model_init (5 rows, the derived label texts written out); every row carries a valueState so the absent-enum-empty-string trap does not apply, and the` &&
                 ` rows without a valueStateText keep the empty string - a string property, where the empty value falls back to the state default text like the original undefined. // LIVE-TEST: unverified in a running` &&
                 ` system: the bound valueState/valueStateText rendering over the 5-row aggregation (render-smoke mocks the model).` ) ).

    lv_text1 = `NOTE: the original controller's JSON model carries UI5Date objects; the ABAP model carries the same dates as ISO 'yyyy-MM-dd' strings, and each sap.ui.model.type.Date part of the DateInterval value` &&
               ` bindings gets an added formatOptions.source pattern 'yyyy-MM-dd' so the strings are parsed to Dates and written back as strings (source-verified: DateInterval sets bUseInternalValues and` &&
               ` Date.getModelFormat returns the source format; CAPABILITIES: Date types over ISO strings need a source pattern). Same rows/values as the sample, only the value type differs. // NOTE: the original` &&
               ` controller's onInit oDRS2.setMinDate(2016-01-01)/setMaxDate(2016-12-31) become minDate/maxDate view attributes on DRS2, bound over ISO strings with formatter 'Formatter.DateCreateObject'` &&
               ` (CAPABILITIES date-object-properties row) - two extra attributes vs the original view.xml. // POST-1.71: core:require (UI5 >= 1.74) on the view root loads z2ui5/model/formatter for the DRS2` &&
               ` minDate/maxDate Formatter.DateCreateObject bindings - the app needs a UI5 release >= 1.74 to render it. // POST-1.71: showCurrentDateButton (since UI5 1.95) on DRS3 is newer than 1.71 but kept for`.
    lv_text1 = lv_text1 && ` the 1:1 port - the app needs a UI5 release >= 1.95 to render it. // NOTE: the change handler's imperative oEventSource.setValueState(None/Error) becomes a two-way bound valueState attribute on each` &&
               ` of the five DateRangeSelections (prefer a bindable property over imperative calls); the backend maps the event-source id to the matching field - five extra valueState attributes vs the original` &&
               ` view.xml, initialized to 'None' (enum property, never an empty string). // NOTE: the change handler's imperative oText.setText(...) becomes a bound text attribute on the TextEvent Text - one extra` &&
               ` attribute vs the original view.xml (there the Text has no text attribute). // NOTE: the controller's _iEvent counter is omitted - it is incremented in handleChange but never displayed or otherwise` &&
               ` used in the sample.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.DateRangeSelection`              name = `DateRangeSelection`                  class = `z2ui5_cl_ai_app_017` path = `src/01/b06/z2ui5_cl_ai_app_017.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.22.0`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = lv_text1
        post171 = `core:require (UI5 >= 1.74) on the view root loads z2ui5/model/formatter for the DRS2 minDate/maxDate Formatter.DateCreateObject bindings - the app needs a UI5 release >= 1.74 to render it. //` &&
                 ` showCurrentDateButton (since UI5 1.95) on DRS3 is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.95 to render it.` ) ).

    lv_text1 = `POST-1.71: sap.m.Button.ariaHasPopup (@1.84) and sap.m.Link.ariaHasPopup (@1.86) kept 1:1 on the three anchors; also hideInput on the picker (@1.97 per the 016 precedent). The app needs a UI5 release` &&
               ` >= 1.97. // NOTE: The 016 hidden-picker pattern on the sibling control: all three anchors (text Button, icon Button, Link) open the hideInput picker roundtrip-free via _event_client control_by_id` &&
               ` openBy ($event.oSource.sId), and the change toast is client-composed from ${$parameters>/value} - the controller handlers fold into the two wire forms 1:1. // LIVE-TEST: unverified in a running` &&
               ` system: the anchored open of the hideInput picker and the change-value toast. Note the 016 headless finding likely applies here too - the popover opens but the focus-restore can loop on the hidden` &&
               ` input in headless Chromium (Popover.onfocusin recursion); wiring is 1:1, verify in a real browser.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.DateRangeSelection`              name = `DateRangeSelectionHidden`            class = `z2ui5_cl_ai_app_256` path = `src/01/b19/z2ui5_cl_ai_app_256.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.Button.ariaHasPopup (@1.84) and sap.m.Link.ariaHasPopup (@1.86) kept 1:1 on the three anchors; also hideInput on the picker (@1.97 per the 016 precedent). The app needs a UI5 release >= 1.97.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.DateRangeSelection`              name = `DateRangeSelectionValueState`        class = `z2ui5_cl_ai_app_254` path = `src/01/b19/z2ui5_cl_ai_app_254.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0`
        notes = `NOTE: The onInit-seeded JSON model rides 1:1 in model_init (5 rows, the derived label texts written out); every row carries a valueState so the absent-enum-empty-string trap does not apply, and the` &&
                 ` rows without a valueStateText keep the empty string (falls back to the state default text like the original undefined) - the app-253 pattern. // LIVE-TEST: unverified in a running system: the bound` &&
                 ` valueState/valueStateText rendering over the 5-row aggregation (render-smoke mocks the model).` ) ).

    lv_text1 = `IMPROVISED: the JSON model's UI5Date instances become date strings in the flat ABAP model: the sap.ui.model.type.DateTime bindings (DTP2/3/4/5/8) get an added source pattern 'yyyy-MM-dd HH:mm:ss'` &&
               ` format option so the type parses the model string (CAPABILITIES: Date types over ISO strings need a source pattern), and the sap.ui.model.odata.type.DateTimeOffset parts of DTP10/DTP11 get added` &&
               ` constraints {V4: true} so the DateTimeWithTimezone composite receives a parsed Date internal value (source-verified in DateTimeOffset.js getModelFormat/CompositeBinding internal values); valueDTP10` &&
               ` is the UTC string '2023-03-31T10:32:30Z' instead of the original's local-time UI5Date, and DTP3/DTP5 'now' comes from server sy-datum/sy-uzeit instead of the browser clock. // IMPROVISED: the` &&
               ` controller's byId('DTP6').setInitialFocusedDateValue(UI5Date.getInstance(2017, 5, 13, 11, 12, 13)) is expressed as a bound initialFocusedDateValue property with the Formatter.DateCreateObject module` &&
               ` formatter over the model string '2017-06-13T11:12:13' (CAPABILITIES date-object row) - extra initialFocusedDateValue attribute on DTP6 plus xmlns:core and core:require on the view root vs the`.
    lv_text1 = lv_text1 && ` original view.xml. // IMPROVISED: the controller's handleChange becomes a CHANGE round-trip: the source control id, entered value and valid flag travel via $event.oSource.sId / ${$parameters>/value}` &&
               ` / ${$parameters>/valid}; the textResult Text.text becomes a binding and every change-firing picker (DTP1/2/3/4/6/7) gets an added bound valueState attribute, initialized to 'None' so no empty string` &&
               ` reaches the enum-typed property - the original sets both imperatively on the controls. // NOTE: the view-level attachParseError/attachValidationSuccess handlers of the original controller (valueState` &&
               ` Error/None on binding parse errors in the data-binding panel) are covered by the framework's automatic handleValidation registration on every view slot (CAPABILITIES MessageManager row,` &&
               ` pr/message-model) - no port code needed. // NOTE: model flattening: the original model's valueDTP9 is bound by no control in the view and is dropped; valueDTP11 (null in the original) serializes as` &&
               ` an empty string in the flat ABAP model, which the V4 DateTimeOffset model format parses back to null, so DTP11 renders timezone-only like the original. // POST-1.71: showCurrentDateButton (since UI5`.
    lv_text1 = lv_text1 && ` 1.95) on DTP2 is kept for the 1:1 port. // POST-1.71: showCurrentTimeButton (since UI5 1.98) on DTP2 and DTP11 is kept for the 1:1 port. // POST-1.71: showTimezone (since UI5 1.99) on DTP8 and DTP11` &&
               ` is kept for the 1:1 port. // POST-1.71: timezone (since UI5 1.99) on DTP8 is kept for the 1:1 port. // POST-1.71: core:require of the z2ui5/model/formatter module on the view root needs UI5 >= 1.74,` &&
               ` and the sap.ui.model.odata.type.DateTimeWithTimezone binding type of DTP10/DTP11 (since UI5 1.99) is kept 1:1 - the app needs a UI5 release >= 1.99 overall.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.DateTimePicker`                  name = `DateTimePicker`                      class = `z2ui5_cl_ai_app_018` path = `src/01/b06/z2ui5_cl_ai_app_018.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.38.0`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = lv_text1
        post171 = `showCurrentDateButton (since UI5 1.95) on DTP2 is kept for the 1:1 port. // showCurrentTimeButton (since UI5 1.98) on DTP2 and DTP11 is kept for the 1:1 port. // showTimezone (since UI5 1.99) on DTP8` &&
                 ` and DTP11 is kept for the 1:1 port. // timezone (since UI5 1.99) on DTP8 is kept for the 1:1 port. // core:require of the z2ui5/model/formatter module on the view root needs UI5 >= 1.74, and the` &&
                 ` sap.ui.model.odata.type.DateTimeWithTimezone binding type of DTP10/DTP11 (since UI5 1.99) is kept 1:1 - the app needs a UI5 release >= 1.99 overall.` ) ).

    lv_text1 = `POST-1.71: sap.m.Button.ariaHasPopup (@1.84) and sap.m.Link.ariaHasPopup (@1.86) kept 1:1 on the three anchors; also hideInput on the picker (@1.97 per the 016 precedent). The app needs a UI5 release` &&
               ` >= 1.97. // NOTE: The 016 hidden-picker pattern on the sibling control: all three anchors (text Button, icon Button, Link) open the hideInput picker roundtrip-free via _event_client control_by_id` &&
               ` openBy ($event.oSource.sId), and the change toast is client-composed from ${$parameters>/value} - the controller handlers fold into the two wire forms 1:1. // LIVE-TEST: unverified in a running` &&
               ` system: the anchored open of the hideInput picker and the change-value toast. Note the 016 headless finding likely applies here too - the popover opens but the focus-restore can loop on the hidden` &&
               ` input in headless Chromium (Popover.onfocusin recursion); wiring is 1:1, verify in a real browser.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.DateTimePicker`                  name = `DateTimePickerHidden`                class = `z2ui5_cl_ai_app_257` path = `src/01/b19/z2ui5_cl_ai_app_257.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.38.0`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.Button.ariaHasPopup (@1.84) and sap.m.Link.ariaHasPopup (@1.86) kept 1:1 on the three anchors; also hideInput on the picker (@1.97 per the 016 precedent). The app needs a UI5 release >= 1.97.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.DateTimePicker`                  name = `DateTimePickerValueState`            class = `z2ui5_cl_ai_app_255` path = `src/01/b19/z2ui5_cl_ai_app_255.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.38.0`
        notes = `NOTE: The onInit-seeded JSON model rides 1:1 in model_init (5 rows, the derived label texts written out); every row carries a valueState so the absent-enum-empty-string trap does not apply, and the` &&
                 ` rows without a valueStateText keep the empty string (falls back to the state default text like the original undefined) - the app-253 pattern. // LIVE-TEST: unverified in a running system: the bound` &&
                 ` valueState/valueStateText rendering over the 5-row aggregation (render-smoke mocks the model).` ) ).

    lv_text1 = `NOTE: the original builds its four Dialogs imperatively in the controller (new Dialog({...}).open()); the port expresses each as a core:FragmentDefinition popup shown via client->popup_display on the` &&
               ` button press event - the CAPABILITIES.md 1:1 path for controller-built Dialogs. The four Dialog fragments are therefore extra vs the archived V.view.xml, which holds only the four trigger Buttons;` &&
               ` every fragment control is EXTRA vs the archived V.view.xml (only the four trigger Buttons exist there): Dialog, Text, TextArea, Label, Button and the l:VerticalLayout / l:HorizontalLayout wrappers` &&
               ` inside the dialogs. // NOTE: the controller reads each note imperatively (Element.getElementById(...).getValue()); the port two-way binds the three TextArea values` &&
               ` (reject_note/submit_note/confirm_note) and builds the 'Note is: ...' toasts from the synced ABAP fields in on_event - an extra value attribute per TextArea vs the original construction. // NOTE: the` &&
               ` submission dialog's liveChange handler (enable the Submit button while the note is non-empty, enabled: false initially) is replaced round-trip-free by valueLiveUpdate=true on the TextArea plus an`.
    lv_text1 = lv_text1 && ` expression binding {= ${...}.length > 0 } on the begin button's enabled - same behavior, starts disabled with the empty note (CAPABILITIES.md: prefer a pure expression binding over an event` &&
               ` round-trip). // NOTE: Cancel: the approve dialog (no inputs) closes client-side via _event_client popup_close; the three note dialogs cancel through a backend DIALOG_CANCEL event + popup_destroy so` &&
               ` the two-way model sync keeps the typed note across a reopen, matching the original's reused cached dialog instances.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Dialog`                          name = `DialogConfirm`                       class = `z2ui5_cl_ai_app_019` path = `src/01/b06/z2ui5_cl_ai_app_019.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed); live-checked reference example for: fragment-popup` &&
                 ` dialogs, roundtrip-free live-enable expression, popup_close paths`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: the shared mock model sap/ui/demo/mock/supplier.json is flattened into the default model: the row type keeps only the six bound columns (SupplierName, Street, HouseNumber, ZIPCode, City,` &&
               ` Country) of the single /SupplierCollection record and drops the unbound columns (Url, Twitter, Tel, Sms, Mobile, Pager, Fax, Email, Rating, Prime, Disposable); the record itself is kept verbatim. //` &&
               ` NOTE: the sample controller loads the shared mock sap/ui/demo/mock/supplier.json - snapshotted byte-identical into ui5/mock/supplier.json (2026-07-20, git sparse checkout of SAP/openui5 master); one` &&
               ` SupplierCollection record, full row set, values verifiable offline. // NOTE: element binding binding="{/T_SUPPLIERS/0}" with relative DisplayListItem value bindings - the binding= context mechanism` &&
               ` is already live-verified via app 041 (checked 2026-07-19); the /0 array-index path variant is a plain JSONModel path resolution, source-decidable, so no LIVE_TEST is carried.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.DisplayListItem`                 name = `DisplayListItem`                     class = `z2ui5_cl_ai_app_020` path = `src/01/b06/z2ui5_cl_ai_app_020.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: the controller's imperative DraftIndicator calls (showDraftSaving/showDraftSaved/clearDraftState on byId('draftIndi')) are not in the FrontendAction CONTROL_METHODS whitelist; per AGENTS` &&
               ` 'prefer a bindable property over a frontend action' the port two-way binds the control's public state property (sap.m.DraftIndicatorState, since 1.32) and sets Saving/Saved/Clear in the three event` &&
               ` handlers. Source-verified equivalent: a binding update calls the public mutator (ManagedObjectBindingSupport.updateProperty -> _sMutator), and DraftIndicator.setState queues exactly what the three` &&
               ` methods queue (setState('Saving') queues Saving+Clear like showDraftSaving, sap/m/DraftIndicator.js). Adds the state attribute on the DraftIndicator vs the original view.xml. // NOTE: pressing the` &&
               ` same button twice in direct succession does not re-run the indicator - the model value is unchanged, so no binding change fires and setState is not called again (the original re-queues on every` &&
               ` method call); pressing a different button in between restores the behaviour.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.DraftIndicator`                  name = `DraftIndicator`                      class = `z2ui5_cl_ai_app_021` path = `src/01/b06/z2ui5_cl_ai_app_021.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.32.0`
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: the bound lists="{/ProductCollectionStats/Filters}" collection is represented as two static FacetFilterLists (Category, SupplierName) - the original's stats model yields exactly these two lists,` &&
               ` so this is a faithful equivalent; the facet values inside each list stay bound to a FacetFilterItem template. A doubly-nested variant (bind the FacetFilter lists aggregation to a nested table,` &&
               ` FacetFilterList template with a relative items binding over each filter's values) is source-plausible now that nested binding is expressible, but no port proves that aggregation-of-aggregation` &&
               ` template shape yet - LIVE_TEST before adopting it. // NOTE: selection transport - every FacetFilterItem binds selected two-way; on listClose/reset the backend reads/clears the flags and re-filters.` &&
               ` This is the documented 1:1 path (CAPABILITIES.md marks controller-read FacetFilter/List multi-select as expressible with app 022 as its evidence port), not a workaround; the model is applied before` &&
               ` on_event runs. // IMPROVISED: the original controller appends the sap.m.sample.Table component's table with its first cell swapped for an ObjectIdentifier {Name}/{Category}; that table is rebuilt`.
    lv_text1 = lv_text1 && ` inline. The price column keeps the original sap.ui.model.type.Currency composite binding 1:1 (raw binding-info string over a numeric PRICE field). // NOTE: the appended table's header toolbar is` &&
               ` restored except for the sticky controls: the popin-layout ComboBox keeps its core:Item entries and binds selectedKey two-way in place of the original's change handler (the controller switch is a pure` &&
               ` key-to-property pass-through; the Table's added popinLayout expression binding maps an empty selection to the Block default), and the Hide/Show ToggleButton binds pressed two-way in place of its` &&
               ` press handler, with the restored infoToolbar's OverflowToolbar carrying a visible expression binding over the same flag - both per the prefer-a-bindable-property rule, no round-trip. // IMPROVISED:` &&
               ` the sticky options Label and the three sticky CheckBox controls (with their select handlers) are dropped - Table.sticky is an array-valued property the controller mutates via setSticky, and neither` &&
               ` an array property binding nor a setSticky whitelist entry is a proven path; a bound-array LIVE_TEST port could disprove this later. // 1.71: the p:ColumnAIAction column plugin (sap.m.plugins, far`.
    lv_text1 = lv_text1 && ` newer than UI5 1.71) is dropped with its dependents aggregation and press toast - the plugin class does not exist on a 1.71 runtime, so keeping it would crash view creation there. // NOTE: the` &&
               ` original's nested items-binding filter (ORs inside each facet group, AND across the groups, model untouched) is expressed 1:1 as a declarative compound filter: apply_filter builds the groups JSON` &&
               ` from the two-way bound selected flags and schedules follow_up_action cs_event-binding_call filter on idProductsTable/items (compound groups implemented upstream 2026-07-20,` &&
               ` pr/binding-call-compound-filters); the earlier ABAP-side model rebuild and the t_products_all mirror are gone. // NOTE: the original derives the ObjectNumber weight state in its frontend Formatter.js` &&
               ` (weightState: KG conversion + Success/Warning/Error thresholds). That is business logic, so - abap2UI5 being a thin frontend - it is computed in ABAP model_init into a WEIGHT_STATE field and bound` &&
               ` state="{WEIGHT_STATE}", not via a frontend formatter (core:require dropped). Visually 1:1 with the original.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.FacetFilter`                     name = `FacetFilterLight`                    class = `z2ui5_cl_ai_app_022` path = `src/01/b04/z2ui5_cl_ai_app_022.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed); live-checked reference example for: compound` &&
                 ` binding_call filter, curated formatter module, two-way facet selection`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: the bound lists="{/ProductCollectionStats/Filters}" collection is represented as two static FacetFilterLists (Category, SupplierName) - the original's stats model yields exactly these two lists,` &&
               ` so this is a faithful equivalent; the facet values inside each list stay bound to a FacetFilterItem template. The stats value objects carry only text + data fields (no key), so the template's key` &&
               ` binds {TEXT} (the original's key='{key}' resolves undefined against the same mock) and the counter binds the data value as {COUNT}. This is the type="Simple" variant of the FacetFilter (app 022 ports` &&
               ` the near-identical type="Light" FacetFilterLight); the difference is the FacetFilter type plus the confirm handling below. // NOTE: selection transport - every FacetFilterItem binds selected two-way;` &&
               ` on the FacetFilter confirm (and on reset) the backend reads/clears the flags and re-filters. This is the documented 1:1 path (CAPABILITIES.md marks controller-read FacetFilter/List multi-select as`.
    lv_text1 = lv_text1 && ` expressible with app 022 as its evidence port), not a workaround; the model is applied before on_event runs. The original's handleConfirm also shows a MessageToast 'confirm event fired' - reproduced` &&
               ` 1:1 via client->message_toast_display after applying the filter. The FacetFilterSimple view does not wire the per-list listClose (only the confirm event drives filtering), so no listClose attribute` &&
               ` is emitted. // IMPROVISED: the original controller appends the sap.m.sample.Table component's table with its first cell swapped for an ObjectIdentifier {Name}/{Category}; that table is rebuilt` &&
               ` inline. The price column keeps the original sap.ui.model.type.Currency composite binding 1:1 (raw binding-info string over a numeric PRICE field). // NOTE: the appended table's header toolbar is` &&
               ` restored except for the sticky controls: the popin-layout ComboBox keeps its core:Item entries and binds selectedKey two-way in place of the original's change handler (the controller switch is a pure` &&
               ` key-to-property pass-through; the Table's added popinLayout expression binding maps an empty selection to the Block default), and the Hide/Show ToggleButton binds pressed two-way in place of its`.
    lv_text1 = lv_text1 && ` press handler, with the restored infoToolbar's OverflowToolbar carrying a visible expression binding over the same flag - both per the prefer-a-bindable-property rule, no round-trip. // IMPROVISED:` &&
               ` the sticky options Label and the three sticky CheckBox controls (with their select handlers) are dropped - Table.sticky is an array-valued property the controller mutates via setSticky, and neither` &&
               ` an array property binding nor a setSticky whitelist entry is a proven path; a bound-array LIVE_TEST port could disprove this later. // 1.71: the p:ColumnAIAction column plugin (sap.m.plugins, far` &&
               ` newer than UI5 1.71) is dropped with its dependents aggregation and press toast - the plugin class does not exist on a 1.71 runtime, so keeping it would crash view creation there. // NOTE: the` &&
               ` original's nested items-binding filter (ORs inside each facet group, AND across the groups, model untouched) is expressed 1:1 as a declarative compound filter: apply_filter builds the groups JSON` &&
               ` from the two-way bound selected flags and schedules follow_up_action cs_event-binding_call filter on idProductsTable/items (compound groups implemented upstream 2026-07-20,`.
    lv_text1 = lv_text1 && ` pr/binding-call-compound-filters). // NOTE: the original derives the ObjectNumber weight state in its frontend Formatter.js (weightState: KG conversion + Success/Warning/Error thresholds). That is` &&
               ` business logic, so - abap2UI5 being a thin frontend - it is computed in ABAP model_init into a WEIGHT_STATE field and bound state="{WEIGHT_STATE}", not via a frontend formatter (core:require` &&
               ` dropped). Visually 1:1 with the original.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.FacetFilter`                     name = `FacetFilterSimple`                   class = `z2ui5_cl_ai_app_235` path = `src/01/b19/z2ui5_cl_ai_app_235.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.FeedContent`                     name = `FeedContent`                         class = `z2ui5_cl_ai_app_023` path = `src/01/b06/z2ui5_cl_ai_app_023.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port` )
      ( module = `sap.m`              control = `sap.m.FeedInput`                       name = `Feed`                                class = `z2ui5_cl_ai_app_024` path = `src/01/b06/z2ui5_cl_ai_app_024.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.22`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `IMPROVISED: the controller's client-side DateFormat.getDateTimeInstance({ style: 'medium' }).format(new Date()) for the new entry's Date is rebuilt server-side in ABAP from sy-datum/sy-uzeit as an` &&
                 ` English medium-style timestamp (e.g. 'Jul 20, 2026, 1:23:45 PM') - the locale-dependent client formatter is not available in the backend round-trip; the value is a plain model string exactly like in` &&
                 ` the original; note the source differs too: sy-datum/sy-uzeit is the SERVER date/time and timezone, while the original renders the browser-local new Date() - around midnight or across timezones the` &&
                 ` displayed timestamp of a new entry can differ from a client-side clock.` ) ).

    lv_text1 = `POST-1.71: the FeedInput 'actions' aggregation (a Button next to the text area) is @since 1.139 - kept 1:1 on the last two FeedInputs; the app needs a UI5 release >= 1.139 to render it. // NOTE:` &&
               ` onPost: the original controller does MessageToast.show( "Posted new feed entry: " + evt.getParameter( "value" ) ) on every FeedInput; reproduced roundtrip-free as a client-composed toast` &&
               ` (cs_event-control_global MESSAGE_TOAST, template 'Posted new feed entry: {0}' filled by ${$parameters>/value}). The post attribute is kept, so structural-diff sees no difference. // NOTE:` &&
               ` onActionButtonPress: the original builds a Dialog imperatively (new Dialog({...}).open()) with a Text and two buttons; expressed 1:1 as a core:FragmentDefinition (Dialog > content/Text,` &&
               ` beginButton/Button 'Enable Post Button', endButton/Button 'Disable Post Button') shown via popup_display on the actions Button press (ACTION_PRESS). The Dialog + its controls are extra vs the` &&
               ` archived V.view.xml (which holds only the two trigger actions Buttons). // NOTE: the dialog begin/end buttons reproduce oFeedInput.enablePostButton(true/false) 1:1 via follow_up_action control_by_id`.
    lv_text1 = lv_text1 && ` + the whitelisted enablePostButton bool method (framework 2026-07-27, pr/feedinput-enable-post-button) and close the popup server-side (popup_destroy). The owning FeedInput (original:` &&
               ` oEvent.getSource().getParent()) is transported as a static button t_arg literal - the two action-carrying FeedInputs got added ids feedActionPlain/feedActionIcon for it (extra id attributes, not in` &&
               ` the original view). // NOTE: the icon 'test-resources/sap/m/images/george_washington.jpg' is rehosted to the OpenUI5 host (https://sdk.openui5.org/test-resources/...) per the project asset-URL rule;` &&
               ` presence of the icon attribute is unchanged. // NOTE: unverified in a running system: the ENABLE_POST/DISABLE_POST round-trips combining follow_up_action(enablePostButton) with popup_destroy in one` &&
               ` response (the app-019 toast+destroy precedent, but with a control method). **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the action dialog's 'Enable Post` &&
               ` Button' click runs the enablePostButton follow-up and the popup_destroy closes the dialog in the same response.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.FeedInput`                       name = `FeedInput`                           class = `z2ui5_cl_ai_app_236` path = `src/01/b19/z2ui5_cl_ai_app_236.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.22`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `the FeedInput 'actions' aggregation (a Button next to the text area) is @since 1.139 - kept 1:1 on the last two FeedInputs; the app needs a UI5 release >= 1.139 to render it.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.FeedListItem`                    name = `FeedListItem`                        class = `z2ui5_cl_ai_app_025` path = `src/01/b06/z2ui5_cl_ai_app_025.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `NOTE: the original's removeItem derives the entry index from the item's binding-context path (getBindingContext().getPath().split('/').pop()); the port transports the List's indexOfItem(item) instead` &&
                 ` - the aggregation index equals the model index for this bound list, so the spliced row is the same. // NOTE: feed.json entries 2 and 4 have no Actions property; the flat ABAP row type serializes` &&
                 ` ACTIONS as an empty array ([] instead of undefined) - the actions aggregation renders no actions either way, and an empty array is not an empty-string/enum hazard. // NOTE: the relative AuthorPicUrl` &&
                 ` asset paths (test-resources/sap/m/images/*.jpg) are rewritten to absolute https://sdk.openui5.org/test-resources/... per the project rule for runtime asset URLs.` )
      ( module = `sap.m`              control = `sap.m.FlexBox`                         name = `FlexBoxGap`                          class = `z2ui5_cl_ai_app_158` path = `src/01/b16/z2ui5_cl_ai_app_158.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = `NOTE: Three Panels demonstrating FlexBox gap / columnGap / rowGap (wrap=Wrap), each with nine typed Buttons, reproduced 1:1. // POST-1.71: FlexBox.gap, FlexBox.columnGap and FlexBox.rowGap (all @since` &&
                 ` 1.134) are used 1:1 - they are the sample's whole point. Newer than UI5 1.71; declared per the property-171 policy, so the app needs UI5 >= 1.134 to render the gaps.`
        post171 = `FlexBox.gap, FlexBox.columnGap and FlexBox.rowGap (all @since 1.134) are used 1:1 - they are the sample's whole point. Newer than UI5 1.71; declared per the property-171 policy, so the app needs UI5` &&
                 ` >= 1.134 to render the gaps.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.FlexBox`                         name = `FlexBoxNested`                       class = `z2ui5_cl_ai_app_026` path = `src/01/b04/z2ui5_cl_ai_app_026.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-19): verified in a running system - human visual pass 2026-07-19 over all apps: the six flex items and the h2 headings render with their injected-CSS background colours like the` &&
                 ` original.`
        notes = `NOTE: the original colours .item1..item6 and the h2 headings via a separate style.css; here it is injected as a core:HTML content attribute (a style tag, minified - see CAPABILITIES.md; the EXTRA` &&
                 ` core:HTML control vs the original view). Confirmed rendering via the human visual pass 2026-07-19.` )
      ( module = `sap.m`              control = `sap.m.FlexBox`                         name = `FlexBoxRenderType`                   class = `z2ui5_cl_ai_app_190` path = `src/01/b17/z2ui5_cl_ai_app_190.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` )
      ( module = `sap.m`              control = `sap.m.FormattedText`                   name = `FormattedText`                       class = `z2ui5_cl_ai_app_154` path = `src/01/b15/z2ui5_cl_ai_app_154.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.38.0`
        notes = `NOTE: FormattedText.htmlText bound to a model field holding the original controller's demo HTML string (headings, link, list, pre, code, cite, dl) 1:1.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.GenericTag`                      name = `GenericTag`                          class = `z2ui5_cl_ai_app_027` path = `src/01/b06/z2ui5_cl_ai_app_027.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.62.0`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port`
        notes = `POST-1.71: ariaLabelledBy (since UI5 1.97) on the labeled GenericTag is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.97 to render it. // NOTE: the sample's` &&
                 ` Page.controller.js defines a press handler (MessageToast 'The GenericTag is pressed.') that is not referenced anywhere in Page.view.xml - no GenericTag carries a press attribute - so the port wires` &&
                 ` no event; the rendered view is a faithful 1:1 rebuild.`
        post171 = `ariaLabelledBy (since UI5 1.97) on the labeled GenericTag is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.97 to render it.` ) ).

    lv_text1 = `POST-1.71: frameType values OneByHalf / TwoByHalf (since UI5 1.83) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.83 to render them; OneByOne / TwoByOne (1.71) were` &&
               ` never affected. // POST-1.71: systemInfo and appShortcut (since UI5 1.92) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.92 to render them. // POST-1.71: url on the` &&
               ` link tiles (since UI5 1.76) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.76 to render it. // IMPROVISED: the relative test-resources image and backgroundImage paths` &&
               ` are resolved to absolute sdk.openui5.org URLs so the tile images load standalone. // NOTE: the custom CSS class tileLayout (float: left) is kept and its style.css injected via a core:HTML content` &&
               ` attribute (see CAPABILITIES.md; the EXTRA core:HTML control vs the original view). Confirmed rendering via the human visual pass 2026-07-19.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.GenericTile`                     name = `GenericTileAsKPITile`                class = `z2ui5_cl_ai_app_028` path = `src/01/b01/z2ui5_cl_ai_app_028.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        since = `1.34.0`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-19): verified in a running system - human visual pass 2026-07-19 over all apps: the KPI tiles float left via the injected tileLayout CSS and render like the original.`
        notes = lv_text1
        post171 = `frameType values OneByHalf / TwoByHalf (since UI5 1.83) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.83 to render them; OneByOne / TwoByOne (1.71) were never` &&
                 ` affected. // systemInfo and appShortcut (since UI5 1.92) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.92 to render them. // url on the link tiles (since UI5 1.76)` &&
                 ` is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.76 to render it.` ) ).

    lv_text1 = `NOTE: the Select's literal selectedKey="1" is replaced by a two-way binding {SELECTED_KEY} (seeded '1'); scrollStepByItem on both HeaderContainers is now a pure client-side expression binding over it` &&
               ` ({= ${SELECTED_KEY} === 'px' ? 0 : +${SELECTED_KEY} }), so the original Select's change handler (.scrollChanged) is dropped - no round-trip. This is the prefer-a-bindable-property/expression pattern` &&
               ` (like the app 019). The original controller reads oEvent.getParameter('selectedItem').getKey(), which has no public $parameters path (selectedItem is a control; reading private control internals is` &&
               ` banned). // NOTE: the controller's setScrollStepByItem(0 | Number(key)) on both containers is reproduced by the scrollStepByItem expression binding above (px -> 0, else the number); seeded via` &&
               ` SELECTED_KEY='1' it matches the UI5 property default (HeaderContainer.js defaultValue: 1), so the initial arrow scroll is one item and selecting px sets 0 (px stepping via scrollStep), exactly like` &&
               ` the controller - all client-side, no scroll_step_by_item field. // NOTE: the NumericContent press ('Fire press' MessageToast) is wired roundtrip-free via client->_event_client(`.
    lv_text1 = lv_text1 && ` cs_event-control_global, MESSAGE_TOAST/show ) - the original's client-side MessageToast.show 1:1; the app is now init-only (no on_event). An unused xmlns:l namespace was dropped. // LIVE-TEST: the` &&
               ` scroll-step selection and the tile-press toast were switched from server round-trips to client-side expression binding / _event_client( control_global ) on 2026-07-22 - re-verify in a running system` &&
               ` that selecting an item/px still changes the arrow scroll step on both containers and that pressing a NumericContent still toasts 'Fire press'.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.HeaderContainer`                 name = `HeaderContainer`                     class = `z2ui5_cl_ai_app_029` path = `src/01/b06/z2ui5_cl_ai_app_029.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.44.0`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.HeaderContainer`                 name = `HeaderContainerVM`                   class = `z2ui5_cl_ai_app_157` path = `src/01/b16/z2ui5_cl_ai_app_157.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.44.0`
        notes = `NOTE: NumericContent presses show a client MessageToast ('Fire press', the original press handler's text - review fixed the earlier text copied from the NumericContentDifColors neighbour). Two` &&
                 ` vertical HeaderContainers — one of eight NumericContents, one of five TileContents (each wrapping a NumericContent) — reproduced 1:1. **e2e-verified 2026-07-30** (transpiled-framework interaction,` &&
                 ` scripts/e2e-smoke.mjs): pressing the first NumericContent toasts 'Fire press'; the other tiles are the identical wire.` )
      ( module = `sap.m`              control = `sap.m.IconTabBar`                      name = `IconTabBarStretchContent`            class = `z2ui5_cl_ai_app_030` path = `src/01/b04/z2ui5_cl_ai_app_030.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed); incl. the phone-emulation device> check`
        notes = `NOTE: the original binds expanded="{device>/isNoPhone}" (a demo-kit helper model); expressed over the framework's device> model as the expression {= !${device>/system/phone} } - same truth value,` &&
                 ` different binding text. Confirmed on desktop and phone emulation in the 2026-07-20 live check.` )
      ( module = `sap.m`              control = `sap.m.IconTabHeader`                   name = `IconTabHeader`                       class = `z2ui5_cl_ai_app_055` path = `src/01/b07/z2ui5_cl_ai_app_055.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.15` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Image`                           name = `ImageModeBackground`                 class = `z2ui5_cl_ai_app_031` path = `src/01/b01/z2ui5_cl_ai_app_031.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed); incl. the phone-emulation device> check`
        notes = `IMPROVISED: the original binds src/mode to a JSONModel (img>/products, /imageMode); these fixed sample values are inlined here as literals (mode Background, the HT-7777 / HT-6100 demo images).` &&
                 ` height/width are restored over the device> model, see below. // NOTE: the custom CSS class imageContainer (light blue background) of the box4 HBox is kept and the sample's styles.css injected via a` &&
                 ` core:HTML content attribute (CAPABILITIES.md CSS row, as apps 028/026; the EXTRA core:HTML control vs the original view). Confirmed rendering via the human visual pass 2026-07-19.` )
      ( module = `sap.m`              control = `sap.m.ImageContent`                    name = `ImageContent`                        class = `z2ui5_cl_ai_app_056` path = `src/01/b07/z2ui5_cl_ai_app_056.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.38`
        notes = `NOTE: the profile-image and logo ImageContent keep the sample's original demokit test-resources asset paths (test-resources/sap/m/demokit/sample/ImageContent/images/*.png) as the src literal 1:1;` &&
                 ` abap2UI5 does not serve those static assets, so only the first (sap-icon://area-chart) icon renders offline. The images are archived under ui5/sap.m/ImageContent/images/.` ) ).

    lv_text1 = `IMPROVISED: The five core:Fragment references of App.view.xml (Input in the heading, HeaderContent in headerContent, and IllustratedMessage/ProductsTable/SupplierDetails in sections) are inlined 1:1` &&
               ` into the single port view - abap2UI5 builds one XML view, there is no runtime Fragment reference. So core:Fragment is absent (5 dropped) and every fragment's content is rendered directly. //` &&
               ` IMPROVISED: The dynamic /selectedPurchase JSON object is flattened onto the single default model as root-level fields: has_selection (drives the ObjectPageLayout` &&
               ` showHeaderContent/toggleHeaderOnTitleClick and every section visible expression, replacing the object-truthiness !!${/selectedPurchase}),` &&
               ` sel_category/sel_subcategory/sel_suppliername/sel_paymenttype/sel_deliverystatus (HeaderContent), sel_delivery_state (ObjectStatus) and sel_products (the products Table). The controller's` &&
               ` _setSelectedPurchaseAndUpdateInput selection logic is reproduced server-side in set_selection: the entered/selected PurchaseID resolves a purchase from t_purchases and seeds these fields (or forces`.
    lv_text1 = lv_text1 && ` has_selection=false so the IllustratedMessage "not found" state shows). The text and Sub-Category header bindings therefore bind the flattened fields instead of {/selectedPurchase/...}. //` &&
               ` IMPROVISED: i18n named-model bindings folded to literal English values from i18n.properties: the pure {i18n>...} property bindings on text (Title Receipt Information/Delivery Status/Products,` &&
               ` column-header Product/Dimensions/Quantity/Price), title (SelectDialog Purchases) and placeholder (Input Enter product) are resolved statically (loses runtime language switching, renders identically` &&
               ` in English). The IllustratedMessage title/description/illustrationType keep their expression binding {= ${/inputPopulated} ? ... : ... } with the i18n operands replaced by the literal strings. The` &&
               ` Label ...:'-suffixed i18n texts are likewise inlined. // IMPROVISED: formatter.deliveryStatusState (Shipped->Success, Failed Shipping->Error, else None) is business logic; per the thin-frontend` &&
               ` principle it moves out of the frontend formatter into the ABAP model (deliverystatus_state, computed in model_init per purchase) and the ObjectStatus state binds that precomputed field`.
    lv_text1 = lv_text1 && ` (sel_delivery_state) directly instead of a formatter binding. // IMPROVISED: handleValueHelpSearch / _getCombinedFilter builds an OR filter of PurchaseID Contains + SupplierName Contains; the port's` &&
               ` SelectDialog search wires a single binding_call filter on SUPPLIERNAME Contains ${$parameters>/value} - the compound OR over two fields is simplified to the supplier field. The suggestion Input's` &&
               ` setFilterFunction (case-insensitive contains over key+text) is UI5's built-in suggestion filtering and is not reproduced explicitly. Additionally _filterAndOpenValueHelpDialog pre-filters the dialog` &&
               ` with the current input value and opens it via oDialog.open(sInputValue); the port's valueHelpRequest opens the SelectDialog unfiltered with no search-string argument (control_by_id open without` &&
               ` params), so the pre-filter-on-open behaviour is lost. // NOTE: Namespace-prefix representation: the port declares xmlns=sap.m (default) plus xmlns:uxap=sap.uxap, so the uxap controls are emitted` &&
               ` uxap:-prefixed. In the originals ObjectPageLayout/ObjectPageDynamicHeaderTitle (App.view.xml) and the IllustratedMessage-fragment ObjectPageSection/ObjectPageSubSection are unprefixed (their file's`.
    lv_text1 = lv_text1 && ` default xmlns is sap.uxap), while the ProductsTable/SupplierDetails fragments already use the uxap: prefix. Same library, identical rendering; structural-diff sees uxap:ObjectPageSection vs` &&
               ` ObjectPageSection (and likewise ObjectPageLayout/ObjectPageDynamicHeaderTitle/ObjectPageSubSection) as control missing/extra. m:IllustratedMessage keeps its m: prefix to match the original. //` &&
               ` POST-1.71: sap.m.IllustratedMessage (control since UI5 1.98, with illustrationType/title/description) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.98 to render it.` &&
               ` property-check does not track IllustratedMessage members, so this is declared by policy, not gate-forced. // POST-1.71: sap.m.Input.autocomplete (since UI5 1.108) is newer than 1.71 but kept 1:1` &&
               ` (autocomplete='false'); the app needs a UI5 release >= 1.108 to render it. Not tracked by property-check (declared by policy). // LIVE-TEST: unverified in a running system: (a) Input submit resolves` &&
               ` the entered PurchaseID (two-way bound input_value) and redraws with the selected purchase; (b) suggestionItemSelected transports the picked ListItem key via ${$parameters>/selectedItem}.getKey(); (c)`.
    lv_text1 = lv_text1 && ` valueHelpRequest opens the SelectDialog client-side via control_by_id open; (d) the SelectDialog search (binding_call filter) and confirm (${$parameters>/selectedItem}.getDescription()) resolve and` &&
               ` redraw; (e) the ObjectPageLayout/IllustratedMessage/Table render inside the headless harness as they do in the running app.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.InitialPagePattern`              name = `InitialPagePattern`                  class = `z2ui5_cl_ai_app_233` path = `src/01/b18/z2ui5_cl_ai_app_233.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 5 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        ui5_only = abap_true
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.IllustratedMessage (control since UI5 1.98, with illustrationType/title/description) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.98 to render it.` &&
                 ` property-check does not track IllustratedMessage members, so this is declared by policy, not gate-forced. // sap.m.Input.autocomplete (since UI5 1.108) is newer than 1.71 but kept 1:1` &&
                 ` (autocomplete='false'); the app needs a UI5 release >= 1.108 to render it. Not tracked by property-check (declared by policy).` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Input`                           name = `InputTypes`                          class = `z2ui5_cl_ai_app_159` path = `src/01/b16/z2ui5_cl_ai_app_159.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: Five Inputs demonstrating the input types Text / Email / Tel / Number / Url with labelFor Labels, reproduced 1:1.` )
      ( module = `sap.m`              control = `sap.m.Input`                           name = `InputValueState`                     class = `z2ui5_cl_ai_app_032` path = `src/01/b02/z2ui5_cl_ai_app_032.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = `POST-1.71: showClearIcon (since UI5 1.94) on three inputs is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.94 to render it. // POST-1.71: the two formattedValueStateText` &&
                 ` aggregations (a FormattedText carrying Links, since UI5 1.78) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.78 to render them. // NOTE: the Links' press` &&
                 ` (.onFormattedTextLinkPress) round-trips as event LINK_PRESS and shows the controller's toast text, docked at CenterCenter 1:1 via message_toast_display( my = 'center center' at = 'center center' )` &&
                 ` (the client method exposes the MessageToast options object - source-verified in Messages.js). The original's preventDefault is not needed: the Links carry no href, so there is no default navigation` &&
                 ` to suppress.`
        post171 = `showClearIcon (since UI5 1.94) on three inputs is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.94 to render it. // the two formattedValueStateText aggregations (a` &&
                 ` FormattedText carrying Links, since UI5 1.78) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.78 to render them.` )
      ( module = `sap.m`              control = `sap.m.InputListItem`                   name = `InputListItem`                       class = `z2ui5_cl_ai_app_057` path = `src/01/b07/z2ui5_cl_ai_app_057.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` ) ).

    lv_text1 = `IMPROVISED: The original demonstrates late binding of an Input over an OData v2 mock server: fnRebind calls view.bindElement('/Employees(1)') and, on dataReceived (~3s), rebinds the input to FirstName` &&
               ` if the value is still untouched. abap2UI5 has no ODataModel roundtrip here, so the OData mock is reduced to ABAP: the button starts a 3s timer (cs_event-start_timer) and the callback sets the bound` &&
               ` value to the Employees(1) FirstName ('Nancy') only when the input still equals its initial value ('Martin'), reproducing the initialValue===currentValue guard. // NOTE: The input value is a two-way` &&
               ` binding on the single default model (the original's named 'initialData' JSONModel /currentValue is flattened). liveChange is wired but the current value already flows back via the two-way binding on` &&
               ` each roundtrip, so the handler is a no-op (the original setProperty('/currentValue', ...) keeps it live between keystrokes).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.InputModelUpdate`                name = `InputModelUpdate`                    class = `z2ui5_cl_ai_app_102` path = `src/01/b12/z2ui5_cl_ai_app_102.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        ui5_only = abap_true
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Label`                           name = `LabelProperties`                     class = `z2ui5_cl_ai_app_058` path = `src/01/b07/z2ui5_cl_ai_app_058.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `IMPROVISED: the four controller handlers (onDisplayOnlyChange/onWrappingChange/onHyphenationChange/onWidthChange) are replaced by a roundtrip-free binding model, so the Switch ``change`` and Slider` &&
                 ` ``liveChange`` event attributes are dropped: the three Switches bind their ``state`` two-way to display_only/wrapping/hyphenation, the two result Labels bind ``displayOnly`` and ``wrapping`` to the` &&
                 ` same variables, and ``wrappingType`` (added on the two Labels, not present in the sample view) plus both container ``width`` values derive live via ``{= }`` expression bindings (wrappingType =` &&
                 ` hyphenation ? 'Hyphenated' : 'Normal'; width = slider_value + '%'). Same technique as app 007.` )
      ( module = `sap.m`              control = `sap.m.LightBox`                        name = `LightBox`                            class = `z2ui5_cl_ai_app_059` path = `src/01/b07/z2ui5_cl_ai_app_059.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: the Image src and LightBoxItem imageSrc keep the sample's original demokit sdk asset paths (test-resources/sap/ui/documentation/sdk/images/...) as literals 1:1; abap2UI5 does not serve those` &&
                 ` static assets, so the thumbnails/large images do not display offline. The LightBox still opens on image click (built-in Image.detailBox behaviour, no controller). The last item deliberately points` &&
                 ` imageSrc at a non-existent file to show the LightBox load-error state, exactly as in the sample. // NOTE: the six identical filler paragraphs use the same ABAP literal via a local ``lorem`` variable;` &&
                 ` XML attribute whitespace (newlines/tabs in the sample's indented multi-line text) is normalised to single spaces (visually identical).` ) ).

    lv_text1 = `NOTE: handleLinkPress opens MessageBox.alert('Link was clicked!') in the original, and both wired Links now do exactly that: the press fires a LINK_PRESSED backend event and on_event calls` &&
               ` client->message_box_display( text = 'Link was clicked!' type = 'alert' ) - the framework's 1:1 form (CAPABILITIES marks sap.m.MessageBox expressible, app 036 is the reference). Until 2026-07-28 the` &&
               ` presses were reduced to a client-composed MessageToast 'Link pressed', which the sidecar itself had already flagged as a wrong improvisation (the app-042 lesson class): neither the control nor the` &&
               ` text matched the original. // POST-1.71: Link.icon (sap-icon://cart, sap-icon://globe) and Link.endIcon (sap-icon://inspect) are @since 1.128 and used 1:1 - the 'Links with Icons' group is the` &&
               ` sample's point. Newer than UI5 1.71; declared per the property-171 policy, so the app needs UI5 >= 1.128 to render the icons.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Link`                            name = `Link`                                class = `z2ui5_cl_ai_app_160` path = `src/01/b16/z2ui5_cl_ai_app_160.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Link.icon (sap-icon://cart, sap-icon://globe) and Link.endIcon (sap-icon://inspect) are @since 1.128 and used 1:1 - the 'Links with Icons' group is the sample's point. Newer than UI5 1.71; declared` &&
                 ` per the property-171 policy, so the app needs UI5 >= 1.128 to render the icons.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Link`                            name = `LinkEmphasized`                      class = `z2ui5_cl_ai_app_033` path = `src/01/b01/z2ui5_cl_ai_app_033.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        checked = `CHECKED (2026-07-19): verified in a running system - human visual pass 2026-07-19 over all apps: the Currency composite binding renders the formatted price per currency (raw binding-info string over` &&
                 ` PRICE TYPE p).` )
      ( module = `sap.m`              control = `sap.m.List`                            name = `ListCounter`                         class = `z2ui5_cl_ai_app_034` path = `src/01/b04/z2ui5_cl_ai_app_034.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-21): verified in a running system - human visual check 2026-07-21: the Products list renders the 11 rows with their Quantity counters (display-only app, no interaction to exercise).`
        notes = `POST-1.71: headerLevel="H2" on the List (since UI5 1.117) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.117 to render it.`
        post171 = `headerLevel="H2" on the List (since UI5 1.117) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.117 to render it.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.List`                            name = `ListFooter`                          class = `z2ui5_cl_ai_app_195` path = `src/01/b17/z2ui5_cl_ai_app_195.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: The original controller loads the shared demo products.json and the List uses binding="{/ProductCollection/0}" to element-bind a single record; abap2UI5 serves one default model, so the record` &&
                 ` is flattened to top-level default-model fields (name/productid/productpicurl = products.json row 0, Notebook Basic 15 / HT-1000) the relative {NAME}/{PRODUCTID}/{PRODUCTPICURL} bindings resolve` &&
                 ` against. Same data, same leaf names, renders identically — the List's binding attribute is dropped. // NOTE: ProductPicUrl is stored as the absolute` &&
                 ` https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg (the mock's host-relative test-resources path rewritten to the OpenUI5 host per the runtime asset-URL rule).` ) ).

    lv_text1 = `NOTE: the original wires a change handler on the type Select (handleSelectChange, which loops the list items calling item.setType). selectedKey and every StandardListItem type share one two-way bound` &&
               ` field (LISTTYPE), so a selection re-types all items client-side and the Select.change attribute is deliberately MISSING vs the original view (AGENTS prefer-a-bindable-property rule; app 003` &&
               ` precedent). The added StandardListItem type binding is not in the original view. // NOTE: the ProductPicUrl icon values are stored as absolute` &&
               ` https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/*.jpg URLs (the mock's host-relative test-resources paths rewritten to the OpenUI5 host per the runtime asset-URL rule). Same` &&
               ` 123-row set, kept verbatim otherwise. // LIVE-TEST: unverified in a running system: (a) handlePress/handleDetailPress are reproduced as roundtrip-free client toasts (control_global MESSAGE_TOAST.show` &&
               ` of "'press' event fired!" / "'detailPress' event fired!"); (b) the Select selectedKey <-> item type two-way binding should re-type all rows on selection. Re-verify both.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.List`                            name = `ListItemTypes`                       class = `z2ui5_cl_ai_app_207` path = `src/01/b17/z2ui5_cl_ai_app_207.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.List`                            name = `ListNoData`                          class = `z2ui5_cl_ai_app_035` path = `src/01/b04/z2ui5_cl_ai_app_035.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` )
      ( module = `sap.m`              control = `sap.m.List`                            name = `ListSelection`                       class = `z2ui5_cl_ai_app_224` path = `src/01/b17/z2ui5_cl_ai_app_224.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: The List mode and the Select selectedKey are two-way bound to one default-model field mode (seeded MultiSelect, a valid sap.m.ListMode), reproducing the original controller's` &&
                 ` handleSelectChange/setMode behaviour without a round-trip. The Select's change attribute is dropped (the two-way binding keeps List.mode in sync client-side). structural-diff does not flag the` &&
                 ` literal mode=MultiSelect / selectedKey=MultiSelect becoming bindings. // NOTE: The full /ProductCollection mock (123 rows) is inlined; the row type is restricted to the columns the StandardListItem` &&
                 ` binds (Name, ProductId, ProductPicUrl) - a column subset, not a row subset. ProductPicUrl relative asset paths are rehosted to the OpenUI5 host https://sdk.openui5.org/ per the asset-URL rule.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MaskInput`                       name = `MaskInput`                           class = `z2ui5_cl_ai_app_153` path = `src/01/b15/z2ui5_cl_ai_app_153.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34.0`
        is_post171 = abap_true
        notes = `NOTE: Six MaskInputs across two SimpleForms with mask/placeholderSymbol/placeholder and MaskInputRule (maskFormatSymbol/regex) sub-rules; the {/showClearIcon} bindings are wired to a boolean model` &&
                 ` field. The original sets no model at all, so its {/showClearIcon} binding stays unresolved and the property keeps its default false - the field is therefore seeded false (the earlier 'initial true'` &&
                 ` seed contradicted the sample). // POST-1.71: MaskInput.showClearIcon (@since 1.96) is used 1:1 - literal true on the phone-number MaskInput and the {/showClearIcon} binding on the three second-form` &&
                 ` MaskInputs. Newer than UI5 1.71; declared per the property-171 policy, so the app needs UI5 >= 1.96 to render the clear icons.`
        post171 = `MaskInput.showClearIcon (@since 1.96) is used 1:1 - literal true on the phone-number MaskInput and the {/showClearIcon} binding on the three second-form MaskInputs. Newer than UI5 1.71; declared per` &&
                 ` the property-171 policy, so the app needs UI5 >= 1.96 to render the clear icons.` ) ).

    lv_text1 = `POST-1.71: Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it. // IMPROVISED: the sample loads the Menu from` &&
               ` Menu.fragment.xml on first press and toggles it in the controller (oMenu.isOpen() ? close() : openBy(button)). The port declares the Menu 1:1 inside the Button's ``dependents`` aggregation and` &&
               ` toggles it via client->roundtrip-free _event_client( cs_event-control_by_id, toggleBy ) anchored to the button's DOM ref ($event.oSource.sId) - toggleBy (open-if-closed / close-if-open) was added` &&
               ` upstream 2026-07-20 (pr/menu-toggle-openby) precisely so the client-side open state need not be mirrored server-side, making the press-to-toggle 1:1. Frontend-action pattern as app 016. //` &&
               ` IMPROVISED: onMenuAction builds a breadcrumb path by walking the selected MenuItem's parent chain (e.g. 'Create New Site > Official Store'); the server cannot walk the client-side control tree, so` &&
               ` the toast shows only the selected item's own text, transported via ${$parameters>/item}.getText(). // NOTE: the selected item's text is read with ${$parameters>/item}.getText() (a method call on the`.
    lv_text1 = lv_text1 && ` resolved MenuItem control), NOT ${$parameters>/item/text}: the $parameters model exposes 'item' as the control object and UI5 keeps properties in the control's internal property store, so the path` &&
               ` .../item/text reads an undefined direct field and the toast arrives empty. // NOTE: live-verified 2026-07-22 - confirm in a running system that the Menu opens anchored to the button (openBy) and that` &&
               ` ${$parameters>/item}.getText() delivers the clicked MenuItem's text to the toast. // NOTE: the Menu open/close is wired roundtrip-free via client->_event_client( cs_event-control_by_id, toggleBy ) on` &&
               ` the button press (anchored by $event.oSource.sId) - the original's client-side toggle 1:1; the item-selected toast is now roundtrip-free too, composed on the frontend via control_global` &&
               ` MESSAGE_TOAST.show (template + ${$parameters>/item}.getText()), so the app has no on_event at all (init-only). // NOTE: the menu toggle was switched from a follow_up_action round-trip to` &&
               ` roundtrip-free _event_client on 2026-07-22 - re-verify the button opens/closes the Menu. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the 'Open Menu' press`.
    lv_text1 = lv_text1 && ` opens the Menu anchored (toggleBy). // NOTE: the item-selected toast was switched from a message_toast_display round-trip to a roundtrip-free client-composed toast on 2026-07-22 (control_global` &&
               ` MESSAGE_TOAST.show, template ``Action triggered on item: {0}`` filled by ${$parameters>/item}.getText()) - re-verify selecting a menu item toasts "Action triggered on item: <text>". **e2e-verified` &&
               ` 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): selecting 'Hide Existing Sites' toasts 'Action triggered on item: Hide Existing Sites'.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Menu`                            name = `Menu`                                class = `z2ui5_cl_ai_app_060` path = `src/01/b07/z2ui5_cl_ai_app_060.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-22): verified in a running system 2026-07-22: the Menu opens anchored to the button (openBy) and the selected item text resolves via ${$parameters>/item}.getText().`
        notes = lv_text1
        post171 = `Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it.` ) ).

    lv_text1 = `POST-1.71: the MenuButton ``beforeMenuOpen`` event (since UI5 1.94) is kept 1:1 on the split-mode buttons that use it. menuPosition (1.56), buttonMode and useDefaultActionOnly are <= 1.71. //` &&
               ` IMPROVISED: onMenuAction builds a breadcrumb path by walking the selected MenuItem's parent chain (e.g. 'basic > add'); the server cannot walk the client-side control tree, so the toast shows only` &&
               ` the selected item's own text, transported via ${$parameters>/item}.getText(). // NOTE: onPress toasts the pressed MenuItem's control id (the sample's evt.getSource().getId() + ' Pressed'),` &&
               ` transported via $event.oSource.sId. The Edit item's core:CustomData (key=target, value=p1) is kept 1:1 as inert view metadata. // NOTE: the selected item's text is read with` &&
               ` ${$parameters>/item}.getText() (a method call on the resolved MenuItem control), NOT ${$parameters>/item/text}: the $parameters model exposes 'item' as the control object and UI5 keeps properties in` &&
               ` the control's internal property store, so the path .../item/text reads an undefined direct field and the toast arrives empty. // NOTE: live-verified 2026-07-22 - confirm in a running system that`.
    lv_text1 = lv_text1 && ` itemSelected/press/defaultAction/beforeMenuOpen all fire their toasts and that ${$parameters>/item}.getText() delivers the selected MenuItem text. // LIVE-TEST: all toasts were switched from` &&
               ` message_toast_display round-trips to roundtrip-free client-composed control_global toasts on 2026-07-22 (the app is now init-only) - re-verify each button/menu still toasts its text. **e2e-verified` &&
               ` 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): opening the 'File' MenuButton and selecting 'Save' toasts 'Action triggered on item: Save' (the ${$parameters>/item}.getText()` &&
               ` template resolves); the remaining buttons/defaultAction wires are the same class but unexercised.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MenuButton`                      name = `MenuButton`                          class = `z2ui5_cl_ai_app_061` path = `src/01/b07/z2ui5_cl_ai_app_061.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-22): verified in a running system 2026-07-22: itemSelected/press/defaultAction/beforeMenuOpen all fire their toasts and the item text resolves.`
        notes = lv_text1
        post171 = `the MenuButton ``beforeMenuOpen`` event (since UI5 1.94) is kept 1:1 on the split-mode buttons that use it. menuPosition (1.56), buttonMode and useDefaultActionOnly are <= 1.71.` ) ).

    lv_text1 = `NOTE: the sample opens a sap.m.MessageBox from its controller; there is no such control in the view. It is driven by two buttons wired to events that call client->message_box_display - the documented` &&
               ` 1:1 path (CAPABILITIES.md marks sap.m.MessageBox as expressible with app 036 as its evidence port), not a workaround. // POST-1.71: ariaHasPopup="Dialog" on both buttons (since UI5 1.84) is newer` &&
               ` than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it. // POST-1.71: the MessageBox emphasizedAction option (since UI5 1.75) is newer than 1.71 but kept for the 1:1` &&
               ` port - the app needs a UI5 release >= 1.75 to render it. // POST-1.71: the MessageBox dependentOn option (since UI5 1.124) is restored via message_box_display's dependenton parameter, pointing at the` &&
               ` view layout (id messageBoxHost); the app needs a UI5 release >= 1.124 to render it.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MessageBox`                      name = `MessageBoxInitialFocus`              class = `z2ui5_cl_ai_app_036` path = `src/01/b03/z2ui5_cl_ai_app_036.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.21.2`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `ariaHasPopup="Dialog" on both buttons (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it. // the MessageBox emphasizedAction option (since` &&
                 ` UI5 1.75) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.75 to render it. // the MessageBox dependentOn option (since UI5 1.124) is restored via message_box_display's` &&
                 ` dependenton parameter, pointing at the view layout (id messageBoxHost); the app needs a UI5 release >= 1.124 to render it.` ) ).

    lv_text1 = `POST-1.71: Button.ariaHasPopup (since UI5 1.84) kept on the message-popover button. The Button.type value 'Negative' (a sap.m.ButtonType value since 1.73) is what the sample's buttonTypeFormatter` &&
               ` returns for the highest-severity Error message. // IMPROVISED: the MessagePopover (built in the controller and addDependent'ed to the button) is declared 1:1 in the button's ``dependents``` &&
               ` aggregation; the controller's oMessagePopover.toggle(button) becomes a roundtrip-free client->_event_client( cs_event-control_by_id, toggleBy ) on the button press (anchored by id), and` &&
               ` onActiveTitlePress's MessageToast.show becomes a roundtrip-free client->_event_client( cs_event-control_global, MESSAGE_TOAST/show ); the app is now init-only (no on_event). Previously` &&
               ` client->follow_up_action( cs_event-control_by_id, toggleBy ) anchored to the button's DOM ref ($event.oSource.sId) - open-if-closed / close-if-open. // NOTE: the sample's three severity formatters` &&
               ` (buttonIconFormatter/buttonTypeFormatter/highestSeverityMessages) compute the button icon/type/count from the highest-severity message; the mock data is static, so the results are precomputed in ABAP`.
    lv_text1 = lv_text1 && ` (error icon, Negative type, count 2 for the two Error messages) and bound as scalars. The sample's root-array JSON model (items path '/') is carried under a /T_MESSAGES field of the single default` &&
               ` model. // NOTE: live-verified 2026-07-22 - confirm in a running system that the button toggles the MessagePopover open/closed (toggleBy) and lists the five messages with their MessageItem link, and` &&
               ` that activeTitlePress toasts on the active (first Error) title. // LIVE-TEST: the toggle and the active-title toast were switched from server round-trips to roundtrip-free _event_client(` &&
               ` control_global / control_by_id ) on 2026-07-22 - re-verify in a running system that the button still toggles the MessagePopover and that pressing an active title still toasts. **e2e-verified` &&
               ` 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the button toggles the MessagePopover open (the bound message items render); the active-title toast remains unexercised.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MessagePopover`                  name = `MessagePopover`                      class = `z2ui5_cl_ai_app_066` path = `src/01/b08/z2ui5_cl_ai_app_066.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        since = `1.28`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-22): verified in a running system 2026-07-22: the button toggles the MessagePopover open/closed (toggleBy) and lists the five messages.`
        notes = lv_text1
        post171 = `Button.ariaHasPopup (since UI5 1.84) kept on the message-popover button. The Button.type value 'Negative' (a sap.m.ButtonType value since 1.73) is what the sample's buttonTypeFormatter returns for the` &&
                 ` highest-severity Error message.` ) ).

    lv_text1 = `POST-1.71: Button.ariaHasPopup (since UI5 1.84) kept on the message-popover button; the Button.type value 'Negative' is a sap.m.ButtonType value since 1.73. MessageItem.markupDescription (renders the` &&
               ` HTML description) is kept for the async sample's rich-text messages. // IMPROVISED: the MessagePopover (built in the controller) is declared 1:1 in the button's ``dependents``; the controller's` &&
               ` toggle(button) becomes a roundtrip-free client->_event_client( cs_event-control_by_id, toggleBy ) on the button press (anchored by id), and onActiveTitlePress's MessageToast.show becomes` &&
               ` roundtrip-free client->_event_client( cs_event-control_global, MESSAGE_TOAST/show ); the app is now init-only. Anchored to $event.oSource.sId. // NOTE: the sample's` &&
               ` oMessagePopover.setAsyncURLHandler(...) - allowed = url.lastIndexOf('http', 0) < 0, i.e. relative links allowed, absolute http links disabled - is reproduced since 2026-07-30 via the framework's` &&
               ` declarative URL policy: follow_up_action control_by_id setAsyncURLHandler 'RELATIVE_ONLY' installs the built-in validator on init (pr/messagepopover-async-url implemented upstream). Semantic nuance:`.
    lv_text1 = lv_text1 && ` RELATIVE_ONLY also denies non-http absolute schemes (mailto:) and protocol-relative //host URLs, which the original's http-prefix test would allow - a strictly safer superset, no demo link is` &&
               ` affected. The controller's urlValidated toast ('URL validation has been performed.') is wired 1:1 as an added urlValidated attribute (declared) with a client-composed toast; the original's` &&
               ` setAsyncDescriptionHandler (allow-all) and its longtextLoaded toast are NOT reproduced - no remote long texts exist in the mock, so the handler never fires in the sample either. // NOTE: the three` &&
               ` severity formatters are precomputed in ABAP from the static mock (error icon, Negative type, count 2); the root-array JSON model is carried under /T_MESSAGES on the single default model. // NOTE:` &&
               ` live-verified 2026-07-22 - confirm the button toggles the MessagePopover (toggleBy) and the first Error message renders its HTML markupDescription (h2/p/ul/ol + links); activeTitlePress toasts. //` &&
               ` LIVE-TEST: the toggle and the active-title toast were switched to roundtrip-free _event_client on 2026-07-22, and the 2026-07-30 RELATIVE_ONLY URL policy + urlValidated toast are new since the`.
    lv_text1 = lv_text1 && ` 2026-07-22 live check (status reset checked -> generated): re-verify the button toggles the MessagePopover, an active title toasts, and the absolute http link in the first message renders disabled` &&
               ` after validation while relative links stay clickable. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the button toggles the MessagePopover open (the 'Error` &&
               ` message' item renders its markup).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MessagePopover`                  name = `MessagePopoverAsyncMessageHandling`  class = `z2ui5_cl_ai_app_067` path = `src/01/b08/z2ui5_cl_ai_app_067.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.28`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Button.ariaHasPopup (since UI5 1.84) kept on the message-popover button; the Button.type value 'Negative' is a sap.m.ButtonType value since 1.73. MessageItem.markupDescription (renders the HTML` &&
                 ` description) is kept for the async sample's rich-text messages.` ) ).

    lv_text1 = `POST-1.71: two post-1.71 members are kept for the 1:1 port: Button.ariaHasPopup (since UI5 1.84) on the MessagePopover button, and MessagePopover.groupItems (since UI5 1.73). // IMPROVISED: the` &&
               ` controller's manual MessageManager handling is replaced by two framework mechanisms: (1) the typed value bindings with constraints (sap.ui.model.type.Integer/String, ZIP_CODE Integer, WEEKLYHOURS` &&
               ` Integer maximum 40, EMAIL search regex) collect/clear their validation messages AUTOMATICALLY into the message> model (no app code) - replacing onChange/handleRequiredField/checkInputConstraints; (2)` &&
               ` app-authored messages go through the new z2ui5.cc.MessageManager companion control (items bound to /T_MESSAGES), which reconciles them into the message manager with a target + processor. Save ports` &&
               ` generateInvalidUserInput 1:1 in effect: since abap2UI5 auto-collects validation messages only from USER input (not from programmatically-set model values), Save INJECTS the four demo issues on the` &&
               ` SAME rows the original targets (formContainer.getItems()[4/5/6] = John Miller Name empty, Stefan Bosch ZIP 'AAA', Maria Fontes email malformed, plus the employment weekly hours 400) AND authors the`.
    lv_text1 = lv_text1 && ` matching four messages (3 Errors + 1 Warning) with their /T_FORMS/4|5|6 and /T_EMPLOYMENT/0 targets, then opens the MessagePopover via follow_up_action( control_by_id openBy ) anchored to` &&
               ` messagePopoverBtn. // IMPROVISED: the sample's nested JSON model (street/name, zip/code, phone/number) is flattened into a flat ABAP row (STREET_NAME, ZIP_CODE, PHONE_NUMBER, ...) - abap2UI5 serves` &&
               ` one default model; the bindings use the flattened field names. The three f:ColumnElementData layoutData hints (cellsSmall/cellsLarge column spans on the street-number, zip-code and one employment` &&
               ` Input) are dropped - responsive-span cosmetics with no data/behaviour. // 1.71: controller-only pieces with no view/binding equivalent are dropped:` &&
               ` buttonIconFormatter/buttonTypeFormatter/highestSeverityMessages (the button's severity-based icon/type/count) is reduced to text={=${message>/}.length}, type=Emphasized; core:CommandExecution (the` &&
               ` Ctrl+Shift+M focus shortcut); isPositionable. // NOTE: the controller's handleMessagePopoverPress (this.oMP.toggle(oEvent.getSource())) becomes a roundtrip-free client->_event_client(`.
    lv_text1 = lv_text1 && ` cs_event-control_by_id, toggleBy ) wired on the button press (anchored to the button by its id 'messagePopoverBtn'), matching the original's client-side toggle 1:1 - no SHOW_MESSAGES round-trip's DOM` &&
               ` ref ($event.oSource.sId), the MessagePopover carrying id=messagePopover - open-if-closed / close-if-open, same frontend-action pattern as apps 066/067. // NOTE: all 8 forms of the mock` &&
               ` FormsModel.json are loaded verbatim (Julie Armstrong, Denise Smith, Richard Wilson, Gerd Becker, John Miller with the built-in invalid ZIP AAA, Stefan Bosch, Maria Fontes with empty email + malformed` &&
               ` website, Antonio Ferrari) plus the single employment row - the full data set, not a subset. // NOTE: activeTitlePress scroll-to-control navigation is RESTORED (activeTitle=true): pressing a message` &&
               ` title fires ACTIVE_TITLE with the message's target control id (${$parameters>/item}.getBindingContext('message').getObject().getControlIds()[0]), and the handler runs follow_up_action(` &&
               ` scroll_into_view ) + control_by_id close + set_focus on it - the 1:1 equivalent of the sample's scrollToElement + close + focus. Needs the upstream fix that lets SET_FOCUS/SCROLL_INTO_VIEW resolve a`.
    lv_text1 = lv_text1 && ` fully-qualified control id (resolveById), since a UI5 Message carries the view-prefixed id. // NOTE: onInit's MessageToast.show('Press "Save" to trigger validation.') is ported as` &&
               ` client->message_toast_display( ... ) in the check_on_init branch. // NOTE: MessageItem grouping (groupItems=true + the 'Personal, <section>' group headers) is RESTORED: the original derives groupName` &&
               ` in its controller (getGroupName). That is a domain classification, so - abap2UI5 being a thin frontend - it is computed in the ABAP backend (COND on additionaltext: Email -> 'Personal, Contact', else` &&
               ` 'Personal, Information') and carried on the Message code field (sap.ui.core.message.Message has no groupName slot), bound groupName="{message>code}" - no frontend expression. Only Email sits in the` &&
               ` Contact group, all others in Information, matching the original's headers.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MessagePopover`                  name = `MessagePopoverMessageHandling`       class = `z2ui5_cl_ai_app_065` path = `src/01/b08/z2ui5_cl_ai_app_065.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        since = `1.28`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-27): verified in a running system 2026-07-27 - MessageManager cc: add/remove app-authored messages reconciled, MessagePopover shows both sources`
        notes = lv_text1
        post171 = `two post-1.71 members are kept for the 1:1 port: Button.ariaHasPopup (since UI5 1.84) on the MessagePopover button, and MessagePopover.groupItems (since UI5 1.73).` ) ).

    lv_text1 = `POST-1.71: the MessageStrip ``controls`` aggregation (since UI5 1.129) is kept 1:1 for the fifth strip's %%0/%%1/%%2 multi-link formatted text (three sap.m.Link). enableFormattedText itself is since` &&
               ` 1.50 (<= 1.71). // POST-1.71: core:require="{Formatter: 'z2ui5/model/formatter'}" wires the curated formatter module (since UI5 1.74) so the inlineIconsHelper strip can use` &&
               ` Formatter.expandInlineIcons; the two added namespace decls (xmlns:core, core:require on the view root) are not in the sample view. // NOTE: the sample's controller builds inlineIconsHelper from` &&
               ` sap.m.MessageStripUtilities.getInlineIcon() concatenations; the port stores the text with %%icon:sap-icon://<name>%% placeholders (the real icon names message-success/sys-enter-2/stethoscope) and` &&
               ` binds it through formatter 'Formatter.expandInlineIcons' - added upstream 2026-07-20 (pr/formatter-inline-icon), it resolves each glyph via IconPool and emits the same sapMMsgStripInlineIcon markup,` &&
               ` so no icon codepoints are guessed. The inlineIconsUnicode strip keeps the sample's own literal &#x....; entities 1:1. // NOTE: the sample's JSONModel of static formatted-text strings is rebuilt as`.
    lv_text1 = lv_text1 && ` ABAP string fields on the single default model and bound 1:1 (text={/...}); field names differ from the JSON keys (default->default_text etc.) but values are display-only, so the binding-value diff` &&
               ` does not apply.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MessageStrip`                    name = `MessageStripWithEnableFormattedText` class = `z2ui5_cl_ai_app_062` path = `src/01/b07/z2ui5_cl_ai_app_062.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.30`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `the MessageStrip ``controls`` aggregation (since UI5 1.129) is kept 1:1 for the fifth strip's %%0/%%1/%%2 multi-link formatted text (three sap.m.Link). enableFormattedText itself is since 1.50 (<=` &&
                 ` 1.71). // core:require="{Formatter: 'z2ui5/model/formatter'}" wires the curated formatter module (since UI5 1.74) so the inlineIconsHelper strip can use Formatter.expandInlineIcons; the two added` &&
                 ` namespace decls (xmlns:core, core:require on the view root) are not in the sample view.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MessageToast`                    name = `MessageToast`                        class = `z2ui5_cl_ai_app_037` path = `src/01/b03/z2ui5_cl_ai_app_037.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.9.2` )
      ( module = `sap.m`              control = `sap.m.MessageView`                     name = `MessageViewMessageManager`           class = `z2ui5_cl_ai_app_038` path = `src/01/b03/z2ui5_cl_ai_app_038.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.46`
        notes = `IMPROVISED: the original registers its four messages on the sap.ui.core.message.MessageManager and the MessageView binds them via the message> model. abap2UI5 DOES carry the message> model on every` &&
                 ` view slot since pr/message-model (2026-07-18, auto-collecting control validation messages), but there is no ABAP API to push an arbitrary static message set into it - so for this render-only sample` &&
                 ` the messages are bound as a plain ABAP table on MessageView items with a MessageItem template (client->_bind( t_messages )), the path CAPABILITIES.md explicitly endorses for static message sets. Same` &&
                 ` rendering as the original. Proven by the curated sample z2ui5_cl_demo_app_038 (MessageView + MessageItem + MessagePopover over a bound table).` )
      ( module = `sap.m`              control = `sap.m.MultiComboBox`                   name = `MultiComboBoxGrouping`               class = `z2ui5_cl_ai_app_039` path = `src/01/b02/z2ui5_cl_ai_app_039.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `NOTE: the custom groupHeaderFactory '.getGroupHeader' (controller code) is replaced by UI5's default group headers - the sample's factory builds a SeparatorItem with the group key, which is exactly` &&
                 ` what the default renders anyway (CAPABILITIES.md group-sorter row, source-verified on both sides), so this is a faithful 1:1, not a workaround. The items are a bound template with the original's` &&
                 ` sorter (path SUPPLIER_NAME, group: true) as a raw binding-info string.` ) ).

    lv_text1 = `NOTE: the controller's onInit pre-sets the tokens on both MultiInputs (Token 1..6 and one long token); they are declared statically in the view's tokens aggregation instead - same rendering` &&
               ` (CAPABILITIES.md marks controller-filled aggregations as expressible, the tokens aggregation is public since UI5 1.16), so this is a faithful 1:1, not a workaround. // NOTE: the controller's onInit` &&
               ` addValidator on multiInput1 and multiInput2 (typing free text + Enter -> new Token({key: text, text})) is wired via the bundled invisible companion control z2ui5.cc.MultiInputExt` &&
               ` (xmlns:z2ui5="z2ui5.cc"): one MultiInputExt per input, referencing it by MultiInputId - the control installs exactly the original's validator (source-verified in app/webapp/cc/MultiInputExt.js). The` &&
               ` two MultiInputExt elements are extra vs the original view.xml (there the validator lives in the controller); first cc-control usage in these ports (converted 2026-07-18). // NOTE: The original's` &&
               ` stray placeholder attributes on the two Labels (not a Label property) are dropped. // POST-1.71: showClearIcon (since UI5 1.94) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5` &&
               ` release >= 1.94 to render it.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MultiInput`                      name = `MultiInput`                          class = `z2ui5_cl_ai_app_040` path = `src/01/b02/z2ui5_cl_ai_app_040.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed); live-checked reference example for: cc control` &&
                 ` (MultiInputExt), bound aggregation, tokens, sorter binding-info`
        notes = lv_text1
        post171 = `showClearIcon (since UI5 1.94) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.94 to render it.` ) ).

    lv_text1 = `POST-1.71: NavContainer.navigationFinished (event, since UI5 1.111.0) is kept 1:1 - it is wired to a client-composed MessageToast; the app needs a UI5 release >= 1.111 to fire it. // IMPROVISED:` &&
               ` handleNav does navCon.to( byId(target), animationSelect.getSelectedKey() ) / navCon.back() imperatively. The port keeps the NavContainer id='navCon' and drives navigation via a round-trip: each` &&
               ` To-button's press (NAV) carries its static target page id (p1..p4) as the event arg, and on_event issues follow_up_action( val = cs_event-control_by_id t_arg = ( 'navCon' )( 'to' )( <target> )(` &&
               ` animation ) ) - 'to' is whitelisted with kinds [controlId, string], so the target page and the transition name both reach the method; Back issues ( 'navCon' )( 'back' ). A server round-trip where the` &&
               ` original is a purely client-side imperative call, but faithful. // NOTE: the animation transition comes from a Select whose getSelectedKey() the original reads at click time. The port two-way binds` &&
               ` the Select's selectedKey to a model field {/ANIMATION} (seeded to the first item's key 'slide'), so the current transition is available to the backend on the NAV round-trip. The original Select has`.
    lv_text1 = lv_text1 && ` no selectedKey attribute (it defaults to the first item), so adding the bound selectedKey is an extra attribute (structural-diff only flags MISSING attributes) and is the faithful thin-frontend form` &&
               ` of the imperative getSelectedKey(). // NOTE: the sample's style.css (a border around the NavContainer via the .navContainerControl class) is injected via an added core:HTML leaf carrying a <style>` &&
               ` block in its content attribute (CAPABILITIES 'Custom CSS'); the literal CSS braces are escaped. structural-diff reports this core:HTML as an extra control (named here); the .navContainerControl class` &&
               ` stays on the NavContainer. // NOTE: the four To-buttons keep their core:CustomData (key='target') element 1:1 for structural fidelity, but the port transports the target page id via the button's` &&
               ` event arg (a static literal per button) rather than reading evt.getSource().data('target') - identical result since the target is fixed per button. // LIVE-TEST: unverified in a running system: that`.
    lv_text1 = lv_text1 && ` navCon.to()/back() navigate the four pages with the selected transition (follow_up_action cs_event-control_by_id 'to'/'back'), that the two-way bound animation Select is applied before NAV runs, and` &&
               ` that navigationFinished fires the client-composed toast with the resolved page title. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the 'To 2' button` &&
               ` navigates to Page 2 via the control_by_id to() call; the transition-type select and back() remain unexercised.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.NavContainer`                    name = `NavContainer`                        class = `z2ui5_cl_ai_app_242` path = `src/01/b19/z2ui5_cl_ai_app_242.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `NavContainer.navigationFinished (event, since UI5 1.111.0) is kept 1:1 - it is wired to a client-composed MessageToast; the app needs a UI5 release >= 1.111 to fire it.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.NewsContent`                     name = `NewsContent`                         class = `z2ui5_cl_ai_app_063` path = `src/01/b07/z2ui5_cl_ai_app_063.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34` )
      ( module = `sap.m`              control = `sap.m.NotificationListGroup`           name = `NotificationListGroup`               class = `z2ui5_cl_ai_app_077` path = `src/01/b09/z2ui5_cl_ai_app_077.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.34`
        is_post171 = abap_true
        notes = `IMPROVISED: static notifications: onItemClose's client-side removeItem is not mirrored (toast only); group 3's onAcceptErrors is simplified to the accept toast. // NOTE: the original's` &&
                 ` showCloseButton="falseue" typo on two items is corrected to false, otherwise UI5 boolean parsing rejects it. // POST-1.71: the NotificationList container control (since UI5 1.90) is newer than 1.71` &&
                 ` but kept for the 1:1 port - the app needs a UI5 release >= 1.90 to render it (control-level, invisible to the member-level property gate).`
        post171 = `the NotificationList container control (since UI5 1.90) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.90 to render it (control-level, invisible to the member-level` &&
                 ` property gate).` ) ).

    lv_text1 = `IMPROVISED: the notifications are static (not model-bound), so onItemClose's client-side removeItem is not mirrored (close fires a toast only); onErrorPress's setProcessingMessage MessageStrip on the` &&
               ` item is shown as a toast. // POST-1.71: the NotificationList container control (since UI5 1.90) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.90 to render it` &&
               ` (control-level, invisible to the member-level property gate). // NOTE: the sample's demo-kit authorPicture image paths (test-resources/sap/m/images/Woman_04.png, headerImg2.jpg, female_BaySu.jpg) are` &&
               ` resolved to absolute sdk.openui5.org URLs. // LIVE-TEST: all toasts were switched to roundtrip-free client-composed control_global toasts on 2026-07-22 (the app is now init-only) - re-verify` &&
               ` press/close/accept/reject/error each toast their text. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the 'Accept' footer button toasts 'Accept Button` &&
               ` Pressed'; item press/close toasts are the identical wire but unexercised.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.NotificationListItem`            name = `NotificationListItem`                class = `z2ui5_cl_ai_app_076` path = `src/01/b09/z2ui5_cl_ai_app_076.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.34`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `the NotificationList container control (since UI5 1.90) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.90 to render it (control-level, invisible to the member-level` &&
                 ` property gate).` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.NumericContent`                  name = `NumericContentDifColors`             class = `z2ui5_cl_ai_app_156` path = `src/01/b15/z2ui5_cl_ai_app_156.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        notes = `NOTE: The NumericContent / GenericTile presses show a client MessageToast ('The numeric content is pressed.'), matching the original press handler. Four NumericContents (value colors` &&
                 ` Good/Critical/Error, indicators) plus a GenericTile > TileContent > NumericContent are reproduced 1:1. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): pressing` &&
                 ` the first NumericContent toasts 'The numeric content is pressed.'; the other tiles are the identical wire.` )
      ( module = `sap.m`              control = `sap.m.NumericContent`                  name = `NumericContentIcon`                  class = `z2ui5_cl_ai_app_064` path = `src/01/b07/z2ui5_cl_ai_app_064.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        notes = `NOTE: the second NumericContent keeps the sample's original demokit test-resources image path (test-resources/sap/m/demokit/sample/NumericContentIcon/images/grass.jpg) as the icon literal 1:1;` &&
                 ` abap2UI5 does not serve that static asset, so it does not render offline (the first tile's sap-icon://travel-expense does). The image is archived under ui5/sap.m/NumericContentIcon/images/.` )
      ( module = `sap.m`              control = `sap.m.ObjectAttribute`                 name = `ObjectAttributeInTable`              class = `z2ui5_cl_ai_app_191` path = `src/01/b17/z2ui5_cl_ai_app_191.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        notes = `NOTE: the JSONModel is defined inline in the original controller's onInit (an array of {product, supplier} rows under /modelData); it is moved verbatim into ABAP model_init (all 10 rows kept) and` &&
                 ` bound on the one default model. Pure prefix/root rename (/modelData -> the default model root), same data, renders identically.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ObjectAttribute`                 name = `ObjectAttributes`                    class = `z2ui5_cl_ai_app_073` path = `src/01/b09/z2ui5_cl_ai_app_073.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.12`
        is_post171 = abap_true
        notes = `NOTE: element binding kept 1:1 - the two display ObjectAttributes bind a one-record structure /S_PRODUCT instead of {/ProductCollection/0}; record 0 fields verbatim. // IMPROVISED:` &&
                 ` handleSAPLinkPressed's URLHelper.redirect maps to the URLHELPER REDIRECT frontend action (cs_event-urlhelper); handleFeedbacklinkPressed's Dialog (a RatingIndicator + TextArea with Submit/Cancel` &&
                 ` Button) is rebuilt via popup_display, the Submit button's 2s setBusy delay dropped. // POST-1.71: ObjectAttribute.ariaHasPopup (since UI5 1.97) is kept 1:1 on the feedback attribute; needs UI5 >=` &&
                 ` 1.97.`
        post171 = `ObjectAttribute.ariaHasPopup (since UI5 1.97) is kept 1:1 on the feedback attribute; needs UI5 >= 1.97.` ) ).

    lv_text1 = `NOTE: the ObjectHeader keeps the original element binding and relative field bindings 1:1 (title, numberUnit, the ObjectAttribute composite texts and the sap.ui.model.type.Currency number binding);` &&
               ` only the binding context path changes - a one-record structure /S_PRODUCT in the default model instead of {/ProductCollection/0}, since the port does not carry the whole collection. // NOTE: the` &&
               ` model holds exactly the bound record /ProductCollection/0 (Notebook Basic 15) of ui5/mock/products.json, verbatim - this is the original sample's own single-record binding {/ProductCollection/0}, not` &&
               ` a shortened data set. // NOTE: the active ObjectAttribute 'www.sap.com' opens via the URLHELPER REDIRECT frontend action (cs_event-urlhelper, { URL, NEW_WINDOW } object param) - not open_new_tab,` &&
               ` which is same-origin-only.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ObjectHeader`                    name = `ObjectHeader`                        class = `z2ui5_cl_ai_app_041` path = `src/01/b01/z2ui5_cl_ai_app_041.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        checked = `CHECKED (2026-07-19): verified in a running system - human visual pass 2026-07-19 over all apps: the element binding {/S_PRODUCT} resolves all relative field bindings incl. the Currency number - the` &&
                 ` ObjectHeader renders fully populated.`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ObjectHeader`                    name = `ObjectHeaderCondensed`               class = `z2ui5_cl_ai_app_201` path = `src/01/b17/z2ui5_cl_ai_app_201.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        notes = `NOTE: the ObjectHeader keeps the original element binding and its relative field bindings 1:1 (title {Name}, condensed, numberUnit {CurrencyCode}, the ObjectAttribute composite text and the` &&
                 ` sap.ui.model.type.Currency number binding over Price/CurrencyCode); only the binding context path changes - a one-record structure /S_PRODUCT in the default model instead of {/ProductCollection/0},` &&
                 ` since the port does not carry the whole collection. // NOTE: the model holds exactly the bound record /ProductCollection/0 (Notebook Basic 15) of ui5/mock/products.json, verbatim - this is the` &&
                 ` original sample's own single-record binding {/ProductCollection/0}, not a shortened data set.` )
      ( module = `sap.m`              control = `sap.m.ObjectHeader`                    name = `ObjectHeaderImage`                   class = `z2ui5_cl_ai_app_206` path = `src/01/b17/z2ui5_cl_ai_app_206.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        notes = `NOTE: The ObjectHeader's single-record element binding attribute binding="{/ProductCollection/5}" is dropped: abap2UI5 serves one default model, so products.json row 5 is seeded directly onto the` &&
                 ` model root (model_init) and the control's relative {NAME}/{PRICE}/… bindings resolve against it — same data, renders identically (single-record fold, AGENTS §5). // LIVE-TEST: The` &&
                 ` sap.ui.model.type.Currency composite binding on number and the flattened relative bindings render in render-smoke but the live data bind is unverified in a running system.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ObjectHeader`                    name = `ObjectHeaderMarkers`                 class = `z2ui5_cl_ai_app_197` path = `src/01/b17/z2ui5_cl_ai_app_197.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        notes = `NOTE: the Page keeps the original element binding and the ObjectHeader relative field bindings 1:1 (title {Name}, numberUnit {CurrencyCode}, the two ObjectAttribute composite texts and the` &&
                 ` sap.ui.model.type.Currency number binding over Price/CurrencyCode); only the binding context path changes - a one-record structure /S_PRODUCT in the default model instead of {/ProductCollection/0},` &&
                 ` since the port does not carry the whole collection. // NOTE: the model holds exactly the bound record /ProductCollection/0 (Notebook Basic 15) of ui5/mock/products.json, verbatim - this is the` &&
                 ` original sample's own single-record binding {/ProductCollection/0}, not a shortened data set.` )
      ( module = `sap.m`              control = `sap.m.ObjectHeader`                    name = `ObjectHeaderResponsiveV`             class = `z2ui5_cl_ai_app_209` path = `src/01/b17/z2ui5_cl_ai_app_209.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        notes = `NOTE: The ObjectHeader's single-record element binding attribute binding="{/ProductCollection/0}" is dropped: abap2UI5 serves one default model, so products.json row 0 (HT-1000, Notebook Basic 15) is` &&
                 ` seeded directly onto the model root (model_init) and the control's relative {NAME}/{DESCRIPTION}/{SUPPLIERNAME}/{WIDTH}/… bindings resolve against it — same data, renders identically (single-record` &&
                 ` fold, AGENTS §5). The ProductPicUrl asset is served absolute from sdk.openui5.org per the asset-URL rule. // LIVE-TEST: The flattened relative field bindings and the ObjectMarker/ObjectStatus markers` &&
                 ` render in render-smoke, but the live data bind of the folded single record is unverified in a running system.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ObjectIdentifier`                name = `ObjectIdentifier`                    class = `z2ui5_cl_ai_app_071` path = `src/01/b09/z2ui5_cl_ai_app_071.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        notes = `NOTE: element binding kept 1:1 - the VerticalLayout binds a one-record structure /S_PRODUCT in the default model instead of {/ProductCollection/0}; titleClicked's MessageBox.alert becomes` &&
                 ` message_box_display. // NOTE: the model holds exactly the bound record /ProductCollection/0 (Notebook Basic 15) of ui5/mock/products.json, verbatim - the original's own single-record binding.` )
      ( module = `sap.m`              control = `sap.m.ObjectListItem`                  name = `ObjectListItem`                      class = `z2ui5_cl_ai_app_074` path = `src/01/b09/z2ui5_cl_ai_app_074.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        notes = `IMPROVISED: the ObjectStatus '.formatter.status' (Status -> ValueState) is precomputed into the STATUS_STATE model field (Available->Success, Out of Stock->Warning, Discontinued->Error, else None). //` &&
                 ` NOTE: the press toast was switched to a roundtrip-free client-composed toast on 2026-07-22 (control_global MESSAGE_TOAST.show, template ``Pressed : {0}`` filled by ${NAME}; on_event dropped,` &&
                 ` init-only) - re-verify pressing an item toasts "Pressed : <name>". **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): pressing the first ObjectListItem toasts` &&
                 ` 'Pressed : <name>'; the other rows are the identical template wire.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ObjectListItem`                  name = `ObjectListItemMarkers`               class = `z2ui5_cl_ai_app_198` path = `src/01/b17/z2ui5_cl_ai_app_198.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        notes = `NOTE: the list-item press was built as a roundtrip-free client-composed toast (control_global MESSAGE_TOAST.show, template ``Pressed : {0}`` filled by ${$source>/title}, reproducing the controller's` &&
                 ` MessageToast.show("Pressed : " + oEvent.getSource().getTitle())) - re-verify pressing an item toasts "Pressed : <title>". **e2e-verified 2026-07-30** (transpiled-framework interaction,` &&
                 ` scripts/e2e-smoke.mjs): pressing the first ObjectListItem toasts 'Pressed : <title>' (the ${$source>/title} template resolves).` )
      ( module = `sap.m`              control = `sap.m.ObjectMarker`                    name = `ObjectMarker`                        class = `z2ui5_cl_ai_app_237` path = `src/01/b19/z2ui5_cl_ai_app_237.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.38`
        notes = `NOTE: the Table's items model is the anonymous JSON model set in onInit (new JSONModel({modelData:[...]}), items='{path:/modelData}'); folded to the one default model as client->_bind( t_modeldata )` &&
                 ` -> {/T_MODELDATA}. Same data, last path segment identical, structural-diff 0 diffs. Child bindings {product}/{type}/{additionalInfo} map to the upper-cased fields {PRODUCT}/{TYPE}/{ADDITIONALINFO}.` &&
                 ` // NOTE: onPress (on the third, interactive ObjectMarker): the original does MessageToast.show( evt.getParameter( "type" ) + " marker pressed!" ); reproduced roundtrip-free as a client-composed toast` &&
                 ` (cs_event-control_global MESSAGE_TOAST, template '{0} marker pressed!' filled by ${$parameters>/type}). The press attribute is kept, so structural-diff sees no difference.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ObjectNumber`                    name = `ObjectNumber`                        class = `z2ui5_cl_ai_app_072` path = `src/01/b09/z2ui5_cl_ai_app_072.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        is_post171 = abap_true
        notes = `NOTE: the original binds records {/ProductCollection/0..5} of the shared mock; the port carries exactly those 6 records as a default-model table T_PRODUCTS and element-binds each ObjectNumber to` &&
                 ` /T_PRODUCTS/0..5 (index binding), Price+CurrencyCode verbatim. // POST-1.71: ObjectNumber.inverted, ObjectNumber.active and ObjectNumber.press (all since UI5 1.86) are kept 1:1 for the` &&
                 ` inverted/interactive variants; needs UI5 >= 1.86.`
        post171 = `ObjectNumber.inverted, ObjectNumber.active and ObjectNumber.press (all since UI5 1.86) are kept 1:1 for the inverted/interactive variants; needs UI5 >= 1.86.` )
      ( module = `sap.m`              control = `sap.m.ObjectStatus`                    name = `ObjectStatus`                        class = `z2ui5_cl_ai_app_042` path = `src/01/b01/z2ui5_cl_ai_app_042.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a` &&
                 ` close look.`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `POST-1.71: the ObjectStatus state values Indication06-Indication08 (since UI5 1.75) and Indication09-Indication20 (since UI5 1.120) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5` &&
                 ` release >= 1.120 to render them all (>= 1.75 for Indication06-Indication08). // NOTE: the active status press opens the controller-built Dialog 1:1 (core:FragmentDefinition + popup_display): the` &&
                 ` Dialog with its VBox, the two content Texts (one EXTRA Text vs the original view) and the Close Button are EXTRA controls vs the archived view.xml, which only holds the ObjectStatus rows. Confirmed` &&
                 ` working in the 2026-07-20 live check.`
        post171 = `the ObjectStatus state values Indication06-Indication08 (since UI5 1.75) and Indication09-Indication20 (since UI5 1.120) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >=` &&
                 ` 1.120 to render them all (>= 1.75 for Indication06-Indication08).` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.OverflowToolbar`                 name = `ToolbarDesign`                       class = `z2ui5_cl_ai_app_086` path = `src/01/b10/z2ui5_cl_ai_app_086.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.28`
        notes = `IMPROVISED: the Select ``change`` handlers onSelectDesign/onSelectStyle (setDesign/setStyle) become two-way bound design/style; bActionContext (design != Info) becomes an expression binding on the` &&
                 ` Buttons' visible.` ) ).

    lv_text1 = `NOTE: Both halves of the controller are now reproduced instead of faked. (a) onPress toasts oEvent.getSource().getText(); the port transports that value - control_global MESSAGE_TOAST.show with the` &&
               ` template '{0}' filled by ${$source>/text} (the app-003 shape) - instead of hardcoding each button's caption, so the icon-only Print button toasts its (empty) text exactly as the original does. (b)` &&
               ` onOpen Fragment.loads ActionSheet.fragment.xml and calls openBy(button): the port rebuilds that fragment 1:1 in on_event (ActionSheet title 'Menu', showCancelButton, placement Top, the five Buttons` &&
               ` with their icons and visible bindings) and anchors it with client->popover_display( by_id = $event.oSource.sId ) - the overflow Button therefore fires a real backend event instead of a placeholder` &&
               ` 'Overflow' toast. The fragment's {range>/isPhone} / {range>/isPhoneOrTablet} bindings fold onto the default model like the view's (a new isphone field joins the existing range flags). // NOTE: The` &&
               ` original drives the footer toolbar button visibility from a separate 'range' media JSON model ({range>/isNoPhone}, isNotPhoneOrTablet, isTablet, isPhoneOrTablet). abap2UI5 has one default model, so`.
    lv_text1 = lv_text1 && ` the flags live flat in it and visible binds them directly - the 'range>' prefix is dropped; the last path segment is identical, which structural-diff matches. Values use the desktop media ranges (the` &&
               ` original filled them from Device.media - a client-only decision).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.OverflowToolbar`                 name = `ToolbarResponsive`                   class = `z2ui5_cl_ai_app_163` path = `src/01/b17/z2ui5_cl_ai_app_163.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: The imperative token interaction is dropped: the tokenDelete event handler on all four OverflowToolbarTokenizers and the press handler on the 'Add Token' Button are removed. The original` &&
               ` controller mutates static Token child controls via addToken/removeToken plus a MessageToast - imperative control mutation over static (non-bound) tokens, not expressible without inventing a bound` &&
               ` token model. All controls, tokens and every other attribute are kept 1:1. // POST-1.71: sap.m.OverflowToolbar ariaHasPopup (since 1.79.0) is kept 1:1 from the original view; needs a UI5 release >=` &&
               ` 1.79 to render. // POST-1.71: REVIEW FINDING (out of scope, maintainer decision needed): the ported control sap.m.OverflowToolbarTokenizer itself is tagged @ui5-experimental-since 1.139 in the` &&
               ` OpenUI5 source and carries NO plain @since tag, so scripts/scope-of.mjs misreads it as base-version (<= 1.71, 'no @since header') and the property gate cannot see it either. The sample is out of` &&
               ` porting scope per AGENTS §1 (control must exist since UI5 1.71); the app needs a UI5 release >= 1.139 (experimental API) to render. Either drop the port or add a ui5/scope-exceptions.json entry;`.
    lv_text1 = lv_text1 && ` scope-of.mjs should also learn @ui5-experimental-since.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.OverflowToolbarTokenizer`        name = `OverflowToolbarTokenizer`            class = `z2ui5_cl_ai_app_203` path = `src/01/b17/z2ui5_cl_ai_app_203.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.139`
        since_post171 = abap_true
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.OverflowToolbar ariaHasPopup (since 1.79.0) is kept 1:1 from the original view; needs a UI5 release >= 1.79 to render. // REVIEW FINDING (out of scope, maintainer decision needed): the ported` &&
                 ` control sap.m.OverflowToolbarTokenizer itself is tagged @ui5-experimental-since 1.139 in the OpenUI5 source and carries NO plain @since tag, so scripts/scope-of.mjs misreads it as base-version (<=` &&
                 ` 1.71, 'no @since header') and the property gate cannot see it either. The sample is out of porting scope per AGENTS §1 (control must exist since UI5 1.71); the app needs a UI5 release >= 1.139` &&
                 ` (experimental API) to render. Either drop the port or add a ui5/scope-exceptions.json entry; scope-of.mjs should also learn @ui5-experimental-since.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Page`                            name = `PageStandardClasses`                 class = `z2ui5_cl_ai_app_089` path = `src/01/b11/z2ui5_cl_ai_app_089.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: element binding kept 1:1 - a one-record structure /S_PRODUCT instead of {/ProductCollection/0}; the IconTabBar expanded stays bound to {device>/isNoPhone} (runtime device model).` )
      ( module = `sap.m`              control = `sap.m.Panel`                           name = `PanelExpanded`                       class = `z2ui5_cl_ai_app_043` path = `src/01/b04/z2ui5_cl_ai_app_043.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `NOTE: the original controller toggles the third panel imperatively (onOverflowToolbarPress -> oPanel.setExpanded(!oPanel.getExpanded())). Reproduced 1:1 since the whitelist extension (2026-07-18, see` &&
                 ` pr/control-call-whitelist): the TOOLBAR_PRESSED handler inverts a server-side mirror of the state and calls the whitelisted setExpanded on the panel via client->follow_up_action(` &&
                 ` cs_event-control_by_id ) - the view no longer carries the improvised two-way ``expanded`` binding, matching the original view.xml exactly.` ) ).

    lv_text1 = `NOTE: the original onInit creates a popup-mode sap.m.PDFViewer and adds it as a view dependent; it is declared 1:1 in the view's mvc:dependents aggregation (an extra PDFViewer element vs the original` &&
               ` view.xml, which never carries it - there it lives in the controller). onPress' setSource/setTitle/open() becomes a bound source updated per click, the constant title declared in the view, and the` &&
               ` whitelisted open via client->follow_up_action( cs_event-control_by_id ) after render - popup mode 1:1, the earlier Dialog embedding workaround is gone (whitelist extended upstream 2026-07-18, see` &&
               ` pr/control-call-whitelist). // IMPROVISED: the per-image JSONModels of onInit (a Source/Preview URL pair per Image) have no server-side equivalent; the Image src (original {/Preview}) is resolved to` &&
               ` static absolute sdk.openui5.org URLs and the Source travels through the one bound pdf_source field - same family as pr/named-json-models. // POST-1.71: the PDFViewer property isTrustedSource (since` &&
               ` UI5 1.121, backported to maintenance patches down to 1.71.63; the original controller passes isTrustedSource: true) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.121`.
    lv_text1 = lv_text1 && ` (or a patched maintenance release) to render it.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.PDFViewer`                       name = `PDFViewerPopup`                      class = `z2ui5_cl_ai_app_044` path = `src/01/b03/z2ui5_cl_ai_app_044.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        since = `1.48`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = lv_text1
        post171 = `the PDFViewer property isTrustedSource (since UI5 1.121, backported to maintenance patches down to 1.71.63; the original controller passes isTrustedSource: true) is newer than 1.71 but kept for the` &&
                 ` 1:1 port - the app needs a UI5 release >= 1.121 (or a patched maintenance release) to render it.` ) ).

    lv_text1 = `NOTE: The object-typed calendar date properties (PlanningCalendar.startDate, CalendarAppointment.startDate/endDate) are fed from plain ISO strings in the model and converted at the point of use with` &&
               ` Formatter.DateCreateObject from the curated module (core:require='{Formatter: z2ui5/model/formatter}'). The original's UI5Date.getInstance(year, month0, day, ...) values are normalized to ISO 1:1` &&
               ` (month is 0-based; day/month overflow rolled forward exactly as the JS Date constructor does). // IMPROVISED: appointmentSelect / intervalSelect / the ToggleButton toggleDayNamesLine are wired to` &&
               ` simple toasts. The original opens a MessageBox with the selected appointment title + count, appends a new appointment on interval select, and toggles the day-names line — those interactive behaviors` &&
               ` are lost here although partly expressible: showDayNamesLine (@since 1.50) is a bindable property (two-way flag + view_model_update, the prefer-a-bindable-property rule), the MessageBox is` &&
               ` client->message_box_display and the appointment title is client-resolvable via ${$parameters>/appointment}.getTitle(); only the date-object event parameters for the interval append are genuinely`.
    lv_text1 = lv_text1 && ` unverified. Review 2026-07-27: needs rework, retyped from NOTE - a lost behavior is IMPROVISED, not NOTE. // POST-1.71: Formatter.DateCreateObject is referenced via core:require, which needs UI5 >=` &&
               ` 1.74. sap.m.PlanningCalendar itself is since 1.34 (in scope). Also sap.ui.unified.CalendarAppointment.ariaHasPopup (@since 1.150.0) is kept 1:1 from the original view (ariaHasPopup='{ariaHasPopup}');` &&
               ` newer than 1.71, declared. Was undeclared because the property gate was sap.m-only (now extended to all libs, 2026-07-24).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.PlanningCalendar`                name = `PlanningCalendarSingle`              class = `z2ui5_cl_ai_app_108` path = `src/01/b14/z2ui5_cl_ai_app_108.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.34`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-27): verified in a running system 2026-07-27 - PlanningCalendar renders all appointments/interval headers via Formatter.DateCreateObject; interactions toast as declared`
        notes = lv_text1
        post171 = `Formatter.DateCreateObject is referenced via core:require, which needs UI5 >= 1.74. sap.m.PlanningCalendar itself is since 1.34 (in scope). Also sap.ui.unified.CalendarAppointment.ariaHasPopup (@since` &&
                 ` 1.150.0) is kept 1:1 from the original view (ariaHasPopup='{ariaHasPopup}'); newer than 1.71, declared. Was undeclared because the property gate was sap.m-only (now extended to all libs, 2026-07-24).` ) ).

    lv_text1 = `POST-1.71: Button.ariaHasPopup (since UI5 1.84) is kept 1:1 on the two view buttons (ariaHasPopup='Dialog'); the app needs a UI5 release >= 1.84 to render it. // IMPROVISED:` &&
               ` handlePopoverPress/handleResizablePopoverPress lazily Fragment.load a Popover and openBy(button). The port builds each popover as a core:FragmentDefinition on the button-press round-trip and shows it` &&
               ` anchored to the pressed button via client->popover_display( xml = ..., by_id = $event.oSource.sId ) - the popover XML parameter is named ``xml`` (not ``val`` like popup_display). This is a` &&
               ` server-round-trip where the original is a client-side Fragment.load, but it is faithful (lazy either way) and matches app 094. // NOTE: the original oPopover.bindElement('/ProductCollection/0') binds` &&
               ` each popover to a single record; the port seeds that record's fields (name, productpicurl) at the default-model root and the popover's relative bindings {NAME}/{PRODUCTPICURL} resolve against the` &&
               ` root - same data, structural-diff matches on the last path segment (app 175 single-record-flatten idiom). No bind_element needed because the record is the static row 0, not a per-row selection. //`.
    lv_text1 = lv_text1 && ` NOTE: handleEmailPress does byId('myPopover').close() + MessageToast.show('E-Mail has been sent'), and handleClose does byId('myResizablePopover').close(); both close the popover slot via` &&
               ` follow_up_action( cs_event-popover_close ) (there is one popover slot open at a time), the email variant additionally toasting via message_toast_display. // IMPROVISED: the JSONModel is loaded from` &&
               ` the shared sap/ui/demo/mock/products.json; only the single record /ProductCollection/0 is bound, so only its name + picture URL are seeded. The mock's host-relative ProductPicUrl` &&
               ` ('test-resources/...') is resolved to an absolute sdk.openui5.org URL. // LIVE-TEST: unverified in a running system: that both popovers open anchored to their button (popover_display by_id =` &&
               ` $event.oSource.sId), that {NAME}/{PRODUCTPICURL} resolve from the root-seeded record, and that the Email/Close footer buttons close the popover (popover_close) with the Email toast firing.` &&
               ` **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the 'Show Popover' press opens the popover anchored with the root-seeded relative bindings rendering (the`.
    lv_text1 = lv_text1 && ` 'Email' action visible); the resizable variant is the identical wire.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Popover`                         name = `Popover`                             class = `z2ui5_cl_ai_app_229` path = `src/01/b18/z2ui5_cl_ai_app_229.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Button.ariaHasPopup (since UI5 1.84) is kept 1:1 on the two view buttons (ariaHasPopup='Dialog'); the app needs a UI5 release >= 1.84 to render it.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Popover`                         name = `PopoverControllingCloseBehavior`     class = `z2ui5_cl_ai_app_094` path = `src/01/b11/z2ui5_cl_ai_app_094.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        is_post171 = abap_true
        notes = `POST-1.71: Link.ariaHasPopup (since 1.86) is kept 1:1 on the popover link; needs UI5 >= 1.86. // IMPROVISED: the row Popover reproduces the original bindElement: it is built per-press with relative` &&
                 ` bindings ({PRODUCT_ID} title, {NAME}, {PRODUCT_PIC_URL}) and follow_up_action( cs_event-bind_element, view=cs_view-popover ) element-binds the popover slot to t_products/<index>, where the index` &&
                 ` comes from the pressed row's binding context ($event.oSource.getBindingContext().getPath()); the popover is anchored by $event.oSource.sId and the Action button reproduces handleActionPress 1:1 (a` &&
                 ` toast 'Action has been pressed' + follow_up_action( cs_event-popover_close )). The disable/enable-pointer-events-while-open behavior is dropped.`
        post171 = `Link.ariaHasPopup (since 1.86) is kept 1:1 on the popover link; needs UI5 >= 1.86.` )
      ( module = `sap.m`              control = `sap.m.ProgressIndicator`               name = `ProgressIndicator`                   class = `z2ui5_cl_ai_app_070` path = `src/01/b09/z2ui5_cl_ai_app_070.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.13.1`
        is_post171 = abap_true
        notes = `IMPROVISED: the two interactive ProgressIndicators (pi-with-animation / pi-without-animation) are set to 0/100 via two-way bound percentValue/displayValue fields updated in a SET event, replacing the` &&
                 ` original's controller byId(...).setPercentValue/setDisplayValue calls. // POST-1.71: ProgressIndicator.displayAnimation (since UI5 1.73) is kept 1:1 on the no-animation ProgressIndicator; needs UI5` &&
                 ` >= 1.73.`
        post171 = `ProgressIndicator.displayAnimation (since UI5 1.73) is kept 1:1 on the no-animation ProgressIndicator; needs UI5 >= 1.73.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.PullToRefresh`                   name = `PullToRefresh`                       class = `z2ui5_cl_ai_app_081` path = `src/01/b10/z2ui5_cl_ai_app_081.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.9.2`
        notes = `NOTE: the incremental backend load is reproduced 1:1: the model starts with the first product and each pull-to-refresh (REFRESH) appends the next until the full /ProductCollection is shown (fill_all +` &&
                 ` shown counter).` ) ).

    lv_text1 = `IMPROVISED: The original binds four separate named JSONModels (CompanyModel / EmployeeModel / GenericModel / GenericModelNoHeader) and swaps the model on the shared QuickView before openBy. abap2UI5` &&
               ` serves a single default model, so the four data sets are flattened into four ABAP tables (kept in PROTECTED) and the pressed button copies the relevant one into the bound t_pages before the popover` &&
               ` is opened. Named ABAP-fed JSON models are not expressible (CAPABILITIES). // NOTE: The QuickView popover is built per press and shown 1:1 via client->popover_display( xml, by_id ), anchored to the` &&
               ` pressed button (the original oQuickView.openBy(oButton)). The nested pages/groups/elements are a nested ABAP table; relative child aggregations (groups, elements) keep the original binding-info form.` &&
               ` // NOTE: The navigate toast is simplified to a fixed message (the original shows the clicked link's text via navOrigin, a control reference that is not transportable as an event arg). Elements` &&
               ` without an elementType (Generic pages, and the Address/Slogan rows) get the QuickViewGroupElementType default 'text', pages without displayShape (Generic) get the AvatarShape default 'Circle', and`.
    lv_text1 = lv_text1 && ` every element row seeds target '_blank' (the QuickViewGroupElement.target default) - absent JSON properties must not serialize as empty strings, which would override the UI5 defaults. The` &&
               ` EmployeeData icon (a test-resources image) points at the OpenUI5 host. // POST-1.71: sap.m.Avatar (control since 1.73) is kept 1:1 as the page icon via the QuickViewPage avatar aggregation, which` &&
               ` itself is since UI5 1.92 - so the app needs UI5 >= 1.92 to render the avatar. // POST-1.71: sap.m.Button.ariaHasPopup (since 1.84) is kept 1:1 on the four trigger buttons; needs UI5 >= 1.84.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.QuickView`                       name = `QuickView`                           class = `z2ui5_cl_ai_app_100` path = `src/01/b12/z2ui5_cl_ai_app_100.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.28.11`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.Avatar (control since 1.73) is kept 1:1 as the page icon via the QuickViewPage avatar aggregation, which itself is since UI5 1.92 - so the app needs UI5 >= 1.92 to render the avatar. //` &&
                 ` sap.m.Button.ariaHasPopup (since 1.84) is kept 1:1 on the four trigger buttons; needs UI5 >= 1.84.` ) ).

    lv_text1 = `NOTE: The QuickViewCard fragment is inlined into the main view instead of a separate core:Fragment include, so the port has no core:Fragment control. The nested pages/groups/elements are a nested ABAP` &&
               ` table (t_pages) bound 1:1; relative child aggregations (groups, elements) keep the original binding-info form. // NOTE: The external Navigate-Back button drives the card 1:1 via follow_up_action(` &&
               ` cs_event-control_by_id, navigateBack ) — navigateBack was whitelisted in the paired abap2UI5 change. afterNavigate forwards the public isTopPage parameter and enables the button while the card is not` &&
               ` on its top page. The navigate toast is simplified to a fixed message (the original distinguishes the clicked link's text vs the back button via navOrigin, a control reference that is not` &&
               ` transportable as an event arg). // NOTE: Elements without an elementType in the source JSON (Address, Slogan) are filled with the QuickViewGroupElementType default 'text', and every element row seeds` &&
               ` target '_blank' (the QuickViewGroupElement.target default) - absent JSON properties must not serialize as empty strings, which would override the UI5 defaults. onAfterRendering's 320px maxWidth tweak`.
    lv_text1 = lv_text1 && ` is dropped. // POST-1.71: sap.m.Avatar (control since 1.73) is kept 1:1 as the page icon via the QuickViewPage avatar aggregation, which itself is since UI5 1.92 - so the app needs UI5 >= 1.92 to` &&
               ` render the avatar.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.QuickViewCard`                   name = `QuickViewCard`                       class = `z2ui5_cl_ai_app_099` path = `src/01/b12/z2ui5_cl_ai_app_099.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.28.11`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.Avatar (control since 1.73) is kept 1:1 as the page icon via the QuickViewPage avatar aggregation, which itself is since UI5 1.92 - so the app needs UI5 >= 1.92 to render the avatar.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.RadioButton`                     name = `RadioButton`                         class = `z2ui5_cl_ai_app_069` path = `src/01/b09/z2ui5_cl_ai_app_069.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = `POST-1.71: RadioButton.wrapping and RadioButton.wrappingType (both since UI5 1.126) are kept 1:1 on the wrapping-demo group; the app needs a UI5 release >= 1.126 to render them.`
        post171 = `RadioButton.wrapping and RadioButton.wrappingType (both since UI5 1.126) are kept 1:1 on the wrapping-demo group; the app needs a UI5 release >= 1.126 to render them.` )
      ( module = `sap.m`              control = `sap.m.RangeSlider`                     name = `RangeSlider`                         class = `z2ui5_cl_ai_app_045` path = `src/01/b02/z2ui5_cl_ai_app_045.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.38`
        notes = `NOTE: the sample binds the composite RangeSlider "range" property (an array [low, high] - range="{/RS1}" / range="0,100"). abap2UI5 binds scalar ABAP fields, so each range is expressed as the` &&
                 ` equivalent value / value2 properties the control keeps in sync - identical rendering.` ) ).

    lv_text1 = `POST-1.71: Button.ariaHasPopup (since UI5 1.84.0) is kept 1:1 on the two trigger buttons (ariaHasPopup='Dialog'); the app needs a UI5 release >= 1.84 to render it. // IMPROVISED:` &&
               ` handleResponsivePopoverPress/handleResponsivePopoverFooterPress lazily Fragment.load a ResponsivePopover fragment and openBy(button). The port builds each fragment (Popover.fragment.xml ->` &&
               ` ResponsivePopover id='myPopover'; PopoverFooter.fragment.xml -> ResponsivePopover id='myFooterPopover') as a core:FragmentDefinition on the button-press round-trip and shows it anchored to the` &&
               ` pressed button via client->popover_display( xml = ..., by_id = $event.oSource.sId ) - the popover XML parameter is named 'xml' (not 'val' like popup_display). A server round-trip where the original` &&
               ` is a client-side Fragment.load, but faithful (lazy either way) and matches apps 229/238. All ResponsivePopover/Button/Image/OverflowToolbar/ToolbarSpacer controls of both fragments are built in the` &&
               ` port, so the fragment union in structural-diff is satisfied. // NOTE: the original oPopover.bindElement('/ProductCollection/0') binds each popover to a single record; the port seeds that record's`.
    lv_text1 = lv_text1 && ` fields (name, productpicurl) at the default-model root and the fragments' relative bindings {NAME}/{PRODUCTPICURL} resolve against the root - same data, structural-diff matches on the last path` &&
               ` segment. No bind_element follow-up needed because the record is the static row 0, not a per-row selection. // NOTE: handleCloseButton (Action-A/Action-B) and handleCloseFooterButton (Cancel) each do` &&
               ` byId(...).close(); the port routes all three to one CLOSE event that issues follow_up_action( cs_event-popover_close ) - only one popover slot is open at a time, so a single popover_close covers both` &&
               ` fragments. The footer's OK button has no handler in the original and none here. // IMPROVISED: the JSONModel is loaded from the shared sap/ui/demo/mock/products.json; only the single record` &&
               ` /ProductCollection/0 is bound (its Name + ProductPicUrl), so only those are seeded. The mock's host-relative ProductPicUrl ('test-resources/...') is resolved to an absolute sdk.openui5.org URL. //` &&
               ` LIVE-TEST: unverified in a running system: that both ResponsivePopover fragments open anchored to their button (popover_display by_id = $event.oSource.sId), that {NAME}/{PRODUCTPICURL} resolve from`.
    lv_text1 = lv_text1 && ` the root-seeded record, and that the action/footer buttons close the popover (popover_close). **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the 'Popover with` &&
               ` Custom Footer' press opens the ResponsivePopover anchored with its OK/Cancel footer; the phone-Dialog variant remains unexercised.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ResponsivePopover`               name = `ResponsivePopover`                   class = `z2ui5_cl_ai_app_243` path = `src/01/b19/z2ui5_cl_ai_app_243.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.15.1`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Button.ariaHasPopup (since UI5 1.84.0) is kept 1:1 on the two trigger buttons (ariaHasPopup='Dialog'); the app needs a UI5 release >= 1.84 to render it.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ScrollContainer`                 name = `ScrollContainer`                     class = `z2ui5_cl_ai_app_046` path = `src/01/b04/z2ui5_cl_ai_app_046.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed); incl. the phone-emulation device> check`
        notes = `IMPROVISED: the Image src binds {img>/products/pic1} in the original, a JSON image model not available server-side; a static demo image URL is used instead.` )
      ( module = `sap.m`              control = `sap.m.SearchField`                     name = `DialogSearch`                        class = `z2ui5_cl_ai_app_090` path = `src/01/b11/z2ui5_cl_ai_app_090.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: the Dialog (loaded from a fragment in the original) is built and shown via popup_display on the button press; its content is static text, so the bindElement /ProductCollection/0 is a no-op and` &&
                 ` dropped.` )
      ( module = `sap.m`              control = `sap.m.SegmentedButton`                 name = `SegmentedButton`                     class = `z2ui5_cl_ai_app_047` path = `src/01/b03/z2ui5_cl_ai_app_047.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `NOTE: the original reads the selected item via oEvent.getParameter("item").getText() / getSelectedItem(). Here the items get keys (one/two/three - an addition, SB1 has none in the sample) and` &&
                 ` selectedKey is two-way bound, so the selection arrives with the event and no private event path is needed - the documented 1:1 path for controller-read selection (CAPABILITIES.md), not a workaround.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Select`                          name = `Select`                              class = `z2ui5_cl_ai_app_048` path = `src/01/b02/z2ui5_cl_ai_app_048.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: the original controller seeds three byte-identical product arrays (/ProductCollection, /ProductCollection2, /ProductCollection3) and binds one Select to each; the port folds them into the single` &&
                 ` shared table /T_PRODUCTS feeding all three Selects - same rows, same sorter, each Select keeps its own two-way selectedKey, so rendering and behaviour are identical.` )
      ( module = `sap.m`              control = `sap.m.Select`                          name = `SelectWithIcons`                     class = `z2ui5_cl_ai_app_205` path = `src/01/b17/z2ui5_cl_ai_app_205.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` ) ).

    lv_text1 = `IMPROVISED: The original configures one shared SelectDialog imperatively per button (oButton.data() CustomData ->` &&
               ` setMultiSelect/setGrowing/setGrowingThreshold/setRememberSelections/setShowClearButton/setConfirmButtonText/setDraggable/setResizable/toggleStyleClass). abap2UI5 binds those SelectDialog properties` &&
               ` two-way and each button's handler sets them before opening (responsivePadding toggles the style class via control_by_id addStyleClass/removeStyleClass). The core:CustomData is kept on the buttons for` &&
               ` fidelity; the dialog is declared once in mvc:dependents and opened via follow_up_action( cs_event-control_by_id, open ). // NOTE: Search filters the dialog's items binding client-side via` &&
               ` _event_client( cs_event-binding_call, filter NAME Contains ${$parameters>/value} ). The valueHelpRequest opens a second SelectDialog (also in dependents) after preselecting the row matching the input` &&
               ` value. The confirm / value-help-close toasts are simplified — selectedContexts / selectedItem are control references not transportable as event args (original composes the chosen product names /`.
    lv_text1 = lv_text1 && ` copies the selected title into the input). // IMPROVISED: The StandardListItem icon binds ProductPicUrl, which is derived in ABAP from the product id (the mock's test-resources/<id>.jpg) built from a` &&
               ` shared base pointing at the OpenUI5 host, like app 006's image flattening. The full 123-row /ProductCollection is inlined. // LIVE-TEST: The per-button dialog configuration` &&
               ` (multi/growing/remember/clear/confirm text/draggable/resizable), the client-side search filter and the value-help selection need an in-system check; machine gates only verify the views are valid.` &&
               ` **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the 'Show Select Dialog' popup opens with the 'Select Product' title; the per-button variants, search and` &&
               ` copy-back remain unexercised. // POST-1.71: sap.m.SelectDialog.searchPlaceholder (since 1.110) is kept 1:1 on the value-help dialog; needs UI5 >= 1.110.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.SelectDialog`                    name = `SelectDialog`                        class = `z2ui5_cl_ai_app_103` path = `src/01/b12/z2ui5_cl_ai_app_103.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.SelectDialog.searchPlaceholder (since 1.110) is kept 1:1 on the value-help dialog; needs UI5 >= 1.110.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.SelectList`                      name = `SelectList`                          class = `z2ui5_cl_ai_app_075` path = `src/01/b09/z2ui5_cl_ai_app_075.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26.0` )
      ( module = `sap.m`              control = `sap.m.SelectList`                      name = `SelectListWithIcons`                 class = `z2ui5_cl_ai_app_211` path = `src/01/b17/z2ui5_cl_ai_app_211.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26.0` ) ).

    lv_text1 = `NOTE: onSemanticButtonPress toasts each action's class name, reproduced by passing the name as a t_arg literal. The SortSelect change toasts the two-way selectedKey (sort_key); PagingButton` &&
               ` positionChange transports ${$parameters>/newPosition}; the custom footer / share buttons transport $event.oSource.sId. // NOTE: MultiSelectAction and MessagesIndicator reproduced 1:1 since` &&
               ` 2026-07-30. onMultiSelectPress: the press transports ${$source>/pressed} and the backend toasts 'MultiSelect Pressed'/'MultiSelect Unpressed' from the toggle state exactly like getPressed().` &&
               ` onMessagesButtonPress: the controller-built MessagePopover over the message model is declared as a dependent of the MessagesIndicator (added controls vs the original view.xml: MessagePopover +` &&
               ` MessageItem with the original's {message>description}/{message>type}/{message>message} template) and toggled roundtrip-free via _event_client control_by_id toggleBy ($event.oSource.sId) - the` &&
               ` _messagePopover.toggle(oMessagesButton) equivalent. onInit's MessageManager.addMessages seed ('Something wrong happened', Error) rides on an added z2ui5.cc.MessageManager bridge control (in an added`.
    lv_text1 = lv_text1 && ` semantic content aggregation, declared) with its one-row items table - the app-065 idiom. // NOTE: The SortSelect items are bound to a 2-row filter-type table reproducing` &&
               ` /ProductCollectionStats/Filters (the two ``type`` values Category and SupplierName; the per-type ``values`` sub-arrays are unused by the Select). The binding keeps the original sorter { path: 'Name'` &&
               ` } 1:1 — a no-op there too, since the Filters entries carry ``type``, not ``Name``.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.semantic.SemanticPage`           name = `SemanticPage`                        class = `z2ui5_cl_ai_app_107` path = `src/01/b13/z2ui5_cl_ai_app_107.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.30.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: onSemanticButtonPress toasts each action's class name, reproduced by passing the name as a t_arg literal. The SortSelect change toasts the two-way selectedKey (sort_key); PagingButton` &&
               ` positionChange transports ${$parameters>/newPosition}; the custom footer / share buttons transport $event.oSource.sId. // NOTE: MultiSelectAction and MessagesIndicator reproduced 1:1 since` &&
               ` 2026-07-30. onMultiSelectPress: the press transports ${$source>/pressed} and the backend toasts 'MultiSelect Pressed'/'MultiSelect Unpressed' from the toggle state exactly like getPressed().` &&
               ` onMessagesButtonPress: the controller-built MessagePopover over the message model is declared as a dependent of the MessagesIndicator (added controls vs the original view.xml: MessagePopover +` &&
               ` MessageItem with the original's {message>description}/{message>type}/{message>message} template) and toggled roundtrip-free via _event_client control_by_id toggleBy ($event.oSource.sId) - the` &&
               ` _messagePopover.toggle(oMessagesButton) equivalent. onInit's MessageManager.addMessages seed ('Something wrong happened', Error) rides on an added z2ui5.cc.MessageManager bridge control (in an added`.
    lv_text1 = lv_text1 && ` semantic content aggregation, declared) with its one-row items table - the app-065 idiom. // NOTE: The SortSelect items are bound to a 2-row filter-type table reproducing` &&
               ` /ProductCollectionStats/Filters (the two ``type`` values Category and SupplierName; the per-type ``values`` sub-arrays are unused by the Select). The binding keeps the original sorter { path: 'Name'` &&
               ` } 1:1 — a no-op there too, since the Filters entries carry ``type``, not ``Name``. // NOTE: Same as SemanticPage but the MasterPage and DetailPage carry floatingFooter='true' and the MasterPage drops` &&
               ` the PageAccessibleLandmarkInfo (matching the SemanticPageFloatingFooter variant).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.semantic.SemanticPage`           name = `SemanticPageFloatingFooter`          class = `z2ui5_cl_ai_app_106` path = `src/01/b13/z2ui5_cl_ai_app_106.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.30.0`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.semantic.SemanticPage`           name = `SemanticPageFullScreen`              class = `z2ui5_cl_ai_app_105` path = `src/01/b13/z2ui5_cl_ai_app_105.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.30.0`
        notes = `NOTE: onSemanticButtonPress toasts the pressed control's class name (getMetadata().getName() minus the library); reproduced by passing each semantic action's name as a t_arg literal ('AddAction',` &&
                 ` 'EditAction', ...) and toasting 'Pressed: <name>'. The custom footer buttons toast the pressed control id via $event.oSource.sId (original onPress). The MessagesIndicator toast is simplified to a` &&
                 ` fixed message (the original opens a MessagePopover, dropped here).` ) ).

    lv_text1 = `NOTE: The object-typed date properties (SinglePlanningCalendar.startDate, CalendarAppointment.startDate/endDate) are fed from ISO strings and converted with Formatter.DateCreateObject (core:require).` &&
               ` The original UI5Date.getInstance values are normalized to ISO 1:1 (0-based months). The first appointment used UI5Date.getInstance() (the current time); it is pinned to the calendar's start date` &&
               ` (2018-07-09) so the port is deterministic. // IMPROVISED: The four calendar events fire backend round-trips that toast, as in the original. Two of them now carry their value: weekNumberPress` &&
               ` transports ${$parameters>/weekNumber} and startDateChange transports ${$parameters>/date}, and the toast texts append them exactly as the original does ('...\n\nweek number is <n>' / '...\n\nNew` &&
               ` start date is <date>') - until 2026-07-28 the port toasted only the event name, which the sidecar itself flagged as a faked value where the transport exists. Two stay name-only, for different` &&
               ` reasons: viewChange because the original's toast carries no value either, and selectedDatesChange because its selectedDates parameter is an ARRAY OF DateRange CONTROLS which the original iterates and`.
    lv_text1 = lv_text1 && ` formats (oRange.getStartDate().toDateString() per entry) - control references are not transportable as event args, so that toast keeps the event name alone. The transported start date is the` &&
               ` client-side string form of the JS Date, not the original's oStartDate.toString() rendering, so the exact wording of that one line can differ. // POST-1.71: Formatter.DateCreateObject is referenced` &&
               ` via core:require (UI5 >= 1.74). sap.m.SinglePlanningCalendar and its DayView/WorkWeekView/WeekView/MonthView are since 1.61 (in scope). Also the SinglePlanningCalendar events weekNumberPress and` &&
               ` selectedDatesChange (@since 1.123) are kept 1:1 from the original view; newer than 1.71, declared per the property-171 policy.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.SinglePlanningCalendar`          name = `SinglePlanningCalendarDateSelection` class = `z2ui5_cl_ai_app_109` path = `src/01/b14/z2ui5_cl_ai_app_109.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.61`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Formatter.DateCreateObject is referenced via core:require (UI5 >= 1.74). sap.m.SinglePlanningCalendar and its DayView/WorkWeekView/WeekView/MonthView are since 1.61 (in scope). Also the` &&
                 ` SinglePlanningCalendar events weekNumberPress and selectedDatesChange (@since 1.123) are kept 1:1 from the original view; newer than 1.71, declared per the property-171 policy.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Slider`                          name = `Slider`                              class = `z2ui5_cl_ai_app_068` path = `src/01/b09/z2ui5_cl_ai_app_068.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` )
      ( module = `sap.m`              control = `sap.m.SlideTile`                       name = `SlideTile`                           class = `z2ui5_cl_ai_app_082` path = `src/01/b10/z2ui5_cl_ai_app_082.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        notes = `NOTE: the sample's demo-kit backgroundImage paths are resolved to absolute sdk.openui5.org URLs.` ) ).

    lv_text1 = `NOTE: Master-detail navigation is driven 1:1 via follow_up_action( cs_event-control_by_id ) on the newly whitelisted SplitApp methods: to (Go-to-Detail button), backDetail/backMaster (page` &&
               ` navButtonPress), toMaster (master list item), toDetail (master2 list items) and setMode (RadioButtonGroup). The methods were added to the abap2UI5 framework in the same change set (CONTROL_METHODS).` &&
               ` // NOTE: The master2 list navigates via a per-item press event that carries the target page id as a t_arg literal ('detail'/'detailDetail'/'detail2'); the original reads the pressed item's custom:to` &&
               ` CustomData in one List.itemPress handler, which is not transportable as an event arg. custom:to is kept on the items for fidelity. // NOTE: The split mode is selected via a two-way selectedIndex` &&
               ` binding on the RadioButtonGroup (mode_idx) and mapped to the SplitAppMode string in ABAP; the original reads the selected RadioButton's custom:splitAppMode CustomData. custom:splitAppMode is kept on` &&
               ` the buttons for fidelity. The onInit setHomeIcon and the onOrientationChange toast are dropped (device-specific cosmetics). // LIVE-TEST: SplitApp as the root view plus the control_by_id navigation`.
    lv_text1 = lv_text1 && ` (to/toDetail/toMaster/backDetail/backMaster/setMode) need an in-system check — machine gates only verify view validity, not the runtime navigation roundtrip.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.SplitApp`                        name = `SplitApp`                            class = `z2ui5_cl_ai_app_097` path = `src/01/b12/z2ui5_cl_ai_app_097.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: Master-detail navigation is driven 1:1 via follow_up_action( cs_event-control_by_id ) on the newly whitelisted SplitContainer methods: to (Go-to-Detail button), backDetail/backMaster (page` &&
               ` navButtonPress), toMaster (master list item), toDetail (master2 list items) and setMode (RadioButtonGroup). The methods were added to the abap2UI5 framework in the same change set (CONTROL_METHODS).` &&
               ` // NOTE: The master2 list navigates via a per-item press event that carries the target page id as a t_arg literal ('detail'/'detailDetail'/'detail2'); the original reads the pressed item's custom:to` &&
               ` CustomData in one List.itemPress handler, which is not transportable as an event arg. custom:to is kept on the items for fidelity. // NOTE: The split mode is selected via a two-way selectedIndex` &&
               ` binding on the RadioButtonGroup (mode_idx) and mapped to the SplitAppMode string in ABAP; the original reads the selected RadioButton's custom:splitAppMode CustomData. custom:splitAppMode is kept on` &&
               ` the buttons for fidelity. The onAfterRendering parent-height fix and the device-model onInit setup (device model is global in abap2UI5) are dropped. // NOTE: live-verified 2026-07-27: SplitContainer`.
    lv_text1 = lv_text1 && ` as the root view plus the control_by_id navigation (to/toDetail/toMaster/backDetail/backMaster/setMode) need an in-system check — machine gates only verify view validity, not the runtime navigation` &&
               ` roundtrip.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.SplitContainer`                  name = `SplitContainer`                      class = `z2ui5_cl_ai_app_096` path = `src/01/b12/z2ui5_cl_ai_app_096.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        checked = `CHECKED (2026-07-27): verified in a running system 2026-07-27 - SplitContainer toDetail/toMaster/backDetail/backMaster/setMode navigation works across modes`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.StandardListItem`                name = `StandardListItem`                    class = `z2ui5_cl_ai_app_212` path = `src/01/b17/z2ui5_cl_ai_app_212.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` )
      ( module = `sap.m`              control = `sap.m.StandardListItem`                name = `StandardListItemAvatar`              class = `z2ui5_cl_ai_app_083` path = `src/01/b10/z2ui5_cl_ai_app_083.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = `NOTE: the List element binding {/ProductCollection} and the items' index paths ({0/Name}..{3/Name}) are kept 1:1 against the default-model table /T_PRODUCTS (full 123-row mock inlined). // POST-1.71:` &&
                 ` the sap.m.Avatar control (since UI5 1.73) is newer than 1.71 but kept for the 1:1 port on three items. // POST-1.71: the StandardListItem avatar aggregation (since UI5 1.98) is newer than 1.71 but` &&
                 ` kept for the 1:1 port - the app needs a UI5 release >= 1.98 to render it. Aggregation/control-level, invisible to the attribute-scanning property gate.`
        post171 = `the sap.m.Avatar control (since UI5 1.73) is newer than 1.71 but kept for the 1:1 port on three items. // the StandardListItem avatar aggregation (since UI5 1.98) is newer than 1.71 but kept for the` &&
                 ` 1:1 port - the app needs a UI5 release >= 1.98 to render it. Aggregation/control-level, invisible to the attribute-scanning property gate.` )
      ( module = `sap.m`              control = `sap.m.StandardListItem`                name = `StandardListItemDescription`         class = `z2ui5_cl_ai_app_202` path = `src/01/b17/z2ui5_cl_ai_app_202.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.StandardListItem`                name = `StandardListItemInfo`                class = `z2ui5_cl_ai_app_208` path = `src/01/b17/z2ui5_cl_ai_app_208.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: the original binds infoState via the presentation-only formatter '.formatter.status' (maps the already-classified Status Available->Success / Out of Stock->Warning / Discontinued->Error / else` &&
                 ` None to a ValueState). abap2UI5 being a thin frontend, the info state is derived in the backend into the INFOSTATE field and bound directly (infoState="{INFOSTATE}"); same output, no loss. All 123` &&
                 ` mock rows (Name/Status) kept verbatim; the List items sorter:{path:'NAME'} is kept 1:1 as a raw binding-info string.` )
      ( module = `sap.m`              control = `sap.m.StandardListItem`                name = `StandardListItemInfoStateInverted`   class = `z2ui5_cl_ai_app_204` path = `src/01/b17/z2ui5_cl_ai_app_204.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = `POST-1.71: sap.m.StandardListItem infoStateInverted (since 1.74) is kept 1:1 from the original view; needs a UI5 release >= 1.74 to render.`
        post171 = `sap.m.StandardListItem infoStateInverted (since 1.74) is kept 1:1 from the original view; needs a UI5 release >= 1.74 to render.` ) ).

    lv_text1 = `IMPROVISED: the sample binds a List to the JSON model /modelData and renders one templated CustomListItem per row. The rows are unrolled into static list items here because every row sets a different` &&
               ` subset of the StepInput properties - an empty ABAP model field would bind as "" instead of leaving the property at its default, so a bound template would not render 1:1. Template properties no row` &&
               ` ever sets (valueState) are dropped with it. // NOTE: the change toast was switched to a roundtrip-free client-composed toast on 2026-07-22 (control_global MESSAGE_TOAST.show, template ``Value changed` &&
               ` to '{0}'`` with get_t_arg single-quote escaping; on_event dropped, init-only) - re-verify changing a StepInput toasts "Value changed to '<value>'" with the quotes intact. **e2e-verified 2026-07-30**` &&
               ` (transpiled-framework interaction, scripts/e2e-smoke.mjs): ArrowUp + Enter on the first StepInput fires change and toasts "Value changed to '<value>'" with the quotes intact; the other StepInputs are` &&
               ` the identical wire.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.StepInput`                       name = `StepInput`                           class = `z2ui5_cl_ai_app_049` path = `src/01/b02/z2ui5_cl_ai_app_049.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.40`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Switch`                          name = `Switch`                              class = `z2ui5_cl_ai_app_050` path = `src/01/b02/z2ui5_cl_ai_app_050.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` ) ).

    lv_text1 = `NOTE: addNewButtonPress appends an empty employee row to the bound /T_EMPLOYEES (the addItem+setSelectedItem equivalent for a bound aggregation; the new tab is appended but not auto-selected -` &&
               ` TabContainer.selectedItem is an association a bound-row clone cannot address from the backend, the one residual difference). itemCloseHandler reproduced 1:1 since 2026-07-30: the itemClose wire` &&
               ` carries s_ctrl-check_prevent_default (the original calls oEvent.preventDefault() unconditionally) and transports ${$parameters>/item}.getName() plus the row index via` &&
               ` ${$parameters>/item/oParent}.indexOfItem(${$parameters>/item}) (the dnd-idiom index transport); the backend raises MessageBox.confirm (Do you want to close the tab '<name>'?, onclose CLOSE_DECIDE)` &&
               ` and on OK deletes the row + view_model_update (the bound-aggregation removeItem) and toasts 'Item closed: <name>' (duration 500), on Cancel toasts 'Item close canceled: <name>' - exactly the` &&
               ` original's onClose branches. The pending name/index live in protected state across the confirm round-trip. The earlier static 'Close requested' toast (tab never removable) is gone. // LIVE-TEST: the`.
    lv_text1 = lv_text1 && ` prevent-default itemClose + MessageBox.confirm + row-delete chain and the index transport via the oParent indexOfItem form are unverified in a running system; the e2e interaction covers` &&
               ` open-confirm-OK-removes end to end in the transpiled harness. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): covered end to end: close icon -> confirm box with` &&
               ` the item name -> OK -> row removed + 'Item closed:' toast (needs the 2026-07-30 Messages.js onclose fix - under the broken wire the OK action never arrived).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.TabContainer`                    name = `TabContainer`                        class = `z2ui5_cl_ai_app_093` path = `src/01/b11/z2ui5_cl_ai_app_093.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Table`                           name = `TableAlternateRowColors`             class = `z2ui5_cl_ai_app_210` path = `src/01/b17/z2ui5_cl_ai_app_210.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16` ) ).

    lv_text1 = `POST-1.71: Table.autoPopinMode (since 1.76), Table.popinChanged (since 1.77) and Column.importance (since 1.76), the core of the auto-pop-in demo, are kept 1:1; needs UI5 >= 1.77. // IMPROVISED:` &&
               ` onSelectionFinish (setHiddenInPopin(getSelectedKeys())) is reproduced 1:1: the MultiComboBox selectedKeys are two-way bound to t_hidden and the selectionFinish round-trip forwards them as a JSON` &&
               ` Priority array through follow_up_action( cs_event-control_by_id, setHiddenInPopin ), so the matching columns hide while in pop-in. The added selectedKeys binding has no counterpart in the original` &&
               ` (the controller reads getSelectedKeys imperatively). onSliderMoved (byId(idProductsTable).setWidth(value + '%')) is now reproduced 1:1 without a round-trip: the Slider value is two-way bound to` &&
               ` width_pct and the Table gains a width expression binding width={= ${width_pct} + '%' }, so moving the Slider shrinks the table live and drives the auto-pop-in (the added Table width attribute and the` &&
               ` Slider value binding have no counterpart in the original view, where setWidth is imperative; the original Slider liveChange handler is dropped). autoPopinMode + Column.importance stay declarative and`.
    lv_text1 = lv_text1 && ` 1:1; popinChanged still toasts. // NOTE: the original derives the ObjectNumber weight state in its frontend Formatter.js (weightState: KG conversion + Success/Warning/Error thresholds). That is` &&
               ` business logic, so - abap2UI5 being a thin frontend - it is computed in ABAP model_init into a WEIGHT_STATE field and bound state="{WEIGHT_STATE}", not via a frontend formatter (core:require` &&
               ` dropped). Visually 1:1 with the original. // NOTE: onPopinChanged reproduced 1:1 since 2026-07-30: the popinChanged wire is a roundtrip-free client-composed toast 'Number of hidden pop-ins: {0}'` &&
               ` filled by ${$parameters>/hiddenInPopin}.length (the event parameter array's length, exactly the original's aHiddenInPopin.length) - the earlier static 'Pop-in layout changed' round-trip toast faked` &&
               ` the value. The hiddenInPopin event parameter is part of the POST_171-declared popinChanged event (since 1.77).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Table`                           name = `TableAutoPopin`                      class = `z2ui5_cl_ai_app_092` path = `src/01/b11/z2ui5_cl_ai_app_092.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Table.autoPopinMode (since 1.76), Table.popinChanged (since 1.77) and Column.importance (since 1.76), the core of the auto-pop-in demo, are kept 1:1; needs UI5 >= 1.77.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Table`                           name = `TableStrictLayout`                   class = `z2ui5_cl_ai_app_225` path = `src/01/b17/z2ui5_cl_ai_app_225.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16`
        is_post171 = abap_true
        notes = `POST-1.71: sap.m.Table autoPopinMode (since UI5 1.76) kept 1:1 from the original; needs a UI5 release >= 1.76 to render. // POST-1.71: sap.m.plugins.ColumnResizer (since UI5 1.91) kept 1:1 in the` &&
                 ` Table dependents aggregation; needs a UI5 release >= 1.91 to render. The Table fixedLayout='Strict' value is also newer than 1.71 (a value-level extension of the 1.22 property, invisible to the` &&
                 ` property gate; the source JSDoc carries no value-level @since) - covered by the same >= 1.91 floor. // LIVE-TEST: The sorter binding ({path:'/ProductCollection', sorter:{path:'NAME'}}) and the` &&
                 ` sap.ui.model.type.Currency composite binding on Price/CurrencyCode are passed through 1:1 as raw binding-info strings; the sorted order and currency formatting are not yet verified in a running` &&
                 ` system.`
        post171 = `sap.m.Table autoPopinMode (since UI5 1.76) kept 1:1 from the original; needs a UI5 release >= 1.76 to render. // sap.m.plugins.ColumnResizer (since UI5 1.91) kept 1:1 in the Table dependents` &&
                 ` aggregation; needs a UI5 release >= 1.91 to render. The Table fixedLayout='Strict' value is also newer than 1.71 (a value-level extension of the 1.22 property, invisible to the property gate; the` &&
                 ` source JSDoc carries no value-level @since) - covered by the same >= 1.91 floor.` ) ).

    lv_text1 = `IMPROVISED: The original configures a single shared dialog imperatively per button (oButton.data() CustomData ->` &&
               ` setMultiSelect/setDraggable/setResizable/setRememberSelections/setConfirmButtonText/addStyleClass). abap2UI5 binds those SelectDialog properties two-way and each button's handler sets them before` &&
               ` opening (responsivePadding toggles the style class via control_by_id addStyleClass/removeStyleClass). The core:CustomData is kept on the buttons for fidelity; the dialog is declared once in` &&
               ` mvc:dependents and opened via follow_up_action( cs_event-control_by_id, open ). // IMPROVISED: The ObjectNumber weightState is business logic (parseFloat thresholds), so it is computed in ABAP` &&
               ` (WEIGHT_STATE, thin-frontend principle) and bound state='{WEIGHT_STATE}' instead of the frontend Formatter.weightState; core:require is therefore dropped and the Currency binding keeps the full` &&
               ` standard type path 'sap.ui.model.type.Currency' 1:1. The full 123-row /ProductCollection is inlined (ProductPicUrl is not needed — the table cells carry no icon). // NOTE: Search filters the dialog's`.
    lv_text1 = lv_text1 && ` items binding client-side via _event_client( cs_event-binding_call, filter NAME Contains ${$parameters>/value} ). The valueHelpRequest opens a second TableSelectDialog (also in dependents) after` &&
               ` preselecting the row matching the input value. The confirm/valueHelpClose toasts are simplified — selectedContexts / selectedItem are control references not transportable as event args (original` &&
               ` composes the chosen product names / copies the selected title into the input). // LIVE-TEST: The per-button dialog configuration, the client-side search filter, multi-select confirm and the` &&
               ` value-help selection copy-back need an in-system check; machine gates only verify the views are valid. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the` &&
               ` dialog opens with the full 123-row mock and the client-side Contains search filters to 'Gladiator MX'; multi-select confirm and the value-help copy-back remain unexercised. // POST-1.71:` &&
               ` sap.m.TableSelectDialog.searchPlaceholder (since 1.110) is kept 1:1 on the value-help dialog; needs UI5 >= 1.110.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.TableSelectDialog`               name = `TableSelectDialog`                   class = `z2ui5_cl_ai_app_104` path = `src/01/b12/z2ui5_cl_ai_app_104.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.TableSelectDialog.searchPlaceholder (since 1.110) is kept 1:1 on the value-help dialog; needs UI5 >= 1.110.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Text`                            name = `Text`                                class = `z2ui5_cl_ai_app_051` path = `src/01/b01/z2ui5_cl_ai_app_051.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` )
      ( module = `sap.m`              control = `sap.m.TextArea`                        name = `TextArea`                            class = `z2ui5_cl_ai_app_052` path = `src/01/b01/z2ui5_cl_ai_app_052.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.9.0` )
      ( module = `sap.m`              control = `sap.m.TileContent`                     name = `TileContent`                         class = `z2ui5_cl_ai_app_078` path = `src/01/b10/z2ui5_cl_ai_app_078.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34.0` ) ).

    lv_text1 = `NOTE: openTimePicker (byId('HiddenTP').openBy(source.getDomRef())) is the app-016 openBy pattern: the source sId is transported via $event.oSource.sId and replayed as a control_by_id/openBy follow-up` &&
               ` action. // POST-1.71: Button.ariaHasPopup (since 1.84), Link.ariaHasPopup (since 1.86) and TimePicker.hideInput (since 1.97) are kept 1:1; needs a UI5 release providing them. // NOTE: the hidden` &&
               ` TimePicker openBy is wired roundtrip-free via client->_event_client( cs_event-control_by_id, openBy ) on each anchor press ($event.oSource.sId) - the original's byId('HiddenTP').openBy(getDomRef())` &&
               ` 1:1; the change toast is now roundtrip-free too (control_global MESSAGE_TOAST.show), so the app is init-only. // NOTE: the openBy was switched to roundtrip-free _event_client on 2026-07-22 -` &&
               ` re-verify each anchor opens the hidden TimePicker. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the 'Open Time Picker' anchor opens the hidden TimePicker` &&
               ` popover; the remaining anchors are the identical wire. // LIVE-TEST: the change toast was switched to a roundtrip-free client-composed toast on 2026-07-22 (control_global MESSAGE_TOAST.show, template`.
    lv_text1 = lv_text1 && ` ``Time selected: {0}`` filled by ${$parameters>/value}; on_event dropped, init-only) - re-verify picking a time toasts "Time selected: <value>".`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.TimePicker`                      name = `TimePickerHidden`                    class = `z2ui5_cl_ai_app_091` path = `src/01/b11/z2ui5_cl_ai_app_091.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.32`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Button.ariaHasPopup (since 1.84), Link.ariaHasPopup (since 1.86) and TimePicker.hideInput (since 1.97) are kept 1:1; needs a UI5 release providing them.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.TimePickerSliders`               name = `TimePickerSliders`                   class = `z2ui5_cl_ai_app_095` path = `src/01/b12/z2ui5_cl_ai_app_095.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.54`
        notes = `NOTE: The picked time is transported to the backend via a two-way value binding on TimePickerSliders (an extra attribute; the original reads it imperatively with oTP.getValue()). OK composes the` &&
                 ` result text from the current time_value, Cancel restores the pre-open value captured on OPEN_DIALOG (the attachAfterOpen equivalent). // NOTE: The result text uses the static control id 'TPS2'` &&
                 ` because the original's runtime-generated oTP.getId() cannot be reproduced. The cosmetic collapseAll() on the sliders as the dialog closes is dropped (no visible effect on a closing dialog).` )
      ( module = `sap.m`              control = `sap.m.Title`                           name = `TitleLink`                           class = `z2ui5_cl_ai_app_079` path = `src/01/b10/z2ui5_cl_ai_app_079.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.27.0`
        is_post171 = abap_true
        notes = `POST-1.71: the Link nested inside the Title uses the Title content aggregation (since UI5 1.87) - newer than 1.71 but kept for the 1:1 port (the sample's whole point); the app needs a UI5 release >=` &&
                 ` 1.87 to render it. Aggregation-level, invisible to the attribute-scanning property gate.`
        post171 = `the Link nested inside the Title uses the Title content aggregation (since UI5 1.87) - newer than 1.71 but kept for the 1:1 port (the sample's whole point); the app needs a UI5 release >= 1.87 to` &&
                 ` render it. Aggregation-level, invisible to the attribute-scanning property gate.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ToggleButton`                    name = `ToggleButton`                        class = `z2ui5_cl_ai_app_080` path = `src/01/b10/z2ui5_cl_ai_app_080.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: onPress toasts the source control id + Pressed/Unpressed; both arrive via $event.oSource (sId and getPressed()) - the earlier ${$source>/pressed} binding did not resolve at runtime. // NOTE: the` &&
                 ` press toast was switched to a roundtrip-free client-composed toast on 2026-07-22 using the conditional placeholder (control_global MESSAGE_TOAST.show, template ``{0} {1?Pressed:Unpressed}``; on_event` &&
                 ` dropped, init-only) - re-verify pressing a ToggleButton toasts "<id> Pressed" when down and "<id> Unpressed" when up. **e2e-verified 2026-07-30** (transpiled-framework interaction,` &&
                 ` scripts/e2e-smoke.mjs): pressing the 'Pressed' ToggleButton (down -> up) toasts '<id> Unpressed' - the {1?Pressed:Unpressed} conditional placeholder resolves from the toggle state; the other buttons` &&
                 ` are the identical wire.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Tokenizer`                       name = `TokenizerBasic`                      class = `z2ui5_cl_ai_app_085` path = `src/01/b10/z2ui5_cl_ai_app_085.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.22`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-27): verified in a running system 2026-07-27 - Tokenizer add appends, delete removes by key, texts correct`
        notes = `IMPROVISED: the first Tokenizer's tokens are now model-bound (t_tokens): onAddToken appends the input value, onTokenDelete removes by key (the deleted key arrives via` &&
                 ` $event.getParameter('tokens')[0].getKey(); the delete toast shows the token text looked up by that key, like the original's oToken.getText()); the second, disabled Tokenizer keeps its 3 static` &&
                 ` tokens, so the port shows one bound Token template + 3 static Token vs the original's 3+3. // NOTE: the CheckBox select handler becomes a live two-way selected/editable bind on the first Tokenizer.` &&
                 ` // POST-1.71: tokenDelete (since UI5 1.82) on the first Tokenizer is newer than 1.71 but kept for the 1:1 port (the original wires the same event) - the app needs a UI5 release >= 1.82 to render it.`
        post171 = `tokenDelete (since UI5 1.82) on the first Tokenizer is newer than 1.71 but kept for the 1:1 port (the original wires the same event) - the app needs a UI5 release >= 1.82 to render it.` )
      ( module = `sap.m`              control = `sap.m.Toolbar`                         name = `ToolbarShrinkable`                   class = `z2ui5_cl_ai_app_053` path = `src/01/b03/z2ui5_cl_ai_app_053.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `NOTE: the sample's controller onSliderLiveChange resizes the toolbars in JS; there is no width in the source XML (the port adds the width attribute, the original wires liveChange instead). Rebuilt as` &&
                 ` a client-side expression binding {= slider + '%' } on each Toolbar width - no event round-trip, resizes instantly like the original; the documented preferred path (CAPABILITIES.md), not a workaround.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Tree`                            name = `Tree`                                class = `z2ui5_cl_ai_app_054` path = `src/01/b04/z2ui5_cl_ai_app_054.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.42`
        checked = `CHECKED (2026-07-19): verified in a running system - human visual pass 2026-07-19 over all apps: the nested-table hierarchy renders as an expandable Tree like the original.` ) ).

    lv_text1 = `IMPROVISED: Breadth-probe: a minimal sap.m.upload.UploadSet (file upload list) with 3 pre-populated items + a toolbar. The item rows are invented, not the mock's items.json rows ('Business Plan` &&
               ` Agenda.doc' / 'Picture of a woman.png'): Screenshot.png (image/png), Notes.txt (text/plain) and Report.doc (application/msword), each with an empty url and a sap-icon://document /` &&
               ` sap-icon://document-text thumbnailUrl. The actual upload backend, the full toolbar (only 'Upload selected' kept; downloadSelectedButton, versionButton and the upload:UploadSetToolbarPlaceholder` &&
               ` dropped) and the item ObjectMarker/ObjectStatus aggregations are simplified away; upload here would target the abap2UI5 FileUploader path in a live system. // POST-1.71: UploadSet.mode (since UI5` &&
               ` 1.100) and UploadSet.afterItemRemoved (since UI5 1.83) kept for the 1:1 port - surfaced when the property gate gained the sap.m/upload sub-package (control-level source scan 2026-07-26). The whole` &&
               ` control is deprecated out-of-scope debt anyway (pr/scope-since-from-source).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.upload.UploadSet`                name = `UploadSet`                           class = `z2ui5_cl_ai_app_121` path = `src/01/b13/z2ui5_cl_ai_app_121.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.63`
        is_post171 = abap_true
        is_deprecated = abap_true
        dep_text = `Deprecated since 1.129: replaced by sap.m.plugins.UploadSetwithTable`
        notes = lv_text1
        post171 = `UploadSet.mode (since UI5 1.100) and UploadSet.afterItemRemoved (since UI5 1.83) kept for the 1:1 port - surfaced when the property gate gained the sap.m/upload sub-package (control-level source scan` &&
                 ` 2026-07-26). The whole control is deprecated out-of-scope debt anyway (pr/scope-since-from-source).` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.URLHelper`                       name = `UrlHelper`                           class = `z2ui5_cl_ai_app_084` path = `src/01/b10/z2ui5_cl_ai_app_084.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.10`
        checked = `CHECKED (2026-07-27): verified in a running system 2026-07-27 - URLHelper tel/sms/email triggers and REDIRECT all fire correctly`
        notes = `NOTE: element binding kept 1:1 - a one-record structure /S_SUPPLIER instead of {/SupplierCollection/0}. // NOTE: URLHelper.triggerTel/triggerSms/triggerEmail/redirect map 1:1 to the URLHELPER frontend` &&
                 ` action (cs_event-urlhelper): TRIGGER_TEL/TRIGGER_SMS take the number as a plain string param, TRIGGER_EMAIL/REDIRECT take a { EMAIL/URL, ... } object-literal t_arg (get_t_arg emits {-prefixed args` &&
                 ` raw as UI5 event-handler object literals). open_new_tab is NOT used - it is same-origin-only (isValidRedirectURL).` ) ).

    lv_text1 = `NOTE: The three controller-loaded fragments (Dialog / DialogPreselected / DialogPreset) are declared in the view's mvc:dependents aggregation and opened 1:1 via follow_up_action(` &&
               ` cs_event-control_by_id, open [pageKey] ) — the whitelisted ViewSettingsDialog open with the optional page key ('filter'). confirm forwards the public filterString event parameter` &&
               ` (${$parameters>/filterString}) and toasts it when non-empty, like the original handleConfirm. // IMPROVISED: The DialogPreset presetFilterItems are declared as three ViewSettingsItem entries (text +` &&
               ` key) instead of the original _presetFiltersInit which adds them imperatively with sap.ui.model.Filter arrays as CustomData. The Filter payload is inert in this sample (no list is bound — confirm only` &&
               ` shows the filterString), so only the three visible preset filter options are reproduced. This adds 3 ViewSettingsItem over the original fragment count.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ViewSettingsDialog`              name = `ViewSettingsDialog`                  class = `z2ui5_cl_ai_app_098` path = `src/01/b12/z2ui5_cl_ai_app_098.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The sample's default model is a bare JSON array (oModel.setData([...])), bound as the root ({/} on the suggestionItems / items aggregations) and by absolute index (/9/text, /9/key on the second` &&
               ` form). abap2UI5's single default model is an object, so the ten rows live in the T_ITEMS member: {/} becomes {/T_ITEMS} and /9/text / /9/key become /T_ITEMS/9/TEXT / /T_ITEMS/9/KEY. The last path` &&
               ` segment is identical, which structural-diff matches; same data, renders identically. // NOTE: The original applies an app-authored '.whitespace2Char' formatter on every text/additionalText binding -` &&
               ` it replaces each doubled space with space + U+00A0 (non-breaking space) so consecutive whitespaces stay visible. abap2UI5 is a thin frontend, so this presentation transform is computed once in` &&
               ` model_init (REPLACE ALL OCCURRENCES OF two spaces WITH space + nbsp) and the finished text is bound plainly ({TEXT}, {ADDITIONALTEXT}); the 'formatter' key is dropped from the bindings. Output is` &&
               ` identical.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.WhitespacePattern`               name = `WhitespacePattern`                   class = `z2ui5_cl_ai_app_185` path = `src/01/b17/z2ui5_cl_ai_app_185.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        ui5_only = abap_true
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: Step validation (additionalInfoValidation) is reproduced in ABAP: on the ProductName/ProductWeight liveChange (and ProductInfoStep activate) the name-length>=6 / weight-numeric checks set` &&
               ` the two valueStates and the ProductInfoStep validated property, which is bound two-way (step2_validated) instead of the original imperative validateStep/invalidateStep. The other steps keep their` &&
               ` literal validated='true'. // NOTE: The step-1 SegmentedButton gets item keys (Mobile/Desktop/Other) and a two-way selectedKey binding so the chosen product type reaches the model directly; the` &&
               ` original reads evt.getParameters().item.getText() in setProductTypeFromSegmented. selectionChange is still wired. The PricingStep activate/complete handlers (which only toggle the unused` &&
               ` navApiEnabled flag) are wired for fidelity but do nothing. // NOTE: Navigation is 1:1 via follow_up_action( cs_event-control_by_id ): Wizard complete -> NavContainer 'to' the review page; each Edit` &&
               ` link -> 'to' the content page then Wizard 'goToStep' the target step (whitelisted). Cancel and Submit open a MessageBox (warning/confirm) with YES/NO; on YES the wizard resets via 'to' the content`.
    lv_text1 = lv_text1 && ` page + 'discardProgress' ProductTypeStep, matching _handleMessageBoxOpen. // LIVE-TEST: The full wizard flow — step validation gating the Next button, complete/edit navigation, the goToStep scroll` &&
               ` and the cancel/submit reset — needs an in-system check; machine gates only verify the view is valid.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Wizard`                          name = `Wizard`                              class = `z2ui5_cl_ai_app_101` path = `src/01/b12/z2ui5_cl_ai_app_101.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.30`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.ui.core.ContainerPadding`          name = `ContainerNoPadding`                  class = `z2ui5_cl_ai_app_087` path = `src/01/b10/z2ui5_cl_ai_app_087.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: the /ProductCollectionStats/Counts values are flattened to the default model fields /TOTAL, /OK, /HEAVY, /OVERWEIGHT (verbatim counts).` )
      ( module = `sap.m`              control = `sap.ui.core.StandardMargins`           name = `StandardMarginsAll`                  class = `z2ui5_cl_ai_app_088` path = `src/01/b11/z2ui5_cl_ai_app_088.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` ) ).

    lv_text1 = `NOTE: The two toggles the original drives from its controller are now bound and dispatched instead of decorative. onToggleFooter flips DynamicPage.showFooter - the port binds showFooter to a boolean` &&
               ` member (an attribute the original view does not carry: it relies on the property default false and the controller's setter). toggleAreaPriority alternates DynamicPageTitle.areaShrinkRatio between the` &&
               ` property default '1:1.6:1.6' (read from the metadata in the original, verified in sap/f/DynamicPageTitle.js) and '1.6:1:1.6'; the port carries that as an expression binding over a boolean flag, so` &&
               ` the title reflects exactly the same two states. Both Button press wires now reach an on_event dispatcher that flips the flag and calls view_model_update - one backend round-trip per press, the` &&
               ` abap2UI5 equivalent of the controller call. Before this rework both were wired to TOGGLE_PRIO/TOGGLE_FOOTER events this class never dispatched (dead wires, pattern-lint dead-event-wire). // NOTE:` &&
               ` f:DynamicPage with title (heading, expanded/snapped tnt:InfoLabel, actions), pinnable header (ObjectAttributes), content (two long Texts) and footer. The footer message Button binds text and`.
    lv_text1 = lv_text1 && ` visible='{= !!${/MESSAGESLENGTH}}' to a model field (initial 0), reproducing the original {/messagesLength} wiring.`.
    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.f.DynamicPage`                     name = `InfoLabelInDynamicPage`              class = `z2ui5_cl_ai_app_143` path = `src/05/b05/z2ui5_cl_ai_app_143.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.54`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.InfoLabel`                     name = `InfoLabel`                           class = `z2ui5_cl_ai_app_113` path = `src/05/b01/z2ui5_cl_ai_app_113.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.54`
        is_post171 = abap_true
        notes = `NOTE: Ten sap.tnt InfoLabels across color schemes / render modes / icon / displayOnly, in FlexBox rows - a full 1:1 rebuild of the sample view (static, no controller logic). Originally generated as a` &&
                 ` breadth-probe; the 2026-07-27 review fixed the last row's label text ('Any Color Scheme in Display Only Mode' - had been invented as 'Color Scheme 10') and removed the stale structural_diff skip. //` &&
                 ` POST-1.71: sap.tnt.InfoLabel.icon (@since 1.74) is used 1:1 (one InfoLabel carries icon='sap-icon://home-share'). Newer than UI5 1.71; declared per the property-171 policy. Previously undeclared` &&
                 ` because the property gate is blind to sap.tnt; found by the non-sap.m @since audit 2026-07-24.`
        post171 = `sap.tnt.InfoLabel.icon (@since 1.74) is used 1:1 (one InfoLabel carries icon='sap-icon://home-share'). Newer than UI5 1.71; declared per the property-171 policy. Previously undeclared because the` &&
                 ` property gate is blind to sap.tnt; found by the non-sap.m @since audit 2026-07-24.` ) ).

    lv_text1 = `IMPROVISED: the controller's onPopinLayoutChanged (ComboBox change handler running a PopinLayout switch with a Block default) is expressed as bound properties instead of a round-trip (AGENTS 'prefer a` &&
               ` bindable property', as app 009): the ComboBox's change attribute is dropped, its selectedKey is bound two-way, and the Table gains a popinLayout expression binding that reproduces the switch` &&
               ` including its Block default. // NOTE: the original binds the InfoLabel colorScheme via a frontend formatter (Formatter.availableState: an already-classified Status string mapped to a colorScheme` &&
               ` index 8/3/5/9). abap2UI5 being a thin frontend, that mapping is computed in ABAP model_init into a COLOR_SCHEME field and bound colorScheme="{COLOR_SCHEME}" (with path 'Status'), not via a frontend` &&
               ` formatter. Visually 1:1 with the original. // NOTE: the sample's local mock model/data.json (/ProductCollection, 9 rows) is moved verbatim into ABAP model_init on the one default model; all 9 rows` &&
               ` and all bound columns kept. Width/Depth/Height are TYPE string (display-only values in a text template with variable decimals like 3.1/1.8 - packed with fixed DECIMALS would add trailing zeros). Pure`.
    lv_text1 = lv_text1 && ` prefix-drop, renders identically.`.
    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.InfoLabel`                     name = `InfoLabelInTable`                    class = `z2ui5_cl_ai_app_192` path = `src/05/b06/z2ui5_cl_ai_app_192.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.54`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.NavigationList`                name = `NavigationList`                      class = `z2ui5_cl_ai_app_123` path = `src/05/b02/z2ui5_cl_ai_app_123.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        notes = `LIVE-TEST: The two toolbar buttons reproduce the original controller behaviour server-side: 'Toggle Collapse/Expand' flips NavigationList.expanded (bound to a boolean model field), 'Show/Hide SubItem` &&
                 ` 3' flips subItemThree.visible. The original used byId().setExpanded/setVisible; here the properties are two-way bound and toggled on a backend round-trip. The 'expanded' attribute on NavigationList` &&
                 ` and the 'visible' attribute on subItemThree are added to carry these bindings (the original set them imperatively).` ) ).

    lv_text1 = `LIVE-TEST: The two buttons reproduce the controller behaviour server-side: 'Toggle Collapse/Expand' flips SideNavigation.expanded (bound to a boolean model field, initial false as in the original) and` &&
               ` 'Show/Hide "Walked"' flips the 'walked' NavigationListItem.visible. The original used byId().setExpanded/setVisible; here the properties are two-way bound and toggled on a backend round-trip. The` &&
               ` 'visible' attribute added to the walked item carries that binding (the original toggled it imperatively). **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the` &&
               ` 'Toggle Collapse/Expand' round-trip flips the two-way bound expanded (the sapTntSideNavigationNotExpanded class disappears); the 'Show/Hide Walked' visible flip is the same two-way idiom but not` &&
               ` exercised. // POST-1.71: NavigationListItem.selectable (@since 1.116) is kept 1:1 from the original (selectable=false on the two 'External Link' fixedItem entries). Newer than UI5 1.71; declared per` &&
               ` the property-171 policy. Was previously undeclared because the property gate is blind to sap.tnt (properties.json holds sap.m only); found and corrected by the app-172 cold-read probe 2026-07-24. //`.
    lv_text1 = lv_text1 && ` POST-1.71: sap.tnt.NavigationListGroup (control @since 1.121) is used 1:1 for the 'New', 'Recently used' and 'Restricted' groups. Newer than UI5 1.71; declared per the property-171 policy` &&
               ` (control-level, app 152 Avatar precedent - the gate only checks members), so the app needs UI5 >= 1.121 to render the groups. Found by the 2026-07-27 review sweep.`.
    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.SideNavigation`                name = `SideNavigation`                      class = `z2ui5_cl_ai_app_128` path = `src/05/b02/z2ui5_cl_ai_app_128.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `NavigationListItem.selectable (@since 1.116) is kept 1:1 from the original (selectable=false on the two 'External Link' fixedItem entries). Newer than UI5 1.71; declared per the property-171 policy.` &&
                 ` Was previously undeclared because the property gate is blind to sap.tnt (properties.json holds sap.m only); found and corrected by the app-172 cold-read probe 2026-07-24. //` &&
                 ` sap.tnt.NavigationListGroup (control @since 1.121) is used 1:1 for the 'New', 'Recently used' and 'Restricted' groups. Newer than UI5 1.71; declared per the property-171 policy (control-level, app` &&
                 ` 152 Avatar precedent - the gate only checks members), so the app needs UI5 >= 1.121 to render the groups. Found by the 2026-07-27 review sweep.` ) ).

    lv_text1 = `POST-1.71: NavigationListItemBase.press event (@since 1.133) is the whole point of this sample; wired 1:1 on every NavigationListItem (press) to a backend ITEM_PRESS event. @since verified in` &&
               ` fork-openui5/src/sap.tnt/src/sap/tnt/NavigationListItemBase.js:74-79. Requires a UI5 release >= 1.133. // POST-1.71: The press event parameters ctrlKey/shiftKey/altKey/metaKey (@since 1.137) are` &&
               ` transported via ${$parameters>/ctrlKey} etc. in the ITEM_PRESS t_arg and echoed into the toast, exactly as the original itemPress reads them. @since verified NavigationListItemBase.js:88-109.` &&
               ` Requires a UI5 release >= 1.137 (the property gate is blind to sap.tnt event params). // POST-1.71: NavigationListItem.selectable (@since 1.116) is used 1:1 (selectable=false) on Link 1/Link 2, Quick` &&
               ` Create and External Link. @since verified NavigationListItem.js:101-103. // POST-1.71: NavigationListItem.design="Action" and NavigationListItem.ariaHasPopup="Dialog" (both @since 1.133.0) are kept` &&
               ` 1:1 on the Quick Create item. @since verified NavigationListItem.js:131-139. // NOTE: itemPress preventDefault reproduced 1:1 since 2026-07-30: every NavigationListItem press wire carries`.
    lv_text1 = lv_text1 && ` s_ctrl-check_prevent_default = prevent_default, so when the 'preventDefaultCheckbox' is selected the handler cancels the item's built-in default client-side (oEvent.preventDefault() before the` &&
               ` round-trip - selection stays, href navigation is suppressed) exactly like the original. The flag is baked into the handler expression at render time, so the CheckBox got an added select wire` &&
               ` (PREVENT_TOGGLE, declared) that redraws the view when toggled; the redraw resets the client-side selection back to selectedKey='walked' - a small toggle-time caveat the original (which never redraws)` &&
               ` does not have. The checkbox state stays two-way bound (selected={/PREVENT_DEFAULT}); the toast heading ('Default was prevented:' vs 'Item Pressed:') is composed server-side from the same flag. //` &&
               ` IMPROVISED: quickActionPress dialog: reproduced as a core:FragmentDefinition shown via client->popup_display - the controller-built sap.m.Dialog with two Label + Input pairs (Name/Icon, the Inputs` &&
               ` two-way bound to create_name/create_icon) and Create/Cancel Buttons. These Dialog/Label/Input/Button controls are extra vs the original view.xml, which declared none of them (the original built the`.
    lv_text1 = lv_text1 && ` Dialog imperatively in the controller). The original Create button imperatively does sideNavigation.getItem().addItem(new NavigationListItem(...)); dynamic addItem to the statically declared` &&
               ` NavigationList is not expressible (it would require folding the 1:1 static items into a bound aggregation), so CREATE_ITEM reads the entered values and shows a toast instead of adding the item. The` &&
               ` .quickActionPress handler is rewired to the QUICK_CREATE backend event. // LIVE-TEST: The 2026-07-27 live check predates the 2026-07-30 prevent-default rewire (status reset checked -> generated per` &&
               ` the invalidation rule): re-verify that with the checkbox set a press does NOT change the selection (eBP cancels the default) and still toasts 'Default was prevented:', that with the checkbox clear` &&
               ` selection changes normally, and that the PREVENT_TOGGLE redraw keeps working (expanded state and checkbox survive it via their two-way bindings). onCollapseExpandPress (expanded two-way +` &&
               ` TOGGLE_EXPAND round-trip), the ITEM_PRESS modifier-key transport and the popup round-trips were live-verified 2026-07-27. **e2e-verified 2026-07-30** (transpiled-framework interaction,`.
    lv_text1 = lv_text1 && ` scripts/e2e-smoke.mjs): with the checkbox set, the PREVENT_TOGGLE redraw re-bakes the wires and pressing 'Building' toasts 'Default was prevented:' - the eBP wire fires and round-trips; the visual` &&
               ` no-selection-change and the popup paths remain for the live check.`.
    lv_text2 = `NavigationListItemBase.press event (@since 1.133) is the whole point of this sample; wired 1:1 on every NavigationListItem (press) to a backend ITEM_PRESS event. @since verified in` &&
               ` fork-openui5/src/sap.tnt/src/sap/tnt/NavigationListItemBase.js:74-79. Requires a UI5 release >= 1.133. // The press event parameters ctrlKey/shiftKey/altKey/metaKey (@since 1.137) are transported via` &&
               ` ${$parameters>/ctrlKey} etc. in the ITEM_PRESS t_arg and echoed into the toast, exactly as the original itemPress reads them. @since verified NavigationListItemBase.js:88-109. Requires a UI5 release` &&
               ` >= 1.137 (the property gate is blind to sap.tnt event params). // NavigationListItem.selectable (@since 1.116) is used 1:1 (selectable=false) on Link 1/Link 2, Quick Create and External Link. @since` &&
               ` verified NavigationListItem.js:101-103. // NavigationListItem.design="Action" and NavigationListItem.ariaHasPopup="Dialog" (both @since 1.133.0) are kept 1:1 on the Quick Create item. @since verified` &&
               ` NavigationListItem.js:131-139.`.
    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.SideNavigation`                name = `SideNavigationPressEvent`            class = `z2ui5_cl_ai_app_241` path = `src/05/b07/z2ui5_cl_ai_app_241.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.34`
        is_post171 = abap_true
        notes = lv_text1
        post171 = lv_text2 ) ).

    lv_text1 = `POST-1.71: sap.tnt.NavigationListItem.selectable (@since 1.116) is used 1:1 on the unselectable parent items (Building/Mileage/Transport) and the fixed External Link item - it is the whole point of` &&
               ` this sample. Kept per the members-newer-than-1.71 fidelity policy; @since verified by hand against fork-openui5/src/sap.tnt/src/sap/tnt/NavigationListItem.js line 101-103 (property gate is blind to` &&
               ` sap.tnt). Requires a UI5 release >= 1.116 to render. // LIVE-TEST: onCollapseExpandPress reproduced server-side: SideNavigation.expanded is two-way bound (initial false as in the original` &&
               ` expanded="false") and flipped on a backend round-trip (TOGGLE_EXPAND) instead of the original imperative byId().setExpanded(!expanded). Same technique as app 128. The literal expanded="false"` &&
               ` becoming a {/EXPANDED} binding needs a live render check. // LIVE-TEST: onItemSelect reproduced roundtrip-free: the SideNavigation itemSelect event fires a client-composed MessageToast` &&
               ` (control_global MESSAGE_TOAST/show, template 'Item selected: {0}' filled by the client-resolved ${$parameters>/item}.getText()) - the 1:1 equivalent of the original MessageToast.show(``Item selected:`.
    lv_text1 = lv_text1 && ` ${sText}``). Same idiom as app 060; CAPABILITIES marks it expressible, live render/click check pending.`.
    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.SideNavigation`                name = `SideNavigationUnselectableParents`   class = `z2ui5_cl_ai_app_172` path = `src/05/b06/z2ui5_cl_ai_app_172.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.tnt.NavigationListItem.selectable (@since 1.116) is used 1:1 on the unselectable parent items (Building/Mileage/Transport) and the fixed External Link item - it is the whole point of this sample.` &&
                 ` Kept per the members-newer-than-1.71 fidelity policy; @since verified by hand against fork-openui5/src/sap.tnt/src/sap/tnt/NavigationListItem.js line 101-103 (property gate is blind to sap.tnt).` &&
                 ` Requires a UI5 release >= 1.116 to render.` ) ).

    lv_text1 = `NOTE: The 'Toggle Collapse/Expand' button flips SideNavigation.expanded (bound to a boolean model field, initial true as in the original). The original toggled it imperatively via byId().setExpanded;` &&
               ` the property is two-way bound here and toggled on a backend round-trip. Every tnt:tag ObjectStatus (IndicationColor states 15-20, inverted) and the NavigationListGroup / fixedItem structure are` &&
               ` reproduced 1:1. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the Toggle Collapse/Expand round-trip collapses the two-way bound SideNavigation (the` &&
               ` NotExpanded class appears). // POST-1.71: Two sap.tnt.NavigationListItem members newer than UI5 1.71 are kept 1:1: selectable (@since 1.116, selectable=false on the Favorites parent item) and the tag` &&
               ` aggregation (@since 1.149, a sap.m.ObjectStatus per item, used 8x). Declared per the property-171 policy. Previously undeclared because the property gate is blind to sap.tnt (properties.json holds` &&
               ` sap.m only); selectable found by the app-172 cold-read probe and tag by the non-sap.m @since audit, 2026-07-24. // POST-1.71: Kept 1:1 but newer than UI5 1.71 and invisible to the property gate:`.
    lv_text1 = lv_text1 && ` sap.tnt.NavigationListGroup (control @since 1.121, the 'Business Operations' group); NavigationListItem.expanded (expanded=true on the Favorites and Projects items - reads as @since 1.121 because the` &&
               ` property was relocated to the newer base class NavigationListItemBase, the property itself predates 1.71, declared per the relocated-member note); and the IndicationColor enum values Indication15,` &&
               ` Indication16, Indication17, Indication18, Indication19, Indication20 (@since 1.120) carried by all 8 ObjectStatus tag states (enum values are invisible at the attribute-name level). The app needs UI5` &&
               ` >= 1.121 to render groups and tags. Found by the 2026-07-27 review sweep.`.
    lv_text2 = `Two sap.tnt.NavigationListItem members newer than UI5 1.71 are kept 1:1: selectable (@since 1.116, selectable=false on the Favorites parent item) and the tag aggregation (@since 1.149, a` &&
               ` sap.m.ObjectStatus per item, used 8x). Declared per the property-171 policy. Previously undeclared because the property gate is blind to sap.tnt (properties.json holds sap.m only); selectable found` &&
               ` by the app-172 cold-read probe and tag by the non-sap.m @since audit, 2026-07-24. // Kept 1:1 but newer than UI5 1.71 and invisible to the property gate: sap.tnt.NavigationListGroup (control @since` &&
               ` 1.121, the 'Business Operations' group); NavigationListItem.expanded (expanded=true on the Favorites and Projects items - reads as @since 1.121 because the property was relocated to the newer base` &&
               ` class NavigationListItemBase, the property itself predates 1.71, declared per the relocated-member note); and the IndicationColor enum values Indication15, Indication16, Indication17, Indication18,` &&
               ` Indication19, Indication20 (@since 1.120) carried by all 8 ObjectStatus tag states (enum values are invisible at the attribute-name level). The app needs UI5 >= 1.121 to render groups and tags. Found`.
    lv_text2 = lv_text2 && ` by the 2026-07-27 review sweep.`.
    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.SideNavigation`                name = `SideNavigationWithTags`              class = `z2ui5_cl_ai_app_132` path = `src/05/b03/z2ui5_cl_ai_app_132.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        is_post171 = abap_true
        notes = lv_text1
        post171 = lv_text2 ) ).

    lv_text1 = `LIVE-TEST: The SAP-logo Image and profile Avatar presses show client-side MessageToasts ('Logo pressed!' / 'Avatar pressed!'), matching the original onLogoPressed / onAvatarPressed. The original's` &&
               ` Device.media handler (which toggles productName/secondTitle/searchField/searchButton visibility per screen range) is a device-responsive behaviour not reproduced server-side; those controls keep` &&
               ` their static initial visibility (searchButton visible='false'). **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the logo Image press toasts 'Logo pressed!'; the` &&
               ` Avatar press is the identical wire but not exercised, and the Device.media visibility branch stays out of scope. // NOTE: Both ToolHeaders, all OverflowToolbarLayoutData priorities/groups, the` &&
               ` ToolHeaderUtilitySeparator and the OverflowToolbarButtons are reproduced 1:1, including the original's Cyrillic-o typo in 'Prоduct Name'. The SAP_Logo.png and Woman_avatar_01.png srcs are the` &&
               ` original's host-relative test-resources/sap/tnt/images/ paths rewritten to the OpenUI5 host https://sdk.openui5.org/test-resources/sap/tnt/images/ per the runtime asset-URL rule (app 152 precedent).`.
    lv_text1 = lv_text1 && ` // POST-1.71: sap.m.Avatar (control @since 1.73) is used 1:1 as the profile avatar in both ToolHeaders (src image, displaySize XS, press). Newer than UI5 1.71; declared per the property-171 policy` &&
               ` (control-level, app 152 precedent), so the app needs UI5 >= 1.73 to render the avatars. Found by the 2026-07-27 review sweep.`.
    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.ToolHeader`                    name = `ToolHeader`                          class = `z2ui5_cl_ai_app_134` path = `src/05/b04/z2ui5_cl_ai_app_134.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.Avatar (control @since 1.73) is used 1:1 as the profile avatar in both ToolHeaders (src image, displaySize XS, press). Newer than UI5 1.71; declared per the property-171 policy (control-level,` &&
                 ` app 152 precedent), so the app needs UI5 >= 1.73 to render the avatars. Found by the 2026-07-27 review sweep.` ) ).

    lv_text1 = `IMPROVISED: The three home Buttons drop their press=onHomePress handler: the original imperatively resets the sibling IconTabHeader selectedKey to 'invalidKey' (deselecting all tabs) by reaching into` &&
               ` the DOM (event.oSource.getParent().getDomRef()...). Review correction 2026-07-27: the earlier rationale (no bindable equivalent for the DOM-walk reset) is WRONG - the DOM walk only locates the` &&
               ` sibling IconTabHeader, which each home Button resolves statically (iconTabHeader / iconTabHeaderOneClickArea / iconTabHeaderTwoClickArea), and the reset is expressible either as a two-way bound` &&
               ` selectedKey reset from an event handler or roundtrip-free via _event_client control_by_id with the unlisted-but-allowed public setter setSelectedKey (FrontendAction.js deny-regex, source-verified).` &&
               ` The press attributes remain dropped for now - open rework before promotion; the IconTabHeaders keep their static selectedKey='invalidKey'. // POST-1.71: IconTabFilter` &&
               ` interactionMode='SelectLeavesOnly' (property since 1.121) is kept 1:1 on the parent filters of the second ToolHeader's IconTabHeader (iconTabHeaderOneClickArea); requires a UI5 release >= 1.121. //`.
    lv_text1 = lv_text1 && ` POST-1.71: IconTabFilter items (the nested sub-filter aggregation, since 1.77 per IconTabFilter.js JSDoc) is kept 1:1 in the second and third ToolHeaders' IconTabHeaders (nested` &&
               ` User/Identity/Monitoring filters); requires a UI5 release >= 1.77. Aggregation-level member, invisible to the property gate (it scans attributes only) - declared by policy, found in review` &&
               ` 2026-07-27. // NOTE: Fully static view reproduced 1:1: three tnt:ToolHeaders, each with a home Button, an IconTabHeader (mode='Inline', backgroundDesign='Transparent', selectedKey='invalidKey') with` &&
               ` OverflowToolbarLayoutData, search/comment Buttons and a MenuButton with a Menu (Edit/Save). The second/third ToolHeaders use nested IconTabFilter items; no bound data.`.
    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.ToolHeader`                    name = `ToolHeaderIconTabHeader`             class = `z2ui5_cl_ai_app_221` path = `src/05/b06/z2ui5_cl_ai_app_221.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `IconTabFilter interactionMode='SelectLeavesOnly' (property since 1.121) is kept 1:1 on the parent filters of the second ToolHeader's IconTabHeader (iconTabHeaderOneClickArea); requires a UI5 release` &&
                 ` >= 1.121. // IconTabFilter items (the nested sub-filter aggregation, since 1.77 per IconTabFilter.js JSDoc) is kept 1:1 in the second and third ToolHeaders' IconTabHeaders (nested` &&
                 ` User/Identity/Monitoring filters); requires a UI5 release >= 1.77. Aggregation-level member, invisible to the property gate (it scans attributes only) - declared by policy, found in review` &&
                 ` 2026-07-27.` ) ).

    lv_text1 = `IMPROVISED: NavigationListItem.selectable is the expression binding {= ${items}.length > 3} in the original; per the thin-frontend rule that presentation logic is computed in ABAP into a flat` &&
               ` 'selectable' field (children count > 3) and bound directly. The controller event handlers (onSideNavButtonPress toggling the side, onItemPress, onItemSelect navigating the NavContainer via to(),` &&
               ` handleUserNamePress opening a popover, fixed-item quickActionPress opening a Create Item Dialog) are each replaced by a STATIC-text client MESSAGE_TOAST; the NavContainer shows its initialPage` &&
               ` (page2) but page-to-page navigation is not wired. Review 2026-07-27: these substitutions under-deliver against CAPABILITIES - onItemPress could transport the item text client-side (control_global` &&
               ` toast template + ${$parameters>/item}.getText(), app 060/172 idiom), the side toggle could two-way bind ToolPage.sideExpanded (prefer-a-bindable-property rule), and itemSelect->to() is expressible` &&
               ` via control_by_id 'to' (CONTROL_METHODS to: controlId+transition, client-resolved key) - flagged for rework, not promoted. // POST-1.71: Several members newer than UI5 1.71 are kept 1:1 from the`.
    lv_text1 = lv_text1 && ` original. sap.tnt.NavigationListItem: selectable (@since 1.116), design (@since 1.133.0, sap.tnt.NavigationListItemDesign), press (event, @since 1.133 on NavigationListItemBase), ariaHasPopup (@since` &&
               ` 1.133.0). sap.m.Button.ariaHasPopup (@since 1.84) on the header 'Alan Smith' button. Declared per the property-171 policy; the tnt members were previously mis/under-declared (the earlier note cited` &&
               ` only sap.m.Button 1.84 for ariaHasPopup, which is the Button version, not the tnt member's 1.133) because the property gate is blind to sap.tnt - corrected by the non-sap.m @since audit 2026-07-24.` &&
               ` NavigationListItem.expanded is also kept 1:1; its @since reads 1.121 because the property was relocated to the new sap.tnt.NavigationListItemBase in 1.121 (the property itself predates 1.71), but the` &&
               ` property gate resolves the base-class version, so it is declared here for the gate. // NOTE: The full 14-item navigation tree (with its nested child lists, incl. Root Item 3's 38 children) and the` &&
               ` 4-item fixed navigation are inlined from data.json. Where data.json omits a property the UI5 default is seeded explicitly (enabled true, expanded false, and on Fixed Item 1-3 the enum fields`.
    lv_text1 = lv_text1 && ` ariaHasPopup None / design Default - an empty string would throw in validateProperty). The page2 ScrollContainer's multi-paragraph lorem-ipsum filler text is abbreviated to a short placeholder. //` &&
               ` NOTE: Faked-event-value audit fix (2026-07-30): four substituted handlers are now the original behaviours. onItemPress: client-composed toast 'Fired itemPress, item: {0}' filled by` &&
               ` ${$parameters>/item}.getText() (was the static 'Item pressed'). onItemSelect: pageContainer.to(item key page) via roundtrip-free _event_client control_by_id 'to' with ${$parameters>/item}.getKey()` &&
               ` (was a static toast; a key without a matching page logs a NavContainer error client-side exactly like the original's createId miss). onSideNavButtonPress: ToolPage.sideExpanded is two-way bound` &&
               ` (added attr, declared) and flipped on the SIDE_TOGGLE round-trip; the button's tooltip is bound (added attr, declared) and set from the PRE-toggle state ('Large/Small Size Navigation') exactly like` &&
               ` _setToggleButtonTooltip; init seeds the desktop default 'Small Size Navigation' (the Device.system.desktop branch resolved statically). handleUserNamePress: the controller-built Popover (showHeader`.
    lv_text1 = lv_text1 && ` false, Bottom, Feedback/Help/Logout transparent buttons, sapMOTAPopover sapTntToolHeaderPopover classes) is rebuilt 1:1 via popover_display by_id = $event.oSource.sId - Popover + 3 Buttons are extra` &&
               ` controls vs the original view.xml (controller-built). onQuickActionPress: the design guard runs server-side on the transported ${$source>/design} and a design=Action item opens the 'Create Item'` &&
               ` Message Dialog (Text 'Create New Navigation List Item', Create/Cancel closing via popup_close) via popup_display - Dialog/Text/Button extra controls declared here too. **e2e-verified 2026-07-30**` &&
               ` (transpiled-framework interaction, scripts/e2e-smoke.mjs): Child Item 1 press toasts 'Fired itemPress, item: Child Item 1' and the Alan Smith press opens the Feedback/Help/Logout popover; the side` &&
               ` toggle, key navigation target and Quick Create dialog remain unexercised.`.
    lv_text2 = `Several members newer than UI5 1.71 are kept 1:1 from the original. sap.tnt.NavigationListItem: selectable (@since 1.116), design (@since 1.133.0, sap.tnt.NavigationListItemDesign), press (event,` &&
               ` @since 1.133 on NavigationListItemBase), ariaHasPopup (@since 1.133.0). sap.m.Button.ariaHasPopup (@since 1.84) on the header 'Alan Smith' button. Declared per the property-171 policy; the tnt` &&
               ` members were previously mis/under-declared (the earlier note cited only sap.m.Button 1.84 for ariaHasPopup, which is the Button version, not the tnt member's 1.133) because the property gate is blind` &&
               ` to sap.tnt - corrected by the non-sap.m @since audit 2026-07-24. NavigationListItem.expanded is also kept 1:1; its @since reads 1.121 because the property was relocated to the new` &&
               ` sap.tnt.NavigationListItemBase in 1.121 (the property itself predates 1.71), but the property gate resolves the base-class version, so it is declared here for the gate.`.
    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.ToolPage`                      name = `ToolPage`                            class = `z2ui5_cl_ai_app_167` path = `src/05/b06/z2ui5_cl_ai_app_167.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.34`
        is_post171 = abap_true
        notes = lv_text1
        post171 = lv_text2 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.codeeditor`  control = `sap.ui.codeeditor.CodeEditor`          name = `CodeEditor`                          class = `z2ui5_cl_ai_app_114` path = `src/02/b01/z2ui5_cl_ai_app_114.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.46`
        notes = `IMPROVISED: Breadth-probe: the ACE-based sap.ui.codeeditor CodeEditor (a wrapped third-party editor). The value literal is shortened to 4 of the original's 12 language entries (against the` &&
                 ` verbatim-data rule) - a loss, retyped from NOTE at the 2026-07-27 review. Escaping concern found at the same review: the original view.xml carries the value's literal braces backslash-escaped` &&
                 ` (value='\{...'), but the port builds the value in a |...| template whose \{ collapses to a raw brace, so the serialized attribute starts with an unescaped { that the XMLView binding parser will read` &&
                 ` as a binding-info object - needs the surviving-backslash form (\\\{ in the template, or a backtick literal) plus a live/render verification. Needs rework.` ) ).

    lv_text1 = `NOTE: The original's onSelectTab swaps the CodeEditor value per selected key imperatively (A -> example2, B -> example1, any other key -> setValue() i.e. empty) and its onInit seeds the hint '//` &&
               ` select tabs to see value of CodeEditor changing'. Rebuilt on the client with no round-trip: selectedKey is two-way bound to selected_key (seeded with the original's literal 'invalidKey') and the` &&
               ` CodeEditor carries a value expression binding that is the same switch - selected_key === 'A' ? code_a : (selected_key === 'B' ? code_b : code_init). Two consequences for the view: the select` &&
               ` attribute is dropped (it was wired to a SELECT_TAB backend event no branch of this class dispatched - a dead wire, pattern-lint dead-event-wire), and a value attribute is added to ce:CodeEditor,` &&
               ` which the original XML does not carry because its controller sets the value. The original's unreachable default branch (a key that is neither A nor B can only be the initial 'invalidKey') therefore` &&
               ` shows the init hint rather than an empty editor; the two example strings are inlined verbatim, including the original's own A/B swap.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.codeeditor`  control = `sap.ui.codeeditor.CodeEditor`          name = `CodeEditorIconTabHeader`             class = `z2ui5_cl_ai_app_150` path = `src/02/b08/z2ui5_cl_ai_app_150.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.46`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: Since 2026-07-30 the global sap.ui.core.BusyIndicator behaviour is reproduced 1:1: each button fires a backend event whose response chains follow_up_action( control_global BUSY_INDICATOR show` &&
               ` [delay] ) with the original's delay (default / 0 / 2000) plus follow_up_action( start_timer HIDE_BUSY duration ) (4000 / 4000 / 1000); the HIDE_BUSY timer round-trip then issues BUSY_INDICATOR hide -` &&
               ` the frontend-action form of showBusyIndicator(iDuration, iDelay) + setTimeout(hideBusyIndicator). START_TIMER's single-slot semantics (a new timer replaces the pending one) match the original's` &&
               ` clearTimeout of _sTimeoutId. Timing nuance: the hide fires after duration + one round-trip latency, and the show after the press round-trip - a few ms later than the original's purely client-side` &&
               ` call; the press attributes are rewired from the controller handler names to backend events (the earlier MessageToast substitution is gone). // NOTE: the BUSY_INDICATOR show/hide chain and the` &&
               ` START_TIMER HIDE_BUSY round-trips are unverified in a running system - verify the overlay appears (default and zero delay), disappears after ~4s, and never appears in the 2s-delay/1s-duration case.`.
    lv_text1 = lv_text1 && ` **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the zero-delay button shows the global overlay (#sapUiBusyIndicator) and the HIDE_BUSY timer round-trip removes` &&
               ` it after ~4s; the default-delay and 2s-delay/1s-duration buttons are the identical wire with different literals.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.core.BusyIndicator`             name = `BusyIndicator`                       class = `z2ui5_cl_ai_app_147` path = `src/02/b07/z2ui5_cl_ai_app_147.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: The three core:CommandExecution controls (CE_SAVE, CE_DELETE in the Page dependents, CE_SAVE_POPOVER in the popoverCommand dependents) are DROPPED as controls - abap2UI5 renders no` &&
               ` CommandExecution element. Their behaviour IS reproduced since 2026-07-30: the manifest shortcuts Save=Ctrl+S / Delete=Ctrl+D are registered on init via cs_event-keyboard_shortcut (follow_up_action,` &&
               ` combo -> named backend event), and every command-triggering button (press='cmd:Save' / press='cmd:Delete') fires the same backend SAVE/DELETE/PSAVE events, so shortcut and button share one command` &&
               ` path like the original command bus; the backend gates each command on its enabled/visible flags, so a disabled command's button press or shortcut does nothing, as with a disabled CommandExecution.` &&
               ` Residual loss: the shortcut registry is document-global - the original's popover-local command scope (CE_SAVE_POPOVER overriding Save while popoverCommand is open) is not reproduced; Ctrl+S always` &&
               ` triggers the page-level Save command. // IMPROVISED: The $cmd> command model bindings enabled='{$cmd>Save/enabled}' / enabled='{$cmd>Delete/enabled}' on the popover footer buttons have no command`.
    lv_text1 = lv_text1 && ` model to bind to (CommandExecution dropped), so they are folded to default-model booleans: the popover buttons bind enabled to {/SAVE_ENABLED}/{/DELETE_ENABLED} (page popover) and` &&
               ` {/PSAVE_ENABLED}/{/DELETE_ENABLED} (command popover). Correspondingly the controller's onToggleSave/onToggleDelete/onTogglePopoverSave (byId('CE_SAVE').setEnabled(state)) and the *Visibility variants` &&
               ` (setVisible) are reproduced as two-way bindings: each Switch state is bound two-way to the matching boolean and the popover buttons additionally bind visible to` &&
               ` {/SAVE_VISIBLE}/{/DELETE_VISIBLE}/{/PSAVE_VISIBLE}, so the switches drive the command-buttons client-side with no round-trip. Consequently the Switch change attributes (change='.onToggleSave' etc., 6` &&
               ` of them) are DROPPED and replaced by the two-way state binding; the enabled binding value differs from the original $cmd> path. The flags travel with the next event's two-way model update, which is` &&
               ` how the server-side command gating reads the current switch state. // NOTE: The manifest-declared viewModel named JSON model (bindings {viewModel>/value}, {viewModel>/countries},`.
    lv_text1 = lv_text1 && ` {viewModel>/selected}, {viewModel>key}, {viewModel>text}) is folded onto the one default model as value/t_countries/selected with the same leaf names and the controller's addData seed values` &&
               ` (HelloWorld!, DZ Algeria / AR Argentina) - a pure prefix-drop, renders identically, structural-diff 0 diffs. // POST-1.71: sap.m.Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for` &&
               ` the 1:1 port - the two Open-Popover buttons carry ariaHasPopup='Dialog' as in the original; the app needs a UI5 release >= 1.84 to render it. // LIVE-TEST: unverified in a running system: (a) the two` &&
               ` Open-Popover buttons open the popover anchored to the button via control_by_id openBy ($event.oSource.sId); (b) the Ctrl+S / Ctrl+D keyboard_shortcut registrations firing the backend SAVE/DELETE` &&
               ` round-trips and their enabled/visible server-side gating; (c) the switch-driven two-way enabled/visible of the popover buttons. The e2e interaction (keyboard Ctrl+S -> save toast) covers (b) for the` &&
               ` page-level Save. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): Ctrl+S fires the SAVE round-trip and toasts 'CTRL+S: save triggered on controller'.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.core.CommandExecution`          name = `Commands`                            class = `z2ui5_cl_ai_app_232` path = `src/02/b10/z2ui5_cl_ai_app_232.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.70`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the two Open-Popover buttons carry ariaHasPopup='Dialog' as in the original; the app needs a UI5 release >=` &&
                 ` 1.84 to render it.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.core.Control`                   name = `ControlBusyIndicator`                class = `z2ui5_cl_ai_app_130` path = `src/02/b03/z2ui5_cl_ai_app_130.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: The 'Toggle Busy State' button flips a boolean model field bound to Panel1.busy and the Icon.busy (both added to carry the binding; the original set busy imperatively via byId().setBusy). The` &&
                 ` original set both busy=true then cleared them after a 5s setTimeout; the client-side auto-reset is simplified to a server-side toggle. **e2e-verified 2026-07-30** (transpiled-framework interaction,` &&
                 ` scripts/e2e-smoke.mjs): the toggle round-trip turns the bound controls busy (sapUiLocalBusy present after the click).` )
      ( module = `sap.ui.core`        control = `sap.ui.core.HTML`                      name = `Html`                                class = `z2ui5_cl_ai_app_120` path = `src/02/b01/z2ui5_cl_ai_app_120.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: Raw HTML injected via the sap.ui.core.HTML content attribute, written as decoded markup (the builder xml-escapes it into the attribute value; the original view.xml carries it entity-encoded).` &&
                 ` The 2026-07-27 review restored the full Lorem-ipsum text 1:1 (had been shortened by the original breadth-probe), so the sample's root Html.view.xml is now rebuilt fully.` ) ).

    lv_text1 = `NOTE: The original's onSliderMoved sets the three Panel widths imperatively (setWidth(value + "%")). Rebuilt 1:1 on the client, the thin-frontend way (same shape as the checked app 053): the Slider` &&
               ` value is two-way bound to slider_value (seeded 100, the original's literal) and each Panel width carries the expression binding {= slider_value + '%' } instead of the literal 100%. The liveChange` &&
               ` attribute is therefore dropped - no backend round-trip fires while dragging, and the resize behaves as in the original. Before this rework the liveChange was wired to a SLIDER backend event the class` &&
               ` never dispatched (dead wire, pattern-lint dead-event-wire). // IMPROVISED: The three core:HTML panels stay empty. The original controller fills them from sap/ui/core/hyphenation/Hyphenation - it` &&
               ` awaits hyph.initialize() per language and then writes the hyphenated text into each HTML control. That is an asynchronous client-side API with a promise chain and no declarative form: it is neither a` &&
               ` binding nor one of the whitelisted control methods, and the hyphenation itself cannot be done on the ABAP side (the algorithm and its language dictionaries live in the browser). The port therefore`.
    lv_text1 = lv_text1 && ` keeps the view 1:1 with the original XML, which also carries content="" on all three, and loses the sample's actual payload - the visible hyphenated text. This is the sample's whole point, so the` &&
               ` port is a structural port only.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.core.hyphenation.Hyphenation`   name = `HyphenationAPI`                      class = `z2ui5_cl_ai_app_146` path = `src/02/b07/z2ui5_cl_ai_app_146.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The sample's style.css is now shipped with the port: it is injected through a core:HTML leaf carrying a <style> block (the documented CAPABILITIES form, as in apps 026/028), so the port adds one` &&
               ` core:HTML control the original view does not have - the original loads the stylesheet through its manifest's sap.ui5/resources/css entry instead. The five size classes and the <600px media query are` &&
               ` verbatim, only whitespace-collapsed; literal braces are escaped \{ \} in a backtick literal because the XMLView parser reads an unescaped brace as a binding. Until 2026-07-28 the port carried the` &&
               ` size1..size5 class names with no stylesheet behind them, so every Icon rendered at the default size - the sample is about icon SIZES, so that was its whole point. The stylesheet was also missing from` &&
               ` ui5/sap.ui.core/Icon/ (a §4 archive gap) and is archived in the same change. // NOTE: The stethoscope Icon press is wired client-side to MessageToast.show('Over budget!') via the control_global` &&
               ` frontend action, matching the original controller's handleStethoscopePress (MessageToast.show). **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the Icon press`.
    lv_text1 = lv_text1 && ` (dispatched click - the icon row renders zero-height headless) toasts 'Over budget!'.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.core.Icon`                      name = `Icon`                                class = `z2ui5_cl_ai_app_122` path = `src/02/b02/z2ui5_cl_ai_app_122.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.11.1`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.core.InvisibleMessage`          name = `InvisibleMessage`                    class = `z2ui5_cl_ai_app_141` path = `src/02/b05/z2ui5_cl_ai_app_141.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.78`
        since_post171 = abap_true
        is_post171 = abap_true
        notes = `LIVE-TEST: The four buttons announce the pressed button's type+text to the sap.ui.core.InvisibleMessage a11y service and echo it into the status Text; here a press updates the bound status Text with a` &&
                 ` generic confirmation (the a11y live-region announce and the per-button identity are not reproduced server-side). The original's 'Infromation' button-text typo is kept 1:1.` )
      ( module = `sap.ui.core`        control = `sap.ui.core.InvisibleText`             name = `InvisibleText`                       class = `z2ui5_cl_ai_app_127` path = `src/02/b02/z2ui5_cl_ai_app_127.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.27.0`
        notes = `NOTE: onPress toasts evt.getSource().getId() + ' Pressed'. All twelve presses reproduce that client-side and roundtrip-free (control_global MESSAGE_TOAST.show) with the template '{0} Pressed' filled` &&
                 ` by $event.oSource.sId - the documented transport for the pressed control's runtime id. Until 2026-07-28 the port toasted a bare 'Pressed' on the rationale that the generated id is 'not reproducible` &&
                 ` statically', which was the wrong conclusion: the id does not have to be reproduced, it is read off the event on the client. The id string itself is a UI5 runtime value and will differ from the` &&
                 ` original sample's (the view prefix differs), exactly as it differs between two runs of the original.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.core.theming.Parameters`        name = `BasicThemeParameters`                class = `z2ui5_cl_ai_app_131` path = `src/02/b03/z2ui5_cl_ai_app_131.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: The sample itself is just a MessageStrip + Link pointing at the Theme Parameter Toolbox (the real demo content lives in that external tool); reproduced 1:1. The Link href is the original's` &&
                 ` host-relative 'test-resources/sap/m/demokit/theming/webapp/index.html' rewritten to the OpenUI5 host https://sdk.openui5.org/test-resources/sap/m/demokit/theming/webapp/index.html per the runtime` &&
                 ` asset-URL rule (an abap2UI5 system does not serve the demokit path; app 152 precedent).` )
      ( module = `sap.ui.core`        control = `sap.ui.model.type.Currency`            name = `TypeCurrency`                        class = `z2ui5_cl_ai_app_135` path = `src/02/b04/z2ui5_cl_ai_app_135.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: Composite data-type binding paradigm: the Currency type is pulled in via core:require and every Input/Text binds a composite parts:['/amount','/currency'] with type:'CurrencyType' plus` &&
                 ` formatOptions (showMeasure/showNumber/preserveDecimals/currencyCode/style) 1:1. The two model fields amount ('123456789.123') and currency ('USD') are serialized by abap2UI5 as /AMOUNT and /CURRENCY;` &&
                 ` the paths are generated via _bind (never hardcoded).` )
      ( module = `sap.ui.core`        control = `sap.ui.model.type.Date`                name = `TypeDateAsString`                    class = `z2ui5_cl_ai_app_181` path = `src/02/b10/z2ui5_cl_ai_app_181.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: Data-type binding paradigm: sap.ui.model.type.Date is pulled via core:require={DateType: 'sap/ui/model/type/Date'} and every DatePicker/Text keeps the original { path, type: 'DateType',` &&
                 ` formatOptions: { style, source: { pattern: 'yyyy-MM-dd' } } } binding 1:1 as a raw binding-info string (braces escaped, path via _bind). The single model field is a yyyy-MM-dd string. // NOTE: The` &&
                 ` original seeds the current date (UI5Date.getInstance().toISOString().slice(0,10)); a fixed date (2026-07-24) is used here so the port is deterministic - a client-only display value.` ) ).

    lv_text1 = `IMPROVISED: The original model value /dtValue is a JS Date object (UI5Date.getInstance()) and every DateTimeType binding has NO source formatOption (the type's default model format is a Date object).` &&
               ` abap2UI5 cannot hold a JS Date object in the JSON model, so a source formatOption { source: { pattern: 'yyyy-MM-dd HH:mm:ss' } } is added to each DateTimeType binding and the field dtvalue is a` &&
               ` parseable datetime string ('2026-07-24 13:30:00') - the abap2UI5 equivalent of the Date-object model. Without it view creation crashes ('Date must be a JavaScript or UI5Date date object'). The` &&
               ` display style/pattern/UTC/relative formatOptions stay 1:1 on top of the added source. Same idiom as app 182 (TypeTimeAsTime) and the CAPABILITIES date-object row. // NOTE: The original seeds the` &&
               ` current time (UI5Date.getInstance()); a fixed datetime (2026-07-24 13:30:00) is used here so the port is deterministic - a client-only display value. The /dtPattern Input placeholder, which the` &&
               ` original controller derives at runtime from the DateTimeType's getPlaceholderText(), is likewise seeded as a static representative value ('e.g. Dec 31, 2026, 11:59:58 PM' - the en medium-style`.
    lv_text1 = lv_text1 && ` DateTime placeholder) since the port has no controller to compute it.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.model.type.DateTime`            name = `TypeDateTime`                        class = `z2ui5_cl_ai_app_183` path = `src/02/b10/z2ui5_cl_ai_app_183.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.model.type.FileSize`            name = `TypeFileSize`                        class = `z2ui5_cl_ai_app_180` path = `src/02/b10/z2ui5_cl_ai_app_180.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = `POST-1.71: core:require on the view root (module preloading for the FileSizeType alias) is kept 1:1 from the original view.xml; core:require needs UI5 >= 1.74 (declared by policy - the property gate` &&
                 ` cannot see view-root require attributes). // NOTE: Data-type binding paradigm: the FileSize type module is pulled in with core:require='{FileSizeType: sap/ui/model/type/FileSize}' and the Input/Text` &&
                 ` bindings carry type:'FileSizeType' plus formatOptions (min/maxIntegerDigits, min/maxFractionDigits) 1:1. The single model field 'fileSize' (initial 100, kept numeric like the sample's JSON) is` &&
                 ` serialized by abap2UI5 as /FILESIZE, so the original raw '/fileSize' paths are written as '/FILESIZE'.`
        post171 = `core:require on the view root (module preloading for the FileSizeType alias) is kept 1:1 from the original view.xml; core:require needs UI5 >= 1.74 (declared by policy - the property gate cannot see` &&
                 ` view-root require attributes).` ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.model.type.Float`               name = `TypeFloat`                           class = `z2ui5_cl_ai_app_179` path = `src/02/b10/z2ui5_cl_ai_app_179.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = `POST-1.71: core:require on the view root (module preloading for the FloatType alias) is kept 1:1 from the original view.xml; core:require needs UI5 >= 1.74 (declared by policy - the property gate` &&
                 ` cannot see view-root require attributes). // NOTE: Data-type binding paradigm: the Float type module is pulled in with core:require='{FloatType: sap/ui/model/type/Float}' and the Input/Text bindings` &&
                 ` carry type:'FloatType' plus formatOptions (min/maxIntegerDigits, min/maxFractionDigits, preserveDecimals) 1:1. The single model field 'number' (initial '123.456', kept as a string like the sample's` &&
                 ` JSON) is serialized by abap2UI5 as /NUMBER, so the original raw '/number' paths are written as '/NUMBER'.`
        post171 = `core:require on the view root (module preloading for the FloatType alias) is kept 1:1 from the original view.xml; core:require needs UI5 >= 1.74 (declared by policy - the property gate cannot see` &&
                 ` view-root require attributes).` )
      ( module = `sap.ui.core`        control = `sap.ui.model.type.Integer`             name = `TypeInteger`                         class = `z2ui5_cl_ai_app_129` path = `src/02/b03/z2ui5_cl_ai_app_129.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: Data-type binding paradigm: the Integer type module is pulled in with core:require='{IntegerType: sap/ui/model/type/Integer}' and the Input/Text bindings carry type:'IntegerType' plus` &&
                 ` formatOptions (min/maxIntegerDigits) 1:1. The single model field 'number' (initial '123') is serialized by abap2UI5 as /NUMBER, so the original raw '/number' paths are written as '/NUMBER'.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.model.type.Time`                name = `TypeTimeAsTime`                      class = `z2ui5_cl_ai_app_182` path = `src/02/b10/z2ui5_cl_ai_app_182.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `IMPROVISED: The original model value is a JS Date object (UI5Date.getInstance()) and every TimeType binding has NO source formatOption (the type's default model format is a Date object). abap2UI5` &&
                 ` cannot hold a JS Date object in the JSON model, so a source formatOption { source: { pattern: 'HH:mm:ss' } } is added to each TimeType binding and the field is a parseable time string ('13:30:00') -` &&
                 ` the abap2UI5 equivalent of the Date-object model. Without it view creation crashes ('Time must be a Date object'). Same idiom applies to any TypeTime/TypeDateTime sample whose model is an object; a` &&
                 ` plain string binding is not enough (CAPABILITIES date-object row). // NOTE: The original seeds the current time; a fixed time (13:30:00) is used here so the port is deterministic - a client-only` &&
                 ` display value.` )
      ( module = `sap.ui.integration` control = `sap.ui.integration.Card`               name = `CardsLayout`                         class = `z2ui5_cl_ai_app_118` path = `src/02/b01/z2ui5_cl_ai_app_118.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.62`
        notes = `IMPROVISED: Breadth-probe of the declarative-card paradigm: a sap.ui.integration.widgets.Card whose whole UI comes from a JSON manifest. The manifest is carried as an ABAP string and bound to the` &&
                 ` Card, and its content (title/subtitle/3 list items) is invented for the probe - it does not come from the sample. The original page (f:ShellBar, IconTabBar with IconTabFilters, f:GridContainer with` &&
                 ` layout settings, several w:Cards over the manifests> named model incl. card:CardBadgeCustomData badges and GridContainerItemLayoutData) is dropped entirely. Needs rework for a faithful rebuild; the` &&
                 ` multi-manifest binding + external component card manifests remain the hard part (render_smoke notes integration Cards need external manifests).` ) ).

    lv_text1 = `NOTE: The sample itself is a Link + Image pointing at the Card Explorer tool (the actual integration Cards live in that tool); Link and Image reproduced 1:1. Since 2026-07-30 the Image press is the` &&
               ` original onImagePress 1:1: URLHelper.redirect('test-resources/sap/ui/integration/demokit/cardExplorer/index.html', true) via _event_client( cs_event-urlhelper, REDIRECT + { URL, NEW_WINDOW: true } )` &&
               ` - the earlier MessageToast substitution is gone. The relative target resolves against the serving origin exactly like the original's (and the Link's href); outside an OpenUI5-hosted origin it 404s in` &&
               ` the new tab, as the original would. // LIVE-TEST: the urlhelper REDIRECT on the Image press (new-window open of the relative Card Explorer URL) is unverified in a running system; the same REDIRECT` &&
               ` action class is live-verified in app 084.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.integration` control = `sap.ui.integration.widgets.Card`       name = `CardExplorer`                        class = `z2ui5_cl_ai_app_149` path = `src/02/b08/z2ui5_cl_ai_app_149.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.62`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.BlockLayout`             name = `BlockLayoutCustomBackground`         class = `z2ui5_cl_ai_app_140` path = `src/02/b05/z2ui5_cl_ai_app_140.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-27): verified in a running system 2026-07-27 - BlockLayout renders all 6 rows/7 cells with color shades after the attribute-line repair`
        notes = `NOTE: BlockLayout with six rows / seven cells across background color shades A-F; the Select (11 ColorSet items) and every cell's backgroundColorSet are two-way bound to one model field (initial` &&
                 ` ColorSet5), reproducing the original {/colorSet} wiring. Cell body texts are reproduced 1:1 (long ones split with &&). // POST-1.71: sap.m.Label.showColon is used (since UI5 1.98). The BlockLayout` &&
                 ` entity itself is in scope; showColon renders the label's trailing colon 1:1.`
        post171 = `sap.m.Label.showColon is used (since UI5 1.98). The BlockLayout entity itself is in scope; showColon renders the label's trailing colon 1:1.` ) ).

    lv_text1 = `LIVE-TEST: The Slider's ``liveChange`` attribute is dropped: Slider.value is two-way bound to /SLIDER_VALUE and the containerLayout (VerticalLayout) width is an expression binding {= ${/SLIDER_VALUE}` &&
               ` + '%' } reproducing the controller's onSliderMoved setWidth client-side (thin-frontend, no round-trip; the original set width='100%' statically). Binding/render behaviour unverified in a running` &&
               ` system. // LIVE-TEST: The SegmentedButton.selectedKey and the BlockLayout.background are both two-way bound to the same /SELECTEDBACKGROUND field, so changing the segmented button updates the` &&
               ` BlockLayout background entirely on the client with no round-trip (the app-048/003 shared-binding idiom, matching the original {/selectedBackground} on both). The field is seeded with the enum default` &&
               ` Default (the original leaves /selectedBackground undefined; an empty string would fail BlockBackgroundType validateProperty). Live sync unverified. // NOTE: The 123 /ProductCollection rows are` &&
               ` inlined from the shared mock ui5/mock/products.json; only the columns the table binds are kept (productid,name,suppliername,width,depth,height,dimunit,weightmeasure,weightunit,price,currencycode).`.
    lv_text1 = lv_text1 && ` Dimension and weight fields are TYPE string to preserve exact decimals for the display templates; price is TYPE p DECIMALS 2 for the sap.ui.model.type.Currency binding. Data verified against the` &&
               ` mock.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.BlockLayout`             name = `BlockLayoutDefault`                  class = `z2ui5_cl_ai_app_214` path = `src/02/b10/z2ui5_cl_ai_app_214.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The Slider's imperative onSliderMoved handler (setWidth on the container) is replaced by the thin-frontend equivalent: the Slider value is two-way bound and the VerticalLayout containerLayout` &&
               ` width is an expression binding {= ${/SLIDERVALUE} + '%' }. The Slider's liveChange attribute is dropped (no event round-trip needed). structural-diff does not flag the literal value=100 becoming a` &&
               ` binding. // NOTE: The SegmentedButton selectedKey and the BlockLayout background are two-way bound to one default-model field selectedbackground, reproducing the original {/selectedBackground}` &&
               ` wiring; it is seeded with the enum default Default (a valid BlockBackgroundType) because an empty enum value crashes validateProperty. The original controller loads sap/ui/demo/mock/products.json as` &&
               ` the unnamed model but no view binding references it, so it is not reproduced.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.BlockLayout`             name = `BlockLayoutLinkTitle`                class = `z2ui5_cl_ai_app_223` path = `src/02/b10/z2ui5_cl_ai_app_223.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The sample's css/main.css is now shipped with the port: injected through a core:HTML leaf carrying a <style> block (the documented CAPABILITIES form), so the port carries six core:HTML controls` &&
               ` where the original view has five - the original loads the stylesheet through its manifest's sap.ui5/resources/css entry. The single .sapUiLayoutCSSGrid .stylePageLayout rule is verbatim,` &&
               ` whitespace-collapsed, braces escaped \{ \} in a backtick literal. Until 2026-07-28 the five grid tiles carried the stylePageLayout class with no stylesheet behind them, so they rendered as unstyled` &&
               ` text instead of the blue rounded boxes the sample shows. The stylesheet was also missing from ui5/sap.ui.layout/CSSGrid/ (a §4 archive gap) and is archived in the same change. // NOTE: onSliderMoved` &&
               ` sets the Panel width to value + "%" imperatively. Rebuilt on the client (the app-053 shape): the Slider value is two-way bound to slider_value, seeded with the original's literal 100, and the Panel` &&
               ` width carries the expression binding {= slider_value + '%' } instead of the literal 100%. The liveChange attribute is therefore dropped. Until 2026-07-28 the port routed liveChange to a SLIDER_MOVED`.
    lv_text1 = lv_text1 && ` backend event that recomputed the width server-side - correct but one full round-trip per drag step; the expression binding is the thin-frontend form and needs none. // NOTE: The five core:HTML tiles` &&
               ` carry raw HTML in the content attribute (the builder xml-escapes it, matching the original's escaped &lt;header&gt;/&lt;aside&gt;/&lt;article&gt;/&lt;footer&gt; content 1:1, including the original's` &&
               ` quirks: the double space in '<aside  ...>Navigation</aside >' and the mismatched '<aside ...>Related Links</article>' close tag).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.cssgrid.CSSGrid`         name = `CSSGrid`                             class = `z2ui5_cl_ai_app_124` path = `src/02/b02/z2ui5_cl_ai_app_124.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 3 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The original's onRadioButtonSelected switches the CSSGrid gridAutoFlow per selectedIndex imperatively (0 Column, 1 ColumnDense, 2 Row, 3 RowDense). Rebuilt on the client with no round-trip: the` &&
               ` RadioButtonGroup gets a two-way bound selectedIndex (an attribute the original does not carry - its controller reads the index off the event) seeded 0, and gridAutoFlow carries the same switch as an` &&
               ` expression binding instead of the literal Column. The select attribute is therefore dropped; before this rework it was wired to an RB_SELECT backend event this class never dispatched (a dead wire,` &&
               ` pattern-lint dead-event-wire). // IMPROVISED: The 'Reveal Grid' ToggleButton loses its press attribute. The original calls RevealGrid.toggle('grid1', view) from` &&
               ` sap/ui/layout/sample/GridAutoFlow/RevealGrid/RevealGrid - a helper module that ships inside the sample folder, not in any UI5 library: it walks the grid's DOM and overlays absolutely positioned` &&
               ` outline elements over every grid cell. There is no control, property or whitelisted control method that expresses it, and the module itself is not loadable in an abap2UI5 app, so the button stays in`.
    lv_text1 = lv_text1 && ` the view (structurally 1:1) but does nothing. Previously the press fired a REVEAL backend event no branch handled, which looked like behaviour and was none. The sample's actual subject - gridAutoFlow` &&
               ` - is fully reproduced; the reveal overlay is a debugging aid around it. // NOTE: grid:CSSGrid with gridAutoFlow + 10 VBox demo boxes, four carrying GridItemLayoutData row/column spans, 1:1.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.cssgrid.CSSGrid`         name = `GridAutoFlow`                        class = `z2ui5_cl_ai_app_145` path = `src/02/b06/z2ui5_cl_ai_app_145.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: Two of the original's three controller behaviours are now reproduced rather than wired to nothing. (a) breakpointChanged carries its own currentBreakpoint event parameter to the backend (t_arg` &&
               ` ${$parameters>/currentBreakpoint}) and on_event enables the Toggle button exactly when it is 'S' - what _updateToggleButtonState does; the port therefore adds an enabled attribute to the Toggle` &&
               ` Button, which the original sets from the controller. (b) handleToggleClick calls DynamicSideContent.toggle( ); the port binds showSideContent (the property that setter writes, default true) and flips` &&
               ` it in on_event, so the press has an effect. Both were dead wires before this rework - BP_CHANGED and TOGGLE fired round-trips this class never dispatched (pattern-lint dead-event-wire). The original` &&
               ` also calls _updateToggleButtonState once in onAfterRendering; abap2UI5 has no equivalent hook, so the button starts disabled and takes its state from the first breakpointChanged event. // IMPROVISED:`.
    lv_text1 = lv_text1 && ` The width Slider loses its liveChange. The original's handleSliderChange resizes the containing Page through jQuery - this.byId('sideContentContainer').$().width(iValue + '%') - i.e. it writes a CSS` &&
               ` width straight onto the rendered DOM node. sap.m.Page has no width property, so there is nothing to bind and no whitelisted control method to call: the expression-binding rebuild used for the same` &&
               ` slider idiom elsewhere (apps 053/146, where the target is a Toolbar/Panel width property) does not apply here. The Slider stays in the view with its value="100" literal and no longer fires a SLIDER` &&
               ` backend event no branch handled; dragging it now does nothing. // NOTE: The hint Text.visible is bound to a boolean model field (initial true); the original used a literal visible='getVisible()' (a` &&
               ` sample quirk) toggled per Device.system.phone in onBeforeRendering. The two long body texts are shortened representative Lorem (not gate-compared, static).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.DynamicSideContent`      name = `DynamicSideContent`                  class = `z2ui5_cl_ai_app_138` path = `src/02/b05/z2ui5_cl_ai_app_138.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.30`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The original binds the Image src against a separate 'img' JSON model ({img>/products/pic1}) loaded from sap/ui/demo/mock/img.json. abap2UI5 serves one default model, so the picture path is` &&
               ` folded into it and the src binds it directly (client->_bind( pic1 )) - the 'img>' prefix is dropped and the last path segment is identical, which structural-diff matches. The mock's host-relative` &&
               ` path is resolved to the OpenUI5 host (sdk.openui5.org) per the asset-URL rule. // NOTE: The sample's style.css (background colours on the FixFlex fixed/flexible areas, referenced by` &&
               ` class='fixFlexHorizontal') is loaded via the manifest in the original; abap2UI5 ships no separate css file, so it is injected via a core:HTML <style> node with the CSS braces escaped. This adds a` &&
               ` core:HTML control not present in the original view - an extra control IS flagged by structural-diff (control extra), declared here by name.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.FixFlex`                 name = `FixFlexHorizontal`                   class = `z2ui5_cl_ai_app_219` path = `src/02/b10/z2ui5_cl_ai_app_219.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.25.0`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.FixFlex`                 name = `FixFlexMinFlexSize`                  class = `z2ui5_cl_ai_app_215` path = `src/02/b10/z2ui5_cl_ai_app_215.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.25.0` ) ).

    lv_text1 = `IMPROVISED: The named-model image path (img>/products/pic1) is resolved to the static OpenUI5 product image https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg` &&
               ` (the mock's actual pic1 value, host-absolutized; wrong-neighbour HT-1000 copy fixed by the 2026-07-24 data audit). Image.src carries the static value where the original binds {img>/products/pic1} -` &&
               ` the app-006 static-fold class. // IMPROVISED: The sample's css/style.css (the .fixFlexVertical > .sapUiFixFlexFixed / .sapUiFixFlexFlexible background colors, loaded via the manifest resources.css)` &&
               ` is not injected - the class attributes are kept but the decorative backgrounds are lost. Review 2026-07-27: custom CSS IS expressible via a core:HTML style leaf (CAPABILITIES 'Custom CSS', apps` &&
               ` 026/028/169) - needs rework to inject the style.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.FixFlex`                 name = `FixFlexVertical`                     class = `z2ui5_cl_ai_app_119` path = `src/02/b01/z2ui5_cl_ai_app_119.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 2 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.25.0`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.Form`               name = `FormToolbar`                         class = `z2ui5_cl_ai_app_142` path = `src/02/b06/z2ui5_cl_ai_app_142.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16.0`
        notes = `NOTE: sap.ui.layout.form.Form with two FormContainers, per-container toolbars, ResponsiveGridLayout, FormElements with GridData layoutData and a Select. The original bound an element context` &&
                 ` (/SupplierCollection/0 from the shared demo supplier.json); flattened here to top-level model fields the {…} bindings resolve against.` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.SimpleForm`         name = `SimpleFormToolbar`                   class = `z2ui5_cl_ai_app_175` path = `src/02/b10/z2ui5_cl_ai_app_175.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16.0`
        notes = `IMPROVISED: The original controller loads the shared demo supplier.json and element-binds a single record (/SupplierCollection/0); flattened here to top-level default-model fields the {…} SimpleForm` &&
                 ` bindings resolve against. Values are supplier.json SupplierCollection row 0 (Red Point Stores, Maintown); unbound columns (Tel, Sms, Rating, …) are dropped.` ) ).

    lv_text1 = `IMPROVISED: The eight Sliders' liveChange='.onSliderMoved' handler is dropped. The original controller resizes the next grid wrapper via jQuery DOM traversal` &&
               ` (oSlider.$().parent().next().find('.gridWrapper'), then Element.closestTo(...).setWidth(value + '%')). The Sliders render 1:1 but do not resize the grids; the responsive GridData behaviour is still` &&
               ` observable by resizing the browser window. Review 2026-07-27: the earlier 'no bindable equivalent' rationale is wrong - each slider's target wrapper is statically known in the view, so the behaviour` &&
               ` IS expressible roundtrip-free by two-way binding each Slider.value and binding each gridWrapper VerticalLayout.width to the expression {= ${/SLIDER_n} + '%' } (exactly how app 176 ports the identical` &&
               ` onSliderMoved pattern); flagged for rework, not promoted. // NOTE: The sample's styles.css (.GridDataSample .exampleDiv / .propertiesDisplay / p) is injected via a single core:HTML <style> leaf as` &&
               ` the first child of the outer VerticalLayout (abap2UI5 ships no separate css file). CSS braces are escaped \{ \} in a backtick literal so the backslash survives to the serialized attribute, otherwise`.
    lv_text1 = lv_text1 && ` the XMLView binding parser would read them as bindings and crash view creation. This adds one core:HTML control not present in the original view.xml. // NOTE: The core:HTML 'content' divs and the` &&
               ` FormattedText 'htmlText' are written as the decoded literal markup (e.g. <div class=exampleDiv></div>); the original view.xml carries them HTML-entity-encoded (&lt;div ...&gt;) and the builder` &&
               ` re-escapes the literal on stringify. Multi-line div contents in the original are written single-line here (whitespace-only difference, not a binding).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.Grid`                    name = `GridData`                            class = `z2ui5_cl_ai_app_169` path = `src/02/b10/z2ui5_cl_ai_app_169.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.15.0`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.Grid`                    name = `GridInfo`                            class = `z2ui5_cl_ai_app_194` path = `src/02/b10/z2ui5_cl_ai_app_194.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.15.0` ) ).

    lv_text1 = `NOTE: The original binds against the default JSONModel (no named model); the InformationCollection array is reproduced 1:1 on the one abap2UI5 default model. The Grid binding={/InformationCollection}` &&
               ` element-binding and the index-relative child bindings ({0/introText1}, {3/ProductPicUrl2}, {1/ProductPicUrl}, {2/ProductPicUrl}, {1/ProductPicUrl2}, {0/Description1}, {0/Description2}) are kept` &&
               ` verbatim with upper-cased field names. // NOTE: Image asset URLs are host-prefixed to https://sdk.openui5.org/ per the project asset-URL rule: the static demoAppsTeaser.png src, and the bound` &&
               ` ProductPicUrl/ProductPicUrl2 values seeded in model_init (originally host-relative test-resources/ paths). // LIVE-TEST: The Grid element-binding to an array path plus index-relative child bindings` &&
               ` render in the static headless harness (render-smoke green); the actual runtime data resolution of {0/INTROTEXT1} etc. against the serialized default model is not yet verified in a running system.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.Grid`                    name = `GridXL`                              class = `z2ui5_cl_ai_app_226` path = `src/02/b10/z2ui5_cl_ai_app_226.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.15.0`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.HorizontalLayout`        name = `HorizontalLayout`                    class = `z2ui5_cl_ai_app_162` path = `src/02/b09/z2ui5_cl_ai_app_162.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16.0`
        notes = `NOTE: The original uses a separate 'img' JSON model for the image src ({img>/products/pic1}) alongside the default model for the widths. abap2UI5 has one default model, so the picture path is folded` &&
                 ` into it and the src binds it directly - the 'img>' prefix is dropped and the path flattened to a single field (pic1); the last path segment is identical, which structural-diff matches. Widths use the` &&
                 ` desktop values (the original's phone branch is a client-only Device decision).` ) ).

    lv_text1 = `NOTE: The original keeps the three pane sizes in a separate 'sizes' JSON model ({sizes>/pane1}, {sizes>/pane2}, {sizes>/pane3}) bound on the three SplitterLayoutData.size properties and echoed in each` &&
               ` pane's Text label. abap2UI5 has one default model, so pane1/pane2/pane3 are folded into it and bound directly - the 'sizes>' prefix is dropped and the last path segment is identical, which` &&
               ` structural-diff matches. Same data, renders identically. // NOTE: The shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json) is inlined into model_init with the three columns the` &&
               ` sample binds - ProductId, Name and Quantity (the List's title/counter and the Select's Item key/text). Quantity is the mock integer; the full row set is kept. // IMPROVISED: The two PaneContainer` &&
               ` resize handlers (resize='.onRootContainerResize' on the root container and resize='.onInnerContainerResize' on the inner container) are dropped. Both only compose an informational MessageToast` &&
               ` listing the oldSizes/newSizes pane-size arrays reported by the resize event; that array-valued container-resize event has no bound-model equivalent, so the resize attribute is not reproduced. No app`.
    lv_text1 = lv_text1 && ` state depends on it.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.ResponsiveSplitter`      name = `ResponsiveSplitter`                  class = `z2ui5_cl_ai_app_186` path = `src/02/b10/z2ui5_cl_ai_app_186.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.38`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.Splitter`                name = `Splitter2`                           class = `z2ui5_cl_ai_app_125` path = `src/02/b02/z2ui5_cl_ai_app_125.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0` ) ).

    lv_text1 = `NOTE: The original binds the image src against a separate 'img' JSON model ({img>/products/pic1} from sap/ui/demo/mock/img.json) alongside the default model for the widths. abap2UI5 has one default` &&
               ` model, so the picture path is folded into it and the src binds it directly (client->_bind( pic1 )) - the 'img>' prefix is dropped, the last path segment (pic1) is identical and the value is the` &&
               ` mock's own HT-7777-large.jpg absolutized on the sanctioned sdk.openui5.org host, so this is the same-data prefix-drop NOTE case (retyped from IMPROVISED per the settled 2026-07-24 policy). //` &&
               ` LIVE-TEST: The original computes widthS/M/L from Device.system.phone in the controller (phone: 2/4/6em, else 5/10/15em). The bindings {/widthS..L} are ported 1:1 on the default model and the seed` &&
               ` reproduces the device branch server-side from client->get( )-s_device-system (app 012 precedent, review fix 2026-07-27); the phone-branch seeding is unverified in a running system.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.VerticalLayout`          name = `VerticalLayout`                      class = `z2ui5_cl_ai_app_173` path = `src/02/b10/z2ui5_cl_ai_app_173.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: Breadth-probe: a minimal sap.ui.table.Table (grid table, distinct from sap.m.Table) with 3 columns + template cells over a small ABAP model. The original's full 13-column set` &&
               ` (Input/ObjectStatus/Currency/ComboBox/Link/Button/CheckBox/Select/MultiInput/Icon/DatePicker cells, formatters, derived Suppliers/Categories arrays), the p:ColumnAIAction plugin (post-1.71) and paste` &&
               ` handling are omitted, and only 5 of the 123 /ProductCollection rows are seeded. Review 2026-07-27: two seeded literals contradicting the mock were corrected (ITelO Vault supplier Smartcard Corp ->` &&
               ` Technocom, Comfort Easy price 1650 -> 1679, the wrong-neighbour-copy class); the reduction itself needs rework toward a faithful rebuild (full rows per the retired-SUBSET_DATA policy; only the` &&
               ` post-1.71 plugin may stay dropped, as DROPPED_171).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                    name = `Basic`                               class = `z2ui5_cl_ai_app_115` path = `src/02/b01/z2ui5_cl_ai_app_115.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: onColumnResize is reduced: the original buffers per-column resize messages, joins them and toasts 'Column <label> was resized to <width>.', and calls oEvent.preventDefault() to block` &&
               ` resizing the deliverydate column. The backend cannot preventDefault a client-side column resize (no CONTROL_METHODS / event hook for it) and cannot read the column label off the event, so` &&
               ` columnResize is wired to a roundtrip-free client MessageToast (control_global MESSAGE_TOAST.show 'Column was resized to {0}.' filled by ${$parameters>/width}); the per-column preventDefault and the` &&
               ` column-label text are dropped. // NOTE: Named-model fold with a nested config object: the original binds each Column width to the ui>/widths/{name,category,image,quantity,date} single object on a` &&
               ` separate JSONModel. abap2UI5 has one default model; a nested single-object bind is proven only for row-relative sub-paths (CAPABILITIES 'Nested single (non-array) structure', app 171) - a top-level` &&
               ` struct-component _bind is unproven in this corpus, and writing '/WIDTHS/NAME' as a literal path is disallowed. So the widths object is folded to five top-level string fields named exactly`.
    lv_text1 = lv_text1 && ` name/category/image/quantity/date (the sanctioned named-model prefix-drop idiom), each bound via client->_bind so the last path segment still matches the original (structural-diff normalizes on the` &&
               ` last segment). onColumnWidthsChange (SegmentedButton Static/Flexible/Mixed) is reproduced faithfully: the selected key is transported via ${$parameters>/item}.getKey() and the width set is recomputed` &&
               ` in ABAP (thin-frontend) + view_model_update. // NOTE: DeliveryDate is seeded deterministically. The original computes DeliveryDate = Date.now() - (i % 10 * 4 days) per load (non-deterministic` &&
               ` timestamps); the port uses a fixed base (2026-07-25 in epoch ms) minus the same (i % 10 * 4 days) offset, kept as an epoch-ms value bound through the original {path:'DeliveryDate',` &&
               ` type:'sap.ui.model.type.Date', formatOptions:{source:{pattern:'timestamp'}}} typed binding. // NOTE: ProductPicUrl is resolved to the OpenUI5 host: the mock stores the host-relative` &&
               ` 'test-resources/sap/ui/documentation/sdk/images/HT-xxxx.jpg'; the port stores the absolute 'https://sdk.openui5.org/test-resources/...' per the asset-URL rule, keeping the original {ProductPicUrl}`.
    lv_text1 = lv_text1 && ` binding. Full 123-row ProductCollection inlined (Name/Category/ProductPicUrl/Quantity/DeliveryDate). // LIVE-TEST: The SegmentedButton width-switch round-trip (WIDTHS_CHANGE with` &&
               ` ${$parameters>/item}.getKey(), width recompute + view_model_update), the columnResize client toast (${$parameters>/width}), and the timestamp-typed DeliveryDate rendering are view-create verified` &&
               ` (render-smoke) but not yet live-verified in a running system.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                    name = `ColumnResizing`                      class = `z2ui5_cl_ai_app_247` path = `src/02/b12/z2ui5_cl_ai_app_247.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                    name = `MultiHeader`                         class = `z2ui5_cl_ai_app_137` path = `src/02/b05/z2ui5_cl_ai_app_137.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: sap.ui.table grid Table with multi-level column headers (multiLabels + headerSpan '3,2'/'2') and an extension OverflowToolbar. The 5 contact rows are inlined from the controller's JSON model;` &&
                 ` column templates bind {SUPPLIER}/{STREET}/{CITY}/{PHONE}/{OPENORDERS} 1:1.` ) ).

    lv_text1 = `IMPROVISED: The three toolbar handlers imperatively mutate Table properties in the original controller: onSelectionModeChange calls setSelectionMode, onAlternateToggle calls setAlternateRowColors,` &&
               ` onHighlightToggle swaps the rowSettingsTemplate between a RowSettings and null. abap2UI5 is a thin frontend, so all three are reproduced as two-way property bindings on the one default model with no` &&
               ` round-trip (AGENTS section 5 / section 10 'prefer a bindable property'): the Select selectedKey and the Table selectionMode both bind SELECTION_MODE; the 'Toggle Alternate Row Colors' ToggleButton` &&
               ` pressed and the Table alternateRowColors both bind ALTERNATE_ROW_COLORS (the alternateRowColors attribute is added to the Table - it is not in the original view, which only sets it via the` &&
               ` controller); the 'Toggle Highlights' ToggleButton pressed binds SHOW_HIGHLIGHTS, which the RowSettings highlight reads through an expression binding {= ${/SHOW_HIGHLIGHTS} ? ${STATUS} : 'None'} to` &&
               ` reproduce the template-null hide. As a consequence the original event-handler attributes are dropped: the Select change and both ToggleButton press handlers are not emitted (their behaviour now lives`.
    lv_text1 = lv_text1 && ` in the bindings). // IMPROVISED: The highlight state per row (RowSettings highlight={Status}, highlightText={StatusText}) is computed by the original controller in initSampleDataModel (fixed states` &&
               ` for the first five rows, then Success/Warning/Error/Information/Indication01/None derived from the Price thresholds, with the matching custom highlightText). This is business logic, so per the` &&
               ` thin-frontend principle it is computed in ABAP model_init into the STATUS / STATUSTEXT model fields and bound directly (highlight={STATUS} via the expression above, highlightText={STATUSTEXT}) rather` &&
               ` than in a frontend formatter. // NOTE: The shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json) is inlined verbatim into model_init with the five columns the sample binds (Name,` &&
               ` ProductId, Quantity, Price, CurrencyCode). Price is typed as a packed ABAP field (p LENGTH 13 DECIMALS 2) because the u:Currency value property is numeric (float) - UI5 2.x strict-type validation` &&
               ` would reject a string there. The mock's own Status field (all 'Available') is intentionally not carried, since the sample overwrites Status with the highlight classification above. // LIVE-TEST: The`.
    lv_text1 = lv_text1 && ` interaction paths are unverified in a running system: the two-way client-side property bindings that replace the controller setters (selectionMode, alternateRowColors) and the highlight-visibility` &&
               ` expression binding driven by the SHOW_HIGHLIGHTS ToggleButton. All @since-checked members are <= 1.71 so no POST_171 is needed (RowSettings 1.48, RowSettings.highlightText 1.62,` &&
               ` Table.alternateRowColors 1.52, u:Currency 1.21.1).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                    name = `RowHighlights`                       class = `z2ui5_cl_ai_app_174` path = `src/02/b10/z2ui5_cl_ai_app_174.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The original splits UI state into a separate 'ui' JSON model and binds the row mode from it ({ui>/rowMode}) in two places - the Table's rowMode aggregation and the footer SegmentedButton's` &&
               ` selectedKey - while the grid rows come from the default model ({/ProductCollection}). abap2UI5 has one default model, so the row mode is folded into it and both places bind it directly - the 'ui>'` &&
               ` prefix is dropped and the path flattened to a single field (rowMode); the last path segment is identical, which structural-diff matches. // NOTE: The shared 123-row demo ProductCollection` &&
               ` (sap/ui/demo/mock/products.json) is inlined into model_init with the five columns the sample binds (Name, Category, ProductPicUrl, Quantity, DeliveryDate), in the mock's own row order (review` &&
               ` 2026-07-27 fixed a reordered tail and one invented 'Smartphone Cover' row - the mock has two 'Tablet Pouch' rows). ProductPicUrl values point at the OpenUI5 host` &&
               ` (https://sdk.openui5.org/test-resources/...) per the asset-URL rule; the mock carries them host-relative. The original computes DeliveryDate from Date.now() with an i-mod-10 offset; a fixed base date`.
    lv_text1 = lv_text1 && ` (2026-07-23) is used here so the port is deterministic - a client-only display decision. The Quantity and DeliveryDate columns keep the original typed complex bindings (sap.ui.model.type.Integer /` &&
               ` .Date with timestamp source). // POST-1.71: sap.ui.table.Table.rowMode (aggregation, @since 1.119) is used 1:1 (the RowModes sample binds rowMode to the folded 'ui>' state). Newer than UI5 1.71;` &&
               ` declared per the property-171 policy. Previously undeclared because the property gate is blind to sap.ui.table (properties.json holds sap.m only); found by the non-sap.m @since audit 2026-07-24.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                    name = `RowModes`                            class = `z2ui5_cl_ai_app_164` path = `src/02/b10/z2ui5_cl_ai_app_164.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-27): verified in a running system 2026-07-27 - sap.ui.table RowModes renders the regenerated 123-row set; rowMode switching works`
        notes = lv_text1
        post171 = `sap.ui.table.Table.rowMode (aggregation, @since 1.119) is used 1:1 (the RowModes sample binds rowMode to the folded 'ui>' state). Newer than UI5 1.71; declared per the property-171 policy. Previously` &&
                 ` undeclared because the property gate is blind to sap.ui.table (properties.json holds sap.m only); found by the non-sap.m @since audit 2026-07-24.` ) ).

    lv_text1 = `NOTE: The onInit JSONModel('.../Clothing.json') load is folded into model_init: the full tree (Women/Men/Girls/Boys, every article with amount/currency/size) plus the /sizes list, 1:1 from the mock.` &&
               ` The tree keeps the original's shape - nested types per level under a CATALOG-CLOTHING structure, so the rows binding path '/CATALOG/CLOTHING' with parameters { arrayNames: ['CATEGORIES'] } mirrors` &&
               ` {path:'/catalog/clothing', parameters:{arrayNames:['categories']}}. Homogeneous-type caveat: a level-3 leaf article (Jewelry/Necklace class) carries an empty CATEGORIES array (the ABAP row type is` &&
               ` one shape per level) - JSONTreeBinding treats an empty child array as a leaf, so it renders like the original's absent property; and a level-3 CATEGORY row (Dresses) carries initial` &&
               ` AMOUNT/CURRENCY/SIZE fields its original JSON node omits - SIZE '' keeps the Select hidden through the original's own !!SIZE guard, and the Price guard below keeps the cell empty. // NOTE:` &&
               ` Currency.value is the guarded expression binding ``{= ${AMOUNT} > 0 ? ${AMOUNT} : null }`` (a numeric-string 0.00 from the transpiled runtime is truthy, so the guard compares > 0 instead of testing`.
    lv_text1 = lv_text1 && ` truthiness) instead of the original's plain {amount}: a category row's own AMOUNT serializes as 0 (initial packed - a flat ABAP row serializes every field), and an unguarded 0 would render '0.00'` &&
               ` where the original's absent JSON property renders an empty Price cell. The app-220 optional-value-guard idiom (backtick literal so the braces reach the attribute verbatim); leaf amounts are all > 0,` &&
               ` so no real price is masked. // LIVE-TEST: unverified in a running system: (a) the nested-structure model root (/CATALOG/CLOTHING via _bind on the catalog-clothing component) feeding the TreeTable` &&
               ` rows binding with arrayNames; (b) Collapse all / Expand first level via roundtrip-free _event_client control_by_id (collapseAll whitelisted, expandToLevel int); (c) Collapse/Expand selection 1:1 via` &&
               ` the $event.oSource.getParent().getParent().getSelectedIndices() expression - the resolved index array reaches the unlisted-but-public collapse/expand methods through castArgAuto untouched; (d) the` &&
               ` two-way Select selectedKey writing a changed size back into the tree row. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): (a) and (b) are covered - the tree`.
    lv_text1 = lv_text1 && ` renders its root categories from the nested-structure model, Expand first level reveals the second level (Accessories) and Collapse all hides it again; (c) selection expand/collapse and (d) the` &&
               ` two-way Select remain unexercised. Environment note: the transpiled runtime serializes packed AMOUNT as a numeric string, which is why the Currency guard compares > 0 instead of truthiness.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.TreeTable`                name = `TreeTable.JSONTreeBinding`           class = `z2ui5_cl_ai_app_248` path = `src/02/b12/z2ui5_cl_ai_app_248.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Calendar`               name = `CalendarCalendarType`                class = `z2ui5_cl_ai_app_151` path = `src/02/b08/z2ui5_cl_ai_app_151.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0`
        notes = `IMPROVISED: Calendar with primaryCalendarType Islamic / secondaryCalendarType Gregorian. select and 'Focus Today' are wired to backend events that write the current server date (Gregorian yyyy-MM-dd)` &&
                 ` into the bound Text; the original formatted the actually selected day into the Text (select) and only focused today via focusDate (Focus Today, no text change). The selected day is not read from the` &&
                 ` event and the calendar focus is not moved - a material behavior substitution, not just an unverified wiring.` ) ).

    lv_text1 = `NOTE: The object-typed calendar date properties (Calendar.minDate, Calendar.maxDate and the disabledDates DateRange startDate/endDate) are fed from plain ISO strings in the model and converted at the` &&
               ` point of use with Formatter.DateCreateObject from the curated module (core:require='{Formatter: z2ui5/model/formatter}'). A plain string binding would crash view creation (Date must be a JS/UI5Date` &&
               ` object). The original's UI5Date.getInstance(year, month0, day) values are normalized to ISO 1:1 (month is 0-based: minDate 2000-01-01, maxDate 2050-12-31, disabled ranges 2016-01-04..2016-01-10 and` &&
               ` 2016-01-15). // NOTE: The second disabled range is a SINGLE day: the original's row omits end entirely (undefined is falsy), and one bound DateRange template cannot omit an attribute per row. A plain` &&
               ` formatter binding over the empty end field crashed the app - Formatter.DateCreateObject('') is new Date('') = Invalid Date, DateRange.endDate accepts it (type object) and Month._checkDateEnabled then`.
    lv_text1 = lv_text1 && ` runs CalendarDate.fromLocalJSDate on every TRUTHY endDate, which throws. Fixed 2026-07-28 by guarding the conversion in the binding itself: endDate="{= ${END} ? Formatter.DateCreateObject(${END}) :` &&
               ` null }" - written as a backtick literal so the braces survive to the attribute. Probe-verified against the real OpenUI5 runtime (scripts/probes/calendar-empty-enddate-probe.mjs, headless Chromium,` &&
               ` calendar focused on the affected month): the old binding throws and renders 0 days, the guarded one yields endDate null for the empty row and renders all 42. This also matters for the semantics, not` &&
               ` only the crash: Month._checkDateEnabled disables a single day ONLY through the no-endDate branch (the range branch compares strictly exclusive, oTimeStamp > start && < end), so seeding end = start` &&
               ` would disable nothing. // IMPROVISED: The Calendar select handler (handleCalendarSelect) formats the picked day with DateFormat and writes it into the 'selectedDate' Text; this is imperative` &&
               ` presentation with no bindable equivalent (the select event parameter is a DateRange control reference, not a value that can be transported), so the select attribute is dropped and the selectedDate`.
    lv_text1 = lv_text1 && ` Text keeps its initial 'No Date Selected' text. // NOTE: The original Switch (state='true') toggles Calendar week numbers via an imperative change handler (setShowWeekNumbers). This is folded into a` &&
               ` two-way binding shared by the Switch state and a Calendar showWeekNumbers property (both bound to show_week_numbers, seeded true), so the toggle runs on the client with no round-trip - the` &&
               ` thin-frontend move. The Switch change attribute is therefore dropped and a showWeekNumbers attribute (absent from the original view) is added. // POST-1.71: Formatter.DateCreateObject is referenced` &&
               ` via core:require, which needs UI5 >= 1.74. sap.ui.unified.Calendar itself and its minDate/maxDate/disabledDates/showWeekNumbers members are all <= 1.71 (in scope).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Calendar`               name = `CalendarMinMax`                      class = `z2ui5_cl_ai_app_220` path = `src/02/b10/z2ui5_cl_ai_app_220.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Formatter.DateCreateObject is referenced via core:require, which needs UI5 >= 1.74. sap.ui.unified.Calendar itself and its minDate/maxDate/disabledDates/showWeekNumbers members are all <= 1.71 (in` &&
                 ` scope).` ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Calendar`               name = `CalendarSingleDaySelection`          class = `z2ui5_cl_ai_app_139` path = `src/02/b05/z2ui5_cl_ai_app_139.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0`
        notes = `IMPROVISED: Calendar.select and the 'Select Today' button are wired to backend events that write the current server date (yyyy-MM-dd) into the bound status Text. The original formatted` &&
                 ` getSelectedDates()[0].getStartDate() / added a DateRange(today) with DateFormat + UI5Date; the actually clicked day is not transported back (Calendar.select carries no date parameter and the selected` &&
                 ` DateRange is control state), so selecting a day other than today shows the server date instead - a material simplification.` ) ).

    lv_text1 = `IMPROVISED: CalendarDateInterval.select and the 'Select Today' button are wired to backend events that write the current server date (yyyy-MM-dd) into the bound status Text. The original formatted` &&
               ` getSelectedDates()[0].getStartDate() with DateFormat, and handleCalendarSelect additionally toggled the day off when the same date was re-clicked (removeSelectedDate). Reading the actually clicked` &&
               ` day out of the event is not transportable (select carries no date parameter and getSelectedDates()[0] needs array indexing the $-arg expression parser does not offer), so both actions report the` &&
               ` server date and the re-click deselect is lost; the select/press attributes are kept. // NOTE: The CAL_SELECT / SELECT_TODAY round-trips updating the bound selectedDate Text are unverified in a` &&
               ` running system. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): 'Select Today' round-trips and the bound #selectedDate Text shows the yyyy-MM-dd value;` &&
               ` CAL_SELECT is the same handler.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.CalendarDateInterval`   name = `CalendarDateIntervalBasic`           class = `z2ui5_cl_ai_app_177` path = `src/02/b10/z2ui5_cl_ai_app_177.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.30.0`
        notes = lv_text1 ) ).

    lv_text1 = `POST-1.71: DateTypeRange.startDate is a date-object (type object) property, so it is bound through core:require="{Formatter: 'z2ui5/model/formatter'}" + formatter 'Formatter.DateCreateObject' (the` &&
               ` curated module), which needs UI5 >= 1.74 - a plain ISO-string binding would crash view creation (CAPABILITIES 'Date-object properties'; same idiom as apps 108/109). The xmlns:core + core:require were` &&
               ` added for it; the original view had neither. // NOTE: The original builds the CalendarLegend items and the Calendar specialDates imperatively in onInit (addItem/addSpecialDate). Reproduced the` &&
               ` faithful abap2UI5 way as declared, model-bound aggregations: CalendarLegend.items = {/T_LEGEND} with a CalendarLegendItem template and Calendar.specialDates = {/T_SPECIAL} with a DateTypeRange` &&
               ` template (both templates are extra controls the original view.xml did not carry, as it added them in the controller) - CAPABILITIES marks controller-filled onInit aggregations as expressible this` &&
               ` way. The 10 legend items (Type01..Type10 / 'Placeholder 1..10') and 20 special dates (per type: day i and day i+12 of the current month) are computed server-side in model_init from sy-datum, so the`.
    lv_text1 = lv_text1 && ` special dates track the current month exactly as the original UI5Date.getInstance() logic did.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.CalendarLegend`         name = `CalendarLegendNavigation`            class = `z2ui5_cl_ai_app_240` path = `src/02/b11/z2ui5_cl_ai_app_240.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `DateTypeRange.startDate is a date-object (type object) property, so it is bound through core:require="{Formatter: 'z2ui5/model/formatter'}" + formatter 'Formatter.DateCreateObject' (the curated` &&
                 ` module), which needs UI5 >= 1.74 - a plain ISO-string binding would crash view creation (CAPABILITIES 'Date-object properties'; same idiom as apps 108/109). The xmlns:core + core:require were added` &&
                 ` for it; the original view had neither.` ) ).

    lv_text1 = `NOTE: Breadth-probe (cross-library capability test). Inline sap.ui.unified ColorPicker (HSL / Simplified); the view itself is a 1:1 rebuild. Since 2026-07-30 the button's controller-built` &&
               ` ResponsivePopover-with-ColorPicker is reproduced 1:1 via popover_display( xml = fragment by_id = $event.oSource.sId ): a core:FragmentDefinition with ResponsivePopover (title 'Color Picker'), a` &&
               ` second u:ColorPicker (HSL/Simplified) in its content and Submit/Cancel Button pair - all extra controls vs the original view.xml, which declared none of them (controller-built). The original's` &&
               ` Device.system.phone branch (phone: begin/end Submit/Cancel buttons that close; desktop: setShowHeader(false)) is expressed declaratively: showHeader='{device>/system/phone}' and` &&
               ` visible='{device>/system/phone}' on both buttons, so phone and desktop render as the original without a JS branch; the buttons close via the popover_close frontend action (oRP.close()). // LIVE-TEST:` &&
               ` the anchored ResponsivePopover open (popover_display by_id) with the embedded ColorPicker and the device-bound header/button variants are unverified in a running system. **e2e-verified 2026-07-30**`.
    lv_text1 = lv_text1 && ` (transpiled-framework interaction, scripts/e2e-smoke.mjs): the button press opens the ResponsivePopover anchored with the embedded ColorPicker attached (the picker's inner sliders render zero-size` &&
               ` headless, so only the container is asserted).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.ColorPicker`            name = `ColorPickerSimplified`               class = `z2ui5_cl_ai_app_112` path = `src/02/b01/z2ui5_cl_ai_app_112.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.48.0`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: The controller calls Formatting.setCustomCurrencies({BGN4:{digits:4}, WWWW:{digits:5}}) to register two custom currencies used by list five (customCurrencyDataModel). This is a global` &&
               ` frontend i18n formatting config, not a control and not expressible in the thin abap2UI5 frontend; ported without it, so the BGN4/WWWW currencies in list five render with UI5's default digit count` &&
               ` instead of 4/5 digits. // LIVE-TEST: The various/nonDecimal arrays back the u:Currency value property (float) as ABAP packed fields, matching the sample's JSON numbers; the bigNumber array (JSON` &&
               ` strings) and the customCurrency array (JSON numbers bound to the string property stringValue, so UI5 coerces them) are ABAP string fields keeping the exact literals (123.45676 has 5 decimals).` &&
               ` listSix binds the numeric variousNumberDataModel/price to stringValue (number coerced to string, as in the original). Currency value/stringValue/maxPrecision formatting needs a live render check.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Currency`               name = `Currency`                            class = `z2ui5_cl_ai_app_196` path = `src/02/b10/z2ui5_cl_ai_app_196.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.21.1`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Currency`               name = `CurrencyInTable`                     class = `z2ui5_cl_ai_app_171` path = `src/02/b10/z2ui5_cl_ai_app_171.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.21.1`
        checked = `CHECKED (2026-07-27): verified in a running system 2026-07-27 - nested transactionAmount/size + currency bindings resolve at runtime (u:Currency renders values)`
        notes = `NOTE: live-verified 2026-07-27: u:Currency binds a nested object path (value={transactionAmount/size}, currency={transactionAmount/currency}). Ported as a nested ABAP structure TRANSACTION_AMOUNT` &&
                 ` (fields SIZE/CURRENCY), bound {TRANSACTION_AMOUNT/SIZE} / {TRANSACTION_AMOUNT/CURRENCY}. CAPABILITIES.md documents nested TABLES/trees but not a nested single (non-array) structure within a row, so` &&
                 ` the nested-object serialization + relative sub-path binding needs a live render check.` )
      ( module = `sap.ui.unified`     control = `sap.ui.unified.FileUploader`           name = `FileUploaderBasic`                   class = `z2ui5_cl_ai_app_126` path = `src/02/b02/z2ui5_cl_ai_app_126.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `LIVE-TEST: The full upload cycle is backend/endpoint dependent, so it is reduced to client-side MessageToasts: 'Upload File' press shows an upload-started toast (original handleUploadPress ran` &&
                 ` checkFileReadable().then(upload)), and FileUploader.uploadComplete shows the hardcoded success message the original built (handleUploadComplete parsed a hardcoded 'Status: 200' response and toasted` &&
                 ` '(Upload Success)'). The uploadUrl='upload/' is kept 1:1.` ) ).

    lv_text1 = `NOTE: handleUploadPress reproduced since 2026-07-30: the Upload File press fires a backend UPLOAD round-trip; FileUploader.value is two-way bound (an added value attribute, declared) so the backend` &&
               ` runs the original's empty check - no file chosen toasts 'Choose a file first' (1:1), else follow_up_action control_by_id fileUploader upload + clear reproduce oFileUploader.upload() then clear()` &&
               ` (both public non-denied methods via the generalized allowlist). The earlier tooltip-derived 'Uploading file to the local server ...' toast is gone. NOT reproduced: checkFileReadable() - a client-side` &&
               ` File API probe whose rejection branch ('The file cannot be read. It may have changed.') has no declarative equivalent; the port uploads without the readability pre-check. // IMPROVISED:` &&
               ` handleUploadComplete: the original parses a hardcoded 'File upload complete. Status: 200' response and toasts '<response> (Upload Success)'. Reproduced as a client-composed MessageToast with the` &&
               ` resolved literal 'File upload complete. Status: 200 (Upload Success)' (endpoint-independent, same as app 126). // NOTE: change and typeMissmatch handlers are reproduced 1:1 as roundtrip-free`.
    lv_text1 = lv_text1 && ` client-composed MessageToasts (control_global MESSAGE_TOAST.show): change -> "Press 'Upload File' to upload file '{0}'" filled by ${$parameters>/newValue}; typeMissmatch -> 'The file type *.{0} is` &&
               ` not supported. Choose one of the following types: txt, jpg' filled by ${$parameters>/fileType}. The allowed-types list is folded to the literal 'txt, jpg' (the static fileType property the original` &&
               ` builds it from); the original's aFileTypes.map(...) result is unused there too, so the message text matches. // LIVE-TEST: The client-composed toasts (change/typeMissmatch/uploadComplete/press via` &&
               ` control_global MESSAGE_TOAST) and the ${$parameters>/newValue} / ${$parameters>/fileType} event-arg resolution are view-create verified (render-smoke) but not yet live-verified in a running system.` &&
               ` **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): pressing 'Upload File' with no chosen file round-trips and toasts 'Choose a file first'; the` &&
               ` change/typeMissmatch toasts need a real file dialog and remain unexercised.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.FileUploader`           name = `FileUploaderComplex`                 class = `z2ui5_cl_ai_app_246` path = `src/02/b12/z2ui5_cl_ai_app_246.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        notes = lv_text1 ) ).

    lv_text1 = `POST-1.71: Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it. // NOTE: anchored open works since the framework` &&
               ` fallback of 2026-07-27 (pr/unified-menu-open-anchored, implemented): the openBy dispatch detects that sap.ui.unified.Menu has no openBy and calls open(false, anchor, 'begin top', 'begin bottom',` &&
               ` anchor) with the button as opener and dock reference - the previously declared no-op wire is now functional, unchanged in the port. Still dropped either way: the keyboard flag (controller` &&
               ` attachBrowserEvent tab/keyup tracking) and the explicit Popup.Dock.BeginTop/BeginBottom constants (default docking is visually equivalent). // NOTE: the fragment Menu (added in the controller via` &&
               ` getView().addDependent(this._menu)) is declared 1:1 inside the Button's ``dependents`` aggregation (the addDependent equivalent, same as app 060) - structurally identical, no loss; structural-diff` &&
               ` ignores the aggregation name. // NOTE: the selected item text/value is read with ${$parameters>/item}.getText() (and .getValue() for the MenuTextFieldItem), a method call on the resolved MenuItemBase`.
    lv_text1 = lv_text1 && ` control, NOT ${$parameters>/item/text}: the $parameters model exposes 'item' as the control object and UI5 keeps properties in the control's internal store, so the path .../item/text reads an` &&
               ` undefined field and the toast arrives empty (same finding as app 060). // LIVE-TEST: unverified in a running system: (a) the button press opens the Menu via the 2026-07-27 anchored-open fallback -` &&
               ` verify the open in a running system; (b) each MenuItem select toasts "'<text>' pressed" via ${$parameters>/item}.getText() and the MenuTextFieldItem select toasts "'<value>' entered" via` &&
               ` ${$parameters>/item}.getValue(). **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the button press opens the sap.ui.unified.Menu anchored via the openBy->open()` &&
               ` fallback ('My 1st Item' visible); the item-select toasts remain unexercised.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Menu`                   name = `MenuItemEventing`                    class = `z2ui5_cl_ai_app_227` path = `src/02/b10/z2ui5_cl_ai_app_227.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.21.0`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it.` ) ).

    lv_text1 = `POST-1.71: Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it. // NOTE: anchored open works since the framework` &&
               ` fallback of 2026-07-27 (pr/unified-menu-open-anchored, implemented): the openBy dispatch detects that sap.ui.unified.Menu has no openBy and calls open(false, anchor, 'begin top', 'begin bottom',` &&
               ` anchor) with the button as opener and dock reference - the previously declared no-op wire is now functional, unchanged in the port. Still dropped either way: the keyboard flag (controller` &&
               ` attachBrowserEvent tab/keyup tracking) and the explicit Popup.Dock.BeginTop/BeginBottom constants (default docking is visually equivalent). // IMPROVISED: the sample's handleMenuItemPress branches on` &&
               ` the runtime item: ``if (oItem.getSubmenu()) return;`` (do nothing for a parent that only opens its submenu) and ``if (oItem.getMetadata().getName() === 'sap.ui.unified.MenuTextFieldItem') sMessage =` &&
               ` item.getValue() + ' entered'`` else ``item.getText() + ' pressed'``. This walks the client-side control tree / inspects the control class, which the thin backend cannot do - and the roundtrip-free`.
    lv_text1 = lv_text1 && ` MESSAGE_TOAST.show template cannot branch. The port composes a single toast "'<text>' pressed" from ${$parameters>/item}.getText() for every itemSelect, dropping the submenu-parent guard and the` &&
               ` MenuTextFieldItem getValue()/'entered' branch (same class of limit as app 060's parent-chain breadcrumb, which the server cannot walk). The itemSelect event and every item are declared 1:1. // NOTE:` &&
               ` the fragment Menu (added in the controller via getView().addDependent(this._menu)) is declared 1:1 inside the Button's ``dependents`` aggregation (the addDependent equivalent, same as app 060) -` &&
               ` structurally identical, no loss; structural-diff ignores the aggregation name. // NOTE: the selected item text is read with ${$parameters>/item}.getText() (a method call on the resolved MenuItemBase` &&
               ` control), NOT ${$parameters>/item/text}: the $parameters model exposes 'item' as the control object and UI5 keeps properties in the control's internal store, so the path .../item/text reads an` &&
               ` undefined field and the toast arrives empty (same finding as app 060). // LIVE-TEST: unverified in a running system: (a) the button press opens the Menu via the 2026-07-27 anchored-open fallback -`.
    lv_text1 = lv_text1 && ` verify the open in a running system; (b) selecting a menu item toasts "'<text>' pressed" via the Menu-level itemSelect + ${$parameters>/item}.getText().`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Menu`                   name = `MenuMenuEventing`                    class = `z2ui5_cl_ai_app_228` path = `src/02/b10/z2ui5_cl_ai_app_228.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.21.0`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.HeaderFacetPattern`           name = `ObjectPageSectionShowTitle`          class = `z2ui5_cl_ai_app_200` path = `src/03/b02/z2ui5_cl_ai_app_200.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        ui5_only = abap_true
        is_post171 = abap_true
        notes = `POST-1.71: sap.uxap.ObjectPageSubSection.showTitle (showTitle='false' on the 'Order Details' and 'Products' subsections) exists only since UI5 1.77 - kept 1:1 (fidelity wins), so the app needs a UI5` &&
                 ` release >= 1.77 to render it. Also kept 1:1: the sap.m.Avatar control (since 1.73) with its displayShape (Square) and displaySize (L) properties, used in the snapped heading and header content. //` &&
                 ` NOTE: The two robot.png avatar assets use the sample's relative './test-resources/sap/uxap/images/robot.png' path; rewritten to the absolute sdk.openui5.org host` &&
                 ` ('https://sdk.openui5.org/test-resources/sap/uxap/images/robot.png') per the offline asset-URL rule. Same asset, literal src value only - structural-diff compares literal attribute names, not values.`
        post171 = `sap.uxap.ObjectPageSubSection.showTitle (showTitle='false' on the 'Order Details' and 'Products' subsections) exists only since UI5 1.77 - kept 1:1 (fidelity wins), so the app needs a UI5 release >=` &&
                 ` 1.77 to render it. Also kept 1:1: the sap.m.Avatar control (since 1.73) with its displayShape (Square) and displaySize (L) properties, used in the snapped heading and header content.` ) ).

    lv_text1 = `IMPROVISED: Named-model fold: the sample's whole point is the uxap:ModelMapping element inside a custom BlockBase (sample:ModelMappingBlock), which maps the external named model jsonModel (at` &&
               ` {jsonModel>/externalPath}, resolving to /Employee) onto the block's internal named model Contact, so {Contact>firstName}/{Contact>lastName} render John/Miller. abap2UI5 serves a single default model` &&
               ` - a second, independent ABAP-fed named model was DECLINED 2026-07-19 (pr/named-json-models, too complex: one serialized JSONModel per slot). So the two named models are folded into the one default` &&
               ` model: firstName/lastName are seeded at the default-model root and bound {/FIRSTNAME}/{/LASTNAME} (last-segment match with the original {Contact>firstName}/{Contact>lastName}). Consequently the` &&
               ` ModelMapping control (the sample entity, a pure model-mapping config with no visual output) is absent, the externalPath indirection is resolved statically to /Employee, and the ModelMappingBlock` &&
               ` BlockBase wrapper is inlined to its own view content: its forms:SimpleForm (core:Title + two Text) is rendered directly, since ObjectPageSubSection/block content is standard controls (CAPABILITIES`.
    lv_text1 = lv_text1 && ` BlockBase row, apps 161/178). ModelMappingBlock and ModelMapping are therefore both absent and a forms:SimpleForm/core:Title/Text are present in their place.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ModelMapping`                 name = `BoundModelMapping`                   class = `z2ui5_cl_ai_app_230` path = `src/03/b02/z2ui5_cl_ai_app_230.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: Block->content inlining (app 161/187 precedent, CAPABILITIES 'Custom BlockBase blocks in a sap.uxap.ObjectPageLayout'): the five blocks aggregations each hold the sample's own BlockBase` &&
               ` control sample:mySimpleBlock (xmlns:sample='sap.uxap.sample.AnchorBar.controller.blocks', ids bbt1-bbt5). A BlockBase is only a lazy-loading wrapper around a view; mySimpleBlock's view is an html:div` &&
               ` (style 'font-size: 0.875rem') wrapping a forms:SimpleForm (maxContainerCols=2, layout=ResponsiveGridLayout, editable=false) with one Label 'Content' / Text 'some content goes here...' pair. Since` &&
               ` ObjectPageSubSection.blocks accepts any sap.ui.core.Control, that SimpleForm is inlined 1:1 in each blocks aggregation - no custom JS control, thin frontend preserved. Lost with the wrapper: the five` &&
               ` mySimpleBlock controls with their ids, the html:div font-size:0.875rem styling (a core:HTML leaf cannot wrap controls, so the div is not reproducible around the form) and the block view root's own`.
    lv_text1 = lv_text1 && ` width='100%' attribute, which goes with the dropped mvc:View wrapper. // LIVE-TEST: ObjectPageDynamicHeaderTitle backgroundDesign='Solid' plus ObjectPageLayout backgroundDesignAnchorBar='Translucent'` &&
               ` (@since 1.58) are pure rendering properties - the port passes them through 1:1, but the rendered title / anchor-bar background was not verified in a running system.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageDynamicHeaderTitle` name = `ObjectPageHeaderBackgroundDesign`    class = `z2ui5_cl_ai_app_258` path = `src/03/b05/z2ui5_cl_ai_app_258.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: Block->content inlining (app 188/217 precedent, CAPABILITIES 'Custom BlockBase blocks in a sap.uxap.ObjectPageLayout'): the blocks / moreBlocks aggregations hold SharedBlocks BlockBase` &&
               ` controls - goals:GoalsBlock, personal:BlockPhoneNumber / BlockSocial / BlockAdresses / BlockMailing / PersonalBlockPart1 / PersonalBlockPart2, employment:BlockJobInfoPart1 / BlockJobInfoPart2 /` &&
               ` BlockJobInfoPart3 / BlockEmpDetailPart1 / BlockEmpDetailPart2 / BlockEmpDetailPart3. A BlockBase is only a lazy-loading wrapper around a view; each of these views is static (a forms:SimpleForm with` &&
               ` core:Title / Label / Text children, BlockJobInfoPart3 a layout:HorizontalLayout / layout:VerticalLayout tree), so every block view is inlined 1:1 into its aggregation and the block's own` &&
               ` class='sapUxAPObjectPageSubSectionAlignContent' is carried onto the inlined root control. Absent from the port as a result: the 13 BlockBase controls with their ids (goalsblock, phone, social,` &&
               ` adresses, mailing, part1, part2, jobinfopart1-3, empdetailpart1-3) and their BlockBase columnLayout='1' properties; the block views' own mvc:View roots (with their width='100%') are gone too. The`.
    lv_text1 = lv_text1 && ` block views' default namespace is sap.m, so their bare Label / Text / SimpleForm counts move to the port's m: / forms: prefixed controls. // POST-1.71: sap.m.Avatar is a control @since 1.73` &&
               ` (scope-of: OUT_OF_SCOPE for a sample entity, kept here because the sample's entity sap.uxap.ObjectPageDynamicHeaderTitle is in scope and 1:1 fidelity wins for members/controls used inside): two` &&
               ` Avatars (snappedHeading, headerContent) with displayShape='Square', initials='HF', displaySize='L'. Needs a UI5 runtime >= 1.73. // POST-1.71: sap.m.Title aggregation 'content' is @since 1.87 - the` &&
               ` original nests an m:Link inside two m:Title controls (Profile, Product Description) and the port keeps that nesting 1:1. Needs a UI5 runtime >= 1.87; below it the Link would not render. // LIVE-TEST:` &&
               ` percentValue='42%' is copied verbatim from the original although sap.m.ProgressIndicator.percentValue is typed float - UI5 parses the leading number, so this renders like the original, but the` &&
               ` rendered indicator plus the RatingIndicator value='4' / iconSize='16px' were not verified in a running system.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageDynamicHeaderTitle` name = `ObjectPageProgressRatingIndicators`  class = `z2ui5_cl_ai_app_259` path = `src/03/b05/z2ui5_cl_ai_app_259.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.Avatar is a control @since 1.73 (scope-of: OUT_OF_SCOPE for a sample entity, kept here because the sample's entity sap.uxap.ObjectPageDynamicHeaderTitle is in scope and 1:1 fidelity wins for` &&
                 ` members/controls used inside): two Avatars (snappedHeading, headerContent) with displayShape='Square', initials='HF', displaySize='L'. Needs a UI5 runtime >= 1.73. // sap.m.Title aggregation` &&
                 ` 'content' is @since 1.87 - the original nests an m:Link inside two m:Title controls (Profile, Product Description) and the port keeps that nesting 1:1. Needs a UI5 runtime >= 1.87; below it the Link` &&
                 ` would not render.` ) ).

    lv_text1 = `IMPROVISED: Block->content inlining (app 188/178/161 precedent, CAPABILITIES 'Custom BlockBase blocks in a sap.uxap.ObjectPageLayout'). The original blocks/moreBlocks aggregations each hold a custom` &&
               ` BlockBase control from the sample's SharedBlocks JS: goals:GoalsBlock (id goalsblock), personal:BlockPhoneNumber (id phone), personal:BlockSocial (id social), personal:BlockAdresses (id adresses),` &&
               ` personal:BlockMailing (id mailing, columnLayout=1), personal:PersonalBlockPart1 (id part1, columnLayout=1) and personal:PersonalBlockPart2 (id part2, columnLayout=1). A BlockBase is only a` &&
               ` lazy-loading wrapper around a view, and ObjectPageSubSection.blocks/moreBlocks accept any sap.ui.core.Control, so each block's rendered content (a sap.ui.layout.form.SimpleForm) is inlined directly` &&
               ` here as a form:SimpleForm holding its core:Title, m:Label and m:Text children. Consequently all seven block controls (GoalsBlock, BlockPhoneNumber, BlockSocial, BlockAdresses, BlockMailing,` &&
               ` PersonalBlockPart1, PersonalBlockPart2) are absent from the port and seven form:SimpleForm controls with their core:Title, m:Label and m:Text content are present in their place (the m:Label count`.
    lv_text1 = lv_text1 && ` rises from 3 to 15). The blocks carry no controller behaviour to port; the ObjectPageModel (employee.json) the controller loads is never bound by the view, so no default model is seeded.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageHeader`             name = `KPIObjectPageHeader`                 class = `z2ui5_cl_ai_app_217` path = `src/03/b02/z2ui5_cl_ai_app_217.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: Block->content inlining (app 161/178 precedent, CAPABILITIES 'Custom BlockBase blocks in a sap.uxap.ObjectPageLayout'): each of the 15 subsection blocks aggregations holds a custom` &&
               ` BlockBase control sample:mySimpleBlock (from the AnchorBar SharedBlocks JS, xmlns:sample='sap.uxap.sample.AnchorBar.controller.blocks', ids bbt1/bbt2/bbt3/bbt4/bbt5/b1..b10). A BlockBase is only a` &&
               ` lazy-loading wrapper around a view; mySimpleBlock's content is an html:div (font-size: 0.875rem) wrapping a forms:SimpleForm with a Label 'Content' + Text 'some content goes here...'. Since` &&
               ` ObjectPageSubSection.blocks accepts any sap.ui.core.Control, each mySimpleBlock is inlined directly as that SimpleForm. Consequently all 15 sample:mySimpleBlock controls (and their id attributes) are` &&
               ` absent from the port; the block's root mvc:View wrapper (its width='100%' attribute) is dropped together with its content-only inlining, and the html:div font-size wrapper is dropped - a control` &&
               ` cannot be wrapped by another control via core:HTML (core:HTML carries markup in a string attribute only), and the div is purely a cosmetic font-size wrapper with no data impact. The empty`.
    lv_text1 = lv_text1 && ` mySimpleBlock controller carries no behaviour to port. // NOTE: Namespace-representation difference: mySimpleBlock.view.xml declares its default xmlns as sap.m, so its Label and Text controls are` &&
               ` bare there; the single port view has a single default namespace (sap.uxap, matching the main sample view), so the inlined block's Label and Text carry the m: prefix (m:Label / m:Text) and the` &&
               ` SimpleForm keeps its forms: prefix. Control counts are prefix-sensitive in structural-diff, so the block's bare 'Label' and 'Text' read as missing while the port supplies m:Label / m:Text - an` &&
               ` unavoidable namespace-representation artifact of folding a sap.m-default fragment into a sap.uxap-default view (cheat-sheet 'multi-fragment differing-default-xmlns'). No output difference. // NOTE:` &&
               ` Static sample: no controller behaviour, no model, no events - only view_display. All members used (ObjectPageHeaderActionButton.text/type/icon/tooltip/hideText/hideIcon @since 1.26,` &&
               ` ObjectPageDynamicHeaderTitle @since 1.52, ObjectPageLayout.showTitleInHeaderContent/upperCaseAnchorBar, SimpleForm.maxContainerCols/layout/editable) are <= 1.71 - no POST_171 needed.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageHeaderActionButton` name = `ObjectPageHeaderActionButtons`       class = `z2ui5_cl_ai_app_239` path = `src/03/b03/z2ui5_cl_ai_app_239.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageHeaderContent`      name = `HeaderContent`                       class = `z2ui5_cl_ai_app_216` path = `src/03/b02/z2ui5_cl_ai_app_216.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.30`
        notes = `NOTE: The view is a 1:1 static rebuild - every ObjectStatus/ObjectNumber/Label/Text/ProgressIndicator/ObjectAttribute/Button/Tokenizer value is a literal, exactly as in the original` &&
                 ` ObjectPageHeaderContent view.xml. The sample's controller loads sap/uxap/sample/SharedJSONData/employee.json into a named 'ObjectPageModel', but the view never binds a single field from it (all` &&
                 ` header content is hard-coded in the XML), so the port carries no model_init - omitting a dead model changes nothing in the rendered view.` ) ).

    lv_text1 = `IMPROVISED: Block->content inlining (app 178/161 precedent, CAPABILITIES 'Custom BlockBase blocks in a sap.uxap.ObjectPageLayout'): the original blocks aggregations each hold a custom BlockBase` &&
               ` control goals:GoalsBlock (from the sample's SharedBlocks JS, xmlns:goals='sap.uxap.sample.SharedBlocks.goals'), used 4 times in the four ObjectPageSubSection blocks aggregations. A BlockBase is only` &&
               ` a lazy-loading wrapper around a view; GoalsBlock's rendered content is a sap.ui.layout.form.SimpleForm (editable='false' layout='ColumnLayout') holding three Label/Text goal pairs. Since` &&
               ` ObjectPageSubSection.blocks accepts any sap.ui.core.Control, each goals:GoalsBlock is inlined here as that SimpleForm (form:SimpleForm) with its m:Label/m:Text content - the whole ObjectPage renders` &&
               ` with the thin generic frontend, no custom JS control. Consequently all four goals:GoalsBlock controls are absent from the port and four form:SimpleForm controls (with their Label/Text children) are` &&
               ` present in their place. GoalsBlock has no controller behaviour to port.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageHeaderContent`      name = `ObjectPageHeaderContentPriorities`   class = `z2ui5_cl_ai_app_188` path = `src/03/b02/z2ui5_cl_ai_app_188.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.30`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: Block->content inlining (app 178/161 precedent, CAPABILITIES 'Custom BlockBase blocks in a sap.uxap.ObjectPageLayout'): the original blocks aggregations each hold a custom BlockBase` &&
               ` control blockcolor:BlockBlue (from the sample's SharedBlocks JS, xmlns:blockcolor='sap.uxap.sample.SharedBlocks'), used 4 times with the id attributes bbt1/bbt2/bbt3/bbt4. A BlockBase is only a` &&
               ` lazy-loading wrapper around a view; BlockBlue's rendered content is a single coloured div (<html:div style='height:4em; background-color: #A9EAFF ;'/>). Since ObjectPageSubSection.blocks accepts any` &&
               ` sap.ui.core.Control, each blockcolor:BlockBlue is inlined as a core:HTML leaf carrying that div in its content attribute - the whole ObjectPage renders with the thin generic frontend, no custom JS` &&
               ` control. Consequently all four blockcolor:BlockBlue controls (and their id attributes bbt1/bbt2/bbt3/bbt4) are absent from the port and four core:HTML controls are present in their place. The empty` &&
               ` BlockBlueCtrl controller (a no-op onParentBlockModeChange stub) carries no behaviour to port.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`             name = `AnchorBarNoPopover`                  class = `z2ui5_cl_ai_app_187` path = `src/03/b02/z2ui5_cl_ai_app_187.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: Block->content inlining (app 188/217 precedent, CAPABILITIES 'Custom BlockBase blocks in a sap.uxap.ObjectPageLayout'): the blocks / moreBlocks aggregations hold the SharedBlocks BlockBase` &&
               ` controls goals:GoalsBlock, personal:BlockPhoneNumber / BlockSocial / BlockAdresses / BlockMailing / PersonalBlockPart1 / PersonalBlockPart2. A BlockBase is only a lazy-loading wrapper around a view` &&
               ` and each of those views is a static forms:SimpleForm with core:Title / Label / Text children, so each block view is inlined 1:1 into its aggregation. Absent as a result: the seven BlockBase controls` &&
               ` with their ids (goalsblock, phone, social, adresses, mailing, part1, part2), BlockMailing's BlockBase columnLayout='1', and the block views' own mvc:View roots with their width='100%'. // NOTE: The` &&
               ` controller's three JSONModels (SharedJSONData/employee.json as 'ObjectPageModel', an inline 'buttons' model with text/icon, SharedJSONData/products.json as the default OneWay model) are not` &&
               ` reproduced: no control in this sample's view or in any of its inlined block views binds against them - every text is a literal. The port therefore has no model at all (no model_init), which renders`.
    lv_text1 = lv_text1 && ` identically. // LIVE-TEST: preserveHeaderStateOnScroll='true' (@since 1.52) is the whole point of the sample - the header content staying expanded while scrolling on desktop. The property is passed` &&
               ` through 1:1 but the scroll behaviour was not verified in a running system.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`             name = `ObjectPageHeaderExpanded`            class = `z2ui5_cl_ai_app_260` path = `src/03/b05/z2ui5_cl_ai_app_260.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.26`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: Block->content inlining (app 188/217 precedent, CAPABILITIES 'Custom BlockBase blocks in a sap.uxap.ObjectPageLayout'): the blocks / moreBlocks aggregations hold SharedBlocks BlockBase` &&
               ` controls - goals:GoalsBlock, personal:BlockPhoneNumber / BlockSocial / BlockAdresses / BlockMailing / PersonalBlockPart1 / PersonalBlockPart2, employment:BlockJobInfoPart1 / BlockJobInfoPart2 /` &&
               ` BlockJobInfoPart3 / BlockEmpDetailPart1 / BlockEmpDetailPart2 / BlockEmpDetailPart3 / EmploymentBlockJob, connections:ConnectionsBlock. Each is only a lazy-loading wrapper around a view, so every` &&
               ` block view is inlined 1:1 into its aggregation (forms:SimpleForm with core:Title / Label / Text, a layout:HorizontalLayout / layout:VerticalLayout tree, the layout:Grid / layout:GridData tree of` &&
               ` EmploymentBlockJobCollapsed, and the six m:Panel / m:VBox / m:Image of ConnectionsBlock). Absent as a result: the 14 BlockBase controls with their ids and their BlockBase columnLayout='1' properties,` &&
               ` and the block views' own mvc:View roots. // IMPROVISED: Named-model fold (app 230 precedent): EmploymentBlockJob and ConnectionsBlock each carry six uxap:ModelMapping elements mapping an external`.
    lv_text1 = lv_text1 && ` model onto the internal models emp1>..emp6> (/Employee/0..5). abap2UI5 serves one default model, so the twelve ModelMapping config controls are gone and the six employee records are seeded as` &&
               ` default-model root fields (emp1_name/_job/_picture .. emp6_*) bound via client->_bind. EmploymentBlockJob is additionally a two-view BlockBase (Collapsed / Expanded with showSubSectionMore='true');` &&
               ` only the Collapsed view (employees 1-2) is inlined - the Expanded view with employees 3-6 and the more/less toggle are lost. // NOTE: The ModelMapping elements in this sample name` &&
               ` externalModelName='data' while the controller registers the JSONModel as 'ObjectPageModel' - upstream those block labels therefore resolve to nothing. The port seeds the evidently intended` &&
               ` SharedJSONData/HRData.json /Employee rows (Michael Adams / Scrum Master, John Miller / Product Owner, Richard Wilson / Ux Designer, Julie Armstrong / Quality Engineer, Denise Smith / Team Member,` &&
               ` Richard Adams / Team Member) and the person.png picture, i.e. it renders the data the sample means rather than the empty labels the name mismatch produces. // IMPROVISED: onNavigate's`.
    lv_text1 = lv_text1 && ` setSelectedSection(null): sap.uxap.ObjectPageLayout.selectedSection is an ASSOCIATION, so it cannot be data-bound - the reset must go through the frontend action. An empty/null association argument` &&
               ` is not transportable through control_by_id either, so the NAVIGATE round-trip (the NavContainer's navigate event, transporting ${$parameters>/toId}) issues follow_up_action( control_by_id,` &&
               ` ObjectPageLayout / setSelectedSection / 'goals' ) - the id of the first section, which is exactly what UI5's own _adjustSelectedSectionByUXRules falls back to when the association is empty. The` &&
               ` checkbox that guards the reset is two-way bound ({/RESET_CHECK}, seeded true like the original selected='true'), so the backend can read it without touching the DOM. // POST-1.71: sap.m.Avatar is a` &&
               ` control @since 1.73 (kept for 1:1 fidelity, the sample entity sap.uxap.ObjectPageLayout is in scope): the snappedHeading avatar and the headerContent avatar (displaySize='L'). Needs a UI5 runtime >=` &&
               ` 1.73. // LIVE-TEST: The page navigation is roundtrip-free _event_client( control_by_id, navigationContainer / to / page1|page2 ) - the client-side equivalent of the controller's _navTo`.
    lv_text1 = lv_text1 && ` (oNavContainer.to(oPage)); 'to' is whitelisted in CONTROL_METHODS. Neither the navigation, the NAVIGATE round-trip nor the setSelectedSection follow-up was verified in a running system. // NOTE: The` &&
               ` Avatar / Image src values point at the sdk.openui5.org host (imageID_275314.png, linkedin.png, Twitter.png, person.png) per the offline asset-URL rule; the original and HRData.json use the relative` &&
               ` ./test-resources path.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`             name = `ObjectPageResetSelectedSection`      class = `z2ui5_cl_ai_app_263` path = `src/03/b05/z2ui5_cl_ai_app_263.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.26`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.Avatar is a control @since 1.73 (kept for 1:1 fidelity, the sample entity sap.uxap.ObjectPageLayout is in scope): the snappedHeading avatar and the headerContent avatar (displaySize='L'). Needs` &&
                 ` a UI5 runtime >= 1.73.` ) ).

    lv_text1 = `POST-1.71: sap.uxap.ObjectPageLayout.breakpointChange (@since 1.147, incl. its currentRange / currentWidth parameters) is the whole point of this sample and is wired 1:1 as a view attribute (an added` &&
               ` attr - the original attaches it imperatively in onInit via attachBreakpointChange): BREAKPOINT_CHANGE transports ${$parameters>/currentRange} and ${$parameters>/currentWidth}, the backend maps` &&
               ` Phone->M / Tablet->L / Desktop and DesktopExtraLarge->XL into the two-way bound Avatar displaySize ({/AVATAR_SIZE}, an added attribute on both Avatars, seeded L like the controller's default branch)` &&
               ` and toasts 'Media Range: <range> (<width>px) / Avatar Size: <size>' exactly like onBreakpointChange. Same wiring as app 244 (the sap.f.DynamicPage twin of this sample). Requires a UI5 release >=` &&
               ` 1.147; on older releases the event never fires and both Avatars keep the seeded L. // POST-1.71: sap.m.Avatar is a control @since 1.73 (kept for 1:1 fidelity, the sample entity` &&
               ` sap.uxap.ObjectPageLayout is in scope): the snappedHeading avatar (id snappedAvatar) and the headerContent avatar (id headerAvatar). Needs a UI5 runtime >= 1.73. // LIVE-TEST: showFooter is two-way`.
    lv_text1 = lv_text1 && ` bound ({/SHOW_FOOTER}, seeded false = the original's ObjectPageLayout default, since the sample sets no showFooter attribute) and the Toggle Footer button flips it on a round-trip (view_model_update)` &&
               ` - the faithful abap2UI5 form of the controller's setShowFooter(!getShowFooter()); a scalar literal -> binding is not a structural diff. The two breadcrumb Link presses and the editHeaderButtonPress` &&
               ` raise client-composed MessageToasts via _event_client control_global MESSAGE_TOAST (roundtrip-free, apps 005/060/244). Footer round-trip, toast wiring and the editHeaderButtonPress attribute are` &&
               ` unverified in a running system. // NOTE: Both Avatar src values point at the sdk.openui5.org host (https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_275314.png) per the offline asset-URL` &&
               ` rule; the original uses the relative ./test-resources path. Literal src values are not compared by structural-diff.`.
    lv_text2 = `sap.uxap.ObjectPageLayout.breakpointChange (@since 1.147, incl. its currentRange / currentWidth parameters) is the whole point of this sample and is wired 1:1 as a view attribute (an added attr - the` &&
               ` original attaches it imperatively in onInit via attachBreakpointChange): BREAKPOINT_CHANGE transports ${$parameters>/currentRange} and ${$parameters>/currentWidth}, the backend maps Phone->M /` &&
               ` Tablet->L / Desktop and DesktopExtraLarge->XL into the two-way bound Avatar displaySize ({/AVATAR_SIZE}, an added attribute on both Avatars, seeded L like the controller's default branch) and toasts` &&
               ` 'Media Range: <range> (<width>px) / Avatar Size: <size>' exactly like onBreakpointChange. Same wiring as app 244 (the sap.f.DynamicPage twin of this sample). Requires a UI5 release >= 1.147; on older` &&
               ` releases the event never fires and both Avatars keep the seeded L. // sap.m.Avatar is a control @since 1.73 (kept for 1:1 fidelity, the sample entity sap.uxap.ObjectPageLayout is in scope): the` &&
               ` snappedHeading avatar (id snappedAvatar) and the headerContent avatar (id headerAvatar). Needs a UI5 runtime >= 1.73.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`             name = `ObjectPageResponsiveAvatar`          class = `z2ui5_cl_ai_app_262` path = `src/03/b05/z2ui5_cl_ai_app_262.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26`
        is_post171 = abap_true
        notes = lv_text1
        post171 = lv_text2 ) ).

    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`             name = `ObjectPageSubSection`                class = `z2ui5_cl_ai_app_116` path = `src/03/b01/z2ui5_cl_ai_app_116.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26`
        notes = `IMPROVISED: Breadth-probe: a minimal sap.uxap.ObjectPageLayout (header title + section + two subsections). The original's blocks are custom JS view controls (sample:MultiViewBlock, 8 instances)` &&
                 ` replaced with sap.m.Text content, and the third ObjectPageSubSection ('Expanded by default') plus both moreBlocks aggregations are dropped entirely. Review 2026-07-27: the original 'not expressible` &&
                 ` in the declarative builder' rationale is refuted by the BlockBase-inlining technique (CAPABILITIES 'Custom BlockBase blocks', apps 161/178) - a BlockBase view's content inlines into blocks; only` &&
                 ` MultiViewBlock's per-mode view switching remains a genuine open point. Needs rework toward the documented technique.` ) ).

    lv_text1 = `IMPROVISED: Block->content inlining (app 188/217 precedent, CAPABILITIES 'Custom BlockBase blocks in a sap.uxap.ObjectPageLayout'): the blocks / moreBlocks aggregations hold SharedBlocks BlockBase` &&
               ` controls - goals:GoalsBlock, personal:BlockAdresses / BlockPhoneNumber / BlockSocial / BlockMailing / PersonalBlockPart1 / PersonalBlockPart2, employment:BlockJobInfoPart1 / BlockJobInfoPart2 /` &&
               ` BlockJobInfoPart3 / BlockEmpDetailPart1 / BlockEmpDetailPart2 / BlockEmpDetailPart3 / EmploymentBlockJob. Each BlockBase is only a lazy-loading wrapper around a static view (forms:SimpleForm with` &&
               ` core:Title / Label / Text, or a layout:HorizontalLayout / layout:VerticalLayout tree), so every block view is inlined 1:1 into its aggregation. Absent as a result: the 13 BlockBase controls with` &&
               ` their ids, and the block views' own mvc:View roots with their width='100%'. // IMPROVISED: EmploymentBlockJob is a two-view BlockBase (Collapsed / Expanded, selected by the block mode, with` &&
               ` showSubSectionMore='true' offering the toggle) whose views bind six internal named models emp1>..emp6> that six uxap:ModelMapping elements map onto ObjectPageModel>/Employee/0..5. abap2UI5 serves one`.
    lv_text1 = lv_text1 && ` default model and has no BlockBase mode toggle, so: the Collapsed view (the block's initial state, two employees - a layout:Grid / layout:VerticalLayout tree with layout:GridData layoutData) is` &&
               ` inlined, and emp1>/emp2> are folded onto default-model root fields bound via client->_bind (app 230 precedent). Lost: the six ModelMapping config controls, the Expanded view with employees 3-6, the` &&
               ` more/less toggle behind showSubSectionMore, and the mapping indirection - the two records are resolved statically to HRData.json /Employee/0 (Michael Adams, Scrum Master) and /Employee/1 (John` &&
               ` Miller, Product Owner). // POST-1.71: sap.m.Avatar is a control @since 1.73 (kept for 1:1 fidelity, the sample entity sap.uxap.ObjectPageLayout is in scope): src='sap-icon://picture' in the` &&
               ` snappedHeading and in the headerContent (displaySize='L'). Needs a UI5 runtime >= 1.73. // NOTE: The controller's three MessageToast handlers (handleLink1Press, handleLink2Press, handleEditBtnPress)` &&
               ` are dead code in this sample - the view wires no press event and sets no showEditHeaderButton, so nothing can reach them. The port therefore has no on_event method, which is behaviour-identical. //`.
    lv_text1 = lv_text1 && ` LIVE-TEST: subSectionLayout='TitleOnLeft' is the point of the sample (subsection titles rendered in a left column instead of above the content). The property is passed through 1:1 but the resulting` &&
               ` layout was not verified in a running system.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`             name = `ObjectPageTitleOnLeft`               class = `z2ui5_cl_ai_app_261` path = `src/03/b05/z2ui5_cl_ai_app_261.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.26`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.Avatar is a control @since 1.73 (kept for 1:1 fidelity, the sample entity sap.uxap.ObjectPageLayout is in scope): src='sap-icon://picture' in the snappedHeading and in the headerContent` &&
                 ` (displaySize='L'). Needs a UI5 runtime >= 1.73.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`             name = `SingleView`                          class = `z2ui5_cl_ai_app_161` path = `src/03/b02/z2ui5_cl_ai_app_161.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26`
        notes = `IMPROVISED: Wall-break for sap.uxap: the original blocks aggregation holds a custom BlockBase control (blockcolor:BlockBlue from the sample's SharedBlocks JS). A BlockBase is only a lazy-loading` &&
                 ` wrapper around a view; its content (a single coloured div) is inlined here as core:HTML, since ObjectPageSubSection.blocks accepts any sap.ui.core.Control. This removes the need for a custom JS` &&
                 ` control - the whole uxap ObjectPage renders with the thin generic frontend. The blockcolor:BlockBlue control is therefore absent and a core:HTML is present in its place.` ) ).

    lv_text1 = `IMPROVISED: Block->content inlining (app 178/161 precedent, CAPABILITIES 'Custom BlockBase blocks in a sap.uxap.ObjectPageLayout'): the original blocks aggregations each hold a custom BlockBase` &&
               ` control (blockcolor:BlockBlueT1, blockcolor:BlockBlueT2, blockcolor:BlockBlueT3, blockcolor:BlockBlueT4, blockcolor:BlockBlueT5, from the sample's SharedBlocks JS,` &&
               ` xmlns:blockcolor='sap.uxap.sample.SharedBlocks'), used once each with ids bbt1/bbt2/bbt3/bbt4/bbt5. A BlockBase is only a lazy-loading wrapper around a view; each BlockBlueTn's rendered content is a` &&
               ` single coloured div (<html:div style='height:auto;min-height:4em; background-color: #A9EAFF ;line-height: 4em;'>...explanatory text...</html:div>). Since ObjectPageSubSection.blocks accepts any` &&
               ` sap.ui.core.Control, each blockcolor:BlockBlueTn is inlined as a core:HTML leaf carrying that div in its content attribute - the whole ObjectPage renders with the thin generic frontend, no custom JS` &&
               ` control. Consequently all five blockcolor:BlockBlueT1..T5 controls (and their id attributes) are absent from the port and five core:HTML controls are present in their place; the`.
    lv_text1 = lv_text1 && ` xmlns:blockcolor='sap.uxap.sample.SharedBlocks' declaration is dropped and xmlns:core='sap.ui.core' added. The block sources are not archived into ui5/ (matching the scaffolder), read from the` &&
               ` checkout's SharedBlocks/BlockBlueTn.view.xml.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageSection`            name = `ObjectPageSection`                   class = `z2ui5_cl_ai_app_184` path = `src/03/b02/z2ui5_cl_ai_app_184.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The ObjectNumber state binding differs: the original binds state="{path:'WeightMeasure', formatter:'.weightState'}" to a controller formatter (parseFloat + Success/Warning/Error thresholds).` &&
               ` That is business logic, so - abap2UI5 being a thin frontend - the weightState is computed in ABAP model_init into a WEIGHTSTATE field and bound state="{WEIGHTSTATE}", not via a frontend formatter.` &&
               ` Visually 1:1 with the original (apps 009/010/022/092 precedent). No core:require is dropped - the original registers the formatter as a controller method, not on the view root. // NOTE: The default` &&
               ` JSONModel (products.json) is folded into the one default model: the Table items path {/ProductCollection} and the row bindings ({SupplierName}, Currency parts:[{path:'Price'},...]) keep the same leaf` &&
               ` names, so structural-diff matches 0 diffs. Full 123-row ProductCollection inlined verbatim; only the columns the view binds are kept as fields. The Price Currency composite type binding is kept 1:1` &&
               ` (price TYPE p) - standard client-side type, no version issue.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageSubSection`         name = `ObjectPageSubSectionHiddenTitle`     class = `z2ui5_cl_ai_app_245` path = `src/03/b04/z2ui5_cl_ai_app_245.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: Block->content inlining (app 161 precedent, CAPABILITIES 'Custom BlockBase blocks in a sap.uxap.ObjectPageLayout'): the original blocks aggregations each hold a custom BlockBase control` &&
               ` blockcolor:BlockBlue (from the sample's SharedBlocks JS, xmlns:blockcolor='sap.uxap.sample.SharedBlocks'), used 3 times (ids b1/b2/b3). A BlockBase is only a lazy-loading wrapper around a view;` &&
               ` BlockBlue's rendered content is a single coloured div (<html:div style='height:4em; background-color: #A9EAFF ;'/>). Since ObjectPageSubSection.blocks accepts any sap.ui.core.Control, each` &&
               ` blockcolor:BlockBlue is inlined as a core:HTML leaf carrying that div in its content attribute - the whole ObjectPage renders with the thin generic frontend, no custom JS control. Consequently all` &&
               ` three blockcolor:BlockBlue controls (and their id attributes) are absent from the port and three core:HTML controls are present in their place. The empty BlockBlueCtrl controller (a no-op` &&
               ` onParentBlockModeChange stub) carries no behaviour to port.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageSubSection`         name = `ObjectPageSubSectionWithActions`     class = `z2ui5_cl_ai_app_178` path = `src/03/b02/z2ui5_cl_ai_app_178.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26`
        notes = lv_text1 ) ).

  ENDMETHOD.


  METHOD link_press.

    " the press wire of the popover's four link buttons: open an EXTERNAL url in
    " a new tab, entirely on the client. cs_event-open_new_tab is same-origin
    " only (isValidRedirectURL) and three of the four targets live on
    " sdk.openui5.org / github.com, so the redirect goes through the URLHELPER
    " frontend action, whose REDIRECT takes a URL/NEW_WINDOW object-literal
    " t_arg - NEW_WINDOW true is what target="_blank" did on the former Links.
    result = client->_event_client( val   = client->cs_event-urlhelper
                                    t_arg = VALUE #( ( `REDIRECT` ) ( |\{ URL: '{ url }', NEW_WINDOW: true \}| ) ) ).

  ENDMETHOD.

ENDCLASS.
