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
"! Both popovers are backend round-trips, but the row's press carries only its
"! CLASS: the generation notes, the live-check text and the four reference URLs
"! are looked up from the catalog in on_event, so they never enter the bound
"! model. Only bound columns are public state, which keeps the persisted draft
"! (and the model JSON of every render) small - the in-browser demo re-parses
"! that draft on every round-trip.
"! The search field above the table filters all rows by a
"! substring over the text columns (module, control, since, sample,
"! class) only, and each sortable column header carries ascending/
"! descending sort icons - both run entirely on the frontend
"! (cs_event-binding_call via _event_client, no server round-trip). Do not edit
"! by hand - regenerate with scripts/generate-overview.mjs
CLASS z2ui5_cl_dmo_app_overview DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the BOUND row - only what the table renders, sorts or filters on. Every
    " public attribute is part of the app state the framework persists as a
    " draft and re-parses on the next round-trip, so the heavy per-port text
    " (generation notes, live-check note, the four reference URLs) is
    " deliberately NOT here: it is looked up server-side from the catalog when
    " a popover asks for it (see on_event). Keeping it in the model made the
    " draft ~578 kB and every round-trip of the transpiled in-browser demo took
    " ~30 s in the XML parse (which is quadratic there); the split brings the
    " draft to ~199 kB and the round-trip to ~3-4 s on the same machine.
    TYPES:
      BEGIN OF ty_s_row,
        module    TYPE string,
        ctrl_name TYPE string,
        name      TYPE string,
        class     TYPE string,
        start_url TYPE string,
        has_check TYPE abap_bool,
        has_notes TYPE abap_bool,
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
      END OF ty_s_row.
    TYPES ty_t_row TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

    DATA t_app TYPE ty_t_row.
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
    " the full catalog row - the generated facts plus everything derived from
    " them. It lives only in local variables (get_catalog is a METHOD, never an
    " attribute), so none of it reaches the persisted app state.
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

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS row_of
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE ty_s_app.
    METHODS derive
      CHANGING
        app TYPE ty_s_app.
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


CLASS z2ui5_cl_dmo_app_overview IMPLEMENTATION.

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
        " the four link buttons for the pressed row, opened in a popover
        " anchored to the button (arg 2). Only the row KEY travels through the
        " client (arg 1, `${CLASS}`) - the URLs are rebuilt here from the
        " catalog, so they never sit in the bound model and never bloat the draft.
        DATA(ls_link) = row_of( client->get_event_arg( ) ).
        DATA(lv_api)  = ls_link-api_url.
        DATA(lv_js)   = ls_link-js_url.
        DATA(lv_ui5)  = ls_link-ui5_url.
        DATA(lv_abap) = ls_link-abap_url.

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
                                 by_id = client->get_event_arg( 2 ) ).

      WHEN `INFO`.
        " everything the generator knows ABOUT the port (as opposed to where it
        " points): the live-check status, the members that need a UI5 release
        " newer than 1.71, and the deviation notes. Own popover behind the info
        " button, anchored to it (arg 2); the button only renders on a row that
        " carries at least one of the three. Like LINKS, only the row key
        " travels (arg 1) - the texts are read from the catalog here.
        DATA(ls_info)    = row_of( client->get_event_arg( ) ).
        DATA(lv_checked) = ls_info-checked.
        DATA(lv_post171) = ls_info-post171.
        DATA(lv_notes)   = ls_info-notes.

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
                                 by_id = client->get_event_arg( 2 ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD row_of.

    " the catalog row behind a pressed table row, by its class name (the only
    " thing the press event carries). READ TABLE, not a table expression: the
    " 702 downport turns `tab[ … ]` into a raise the transpiled runtime maps to
    " an uncatchable ASSERT.
    DATA(catalog) = get_catalog( ).
    READ TABLE catalog INTO result WITH KEY class = val.
    IF sy-subrc <> 0.
      CLEAR result.
      RETURN.
    ENDIF.

    derive( CHANGING app = result ).

  ENDMETHOD.


  METHOD view_display.

    DATA(catalog) = get_catalog( ).
    CLEAR t_app.
    LOOP AT catalog ASSIGNING FIELD-SYMBOL(<app>).

      derive( CHANGING app = <app> ).

      " only the columns the table renders, sorts or filters on go into the
      " bound model - the notes, the live-check text and the four URLs stay in
      " the catalog and are fetched per row in on_event (see ty_s_row)
      APPEND VALUE #( module        = <app>-module
                      ctrl_name     = <app>-ctrl_name
                      name          = <app>-name
                      class         = <app>-class
                      start_url     = <app>-start_url
                      has_check     = <app>-has_check
                      has_notes     = <app>-has_notes
                      has_p171      = <app>-has_p171
                      since         = <app>-since
                      since_post171 = <app>-since_post171
                      ui5_only      = <app>-ui5_only
                      is_post171    = <app>-is_post171
                      is_deprecated = <app>-is_deprecated
                      dep_text      = <app>-dep_text
                      ctrl_html     = <app>-ctrl_html
                      score         = <app>-score
                      score_tip     = <app>-score_tip
                      filter        = <app>-filter ) TO t_app.

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
                                        " only the row KEY travels (the four URLs are rebuilt
                                        " server-side in on_event, so they stay out of the model
                                        " and out of the persisted draft), plus the button's own
                                        " runtime id as the popover anchor
                                        )->a( n = `press`   v = client->_event( val = `LINKS` t_arg = VALUE #(
                                            ( `${CLASS}` ) ( `$event.oSource.sId` ) ) )
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
                                            ( `${CLASS}` ) ( `$event.oSource.sId` ) ) )

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


  METHOD derive.

    " everything a catalog row does not carry as a generated fact: the bare
    " control name, the four reference links, the start URL, the three
    " has-something flags, the control's display markup and the search blob.
    " Called per row when the table is built, and for the single row a popover
    " asks about (row_of) - so the links exist without living in the model.
    DATA(libpath) = replace( val = app-module
                             sub = `.`
                             with = `/`
                             occ = 0 ).

    " display only the bare control, without its namespace (sap.f.GridList -> GridList)
    DATA(dot) = find( val = app-control sub = `.` occ = -1 ).
    app-ctrl_name = COND #( WHEN dot >= 0 THEN substring( val = app-control off = dot + 1 ) ELSE app-control ).

    " the three reference links point into OpenUI5 - API reference, sample
    " source, live runner - so they only exist for a library OpenUI5 ships.
    " A ui5_only row (control not in the OpenUI5 checkout) has none of the
    " three there: leaving them built would hand out four links of which three
    " 404, and the commercial host is not an option (pattern-lint
    " commercial-ui5-host).
    " They stay empty and the popover renders only what resolves - the ABAP
    " class link is repository-local and always correct
    IF app-ui5_only = abap_false.
      app-api_url = |https://sdk.openui5.org/api/{ app-control }|.
      app-js_url  = |https://github.com/SAP/openui5/tree/master/src/{ app-module }| &&
                    |/test/{ libpath }/demokit/sample/{ app-name }|.
      app-ui5_url = |https://sdk.openui5.org/resources/sap/ui/documentation/sdk/index.html| &&
                    |?sap-ui-xx-sample-id={ app-module }.sample.{ app-name }| &&
                    |&sap-ui-xx-sample-lib={ app-module }|.
    ENDIF.
    app-abap_url  = |https://github.com/abap2UI5/ai-demokit/blob/main/{ app-path }|.
    app-start_url = |{ client->get( )-s_config-origin }{ client->get( )-s_config-pathname }| &&
                    |?app_start={ to_upper( app-class ) }|.
    app-has_check = xsdbool( app-checked IS NOT INITIAL ).
    app-has_notes = xsdbool( app-notes IS NOT INITIAL ).
    app-has_p171  = xsdbool( app-post171 IS NOT INITIAL ).

    " control name: struck through when the control is deprecated, otherwise
    " plain - never coloured (carried as FormattedText htmlText so the
    " strikethrough can vary per row); a plain control is rendered as-is
    app-ctrl_html = COND string(
        WHEN app-dep_text IS NOT INITIAL
        THEN |<span style="text-decoration:line-through">{ app-ctrl_name }</span>|
        ELSE app-ctrl_name ).

    " one blob per row, bound as the FILTER column that the table search's
    " client-side Contains filter (binding_call) matches against. Only the
    " VISIBLE text columns feed it - Module, Control (bare name), Since,
    " Sample, abap2UI5 (class) - so a query like "Date" no longer
    " matches hidden text buried in the notes/checked/post-1.71 fields
    app-filter = app-module && ` ` && app-ctrl_name && ` ` &&
                 app-since  && ` ` && app-name      && ` ` &&
                 app-class.

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
      ( module = `sap.f`              control = `sap.f.Card`                            name = `Card`                                          class = `z2ui5_cl_dmo_app_117` path = `src/04/b01/z2ui5_cl_dmo_app_117.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.64`
        notes = `NOTE: **Rebuilt 1:1 on 2026-08-05** - it was a breadth probe that showed one simplified card. Both cards of the sample are there now: the booking card with its two sorted city ComboBoxes, the` &&
                 ` DatePicker and the Book button (whose fixed explanation toast is composed on the client), and the whole second card - the revenue List with its CustomListItem template, Title/Text and the` &&
                 ` ObjectStatus state. The two named models fold into the one default model (cities> -> T_CITIES, products> -> T_PRODUCTS, last path segment identical) and the ComboBox sorter rides along as a raw` &&
                 ` binding-info string. The port has NO structural difference from the original left, so its structural_diff skip is gone - the gate reported it stale, which is what that ratchet is for.` ) ).

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
      ( module = `sap.f`              control = `sap.f.DynamicPage`                     name = `DynamicPageFreeStyle`                          class = `z2ui5_cl_dmo_app_170` path = `src/04/b07/z2ui5_cl_dmo_app_170.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.42`
        notes = lv_text1 ) ).

    lv_text1 = `POST-1.71: sap.m.Avatar (control @since 1.73, incl. its src/class/press members) is used 1:1 in snappedContent and the DynamicPageHeader; needs UI5 >= 1.73. DynamicPage is the in-scope headline` &&
               ` control (@1.42); Avatar is a secondary control kept 1:1 per the post-1.71 member policy. // POST-1.71: sap.f.DynamicPage.breakpointChange (@since 1.147, incl. its currentRange/currentWidth` &&
               ` parameters) is the whole point of this sample and is wired 1:1 since 2026-07-30 as a view attribute (an added attr - the original attaches it imperatively in onInit via attachBreakpointChange):` &&
               ` BREAKPOINT_CHANGE transports ${$parameters>/currentRange} and ${$parameters>/currentWidth}, the backend maps Phone->M / Tablet->L / else XL into the two-way bound Avatar displaySize ({/AVATAR_SIZE},` &&
               ` an added attribute on both Avatars, seeded XL) and toasts Media Range: <range> (<width>px) exactly like onBreakpointChange. @since verified fork-openui5/src/sap.f/src/sap/f/DynamicPage.js:315.` &&
               ` Requires a UI5 release >= 1.147; on older releases the event never fires and the Avatars keep the seeded XL (the property gate is blind to sap.f event params). // NOTE: live-verified 2026-08-04`.
    lv_text1 = lv_text1 && ` (nightly e2e interaction): showFooter is two-way bound ({/SHOW_FOOTER}, default true) and the Toggle Footer button flips it on a round-trip (view_model_update) - the faithful abap2UI5 form of the` &&
               ` controller's setShowFooter(!getShowFooter()); the scalar literal showFooter="true" -> binding is not a structural diff. The Home/Examples/Avatar presses raise client-composed MessageToasts via` &&
               ` _event_client control_global MESSAGE_TOAST (roundtrip-free, apps 005/060). Both the footer round-trip and the toast wiring are unverified in a running system. // NOTE: The two Avatar src values point` &&
               ` at the sdk.openui5.org host (https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_275314.png) per the offline asset-URL rule; the original uses the relative ./test-resources path. Literal` &&
               ` src values are not compared by structural-diff.`.
    lv_text2 = `sap.m.Avatar (control @since 1.73, incl. its src/class/press members) is used 1:1 in snappedContent and the DynamicPageHeader; needs UI5 >= 1.73. DynamicPage is the in-scope headline control (@1.42);` &&
               ` Avatar is a secondary control kept 1:1 per the post-1.71 member policy. // sap.f.DynamicPage.breakpointChange (@since 1.147, incl. its currentRange/currentWidth parameters) is the whole point of this` &&
               ` sample and is wired 1:1 since 2026-07-30 as a view attribute (an added attr - the original attaches it imperatively in onInit via attachBreakpointChange): BREAKPOINT_CHANGE transports` &&
               ` ${$parameters>/currentRange} and ${$parameters>/currentWidth}, the backend maps Phone->M / Tablet->L / else XL into the two-way bound Avatar displaySize ({/AVATAR_SIZE}, an added attribute on both` &&
               ` Avatars, seeded XL) and toasts Media Range: <range> (<width>px) exactly like onBreakpointChange. @since verified fork-openui5/src/sap.f/src/sap/f/DynamicPage.js:315. Requires a UI5 release >= 1.147;` &&
               ` on older releases the event never fires and the Avatars keep the seeded XL (the property gate is blind to sap.f event params).`.
    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.DynamicPage`                     name = `DynamicPageResponsiveAvatar`                   class = `z2ui5_cl_dmo_app_244` path = `src/04/b10/z2ui5_cl_dmo_app_244.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
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
    lv_text1 = lv_text1 && ` Card/NumericHeader/GenericTag members used are <= 1.71. // NOTE: live-verified 2026-08-04 (nightly e2e interaction): unverified in a running system: that the Card popover opens anchored to the` &&
               ` pressed GenericTag (popover_display by_id = $event.oSource.sId), and that the Toggle Footer round-trip flips showFooter and reveals/hides the DynamicPage footer. **e2e-verified 2026-07-30**` &&
               ` (transpiled-framework interaction, scripts/e2e-smoke.mjs): the GenericTag press opens the Card popover with the NumericHeader rendering ('Sales Revenue'; asserted on text - the popover box measures` &&
               ` empty headless); the layoutData-button variant is the identical wire.`.
    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.DynamicPage`                     name = `DynamicPageWithStickySubheader`                class = `z2ui5_cl_dmo_app_238` path = `src/04/b09/z2ui5_cl_dmo_app_238.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
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
      ( module = `sap.f`              control = `sap.f.FlexibleColumnLayout`            name = `FlexibleColumnLayoutSimple`                    class = `z2ui5_cl_dmo_app_234` path = `src/04/b08/z2ui5_cl_dmo_app_234.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.46`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The original binds two named models inside the cards (cities> for the ComboBoxes, products> for the revenue List); abap2UI5 keeps one default model, so those bind directly ({cities>/cities} ->` &&
               ` {/CITIES}, {products>/productItems} -> {/PRODUCTITEMS}, prefix dropped, last segment identical). **Sidecar corrected 2026-08-05**: the rest of the text still described the port before its rework and` &&
               ` called the handlers STATIC toasts. They are not: the three property Switches are two-way bound to the GridContainer's snapToRow / allowDenseFill / inlineBlockLayout (prefer-a-bindable-property, the` &&
               ` app-007/048/128 pattern), columnsChange round-trips its columns parameter, and the GenericTile / f:Card header presses compose their toast from $event.oSource.getMetadata().getName() instead of a` &&
               ` fixed string. What stays dropped: the RevealGrid toggle (a sample-local JS debug overlay, same as apps 145/222/271) The onInit attachLayoutChange handler that swaps sapUiSmallMargin/sapUiTinyMargin`.
    lv_text1 = lv_text1 && ` on the narrow breakpoints was dropped for the same reason until 2026-08-05 - a class swap on a LIVE breakpoint change, for which no wire existed (the device> model was a snapshot: it wrapped the live` &&
               ` sap.ui.Device object but never notified its bindings). The framework now refreshes it on resize/rotation and publishes the current media range as {device>/media/range} (pr/live-device-model,` &&
               ` implemented upstream), so the class is a plain expression binding on the GridContainer - ``{= ${device>/media/range} === 'Phone' ? 'sapUiTinyMargin' : 'sapUiSmallMargin' }`` - and follows a live` &&
               ` resize with no wire and no round-trip, which is what the original's handler does. The three-way layoutXS/layoutS split folds into the one Phone range (< 600px), the same threshold the sample's own` &&
               ` layout data uses. // NOTE: The ComboBox items keep the original binding-info sorter 1:1 ({path:'/CITIES', sorter:{path:'TEXT'}} - restored 2026-07-27; an earlier version had dropped it although` &&
               ` CAPABILITIES marks binding sorters expressible). The sap.ui.integration Card keeps its original external manifest reference (cardManifest.json). The two long lorem-ipsum filler Texts are abbreviated`.
    lv_text1 = lv_text1 && ` to short placeholders. cities.json (7) and products.json (3) are inlined in full (the unbound 'status' mock column stays out of the row type per the rows-not-columns rule). // NOTE: Faked-event-value` &&
               ` audit fix (2026-07-30): the four substituted handlers are now the original behaviours. onSnapToRowChange / onAllowDenseFillChange / onInlineBlockLayoutChange: each Switch state is two-way bound and` &&
               ` the GridContainer binds snapToRow/allowDenseFill/inlineBlockLayout (added attrs) to the same fields, so the toggles drive the grid entirely client-side (the 007/128 pattern) - the three Switch change` &&
               ` attributes are DROPPED for the binding (they only carried the imperative setter). onGridColumnsChange: the columnsChange wire round-trips ${$parameters>/columns} and recomputes the bound` &&
               ` columnsCountText text ('Current grid columns count: <n>'; text is an added attr on the Text). onPress (tiles + card): client-composed toast 'Press was fired on - {0}' filled by` &&
               ` $event.oSource.getMetadata().getName(), the original's exact text. onRevealGrid: the Reveal Grid button's press attribute is DROPPED, undecorated - RevealGrid is a sample-local JS helper (grid`.
    lv_text1 = lv_text1 && ` outline overlay) with no declarative equivalent (the app-145 precedent); the earlier static toasts ('Reveal Grid', 'Snap to row', 'Allow dense fill', 'Inline block layout', 'Columns changed', 'Tile` &&
               ` pressed', 'Card pressed') are gone. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the first GenericTile press toasts 'Press was fired on - sap.m.GenericTile'` &&
               ` (the getMetadata().getName() expression resolves); the switch bindings and columns counter remain unexercised.`.
    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.GridContainer`                   name = `GridContainer`                                 class = `z2ui5_cl_dmo_app_168` path = `src/04/b07/z2ui5_cl_dmo_app_168.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.65`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.GridList`                        name = `GridListBasic`                                 class = `z2ui5_cl_dmo_app_111` path = `src/04/b01/z2ui5_cl_dmo_app_111.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        notes = `NOTE: The Slider drives the panel width via a roundtrip-free expression binding ({= ${slider} + '%' }) over the two-way slider value, instead of the original onSliderMoved setWidth handler;` &&
                 ` Slider.liveChange is therefore not wired (the width tracks the slider client-side). The full 27-row item set is inlined.` )
      ( module = `sap.f`              control = `sap.f.GridList`                        name = `GridListBoxContainer`                          class = `z2ui5_cl_dmo_app_144` path = `src/04/b04/z2ui5_cl_dmo_app_144.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        notes = `NOTE: **e2e-verified 2026-08-01** (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): one keyboard step on the Slider carries the value into the backend, the round-trip recomposes` &&
                 ` the Panel width and the Panel really renders at 99% - the imperative setWidth is fully replaced. Residual (nothing headless can assert): the visual GridList reflow inside the resized panel. // NOTE:` &&
                 ` GridList with a grid:GridBoxLayout (boxMinWidth 17rem) and a GridListItem template (VBox + FlexItemData, Title, Label). The 27 items are inlined from model/items.json; the template binds` &&
                 ` {TITLE}/{SUBTITLE} 1:1.` ) ).

    lv_text1 = `NOTE: The Slider's ``liveChange`` attribute is dropped (the expression binding needs no event). **e2e-verified 2026-08-01** (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): one` &&
               ` keyboard step on the Slider moves the Panel width to 99% with no round-trip at all - the expression binding replaces onSliderMoved completely. Residual: the grouped GridList's visual reflow. // NOTE:` &&
               ` GridList with a group sorter on items ({path, sorter:{path:'GROUP', descending:false, group:true}}, default group headers), an empty grid:GridBoxLayout customLayout, growing/growingThreshold, and a` &&
               ` custom f:headerToolbar (Toolbar with Title, ToolbarSpacer, SearchField - the SearchField has no handler in the original). The 27 items are inlined 1:1 from the sample's own model/items.json; the` &&
               ` GridListItem template (VBox>VBox+FlexItemData, Title, Label) binds {TITLE}/{SUBTITLE} 1:1.`.
    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.GridList`                        name = `GridListBoxContainerGrouping`                  class = `z2ui5_cl_dmo_app_176` path = `src/04/b07/z2ui5_cl_dmo_app_176.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.GridList`                        name = `GridListBreakPoints`                           class = `z2ui5_cl_dmo_app_213` path = `src/04/b07/z2ui5_cl_dmo_app_213.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        notes = `NOTE: The Slider's ``liveChange`` attribute is dropped (the expression binding needs no event). **e2e-verified 2026-08-01** (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): one` &&
                 ` keyboard step on the Slider moves the Panel width to 99% with no round-trip - the expression binding replaces onSliderMoved completely. Residual: which GridList breakpoint the resized panel then hits` &&
                 ` (a visual property). // NOTE: GridResponsiveLayout.layoutChange is wired to a client-composed MessageToast (control_global MESSAGE_TOAST, template 'Layout changed to {0}' filled by` &&
                 ` ${$parameters>/layout}) reproducing onLayoutChange 1:1 without a backend round-trip. The layoutChange attribute itself is kept, so structural-diff sees no difference.` ) ).

    lv_text1 = `NOTE: The drop now reorders the list for real. CAPABILITIES marks drag & drop reorder expressible, so the earlier 'reorder logic not reproduced' was a wrong improvisation: the drop event ships the two` &&
               ` row indices and the insert position as client-side resolved $-args (${$parameters>/draggedControl/oParent}.indexOfItem(${$parameters>/draggedControl}), the same for droppedControl, and` &&
               ` ${$parameters>/dropPosition}), and on_event rebuilds the original onDrop arithmetic 1:1 in ABAP - remove the dragged row, decrement the drop index when dragging downwards, insert Before or After -` &&
               ` then view_model_update. Client indices are 0-based, ABAP table rows 1-based, which is the only difference to the JS splice. Both indices are range-checked before use: they arrive from the frontend,` &&
               ` and where JS would splice a nonsense index harmlessly, an ABAP table read on it dumps. Before this rework the drop fired a DROP event this class never dispatched (a dead wire, pattern-lint` &&
               ` dead-event-wire). // NOTE: The GridDropInfo control from sap.f.dnd keeps a hyphen-free 'dndgrid' xmlns alias instead of the original 'dnd-grid' (the alias only names the same sap.f.dnd URI; it makes`.
    lv_text1 = lv_text1 && ` the control statically visible to the checks). // NOTE: 27 items inlined from model/data.json; absent enum fields defaulted (highlight None, type Inactive) so the bound GridListItem properties stay` &&
               ` valid. Template binds counter/highlight/type/unread + title/subtitle 1:1.`.
    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.GridList`                        name = `GridListDragAndDrop`                           class = `z2ui5_cl_dmo_app_148` path = `src/04/b05/z2ui5_cl_dmo_app_148.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: SegmentedButton.selectionChange reproduces onModeChange server-side: GridList.mode is two-way bound to the same field as SegmentedButton.selectedKey and the headerText (bound) is recomputed as` &&
               ` 'GridList with mode ' + key on a backend round-trip. The GridList delete / selectionChange and the GridListItem press / detailPress are wired to client-side MessageToasts (the original toasted the` &&
               ` affected item's runtime id). mode/headerText/selectedKey carry bindings the original set statically. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): selecting` &&
               ` 'MultiSelect' round-trips the two-way bound mode and the list renders checkboxes. // NOTE: The 11 product rows are inlined from the sample's model/data.json. Fields the original JSON omits are given` &&
               ` their UI5 defaults so the bound enum-ish properties stay valid: GridListItem.type -> 'Inactive' (8 rows), highlight/Status -> 'None' (5 rows). Both render identically to the original's undefined` &&
               ` values; structural-diff compares only binding paths, not data. // NOTE: the four MessageToast handlers are reproduced as roundtrip-free CLIENT-COMPOSED toasts (_event_client cs_event-control_global`.
    lv_text1 = lv_text1 && ` MESSAGE_TOAST.show with a {N} template): onSelectionChange as '{0?Selected:Unselected} item with ID {1}' over ${$parameters>/selected} and ${$parameters>/listItem}.getId(), onDelete as 'Delete item` &&
               ` with ID {0}', and onDetailPress/onPress as 'Request details for item with ID {0}' / 'Pressed item with ID {0}' over $event.oSource.sId. **Corrected 2026-08-01** (faked-event-value audit): all four` &&
               ` used to toast a CONSTANT ('Selection changed', 'Delete item', 'Request details', 'Pressed item') and dropped the item identity the original shows. The ids are the runtime UI5 ids, exactly as in the` &&
               ` original.`.
    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.GridList`                        name = `GridListModes`                                 class = `z2ui5_cl_dmo_app_133` path = `src/04/b02/z2ui5_cl_dmo_app_133.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The Slider resizes the Panel again since 2026-08-05: onSliderMoved sets the width of byId('panelForGridList'), the Panel HAS a width property, so the pair is the roundtrip-free binding idiom of` &&
               ` apps 176/213 (Slider.value two-way bound, Panel.width an expression over it) - the 2026-07-27 review had already established that the earlier 'targets a non-existent id' claim was wrong. The` &&
               ` ToggleButton keeps its dropped press handler: onRevealGrid draws a debug overlay from the sample-local RevealGrid.js, a JS helper with its own CSS that is not an abap2UI5 capability (same drop as` &&
               ` apps 145/271). As a consequence the Slider's liveChange attribute is not emitted either - the resize lives in the binding pair now, exactly as in apps 176/213. // POST-1.71: The GridList customLayout` &&
               ` uses sap.ui.layout.cssgrid.ResponsiveColumnLayout and per-item ResponsiveColumnItemLayoutData with columns/rows (control + members since 1.72), kept 1:1; requires a UI5 release >= 1.72. // NOTE:` &&
               ` Fully static view reproduced 1:1: a ToggleButton, a Slider (value=100), and a Panel (headerToolbar Toolbar+Title) hosting an f:GridList with a ResponsiveColumnLayout and five static f:GridListItems`.
    lv_text1 = lv_text1 && ` (columns/rows 4/4, 3/2, 3/2, 1/1, 1/1), each a VBox with a Title and 1..5 Labels; no bound data.`.
    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.GridList`                        name = `GridListResponsiveColumnLayout`                class = `z2ui5_cl_dmo_app_222` path = `src/04/b07/z2ui5_cl_dmo_app_222.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `The GridList customLayout uses sap.ui.layout.cssgrid.ResponsiveColumnLayout and per-item ResponsiveColumnItemLayoutData with columns/rows (control + members since 1.72), kept 1:1; requires a UI5` &&
                 ` release >= 1.72.` ) ).

    lv_text1 = `NOTE: The sample's UI is a trigger Button plus two explanatory Texts, and the ProductSwitch itself lives in ProductSwitchPopover.fragment.xml, opened on press. **Rebuilt 1:1 on 2026-08-05** (the` &&
               ` 2026-07-27 review had flagged the 'no JS controller' rationale as refuted): the fragment is a core:FragmentDefinition shown through popover_display( by_id = pSwitchBtn ), the three products come from` &&
               ` model/data.json into a bound ProductSwitch items aggregation, and fnChange - a toast 'Redirecting to <targetSrc>' plus URLHelper.redirect( targetSrc, true ) - is two client actions chained on the one` &&
               ` change event, both reading the pressed item off the event (${$parameters>/itemPressed}.getTargetSrc()). The port now has NO structural difference from the original at all. // POST-1.71:` &&
               ` sap.f.ProductSwitch and sap.f.ProductSwitchItem are controls @since 1.72 - one minor release past the 1.71 line. The sample IS the ProductSwitch, so the port is one of the five decided scope` &&
               ` exceptions (ui5/scope-exceptions.json, KEEP 2026-07-30); the controls only became visible to the property gate on 2026-08-05, when the popover fragment was rebuilt instead of substituted by a toast.`.
    lv_text1 = lv_text1 && ` The app needs a UI5 release >= 1.72.`.
    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.ProductSwitch`                   name = `ProductSwitchNavigation`                       class = `z2ui5_cl_dmo_app_165` path = `src/04/b07/z2ui5_cl_dmo_app_165.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.72`
        since_post171 = abap_true
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.f.ProductSwitch and sap.f.ProductSwitchItem are controls @since 1.72 - one minor release past the 1.71 line. The sample IS the ProductSwitch, so the port is one of the five decided scope` &&
                 ` exceptions (ui5/scope-exceptions.json, KEEP 2026-07-30); the controls only became visible to the property gate on 2026-08-05, when the popover fragment was rebuilt instead of substituted by a toast.` &&
                 ` The app needs a UI5 release >= 1.72.` ) ).

    lv_text1 = `NOTE: The original keeps header/object data in nested paths on one JSON model (title, showFooter, titleSnappedContent/text, titleExpandedContent/text, objectDescription/category|center|email|status).` &&
               ` abap2UI5 keeps one default model and render-smoke does not mock nested structures, so those paths are folded to flat fields bound via _bind (last path segment identical, which structural-diff` &&
               ` matches). Both the snapped and expanded subheading Text controls bind the same flat 'text' field. The full 125-row ProductCollection mock is inlined. // NOTE: The semantic action handlers are` &&
               ` reproduced since 2026-08-05 instead of raising static toasts: onEdit sets showFooter and hides the Edit action, onSave/onCancel reset both, and onSave shows the original's MessageBox.alert(` &&
               ` 'Successfully saved!' ) - the state lives in ABAP and drives the bound properties, which is the thin-frontend answer to three controller methods that only toggle view state. The controller's onInit` &&
               ` Messaging.addMessages seed (one Error 'Something wrong happened') now goes through the z2ui5.cc.MessageManager companion control (app 065 idiom, pr/message-manager-write), so the MessagesIndicator`.
    lv_text1 = lv_text1 && ` carries its count again, and onMessagesButtonPress is a MessagePopover over the message> model declared in the indicator's dependents and toggled roundtrip-free (app 066 idiom). The DiscussInJam /` &&
               ` SendEmail / SendMessage semantic actions keep their built-in behaviour and the DraftIndicator shows state Saved. Structurally that adds three controls the original view does not declare - the` &&
               ` z2ui5:MessageManager bridge plus the MessagePopover and its MessageItem template - because the original builds the popover in the controller and seeds the message through the Messaging API.`.
    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.semantic.SemanticPage`           name = `SemanticPage`                                  class = `z2ui5_cl_dmo_app_166` path = `src/04/b07/z2ui5_cl_dmo_app_166.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.46.0`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.ShellBar`                        name = `ShellBar`                                      class = `z2ui5_cl_dmo_app_110` path = `src/04/b01/z2ui5_cl_dmo_app_110.clas.abap`
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
      ( module = `sap.f`              control = `sap.f.ShellBar`                        name = `ShellBarWithMenuButton`                        class = `z2ui5_cl_dmo_app_152` path = `src/04/b06/z2ui5_cl_dmo_app_152.clas.abap`
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
               ` non-denied method via the generalized allowlist (closing the 2026-07-27 review-flagged gap). // NOTE: **e2e-verified 2026-08-01** (scripts/e2e-smoke.mjs interaction, transpiled backend + real`.
    lv_text1 = lv_text1 && ` browser): typing into the ShellBar search fires the client-composed liveChange toast ('<id> liveChange event value is: <value>', the app-005 idiom over cs_event-control_global). The SearchManager` &&
               ` renders collapsed in the ShellBar, so the interaction expands it through the Search button first. Residual: the search event's own toast and the suggest -> binding_call Contains filter round-trip` &&
               ` with its effect on the suggestion list. // NOTE: The ShellBar homeIcon asset URL './resources/sap/ui/documentation/sdk/images/logo_sap.png' is repointed to the OpenUI5 host` &&
               ` 'https://sdk.openui5.org/resources/...' per the asset-URL rule (same as app 110). The mock's per-row ProductPicUrl values are kept byte-identical to sap/ui/demo/mock/products.json (unbound display` &&
               ` data, never rendered by this view). Rows without a DateOfSale in the mock carry an empty string (the property is not bound). Review finding 2026-07-27: the row type inlines all 20 mock keys although` &&
               ` the view binds only Name, Price, CurrencyCode and ProductId - against AGENTS.md par.5 'unbound mock keys stay out of the row type'; the unbound columns (category, maincategory, taxtarifcode,`.
    lv_text1 = lv_text1 && ` suppliername, weightmeasure, weightunit, description, dateofsale, productpicurl, status, quantity, uom, width, depth, height, dimunit) should be trimmed. // POST-1.71: the sap.m.Avatar control (since` &&
               ` UI5 1.73) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.73 to render it. @since verified in sap/m/Avatar.js:99 (control-level, which the member-level property gate` &&
               ` never saw).`.
    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.ShellBar`                        name = `ShellBarWithSearch`                            class = `z2ui5_cl_dmo_app_218` path = `src/04/b07/z2ui5_cl_dmo_app_218.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.63`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `the sap.m.Avatar control (since UI5 1.73) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.73 to render it. @since verified in sap/m/Avatar.js:99 (control-level, which` &&
                 ` the member-level property gate never saw).` ) ).

    lv_text1 = `NOTE: onToggle vetoes the NEXT toggle when the matching switch is on (event.preventDefault) and resets that switch. **Reproduced 2026-08-05**: the framework's veto flag (s_ctrl-check_prevent_default,` &&
               ` merged 2026-07-30 - AFTER this port was written, which is why the sidecar said 'an event veto is not expressible') is baked into the wire at RENDER time, and that is enough here because the DIRECTION` &&
               ` of the next toggle is known - an expanded panel can only collapse next. The flag is therefore the switch that applies to that direction, the two Switches are two-way bound, and the toggle round-trip` &&
               ` re-renders so the flag is rebuilt from the state the client just sent back. The handler is the original's if/else: on a vetoed direction it toasts 'I am prevented COLLAPSE/EXPAND event' and clears` &&
               ` that switch, otherwise it keeps the new expanded state. Residual: the veto costs a round-trip per toggle, where the original decides in the handler - the state the decision needs (the switches) lives`.
    lv_text1 = lv_text1 && ` in the model either way. // POST-1.71: the SidePanel and SidePanelItem controls (both since UI5 1.107) are newer than 1.71 but are the whole point of this sample and kept for the 1:1 port - the app` &&
               ` needs a UI5 release >= 1.107 to render it. @since verified in sap/f/SidePanel.js and sap/f/SidePanelItem.js:34 (control-level, which the member-level property gate never saw).`.
    result = VALUE #( BASE result
      ( module = `sap.f`              control = `sap.f.SidePanel`                       name = `SidePanelSingle`                               class = `z2ui5_cl_dmo_app_136` path = `src/04/b03/z2ui5_cl_dmo_app_136.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.107`
        since_post171 = abap_true
        is_post171 = abap_true
        notes = lv_text1
        post171 = `the SidePanel and SidePanelItem controls (both since UI5 1.107) are newer than 1.71 but are the whole point of this sample and kept for the 1:1 port - the app needs a UI5 release >= 1.107 to render` &&
                 ` it. @since verified in sap/f/SidePanel.js and sap/f/SidePanelItem.js:34 (control-level, which the member-level property gate never saw).` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ActionListItem`                  name = `ActionListItem`                                class = `z2ui5_cl_dmo_app_001` path = `src/01/b05/z2ui5_cl_dmo_app_001.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port` )
      ( module = `sap.m`              control = `sap.m.Bar`                             name = `Page`                                          class = `z2ui5_cl_dmo_app_002` path = `src/01/b05/z2ui5_cl_dmo_app_002.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port` )
      ( module = `sap.m`              control = `sap.m.Bar`                             name = `ToolbarVsBar`                                  class = `z2ui5_cl_dmo_app_189` path = `src/01/b17/z2ui5_cl_dmo_app_189.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` ) ).

    lv_text1 = `NOTE: the original wires a change handler on the separator Select (SEP_CHANGE round-trip, removed 2026-07-16): selectedKey and separatorStyle share one two-way model path, so the Select.change` &&
               ` attribute is deliberately MISSING vs the original view. Instant switching confirmed in the 2026-07-20 live check (restamp). // NOTE: the link toast was switched from a message_toast_display` &&
               ` round-trip to a roundtrip-free client-composed toast on 2026-07-22 (control_global MESSAGE_TOAST.show, template ``{0} has been activated`` filled by ${$source>/text}; on_event dropped) - re-verify` &&
               ` each breadcrumb link toasts "<text> has been activated". **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the overflow-picker entry 'Products' fires the link` &&
               ` press and toasts 'Products has been activated' (the headless layout collapses the links into the Breadcrumbs overflow Select; the picker path exercises the same press wire).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Breadcrumbs`                     name = `Breadcrumbs`                                   class = `z2ui5_cl_dmo_app_003` path = `src/01/b01/z2ui5_cl_dmo_app_003.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed); RESTAMP after the 2026-07-16 rework (link toast +` &&
                 ` instant separator switch confirmed)`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Breadcrumbs`                     name = `BreadcrumbsWithCurrentPageLink`                class = `z2ui5_cl_dmo_app_286` path = `src/01/b21/z2ui5_cl_dmo_app_286.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        is_post171 = abap_true
        notes = `POST-1.71: the sample's whole point is the currentLocation aggregation of sap.m.Breadcrumbs (since UI5 1.123), which shows the current page as a Link instead of plain text - kept 1:1, so the app needs` &&
                 ` a UI5 release >= 1.123 to render it there (on an older release the Link falls into the default items aggregation). // NOTE: each Link keeps the original's client-side` &&
                 ` MessageToast.show(evt.getSource().getText() + ' has been clicked') as a roundtrip-free _event_client MESSAGE_TOAST with the template '{0} has been clicked' filled by ${$source>/text} - the text comes` &&
                 ` from the pressed Link itself, exactly as in the original, and nothing travels to the backend. The class therefore has no on_event and no model at all.`
        post171 = `the sample's whole point is the currentLocation aggregation of sap.m.Breadcrumbs (since UI5 1.123), which shows the current page as a Link instead of plain text - kept 1:1, so the app needs a UI5` &&
                 ` release >= 1.123 to render it there (on an older release the Link falls into the default items aggregation).` ) ).

    lv_text1 = `NOTE: the BusyDialog fragment is rebuilt 1:1 as a core:FragmentDefinition shown via client->popup_display (the framework's displayFragment calls .open() on the fragment root, the equivalent of the` &&
               ` controller's Fragment.load + oBusyDialog.open()); one attribute is added vs the original fragment: id="busyDialog", needed so the backend timer event can close the dialog via the whitelisted` &&
               ` control_by_id 'close' method (CONTROL_METHODS in FrontendAction.js, no-arg; the id resolves in the POPUP slot via Fragment.byId('popupId', ...)) - the equivalent of the controller's` &&
               ` oBusyDialog.close(). // NOTE: the controller's simulateServerRequest (setTimeout 3000ms) becomes the framework timer: follow_up_action( cs_event-start_timer, callbackEvent TIMER_FINISHED, 3000 )` &&
               ` started with the popup. A running frontend timer cannot be cleared from ABAP (the original's clearTimeout in onDialogClosed), so after a cancel the timer still fires one backend round-trip; a` &&
               ` protected guard flag (check_busy) ignores it - same visible behavior (no second toast, dialog already closed), one extra no-op round-trip. // NOTE: the controller's syncStyleClass('sapUiSizeCompact',`.
    lv_text1 = lv_text1 && ` view, dialog) is dropped: it only copies the compact-density class when the view itself carries it, which the sample view does not; abap2UI5's popup slot has no per-view density sync, so there is` &&
               ` nothing to propagate.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.BusyDialog`                      name = `BusyDialog`                                    class = `z2ui5_cl_dmo_app_004` path = `src/01/b05/z2ui5_cl_dmo_app_004.clas.abap`
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
      ( module = `sap.m`              control = `sap.m.BusyDialog`                      name = `BusyDialogLight`                               class = `z2ui5_cl_dmo_app_251` path = `src/01/b19/z2ui5_cl_dmo_app_251.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Button`                          name = `Button`                                        class = `z2ui5_cl_dmo_app_005` path = `src/01/b03/z2ui5_cl_dmo_app_005.clas.abap`
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
               ` numeric-bound-as-string lint (app-053 lesson) wants the model to serialize real numbers; Input.value coerces either way. // NOTE: live-verified 2026-08-04 (nightly e2e interaction): unverified in a` &&
               ` running system: (a) the shared /BADGECURRENT binding driving badge and StepInput; (b) the icon/text expression bindings over /BUTTONWITHICON//BUTTONWITHTEXT; (c) the MIN_CHANGE/MAX_CHANGE validation` &&
               ` round-trips incl. the reset-on-invalid path and the setBadgeMin/MaxValue follow-ups. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): (a) is covered - the badge`.
    lv_text1 = lv_text1 && ` renders data-badge 1 and follows the StepInput to 2 after ArrowUp+Enter (the change event carries the two-way write); the MIN/MAX validation round-trips remain unexercised.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Button`                          name = `ButtonWithBadge`                               class = `z2ui5_cl_dmo_app_249` path = `src/01/b19/z2ui5_cl_dmo_app_249.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `The badge API is newer than 1.71 and kept 1:1 per the fidelity-first member policy: sap.m.BadgeCustomData (control @since 1.80, secondary control - sap.m.Button is the in-scope headline entity, the` &&
                 ` app-244 Avatar precedent), Button.badgeStyle (@since 1.132) and the BadgeEnabler methods setBadgeMinValue/setBadgeMaxValue driven via control_by_id. The app needs a UI5 release >= 1.132 to render the` &&
                 ` badgeStyle; the badge itself needs >= 1.80.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Carousel`                        name = `CarouselWithControls`                          class = `z2ui5_cl_dmo_app_006` path = `src/01/b04/z2ui5_cl_dmo_app_006.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-15): manually verified in a running system - renders and scrolls like the original (see the note below on the flattened image model).`
        notes = `NOTE: the three carousel images bind to a separate named model in the original (img>/products/pic1..3 from sap/ui/demo/mock/img.json); resolved here to static image URLs, as abap2UI5 serves a single` &&
                 ` default model. // POST-1.71: ariaLabelledBy on the Carousel (since UI5 1.125) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.125 to render it.`
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
      ( module = `sap.m`              control = `sap.m.Carousel`                        name = `CarouselWithMorePages`                         class = `z2ui5_cl_dmo_app_252` path = `src/01/b19/z2ui5_cl_dmo_app_252.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Members newer than 1.71 kept 1:1: sap.m.Carousel.ariaLabelledBy (@1.125) and sap.m.CarouselLayout.scrollMode (@1.121); the CarouselLayout control itself is @1.62. The app needs a UI5 release >= 1.125` &&
                 ` to render both.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.CheckBox`                        name = `CheckBox`                                      class = `z2ui5_cl_dmo_app_155` path = `src/01/b15/z2ui5_cl_dmo_app_155.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = `NOTE: Fifteen CheckBoxes across all states (selected, partiallySelected, required, enabled, valueState Warning/Error/Information, wrapping) plus a SimpleForm with GridData-laid-out CheckBoxes,` &&
                 ` reproduced 1:1. // POST-1.71: CheckBox.required (@since 1.121, the 'Required option' CheckBox) is used 1:1. Newer than UI5 1.71; declared per the property-171 policy, so the app needs UI5 >= 1.121 to` &&
                 ` render the required state.`
        post171 = `CheckBox.required (@since 1.121, the 'Required option' CheckBox) is used 1:1. Newer than UI5 1.71; declared per the property-171 policy, so the app needs UI5 >= 1.121 to render the required state.` )
      ( module = `sap.m`              control = `sap.m.CheckBox`                        name = `CheckBoxTriState`                              class = `z2ui5_cl_dmo_app_007` path = `src/01/b02/z2ui5_cl_dmo_app_007.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-15): manually verified in a running system - the select-all parent checkbox and its tri-state expression bindings behave like the original.; live-checked reference example for:` &&
                 ` expression bindings, two-way bind, boolean event arg` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ColorPalette`                    name = `ColorPalette`                                  class = `z2ui5_cl_dmo_app_008` path = `src/01/b02/z2ui5_cl_dmo_app_008.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.54`
        notes = `NOTE: the color-select toast was switched to a roundtrip-free client-composed toast on 2026-07-22 (control_global MESSAGE_TOAST.show, template with {0}/{1} filled by ${$parameters>/value} and` &&
                 ` ${$parameters>/defaultAction}; on_event dropped, init-only). **e2e-verified 2026-08-01** (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): picking a colour (the swatch has a` &&
                 ` zero-height box headless, so it is focused and activated with Enter) toasts 'Color Selected: value - gold, \n defaultAction - false' - the client-composed template with ${$parameters>/value} and` &&
                 ` ${$parameters>/defaultAction} filled in, with no round-trip.` ) ).

    lv_text1 = `NOTE: The controller lazily builds six differently configured ColorPalettePopover instances and openBy()s them; the port declares all six 1:1 in the view's mvc:dependents (ColorPalettePopover x6 -` &&
               ` extra controls vs the original view.xml, controller-built there) with the original ids/configurations, and every button press opens its popover roundtrip-free via _event_client control_by_id openBy` &&
               ` ($event.oSource.sId). handleColorSelect is the app-008 client-composed toast: 'Color Selected: value - {0}, \n defaultAction - {1}' filled by ${$parameters>/value} and ${$parameters>/defaultAction}.` &&
               ` The original's same-instance quirk (both displayMode buttons share oColorPaletteDisplayMode) is kept - both open the same declared popover. // POST-1.71: Members newer than 1.71 kept 1:1 per the` &&
               ` fidelity-first policy: sap.m.ColorPalettePopover.selectedColor (@1.122) and showRecentColorsSection (@1.74) on the selected-color popover, and sap.m.Button.ariaHasPopup (@1.84) on all seven action` &&
               ` buttons. The app needs a UI5 release >= 1.122 for the selectedColor variant; the control itself is @1.54. // NOTE: Two of the custom colors cannot ride an XML string[] attribute - the parser splits`.
    lv_text1 = lv_text1 && ` on commas, so hsl(0,100%,71%) and rgb(255,234,234) become their exact hex equivalents #ff6b6b and #ffeaea (same rendered swatches, different notation; sap.ui.core.CSSColor validation rejects any` &&
               ` comma-escaping workaround). // NOTE: handleLiveChange is reproduced since 2026-08-06, and the earlier verdict - 'direct DOM manipulation outside any bindable property, not expressible in the thin` &&
               ` frontend' - was too quick. The original paints the liveChangeButton's ICON by writing rgba(r,g,b,alpha) onto getDomRef().firstChild.firstChild.style.color, i.e. the icon span, and the framework's` &&
               ` ``css`` action deliberately writes only on a control's OWN DOM node (the pr/control-inline-style entry excludes internal DOM on purpose). Measured instead of assumed (scripts/probes/, real OpenUI5):` &&
               ` the icon span INHERITS color from the button root, so setting it there gives the identical computed colour without touching internal DOM. The wire is roundtrip-free - the rgba() string is composed on` &&
               ` the client from the four liveChange parameters, an event argument being a full UI5 expression. Still NOT ported: onExit's popover destroy calls - the declared dependents die with the view. // NOTE:`.
    lv_text1 = lv_text1 && ` live-verified 2026-08-04 (nightly e2e interaction): unverified in a running system: the six dependents-declared ColorPalettePopover configurations opening anchored via openBy and the colorSelect` &&
               ` toast argument resolution. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the first action button opens its ColorPalettePopover anchored (palette content` &&
               ` attached); the other five configurations are the identical wire.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ColorPalette`                    name = `ColorPalettePopover`                           class = `z2ui5_cl_dmo_app_250` path = `src/01/b19/z2ui5_cl_dmo_app_250.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.54`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Members newer than 1.71 kept 1:1 per the fidelity-first policy: sap.m.ColorPalettePopover.selectedColor (@1.122) and showRecentColorsSection (@1.74) on the selected-color popover, and` &&
                 ` sap.m.Button.ariaHasPopup (@1.84) on all seven action buttons. The app needs a UI5 release >= 1.122 for the selectedColor variant; the control itself is @1.54.` ) ).

    lv_text1 = `NOTE: the shared demo kit mock model sap/ui/demo/mock/products.json (/ProductCollection, snapshotted in ui5/mock/products.json) is flattened into the default model: all 123 rows are kept verbatim, but` &&
               ` only the bound columns (ProductId, Name, SupplierName, WeightMeasure, WeightUnit, Width, Depth, Height, DimUnit, Price, CurrencyCode) are ported - the unbound columns (Category, MainCategory,` &&
               ` TaxTarifCode, Description, DateOfSale, ProductPicUrl, Status, Quantity, UoM) of the shared mock model are dropped. // NOTE: the controller's onPopinLayoutChanged (ComboBox change handler running a` &&
               ` PopinLayout switch with a Block default) is expressed as bound properties instead of a round-trip (AGENTS 'prefer a bindable property'): the ComboBox's change attribute is dropped, its selectedKey is` &&
               ` bound two-way, and the Table gains a popinLayout expression binding that reproduces the switch including its Block default. // NOTE: the controller's onToggleInfoToolbar (ToggleButton press handler` &&
               ` calling getInfoToolbar().setVisible(!pressed)) is expressed as bound properties instead of a round-trip: the ToggleButton's press attribute is dropped, its pressed property is bound two-way, and the`.
    lv_text1 = lv_text1 && ` infoToolbar's OverflowToolbar gains a visible={= !pressed } expression binding. // NOTE: the controller's onSelect (imperative oTable.setSticky array maintenance from the CheckBox text + selected` &&
               ` parameter) becomes a sticky property on the Table bound to a plain string table: each CheckBox select event round-trips ${$source>/text} and ${$parameters>/selected}, the ABAP handler inserts/removes` &&
               ` that option and pushes the model back via view_model_update. This is the bound-array path working, not a gap: Table.sticky takes an ABAP string table directly, live-verified here, and apps 022/235` &&
               ` were reworked onto the same pattern 2026-08-05/06. // 1.71: the p:ColumnAIAction column plugin (sap.m.plugins, since UI5 1.136 - far newer than 1.71) is dropped with its dependents aggregation, the` &&
               ` xmlns:p namespace and the press toast - the plugin class does not exist on a 1.71 runtime, so keeping it would break view creation there (same decision as app 022). // NOTE: the original derives the`.
    lv_text1 = lv_text1 && ` ObjectNumber weight state in its frontend Formatter.js (weightState: KG conversion + Success/Warning/Error thresholds). That is business logic, so - abap2UI5 being a thin frontend - it is computed in` &&
               ` ABAP model_init into a WEIGHT_STATE field and bound state="{WEIGHT_STATE}", not via a frontend formatter (core:require dropped). Visually 1:1 with the original.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Column`                          name = `Table`                                         class = `z2ui5_cl_dmo_app_009` path = `src/01/b05/z2ui5_cl_dmo_app_009.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.12`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: the sample is an OPA-test demo: only the UI app under applicationUnderTest/ (Table.view.xml, Table.controller.js, Formatter.js, products.json) is ported 1:1; the qunit/OPA harness files` &&
               ` (OpaTableTest.qunit.js, Test.qunit.html, testsuite.qunit.*) are test infrastructure without UI and are not ported. // NOTE: the controller's onPopinLayoutChanged (byId(idProductsTable).setPopinLayout` &&
               ` per the ComboBox selectedKey switch) is a pure client-side path: two-way bound ComboBox selectedKey feeding a popinLayout expression binding with the same GridLarge/GridSmall-else-Block fallback` &&
               ` (extra attributes vs the original view, original change handler dropped) - no round-trip, same pattern as app 009; the expression can never emit an empty enum value. // NOTE: the controller-built` &&
               ` sap.m.Dialog of onMessageDialogPress (title Message, type Message, a Text 'Success' as content, an OK beginButton Button that closes it) is rebuilt 1:1 as a core:FragmentDefinition shown via` &&
               ` client->popup_display on the ColumnListItem press event; the OK Button closes roundtrip-free via the frontend action _event_client( cs_event-popup_close ), and the original's afterClose destroy is`.
    lv_text1 = lv_text1 && ` the framework's popup lifecycle. The Dialog, its Text and its Button are extra controls vs the original view.xml (controller-created there). // NOTE: model flattening: the sample's LOCAL` &&
               ` applicationUnderTest/products.json (123 rows) is moved into the default model verbatim, unbound columns dropped. Note: the local file is NOT identical to the shared mock ui5/mock/products.json - same` &&
               ` 123 ProductIds, but HT-9995 differs in content (local: Smartphone Cover / 15 EUR vs mock: Tablet Pouch / 20 EUR); the port follows the local file, the sample's actual model source. // NOTE: the` &&
               ` original derives the ObjectNumber weight state in its frontend Formatter.js (weightState: KG conversion + Success/Warning/Error thresholds). That is business logic, so - abap2UI5 being a thin` &&
               ` frontend - it is computed in ABAP model_init into a WEIGHT_STATE field and bound state="{WEIGHT_STATE}", not via a frontend formatter (core:require dropped). Visually 1:1 with the original.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ColumnListItem`                  name = `TableTest`                                     class = `z2ui5_cl_dmo_app_010` path = `src/01/b05/z2ui5_cl_dmo_app_010.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        since = `1.12`
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ComboBox`                        name = `ComboBox`                                      class = `z2ui5_cl_dmo_app_011` path = `src/01/b02/z2ui5_cl_dmo_app_011.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22` )
      ( module = `sap.m`              control = `sap.m.ComboBox`                        name = `ComboBox2Columns`                              class = `z2ui5_cl_dmo_app_193` path = `src/01/b17/z2ui5_cl_dmo_app_193.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22` )
      ( module = `sap.m`              control = `sap.m.ComboBox`                        name = `ComboBoxGrouping`                              class = `z2ui5_cl_dmo_app_199` path = `src/01/b17/z2ui5_cl_dmo_app_199.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22` ) ).

    lv_text1 = `IMPROVISED: the pattern's three views (App.view with sap.m.App id=rootControl, Main.view, Comparison.view) plus manifest routing are merged into ONE view: the App hosts the Main Page and the` &&
               ` Comparison f:DynamicPage (id page-comparison added) directly as its pages; the router's navTo("page2") is mapped to the documented NavContainer frontend action follow_up_action(` &&
               ` cs_event-control_by_id, rootControl//to/page-comparison ) with the default slide transition (CAPABILITIES nav row); hash-based routing / browser-back navigation is not wired; the view controllerName` &&
               ` attributes are dropped. // NOTE: named models flattened into the single default model: the Comparison view's settings> model becomes the bound PAGES_COUNT/IS_DESKTOP fields (pagesCount initialized to` &&
               ` 1, the CarouselLayout.visiblePagesCount UI5 default, instead of the original's undefined-until-routeMatched), and its products> model (Products/Props) becomes T_COMP_PRODUCTS/T_COMP_PROPS; the shared` &&
               ` mock products.json default model is flattened into a flat upper-cased row type (all 20 JSON columns kept; rows without DateOfSale carry an empty string where the original JSON omits the key - a`.
    lv_text1 = lv_text1 && ` harmless string property, no enum/default override). // NOTE: the '.formatter.url' iconSrc formatter flattened to absolute https://sdk.openui5.org image URLs - source-verified against the` &&
               ` now-archived app/model/formatter.js (it only prefixes '../../../../../../', i.e. resolves to the test-resources root), so the absolute URLs are the faithful equivalent. // NOTE: compare button: the` &&
               ` controller's onSelection setText/setVisible is replaced by bound COMPARE_TEXT/COMPARE_VISIBLE model properties updated in the SELECTION handler (same count>1 logic, text only refreshed while shown,` &&
               ` like the original); the ColumnListItem gains a selected="{SELECTED}" two-way binding - the sanctioned selection-read pattern (CAPABILITIES 'Controller-read list selection') replacing` &&
               ` getSelectedContextPaths - which is an extra attribute vs the original template, and the initial visible="false"/absent text of the Button become bindings. // IMPROVISED: the ResizeHandler-driven` &&
               ` pagesCount/isDesktop recalculation (_onResize/_getPagesCount) is replaced by a one-shot computation at COMPARE time from client->get( )-s_device-resize-width using the original's 600/1024 thresholds`.
    lv_text1 = lv_text1 && ` and the cap at the selected-items count; no live recalculation on window resize. Re-judged 2026-08-05 against the now-live device model (pr/live-device-model): it does NOT close this one.` &&
               ` visiblePagesCount could bind {device>/resize/width} directly, but the count is also capped at the number of SELECTED products and then drives comparison_props_build, which slices the props table` &&
               ` server-side per page window - so a client-side count would desync the props it is supposed to index. The round-trip decision stays; what the live model closes is the class-swap family (app 168), not` &&
               ` this one. Re-judged again 2026-08-06 and reclassified as a BOUNDARY rather than a framework gap: closing it would need a resize -> BACKEND event wire (a debounced ResizeHandler round-trip), and that` &&
               ` is deliberately not offered - it is chatty by construction, and every display-only case it would serve is already covered by the live device model without a round-trip. The one case it would` &&
               ` genuinely serve is this one, where the count feeds a server-side slice; one port is not enough to file on (the repo's rule), so the idea is recorded here for the second sample that needs it. // NOTE:`.
    lv_text1 = lv_text1 && ` Panel expand: the controller's onPanelExpanded (walking the sibling HBox controls and calling setVisible) is replaced by a bound VISIBLE flag per comparison value row, toggled in the PANEL_EXPANDED` &&
               ` event via t_arg ${KEY} + ${$parameters>/expand}; the description HBox's literal visible="false" becomes the {VISIBLE} binding (initial false). // NOTE: The snapped/expanded Carousel re-sync is` &&
               ` reproduced since 2026-08-06. The original's _updateCarouselsActivePage hands each Carousel its own page AT THE SAME INDEX - carousel.setActivePage( carousel.getPages()[ iFirstItem ] ) - and those` &&
               ` pages are aggregation-template CLONES. Measured 2026-08-06 (scripts/probes/aggregation-item-probe.mjs, real OpenUI5): their ids ARE deterministic and stable, even across a reorder - UI5 mints` &&
               ` <templateId>-<parentId>-<index> - but the parent id carries the VIEW PREFIX the framework assigns at runtime (v1--tpl-v1--car-0), which the backend never sees, so it cannot spell one. The earlier` &&
               ` sidecar called them 'nondeterministic', which the probe refutes; the gap was the prefix, not the determinism. Wherever a CONTROL_BY_ID argument takes a control id it now also takes an aggregation`.
    lv_text1 = lv_text1 && ` ITEM, addressed positionally as <id>/<aggregation>/<index> (pr/aggregation-item-address, implemented upstream), resolved on the client where both the prefix and the aggregation are known. Both` &&
               ` carousels are re-synced on every PAGE_CHANGED, as in the original. // NOTE: the DynamicPageTitle stateChange handler (.onStateChange, add/removeSnappedContent of the snapped Carousel as a` &&
               ` Carousel-animation workaround) is dropped together with its stateChange attribute - imperative aggregation surgery with no framework equivalent; the snapped/expanded content still switches natively` &&
               ` with the DynamicPage header state. // NOTE: comparison Props are built from a fixed 19-key list in the mock JSON key order (the original iterates the FIRST selected product's own keys, skipping` &&
               ` ProductPicUrl - so a first product without DateOfSale would drop that row, and missing values rendered '<strong>undefined</strong>' where the port renders an empty <strong></strong>); selected` &&
               ` products are taken in model row order, not click order; the original's per-product information cache is unnecessary server-side. The controller's handleButtonPress (MessageBox) is dead code`.
    lv_text1 = lv_text1 && ` referenced by no view and not ported.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ComparisonPattern`               name = `ComparisonPattern`                             class = `z2ui5_cl_dmo_app_012` path = `src/01/b05/z2ui5_cl_dmo_app_012.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        ui5_only = abap_true
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: the i18n> ResourceModel (i18n/i18n.properties) has no framework i18n mechanism here - all texts (dialog title, section titles/summaries/details, button labels) are inlined as the resolved` &&
               ` English literals from the properties file; this covers every i18n>-bound text incl. the Panel headerText 'More Info'. // NOTE: the cookieData> named JSON model is flattened into the default model:` &&
               ` /showCookieDetails becomes the bound abap_bool show_cookie_details; every visible binding and expression binding keeps its original shape over the flattened path (named ABAP-fed JSON models are not` &&
               ` expressible, CAPABILITIES.md). // IMPROVISED: custom:DivContainer (xmlns:custom="sap.ui.documentation", a demo-kit-internal plain-div wrapper control not shipped in any UI5 library) is rebuilt as a` &&
               ` sap.m.VBox with the same class sapUiSmallMargin. // IMPROVISED: the controller's toggleStyleClass/addStyleClass/removeStyleClass('cookiesDetailedView') on the dialog is dropped because the class's` &&
               ` CSS is not part of the sample's shipped files (manifest references css/style.css but does not list it under sample files, and it is not archived), so toggling the class has no visible effect. Since`.
    lv_text1 = lv_text1 && ` 2026-07-22 add/remove/toggleStyleClass ARE whitelisted in CONTROL_METHODS (pr/style-class-toggle), so the toggle could be wired via follow_up_action( cs_event-control_by_id, toggleStyleClass ) once` &&
               ` the CSS is present; it stays dropped here only for the missing CSS. // NOTE: the controller's lazy Fragment.load + cached-instance open()/close() lifecycle maps to client->popup_display (the fragment` &&
               ` XML is rebuilt per open, forcing showCookieDetails=false like the original's openCookieSettingsDialog) and client->popup_destroy in the close handlers; the original's empty 'insert your ... logic` &&
               ` here' placeholders remain as backend event branches (ACCEPT_ALL_COOKIES/REJECT_ALL_COOKIES/SAVE_COOKIES) that only close the dialog.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.CookieSettingsDialogPattern`     name = `CookieSettingsDialogPattern`                   class = `z2ui5_cl_dmo_app_013` path = `src/01/b05/z2ui5_cl_dmo_app_013.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        ui5_only = abap_true
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: the shared mock model /ProductCollection (ui5/mock/products.json) is flattened into the default model with only the three bound columns (ProductId, Name, ProductPicUrl); all unbound columns are` &&
               ` dropped. The full 123-row set is kept verbatim. // NOTE: the ProductPicUrl values point at the OpenUI5 host (https://sdk.openui5.org/test-resources/...) per the asset-URL rule; they are rebuilt per` &&
               ` row from ProductId in a LOOP in model_init - path and file name are identical to the mock values, only the host prefix is added. // NOTE: the controller-built Dialog of handlePress (Image + Close` &&
               ` button, afterClose destroy) is rebuilt 1:1 as a core:FragmentDefinition -> Dialog shown via client->popup_display (the CAPABILITIES.md pattern, app 042). The Link press ships the row's ProductPicUrl` &&
               ` via t_arg ${PRODUCT_PIC_URL} - the original reads evt.getSource().getTarget(), whose target property is bound to the same column. The Close button maps to client->_event_client( popup_close ); the` &&
               ` original's afterClose destroy is handled by the framework's popup lifecycle and is not wired separately.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.CustomListItem`                  name = `CustomListItem`                                class = `z2ui5_cl_dmo_app_014` path = `src/01/b05/z2ui5_cl_dmo_app_014.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a` &&
                 ` close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.CustomTreeItem`                  name = `CustomTreeItem`                                class = `z2ui5_cl_dmo_app_015` path = `src/01/b05/z2ui5_cl_dmo_app_015.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.48.0`
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port`
        notes = `NOTE: the original binds the Tree's items to the whole JSON model root (items="{path: '/'}", the model IS the node array from Tree.json); abap2UI5 serves a single default model, so the array is` &&
                 ` flattened into it as the bound table T_TREE and the binding-info keeps its shape with the bound path substituted for '/' (nested tree binding is expressible per CAPABILITIES.md, proven by app 054).` &&
                 ` // NOTE: the flat ABAP row types serialize an empty NODES array on leaf rows where the original Tree.json simply omits the 'nodes' property (levels 1-4; the level-5 row type carries no NODES field at` &&
                 ` all); ClientTreeBinding treats an empty child array as a childless node, so the rendered tree matches. TEXT and REF are present on every original node - no absent-property/empty-string enum risk.` ) ).

    lv_text1 = `POST-1.71: Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port on both Buttons - the app needs a UI5 release >= 1.84 to render it. // POST-1.71: Link.ariaHasPopup (since` &&
               ` UI5 1.86) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.86 to render it. // POST-1.71: DatePicker.hideInput (since UI5 1.97) is newer than 1.71 but kept for the 1:1` &&
               ` port - the sample's central property (the picker input stays hidden, opened only via the anchor controls); openBy is also since 1.97, so the app needs a UI5 release >= 1.97 to render this sample's` &&
               ` behavior. // NOTE: the 2026-07-22 rework (openBy via _event_client instead of follow_up_action, client-composed date toast, app became init-only) is live-verified on 2026-08-02 - each anchor opens` &&
               ` the hidden DatePicker and picking a date toasts the value. // NOTE: the headless e2e finding of 2026-07-30 (clicking an openBy anchor opens the popover, then Popover.onfocusin recurses off the` &&
               ` hideInput input - Maximum call stack size exceeded) is resolved as HEADLESS-ONLY: the picker opens and works in a real browser (2026-08-02 live check). The check covered the visible behaviour; the`.
    lv_text1 = lv_text1 && ` browser console was not necessarily inspected for a silent recursion warning. The e2e interaction stays deliberately unarmed for this app - app 091 covers the hidden-picker openBy class.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.DatePicker`                      name = `DatePickerHidden`                              class = `z2ui5_cl_dmo_app_016` path = `src/01/b05/z2ui5_cl_dmo_app_016.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a` &&
                 ` close look.`
        since = `1.22.0`
        is_post171 = abap_true
        checked = `CHECKED (2026-08-02): verified in a running system - human live check 2026-08-02 (maintainer), re-check after the 2026-07-22 roundtrip-free rework: each anchor opens the hidden DatePicker and picking` &&
                 ` a date toasts the value. Live-checked reference example for: frontend action (openBy/domRef), $event.oSource.sId anchor transport, POST_171 discipline`
        notes = lv_text1
        post171 = `Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port on both Buttons - the app needs a UI5 release >= 1.84 to render it. // Link.ariaHasPopup (since UI5 1.86) is newer` &&
                 ` than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.86 to render it. // DatePicker.hideInput (since UI5 1.97) is newer than 1.71 but kept for the 1:1 port - the sample's central` &&
                 ` property (the picker input stays hidden, opened only via the anchor controls); openBy is also since 1.97, so the app needs a UI5 release >= 1.97 to render this sample's behavior.` ) ).

    lv_text1 = `NOTE: The onInit-seeded JSON model rides 1:1 in model_init (5 rows, the derived label texts written out); every row carries a valueState so the absent-enum-empty-string trap does not apply, and the` &&
               ` rows without a valueStateText keep the empty string - a string property, where the empty value falls back to the state default text like the original undefined. // NOTE: **e2e-verified 2026-08-01**` &&
               ` (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): all five rows render from the real backend model - the labels arrive, each of the four non-None value states reaches the DOM` &&
               ` exactly once (sapMInputBaseContentWrapper<State> on the DatePicker) and the bound valueStateText of the Warning row is written into the value-state node. Residual (nothing headless can assert): the` &&
               ` value-state message popup's wrapping of the long text, which needs the theme CSS the harness does not load.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.DatePicker`                      name = `DatePickerValueState`                          class = `z2ui5_cl_dmo_app_253` path = `src/01/b19/z2ui5_cl_dmo_app_253.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0`
        notes = lv_text1 ) ).

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
      ( module = `sap.m`              control = `sap.m.DateRangeSelection`              name = `DateRangeSelection`                            class = `z2ui5_cl_dmo_app_017` path = `src/01/b06/z2ui5_cl_dmo_app_017.clas.abap`
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
               ` openBy ($event.oSource.sId), and the change toast is client-composed from ${$parameters>/value} - the controller handlers fold into the two wire forms 1:1. // NOTE: live-verified on 2026-08-02: the` &&
               ` anchored open of the hideInput picker and the change-value toast both work in a real browser. The 016 headless finding (Popover.onfocusin recursion on the hidden input) is therefore headless-only for` &&
               ` this control too; no e2e interaction is armed for the hidden-picker class.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.DateRangeSelection`              name = `DateRangeSelectionHidden`                      class = `z2ui5_cl_dmo_app_256` path = `src/01/b19/z2ui5_cl_dmo_app_256.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a` &&
                 ` close look.`
        since = `1.22.0`
        is_post171 = abap_true
        checked = `CHECKED (2026-08-02): verified in a running system - human live check 2026-08-02 (maintainer): all anchors open the hideInput picker and the change toast carries the picked value.`
        notes = lv_text1
        post171 = `sap.m.Button.ariaHasPopup (@1.84) and sap.m.Link.ariaHasPopup (@1.86) kept 1:1 on the three anchors; also hideInput on the picker (@1.97 per the 016 precedent). The app needs a UI5 release >= 1.97.` ) ).

    lv_text1 = `NOTE: The onInit-seeded JSON model rides 1:1 in model_init (5 rows, the derived label texts written out); every row carries a valueState so the absent-enum-empty-string trap does not apply, and the` &&
               ` rows without a valueStateText keep the empty string (falls back to the state default text like the original undefined) - the app-253 pattern. // NOTE: **e2e-verified 2026-08-01**` &&
               ` (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): all five rows render from the real backend model - the labels arrive, each of the four non-None value states reaches the DOM` &&
               ` exactly once (sapMInputBaseContentWrapper<State> on the DateRangeSelection) and the bound valueStateText of the Warning row is written into the value-state node. Residual (nothing headless can` &&
               ` assert): the value-state message popup's wrapping of the long text, which needs the theme CSS the harness does not load.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.DateRangeSelection`              name = `DateRangeSelectionValueState`                  class = `z2ui5_cl_dmo_app_254` path = `src/01/b19/z2ui5_cl_dmo_app_254.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: the JSON model's UI5Date instances become date strings in the flat ABAP model: the sap.ui.model.type.DateTime bindings (DTP2/3/4/5/8) get an added source pattern 'yyyy-MM-dd HH:mm:ss'` &&
               ` format option so the type parses the model string (CAPABILITIES: Date types over ISO strings need a source pattern), and the sap.ui.model.odata.type.DateTimeOffset parts of DTP10/DTP11 get added` &&
               ` constraints {V4: true} so the DateTimeWithTimezone composite receives a parsed Date internal value (source-verified in DateTimeOffset.js getModelFormat/CompositeBinding internal values); valueDTP10` &&
               ` is the UTC string '2023-03-31T10:32:30Z' instead of the original's local-time UI5Date, and DTP3/DTP5 'now' comes from server sy-datum/sy-uzeit instead of the browser clock. // IMPROVISED: the` &&
               ` controller's byId('DTP6').setInitialFocusedDateValue(UI5Date.getInstance(2017, 5, 13, 11, 12, 13)) is expressed as a bound initialFocusedDateValue property with the Formatter.DateCreateObject module` &&
               ` formatter over the model string '2017-06-13T11:12:13' (CAPABILITIES date-object row) - extra initialFocusedDateValue attribute on DTP6 plus xmlns:core and core:require on the view root vs the`.
    lv_text1 = lv_text1 && ` original view.xml. // NOTE: the controller's handleChange becomes a CHANGE round-trip: the source control id, entered value and valid flag travel via $event.oSource.sId / ${$parameters>/value} /` &&
               ` ${$parameters>/valid}; the textResult Text.text becomes a binding and every change-firing picker (DTP1/2/3/4/6/7) gets an added bound valueState attribute, initialized to 'None' so no empty string` &&
               ` reaches the enum-typed property - the original sets both imperatively on the controls. // NOTE: the view-level attachParseError/attachValidationSuccess handlers of the original controller (valueState` &&
               ` Error/None on binding parse errors in the data-binding panel) are covered by the framework's automatic handleValidation registration on every view slot (CAPABILITIES MessageManager row,` &&
               ` pr/message-model) - no port code needed. // NOTE: model flattening: the original model's valueDTP9 is bound by no control in the view and is dropped; valueDTP11 (null in the original) serializes as` &&
               ` an empty string in the flat ABAP model, which the V4 DateTimeOffset model format parses back to null, so DTP11 renders timezone-only like the original. // POST-1.71: showCurrentDateButton (since UI5`.
    lv_text1 = lv_text1 && ` 1.95) on DTP2 is kept for the 1:1 port. // POST-1.71: showCurrentTimeButton (since UI5 1.98) on DTP2 and DTP11 is kept for the 1:1 port. // POST-1.71: showTimezone (since UI5 1.99) on DTP8 and DTP11` &&
               ` is kept for the 1:1 port. // POST-1.71: timezone (since UI5 1.99) on DTP8 is kept for the 1:1 port. // POST-1.71: core:require of the z2ui5/model/formatter module on the view root needs UI5 >= 1.74,` &&
               ` and the sap.ui.model.odata.type.DateTimeWithTimezone binding type of DTP10/DTP11 (since UI5 1.99) is kept 1:1 - the app needs a UI5 release >= 1.99 overall.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.DateTimePicker`                  name = `DateTimePicker`                                class = `z2ui5_cl_dmo_app_018` path = `src/01/b06/z2ui5_cl_dmo_app_018.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
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
               ` openBy ($event.oSource.sId), and the change toast is client-composed from ${$parameters>/value} - the controller handlers fold into the two wire forms 1:1. // NOTE: live-verified on 2026-08-02: the` &&
               ` anchored open of the hideInput picker and the change-value toast both work in a real browser. The 016 headless finding (Popover.onfocusin recursion on the hidden input) is therefore headless-only for` &&
               ` this control too; no e2e interaction is armed for the hidden-picker class.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.DateTimePicker`                  name = `DateTimePickerHidden`                          class = `z2ui5_cl_dmo_app_257` path = `src/01/b19/z2ui5_cl_dmo_app_257.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a` &&
                 ` close look.`
        since = `1.38.0`
        is_post171 = abap_true
        checked = `CHECKED (2026-08-02): verified in a running system - human live check 2026-08-02 (maintainer): all anchors open the hideInput picker and the change toast carries the picked value.`
        notes = lv_text1
        post171 = `sap.m.Button.ariaHasPopup (@1.84) and sap.m.Link.ariaHasPopup (@1.86) kept 1:1 on the three anchors; also hideInput on the picker (@1.97 per the 016 precedent). The app needs a UI5 release >= 1.97.` ) ).

    lv_text1 = `NOTE: The onInit-seeded JSON model rides 1:1 in model_init (5 rows, the derived label texts written out); every row carries a valueState so the absent-enum-empty-string trap does not apply, and the` &&
               ` rows without a valueStateText keep the empty string (falls back to the state default text like the original undefined) - the app-253 pattern. // NOTE: **e2e-verified 2026-08-01**` &&
               ` (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): all five rows render from the real backend model - the labels arrive, each of the four non-None value states reaches the DOM` &&
               ` exactly once (sapMInputBaseContentWrapper<State> on the DateTimePicker) and the bound valueStateText of the Warning row is written into the value-state node. Residual (nothing headless can assert):` &&
               ` the value-state message popup's wrapping of the long text, which needs the theme CSS the harness does not load.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.DateTimePicker`                  name = `DateTimePickerValueState`                      class = `z2ui5_cl_dmo_app_255` path = `src/01/b19/z2ui5_cl_dmo_app_255.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.38.0`
        notes = lv_text1 ) ).

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
      ( module = `sap.m`              control = `sap.m.Dialog`                          name = `DialogConfirm`                                 class = `z2ui5_cl_dmo_app_019` path = `src/01/b06/z2ui5_cl_dmo_app_019.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed); live-checked reference example for: fragment-popup` &&
                 ` dialogs, roundtrip-free live-enable expression, popup_close paths`
        notes = lv_text1 ) ).

    lv_text1 = `POST-1.71: sap.m.Dialog.showFullScreenButton is @since 1.149 - it is the very property this sample demonstrates, so dropping it would drop the sample. Kept 1:1 (fidelity-first, the corpus-wide` &&
               ` POST_171 policy); the app needs UI5 >= 1.149 to show the toggle, everything else renders on 1.71. // NOTE: the original builds its three Dialogs imperatively in the controller (new` &&
               ` Dialog({...}).open(), each cached in a controller field and added as a view dependent); the port expresses each as a core:FragmentDefinition popup shown via client->popup_display on the button press` &&
               ` (app 019/273 precedent). Every fragment control is therefore EXTRA vs the archived V.view.xml, which holds only the three trigger Buttons: Dialog, List, StandardListItem and the dialog's own OK/Close` &&
               ` Buttons (Button 3 -> 5, Dialog/List/StandardListItem 0 -> 1 per open dialog). // NOTE: the three dialogs differ only in resizable / draggable / the fixed contentWidth+contentHeight and in the first` &&
               ` one's extra Emphasized OK begin button, so the port builds them through one popup_products_display( resizable draggable sized begin_ok ) method. Each flag is written ONLY when the original passes it`.
    lv_text1 = lv_text1 && ` - the plain dialog gets no resizable='false' and no contentWidth, so no attribute the original never sets is added. // NOTE: the List binds the shared demo mock products.json /ProductCollection (all` &&
               ` 123 rows, Name + Quantity - the only two fields the StandardListItem binds) inlined into model_init; the original loads the same file through a JSONModel. Both dialog buttons (OK and Close) close the` &&
               ` dialog client-side via _event_client( cs_event-popup_close ), the direct form of the original's this.oDialog.close(). // NOTE: **e2e-verified 2026-08-01** (scripts/e2e-smoke.mjs interaction,` &&
               ` transpiled backend + real browser): the plain dialog opens with its title 'Available Products' and the bound 123-row product list inside it, and the Close button closes it client-side (popup_close).` &&
               ` Residual (nothing headless can assert): the fullscreen toggle itself (needs UI5 >= 1.149) and the resizable/draggable behaviour of the other two dialogs, which differ only in the flags the same` &&
               ` builder writes.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Dialog`                          name = `DialogFullScreen`                              class = `z2ui5_cl_dmo_app_274` path = `src/01/b15/z2ui5_cl_dmo_app_274.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        is_post171 = abap_true
        checked = `CHECKED (2026-08-02): verified in a running system - human live check 2026-08-02 (maintainer): app started and exercised, no findings.`
        notes = lv_text1
        post171 = `sap.m.Dialog.showFullScreenButton is @since 1.149 - it is the very property this sample demonstrates, so dropping it would drop the sample. Kept 1:1 (fidelity-first, the corpus-wide POST_171 policy);` &&
                 ` the app needs UI5 >= 1.149 to show the toggle, everything else renders on 1.71.` ) ).

    lv_text1 = `NOTE: the original builds its five Message Dialogs imperatively in the controller (new Dialog({type: Message, title, state, content: new Text(...), beginButton: new Button(...)}).open()); the port` &&
               ` expresses each as a core:FragmentDefinition popup shown via client->popup_display on the button press event - the CAPABILITIES.md 1:1 path for controller-built Dialogs (app 019 precedent). Every` &&
               ` fragment control is therefore EXTRA vs the archived V.view.xml, which holds only the five trigger Buttons: Dialog, Text and the dialog's own OK Button (Button 5 -> 6, Dialog 0 -> 1, Text 0 -> 1 per` &&
               ` open dialog). // NOTE: the five handlers differ only in title / state / content text, so the port builds them through one popup_message_display( title state text ) method instead of five` &&
               ` near-identical blocks. The ``state`` attribute is written only when the original passes one: onDefaultMessageDialogPress builds its Dialog WITHOUT a state, and writing state='None' explicitly would` &&
               ` be an added attribute rather than the inherited default. // NOTE: the original keeps each Dialog in a controller field and reuses it (if (!this.oDialog) ...); abap2UI5 rebuilds the fragment per open,`.
    lv_text1 = lv_text1 && ` which is the framework's popup lifecycle - the same deviation the other popup ports carry. The OK button's press (this.oDialog.close()) is reproduced roundtrip-free as _event_client(` &&
               ` cs_event-popup_close ). // NOTE: **e2e-verified 2026-08-01** (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): the Default and the Error dialog each open with their own` &&
               ` title/state/text and close again on the Emphasized OK button (popup_close, no round-trip) - the second open proves the rebuild-per-open lifecycle works. The other three differ only in the three` &&
               ` literals the same builder method fills in, and render-smoke covers their views.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Dialog`                          name = `DialogMessage`                                 class = `z2ui5_cl_dmo_app_273` path = `src/01/b15/z2ui5_cl_dmo_app_273.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        checked = `CHECKED (2026-08-02): verified in a running system - human live check 2026-08-02 (maintainer): app started and exercised, no findings.`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: the shared mock model sap/ui/demo/mock/supplier.json is flattened into the default model: the row type keeps only the six bound columns (SupplierName, Street, HouseNumber, ZIPCode, City,` &&
               ` Country) of the single /SupplierCollection record and drops the unbound columns (Url, Twitter, Tel, Sms, Mobile, Pager, Fax, Email, Rating, Prime, Disposable); the record itself is kept verbatim. //` &&
               ` NOTE: the sample controller loads the shared mock sap/ui/demo/mock/supplier.json - snapshotted byte-identical into ui5/mock/supplier.json (2026-07-20, git sparse checkout of SAP/openui5 master); one` &&
               ` SupplierCollection record, full row set, values verifiable offline. // NOTE: element binding binding="{/T_SUPPLIERS/0}" with relative DisplayListItem value bindings - the binding= context mechanism` &&
               ` is already live-verified via app 041 (checked 2026-07-19); the /0 array-index path variant is a plain JSONModel path resolution, source-decidable, so no LIVE_TEST is carried.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.DisplayListItem`                 name = `DisplayListItem`                               class = `z2ui5_cl_dmo_app_020` path = `src/01/b06/z2ui5_cl_dmo_app_020.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 3 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: the controller's imperative DraftIndicator calls (showDraftSaving/showDraftSaved/clearDraftState on byId('draftIndi')) are not in the FrontendAction CONTROL_METHODS whitelist; per AGENTS 'prefer` &&
               ` a bindable property over a frontend action' the port two-way binds the control's public state property (sap.m.DraftIndicatorState, since 1.32) and sets Saving/Saved/Clear in the three event handlers.` &&
               ` Source-verified equivalent: a binding update calls the public mutator (ManagedObjectBindingSupport.updateProperty -> _sMutator), and DraftIndicator.setState queues exactly what the three methods` &&
               ` queue (setState('Saving') queues Saving+Clear like showDraftSaving, sap/m/DraftIndicator.js). Adds the state attribute on the DraftIndicator vs the original view.xml. // NOTE: pressing the same` &&
               ` button twice in direct succession does not re-run the indicator - the model value is unchanged, so no binding change fires and setState is not called again (the original re-queues on every method` &&
               ` call); pressing a different button in between restores the behaviour.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.DraftIndicator`                  name = `DraftIndicator`                                class = `z2ui5_cl_dmo_app_021` path = `src/01/b06/z2ui5_cl_dmo_app_021.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.32.0`
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: the bound lists="{/ProductCollectionStats/Filters}" collection is represented as two static FacetFilterLists (Category, SupplierName) - the original's stats model yields exactly these two lists,` &&
               ` so this is a faithful equivalent; the facet values inside each list stay bound to a FacetFilterItem template. A doubly-nested variant (bind the FacetFilter lists aggregation to a nested table,` &&
               ` FacetFilterList template with a relative items binding over each filter's values) is source-plausible now that nested binding is expressible, but no port proves that aggregation-of-aggregation` &&
               ` template shape yet - LIVE_TEST before adopting it. // NOTE: selection transport - every FacetFilterItem binds selected two-way; on listClose/reset the backend reads/clears the flags and re-filters.` &&
               ` This is the documented 1:1 path (CAPABILITIES.md marks controller-read FacetFilter/List multi-select as expressible with app 022 as its evidence port), not a workaround; the model is applied before` &&
               ` on_event runs. // NOTE: the original controller appends the sap.m.sample.Table component's table with its first cell swapped for an ObjectIdentifier {Name}/{Category}; that table is rebuilt inline.`.
    lv_text1 = lv_text1 && ` The price column keeps the original sap.ui.model.type.Currency composite binding 1:1 (raw binding-info string over a numeric PRICE field). // NOTE: the sticky options Label and the three sticky` &&
               ` CheckBox controls are BACK (2026-08-05). The earlier rationale - 'neither an array property binding nor a setSticky whitelist entry is a proven path' - was wrong on the first half: app 009 binds` &&
               ` Table.sticky to an ABAP string table and is live-verified. This port now uses that same pattern: sticky is bound to t_sticky, each CheckBox round-trips ${$source>/text} + ${$parameters>/selected} and` &&
               ` the backend maintains the set (a set operation is backend work; setSticky was whitelisted upstream in the same round for the imperative case, but the bound path is the thin-frontend one). The three` &&
               ` controls come from the appended sap.m.sample.Table view, which this port rebuilds inline, so they count as extra against the archived FacetFilter original. The neighbouring onPopinLayoutChanged is` &&
               ` unchanged and still expressed as bound properties (the app-009 pattern), so the ComboBox ``change`` attribute stays dropped: its selectedKey is bound two-way and the Table's popinLayout is an`.
    lv_text1 = lv_text1 && ` expression binding over it, including the Block default. // NOTE: Restored 2026-08-05/06. The sticky options Label and the three sticky CheckBoxes are present and work: Table.sticky is an` &&
               ` ARRAY-valued property, and binding it to a plain ABAP string table IS the proven path - app 009 does exactly that and is live-verified. Each CheckBox select round-trips ${$source>/text} and` &&
               ` ${$parameters>/selected}, the ABAP handler inserts or removes that option and pushes the model back, which is the array maintenance the original's onSelect does with setSticky. The sidecar's earlier` &&
               ` claim - that neither an array property binding nor a setSticky whitelist entry was a proven path - was FALSE when it was written and is corrected here rather than quietly deleted; the whitelist entry` &&
               ` that followed (CONTROL_METHODS setSticky) closes a different footgun, an imperative call that silently received a string. // 1.71: the p:ColumnAIAction column plugin (sap.m.plugins, far newer than` &&
               ` UI5 1.71) is dropped with its dependents aggregation and press toast - the plugin class does not exist on a 1.71 runtime, so keeping it would crash view creation there. // NOTE: the original's nested`.
    lv_text1 = lv_text1 && ` items-binding filter (ORs inside each facet group, AND across the groups, model untouched) is expressed 1:1 as a declarative compound filter: apply_filter builds the groups JSON from the two-way` &&
               ` bound selected flags and schedules follow_up_action cs_event-binding_call filter on idProductsTable/items (compound groups implemented upstream 2026-07-20, pr/binding-call-compound-filters); the` &&
               ` earlier ABAP-side model rebuild and the t_products_all mirror are gone. // NOTE: the original derives the ObjectNumber weight state in its frontend Formatter.js (weightState: KG conversion +` &&
               ` Success/Warning/Error thresholds). That is business logic, so - abap2UI5 being a thin frontend - it is computed in ABAP model_init into a WEIGHT_STATE field and bound state="{WEIGHT_STATE}", not via` &&
               ` a frontend formatter (core:require dropped). Visually 1:1 with the original.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.FacetFilter`                     name = `FacetFilterLight`                              class = `z2ui5_cl_dmo_app_022` path = `src/01/b04/z2ui5_cl_dmo_app_022.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
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
               ` is emitted. // NOTE: the original controller appends the sap.m.sample.Table component's table with its first cell swapped for an ObjectIdentifier {Name}/{Category}; that table is rebuilt inline. The` &&
               ` price column keeps the original sap.ui.model.type.Currency composite binding 1:1 (raw binding-info string over a numeric PRICE field). // NOTE: the sticky options Label and the three sticky CheckBox` &&
               ` controls are BACK (2026-08-05). The earlier rationale - 'neither an array property binding nor a setSticky whitelist entry is a proven path' - was wrong on the first half: app 009 binds Table.sticky`.
    lv_text1 = lv_text1 && ` to an ABAP string table and is live-verified. This port now uses that same pattern: sticky is bound to t_sticky, each CheckBox round-trips ${$source>/text} + ${$parameters>/selected} and the backend` &&
               ` maintains the set (a set operation is backend work; setSticky was whitelisted upstream in the same round for the imperative case, but the bound path is the thin-frontend one). The three controls come` &&
               ` from the appended sap.m.sample.Table view, which this port rebuilds inline, so they count as extra against the archived FacetFilter original. The neighbouring onPopinLayoutChanged is unchanged and` &&
               ` still expressed as bound properties (the app-009 pattern), so the ComboBox ``change`` attribute stays dropped: its selectedKey is bound two-way and the Table's popinLayout is an expression binding` &&
               ` over it, including the Block default. // NOTE: Restored 2026-08-05/06. The sticky options Label and the three sticky CheckBoxes are present and work: Table.sticky is an ARRAY-valued property, and` &&
               ` binding it to a plain ABAP string table IS the proven path - app 009 does exactly that and is live-verified. Each CheckBox select round-trips ${$source>/text} and ${$parameters>/selected}, the ABAP`.
    lv_text1 = lv_text1 && ` handler inserts or removes that option and pushes the model back, which is the array maintenance the original's onSelect does with setSticky. The sidecar's earlier claim - that neither an array` &&
               ` property binding nor a setSticky whitelist entry was a proven path - was FALSE when it was written and is corrected here rather than quietly deleted; the whitelist entry that followed` &&
               ` (CONTROL_METHODS setSticky) closes a different footgun, an imperative call that silently received a string. // 1.71: the p:ColumnAIAction column plugin (sap.m.plugins, far newer than UI5 1.71) is` &&
               ` dropped with its dependents aggregation and press toast - the plugin class does not exist on a 1.71 runtime, so keeping it would crash view creation there. // NOTE: the original's nested` &&
               ` items-binding filter (ORs inside each facet group, AND across the groups, model untouched) is expressed 1:1 as a declarative compound filter: apply_filter builds the groups JSON from the two-way` &&
               ` bound selected flags and schedules follow_up_action cs_event-binding_call filter on idProductsTable/items (compound groups implemented upstream 2026-07-20, pr/binding-call-compound-filters). // NOTE:`.
    lv_text1 = lv_text1 && ` the original derives the ObjectNumber weight state in its frontend Formatter.js (weightState: KG conversion + Success/Warning/Error thresholds). That is business logic, so - abap2UI5 being a thin` &&
               ` frontend - it is computed in ABAP model_init into a WEIGHT_STATE field and bound state="{WEIGHT_STATE}", not via a frontend formatter (core:require dropped). Visually 1:1 with the original.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.FacetFilter`                     name = `FacetFilterSimple`                             class = `z2ui5_cl_dmo_app_235` path = `src/01/b19/z2ui5_cl_dmo_app_235.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.FeedContent`                     name = `FeedContent`                                   class = `z2ui5_cl_dmo_app_023` path = `src/01/b06/z2ui5_cl_dmo_app_023.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        checked = `CHECKED (2026-07-20): verified in a running system - human pass 2026-07-20: app starts and renders like the original; no interaction paths were open for this port` )
      ( module = `sap.m`              control = `sap.m.FeedInput`                       name = `Feed`                                          class = `z2ui5_cl_dmo_app_024` path = `src/01/b06/z2ui5_cl_dmo_app_024.clas.abap`
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
      ( module = `sap.m`              control = `sap.m.FeedInput`                       name = `FeedInput`                                     class = `z2ui5_cl_dmo_app_236` path = `src/01/b19/z2ui5_cl_dmo_app_236.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.22`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `the FeedInput 'actions' aggregation (a Button next to the text area) is @since 1.139 - kept 1:1 on the last two FeedInputs; the app needs a UI5 release >= 1.139 to render it.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.FeedListItem`                    name = `FeedListItem`                                  class = `z2ui5_cl_dmo_app_025` path = `src/01/b06/z2ui5_cl_dmo_app_025.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `NOTE: the original's removeItem derives the entry index from the item's binding-context path (getBindingContext().getPath().split('/').pop()); the port transports the List's indexOfItem(item) instead` &&
                 ` - the aggregation index equals the model index for this bound list, so the spliced row is the same. // NOTE: feed.json entries 2 and 4 have no Actions property; the flat ABAP row type serializes` &&
                 ` ACTIONS as an empty array ([] instead of undefined) - the actions aggregation renders no actions either way, and an empty array is not an empty-string/enum hazard. // NOTE: the relative AuthorPicUrl` &&
                 ` asset paths (test-resources/sap/m/images/*.jpg) are rewritten to absolute https://sdk.openui5.org/test-resources/... per the project rule for runtime asset URLs.` )
      ( module = `sap.m`              control = `sap.m.FlexBox`                         name = `FlexBoxGap`                                    class = `z2ui5_cl_dmo_app_158` path = `src/01/b16/z2ui5_cl_dmo_app_158.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = `NOTE: Three Panels demonstrating FlexBox gap / columnGap / rowGap (wrap=Wrap), each with nine typed Buttons, reproduced 1:1. // POST-1.71: FlexBox.gap, FlexBox.columnGap and FlexBox.rowGap (all @since` &&
                 ` 1.134) are used 1:1 - they are the sample's whole point. Newer than UI5 1.71; declared per the property-171 policy, so the app needs UI5 >= 1.134 to render the gaps.`
        post171 = `FlexBox.gap, FlexBox.columnGap and FlexBox.rowGap (all @since 1.134) are used 1:1 - they are the sample's whole point. Newer than UI5 1.71; declared per the property-171 policy, so the app needs UI5` &&
                 ` >= 1.134 to render the gaps.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.FlexBox`                         name = `FlexBoxNested`                                 class = `z2ui5_cl_dmo_app_026` path = `src/01/b04/z2ui5_cl_dmo_app_026.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-19): verified in a running system - human visual pass 2026-07-19 over all apps: the six flex items and the h2 headings render with their injected-CSS background colours like the` &&
                 ` original.`
        notes = `NOTE: the original colours .item1..item6 and the h2 headings via a separate style.css; here it is injected as a core:HTML content attribute (a style tag, minified - see CAPABILITIES.md; the EXTRA` &&
                 ` core:HTML control vs the original view). Confirmed rendering via the human visual pass 2026-07-19.` )
      ( module = `sap.m`              control = `sap.m.FlexBox`                         name = `FlexBoxRenderType`                             class = `z2ui5_cl_dmo_app_190` path = `src/01/b17/z2ui5_cl_dmo_app_190.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` )
      ( module = `sap.m`              control = `sap.m.FormattedText`                   name = `FormattedText`                                 class = `z2ui5_cl_dmo_app_154` path = `src/01/b15/z2ui5_cl_dmo_app_154.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.38.0`
        notes = `NOTE: FormattedText.htmlText bound to a model field holding the original controller's demo HTML string (headings, link, list, pre, code, cite, dl) 1:1.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.GenericTag`                      name = `GenericTag`                                    class = `z2ui5_cl_dmo_app_027` path = `src/01/b06/z2ui5_cl_dmo_app_027.clas.abap`
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
               ` link tiles (since UI5 1.76) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.76 to render it. // NOTE: the relative test-resources image and backgroundImage paths are` &&
               ` resolved to absolute sdk.openui5.org URLs so the tile images load standalone. // NOTE: the custom CSS class tileLayout (float: left) is kept and its style.css injected via a core:HTML content` &&
               ` attribute (see CAPABILITIES.md; the EXTRA core:HTML control vs the original view). Confirmed rendering via the human visual pass 2026-07-19.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.GenericTile`                     name = `GenericTileAsKPITile`                          class = `z2ui5_cl_dmo_app_028` path = `src/01/b01/z2ui5_cl_dmo_app_028.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a` &&
                 ` close look.`
        since = `1.34.0`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-19): verified in a running system - human visual pass 2026-07-19 over all apps: the KPI tiles float left via the injected tileLayout CSS and render like the original.`
        notes = lv_text1
        post171 = `frameType values OneByHalf / TwoByHalf (since UI5 1.83) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.83 to render them; OneByOne / TwoByOne (1.71) were never` &&
                 ` affected. // systemInfo and appShortcut (since UI5 1.92) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.92 to render them. // url on the link tiles (since UI5 1.76)` &&
                 ` is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.76 to render it.` ) ).

    lv_text1 = `NOTE: the sample's style.css (one rule: .tileLayout floats left) is injected through an extra core:HTML style leaf (app 122/124/270 precedent) - one control the archived Page.view.xml does not have` &&
               ` (core:HTML 0 -> 1). The literal braces of the CSS rule are escaped in the ABAP literal because the XMLView parser reads an unescaped brace in an attribute value as a binding. // NOTE: the` &&
               ` controller's only handler is MessageToast.show('The generic tile is pressed.') with a CONSTANT text, so every press wire is the roundtrip-free client toast (_event_client cs_event-control_global` &&
               ` MESSAGE_TOAST.show, app 005 idiom) and the app stays init-only. The four tiles the original leaves without a press handler keep none, so the 'no press event' half of the sample still demonstrates` &&
               ` exactly that. // NOTE: the two SlideTile tiles carry backgroundImage paths that point into ANOTHER sample's folder (test-resources/sap/m/demokit/sample/GenericTileAsFeedTile/images/NewsImage1.png and` &&
               ` NewsImage2.png); they are kept verbatim and only host-absolutized to https://sdk.openui5.org/ per the runtime asset-URL rule, so the images resolve against the OpenUI5 host exactly as in the demo`.
    lv_text1 = lv_text1 && ` kit. The sample's own images/headerImg2.jpg is referenced by no control in the view and is therefore not seeded. // NOTE: live-verified on 2026-08-02 (maintainer live check): the Loading / Failed /` &&
               ` Disabled tiles paint their placeholder, error and disabled visuals and the SlideTile slides between its two tiles.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.GenericTile`                     name = `GenericTileStates`                             class = `z2ui5_cl_dmo_app_275` path = `src/01/b15/z2ui5_cl_dmo_app_275.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.34.0`
        checked = `CHECKED (2026-08-02): verified in a running system - human live check 2026-08-02 (maintainer): app started and exercised, no findings.`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: the Select's literal selectedKey="1" is replaced by a two-way binding {SELECTED_KEY} (seeded '1'); scrollStepByItem on both HeaderContainers is now a pure client-side expression binding over it` &&
               ` ({= ${SELECTED_KEY} === 'px' ? 0 : +${SELECTED_KEY} }), so the original Select's change handler (.scrollChanged) is dropped - no round-trip. This is the prefer-a-bindable-property/expression pattern` &&
               ` (like the app 019). The original controller reads oEvent.getParameter('selectedItem').getKey(), which has no public $parameters path (selectedItem is a control; reading private control internals is` &&
               ` banned). // NOTE: the controller's setScrollStepByItem(0 | Number(key)) on both containers is reproduced by the scrollStepByItem expression binding above (px -> 0, else the number); seeded via` &&
               ` SELECTED_KEY='1' it matches the UI5 property default (HeaderContainer.js defaultValue: 1), so the initial arrow scroll is one item and selecting px sets 0 (px stepping via scrollStep), exactly like` &&
               ` the controller - all client-side, no scroll_step_by_item field. // NOTE: the NumericContent press ('Fire press' MessageToast) is wired roundtrip-free via client->_event_client(`.
    lv_text1 = lv_text1 && ` cs_event-control_global, MESSAGE_TOAST/show ) - the original's client-side MessageToast.show 1:1; the app is now init-only (no on_event). An unused xmlns:l namespace was dropped. // NOTE:` &&
               ` live-verified 2026-08-04 (nightly e2e interaction): the scroll-step selection and the tile-press toast were switched from server round-trips to client-side expression binding / _event_client(` &&
               ` control_global ) on 2026-07-22 - re-verify in a running system that selecting an item/px still changes the arrow scroll step on both containers and that pressing a NumericContent still toasts 'Fire` &&
               ` press'. **e2e-verified 2026-07-31** (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): pressing the first NumericContent tile raises its client-composed toast ('Fire press'). The` &&
               ` scroll-step Select (item/px) is NOT covered - it sits in the sample's option area and needs a human check.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.HeaderContainer`                 name = `HeaderContainer`                               class = `z2ui5_cl_dmo_app_029` path = `src/01/b06/z2ui5_cl_dmo_app_029.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.44.0`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.HeaderContainer`                 name = `HeaderContainerVM`                             class = `z2ui5_cl_dmo_app_157` path = `src/01/b16/z2ui5_cl_dmo_app_157.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.44.0`
        notes = `NOTE: NumericContent presses show a client MessageToast ('Fire press', the original press handler's text - review fixed the earlier text copied from the NumericContentDifColors neighbour). Two` &&
                 ` vertical HeaderContainers — one of eight NumericContents, one of five TileContents (each wrapping a NumericContent) — reproduced 1:1. **e2e-verified 2026-07-30** (transpiled-framework interaction,` &&
                 ` scripts/e2e-smoke.mjs): pressing the first NumericContent toasts 'Fire press'; the other tiles are the identical wire.` ) ).

    lv_text1 = `POST-1.71: two members and one control newer than UI5 1.71 are kept 1:1 because they ARE the sample: sap.m.BadgeCustomData (control since 1.80, the badge marker in every customData aggregation -` &&
               ` declared by policy, the property gate does not resolve it) and sap.m.IconTabFilter.items (since 1.77, the nested sub-tabs of iconTabBar8). The app needs a UI5 release >= 1.80. // NOTE: onInit adds 30` &&
               ` IconTabFilters to iconTabBar0 imperatively (text 'Tab n', key n, a Text 'Content n', and a BadgeCustomData visible on the 19th). The port builds that as a bound aggregation over T_TABS with one` &&
               ` template - so exactly one IconTabFilter, one Text and one BadgeCustomData more than the original view.xml carries, which is the template itself; the 30 instances come from the model, as they come` &&
               ` from the loop in the original. // NOTE: onTabDensityModeSelect loops over all nine bars and calls setTabDensityMode(selectedButton.getText()). tabDensityMode is a bindable property, so every` &&
               ` IconTabBar binds the one field TAB_DENSITY (added attribute, no structural diff) and only the RadioButtonGroup round-trips: its selectedIndex is bound two-way and the three values are derived`.
    lv_text1 = lv_text1 && ` server-side, per the prefer-a-bindable-property rule (linter rule settable-property-via-action).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.IconTabBar`                      name = `IconTabBarBadges`                              class = `z2ui5_cl_dmo_app_287` path = `src/01/b21/z2ui5_cl_dmo_app_287.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `two members and one control newer than UI5 1.71 are kept 1:1 because they ARE the sample: sap.m.BadgeCustomData (control since 1.80, the badge marker in every customData aggregation - declared by` &&
                 ` policy, the property gate does not resolve it) and sap.m.IconTabFilter.items (since 1.77, the nested sub-tabs of iconTabBar8). The app needs a UI5 release >= 1.80.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.IconTabBar`                      name = `IconTabBarStretchContent`                      class = `z2ui5_cl_dmo_app_030` path = `src/01/b04/z2ui5_cl_dmo_app_030.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed); incl. the phone-emulation device> check`
        notes = `NOTE: the original binds expanded="{device>/isNoPhone}" (a demo-kit helper model); expressed over the framework's device> model as the expression {= !${device>/system/phone} } - same truth value,` &&
                 ` different binding text. Confirmed on desktop and phone emulation in the 2026-07-20 live check.` )
      ( module = `sap.m`              control = `sap.m.IconTabHeader`                   name = `IconTabHeader`                                 class = `z2ui5_cl_dmo_app_055` path = `src/01/b07/z2ui5_cl_dmo_app_055.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.15` ) ).

    lv_text1 = `POST-1.71: sap.m.IllustratedMessage (control since UI5 1.98, with its description / title / illustrationType members) is newer than 1.71 but kept for the 1:1 port - it is the sample's whole point, the` &&
               ` error fallback. No gate sees it (the control is not in ui5/properties.json), so this entry is declared by policy; the app needs a UI5 release >= 1.98. // NOTE: the controller resolves` &&
               ` Device.system.phone once in onInit into the model fields imageHeight / imageWidth (5em on a phone, 10em otherwise). The port binds height and width to the same branch as an expression over the shared` &&
               ` device model instead of seeding one resolved value, so both branches survive - the model layer differs, the rendered size does not. // NOTE: the named img> model ({img>/products/pic1} from` &&
               ` sap/ui/demo/mock/img.json) folds onto the one default model as the bound field IMAGE_SRC, seeded with the mock's own HT-7777-large.jpg path absolutized to the sdk.openui5.org host. It stays a bound` &&
               ` field because the sample's Set-wrong-src button overwrites it at runtime (with /some/random/url, as in the original). // NOTE: live-verified on 2026-08-02 (maintainer live check): the initial load`.
    lv_text1 = lv_text1 && ` leaves HAS_ERROR false and Set-wrong-src fires error, hides the Image and reveals the IllustratedMessage. The error->swap half is additionally e2e-verified (scripts/e2e-smoke.mjs interaction); the` &&
               ` load leg cannot be checked headless (the seeded image sits on sdk.openui5.org).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Image`                           name = `ImageErrorWithIllustration`                    class = `z2ui5_cl_dmo_app_279` path = `src/01/b15/z2ui5_cl_dmo_app_279.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        checked = `CHECKED (2026-08-02): verified in a running system - human live check 2026-08-02 (maintainer): app started and exercised, no findings.`
        notes = lv_text1
        post171 = `sap.m.IllustratedMessage (control since UI5 1.98, with its description / title / illustrationType members) is newer than 1.71 but kept for the 1:1 port - it is the sample's whole point, the error` &&
                 ` fallback. No gate sees it (the control is not in ui5/properties.json), so this entry is declared by policy; the app needs a UI5 release >= 1.98.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Image`                           name = `ImageModeBackground`                           class = `z2ui5_cl_dmo_app_031` path = `src/01/b01/z2ui5_cl_dmo_app_031.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed); incl. the phone-emulation device> check`
        notes = `NOTE: the original binds src/mode to a JSONModel (img>/products, /imageMode); these fixed sample values are inlined here as literals (mode Background, the HT-7777 / HT-6100 demo images). height/width` &&
                 ` are restored over the device> model, see below. // NOTE: the custom CSS class imageContainer (light blue background) of the box4 HBox is kept and the sample's styles.css injected via a core:HTML` &&
                 ` content attribute (CAPABILITIES.md CSS row, as apps 028/026; the EXTRA core:HTML control vs the original view). Confirmed rendering via the human visual pass 2026-07-19.` )
      ( module = `sap.m`              control = `sap.m.ImageContent`                    name = `ImageContent`                                  class = `z2ui5_cl_dmo_app_056` path = `src/01/b07/z2ui5_cl_dmo_app_056.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.38`
        notes = `NOTE: the profile-image and logo ImageContent keep the sample's original demokit test-resources asset paths (test-resources/sap/m/demokit/sample/ImageContent/images/*.png) as the src literal 1:1;` &&
                 ` abap2UI5 does not serve those static assets, so only the first (sap-icon://area-chart) icon renders offline. The images are archived under ui5/sap.m/ImageContent/images/.` ) ).

    lv_text1 = `NOTE: The five core:Fragment references of App.view.xml (Input in the heading, HeaderContent in headerContent, and IllustratedMessage/ProductsTable/SupplierDetails in sections) are inlined 1:1 into` &&
               ` the single port view - abap2UI5 builds one XML view, there is no runtime Fragment reference. So core:Fragment is absent (5 dropped) and every fragment's content is rendered directly. // NOTE: The` &&
               ` dynamic /selectedPurchase JSON object is flattened onto the single default model as root-level fields: has_selection (drives the ObjectPageLayout showHeaderContent/toggleHeaderOnTitleClick and every` &&
               ` section visible expression, replacing the object-truthiness !!${/selectedPurchase}), sel_category/sel_subcategory/sel_suppliername/sel_paymenttype/sel_deliverystatus (HeaderContent),` &&
               ` sel_delivery_state (ObjectStatus) and sel_products (the products Table). The controller's _setSelectedPurchaseAndUpdateInput selection logic is reproduced server-side in set_selection: the` &&
               ` entered/selected PurchaseID resolves a purchase from t_purchases and seeds these fields (or forces has_selection=false so the IllustratedMessage "not found" state shows). The text and Sub-Category`.
    lv_text1 = lv_text1 && ` header bindings therefore bind the flattened fields instead of {/selectedPurchase/...}. // IMPROVISED: i18n named-model bindings folded to literal English values from i18n.properties: the pure` &&
               ` {i18n>...} property bindings on text (Title Receipt Information/Delivery Status/Products, column-header Product/Dimensions/Quantity/Price), title (SelectDialog Purchases) and placeholder (Input Enter` &&
               ` product) are resolved statically (loses runtime language switching, renders identically in English). The IllustratedMessage title/description/illustrationType keep their expression binding {=` &&
               ` ${/inputPopulated} ? ... : ... } with the i18n operands replaced by the literal strings. The Label ...:'-suffixed i18n texts are likewise inlined. // NOTE: formatter.deliveryStatusState` &&
               ` (Shipped->Success, Failed Shipping->Error, else None) is business logic; per the thin-frontend principle it moves out of the frontend formatter into the ABAP model (deliverystatus_state, computed in` &&
               ` model_init per purchase) and the ObjectStatus state binds that precomputed field (sel_delivery_state) directly instead of a formatter binding. // NOTE: handleValueHelpSearch / _getCombinedFilter`.
    lv_text1 = lv_text1 && ` build an OR filter of PurchaseID Contains + SupplierName Contains, and _filterAndOpenValueHelpDialog opens the dialog pre-filtered with the current input value. **Both reproduced 2026-08-05** against` &&
               ` capabilities that had shipped and were unused: the search round-trips its value and the backend issues the COMPOUND binding_call filter (a JSON group with both fields, ORed inside the group -` &&
               ` pr/binding-call-compound-filters; the payload is one JSON string, so the value cannot be substituted client-side, which is why this one wire round-trips like app 022's), and valueHelpRequest now` &&
               ` passes $event.oSource.getValue() to open( ), the search-string argument the whitelist already declared. The Input's setFilterFunction (case-insensitive contains over key+text) stays unreproduced - it` &&
               ` is UI5's built-in suggestion filtering. // NOTE: Namespace-prefix representation: the port declares xmlns=sap.m (default) plus xmlns:uxap=sap.uxap, so the uxap controls are emitted uxap:-prefixed. In` &&
               ` the originals ObjectPageLayout/ObjectPageDynamicHeaderTitle (App.view.xml) and the IllustratedMessage-fragment ObjectPageSection/ObjectPageSubSection are unprefixed (their file's default xmlns is`.
    lv_text1 = lv_text1 && ` sap.uxap), while the ProductsTable/SupplierDetails fragments already use the uxap: prefix. Same library, identical rendering; structural-diff sees uxap:ObjectPageSection vs ObjectPageSection (and` &&
               ` likewise ObjectPageLayout/ObjectPageDynamicHeaderTitle/ObjectPageSubSection) as control missing/extra. m:IllustratedMessage keeps its m: prefix to match the original. // POST-1.71:` &&
               ` sap.m.IllustratedMessage (control since UI5 1.98, with illustrationType/title/description) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.98 to render it.` &&
               ` property-check does not track IllustratedMessage members, so this is declared by policy, not gate-forced. // POST-1.71: sap.m.Input.autocomplete (since UI5 1.108) is newer than 1.71 but kept 1:1` &&
               ` (autocomplete='false'); the app needs a UI5 release >= 1.108 to render it. Not tracked by property-check (declared by policy). // NOTE: live-verified 2026-08-04 (nightly e2e interaction): leg (c) is` &&
               ` closed: **e2e-verified 2026-08-01** (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): F4 on the PurchaseID Input (the keyboard form of valueHelpRequest - its icon has no layout`.
    lv_text1 = lv_text1 && ` box headless) opens the SelectDialog client-side through control_by_id, and the dialog renders its bound purchase rows. Still unverified in a running system: (a) Input submit resolving the entered` &&
               ` PurchaseID and redrawing; (b) suggestionItemSelected transporting ${$parameters>/selectedItem}.getKey(); (d) the SelectDialog search (binding_call filter) and its confirm arg - the dialog row has no` &&
               ` layout box headless and neither a click nor a keyboard Enter reaches the confirm; (e) the ObjectPageLayout/IllustratedMessage/Table rendering.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.InitialPagePattern`              name = `InitialPagePattern`                            class = `z2ui5_cl_dmo_app_233` path = `src/01/b18/z2ui5_cl_dmo_app_233.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        ui5_only = abap_true
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.IllustratedMessage (control since UI5 1.98, with illustrationType/title/description) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.98 to render it.` &&
                 ` property-check does not track IllustratedMessage members, so this is declared by policy, not gate-forced. // sap.m.Input.autocomplete (since UI5 1.108) is newer than 1.71 but kept 1:1` &&
                 ` (autocomplete='false'); the app needs a UI5 release >= 1.108 to render it. Not tracked by property-check (declared by policy).` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Input`                           name = `InputTypes`                                    class = `z2ui5_cl_dmo_app_159` path = `src/01/b16/z2ui5_cl_dmo_app_159.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: Five Inputs demonstrating the input types Text / Email / Tel / Number / Url with labelFor Labels, reproduced 1:1.` )
      ( module = `sap.m`              control = `sap.m.Input`                           name = `InputValueState`                               class = `z2ui5_cl_dmo_app_032` path = `src/01/b02/z2ui5_cl_dmo_app_032.clas.abap`
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
      ( module = `sap.m`              control = `sap.m.InputListItem`                   name = `InputListItem`                                 class = `z2ui5_cl_dmo_app_057` path = `src/01/b07/z2ui5_cl_dmo_app_057.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` ) ).

    lv_text1 = `IMPROVISED: The original demonstrates late binding of an Input over an OData v2 mock server: fnRebind calls view.bindElement('/Employees(1)') and, on dataReceived (~3s), rebinds the input to FirstName` &&
               ` if the value is still untouched. abap2UI5 has no ODataModel roundtrip here, so the OData mock is reduced to ABAP: the button starts a 3s timer (cs_event-start_timer) and the callback sets the bound` &&
               ` value to the Employees(1) FirstName ('Nancy') only when the input still equals its initial value ('Martin'), reproducing the initialValue===currentValue guard. // NOTE: The input value is a two-way` &&
               ` binding on the single default model (the original's named 'initialData' JSONModel /currentValue is flattened). liveChange is wired but the current value already flows back via the two-way binding on` &&
               ` each roundtrip, so the handler is a no-op (the original setProperty('/currentValue', ...) keeps it live between keystrokes).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.InputModelUpdate`                name = `InputModelUpdate`                              class = `z2ui5_cl_dmo_app_102` path = `src/01/b12/z2ui5_cl_dmo_app_102.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        ui5_only = abap_true
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Label`                           name = `LabelProperties`                               class = `z2ui5_cl_dmo_app_058` path = `src/01/b07/z2ui5_cl_dmo_app_058.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: the four controller handlers (onDisplayOnlyChange/onWrappingChange/onHyphenationChange/onWidthChange) are replaced by a roundtrip-free binding model, so the Switch ``change`` and Slider` &&
                 ` ``liveChange`` event attributes are dropped: the three Switches bind their ``state`` two-way to display_only/wrapping/hyphenation, the two result Labels bind ``displayOnly`` and ``wrapping`` to the` &&
                 ` same variables, and ``wrappingType`` (added on the two Labels, not present in the sample view) plus both container ``width`` values derive live via ``{= }`` expression bindings (wrappingType =` &&
                 ` hyphenation ? 'Hyphenated' : 'Normal'; width = slider_value + '%'). Same technique as app 007.` )
      ( module = `sap.m`              control = `sap.m.LightBox`                        name = `LightBox`                                      class = `z2ui5_cl_dmo_app_059` path = `src/01/b07/z2ui5_cl_dmo_app_059.clas.abap`
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
      ( module = `sap.m`              control = `sap.m.Link`                            name = `Link`                                          class = `z2ui5_cl_dmo_app_160` path = `src/01/b16/z2ui5_cl_dmo_app_160.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Link.icon (sap-icon://cart, sap-icon://globe) and Link.endIcon (sap-icon://inspect) are @since 1.128 and used 1:1 - the 'Links with Icons' group is the sample's point. Newer than UI5 1.71; declared` &&
                 ` per the property-171 policy, so the app needs UI5 >= 1.128 to render the icons.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Link`                            name = `LinkEmphasized`                                class = `z2ui5_cl_dmo_app_033` path = `src/01/b01/z2ui5_cl_dmo_app_033.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        checked = `CHECKED (2026-07-19): verified in a running system - human visual pass 2026-07-19 over all apps: the Currency composite binding renders the formatted price per currency (raw binding-info string over` &&
                 ` PRICE TYPE p).` )
      ( module = `sap.m`              control = `sap.m.List`                            name = `ListCounter`                                   class = `z2ui5_cl_dmo_app_034` path = `src/01/b04/z2ui5_cl_dmo_app_034.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-21): verified in a running system - human visual check 2026-07-21: the Products list renders the 11 rows with their Quantity counters (display-only app, no interaction to exercise).`
        notes = `POST-1.71: headerLevel="H2" on the List (since UI5 1.117) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.117 to render it.`
        post171 = `headerLevel="H2" on the List (since UI5 1.117) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.117 to render it.` ) ).

    lv_text1 = `NOTE: The original controller loads the shared demo products.json and the List uses binding="{/ProductCollection/0}" to element-bind a single record; abap2UI5 serves one default model, so the record` &&
               ` is flattened to top-level default-model fields (name/productid/productpicurl = products.json row 0, Notebook Basic 15 / HT-1000) the relative {NAME}/{PRODUCTID}/{PRODUCTPICURL} bindings resolve` &&
               ` against. Same data, same leaf names, renders identically — the List's binding attribute is dropped. **Corrected 2026-08-01**: those bindings were written RELATIVE ({FIELD}) and a relative path on a` &&
               ` control with no binding context resolves against nothing — the fields rendered EMPTY in the running app (measured with the e2e harness, the app-207 class). They are now bound ABSOLUTELY through` &&
               ` client->_bind( field ), which is what a root-seeded record needs. // NOTE: ProductPicUrl is stored as the absolute https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg` &&
               ` (the mock's host-relative test-resources path rewritten to the OpenUI5 host per the runtime asset-URL rule).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.List`                            name = `ListFooter`                                    class = `z2ui5_cl_dmo_app_195` path = `src/01/b17/z2ui5_cl_dmo_app_195.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: zero structural difference to the archived List.view.xml: growing / growingThreshold=4 / growingScrollToLoad=false are pure client-side paging over the bound aggregation, so the port needs no` &&
               ` wire for them at all and stays init-only. The whole collection travels to the client exactly as in the original, where the JSONModel also holds all 123 rows. // NOTE: the List binds the shared demo` &&
               ` mock products.json /ProductCollection (all 123 rows; Name, ProductId and ProductPicUrl - the three fields the StandardListItem binds) inlined into model_init. The mock's host-relative ProductPicUrl` &&
               ` ('test-resources/...') is resolved to an absolute sdk.openui5.org URL per the runtime asset-URL rule. // NOTE: **e2e-verified 2026-08-01** (scripts/e2e-smoke.mjs interaction, transpiled backend +` &&
               ` real browser): the list starts at exactly the growingThreshold of 4 rows and the More trigger appends the next page (8 rows) - client-side paging over the whole bound collection, with no backend wire` &&
               ` involved.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.List`                            name = `ListGrowing`                                   class = `z2ui5_cl_dmo_app_276` path = `src/01/b15/z2ui5_cl_dmo_app_276.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-08-02): verified in a running system - human live check 2026-08-02 (maintainer): app started and exercised, no findings.`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: the original wires a change handler on the type Select (handleSelectChange, which loops the list items calling item.setType). selectedKey and every StandardListItem type share one two-way bound` &&
               ` field (LISTTYPE), so a selection re-types all items client-side and the Select.change attribute is deliberately MISSING vs the original view (AGENTS prefer-a-bindable-property rule; app 003` &&
               ` precedent). The added StandardListItem type binding is not in the original view. **Corrected 2026-07-31 (found by the e2e interaction):** the template first bound the shared field RELATIVELY` &&
               ` ({LISTTYPE}), which resolves against the ROW context - the rows carry no such field, so the items stayed Inactive and the Select had no effect at all. The template now binds the absolute path through` &&
               ` client->_bind( listtype ), which is what a shared root-level field needs inside a bound aggregation. // NOTE: the ProductPicUrl icon values are stored as absolute` &&
               ` https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/*.jpg URLs (the mock's host-relative test-resources paths rewritten to the OpenUI5 host per the runtime asset-URL rule). Same`.
    lv_text1 = lv_text1 && ` 123-row set, kept verbatim otherwise. // NOTE: unverified originally: (a) handlePress/handleDetailPress as roundtrip-free client toasts (control_global MESSAGE_TOAST.show of "'press' event fired!" /` &&
               ` "'detailPress' event fired!"); (b) the Select selectedKey <-> item type two-way binding re-typing all rows. **e2e-verified 2026-08-01** (scripts/e2e-smoke.mjs interaction, transpiled backend + real` &&
               ` browser): the list renders, every StandardListItem binds its type to the ABSOLUTE path /LISTTYPE (the regression that bit us - a relative {LISTTYPE} would resolve against the row and kill the` &&
               ` Select), AND the click-through now runs: opening the OverflowToolbar's 'Additional Options' popover makes the type Select drivable, and picking 'Navigation' re-types every bound row. The earlier` &&
               ` claim that the popover is not drivable headless was wrong (AGENTS 10, 2026-08-01). Still not covered: the press/detailPress toasts.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.List`                            name = `ListItemTypes`                                 class = `z2ui5_cl_dmo_app_207` path = `src/01/b17/z2ui5_cl_dmo_app_207.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.List`                            name = `ListNoData`                                    class = `z2ui5_cl_dmo_app_035` path = `src/01/b04/z2ui5_cl_dmo_app_035.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` )
      ( module = `sap.m`              control = `sap.m.List`                            name = `ListSelection`                                 class = `z2ui5_cl_dmo_app_224` path = `src/01/b17/z2ui5_cl_dmo_app_224.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: The List mode and the Select selectedKey are two-way bound to one default-model field mode (seeded MultiSelect, a valid sap.m.ListMode), reproducing the original controller's` &&
                 ` handleSelectChange/setMode behaviour without a round-trip. The Select's change attribute is dropped (the two-way binding keeps List.mode in sync client-side). structural-diff does not flag the` &&
                 ` literal mode=MultiSelect / selectedKey=MultiSelect becoming bindings. // NOTE: The full /ProductCollection mock (123 rows) is inlined; the row type is restricted to the columns the StandardListItem` &&
                 ` binds (Name, ProductId, ProductPicUrl) - a column subset, not a row subset. ProductPicUrl relative asset paths are rehosted to the OpenUI5 host https://sdk.openui5.org/ per the asset-URL rule.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MaskInput`                       name = `MaskInput`                                     class = `z2ui5_cl_dmo_app_153` path = `src/01/b15/z2ui5_cl_dmo_app_153.clas.abap`
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

    lv_text1 = `POST-1.71: Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it. // NOTE: the sample loads the Menu from` &&
               ` Menu.fragment.xml on first press and toggles it in the controller (oMenu.isOpen() ? close() : openBy(button)). The port declares the Menu 1:1 inside the Button's ``dependents`` aggregation and` &&
               ` toggles it via client->roundtrip-free _event_client( cs_event-control_by_id, toggleBy ) anchored to the button's DOM ref ($event.oSource.sId) - toggleBy (open-if-closed / close-if-open) was added` &&
               ` upstream 2026-07-20 (pr/menu-toggle-openby) precisely so the client-side open state need not be mirrored server-side, making the press-to-toggle 1:1. Frontend-action pattern as app 016. // NOTE:` &&
               ` onMenuAction builds a breadcrumb path by walking the selected MenuItem's parent chain (e.g. 'Create New Site > Official Store'); the port toasts only the selected item's own text, transported via` &&
               ` ${$parameters>/item}.getText(). **Measured 2026-07-31 (browser probe + e2e against the transpiled backend, OpenUI5 1.152), closing pr/menu-item-selected-path as a capability boundary:** sap.m.Menu`.
    lv_text1 = lv_text1 && ` re-parents its items through an internal sap.m.MenuWrapper, and the chain changes with the runtime state - while the submenu is closed the parent MenuItem is TWO hops up (MenuItem -> MenuWrapper ->` &&
               ` MenuItem), once the submenu popover exists it is FOUR (MenuItem -> MenuWrapper -> Popover -> ResponsivePopover -> MenuItem). An event arg IS a full UI5 expression (EventHandlerResolver hands the` &&
               ` whole handler to BindingParser.parseExpression, so method calls / isA() / ternaries resolve - a fixed-hop walk was built and did toast 'Create New Site > Official Store' when the event was fired` &&
               ` programmatically), but an expression has no loop, so no fixed hop count addresses the parent in both states. The same wrapper breaks the SAMPLE's own 'while (oItem instanceof MenuItem) { ...` &&
               ` oItem.getParent(); }' loop: the live demo kit sample toasts the leaf text too on this release, so the port is behaviour-identical with upstream - hence NOTE, not IMPROVISED. The e2e interaction` &&
               ` asserts the nested-selection leaf toast to guard the boundary. // NOTE: the selected item's text is read with ${$parameters>/item}.getText() (a method call on the resolved MenuItem control), NOT`.
    lv_text1 = lv_text1 && ` ${$parameters>/item/text}: the $parameters model exposes 'item' as the control object and UI5 keeps properties in the control's internal property store, so the path .../item/text reads an undefined` &&
               ` direct field and the toast arrives empty. // NOTE: live-verified 2026-07-22 - confirm in a running system that the Menu opens anchored to the button (openBy) and that ${$parameters>/item}.getText()` &&
               ` delivers the clicked MenuItem's text to the toast. // NOTE: the Menu open/close is wired roundtrip-free via client->_event_client( cs_event-control_by_id, toggleBy ) on the button press (anchored by` &&
               ` $event.oSource.sId) - the original's client-side toggle 1:1; the item-selected toast is now roundtrip-free too, composed on the frontend via control_global MESSAGE_TOAST.show (template +` &&
               ` ${$parameters>/item}.getText()), so the app has no on_event at all (init-only). // NOTE: the menu toggle was switched from a follow_up_action round-trip to roundtrip-free _event_client on 2026-07-22` &&
               ` - re-verify the button opens/closes the Menu. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the 'Open Menu' press opens the Menu anchored (toggleBy). // NOTE:`.
    lv_text1 = lv_text1 && ` the item-selected toast was switched from a message_toast_display round-trip to a roundtrip-free client-composed toast on 2026-07-22 (control_global MESSAGE_TOAST.show, template ``Action triggered on` &&
               ` item: {0}`` filled by ${$parameters>/item}.getText()) - re-verify selecting a menu item toasts "Action triggered on item: <text>". **e2e-verified 2026-07-30** (transpiled-framework interaction,` &&
               ` scripts/e2e-smoke.mjs): selecting 'Hide Existing Sites' toasts 'Action triggered on item: Hide Existing Sites'.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Menu`                            name = `Menu`                                          class = `z2ui5_cl_dmo_app_060` path = `src/01/b07/z2ui5_cl_dmo_app_060.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-22): verified in a running system 2026-07-22: the Menu opens anchored to the button (openBy) and the selected item text resolves via ${$parameters>/item}.getText().`
        notes = lv_text1
        post171 = `Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it.` ) ).

    lv_text1 = `POST-1.71: the MenuButton ``beforeMenuOpen`` event (since UI5 1.94) is kept 1:1 on the split-mode buttons that use it. menuPosition (1.56), buttonMode and useDefaultActionOnly are <= 1.71. // NOTE:` &&
               ` onMenuAction builds a breadcrumb path by walking the selected MenuItem's parent chain (e.g. 'basic > add'); the port toasts only the selected item's own text, transported via` &&
               ` ${$parameters>/item}.getText(). **Measured 2026-07-31 (browser probe + e2e against the transpiled backend, OpenUI5 1.152), closing pr/menu-item-selected-path as a capability boundary:** sap.m.Menu` &&
               ` re-parents its items through an internal sap.m.MenuWrapper, and the chain changes with the runtime state - while the submenu is closed the parent MenuItem is TWO hops up (MenuItem -> MenuWrapper ->` &&
               ` MenuItem), once the submenu popover exists it is FOUR (MenuItem -> MenuWrapper -> Popover -> ResponsivePopover -> MenuItem). An event arg IS a full UI5 expression (EventHandlerResolver hands the` &&
               ` whole handler to BindingParser.parseExpression, so method calls / isA() / ternaries resolve - a fixed-hop walk was built and did toast 'Create New Site > Official Store' when the event was fired`.
    lv_text1 = lv_text1 && ` programmatically), but an expression has no loop, so no fixed hop count addresses the parent in both states. The same wrapper breaks the SAMPLE's own 'while (oItem instanceof MenuItem) { ...` &&
               ` oItem.getParent(); }' loop: the live demo kit sample toasts the leaf text too on this release, so the port is behaviour-identical with upstream - hence NOTE, not IMPROVISED. The e2e interaction` &&
               ` asserts the nested-selection leaf toast to guard the boundary. // NOTE: onPress toasts the pressed MenuItem's control id (the sample's evt.getSource().getId() + ' Pressed'), transported via` &&
               ` $event.oSource.sId. The Edit item's core:CustomData (key=target, value=p1) is kept 1:1 as inert view metadata. // NOTE: the selected item's text is read with ${$parameters>/item}.getText() (a method` &&
               ` call on the resolved MenuItem control), NOT ${$parameters>/item/text}: the $parameters model exposes 'item' as the control object and UI5 keeps properties in the control's internal property store, so` &&
               ` the path .../item/text reads an undefined direct field and the toast arrives empty. // NOTE: live-verified 2026-07-22 - confirm in a running system that`.
    lv_text1 = lv_text1 && ` itemSelected/press/defaultAction/beforeMenuOpen all fire their toasts and that ${$parameters>/item}.getText() delivers the selected MenuItem text. // NOTE: live-verified 2026-08-04 (nightly e2e` &&
               ` interaction): all toasts were switched from message_toast_display round-trips to roundtrip-free client-composed control_global toasts on 2026-07-22 (the app is now init-only) - re-verify each` &&
               ` button/menu still toasts its text. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): opening the 'File' MenuButton and selecting 'Save' toasts 'Action triggered` &&
               ` on item: Save' (the ${$parameters>/item}.getText() template resolves); the remaining buttons/defaultAction wires are the same class but unexercised.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MenuButton`                      name = `MenuButton`                                    class = `z2ui5_cl_dmo_app_061` path = `src/01/b07/z2ui5_cl_dmo_app_061.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-22): verified in a running system 2026-07-22: itemSelected/press/defaultAction/beforeMenuOpen all fire their toasts and the item text resolves.`
        notes = lv_text1
        post171 = `the MenuButton ``beforeMenuOpen`` event (since UI5 1.94) is kept 1:1 on the split-mode buttons that use it. menuPosition (1.56), buttonMode and useDefaultActionOnly are <= 1.71.` ) ).

    lv_text1 = `NOTE: the sample opens every sap.m.MessageBox from its controller, so there is no such control in the view. The nine buttons are wired to events that call client->message_box_display with the sample's` &&
               ` own method name as type (confirm, alert, error, information, warning, success) - the documented 1:1 path (CAPABILITIES.md marks sap.m.MessageBox as expressible, app 036 is its evidence port), not a` &&
               ` workaround. // NOTE: the onClose handler of the two action boxes composes its toast on the client in the original; here the pressed action rides back through the onclose event and ABAP builds the` &&
               ` same text with message_toast_display - same output, and the thin-frontend direction (the action becomes backend-visible, which is the point of the onclose return path). // POST-1.71: the MessageBox` &&
               ` emphasizedAction option (since UI5 1.75) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.75 to render it. // POST-1.71: the MessageBox dependentOn option (since UI5` &&
               ` 1.124) is restored via message_box_display's dependenton parameter, pointing at the view layout (id messageBoxHost) instead of the view object; the app needs a UI5 release >= 1.124 for it.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MessageBox`                      name = `MessageBox`                                    class = `z2ui5_cl_dmo_app_278` path = `src/01/b15/z2ui5_cl_dmo_app_278.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.21.2`
        is_post171 = abap_true
        checked = `CHECKED (2026-08-02): verified in a running system - human live check 2026-08-02 (maintainer): app started and exercised, no findings.`
        notes = lv_text1
        post171 = `the MessageBox emphasizedAction option (since UI5 1.75) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.75 to render it. // the MessageBox dependentOn option (since UI5` &&
                 ` 1.124) is restored via message_box_display's dependenton parameter, pointing at the view layout (id messageBoxHost) instead of the view object; the app needs a UI5 release >= 1.124 for it.` ) ).

    lv_text1 = `NOTE: the sample opens a sap.m.MessageBox from its controller; there is no such control in the view. It is driven by two buttons wired to events that call client->message_box_display - the documented` &&
               ` 1:1 path (CAPABILITIES.md marks sap.m.MessageBox as expressible with app 036 as its evidence port), not a workaround. // POST-1.71: ariaHasPopup="Dialog" on both buttons (since UI5 1.84) is newer` &&
               ` than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it. // POST-1.71: the MessageBox emphasizedAction option (since UI5 1.75) is newer than 1.71 but kept for the 1:1` &&
               ` port - the app needs a UI5 release >= 1.75 to render it. // POST-1.71: the MessageBox dependentOn option (since UI5 1.124) is restored via message_box_display's dependenton parameter, pointing at the` &&
               ` view layout (id messageBoxHost); the app needs a UI5 release >= 1.124 to render it.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MessageBox`                      name = `MessageBoxInitialFocus`                        class = `z2ui5_cl_dmo_app_036` path = `src/01/b03/z2ui5_cl_dmo_app_036.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.21.2`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `ariaHasPopup="Dialog" on both buttons (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it. // the MessageBox emphasizedAction option (since` &&
                 ` UI5 1.75) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.75 to render it. // the MessageBox dependentOn option (since UI5 1.124) is restored via message_box_display's` &&
                 ` dependenton parameter, pointing at the view layout (id messageBoxHost); the app needs a UI5 release >= 1.124 to render it.` ) ).

    lv_text1 = `POST-1.71: Button.ariaHasPopup (since UI5 1.84) kept on the message-popover button. The Button.type value 'Negative' (a sap.m.ButtonType value since 1.73) is what the sample's buttonTypeFormatter` &&
               ` returns for the highest-severity Error message. // NOTE: the MessagePopover (built in the controller and addDependent'ed to the button) is declared 1:1 in the button's ``dependents`` aggregation; the` &&
               ` controller's oMessagePopover.toggle(button) becomes a roundtrip-free client->_event_client( cs_event-control_by_id, toggleBy ) on the button press (anchored by id), and onActiveTitlePress's` &&
               ` MessageToast.show becomes a roundtrip-free client->_event_client( cs_event-control_global, MESSAGE_TOAST/show ); the app is now init-only (no on_event). Previously client->follow_up_action(` &&
               ` cs_event-control_by_id, toggleBy ) anchored to the button's DOM ref ($event.oSource.sId) - open-if-closed / close-if-open. // NOTE: the sample's three severity formatters` &&
               ` (buttonIconFormatter/buttonTypeFormatter/highestSeverityMessages) compute the button icon/type/count from the highest-severity message; the mock data is static, so the results are precomputed in ABAP`.
    lv_text1 = lv_text1 && ` (error icon, Negative type, count 2 for the two Error messages) and bound as scalars. The sample's root-array JSON model (items path '/') is carried under a /T_MESSAGES field of the single default` &&
               ` model. // NOTE: live-verified 2026-07-22 - confirm in a running system that the button toggles the MessagePopover open/closed (toggleBy) and lists the five messages with their MessageItem link, and` &&
               ` that activeTitlePress toasts on the active (first Error) title. // NOTE: live-verified 2026-08-04 (nightly e2e interaction): the toggle and the active-title toast were switched from server` &&
               ` round-trips to roundtrip-free _event_client( control_global / control_by_id ) on 2026-07-22 - re-verify in a running system that the button still toggles the MessagePopover and that pressing an` &&
               ` active title still toasts. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the button toggles the MessagePopover open (the bound message items render); the` &&
               ` active-title toast remains unexercised.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MessagePopover`                  name = `MessagePopover`                                class = `z2ui5_cl_dmo_app_066` path = `src/01/b08/z2ui5_cl_dmo_app_066.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        since = `1.28`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-22): verified in a running system 2026-07-22: the button toggles the MessagePopover open/closed (toggleBy) and lists the five messages.`
        notes = lv_text1
        post171 = `Button.ariaHasPopup (since UI5 1.84) kept on the message-popover button. The Button.type value 'Negative' (a sap.m.ButtonType value since 1.73) is what the sample's buttonTypeFormatter returns for the` &&
                 ` highest-severity Error message.` ) ).

    lv_text1 = `POST-1.71: Button.ariaHasPopup (since UI5 1.84) kept on the message-popover button; the Button.type value 'Negative' is a sap.m.ButtonType value since 1.73. MessageItem.markupDescription (renders the` &&
               ` HTML description) is kept for the async sample's rich-text messages. // NOTE: the MessagePopover (built in the controller) is declared 1:1 in the button's ``dependents``; the controller's` &&
               ` toggle(button) becomes a roundtrip-free client->_event_client( cs_event-control_by_id, toggleBy ) on the button press (anchored by id), and onActiveTitlePress's MessageToast.show becomes` &&
               ` roundtrip-free client->_event_client( cs_event-control_global, MESSAGE_TOAST/show ); the app is now init-only. Anchored to $event.oSource.sId. // NOTE: the sample's` &&
               ` oMessagePopover.setAsyncURLHandler(...) - allowed = url.lastIndexOf('http', 0) < 0, i.e. relative links allowed, absolute http links disabled - is reproduced since 2026-07-30 via the framework's` &&
               ` declarative URL policy: follow_up_action control_by_id setAsyncURLHandler 'RELATIVE_ONLY' installs the built-in validator on init (pr/messagepopover-async-url implemented upstream). Semantic nuance:`.
    lv_text1 = lv_text1 && ` RELATIVE_ONLY also denies non-http absolute schemes (mailto:) and protocol-relative //host URLs, which the original's http-prefix test would allow - a strictly safer superset, no demo link is` &&
               ` affected. The controller's urlValidated toast ('URL validation has been performed.') is wired 1:1 as an added urlValidated attribute (declared) with a client-composed toast; the original's` &&
               ` setAsyncDescriptionHandler (allow-all) and its longtextLoaded toast are NOT reproduced - no remote long texts exist in the mock, so the handler never fires in the sample either. // NOTE: the three` &&
               ` severity formatters are precomputed in ABAP from the static mock (error icon, Negative type, count 2); the root-array JSON model is carried under /T_MESSAGES on the single default model. // NOTE:` &&
               ` live-verified 2026-07-22 - confirm the button toggles the MessagePopover (toggleBy) and the first Error message renders its HTML markupDescription (h2/p/ul/ol + links); activeTitlePress toasts. //` &&
               ` NOTE: live-verified 2026-08-04 (nightly e2e interaction): the toggle and the active-title toast were switched to roundtrip-free _event_client on 2026-07-22, and the 2026-07-30 RELATIVE_ONLY URL`.
    lv_text1 = lv_text1 && ` policy + urlValidated toast are new since the 2026-07-22 live check (status reset checked -> generated): re-verify the button toggles the MessagePopover, an active title toasts, and the absolute http` &&
               ` link in the first message renders disabled after validation while relative links stay clickable. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the button` &&
               ` toggles the MessagePopover open (the 'Error message' item renders its markup).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MessagePopover`                  name = `MessagePopoverAsyncMessageHandling`            class = `z2ui5_cl_dmo_app_067` path = `src/01/b08/z2ui5_cl_dmo_app_067.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.28`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Button.ariaHasPopup (since UI5 1.84) kept on the message-popover button; the Button.type value 'Negative' is a sap.m.ButtonType value since 1.73. MessageItem.markupDescription (renders the HTML` &&
                 ` description) is kept for the async sample's rich-text messages.` ) ).

    lv_text1 = `POST-1.71: two post-1.71 members are kept for the 1:1 port: Button.ariaHasPopup (since UI5 1.84) on the MessagePopover button, and MessagePopover.groupItems (since UI5 1.73). // NOTE: the controller's` &&
               ` manual MessageManager handling is replaced by two framework mechanisms: (1) the typed value bindings with constraints (sap.ui.model.type.Integer/String, ZIP_CODE Integer, WEEKLYHOURS Integer maximum` &&
               ` 40, EMAIL search regex) collect/clear their validation messages AUTOMATICALLY into the message> model (no app code) - replacing onChange/handleRequiredField/checkInputConstraints; (2) app-authored` &&
               ` messages go through the new z2ui5.cc.MessageManager companion control (items bound to /T_MESSAGES), which reconciles them into the message manager with a target + processor. Save ports` &&
               ` generateInvalidUserInput 1:1 in effect: since abap2UI5 auto-collects validation messages only from USER input (not from programmatically-set model values), Save INJECTS the four demo issues on the` &&
               ` SAME rows the original targets (formContainer.getItems()[4/5/6] = John Miller Name empty, Stefan Bosch ZIP 'AAA', Maria Fontes email malformed, plus the employment weekly hours 400) AND authors the`.
    lv_text1 = lv_text1 && ` matching four messages (3 Errors + 1 Warning) with their /T_FORMS/4|5|6 and /T_EMPLOYMENT/0 targets, then opens the MessagePopover via follow_up_action( control_by_id openBy ) anchored to` &&
               ` messagePopoverBtn. // NOTE: the sample's nested JSON model (street/name, zip/code, phone/number) is flattened into a flat ABAP row (STREET_NAME, ZIP_CODE, PHONE_NUMBER, ...) - abap2UI5 serves one` &&
               ` default model; the bindings use the flattened field names. The three f:ColumnElementData layoutData hints (cellsSmall/cellsLarge column spans on the street-number, zip-code and one employment Input)` &&
               ` are dropped - responsive-span cosmetics with no data/behaviour. // 1.71: controller-only pieces with no view/binding equivalent are dropped:` &&
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
      ( module = `sap.m`              control = `sap.m.MessagePopover`                  name = `MessagePopoverMessageHandling`                 class = `z2ui5_cl_dmo_app_065` path = `src/01/b08/z2ui5_cl_dmo_app_065.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth` &&
                 ` a close look.`
        since = `1.28`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-27): verified in a running system 2026-07-27 - MessageManager cc: add/remove app-authored messages reconciled, MessagePopover shows both sources`
        notes = lv_text1
        post171 = `two post-1.71 members are kept for the 1:1 port: Button.ariaHasPopup (since UI5 1.84) on the MessagePopover button, and MessagePopover.groupItems (since UI5 1.73).` ) ).

    lv_text1 = `NOTE: the original's view.xml has no MessageStrip at all: showMsgStrip destroys the previous one and _generateMsgStrip creates a new sap.m.MessageStrip in the controller, adding it to the` &&
               ` VerticalLayout. The port declares that MessageStrip in the view (one control more than the original view.xml) and binds its four varying properties - text, type, showIcon, showCloseButton - plus` &&
               ` visible, which keeps it hidden until the button has been pressed once. Destroy-and-recreate then has no counterpart: rebinding the same control is the abap2UI5 form of the same result. // IMPROVISED:` &&
               ` the original randomizes: sType = aTypes[Math.round(Math.random() * 3)] and both flags from Math.round(Math.random()). Deciding is backend work, so the choice moves to ABAP - and it is made` &&
               ` DETERMINISTIC there: a press counter rotates the type through Information/Warning/Error/Success and the two flags through their combinations, so every press still changes the strip but the port is` &&
               ` reproducible (the corpus rule for random/current-date values, apps 164/181). MessageStrip.type carries the control's own default Information until the first press, because an empty string is rejected`.
    lv_text1 = lv_text1 && ` on an enum property. // NOTE: the accessibility announcement is reproduced since 2026-08-05: onInit takes an sap.ui.core.InvisibleMessage instance and _generateMsgStrip calls announce('New` &&
               ` Information Bar of type ...', Assertive) on it. InvisibleMessage is a JS singleton, not a control in the view, so no CONTROL_BY_ID wire can address it - the INVISIBLE_MESSAGE global target added for` &&
               ` exactly that (pr/invisible-message-announce) carries the announcement instead: follow_up_action( control_global, INVISIBLE_MESSAGE / announce / <text> / Assertive ) right after the model update, with` &&
               ` the same text the original composes. It is lazy-required, so a runtime older than UI5 1.78 logs 'not available' instead of failing the app.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MessageStrip`                    name = `DynamicMessageStripGenerator`                  class = `z2ui5_cl_dmo_app_289` path = `src/01/b22/z2ui5_cl_dmo_app_289.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.30`
        notes = lv_text1 ) ).

    lv_text1 = `POST-1.71: the MessageStrip ``controls`` aggregation (since UI5 1.129) is kept 1:1 for the fifth strip's %%0/%%1/%%2 multi-link formatted text (three sap.m.Link). enableFormattedText itself is since` &&
               ` 1.50 (<= 1.71). // POST-1.71: core:require="{Formatter: 'z2ui5/model/formatter'}" wires the curated formatter module (since UI5 1.74) so the inlineIconsHelper strip can use` &&
               ` Formatter.expandInlineIcons; the two added namespace decls (xmlns:core, core:require on the view root) are not in the sample view. // NOTE: the sample's controller builds inlineIconsHelper from` &&
               ` sap.m.MessageStripUtilities.getInlineIcon() concatenations; the port stores the text with %%icon:sap-icon://<name>%% placeholders (the real icon names message-success/sys-enter-2/stethoscope) and` &&
               ` binds it through formatter 'Formatter.expandInlineIcons' - added upstream 2026-07-20 (pr/formatter-inline-icon), it resolves each glyph via IconPool and emits the same sapMMsgStripInlineIcon markup,` &&
               ` so no icon codepoints are guessed. The inlineIconsUnicode strip keeps the sample's own literal &#x....; entities 1:1. // NOTE: the sample's JSONModel of static formatted-text strings is rebuilt as`.
    lv_text1 = lv_text1 && ` ABAP string fields on the single default model and bound 1:1 (text={/...}); field names differ from the JSON keys (default->default_text etc.) but values are display-only, so the binding-value diff` &&
               ` does not apply.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MessageStrip`                    name = `MessageStripWithEnableFormattedText`           class = `z2ui5_cl_dmo_app_062` path = `src/01/b07/z2ui5_cl_dmo_app_062.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.30`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `the MessageStrip ``controls`` aggregation (since UI5 1.129) is kept 1:1 for the fifth strip's %%0/%%1/%%2 multi-link formatted text (three sap.m.Link). enableFormattedText itself is since 1.50 (<=` &&
                 ` 1.71). // core:require="{Formatter: 'z2ui5/model/formatter'}" wires the curated formatter module (since UI5 1.74) so the inlineIconsHelper strip can use Formatter.expandInlineIcons; the two added` &&
                 ` namespace decls (xmlns:core, core:require on the view root) are not in the sample view.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MessageToast`                    name = `MessageToast`                                  class = `z2ui5_cl_dmo_app_037` path = `src/01/b03/z2ui5_cl_dmo_app_037.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.9.2` ) ).

    lv_text1 = `NOTE: the sample's view.xml is only the Page with the Delete Button - everything else is built in onInit. The controller-built Dialog (resizable, state Error, contentHeight/contentWidth 50%,` &&
               ` verticalScrolling false), its customHeader Bar with the nav-back Button and the Title, the MessageView with its MessageItem template and the item's Link, and the Close beginButton are rebuilt 1:1 as` &&
               ` a core:FragmentDefinition shown with popup_display. So Dialog, Bar, Title, MessageView, MessageItem, Link and two of the three Button controls are extra against the original view.xml. // NOTE: the` &&
               ` two controller handlers that reach into controls become bound state, per the prefer-a-bindable-property rule: oBackButton.setVisible(...) is the two-way bound visible={/BACK_VISIBLE} and` &&
               ` oDialogTitle.setText(...) is text={/DIALOG_TITLE}. Only navigateBack has no bindable equivalent - it is the one frontend action (control_by_id, view = cs_view-popup, on the MessageView id` &&
               ` messageView, an unlisted public control method that passes the framework's deny-prefix guard). handleDialogPress's own navigateBack is not needed: popup_display rebuilds the fragment, so the`.
    lv_text1 = lv_text1 && ` MessageView always opens on its list page; only the header state is reset in ABAP. // NOTE: activeTitlePress keeps the original's client-side MessageToast.show('Active title pressed') as a` &&
               ` roundtrip-free _event_client MESSAGE_TOAST show - the text is static, so nothing has to travel. // NOTE: a flat ABAP row serializes every field, so the properties the mock omits carry their UI5` &&
               ` defaults: markupDescription is false on all six messages (never set in the original), activeTitle false except on the last one, and the counter of the second message (Warning without description) is` &&
               ` 0 - ListItemBaseRenderer.renderCounter only renders a truthy counter, so 0 and 'absent' render identically.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MessageView`                     name = `MessageViewInsideDialog`                       class = `z2ui5_cl_dmo_app_284` path = `src/01/b20/z2ui5_cl_dmo_app_284.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.46`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MessageView`                     name = `MessageViewMessageManager`                     class = `z2ui5_cl_dmo_app_038` path = `src/01/b03/z2ui5_cl_dmo_app_038.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.46`
        notes = `NOTE: the original registers its four messages on the sap.ui.core.message.MessageManager and the MessageView binds them via the message> model. abap2UI5 DOES carry the message> model on every view` &&
                 ` slot since pr/message-model (2026-07-18, auto-collecting control validation messages), but there is no ABAP API to push an arbitrary static message set into it - so for this render-only sample the` &&
                 ` messages are bound as a plain ABAP table on MessageView items with a MessageItem template (client->_bind( t_messages )), the path CAPABILITIES.md explicitly endorses for static message sets. Same` &&
                 ` rendering as the original. Proven by the curated sample z2ui5_cl_demo_app_038 (MessageView + MessageItem + MessagePopover over a bound table).` ) ).

    lv_text1 = `NOTE: the three formatters are computed in the backend, which is the point of the thin-frontend rule (apps 009/010/022/092). buttonIconFormatter, buttonTypeFormatter and highestSeverityMessages each` &&
               ` walk the whole message list to find the highest severity (Error > Warning > Success > Information) and count how many messages carry it - a computation over the data, not a presentation format.` &&
               ` model_init does it once and the Button binds the three finished values (sap-icon://message-error, Negative, 5 for this data). The original re-runs the formatters on every model change; here the` &&
               ` values are recomputed wherever the message list changes. // NOTE: the original's view.xml is only the Page with the footer Button; the MessageView with its MessageItem template and Link, the Dialog` &&
               ` with its custom-header Bar, the nav-back Button, the 'Publish order' Text and the Close endButton are all built in onInit. They are rebuilt here as a core:FragmentDefinition shown with popup_display,` &&
               ` so Dialog, Bar, Text, MessageView, MessageItem, Link and two of the three Button controls are extra against the original view.xml. // NOTE: the back button's visible state is two-way bound`.
    lv_text1 = lv_text1 && ` (visible={/BACK_VISIBLE}) instead of driven by setVisible, per the prefer-a-bindable-property rule; only navigateBack, which has no bindable equivalent, stays a control_by_id action on the popup` &&
               ` slot. handleMessageViewPress's own navigateBack is not needed: popup_display rebuilds the fragment, so the MessageView always opens on its list page. // NOTE: the MessageItem template binds` &&
               ` counter={COUNTER} 1:1, but no message in the sample sets a counter - a flat ABAP row serializes it as 0, which ListItemBaseRenderer renders exactly like an absent counter (it only renders a truthy` &&
               ` one). The two ungrouped messages carry no groupName, which is what makes them appear outside the two Purchase Order groups.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MessageView`                     name = `MessageViewWithGrouping`                       class = `z2ui5_cl_dmo_app_294` path = `src/01/b23/z2ui5_cl_dmo_app_294.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.46`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MultiComboBox`                   name = `MultiComboBoxGrouping`                         class = `z2ui5_cl_dmo_app_039` path = `src/01/b02/z2ui5_cl_dmo_app_039.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `NOTE: the custom groupHeaderFactory '.getGroupHeader' (controller code) is replaced by UI5's default group headers - the sample's factory builds a SeparatorItem with the group key, which is exactly` &&
                 ` what the default renders anyway (CAPABILITIES.md group-sorter row, source-verified on both sides), so this is a faithful 1:1, not a workaround. The items are a bound template with the original's` &&
                 ` sorter (path SUPPLIER_NAME, group: true) as a raw binding-info string.` ) ).

    lv_text1 = `POST-1.71: showSelectAll (since UI5 1.111) is the sample's whole point and kept 1:1 - the app needs a UI5 release >= 1.111 for the select-all checkbox in the picker. // NOTE: both toasts round-trip` &&
               ` instead of being composed on the client. selectionChange carries the changed item's text and the selected flag as event args and ABAP builds the same sentence; selectionFinish needs the whole` &&
               ` selection, so the MultiComboBox gains a selectedKeys binding (added, no counterpart in the original, which reads getSelectedItems in the controller) and ABAP joins the matching product names into the` &&
               ` original's ['A','B'] form. The round-trip also carries the original's width: 'auto' toast option, which the client-composed toast wire cannot pass. // NOTE: live-verified on 2026-08-02 (maintainer` &&
               ` live check): the selectionFinish toast lists the selected names and Select All fills the selectedKeys binding. The selectionChange leg is additionally e2e-verified (the toast carries the real item` &&
               ` text). The selectionFinish leg is NOT machine-checkable: it fires only when the picker CLOSES, and headless neither F4 nor Escape reaches the picker once focus sits in the item list, an outside click`.
    lv_text1 = lv_text1 && ` does not dismiss it and getPicker() is null on the registry instance (measured 2026-08-02) - the armed interaction covers the selectionChange leg only.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MultiComboBox`                   name = `MultiComboBoxSelectAll`                        class = `z2ui5_cl_dmo_app_281` path = `src/01/b15/z2ui5_cl_dmo_app_281.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0`
        is_post171 = abap_true
        checked = `CHECKED (2026-08-02): verified in a running system - human live check 2026-08-02 (maintainer): app started and exercised, no findings.`
        notes = lv_text1
        post171 = `showSelectAll (since UI5 1.111) is the sample's whole point and kept 1:1 - the app needs a UI5 release >= 1.111 for the select-all checkbox in the picker.` ) ).

    lv_text1 = `NOTE: the controller's onInit pre-sets the tokens on both MultiInputs (Token 1..6 and one long token); they are declared statically in the view's tokens aggregation instead - same rendering` &&
               ` (CAPABILITIES.md marks controller-filled aggregations as expressible, the tokens aggregation is public since UI5 1.16), so this is a faithful 1:1, not a workaround. // NOTE: the controller's onInit` &&
               ` addValidator on multiInput1 and multiInput2 (typing free text + Enter -> new Token({key: text, text})) is wired via the bundled invisible companion control z2ui5.cc.MultiInputExt` &&
               ` (xmlns:z2ui5="z2ui5.cc"): one MultiInputExt per input, referencing it by MultiInputId - the control installs exactly the original's validator (source-verified in app/webapp/cc/MultiInputExt.js). The` &&
               ` two MultiInputExt elements are extra vs the original view.xml (there the validator lives in the controller); first cc-control usage in these ports (converted 2026-07-18). // NOTE: The original's` &&
               ` stray placeholder attributes on the two Labels (not a Label property) are dropped. // POST-1.71: showClearIcon (since UI5 1.94) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5` &&
               ` release >= 1.94 to render it.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MultiInput`                      name = `MultiInput`                                    class = `z2ui5_cl_dmo_app_040` path = `src/01/b02/z2ui5_cl_dmo_app_040.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed); live-checked reference example for: cc control` &&
                 ` (MultiInputExt), bound aggregation, tokens, sorter binding-info`
        notes = lv_text1
        post171 = `showClearIcon (since UI5 1.94) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.94 to render it.` ) ).

    lv_text1 = `NOTE: handleValueHelp is reproduced 1:1 through two follow-up actions in the order the controller has them: cs_event-binding_call filters the dialog's items binding by NAME Contains the typed value` &&
               ` (the model stays untouched, exactly like oValueHelpDialog.getBinding('items').filter([...])), then cs_event-control_by_id open( value ) opens it with that same value in its search field -` &&
               ` CONTROL_METHODS declares open's optional string argument, so oValueHelpDialog.open(sInputValue) travels whole. The MultiInput's value is bound two-way so the typed text is on the server when` &&
               ` valueHelpRequest fires. The dialog's own search event keeps the roundtrip-free _event_client binding_call form (app 103 idiom). // NOTE: _handleValueHelpClose reads evt.getParameter('selectedItems')` &&
               ` and adds one sap.m.Token per item. A list of CONTROLS cannot travel to the backend, so the selection is read from the data instead: the StandardListItem template gains a selected={SELECTED} binding` &&
               ` (an added attribute) and the handler loops the rows, appends a token per selected row and clears the flag again. The MultiInput's tokens aggregation is bound to that token table, so the Token in the`.
    lv_text1 = lv_text1 && ` view is a template the original does not have (it builds Tokens in the controller) - one control more than the original view.xml. // NOTE: the suggestionItems binding keeps the original's { path,` &&
               ` sorter: { path: 'Name' } } shape 1:1 as a raw binding-info string, with the path from client->_bind and the sorter path switched to the ABAP field NAME. The Component's oModel.setSizeLimit(1000000)` &&
               ` has no counterpart: an abap2UI5 model carries whatever the ABAP table holds, so all 123 rows are bound without a limit to raise.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.MultiInput`                      name = `MultiInputValueHelp`                           class = `z2ui5_cl_dmo_app_290` path = `src/01/b22/z2ui5_cl_dmo_app_290.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    lv_text1 = `POST-1.71: NavContainer.navigationFinished (event, since UI5 1.111.0) is kept 1:1 - it is wired to a client-composed MessageToast; the app needs a UI5 release >= 1.111 to fire it. // NOTE: handleNav` &&
               ` does navCon.to( byId(target), animationSelect.getSelectedKey() ) / navCon.back() imperatively. The port keeps the NavContainer id='navCon' and drives navigation via a round-trip: each To-button's` &&
               ` press (NAV) carries its static target page id (p1..p4) as the event arg, and on_event issues follow_up_action( val = cs_event-control_by_id t_arg = ( 'navCon' )( 'to' )( <target> )( animation ) ) -` &&
               ` 'to' is whitelisted with kinds [controlId, string], so the target page and the transition name both reach the method; Back issues ( 'navCon' )( 'back' ). A server round-trip where the original is a` &&
               ` purely client-side imperative call, but faithful. // NOTE: the animation transition comes from a Select whose getSelectedKey() the original reads at click time. The port two-way binds the Select's` &&
               ` selectedKey to a model field {/ANIMATION} (seeded to the first item's key 'slide'), so the current transition is available to the backend on the NAV round-trip. The original Select has no selectedKey`.
    lv_text1 = lv_text1 && ` attribute (it defaults to the first item), so adding the bound selectedKey is an extra attribute (structural-diff only flags MISSING attributes) and is the faithful thin-frontend form of the` &&
               ` imperative getSelectedKey(). // NOTE: the sample's style.css (a border around the NavContainer via the .navContainerControl class) is injected via an added core:HTML leaf carrying a <style> block in` &&
               ` its content attribute (CAPABILITIES 'Custom CSS'); the literal CSS braces are escaped. structural-diff reports this core:HTML as an extra control (named here); the .navContainerControl class stays on` &&
               ` the NavContainer. // NOTE: the four To-buttons keep their core:CustomData (key='target') element 1:1 for structural fidelity, but the port transports the target page id via the button's event arg (a` &&
               ` static literal per button) rather than reading evt.getSource().data('target') - identical result since the target is fixed per button. // NOTE: live-verified 2026-08-04 (nightly e2e interaction):` &&
               ` unverified in a running system: that navCon.to()/back() navigate the four pages with the selected transition (follow_up_action cs_event-control_by_id 'to'/'back'), that the two-way bound animation`.
    lv_text1 = lv_text1 && ` Select is applied before NAV runs, and that navigationFinished fires the client-composed toast with the resolved page title. **e2e-verified 2026-07-30** (transpiled-framework interaction,` &&
               ` scripts/e2e-smoke.mjs): the 'To 2' button navigates to Page 2 via the control_by_id to() call; the transition-type select and back() remain unexercised.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.NavContainer`                    name = `NavContainer`                                  class = `z2ui5_cl_dmo_app_242` path = `src/01/b19/z2ui5_cl_dmo_app_242.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `NavContainer.navigationFinished (event, since UI5 1.111.0) is kept 1:1 - it is wired to a client-composed MessageToast; the app needs a UI5 release >= 1.111 to fire it.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.NewsContent`                     name = `NewsContent`                                   class = `z2ui5_cl_dmo_app_063` path = `src/01/b07/z2ui5_cl_dmo_app_063.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34` ) ).

    lv_text1 = `NOTE: onItemClose is reproduced 1:1 since 2026-08-05. The original removes the item from its list (oList.removeItem(oItem)) and toasts its title; the port does BOTH client-side on the same event: UI5` &&
               ` runs a ';'-separated pair of event handlers (measured with scripts/probes/event-arg-expression-probe.mjs), so the wire chains control_by_id removeItem with the client-composed toast. The item travels` &&
               ` as its own id ($event.oSource.getId()), which ManagedObject.removeAggregation accepts (measured in the same probe). The NotificationList gained an ``id`` the original does not carry - removeItem` &&
               ` needs a target for the wire; that is the port's only extra attribute here. The earlier 'static items, so close only toasts' rationale is retired. Group 3's onAcceptErrors keeps its accept toast. //` &&
               ` NOTE: the original's showCloseButton="falseue" typo on two items is corrected to false, otherwise UI5 boolean parsing rejects it. // POST-1.71: the NotificationList container control (since UI5 1.90)` &&
               ` is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.90 to render it (control-level, invisible to the member-level property gate).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.NotificationListGroup`           name = `NotificationListGroup`                         class = `z2ui5_cl_dmo_app_077` path = `src/01/b09/z2ui5_cl_dmo_app_077.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `the NotificationList container control (since UI5 1.90) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.90 to render it (control-level, invisible to the member-level` &&
                 ` property gate).` ) ).

    lv_text1 = `POST-1.71: sap.m.NotificationList (control since UI5 1.90) is the container the sample binds its groups to and is kept 1:1, like the other notification ports (076/077). templateShareable: true is a` &&
               ` binding-info parameter, not a control member, so no gate can see it - it is kept verbatim on all four aggregation bindings and declared here by policy (apps 264/265 precedent). The app needs a UI5` &&
               ` release >= 1.90. // NOTE: three levels of bound aggregation, which is what the sample is about: NotificationList.items over the groups, NotificationListGroup.items over that group's items, and` &&
               ` buttons over the group's and the item's own button rows. The ABAP model mirrors that as nested tables (ty_t_group > groupitems ty_t_item > itembuttons ty_t_button), and every relative binding inside` &&
               ` a template addresses its own row. // NOTE: four of the five controller handlers compose their toast from the pressed control and stay on the client, roundtrip-free: onGroupClose and onListItemPress` &&
               ` with ${$source>/title}, onGroupButtonPress and onItemButtonPress with ${$source>/text}. Only onItemClose needs the backend, because it REMOVES the row (oList.removeItem): the item's own title travels`.
    lv_text1 = lv_text1 && ` as a $-prefixed event arg and the handler deletes that row from every group before pushing the model back. The titles are unique in this data; a real app would carry a key. // NOTE: the` &&
               ` priorityFormatter is dropped. It maps a value that is not a sap.ui.core.Priority to Priority.None - presentation logic that the thin-frontend rule puts in the backend, and the mock's priorities` &&
               ` (High, Low) are all valid anyway, so the port binds PRIORITY directly. A model_init that seeded an unknown value would have to map it there. // NOTE: the item rows bind datetime={CREATIONDATE}, but` &&
               ` only the GROUPS carry a creationDate in the mock and the group template does not bind it - so the field exists on the item row type and stays empty on both items, exactly as the original renders it.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.NotificationListGroup`           name = `NotificationListGroupBindings`                 class = `z2ui5_cl_dmo_app_291` path = `src/01/b23/z2ui5_cl_dmo_app_291.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.34`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.NotificationList (control since UI5 1.90) is the container the sample binds its groups to and is kept 1:1, like the other notification ports (076/077). templateShareable: true is a binding-info` &&
                 ` parameter, not a control member, so no gate can see it - it is kept verbatim on all four aggregation bindings and declared here by policy (apps 264/265 precedent). The app needs a UI5 release >=` &&
                 ` 1.90.` ) ).

    lv_text1 = `NOTE: onItemClose is reproduced 1:1 since 2026-08-05. The original removes the item from its list (oList.removeItem(oItem)) and toasts its title; the port does BOTH client-side on the same event: UI5` &&
               ` runs a ';'-separated pair of event handlers (measured with scripts/probes/event-arg-expression-probe.mjs), so the wire chains control_by_id removeItem with the client-composed toast. The item travels` &&
               ` as its own id ($event.oSource.getId()), which ManagedObject.removeAggregation accepts (measured in the same probe). The NotificationList gained an ``id`` the original does not carry - removeItem` &&
               ` needs a target for the wire; that is the port's only extra attribute here. The earlier 'static items, so close only toasts' rationale is retired. // POST-1.71: the NotificationList container control` &&
               ` (since UI5 1.90) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.90 to render it (control-level, invisible to the member-level property gate). // NOTE: the sample's` &&
               ` demo-kit authorPicture image paths (test-resources/sap/m/images/Woman_04.png, headerImg2.jpg, female_BaySu.jpg) are resolved to absolute sdk.openui5.org URLs. // NOTE: live-verified 2026-08-04`.
    lv_text1 = lv_text1 && ` (nightly e2e interaction): all toasts were switched to roundtrip-free client-composed control_global toasts on 2026-07-22 (the app is now init-only) - re-verify press/close/accept/reject/error each` &&
               ` toast their text. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the 'Accept' footer button toasts 'Accept Button Pressed'; item press/close toasts are the` &&
               ` identical wire but unexercised.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.NotificationListItem`            name = `NotificationListItem`                          class = `z2ui5_cl_dmo_app_076` path = `src/01/b09/z2ui5_cl_dmo_app_076.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `the NotificationList container control (since UI5 1.90) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.90 to render it (control-level, invisible to the member-level` &&
                 ` property gate).` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.NumericContent`                  name = `NumericContentDifColors`                       class = `z2ui5_cl_dmo_app_156` path = `src/01/b15/z2ui5_cl_dmo_app_156.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        notes = `NOTE: The NumericContent / GenericTile presses show a client MessageToast ('The numeric content is pressed.'), matching the original press handler. Four NumericContents (value colors` &&
                 ` Good/Critical/Error, indicators) plus a GenericTile > TileContent > NumericContent are reproduced 1:1. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): pressing` &&
                 ` the first NumericContent toasts 'The numeric content is pressed.'; the other tiles are the identical wire.` )
      ( module = `sap.m`              control = `sap.m.NumericContent`                  name = `NumericContentIcon`                            class = `z2ui5_cl_dmo_app_064` path = `src/01/b07/z2ui5_cl_dmo_app_064.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        notes = `NOTE: the second NumericContent keeps the sample's original demokit test-resources image path (test-resources/sap/m/demokit/sample/NumericContentIcon/images/grass.jpg) as the icon literal 1:1;` &&
                 ` abap2UI5 does not serve that static asset, so it does not render offline (the first tile's sap-icon://travel-expense does). The image is archived under ui5/sap.m/NumericContentIcon/images/.` )
      ( module = `sap.m`              control = `sap.m.ObjectAttribute`                 name = `ObjectAttributeInTable`                        class = `z2ui5_cl_dmo_app_191` path = `src/01/b17/z2ui5_cl_dmo_app_191.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        notes = `NOTE: the JSONModel is defined inline in the original controller's onInit (an array of {product, supplier} rows under /modelData); it is moved verbatim into ABAP model_init (all 10 rows kept) and` &&
                 ` bound on the one default model. Pure prefix/root rename (/modelData -> the default model root), same data, renders identically.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ObjectAttribute`                 name = `ObjectAttributes`                              class = `z2ui5_cl_dmo_app_073` path = `src/01/b09/z2ui5_cl_dmo_app_073.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        is_post171 = abap_true
        notes = `NOTE: element binding kept 1:1 - the two display ObjectAttributes bind a one-record structure /S_PRODUCT instead of {/ProductCollection/0}; record 0 fields verbatim. // NOTE: handleSAPLinkPressed's` &&
                 ` URLHelper.redirect maps to the URLHELPER REDIRECT frontend action (cs_event-urlhelper); handleFeedbacklinkPressed's Dialog (a RatingIndicator + TextArea with Submit/Cancel Button) is rebuilt via` &&
                 ` popup_display, the Submit button's 2s setBusy delay dropped. // POST-1.71: ObjectAttribute.ariaHasPopup (since UI5 1.97) is kept 1:1 on the feedback attribute; needs UI5 >= 1.97.`
        post171 = `ObjectAttribute.ariaHasPopup (since UI5 1.97) is kept 1:1 on the feedback attribute; needs UI5 >= 1.97.` ) ).

    lv_text1 = `NOTE: the ObjectHeader keeps the original element binding and relative field bindings 1:1 (title, numberUnit, the ObjectAttribute composite texts and the sap.ui.model.type.Currency number binding);` &&
               ` only the binding context path changes - a one-record structure /S_PRODUCT in the default model instead of {/ProductCollection/0}, since the port does not carry the whole collection. // NOTE: the` &&
               ` model holds exactly the bound record /ProductCollection/0 (Notebook Basic 15) of ui5/mock/products.json, verbatim - this is the original sample's own single-record binding {/ProductCollection/0}, not` &&
               ` a shortened data set. // NOTE: the active ObjectAttribute 'www.sap.com' opens via the URLHELPER REDIRECT frontend action (cs_event-urlhelper, { URL, NEW_WINDOW } object param) - not open_new_tab,` &&
               ` which is same-origin-only.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ObjectHeader`                    name = `ObjectHeader`                                  class = `z2ui5_cl_dmo_app_041` path = `src/01/b01/z2ui5_cl_dmo_app_041.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        checked = `CHECKED (2026-07-19): verified in a running system - human visual pass 2026-07-19 over all apps: the element binding {/S_PRODUCT} resolves all relative field bindings incl. the Currency number - the` &&
                 ` ObjectHeader renders fully populated.`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ObjectHeader`                    name = `ObjectHeaderCondensed`                         class = `z2ui5_cl_dmo_app_201` path = `src/01/b17/z2ui5_cl_dmo_app_201.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        notes = `NOTE: the ObjectHeader keeps the original element binding and its relative field bindings 1:1 (title {Name}, condensed, numberUnit {CurrencyCode}, the ObjectAttribute composite text and the` &&
                 ` sap.ui.model.type.Currency number binding over Price/CurrencyCode); only the binding context path changes - a one-record structure /S_PRODUCT in the default model instead of {/ProductCollection/0},` &&
                 ` since the port does not carry the whole collection. // NOTE: the model holds exactly the bound record /ProductCollection/0 (Notebook Basic 15) of ui5/mock/products.json, verbatim - this is the` &&
                 ` original sample's own single-record binding {/ProductCollection/0}, not a shortened data set.` ) ).

    lv_text1 = `NOTE: The ObjectHeader's single-record element binding attribute binding="{/ProductCollection/5}" is dropped: abap2UI5 serves one default model, so products.json row 5 is seeded directly onto the` &&
               ` model root (model_init) and the control's relative {NAME}/{PRICE}/… bindings resolve against it — same data, renders identically (single-record fold, AGENTS §5). **Corrected 2026-08-01**: those` &&
               ` bindings were written RELATIVE ({FIELD}) and a relative path on a control with no binding context resolves against nothing — the fields rendered EMPTY in the running app (measured with the e2e` &&
               ` harness, the app-207 class). They are now bound ABSOLUTELY through client->_bind( field ), which is what a root-seeded record needs. // NOTE: **e2e-verified 2026-08-01** (scripts/e2e-smoke.mjs` &&
               ` interaction, transpiled backend + real browser): the element-bound record resolves in the running app - the title 'Notebook Professional 15' and the bound description render. This is the port that` &&
               ` exposed the relative-binding defect (see the corrected NOTE above): it rendered EMPTY until the fields were bound absolutely. Residual: the Currency type's locale formatting of the number.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ObjectHeader`                    name = `ObjectHeaderImage`                             class = `z2ui5_cl_dmo_app_206` path = `src/01/b17/z2ui5_cl_dmo_app_206.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ObjectHeader`                    name = `ObjectHeaderMarkers`                           class = `z2ui5_cl_dmo_app_197` path = `src/01/b17/z2ui5_cl_dmo_app_197.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        notes = `NOTE: the Page keeps the original element binding and the ObjectHeader relative field bindings 1:1 (title {Name}, numberUnit {CurrencyCode}, the two ObjectAttribute composite texts and the` &&
                 ` sap.ui.model.type.Currency number binding over Price/CurrencyCode); only the binding context path changes - a one-record structure /S_PRODUCT in the default model instead of {/ProductCollection/0},` &&
                 ` since the port does not carry the whole collection. // NOTE: the model holds exactly the bound record /ProductCollection/0 (Notebook Basic 15) of ui5/mock/products.json, verbatim - this is the` &&
                 ` original sample's own single-record binding {/ProductCollection/0}, not a shortened data set.` ) ).

    lv_text1 = `NOTE: The ObjectHeader's single-record element binding attribute binding="{/ProductCollection/0}" is dropped: abap2UI5 serves one default model, so products.json row 0 (HT-1000, Notebook Basic 15) is` &&
               ` seeded directly onto the model root (model_init) and the control's relative {NAME}/{DESCRIPTION}/{SUPPLIERNAME}/{WIDTH}/… bindings resolve against it — same data, renders identically (single-record` &&
               ` fold, AGENTS §5). The ProductPicUrl asset is served absolute from sdk.openui5.org per the asset-URL rule. **Corrected 2026-08-01**: those bindings were written RELATIVE ({FIELD}) and a relative path` &&
               ` on a control with no binding context resolves against nothing — the fields rendered EMPTY in the running app (measured with the e2e harness, the app-207 class). They are now bound ABSOLUTELY through` &&
               ` client->_bind( field ), which is what a root-seeded record needs. // NOTE: **e2e-verified 2026-08-01** (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): the folded single record`.
    lv_text1 = lv_text1 && ` resolves in the running app - the title 'Notebook Basic 15' and the Manufacturer attribute 'Very Best Screens' render. Like 206 this port rendered EMPTY until the fields were bound absolutely (see` &&
               ` the corrected NOTE above). Residual: the ObjectMarker icons, which need the theme CSS the harness does not load.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ObjectHeader`                    name = `ObjectHeaderResponsiveV`                       class = `z2ui5_cl_dmo_app_209` path = `src/01/b17/z2ui5_cl_dmo_app_209.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ObjectIdentifier`                name = `ObjectIdentifier`                              class = `z2ui5_cl_dmo_app_071` path = `src/01/b09/z2ui5_cl_dmo_app_071.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        notes = `NOTE: element binding kept 1:1 - the VerticalLayout binds a one-record structure /S_PRODUCT in the default model instead of {/ProductCollection/0}; titleClicked's MessageBox.alert becomes` &&
                 ` message_box_display. // NOTE: the model holds exactly the bound record /ProductCollection/0 (Notebook Basic 15) of ui5/mock/products.json, verbatim - the original's own single-record binding.` )
      ( module = `sap.m`              control = `sap.m.ObjectListItem`                  name = `ObjectListItem`                                class = `z2ui5_cl_dmo_app_074` path = `src/01/b09/z2ui5_cl_dmo_app_074.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        notes = `NOTE: the ObjectStatus '.formatter.status' (Status -> ValueState) is precomputed into the STATUS_STATE model field (Available->Success, Out of Stock->Warning, Discontinued->Error, else None). // NOTE:` &&
                 ` the press toast was switched to a roundtrip-free client-composed toast on 2026-07-22 (control_global MESSAGE_TOAST.show, template ``Pressed : {0}`` filled by ${NAME}; on_event dropped, init-only) -` &&
                 ` re-verify pressing an item toasts "Pressed : <name>". **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): pressing the first ObjectListItem toasts 'Pressed :` &&
                 ` <name>'; the other rows are the identical template wire.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ObjectListItem`                  name = `ObjectListItemMarkers`                         class = `z2ui5_cl_dmo_app_198` path = `src/01/b17/z2ui5_cl_dmo_app_198.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        notes = `NOTE: the list-item press was built as a roundtrip-free client-composed toast (control_global MESSAGE_TOAST.show, template ``Pressed : {0}`` filled by ${$source>/title}, reproducing the controller's` &&
                 ` MessageToast.show("Pressed : " + oEvent.getSource().getTitle())) - re-verify pressing an item toasts "Pressed : <title>". **e2e-verified 2026-07-30** (transpiled-framework interaction,` &&
                 ` scripts/e2e-smoke.mjs): pressing the first ObjectListItem toasts 'Pressed : <title>' (the ${$source>/title} template resolves).` )
      ( module = `sap.m`              control = `sap.m.ObjectMarker`                    name = `ObjectMarker`                                  class = `z2ui5_cl_dmo_app_237` path = `src/01/b19/z2ui5_cl_dmo_app_237.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.38`
        notes = `NOTE: the Table's items model is the anonymous JSON model set in onInit (new JSONModel({modelData:[...]}), items='{path:/modelData}'); folded to the one default model as client->_bind( t_modeldata )` &&
                 ` -> {/T_MODELDATA}. Same data, last path segment identical, structural-diff 0 diffs. Child bindings {product}/{type}/{additionalInfo} map to the upper-cased fields {PRODUCT}/{TYPE}/{ADDITIONALINFO}.` &&
                 ` // NOTE: onPress (on the third, interactive ObjectMarker): the original does MessageToast.show( evt.getParameter( "type" ) + " marker pressed!" ); reproduced roundtrip-free as a client-composed toast` &&
                 ` (cs_event-control_global MESSAGE_TOAST, template '{0} marker pressed!' filled by ${$parameters>/type}). The press attribute is kept, so structural-diff sees no difference.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ObjectNumber`                    name = `ObjectNumber`                                  class = `z2ui5_cl_dmo_app_072` path = `src/01/b09/z2ui5_cl_dmo_app_072.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.12`
        is_post171 = abap_true
        notes = `NOTE: the original binds records {/ProductCollection/0..5} of the shared mock; the port carries exactly those 6 records as a default-model table T_PRODUCTS and element-binds each ObjectNumber to` &&
                 ` /T_PRODUCTS/0..5 (index binding), Price+CurrencyCode verbatim. // POST-1.71: ObjectNumber.inverted, ObjectNumber.active and ObjectNumber.press (all since UI5 1.86) are kept 1:1 for the` &&
                 ` inverted/interactive variants; needs UI5 >= 1.86.`
        post171 = `ObjectNumber.inverted, ObjectNumber.active and ObjectNumber.press (all since UI5 1.86) are kept 1:1 for the inverted/interactive variants; needs UI5 >= 1.86.` )
      ( module = `sap.m`              control = `sap.m.ObjectStatus`                    name = `ObjectStatus`                                  class = `z2ui5_cl_dmo_app_042` path = `src/01/b01/z2ui5_cl_dmo_app_042.clas.abap`
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
      ( module = `sap.m`              control = `sap.m.OverflowToolbar`                 name = `ToolbarDesign`                                 class = `z2ui5_cl_dmo_app_086` path = `src/01/b10/z2ui5_cl_dmo_app_086.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.28`
        notes = `NOTE: the Select ``change`` handlers onSelectDesign/onSelectStyle (setDesign/setStyle) become two-way bound design/style; bActionContext (design != Info) becomes an expression binding on the Buttons'` &&
                 ` visible.` ) ).

    lv_text1 = `NOTE: Both halves of the controller are now reproduced instead of faked. (a) onPress toasts oEvent.getSource().getText(); the port transports that value - control_global MESSAGE_TOAST.show with the` &&
               ` template '{0}' filled by ${$source>/text} (the app-003 shape) - instead of hardcoding each button's caption, so the icon-only Print button toasts its (empty) text exactly as the original does. (b)` &&
               ` onOpen Fragment.loads ActionSheet.fragment.xml and calls openBy(button): the port rebuilds that fragment 1:1 in on_event (ActionSheet title 'Menu', showCancelButton, placement Top, the five Buttons` &&
               ` with their icons and visible bindings) and anchors it with client->popover_display( by_id = $event.oSource.sId ) - the overflow Button therefore fires a real backend event instead of a placeholder` &&
               ` 'Overflow' toast. The fragment's {range>/isPhone} / {range>/isPhoneOrTablet} bindings fold onto the default model like the view's (a new isphone field joins the existing range flags). // NOTE: The` &&
               ` original drives the footer toolbar button visibility from a separate 'range' media JSON model ({range>/isNoPhone}, isNotPhoneOrTablet, isTablet, isPhoneOrTablet). abap2UI5 has one default model, so`.
    lv_text1 = lv_text1 && ` the flags live flat in it and visible binds them directly - the 'range>' prefix is dropped; the last path segment is identical, which structural-diff matches. Values use the desktop media ranges (the` &&
               ` original filled them from Device.media - a client-only decision).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.OverflowToolbar`                 name = `ToolbarResponsive`                             class = `z2ui5_cl_dmo_app_163` path = `src/01/b17/z2ui5_cl_dmo_app_163.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: the token interaction is reproduced since 2026-08-05, in the two shapes the sample needs. The FIRST tokenizer - the one onAddToken/onTokenDelete work on - has its three static tokens folded into` &&
               ` a bound aggregation (the app-085 pattern), so adding appends a row (with the original's empty-input toast and the input cleared afterwards) and deleting removes the row by key; that costs 3 static` &&
               ` Token controls against the original's 24, the port now declaring one bound template instead. The other three tokenizers keep their static tokens and delete them roundtrip-free through control_by_id` &&
               ` removeToken with the token's ID - measured with scripts/probes/event-arg-expression-probe.mjs, ManagedObject.removeAggregation accepts an id and the token really leaves the aggregation - plus the` &&
               ` original's 'Token deleted: X' toast. The earlier claim (imperative control mutation over static tokens is 'not expressible without inventing a bound token model') was half wrong: the bound model is` &&
               ` what the sample's own add path needs, and removal by id needs no model at all. // POST-1.71: sap.m.OverflowToolbar ariaHasPopup (since 1.79.0) is kept 1:1 from the original view; needs a UI5 release`.
    lv_text1 = lv_text1 && ` >= 1.79 to render. // POST-1.71: REVIEW FINDING (out of scope, maintainer decision needed): the ported control sap.m.OverflowToolbarTokenizer itself is tagged @ui5-experimental-since 1.139 in the` &&
               ` OpenUI5 source and carries NO plain @since tag, so scripts/scope-of.mjs misreads it as base-version (<= 1.71, 'no @since header') and the property gate cannot see it either. The sample is out of` &&
               ` porting scope per AGENTS §1 (control must exist since UI5 1.71); the app needs a UI5 release >= 1.139 (experimental API) to render. Either drop the port or add a ui5/scope-exceptions.json entry;` &&
               ` scope-of.mjs should also learn @ui5-experimental-since.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.OverflowToolbarTokenizer`        name = `OverflowToolbarTokenizer`                      class = `z2ui5_cl_dmo_app_203` path = `src/01/b17/z2ui5_cl_dmo_app_203.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.139`
        since_post171 = abap_true
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.OverflowToolbar ariaHasPopup (since 1.79.0) is kept 1:1 from the original view; needs a UI5 release >= 1.79 to render. // REVIEW FINDING (out of scope, maintainer decision needed): the ported` &&
                 ` control sap.m.OverflowToolbarTokenizer itself is tagged @ui5-experimental-since 1.139 in the OpenUI5 source and carries NO plain @since tag, so scripts/scope-of.mjs misreads it as base-version (<=` &&
                 ` 1.71, 'no @since header') and the property gate cannot see it either. The sample is out of porting scope per AGENTS §1 (control must exist since UI5 1.71); the app needs a UI5 release >= 1.139` &&
                 ` (experimental API) to render. Either drop the port or add a ui5/scope-exceptions.json entry; scope-of.mjs should also learn @ui5-experimental-since.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Page`                            name = `PageStandardClasses`                           class = `z2ui5_cl_dmo_app_089` path = `src/01/b11/z2ui5_cl_dmo_app_089.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: element binding kept 1:1 - a one-record structure /S_PRODUCT instead of {/ProductCollection/0}; the IconTabBar expanded stays bound to {device>/isNoPhone} (runtime device model).` )
      ( module = `sap.m`              control = `sap.m.Panel`                           name = `PanelBackgroundDesign`                         class = `z2ui5_cl_dmo_app_292` path = `src/01/b23/z2ui5_cl_dmo_app_292.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16`
        notes = `NOTE: the Select's change attribute is dropped, and with it the whole controller. onBackgroundDesignChange only reads the selected key and pushes it into the panel with setBackgroundDesign - both ends` &&
                 ` are bindable properties, so Select.selectedKey and Panel.backgroundDesign bind the SAME field: the Select writes it, the Panel reads it, and no event and no round-trip are needed at all` &&
                 ` (prefer-a-bindable-property, linter rule settable-property-via-action). The class has no on_event and no model_init; the initial Solid comes from the field's own VALUE.` ) ).

    lv_text1 = `NOTE: the original controller toggles the third panel imperatively (onOverflowToolbarPress -> oPanel.setExpanded(!oPanel.getExpanded())). The port binds Panel.expanded two-way instead and only flips` &&
               ` the flag server-side, per the prefer-a-bindable-property rule: the state then lives in the model, where it survives a view rebuild and a draft restore, and the control's own expand/collapse writes` &&
               ` back into it rather than drifting from a server-side mirror. This REVERSES the 2026-07-18 decision recorded here before (which had replaced the binding with the whitelisted setExpanded to 'match the` &&
               ` original view.xml exactly'); an added attribute is not a structural diff, and the rulebook has since settled the other way. The linter rule settable-property-via-action now gates it corpus-wide. //` &&
               ` NOTE: live-verified 2026-08-04 (nightly e2e interaction): the two-way expanded binding is not live-verified. The imperative form it replaces WAS: human live check 2026-07-20 following the interaction`.
    lv_text1 = lv_text1 && ` checklist, all listed checks passed - kept here as context. A fresh live run (toolbar press expands and collapses the third panel, and a manual expand/collapse of the panel header survives the next` &&
               ` round-trip) restamps this port to checked.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Panel`                           name = `PanelExpanded`                                 class = `z2ui5_cl_dmo_app_043` path = `src/01/b04/z2ui5_cl_dmo_app_043.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: the two PDF paths are the ones onInit resolves with sap.ui.require.toUrl('sap/m/sample/PDFViewerEmbedded/sample.pdf') and '.../sample_nonexisting.pdf'. An abap2UI5 system does not serve the demo` &&
               ` kit module path, so both are pinned to the OpenUI5 host in their SDK form (https://sdk.openui5.org/test-resources/sap/m/demokit/sample/PDFViewerEmbedded/sample.pdf and sample_nonexisting.pdf) per the` &&
               ` runtime asset-URL rule - same two file names, same sample folder, only the host-side prefix differs from the module path the original writes (app 131/152 precedent). The second one is MEANT to 404:` &&
               ` it is how the sample demonstrates the PDFViewer's loading error. // NOTE: the controller keeps the two paths in closure variables and swaps /Source with setProperty. Here they are PROTECTED CONSTANTS` &&
               ` and only the bound SOURCE field is public - a value that exists solely to be assigned is not model data (AGENTS section 10, every PUBLIC attribute is persisted app state).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.PDFViewer`                       name = `PDFViewerEmbedded`                             class = `z2ui5_cl_dmo_app_288` path = `src/01/b22/z2ui5_cl_dmo_app_288.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.48`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: the original onInit creates a popup-mode sap.m.PDFViewer and adds it as a view dependent; it is declared 1:1 in the view's mvc:dependents aggregation (an extra PDFViewer element vs the original` &&
               ` view.xml, which never carries it - there it lives in the controller). onPress' setSource/setTitle/open() becomes a bound source updated per click, the constant title declared in the view, and the` &&
               ` whitelisted open via client->follow_up_action( cs_event-control_by_id ) after render - popup mode 1:1, the earlier Dialog embedding workaround is gone (whitelist extended upstream 2026-07-18, see` &&
               ` pr/control-call-whitelist). // NOTE: the per-image JSONModels of onInit (a Source/Preview URL pair per Image) have no server-side equivalent; the Image src (original {/Preview}) is resolved to static` &&
               ` absolute sdk.openui5.org URLs and the Source travels through the one bound pdf_source field - same family as pr/named-json-models. // POST-1.71: the PDFViewer property isTrustedSource (since UI5` &&
               ` 1.121, backported to maintenance patches down to 1.71.63; the original controller passes isTrustedSource: true) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.121 (or`.
    lv_text1 = lv_text1 && ` a patched maintenance release) to render it.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.PDFViewer`                       name = `PDFViewerPopup`                                class = `z2ui5_cl_dmo_app_044` path = `src/01/b03/z2ui5_cl_dmo_app_044.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, reviewed, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a` &&
                 ` close look.`
        since = `1.48`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = lv_text1
        post171 = `the PDFViewer property isTrustedSource (since UI5 1.121, backported to maintenance patches down to 1.71.63; the original controller passes isTrustedSource: true) is newer than 1.71 but kept for the` &&
                 ` 1:1 port - the app needs a UI5 release >= 1.121 (or a patched maintenance release) to render it.` ) ).

    lv_text1 = `NOTE: The object-typed calendar date properties (PlanningCalendar.startDate, CalendarAppointment.startDate/endDate) are fed from plain ISO strings in the model and converted at the point of use with` &&
               ` Formatter.DateCreateObject from the curated module (core:require='{Formatter: z2ui5/model/formatter}'). The original's UI5Date.getInstance(year, month0, day, ...) values are normalized to ISO 1:1` &&
               ` (month is 0-based; day/month overflow rolled forward exactly as the JS Date constructor does). // NOTE: appointmentSelect / intervalSelect / the toggleDayNamesLine ToggleButton are reproduced since` &&
               ` 2026-08-05, after the 2026-07-27 review had retyped the entry from NOTE to IMPROVISED because a lost behaviour is not a NOTE. handleAppointmentSelect's MessageBox is composed in ABAP from values the` &&
               ` event carries (${$parameters>/appointment}.getTitle() / .getSelected(), $event.oSource.getSelectedAppointments().length and the appointments array length for the no-appointment branch), so both` &&
               ` branches of the original read exactly as before - the message is modal, so the round-trip costs nothing visible. handleIntervalSelect appends the sample's new appointment ('new appointment', Type09)`.
    lv_text1 = lv_text1 && ` over the selected interval, whose start/end travel as their LOCAL parts (a UTC toISOString( ) would shift the day). toggleDayNamesLine is the bindable showDayNamesLine (@since 1.50) shared with the` &&
               ` ToggleButton's pressed state, so the press attribute is not emitted - the prefer-a-bindable-property rule. // POST-1.71: Formatter.DateCreateObject is referenced via core:require, which needs UI5 >=` &&
               ` 1.74. sap.m.PlanningCalendar itself is since 1.34 (in scope). Also sap.ui.unified.CalendarAppointment.ariaHasPopup (@since 1.150.0) is kept 1:1 from the original view (ariaHasPopup='{ariaHasPopup}');` &&
               ` newer than 1.71, declared. Was undeclared because the property gate was sap.m-only (now extended to all libs, 2026-07-24).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.PlanningCalendar`                name = `PlanningCalendarSingle`                        class = `z2ui5_cl_dmo_app_108` path = `src/01/b14/z2ui5_cl_dmo_app_108.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-27): verified in a running system 2026-07-27 - PlanningCalendar renders all appointments/interval headers via Formatter.DateCreateObject; interactions toast as declared`
        notes = lv_text1
        post171 = `Formatter.DateCreateObject is referenced via core:require, which needs UI5 >= 1.74. sap.m.PlanningCalendar itself is since 1.34 (in scope). Also sap.ui.unified.CalendarAppointment.ariaHasPopup (@since` &&
                 ` 1.150.0) is kept 1:1 from the original view (ariaHasPopup='{ariaHasPopup}'); newer than 1.71, declared. Was undeclared because the property gate was sap.m-only (now extended to all libs, 2026-07-24).` ) ).

    lv_text1 = `POST-1.71: Button.ariaHasPopup (since UI5 1.84) is kept 1:1 on the two view buttons (ariaHasPopup='Dialog'); the app needs a UI5 release >= 1.84 to render it. // NOTE:` &&
               ` handlePopoverPress/handleResizablePopoverPress lazily Fragment.load a Popover and openBy(button). The port builds each popover as a core:FragmentDefinition on the button-press round-trip and shows it` &&
               ` anchored to the pressed button via client->popover_display( xml = ..., by_id = $event.oSource.sId ) - the popover XML parameter is named ``xml`` (not ``val`` like popup_display). This is a` &&
               ` server-round-trip where the original is a client-side Fragment.load, but it is faithful (lazy either way) and matches app 094. // NOTE: the original oPopover.bindElement('/ProductCollection/0') binds` &&
               ` each popover to a single record; the port seeds that record's fields (name, productpicurl) at the default-model root and the popover's relative bindings {NAME}/{PRODUCTPICURL} resolve against the` &&
               ` root - same data, structural-diff matches on the last path segment (app 175 single-record-flatten idiom). No bind_element needed because the record is the static row 0, not a per-row selection.`.
    lv_text1 = lv_text1 && ` **Corrected 2026-08-01**: those bindings were written RELATIVE ({FIELD}) and a relative path on a control with no binding context resolves against nothing — the fields rendered EMPTY in the running` &&
               ` app (measured with the e2e harness, the app-207 class). They are now bound ABSOLUTELY through client->_bind( field ), which is what a root-seeded record needs. // NOTE: handleEmailPress does` &&
               ` byId('myPopover').close() + MessageToast.show('E-Mail has been sent'), and handleClose does byId('myResizablePopover').close(); both close the popover slot via follow_up_action(` &&
               ` cs_event-popover_close ) (there is one popover slot open at a time), the email variant additionally toasting via message_toast_display. // NOTE: the JSONModel is loaded from the shared` &&
               ` sap/ui/demo/mock/products.json; only the single record /ProductCollection/0 is bound, so only its name + picture URL are seeded. The mock's host-relative ProductPicUrl ('test-resources/...') is` &&
               ` resolved to an absolute sdk.openui5.org URL. // NOTE: live-verified 2026-08-04 (nightly e2e interaction): partly verified 2026-08-01 (scripts/e2e-smoke.mjs interaction, transpiled backend + real`.
    lv_text1 = lv_text1 && ` browser): the first popover opens anchored to its button (popover_display by_id = $event.oSource.sId) AND the root-seeded record now reaches it - the popover shows 'Notebook Basic 15' (it rendered` &&
               ` empty until the relative bindings were made absolute the same day, see the corrected NOTE above). Still unverified in a running system: the second popover's placement, and that the Email / Close` &&
               ` footer buttons close it (popover_close) with the Email one opening the mail client.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Popover`                         name = `Popover`                                       class = `z2ui5_cl_dmo_app_229` path = `src/01/b18/z2ui5_cl_dmo_app_229.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Button.ariaHasPopup (since UI5 1.84) is kept 1:1 on the two view buttons (ariaHasPopup='Dialog'); the app needs a UI5 release >= 1.84 to render it.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Popover`                         name = `PopoverControllingCloseBehavior`               class = `z2ui5_cl_dmo_app_094` path = `src/01/b11/z2ui5_cl_dmo_app_094.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = `POST-1.71: Link.ariaHasPopup (since 1.86) is kept 1:1 on the popover link; needs UI5 >= 1.86. // NOTE: the row Popover reproduces the original bindElement: it is built per-press with relative bindings` &&
                 ` ({PRODUCT_ID} title, {NAME}, {PRODUCT_PIC_URL}) and follow_up_action( cs_event-bind_element, view=cs_view-popover ) element-binds the popover slot to t_products/<index>, where the index comes from` &&
                 ` the pressed row's binding context ($event.oSource.getBindingContext().getPath()); the popover is anchored by $event.oSource.sId and the Action button reproduces handleActionPress 1:1 (a toast 'Action` &&
                 ` has been pressed' + follow_up_action( cs_event-popover_close )). The disable/enable-pointer-events-while-open behavior is dropped.`
        post171 = `Link.ariaHasPopup (since 1.86) is kept 1:1 on the popover link; needs UI5 >= 1.86.` ) ).

    lv_text1 = `NOTE: the sample's point - Popup.setWithinArea(this.byId('withinArea')), which confines every popup to the grey VBox instead of the viewport - is reproduced through the CONTROL_GLOBAL target POPUP` &&
               ` with the method setWithinArea (added to abap2UI5 for this port; the pr/popup-within-area request is implemented). Two differences to the original wiring, both without visible effect here: it is set` &&
               ` ONCE together with the view instead of in each press handler, because a follow_up_action runs AFTER the popover of the same round-trip has already opened - and the Popover.afterClose handler of all` &&
               ` three popovers, whose only job was Popup.setWithinArea(null), is therefore dropped. This app opens no other popup, so a permanently set area behaves exactly like the per-press one. Needs UI5 >= 1.89` &&
               ` for setWithinArea. // NOTE: the three popovers live in three *.fragment.xml files the controller loads with Fragment.load and opens with openBy(oButton). They are rebuilt as three` &&
               ` core:FragmentDefinition documents shown with popover_display( xml = ... by_id = ... ), anchored on the pressing button transported as $event.oSource.sId - the documented 1:1 path. // NOTE: flattened`.
    lv_text1 = lv_text1 && ` element binding: each popover gets bindElement('/ProductCollection/0'), and the image popover's Popover.title {Name} and Image src {ProductPicUrl} are relative to it. That record (products.json row` &&
               ` 0: Notebook Basic 15 / HT-1000.jpg) is seeded at the ABAP model root, so both bind ABSOLUTELY via client->_bind - a relative {NAME} on a control with no binding context resolves against nothing and` &&
               ` renders empty. structural-diff pairs the port's Popover.title against the wrong one of the three Popovers (it reports 'original {Name} vs port Products', the list popover's literal title); both` &&
               ` titles are 1:1 with the popover they sit on. // NOTE: the two list popovers also carry bindElement('/ProductCollection/0') in the original, but nothing in them is bound relatively - the List binds` &&
               ` the absolute {/ProductCollection} - so that element binding has no effect and has no counterpart here. // POST-1.71: sap.m.Button.ariaHasPopup (since UI5 1.84) is kept 1:1 on all three buttons - the` &&
               ` app needs a UI5 release >= 1.84 for the aria-haspopup attribute.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Popover`                         name = `PopoverWithinArea`                             class = `z2ui5_cl_dmo_app_285` path = `src/01/b20/z2ui5_cl_dmo_app_285.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.Button.ariaHasPopup (since UI5 1.84) is kept 1:1 on all three buttons - the app needs a UI5 release >= 1.84 for the aria-haspopup attribute.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ProgressIndicator`               name = `ProgressIndicator`                             class = `z2ui5_cl_dmo_app_070` path = `src/01/b09/z2ui5_cl_dmo_app_070.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.13.1`
        is_post171 = abap_true
        notes = `NOTE: the two interactive ProgressIndicators (pi-with-animation / pi-without-animation) are set to 0/100 via two-way bound percentValue/displayValue fields updated in a SET event, replacing the` &&
                 ` original's controller byId(...).setPercentValue/setDisplayValue calls. // POST-1.71: ProgressIndicator.displayAnimation (since UI5 1.73) is kept 1:1 on the no-animation ProgressIndicator; needs UI5` &&
                 ` >= 1.73.`
        post171 = `ProgressIndicator.displayAnimation (since UI5 1.73) is kept 1:1 on the no-animation ProgressIndicator; needs UI5 >= 1.73.` )
      ( module = `sap.m`              control = `sap.m.PullToRefresh`                   name = `PullToRefresh`                                 class = `z2ui5_cl_dmo_app_081` path = `src/01/b10/z2ui5_cl_dmo_app_081.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.9.2`
        notes = `NOTE: the incremental backend load is reproduced 1:1: the model starts with the first product and each pull-to-refresh (REFRESH) appends the next until the full /ProductCollection is shown (fill_all +` &&
                 ` shown counter).` ) ).

    lv_text1 = `NOTE: The original binds four separate named JSONModels (CompanyModel / EmployeeModel / GenericModel / GenericModelNoHeader) and swaps the model on the shared QuickView before openBy. abap2UI5 serves` &&
               ` a single default model, so the four data sets are flattened into four ABAP tables (kept in PROTECTED) and the pressed button copies the relevant one into the bound t_pages before the popover is` &&
               ` opened. Named ABAP-fed JSON models are not expressible (CAPABILITIES). // NOTE: The QuickView popover is built per press and shown 1:1 via client->popover_display( xml, by_id ), anchored to the` &&
               ` pressed button (the original oQuickView.openBy(oButton)). The nested pages/groups/elements are a nested ABAP table; relative child aggregations (groups, elements) keep the original binding-info form.` &&
               ` // NOTE: The navigate toast is simplified to a fixed message (the original shows the clicked link's text via navOrigin, a control reference that is not transportable as an event arg). Elements` &&
               ` without an elementType (Generic pages, and the Address/Slogan rows) get the QuickViewGroupElementType default 'text', pages without displayShape (Generic) get the AvatarShape default 'Circle', and`.
    lv_text1 = lv_text1 && ` every element row seeds target '_blank' (the QuickViewGroupElement.target default) - absent JSON properties must not serialize as empty strings, which would override the UI5 defaults. The` &&
               ` EmployeeData icon (a test-resources image) points at the OpenUI5 host. // POST-1.71: sap.m.Avatar (control since 1.73) is kept 1:1 as the page icon via the QuickViewPage avatar aggregation, which` &&
               ` itself is since UI5 1.92 - so the app needs UI5 >= 1.92 to render the avatar. // POST-1.71: sap.m.Button.ariaHasPopup (since 1.84) is kept 1:1 on the four trigger buttons; needs UI5 >= 1.84. // NOTE:` &&
               ` onNavigate names the clicked link in its toast ("Link '<text>' was clicked") and falls back to 'Back button was clicked' when the event carries no navOrigin. **Corrected 2026-08-01**` &&
               ` (faked-event-value audit): the port used to toast the constant 'A QuickView link was clicked' and dropped both the link identity and the back-button branch. The navigate event now transports` &&
               ` ${$parameters>/navOrigin} ? ${$parameters>/navOrigin}.getText() : '' and the ABAP COND rebuilds the original's if/else.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.QuickView`                       name = `QuickView`                                     class = `z2ui5_cl_dmo_app_100` path = `src/01/b12/z2ui5_cl_dmo_app_100.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
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
      ( module = `sap.m`              control = `sap.m.QuickViewCard`                   name = `QuickViewCard`                                 class = `z2ui5_cl_dmo_app_099` path = `src/01/b12/z2ui5_cl_dmo_app_099.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.28.11`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.Avatar (control since 1.73) is kept 1:1 as the page icon via the QuickViewPage avatar aggregation, which itself is since UI5 1.92 - so the app needs UI5 >= 1.92 to render the avatar.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.RadioButton`                     name = `RadioButton`                                   class = `z2ui5_cl_dmo_app_069` path = `src/01/b09/z2ui5_cl_dmo_app_069.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = `POST-1.71: RadioButton.wrapping and RadioButton.wrappingType (both since UI5 1.126) are kept 1:1 on the wrapping-demo group; the app needs a UI5 release >= 1.126 to render them.`
        post171 = `RadioButton.wrapping and RadioButton.wrappingType (both since UI5 1.126) are kept 1:1 on the wrapping-demo group; the app needs a UI5 release >= 1.126 to render them.` )
      ( module = `sap.m`              control = `sap.m.RangeSlider`                     name = `RangeSlider`                                   class = `z2ui5_cl_dmo_app_045` path = `src/01/b02/z2ui5_cl_dmo_app_045.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.38`
        notes = `NOTE: the sample binds the composite RangeSlider "range" property (an array [low, high] - range="{/RS1}" / range="0,100"). abap2UI5 binds scalar ABAP fields, so each range is expressed as the` &&
                 ` equivalent value / value2 properties the control keeps in sync - identical rendering.` ) ).

    lv_text1 = `POST-1.71: Button.ariaHasPopup (since UI5 1.84.0) is kept 1:1 on the two trigger buttons (ariaHasPopup='Dialog'); the app needs a UI5 release >= 1.84 to render it. // NOTE:` &&
               ` handleResponsivePopoverPress/handleResponsivePopoverFooterPress lazily Fragment.load a ResponsivePopover fragment and openBy(button). The port builds each fragment (Popover.fragment.xml ->` &&
               ` ResponsivePopover id='myPopover'; PopoverFooter.fragment.xml -> ResponsivePopover id='myFooterPopover') as a core:FragmentDefinition on the button-press round-trip and shows it anchored to the` &&
               ` pressed button via client->popover_display( xml = ..., by_id = $event.oSource.sId ) - the popover XML parameter is named 'xml' (not 'val' like popup_display). A server round-trip where the original` &&
               ` is a client-side Fragment.load, but faithful (lazy either way) and matches apps 229/238. All ResponsivePopover/Button/Image/OverflowToolbar/ToolbarSpacer controls of both fragments are built in the` &&
               ` port, so the fragment union in structural-diff is satisfied. // NOTE: the original oPopover.bindElement('/ProductCollection/0') binds each popover to a single record; the port seeds that record's`.
    lv_text1 = lv_text1 && ` fields (name, productpicurl) at the default-model root and the fragments' relative bindings {NAME}/{PRODUCTPICURL} resolve against the root - same data, structural-diff matches on the last path` &&
               ` segment. No bind_element follow-up needed because the record is the static row 0, not a per-row selection. **Corrected 2026-08-01**: those bindings were written RELATIVE ({FIELD}) and a relative path` &&
               ` on a control with no binding context resolves against nothing — the fields rendered EMPTY in the running app (measured with the e2e harness, the app-207 class). They are now bound ABSOLUTELY through` &&
               ` client->_bind( field ), which is what a root-seeded record needs. // NOTE: handleCloseButton (Action-A/Action-B) and handleCloseFooterButton (Cancel) each do byId(...).close(); the port routes all` &&
               ` three to one CLOSE event that issues follow_up_action( cs_event-popover_close ) - only one popover slot is open at a time, so a single popover_close covers both fragments. The footer's OK button has` &&
               ` no handler in the original and none here. // NOTE: the JSONModel is loaded from the shared sap/ui/demo/mock/products.json; only the single record /ProductCollection/0 is bound (its Name +`.
    lv_text1 = lv_text1 && ` ProductPicUrl), so only those are seeded. The mock's host-relative ProductPicUrl ('test-resources/...') is resolved to an absolute sdk.openui5.org URL. // NOTE: live-verified 2026-08-04 (nightly e2e` &&
               ` interaction): unverified in a running system: that both ResponsivePopover fragments open anchored to their button (popover_display by_id = $event.oSource.sId), that {NAME}/{PRODUCTPICURL} resolve` &&
               ` from the root-seeded record, and that the action/footer buttons close the popover (popover_close). **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the 'Popover` &&
               ` with Custom Footer' press opens the ResponsivePopover anchored with its OK/Cancel footer; the phone-Dialog variant remains unexercised.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ResponsivePopover`               name = `ResponsivePopover`                             class = `z2ui5_cl_dmo_app_243` path = `src/01/b19/z2ui5_cl_dmo_app_243.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.15.1`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Button.ariaHasPopup (since UI5 1.84.0) is kept 1:1 on the two trigger buttons (ariaHasPopup='Dialog'); the app needs a UI5 release >= 1.84 to render it.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ScrollContainer`                 name = `ScrollContainer`                               class = `z2ui5_cl_dmo_app_046` path = `src/01/b04/z2ui5_cl_dmo_app_046.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed); incl. the phone-emulation device> check`
        notes = `NOTE: the Image src binds {img>/products/pic1} in the original, a JSON image model not available server-side; a static demo image URL is used instead.` )
      ( module = `sap.m`              control = `sap.m.SearchField`                     name = `DialogSearch`                                  class = `z2ui5_cl_dmo_app_090` path = `src/01/b11/z2ui5_cl_dmo_app_090.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: the Dialog (loaded from a fragment in the original) is built and shown via popup_display on the button press; its content is static text, so the bindElement /ProductCollection/0 is a no-op and` &&
                 ` dropped.` )
      ( module = `sap.m`              control = `sap.m.SegmentedButton`                 name = `SegmentedButton`                               class = `z2ui5_cl_dmo_app_047` path = `src/01/b03/z2ui5_cl_dmo_app_047.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `NOTE: the original reads the selected item via oEvent.getParameter("item").getText() / getSelectedItem(). Here the items get keys (one/two/three - an addition, SB1 has none in the sample) and` &&
                 ` selectedKey is two-way bound, so the selection arrives with the event and no private event path is needed - the documented 1:1 path for controller-read selection (CAPABILITIES.md), not a workaround.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Select`                          name = `Select`                                        class = `z2ui5_cl_dmo_app_048` path = `src/01/b02/z2ui5_cl_dmo_app_048.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: the original controller seeds three byte-identical product arrays (/ProductCollection, /ProductCollection2, /ProductCollection3) and binds one Select to each; the port folds them into the single` &&
                 ` shared table /T_PRODUCTS feeding all three Selects - same rows, same sorter, each Select keeps its own two-way selectedKey, so rendering and behaviour are identical.` )
      ( module = `sap.m`              control = `sap.m.Select`                          name = `SelectWithIcons`                               class = `z2ui5_cl_dmo_app_205` path = `src/01/b17/z2ui5_cl_dmo_app_205.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` ) ).

    lv_text1 = `NOTE: The original configures one shared SelectDialog imperatively per button (oButton.data() CustomData ->` &&
               ` setMultiSelect/setGrowing/setGrowingThreshold/setRememberSelections/setShowClearButton/setConfirmButtonText/setDraggable/setResizable/toggleStyleClass). abap2UI5 binds those SelectDialog properties` &&
               ` two-way and each button's handler sets them before opening (responsivePadding toggles the style class via control_by_id addStyleClass/removeStyleClass). The core:CustomData is kept on the buttons for` &&
               ` fidelity; the dialog is declared once in mvc:dependents and opened via follow_up_action( cs_event-control_by_id, open ). // NOTE: Search filters the dialog's items binding client-side via` &&
               ` _event_client( cs_event-binding_call, filter NAME Contains ${$parameters>/value} ). The valueHelpRequest opens a second SelectDialog (also in dependents) after preselecting the row matching the input` &&
               ` value. The confirm / value-help-close toasts are simplified — selectedContexts / selectedItem are control references not transportable as event args (original composes the chosen product names /`.
    lv_text1 = lv_text1 && ` copies the selected title into the input). // NOTE: The StandardListItem icon binds ProductPicUrl, which is derived in ABAP from the product id (the mock's test-resources/<id>.jpg) built from a` &&
               ` shared base pointing at the OpenUI5 host, like app 006's image flattening. The full 123-row /ProductCollection is inlined. // NOTE: live-verified 2026-08-04 (nightly e2e interaction): The per-button` &&
               ` dialog configuration (multi/growing/remember/clear/confirm text/draggable/resizable), the client-side search filter and the value-help selection need an in-system check; machine gates only verify the` &&
               ` views are valid. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the 'Show Select Dialog' popup opens with the 'Select Product' title; the per-button variants,` &&
               ` search and copy-back remain unexercised. // POST-1.71: sap.m.SelectDialog.searchPlaceholder (since 1.110) is kept 1:1 on the value-help dialog; needs UI5 >= 1.110.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.SelectDialog`                    name = `SelectDialog`                                  class = `z2ui5_cl_dmo_app_103` path = `src/01/b12/z2ui5_cl_dmo_app_103.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.SelectDialog.searchPlaceholder (since 1.110) is kept 1:1 on the value-help dialog; needs UI5 >= 1.110.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.SelectList`                      name = `SelectList`                                    class = `z2ui5_cl_dmo_app_075` path = `src/01/b09/z2ui5_cl_dmo_app_075.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26.0` )
      ( module = `sap.m`              control = `sap.m.SelectList`                      name = `SelectListWithIcons`                           class = `z2ui5_cl_dmo_app_211` path = `src/01/b17/z2ui5_cl_dmo_app_211.clas.abap`
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
      ( module = `sap.m`              control = `sap.m.semantic.SemanticPage`           name = `SemanticPage`                                  class = `z2ui5_cl_dmo_app_107` path = `src/01/b13/z2ui5_cl_dmo_app_107.clas.abap`
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
      ( module = `sap.m`              control = `sap.m.semantic.SemanticPage`           name = `SemanticPageFloatingFooter`                    class = `z2ui5_cl_dmo_app_106` path = `src/01/b13/z2ui5_cl_dmo_app_106.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.30.0`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.semantic.SemanticPage`           name = `SemanticPageFullScreen`                        class = `z2ui5_cl_dmo_app_105` path = `src/01/b13/z2ui5_cl_dmo_app_105.clas.abap`
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
    lv_text1 = lv_text1 && ` formats (oRange.getStartDate().toDateString() per entry) - each entry has to be formatted separately and the client expression grammar has NO LOOP - measured 2026-08-05 with` &&
               ` scripts/probes/event-arg-expression-probe.mjs, which showed that indexed access and chained calls DO resolve (so ``[0].getStartDate()`` would work for a single range), but a per-entry map does not` &&
               ` exist. The same boundary as app 060's parent-chain breadcrumb; the toast keeps the event name alone. The transported start date is the client-side string form of the JS Date, not the original's` &&
               ` oStartDate.toString() rendering, so the exact wording of that one line can differ. // POST-1.71: Formatter.DateCreateObject is referenced via core:require (UI5 >= 1.74). sap.m.SinglePlanningCalendar` &&
               ` and its DayView/WorkWeekView/WeekView/MonthView are since 1.61 (in scope). Also the SinglePlanningCalendar events weekNumberPress and selectedDatesChange (@since 1.123) are kept 1:1 from the original` &&
               ` view; newer than 1.71, declared per the property-171 policy.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.SinglePlanningCalendar`          name = `SinglePlanningCalendarDateSelection`           class = `z2ui5_cl_dmo_app_109` path = `src/01/b14/z2ui5_cl_dmo_app_109.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.61`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Formatter.DateCreateObject is referenced via core:require (UI5 >= 1.74). sap.m.SinglePlanningCalendar and its DayView/WorkWeekView/WeekView/MonthView are since 1.61 (in scope). Also the` &&
                 ` SinglePlanningCalendar events weekNumberPress and selectedDatesChange (@since 1.123) are kept 1:1 from the original view; newer than 1.71, declared per the property-171 policy.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Slider`                          name = `Slider`                                        class = `z2ui5_cl_dmo_app_068` path = `src/01/b09/z2ui5_cl_dmo_app_068.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` )
      ( module = `sap.m`              control = `sap.m.SlideTile`                       name = `SlideTile`                                     class = `z2ui5_cl_dmo_app_082` path = `src/01/b10/z2ui5_cl_dmo_app_082.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        notes = `NOTE: the sample's demo-kit backgroundImage paths are resolved to absolute sdk.openui5.org URLs.` ) ).

    lv_text1 = `NOTE: Master-detail navigation is driven 1:1 via follow_up_action( cs_event-control_by_id ) on the newly whitelisted SplitApp methods: to (Go-to-Detail button), backDetail/backMaster (page` &&
               ` navButtonPress), toMaster (master list item), toDetail (master2 list items) and setMode (RadioButtonGroup). The methods were added to the abap2UI5 framework in the same change set (CONTROL_METHODS).` &&
               ` // NOTE: The master2 list navigates via a per-item press event that carries the target page id as a t_arg literal ('detail'/'detailDetail'/'detail2'); the original reads the pressed item's custom:to` &&
               ` CustomData in one List.itemPress handler, which is not transportable as an event arg. custom:to is kept on the items for fidelity. // NOTE: The split mode is selected via a two-way selectedIndex` &&
               ` binding on the RadioButtonGroup (mode_idx) and mapped to the SplitAppMode string in ABAP; the original reads the selected RadioButton's custom:splitAppMode CustomData. custom:splitAppMode is kept on` &&
               ` the buttons for fidelity. The onInit setHomeIcon and the onOrientationChange toast are dropped (device-specific cosmetics). // NOTE: live-verified 2026-08-04 (nightly e2e interaction): SplitApp as`.
    lv_text1 = lv_text1 && ` the root view plus the control_by_id navigation (to/toDetail/toMaster/backDetail/backMaster/setMode) need an in-system check — machine gates only verify view validity, not the runtime navigation` &&
               ` roundtrip. // NOTE: the mode RadioButtonGroup's handler calls oSplitApp.setMode( ) in the original; SplitApp.mode is a bindable property, so the port binds it two-way (added attribute, no structural` &&
               ` diff) and the handler only assigns the chosen mode - the prefer-a-bindable-property rule, gated by the linter rule settable-property-via-action. The state then survives a view rebuild instead of` &&
               ` living only in the control.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.SplitApp`                        name = `SplitApp`                                      class = `z2ui5_cl_dmo_app_097` path = `src/01/b12/z2ui5_cl_dmo_app_097.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: Master-detail navigation is driven 1:1 via follow_up_action( cs_event-control_by_id ) on the newly whitelisted SplitContainer methods: to (Go-to-Detail button), backDetail/backMaster (page` &&
               ` navButtonPress), toMaster (master list item), toDetail (master2 list items) and setMode (RadioButtonGroup). The methods were added to the abap2UI5 framework in the same change set (CONTROL_METHODS).` &&
               ` // NOTE: The master2 list navigates via a per-item press event that carries the target page id as a t_arg literal ('detail'/'detailDetail'/'detail2'); the original reads the pressed item's custom:to` &&
               ` CustomData in one List.itemPress handler, which is not transportable as an event arg. custom:to is kept on the items for fidelity. // NOTE: The split mode is selected via a two-way selectedIndex` &&
               ` binding on the RadioButtonGroup (mode_idx) and mapped to the SplitAppMode string in ABAP; the original reads the selected RadioButton's custom:splitAppMode CustomData. custom:splitAppMode is kept on` &&
               ` the buttons for fidelity. The onAfterRendering parent-height fix and the device-model onInit setup (device model is global in abap2UI5) are dropped. // NOTE: live-verified 2026-07-27: SplitContainer`.
    lv_text1 = lv_text1 && ` as the root view plus the control_by_id navigation (to/toDetail/toMaster/backDetail/backMaster/setMode) need an in-system check — machine gates only verify view validity, not the runtime navigation` &&
               ` roundtrip. // NOTE: the mode RadioButtonGroup's handler calls oSplitContainer.setMode( ) in the original; SplitContainer.mode is a bindable property, so the port binds it two-way (added attribute, no` &&
               ` structural diff) and the handler only assigns the chosen mode - the prefer-a-bindable-property rule, gated by the linter rule settable-property-via-action. The state then survives a view rebuild` &&
               ` instead of living only in the control. // NOTE: live-verified 2026-08-04 (nightly e2e interaction): the two-way mode binding replaces the setMode( ) action and is not live-verified. The imperative` &&
               ` form it replaces WAS verified: verified in a running system 2026-07-27 - SplitContainer toDetail/toMaster/backDetail/backMaster/setMode navigation works across modes (2026-07-27) - kept as context. A` &&
               ` fresh live run (each radio button switches the split mode and the toast names it) restamps this port to checked.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.SplitContainer`                  name = `SplitContainer`                                class = `z2ui5_cl_dmo_app_096` path = `src/01/b12/z2ui5_cl_dmo_app_096.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.StandardListItem`                name = `StandardListItem`                              class = `z2ui5_cl_dmo_app_212` path = `src/01/b17/z2ui5_cl_dmo_app_212.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` )
      ( module = `sap.m`              control = `sap.m.StandardListItem`                name = `StandardListItemAvatar`                        class = `z2ui5_cl_dmo_app_083` path = `src/01/b10/z2ui5_cl_dmo_app_083.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = `NOTE: the List element binding {/ProductCollection} and the items' index paths ({0/Name}..{3/Name}) are kept 1:1 against the default-model table /T_PRODUCTS (full 123-row mock inlined). // POST-1.71:` &&
                 ` the sap.m.Avatar control (since UI5 1.73) is newer than 1.71 but kept for the 1:1 port on three items. // POST-1.71: the StandardListItem avatar aggregation (since UI5 1.98) is newer than 1.71 but` &&
                 ` kept for the 1:1 port - the app needs a UI5 release >= 1.98 to render it. Aggregation/control-level, invisible to the attribute-scanning property gate.`
        post171 = `the sap.m.Avatar control (since UI5 1.73) is newer than 1.71 but kept for the 1:1 port on three items. // the StandardListItem avatar aggregation (since UI5 1.98) is newer than 1.71 but kept for the` &&
                 ` 1:1 port - the app needs a UI5 release >= 1.98 to render it. Aggregation/control-level, invisible to the attribute-scanning property gate.` )
      ( module = `sap.m`              control = `sap.m.StandardListItem`                name = `StandardListItemDescription`                   class = `z2ui5_cl_dmo_app_202` path = `src/01/b17/z2ui5_cl_dmo_app_202.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.StandardListItem`                name = `StandardListItemInfo`                          class = `z2ui5_cl_dmo_app_208` path = `src/01/b17/z2ui5_cl_dmo_app_208.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: the original binds infoState via the presentation-only formatter '.formatter.status' (maps the already-classified Status Available->Success / Out of Stock->Warning / Discontinued->Error / else` &&
                 ` None to a ValueState). abap2UI5 being a thin frontend, the info state is derived in the backend into the INFOSTATE field and bound directly (infoState="{INFOSTATE}"); same output, no loss. All 123` &&
                 ` mock rows (Name/Status) kept verbatim; the List items sorter:{path:'NAME'} is kept 1:1 as a raw binding-info string.` )
      ( module = `sap.m`              control = `sap.m.StandardListItem`                name = `StandardListItemInfoStateInverted`             class = `z2ui5_cl_dmo_app_204` path = `src/01/b17/z2ui5_cl_dmo_app_204.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = `POST-1.71: sap.m.StandardListItem infoStateInverted (since 1.74) is kept 1:1 from the original view; needs a UI5 release >= 1.74 to render.`
        post171 = `sap.m.StandardListItem infoStateInverted (since 1.74) is kept 1:1 from the original view; needs a UI5 release >= 1.74 to render.` ) ).

    lv_text1 = `NOTE: the sample binds a List to the JSON model /modelData and renders one templated CustomListItem per row. **Rebuilt as that ONE bound template on 2026-08-05** (it used to be 14 unrolled static` &&
               ` items): the rows are bound with client->_bind( val = modeldata omit_initial_paths = ... ), the parameter added upstream for exactly this shape (pr/model-empty-vs-default), so a property a row does` &&
               ` not set stays ABSENT from the model and the StepInput keeps its own default instead of receiving ````. The dropped template property valueState is back as well. The omission is SCOPED to the` &&
               ` numeric/string columns because the two BOOLEAN properties must send their explicit false (abap_false is itself initial, so the blanket flag would have dropped it and the disabled / read-only row` &&
               ` would render enabled) - which is why the port binds enabled/editable as plain {ENABLED}/{EDITABLE} again, with no expression binding and no binding-value deviation left. Rows the sample leaves` &&
               ` untouched send the control default true explicitly. // NOTE: the change toast was switched to a roundtrip-free client-composed toast on 2026-07-22 (control_global MESSAGE_TOAST.show, template ``Value`.
    lv_text1 = lv_text1 && ` changed to '{0}'`` with get_t_arg single-quote escaping; on_event dropped, init-only) - re-verify changing a StepInput toasts "Value changed to '<value>'" with the quotes intact. **e2e-verified` &&
               ` 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): ArrowUp + Enter on the first StepInput fires change and toasts "Value changed to '<value>'" with the quotes intact; the other` &&
               ` StepInputs are the identical wire.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.StepInput`                       name = `StepInput`                                     class = `z2ui5_cl_dmo_app_049` path = `src/01/b02/z2ui5_cl_dmo_app_049.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.40`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Switch`                          name = `Switch`                                        class = `z2ui5_cl_dmo_app_050` path = `src/01/b02/z2ui5_cl_dmo_app_050.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` ) ).

    lv_text1 = `NOTE: addNewButtonPress appends an empty employee row to the bound /T_EMPLOYEES (the addItem+setSelectedItem equivalent for a bound aggregation; the new tab is appended but not auto-selected -` &&
               ` TabContainer.selectedItem is an association a bound-row clone cannot address from the backend, the one residual difference). itemCloseHandler reproduced 1:1 since 2026-07-30: the itemClose wire` &&
               ` carries s_ctrl-check_prevent_default (the original calls oEvent.preventDefault() unconditionally) and transports ${$parameters>/item}.getName() plus the row index via` &&
               ` ${$parameters>/item/oParent}.indexOfItem(${$parameters>/item}) (the dnd-idiom index transport); the backend raises MessageBox.confirm (Do you want to close the tab '<name>'?, onclose CLOSE_DECIDE)` &&
               ` and on OK deletes the row + view_model_update (the bound-aggregation removeItem) and toasts 'Item closed: <name>' (duration 500), on Cancel toasts 'Item close canceled: <name>' - exactly the` &&
               ` original's onClose branches. The pending name/index live in protected state across the confirm round-trip. The earlier static 'Close requested' toast (tab never removable) is gone. // NOTE:`.
    lv_text1 = lv_text1 && ` live-verified 2026-08-04 (nightly e2e interaction): the prevent-default itemClose + MessageBox.confirm + row-delete chain and the index transport via the oParent indexOfItem form are unverified in a` &&
               ` running system; the e2e interaction covers open-confirm-OK-removes end to end in the transpiled harness. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): covered` &&
               ` end to end: close icon -> confirm box with the item name -> OK -> row removed + 'Item closed:' toast (needs the 2026-07-30 Messages.js onclose fix - under the broken wire the OK action never` &&
               ` arrived).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.TabContainer`                    name = `TabContainer`                                  class = `z2ui5_cl_dmo_app_093` path = `src/01/b11/z2ui5_cl_dmo_app_093.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Table`                           name = `TableAlternateRowColors`                       class = `z2ui5_cl_dmo_app_210` path = `src/01/b17/z2ui5_cl_dmo_app_210.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16` ) ).

    lv_text1 = `POST-1.71: Table.autoPopinMode (since 1.76), Table.hiddenInPopin (since 1.77), Table.popinChanged (since 1.77) and Column.importance (since 1.76), the core of the auto-pop-in demo, are kept 1:1; needs` &&
               ` UI5 >= 1.77. // NOTE: onSelectionFinish (setHiddenInPopin(getSelectedKeys())) is reproduced 1:1: the MultiComboBox selectedKeys are two-way bound to t_hidden and the selectionFinish round-trip` &&
               ` forwards them as a JSON Priority array through follow_up_action( cs_event-control_by_id, setHiddenInPopin ), so the matching columns hide while in pop-in. The added selectedKeys binding has no` &&
               ` counterpart in the original (the controller reads getSelectedKeys imperatively). onSliderMoved (byId(idProductsTable).setWidth(value + '%')) is now reproduced 1:1 without a round-trip: the Slider` &&
               ` value is two-way bound to width_pct and the Table gains a width expression binding width={= ${width_pct} + '%' }, so moving the Slider shrinks the table live and drives the auto-pop-in (the added` &&
               ` Table width attribute and the Slider value binding have no counterpart in the original view, where setWidth is imperative; the original Slider liveChange handler is dropped). autoPopinMode +`.
    lv_text1 = lv_text1 && ` Column.importance stay declarative and 1:1; popinChanged still toasts. // NOTE: the original derives the ObjectNumber weight state in its frontend Formatter.js (weightState: KG conversion +` &&
               ` Success/Warning/Error thresholds). That is business logic, so - abap2UI5 being a thin frontend - it is computed in ABAP model_init into a WEIGHT_STATE field and bound state="{WEIGHT_STATE}", not via` &&
               ` a frontend formatter (core:require dropped). Visually 1:1 with the original. // NOTE: onPopinChanged reproduced 1:1 since 2026-07-30: the popinChanged wire is a roundtrip-free client-composed toast` &&
               ` 'Number of hidden pop-ins: {0}' filled by ${$parameters>/hiddenInPopin}.length (the event parameter array's length, exactly the original's aHiddenInPopin.length) - the earlier static 'Pop-in layout` &&
               ` changed' round-trip toast faked the value. The hiddenInPopin event parameter is part of the POST_171-declared popinChanged event (since 1.77). // NOTE: the original's` &&
               ` setHiddenInPopin(oMultiComboBox.getSelectedKeys()) is a binding here: hiddenInPopin is a bindable property and the MultiComboBox's selectedKeys already IS that Priority array, so both bind the same`.
    lv_text1 = lv_text1 && ` field T_HIDDEN and the selectionFinish handler only pushes the model. The JSON array the port used to build by hand for the frontend action is gone (prefer-a-bindable-property rule, linter rule` &&
               ` settable-property-via-action).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Table`                           name = `TableAutoPopin`                                class = `z2ui5_cl_dmo_app_092` path = `src/01/b11/z2ui5_cl_dmo_app_092.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Table.autoPopinMode (since 1.76), Table.hiddenInPopin (since 1.77), Table.popinChanged (since 1.77) and Column.importance (since 1.76), the core of the auto-pop-in demo, are kept 1:1; needs UI5 >=` &&
                 ` 1.77.` ) ).

    lv_text1 = `NOTE: the whole controller is one responsive rule: onBeforeRendering + _orientationHandler + _showMessageStrip hide the MessageStrip on a PHONE in portrait and show it again in landscape (and onExit` &&
               ` detaches the handler). The port replaces all four methods with one expression binding on the shared device model - visible = !${device>/system/phone} || ${device>/orientation/landscape} - which UI5` &&
               ` keeps current on every rotation. No round-trip, no controller; the added ``visible`` attribute is the only difference to the archived Table.view.xml. // NOTE: contextualWidth='Auto' +` &&
               ` popinLayout='GridSmall' + the per-column minScreenWidth/demandPopin are what the sample demonstrates and are passed through 1:1 on both tables, including the original's mixed casing ('phone'/'tablet'` &&
               ` on two columns, 'Phone' on the third). The ResponsiveSplitter/PaneContainer/SplitPane nesting with requiredParentWidth 500 and 400 is 1:1 as well. // NOTE: both tables bind the shared demo mock` &&
               ` products.json /ProductCollection (all 123 rows; Name, SupplierName, Status and Quantity - the four fields the ColumnListItem binds) from ONE inlined table in model_init; the original loads the same`.
    lv_text1 = lv_text1 && ` file once into the view's model and binds it twice, so the two panes stay in sync exactly as before. // NOTE: live-verified on 2026-08-02 (maintainer live check): the splitter re-flow through` &&
               ` contextualWidth works. NOT covered by that check: the phone-portrait branch of the MessageStrip, which needs a real device rotation - kept as the one open leg. // NOTE: live-verified 2026-08-04` &&
               ` (nightly e2e interaction): still unverified: the phone-portrait branch of the MessageStrip expression (!${device>/system/phone} || ${device>/orientation/landscape}) - it needs a real device rotation,` &&
               ` which neither the desktop live check nor the headless harness performs.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Table`                           name = `TableContextualWidthDynamic`                   class = `z2ui5_cl_dmo_app_277` path = `src/01/b15/z2ui5_cl_dmo_app_277.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16`
        checked = `CHECKED (2026-08-02): verified in a running system - human live check 2026-08-02 (maintainer): app started and exercised, no findings.`
        notes = lv_text1 ) ).

    lv_text1 = `POST-1.71: sap.m.Table autoPopinMode (since UI5 1.76) kept 1:1 from the original; needs a UI5 release >= 1.76 to render. // POST-1.71: sap.m.plugins.ColumnResizer (since UI5 1.91) kept 1:1 in the` &&
               ` Table dependents aggregation; needs a UI5 release >= 1.91 to render. The Table fixedLayout='Strict' value is also newer than 1.71 (a value-level extension of the 1.22 property, invisible to the` &&
               ` property gate; the source JSDoc carries no value-level @since) - covered by the same >= 1.91 floor. // NOTE: **e2e-verified 2026-08-01** (scripts/e2e-smoke.mjs interaction, transpiled backend + real` &&
               ` browser): the sorter inside the raw binding-info string really sorts: the first rendered row is '10" Portable DVD player', not the model's first record ('Notebook Basic 15'). Residual (nothing` &&
               ` headless can assert deterministically): the Currency type's locale formatting of Price/CurrencyCode.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Table`                           name = `TableStrictLayout`                             class = `z2ui5_cl_dmo_app_225` path = `src/01/b17/z2ui5_cl_dmo_app_225.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.Table autoPopinMode (since UI5 1.76) kept 1:1 from the original; needs a UI5 release >= 1.76 to render. // sap.m.plugins.ColumnResizer (since UI5 1.91) kept 1:1 in the Table dependents` &&
                 ` aggregation; needs a UI5 release >= 1.91 to render. The Table fixedLayout='Strict' value is also newer than 1.71 (a value-level extension of the 1.22 property, invisible to the property gate; the` &&
                 ` source JSDoc carries no value-level @since) - covered by the same >= 1.91 floor.` ) ).

    lv_text1 = `POST-1.71: The whole column-header menu is newer than the 1.71 floor: sap.m.table.columnmenu.Menu, QuickSort, QuickSortItem and ActionItem are @since 1.110, QuickResize is @since 1.137, and the` &&
               ` sap.m.Column headerMenu association that points at it is @since 1.98.0. The sample's ColumnMenu fragment is nothing but those controls, so a faithful port cannot avoid them - the app needs a UI5` &&
               ` release >= 1.137 for the menu, the rest of the table renders on 1.71. // NOTE: All four controller-loaded fragments (ColumnMenu, SortDialog, GroupDialog, FilterDialog) are declared in the view's` &&
               ` mvc:dependents aggregation and opened 1:1 via follow_up_action( cs_event-control_by_id, <id> open ). The three ViewSettingsDialogs are anonymous in the original (the controller keeps them in a map` &&
               ` keyed by fragment name); the port gives each the id it is opened by - sortDialog, groupDialog, filterDialog. // NOTE: The confirm handlers read the selected ViewSettingsItem CONTROLS` &&
               ` (${$parameters>/sortItem}, ${$parameters>/groupItem}, ${$parameters>/filterItems}) rather than a display string: the frontend marshals each control into its id plus its public properties, so the`.
    lv_text1 = lv_text1 && ` backend gets the real keys. That is the same information the original's mParams.sortItem.getKey() / oItem.getKey() reads. // NOTE: Thin frontend: sorting, filtering and the filter-bar text are` &&
               ` computed in ABAP over the model table instead of through sap.ui.model.Sorter/Filter on the items binding. The filter item keys keep the original's own encoding (WeightMeasure___LE___1000___X - field,` &&
               ` operator, value1, value2 separated by three underscores), which the port splits exactly like the controller's handleFilterDialogConfirm does. The infoToolbar visible flag and the filter label are` &&
               ` bound instead of set imperatively on vsdFilterBar / vsdFilterLabel. // NOTE: Formatter.weightState (parseFloat plus the 0/1000/2000 ValueState thresholds) is computed in ABAP and bound as a finished` &&
               ` value (state="{WEIGHT_STATE}"), the thin-frontend rule and the same treatment as app 009 on this mock. The Currency parts binding on the Price ObjectNumber is kept verbatim as a raw binding-info` &&
               ` string. // NOTE: The QuickSort change wire carries the event's declared key and sortOrder parameters. The first draft used ${$parameters>/item}, which sap.m.table.columnmenu.QuickSort does not`.
    lv_text1 = lv_text1 && ` declare - the view gate's event-parameter check caught it before it could arrive empty at runtime. // IMPROVISED: Grouping loses its group headers. The original's mGroupFunctions build a` &&
               ` sap.ui.model.Sorter group key per row - a plain supplier name, and for Price a bucketed '100 EUR or less' / 'Between 100 and 1000 EUR' / 'More than 1000 EUR' label. abap2UI5 has no client-side` &&
               ` grouping function, so the port sorts the table by the chosen field instead: the rows end up in the same order, but without the grey group header rows. The reset button clears the grouping like the` &&
               ` original's resetGroupDialog. // IMPROVISED: The context-menu ToggleButton reports its state as a toast instead of attaching a sap.m.Menu as the table's contextMenu aggregation. The original's` &&
               ` onToggleContextMenu builds the Menu imperatively in the controller and swaps it in and out; the aggregation itself is not driven by any bindable property, and the sample's menu carries no behaviour` &&
               ` beyond opening. // NOTE: Device.system.desktop adds sapUiSizeCompact to each dialog in the original. The port drops that: abap2UI5 exposes the device data as {device>/system/desktop}, but a style`.
    lv_text1 = lv_text1 && ` class is not a bindable property, and the density is a global app decision rather than a per-dialog one here.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Table`                           name = `TableViewSettingsDialog`                       class = `z2ui5_cl_dmo_app_298` path = `src/01/b24/z2ui5_cl_dmo_app_298.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `The whole column-header menu is newer than the 1.71 floor: sap.m.table.columnmenu.Menu, QuickSort, QuickSortItem and ActionItem are @since 1.110, QuickResize is @since 1.137, and the sap.m.Column` &&
                 ` headerMenu association that points at it is @since 1.98.0. The sample's ColumnMenu fragment is nothing but those controls, so a faithful port cannot avoid them - the app needs a UI5 release >= 1.137` &&
                 ` for the menu, the rest of the table renders on 1.71.` ) ).

    lv_text1 = `NOTE: The original configures a single shared dialog imperatively per button (oButton.data() CustomData ->` &&
               ` setMultiSelect/setDraggable/setResizable/setRememberSelections/setConfirmButtonText/addStyleClass). abap2UI5 binds those SelectDialog properties two-way and each button's handler sets them before` &&
               ` opening (responsivePadding toggles the style class via control_by_id addStyleClass/removeStyleClass). The core:CustomData is kept on the buttons for fidelity; the dialog is declared once in` &&
               ` mvc:dependents and opened via follow_up_action( cs_event-control_by_id, open ). // NOTE: The ObjectNumber weightState is business logic (parseFloat thresholds), so it is computed in ABAP` &&
               ` (WEIGHT_STATE, thin-frontend principle) and bound state='{WEIGHT_STATE}' instead of the frontend Formatter.weightState; core:require is therefore dropped and the Currency binding keeps the full` &&
               ` standard type path 'sap.ui.model.type.Currency' 1:1. The full 123-row /ProductCollection is inlined (ProductPicUrl is not needed — the table cells carry no icon). // NOTE: Search filters the dialog's`.
    lv_text1 = lv_text1 && ` items binding client-side via _event_client( cs_event-binding_call, filter NAME Contains ${$parameters>/value} ). The valueHelpRequest opens a second TableSelectDialog (also in dependents) after` &&
               ` preselecting the row matching the input value. The confirm/valueHelpClose toasts are simplified — selectedContexts / selectedItem are control references not transportable as event args (original` &&
               ` composes the chosen product names / copies the selected title into the input). // NOTE: live-verified 2026-08-04 (nightly e2e interaction): The per-button dialog configuration, the client-side search` &&
               ` filter, multi-select confirm and the value-help selection copy-back need an in-system check; machine gates only verify the views are valid. **e2e-verified 2026-07-30** (transpiled-framework` &&
               ` interaction, scripts/e2e-smoke.mjs): the dialog opens with the full 123-row mock and the client-side Contains search filters to 'Gladiator MX'; multi-select confirm and the value-help copy-back` &&
               ` remain unexercised. // POST-1.71: sap.m.TableSelectDialog.searchPlaceholder (since 1.110) is kept 1:1 on the value-help dialog; needs UI5 >= 1.110.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.TableSelectDialog`               name = `TableSelectDialog`                             class = `z2ui5_cl_dmo_app_104` path = `src/01/b12/z2ui5_cl_dmo_app_104.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.TableSelectDialog.searchPlaceholder (since 1.110) is kept 1:1 on the value-help dialog; needs UI5 >= 1.110.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Text`                            name = `Text`                                          class = `z2ui5_cl_dmo_app_051` path = `src/01/b01/z2ui5_cl_dmo_app_051.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.` )
      ( module = `sap.m`              control = `sap.m.TextArea`                        name = `TextArea`                                      class = `z2ui5_cl_dmo_app_052` path = `src/01/b01/z2ui5_cl_dmo_app_052.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.9.0` ) ).

    lv_text1 = `NOTE: the sample's whole point is the difference between the control's own value and the model property while valueLiveUpdate is off, so the getValue Text must NOT be bound to the same field as the` &&
               ` TextArea. The port keeps them apart the same way: liveChange carries ${$parameters>/value} into the backend, which writes it to the separate field GET_VALUE - the second Text stays bound to the` &&
               ` TextArea's own model field, which only updates when valueLiveUpdate is on (or on blur). // NOTE: behavioural limit of the liveChange round-trip, measured 2026-08-02 in the e2e harness: abap2UI5` &&
               ` serializes round-trips, so keystrokes typed while one is in flight are DROPPED, not queued - typing abc with no delay left GET_VALUE at a (the value of the last COMPLETED round-trip), while the` &&
               ` TextArea itself held abc. The original updates its Text client-side on every keystroke, so under fast typing the port lags and can skip intermediate values; it converges as soon as typing pauses.` &&
               ` Inherent to moving the handler into the backend, not a wiring defect - the e2e interaction therefore types with a delay.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.TextArea`                        name = `TextAreaValueUpdate`                           class = `z2ui5_cl_dmo_app_280` path = `src/01/b15/z2ui5_cl_dmo_app_280.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.9.0`
        checked = `CHECKED (2026-08-02): verified in a running system - human live check 2026-08-02 (maintainer): app started and exercised, no findings. Both legs are additionally e2e-verified (scripts/e2e-smoke.mjs` &&
                 ` interaction, transpiled backend + real browser): with the Switch off the liveChange round-trip fills GET_VALUE while model.getProperty() stays behind, and after flipping it the model follows.`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.TileContent`                     name = `TileContent`                                   class = `z2ui5_cl_dmo_app_078` path = `src/01/b10/z2ui5_cl_dmo_app_078.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34.0` ) ).

    lv_text1 = `NOTE: openTimePicker (byId('HiddenTP').openBy(source.getDomRef())) is the app-016 openBy pattern: the source sId is transported via $event.oSource.sId and replayed as a control_by_id/openBy follow-up` &&
               ` action. // POST-1.71: Button.ariaHasPopup (since 1.84), Link.ariaHasPopup (since 1.86) and TimePicker.hideInput (since 1.97) are kept 1:1; needs a UI5 release providing them. // NOTE: the hidden` &&
               ` TimePicker openBy is wired roundtrip-free via client->_event_client( cs_event-control_by_id, openBy ) on each anchor press ($event.oSource.sId) - the original's byId('HiddenTP').openBy(getDomRef())` &&
               ` 1:1; the change toast is now roundtrip-free too (control_global MESSAGE_TOAST.show), so the app is init-only. // NOTE: the openBy was switched to roundtrip-free _event_client on 2026-07-22 -` &&
               ` re-verify each anchor opens the hidden TimePicker. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the 'Open Time Picker' anchor opens the hidden TimePicker` &&
               ` popover; the remaining anchors are the identical wire. // NOTE: live-verified 2026-08-04 (nightly e2e interaction): the change toast was switched to a roundtrip-free client-composed toast on`.
    lv_text1 = lv_text1 && ` 2026-07-22 (control_global MESSAGE_TOAST.show, template ``Time selected: {0}`` filled by ${$parameters>/value}; on_event dropped, init-only) - re-verify picking a time toasts "Time selected:` &&
               ` <value>".`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.TimePicker`                      name = `TimePickerHidden`                              class = `z2ui5_cl_dmo_app_091` path = `src/01/b11/z2ui5_cl_dmo_app_091.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.32`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Button.ariaHasPopup (since 1.84), Link.ariaHasPopup (since 1.86) and TimePicker.hideInput (since 1.97) are kept 1:1; needs a UI5 release providing them.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.TimePickerSliders`               name = `TimePickerSliders`                             class = `z2ui5_cl_dmo_app_095` path = `src/01/b12/z2ui5_cl_dmo_app_095.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.54`
        notes = `NOTE: The picked time is transported to the backend via a two-way value binding on TimePickerSliders (an extra attribute; the original reads it imperatively with oTP.getValue()). OK composes the` &&
                 ` result text from the current time_value, Cancel restores the pre-open value captured on OPEN_DIALOG (the attachAfterOpen equivalent). // NOTE: The result text uses the static control id 'TPS2'` &&
                 ` because the original's runtime-generated oTP.getId() cannot be reproduced. The cosmetic collapseAll() on the sliders as the dialog closes is dropped (no visible effect on a closing dialog).` )
      ( module = `sap.m`              control = `sap.m.Title`                           name = `TitleLink`                                     class = `z2ui5_cl_dmo_app_079` path = `src/01/b10/z2ui5_cl_dmo_app_079.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.27.0`
        is_post171 = abap_true
        notes = `POST-1.71: the Link nested inside the Title uses the Title content aggregation (since UI5 1.87) - newer than 1.71 but kept for the 1:1 port (the sample's whole point); the app needs a UI5 release >=` &&
                 ` 1.87 to render it. Aggregation-level, invisible to the attribute-scanning property gate.`
        post171 = `the Link nested inside the Title uses the Title content aggregation (since UI5 1.87) - newer than 1.71 but kept for the 1:1 port (the sample's whole point); the app needs a UI5 release >= 1.87 to` &&
                 ` render it. Aggregation-level, invisible to the attribute-scanning property gate.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ToggleButton`                    name = `ToggleButton`                                  class = `z2ui5_cl_dmo_app_080` path = `src/01/b10/z2ui5_cl_dmo_app_080.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: onPress toasts the source control id + Pressed/Unpressed; both arrive via $event.oSource (sId and getPressed()) - the earlier ${$source>/pressed} binding did not resolve at runtime. // NOTE: the` &&
                 ` press toast was switched to a roundtrip-free client-composed toast on 2026-07-22 using the conditional placeholder (control_global MESSAGE_TOAST.show, template ``{0} {1?Pressed:Unpressed}``; on_event` &&
                 ` dropped, init-only) - re-verify pressing a ToggleButton toasts "<id> Pressed" when down and "<id> Unpressed" when up. **e2e-verified 2026-07-30** (transpiled-framework interaction,` &&
                 ` scripts/e2e-smoke.mjs): pressing the 'Pressed' ToggleButton (down -> up) toasts '<id> Unpressed' - the {1?Pressed:Unpressed} conditional placeholder resolves from the toggle state; the other buttons` &&
                 ` are the identical wire.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Tokenizer`                       name = `TokenizerBasic`                                class = `z2ui5_cl_dmo_app_085` path = `src/01/b10/z2ui5_cl_dmo_app_085.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-27): verified in a running system 2026-07-27 - Tokenizer add appends, delete removes by key, texts correct`
        notes = `NOTE: the first Tokenizer's tokens are now model-bound (t_tokens): onAddToken appends the input value, onTokenDelete removes by key (the deleted key arrives via` &&
                 ` $event.getParameter('tokens')[0].getKey(); the delete toast shows the token text looked up by that key, like the original's oToken.getText()); the second, disabled Tokenizer keeps its 3 static` &&
                 ` tokens, so the port shows one bound Token template + 3 static Token vs the original's 3+3. // NOTE: the CheckBox select handler becomes a live two-way selected/editable bind on the first Tokenizer.` &&
                 ` // POST-1.71: tokenDelete (since UI5 1.82) on the first Tokenizer is newer than 1.71 but kept for the 1:1 port (the original wires the same event) - the app needs a UI5 release >= 1.82 to render it.`
        post171 = `tokenDelete (since UI5 1.82) on the first Tokenizer is newer than 1.71 but kept for the 1:1 port (the original wires the same event) - the app needs a UI5 release >= 1.82 to render it.` )
      ( module = `sap.m`              control = `sap.m.Toolbar`                         name = `ToolbarShrinkable`                             class = `z2ui5_cl_dmo_app_053` path = `src/01/b03/z2ui5_cl_dmo_app_053.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16`
        checked = `CHECKED (2026-07-20): verified in a running system - human live check 2026-07-20 following the interaction checklist (all listed checks passed)`
        notes = `NOTE: the sample's controller onSliderLiveChange resizes the toolbars in JS; there is no width in the source XML (the port adds the width attribute, the original wires liveChange instead). Rebuilt as` &&
                 ` a client-side expression binding {= slider + '%' } on each Toolbar width - no event round-trip, resizes instantly like the original; the documented preferred path (CAPABILITIES.md), not a workaround.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Tree`                            name = `Tree`                                          class = `z2ui5_cl_dmo_app_054` path = `src/01/b04/z2ui5_cl_dmo_app_054.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.42`
        checked = `CHECKED (2026-07-19): verified in a running system - human visual pass 2026-07-19 over all apps: the nested-table hierarchy renders as an expandable Tree like the original.` ) ).

    lv_text1 = `NOTE: **Rebuilt on 2026-08-05** - it was a breadth probe with THREE INVENTED rows (Screenshot.png / Notes.txt / Report.doc) and a reduced toolbar. Both rows of the sample's own items.json are there` &&
               ` verbatim now (Business Plan Agenda.doc with its five ObjectMarkers and four ObjectStatuses, Picture of a woman.png with its two), the item template carries the markers/statuses aggregations and` &&
               ` uploadState, the UploadSet its terminationEnabled / maxFileNameLength / maxFileSize / mediaTypes / uploadUrl, and the toolbar its three buttons plus the UploadSetToolbarPlaceholder. The asset URLs` &&
               ` point at the OpenUI5 host per the offline asset rule. The port has no structural difference from the original left, so its breadth-probe structural_diff skip is gone. Upload itself still targets the` &&
               ` abap2UI5 FileUploader path in a live system, and the control stays a decided scope exception (sap.m.upload.UploadSet is deprecated, KEEP 2026-07-30). // POST-1.71: UploadSet.mode (since UI5 1.100)` &&
               ` and UploadSet.afterItemRemoved (since UI5 1.83) kept for the 1:1 port - surfaced when the property gate gained the sap.m/upload sub-package (control-level source scan 2026-07-26). The whole control`.
    lv_text1 = lv_text1 && ` is deprecated out-of-scope debt anyway (pr/scope-since-from-source).`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.upload.UploadSet`                name = `UploadSet`                                     class = `z2ui5_cl_dmo_app_121` path = `src/01/b13/z2ui5_cl_dmo_app_121.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.63`
        is_post171 = abap_true
        is_deprecated = abap_true
        dep_text = `Deprecated since 1.129: replaced by sap.m.plugins.UploadSetwithTable`
        notes = lv_text1
        post171 = `UploadSet.mode (since UI5 1.100) and UploadSet.afterItemRemoved (since UI5 1.83) kept for the 1:1 port - surfaced when the property gate gained the sap.m/upload sub-package (control-level source scan` &&
                 ` 2026-07-26). The whole control is deprecated out-of-scope debt anyway (pr/scope-since-from-source).` ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.URLHelper`                       name = `UrlHelper`                                     class = `z2ui5_cl_dmo_app_084` path = `src/01/b10/z2ui5_cl_dmo_app_084.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.10`
        checked = `CHECKED (2026-07-27): verified in a running system 2026-07-27 - URLHelper tel/sms/email triggers and REDIRECT all fire correctly`
        notes = `NOTE: element binding kept 1:1 - a one-record structure /S_SUPPLIER instead of {/SupplierCollection/0}. // NOTE: URLHelper.triggerTel/triggerSms/triggerEmail/redirect map 1:1 to the URLHELPER frontend` &&
                 ` action (cs_event-urlhelper): TRIGGER_TEL/TRIGGER_SMS take the number as a plain string param, TRIGGER_EMAIL/REDIRECT take a { EMAIL/URL, ... } object-literal t_arg (get_t_arg emits {-prefixed args` &&
                 ` raw as UI5 event-handler object literals). open_new_tab is NOT used - it is same-origin-only (isValidRedirectURL).` ) ).

    lv_text1 = `NOTE: The three controller-loaded fragments (Dialog / DialogPreselected / DialogPreset) are declared in the view's mvc:dependents aggregation and opened 1:1 via follow_up_action(` &&
               ` cs_event-control_by_id, open [pageKey] ) — the whitelisted ViewSettingsDialog open with the optional page key ('filter'). confirm forwards the public filterString event parameter` &&
               ` (${$parameters>/filterString}) and toasts it when non-empty, like the original handleConfirm. // NOTE: The DialogPreset presetFilterItems are declared as three ViewSettingsItem entries (text + key)` &&
               ` instead of the original _presetFiltersInit which adds them imperatively with sap.ui.model.Filter arrays as CustomData. The Filter payload is inert in this sample (no list is bound — confirm only` &&
               ` shows the filterString), so only the three visible preset filter options are reproduced. This adds 3 ViewSettingsItem over the original fragment count.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ViewSettingsDialog`              name = `ViewSettingsDialog`                            class = `z2ui5_cl_dmo_app_098` path = `src/01/b12/z2ui5_cl_dmo_app_098.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The controller-loaded Dialog fragment is declared in the view's mvc:dependents aggregation and opened 1:1 via follow_up_action( cs_event-control_by_id, settingsDialog open ).` &&
               ` confirm/cancel/resetFilters become backend events; confirm forwards the public filterString event parameter (${$parameters>/filterString}) and toasts it together with the slider value, like the` &&
               ` original handleConfirm. // NOTE: The Slider carries a bound value attribute the original does not have: the sample seeds and restores it imperatively (oSlider.setValue in the fragment-load callback,` &&
               ` in handleCancel and in handleResetFilters). A bound ABAP field is the abap2UI5 equivalent of all three, so the initial value 50 comes from model_init and cancel/reset just write the field. // NOTE:` &&
               ` ViewSettingsCustomItem carries bound filterCount and selected attributes the original does not have. The original drives both imperatively (setFilterCount/setSelected in handleSliderChange,` &&
               ` handleCancel and handleResetFilters); both are ordinary bindable properties, so the port binds them and computes the state in ABAP. // NOTE: Thin frontend: the comparisons that decide the filter`.
    lv_text1 = lv_text1 && ` state - new slider value against the last confirmed one (handleSliderChange), and the confirmed value against the reset value 50 (handleCancel) - are computed in ABAP instead of in the controller.` &&
               ` filterResetValue/filterPreviousValue become the constant c_reset_value and the protected previous_value; behaviour is identical.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ViewSettingsDialog`              name = `ViewSettingsDialogCustom`                      class = `z2ui5_cl_dmo_app_295` path = `src/01/b24/z2ui5_cl_dmo_app_295.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The controller-loaded Dialog fragment is declared in the view's mvc:dependents aggregation and opened 1:1 via follow_up_action( cs_event-control_by_id, settingsDialog open ), the equivalent of` &&
               ` the controller's _getDialog().then(oDialog => oDialog.open()). // NOTE: The ViewSettingsDialog carries a bound filterSearchOperator attribute the original does not have. The original calls` &&
               ` setFilterSearchOperator( mLibrary.StringFilterOperator.Contains / AnyWordStartsWith ) imperatively right before opening; it is an ordinary bindable property, so the port binds it and the two buttons` &&
               ` just write the ABAP field. // IMPROVISED: The third button, 'Search Case Sensitive Contains', loses its case sensitivity. The original installs a live JS function through setFilterSearchCallback(` &&
               ` caseSensitiveStringContains ) - a callback the frontend evaluates per keystroke, which no backend payload can carry and which the framework deliberately has no route for (a runtime-compiled JS string` &&
               ` was rejected for security). The port falls back to the closest built-in operator, the case-INSENSITIVE Contains, so the button still filters but matches regardless of case. The other two buttons are`.
    lv_text1 = lv_text1 && ` unaffected.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ViewSettingsDialog`              name = `ViewSettingsDialogCustomFilterDetails`         class = `z2ui5_cl_dmo_app_296` path = `src/01/b24/z2ui5_cl_dmo_app_296.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: All three controller-loaded fragments (Dialog / DialogSingleCustomTab / DialogSingleCustomTabWithDatePicker) are declared in the view's mvc:dependents aggregation and opened 1:1 via` &&
               ` follow_up_action( cs_event-control_by_id, <id> open ). confirm forwards the public filterString event parameter (${$parameters>/filterString}) and toasts it when non-empty, like the original` &&
               ` handleConfirm. // POST-1.71: ViewSettingsDialog.beforeClose is @since 1.132 - newer than the 1.71 floor. It is the event the original's handleBeforeClose hangs on to veto closing while the DatePicker` &&
               ` is invalid, so a faithful port cannot drop it; the app needs a UI5 release >= 1.132 for that third dialog. // NOTE: The beforeClose veto is reproduced with s_ctrl-prevent_default_expr: a client` &&
               ` expression over the bound date_value_state field decides per firing whether the close is cancelled, which is what the original's conditional oEvent.preventDefault() does. The event still reaches the` &&
               ` backend, which adds the 'The entered date is invalid' toast - so the decision travels as data, not as a controller branch. // NOTE: The DatePicker carries bound valueState and valueStateText`.
    lv_text1 = lv_text1 && ` attributes the original does not have, and its change event reports the public valid parameter (${$parameters>/valid}). The original's validateDate sets both imperatively in the controller; both are` &&
               ` bindable properties, so the port computes the state in ABAP (thin frontend) and binds it. The error text is identical. // NOTE: The three fragments each use id='app-settings' for their` &&
               ` ViewSettingsCustomTab, and the first two additionally repeat the whole Settings-tab id set (VSDThemeLabel, VSDThemeButtons, VSDsap_hcb, VSDsap_quartzlight, VSDCompactModeButtons, VSDcompactOn,` &&
               ` VSDcompactOff, VSDRTLButtons, VSDRTLOn, VSDRTLOff). In UI5 those are separate fragment id scopes; abap2UI5 renders all three dialogs into ONE view, where the duplicates would collide. The second and` &&
               ` third dialog therefore carry suffixed ids (app-settings-single, app-settings-datepicker, and the Single suffix on the repeated Settings-tab ids). Only the id VALUES differ - every control and` &&
               ` attribute is the original's. // NOTE: The Settings tab body is written out twice instead of through a helper method, mirroring the original, which also carries one copy per fragment. A`.
    lv_text1 = lv_text1 && ` builder-returning helper would hide the open/shut tree from the static view gates. // IMPROVISED: The custom tabs are inert, exactly as in the original: the SegmentedButtons for Theme, Compact` &&
               ` Content Density and Right To Left Mode carry no handler in the sample either, so nothing is applied when they are pressed. The sample's own style.css (the .vsdSetting / .vsd-dp spacing rules) is not` &&
               ` reproduced - the class attributes stay on the controls, only the stylesheet is missing, so the tab content renders slightly tighter than the original.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.ViewSettingsDialog`              name = `ViewSettingsDialogCustomTabs`                  class = `z2ui5_cl_dmo_app_297` path = `src/01/b24/z2ui5_cl_dmo_app_297.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `ViewSettingsDialog.beforeClose is @since 1.132 - newer than the 1.71 floor. It is the event the original's handleBeforeClose hangs on to veto closing while the DatePicker is invalid, so a faithful` &&
                 ` port cannot drop it; the app needs a UI5 release >= 1.132 for that third dialog.` ) ).

    lv_text1 = `NOTE: The sample's default model is a bare JSON array (oModel.setData([...])), bound as the root ({/} on the suggestionItems / items aggregations) and by absolute index (/9/text, /9/key on the second` &&
               ` form). abap2UI5's single default model is an object, so the ten rows live in the T_ITEMS member: {/} becomes {/T_ITEMS} and /9/text / /9/key become /T_ITEMS/9/TEXT / /T_ITEMS/9/KEY. The last path` &&
               ` segment is identical, which structural-diff matches; same data, renders identically. // NOTE: The original applies an app-authored '.whitespace2Char' formatter on every text/additionalText binding -` &&
               ` it replaces each doubled space with space + U+00A0 (non-breaking space) so consecutive whitespaces stay visible. abap2UI5 is a thin frontend, so this presentation transform is computed once in` &&
               ` model_init (REPLACE ALL OCCURRENCES OF two spaces WITH space + nbsp) and the finished text is bound plainly ({TEXT}, {ADDITIONALTEXT}); the 'formatter' key is dropped from the bindings. Output is` &&
               ` identical.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.WhitespacePattern`               name = `WhitespacePattern`                             class = `z2ui5_cl_dmo_app_185` path = `src/01/b17/z2ui5_cl_dmo_app_185.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        ui5_only = abap_true
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: Step validation (additionalInfoValidation) is reproduced in ABAP: on the ProductName/ProductWeight liveChange (and ProductInfoStep activate) the name-length>=6 / weight-numeric checks set the` &&
               ` two valueStates and the ProductInfoStep validated property, which is bound two-way (step2_validated) instead of the original imperative validateStep/invalidateStep. The other steps keep their literal` &&
               ` validated='true'. // NOTE: The step-1 SegmentedButton gets item keys (Mobile/Desktop/Other) and a two-way selectedKey binding so the chosen product type reaches the model directly; the original reads` &&
               ` evt.getParameters().item.getText() in setProductTypeFromSegmented. selectionChange is still wired. The PricingStep activate/complete handlers (which only toggle the unused navApiEnabled flag) are` &&
               ` wired for fidelity but do nothing. // NOTE: Navigation is 1:1 via follow_up_action( cs_event-control_by_id ): Wizard complete -> NavContainer 'to' the review page; each Edit link -> 'to' the content`.
    lv_text1 = lv_text1 && ` page then Wizard 'goToStep' the target step (whitelisted). Cancel and Submit open a MessageBox (warning/confirm) with YES/NO; on YES the wizard resets via 'to' the content page + 'discardProgress'` &&
               ` ProductTypeStep, matching _handleMessageBoxOpen. // NOTE: live-verified 2026-08-04 (nightly e2e interaction): the cancel leg is closed: **e2e-verified 2026-08-01** (scripts/e2e-smoke.mjs interaction,` &&
               ` transpiled backend + real browser): the first wizard step renders and the footer Cancel really round-trips - message_box_display opens the MessageBox 'Are you sure you want to cancel your report?'` &&
               ` with its YES/NO onclose action. Still needs an in-system check: step validation gating the Next button, the complete/edit navigation, the goToStep scroll and the submit/cancel reset itself.`.
    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.m.Wizard`                          name = `Wizard`                                        class = `z2ui5_cl_dmo_app_101` path = `src/01/b12/z2ui5_cl_dmo_app_101.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.30`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.m`              control = `sap.ui.core.ContainerPadding`          name = `ContainerNoPadding`                            class = `z2ui5_cl_dmo_app_087` path = `src/01/b10/z2ui5_cl_dmo_app_087.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: the /ProductCollectionStats/Counts values are flattened to the default model fields /TOTAL, /OK, /HEAVY, /OVERWEIGHT (verbatim counts).` )
      ( module = `sap.m`              control = `sap.ui.core.StandardMargins`           name = `StandardMarginsAll`                            class = `z2ui5_cl_dmo_app_088` path = `src/01/b11/z2ui5_cl_dmo_app_088.clas.abap`
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
      ( module = `sap.tnt`            control = `sap.f.DynamicPage`                     name = `InfoLabelInDynamicPage`                        class = `z2ui5_cl_dmo_app_143` path = `src/05/b05/z2ui5_cl_dmo_app_143.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.54`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.InfoLabel`                     name = `InfoLabel`                                     class = `z2ui5_cl_dmo_app_113` path = `src/05/b01/z2ui5_cl_dmo_app_113.clas.abap`
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

    lv_text1 = `NOTE: the controller's onPopinLayoutChanged (ComboBox change handler running a PopinLayout switch with a Block default) is expressed as bound properties instead of a round-trip (AGENTS 'prefer a` &&
               ` bindable property', as app 009): the ComboBox's change attribute is dropped, its selectedKey is bound two-way, and the Table gains a popinLayout expression binding that reproduces the switch` &&
               ` including its Block default. // NOTE: the original binds the InfoLabel colorScheme via a frontend formatter (Formatter.availableState: an already-classified Status string mapped to a colorScheme` &&
               ` index 8/3/5/9). abap2UI5 being a thin frontend, that mapping is computed in ABAP model_init into a COLOR_SCHEME field and bound colorScheme="{COLOR_SCHEME}" (with path 'Status'), not via a frontend` &&
               ` formatter. Visually 1:1 with the original. // NOTE: the sample's local mock model/data.json (/ProductCollection, 9 rows) is moved verbatim into ABAP model_init on the one default model; all 9 rows` &&
               ` and all bound columns kept. Width/Depth/Height are TYPE string (display-only values in a text template with variable decimals like 3.1/1.8 - packed with fixed DECIMALS would add trailing zeros). Pure`.
    lv_text1 = lv_text1 && ` prefix-drop, renders identically.`.
    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.InfoLabel`                     name = `InfoLabelInTable`                              class = `z2ui5_cl_dmo_app_192` path = `src/05/b06/z2ui5_cl_dmo_app_192.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.54`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The two toolbar buttons reproduce the original controller behaviour server-side: 'Toggle Collapse/Expand' flips NavigationList.expanded (bound to a boolean model field), 'Show/Hide SubItem 3'` &&
               ` flips subItemThree.visible. The original used byId().setExpanded/setVisible; here the properties are two-way bound and toggled on a backend round-trip. The 'expanded' attribute on NavigationList and` &&
               ` the 'visible' attribute on subItemThree are added to carry these bindings (the original set them imperatively). **e2e-verified 2026-07-31** (scripts/e2e-smoke.mjs interaction, transpiled backend +` &&
               ` real browser): 'Show/Hide SubItem 3' removes exactly one of the two same-named sub items (the bound visible flag flipped on a round-trip) and 'Toggle Collapse/Expand' collapses the NavigationList so` &&
               ` the item texts disappear - both toolbar buttons reproduce the original byId().setVisible/setExpanded server-side.`.
    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.NavigationList`                name = `NavigationList`                                class = `z2ui5_cl_dmo_app_123` path = `src/05/b02/z2ui5_cl_dmo_app_123.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: live-verified 2026-08-04 (nightly e2e interaction): The two buttons reproduce the controller behaviour server-side: 'Toggle Collapse/Expand' flips SideNavigation.expanded (bound to a boolean` &&
               ` model field, initial false as in the original) and 'Show/Hide "Walked"' flips the 'walked' NavigationListItem.visible. The original used byId().setExpanded/setVisible; here the properties are two-way` &&
               ` bound and toggled on a backend round-trip. The 'visible' attribute added to the walked item carries that binding (the original toggled it imperatively). **e2e-verified 2026-07-30**` &&
               ` (transpiled-framework interaction, scripts/e2e-smoke.mjs): the 'Toggle Collapse/Expand' round-trip flips the two-way bound expanded (the sapTntSideNavigationNotExpanded class disappears); the` &&
               ` 'Show/Hide Walked' visible flip is the same two-way idiom but not exercised. // POST-1.71: NavigationListItem.selectable (@since 1.116) is kept 1:1 from the original (selectable=false on the two` &&
               ` 'External Link' fixedItem entries). Newer than UI5 1.71; declared per the property-171 policy. Was previously undeclared because the property gate is blind to sap.tnt (properties.json holds sap.m`.
    lv_text1 = lv_text1 && ` only); found and corrected by the app-172 cold-read probe 2026-07-24. // POST-1.71: sap.tnt.NavigationListGroup (control @since 1.121) is used 1:1 for the 'New', 'Recently used' and 'Restricted'` &&
               ` groups. Newer than UI5 1.71; declared per the property-171 policy (control-level, app 152 Avatar precedent - the gate only checks members), so the app needs UI5 >= 1.121 to render the groups. Found` &&
               ` by the 2026-07-27 review sweep.`.
    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.SideNavigation`                name = `SideNavigation`                                class = `z2ui5_cl_dmo_app_128` path = `src/05/b02/z2ui5_cl_dmo_app_128.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `NavigationListItem.selectable (@since 1.116) is kept 1:1 from the original (selectable=false on the two 'External Link' fixedItem entries). Newer than UI5 1.71; declared per the property-171 policy.` &&
                 ` Was previously undeclared because the property gate is blind to sap.tnt (properties.json holds sap.m only); found and corrected by the app-172 cold-read probe 2026-07-24. //` &&
                 ` sap.tnt.NavigationListGroup (control @since 1.121) is used 1:1 for the 'New', 'Recently used' and 'Restricted' groups. Newer than UI5 1.71; declared per the property-171 policy (control-level, app` &&
                 ` 152 Avatar precedent - the gate only checks members), so the app needs UI5 >= 1.121 to render the groups. Found by the 2026-07-27 review sweep.` ) ).

    lv_text1 = `NOTE: onCollapseExpandPress (byId('sideNavigation').setExpanded(!expanded)) is reproduced by two-way binding SideNavigation.expanded to a boolean model field, seeded false exactly like the original` &&
               ` literal, and flipping it on the TOGGLE_EXPAND round-trip. // NOTE: quickActionPress dialog: the controller-built sap.m.Dialog is expressed as a core:FragmentDefinition shown via` &&
               ` client->popup_display. Its Dialog, Label, Input and Button controls are extra vs the archived V.view.xml, which declares none of them; the two Inputs are two-way bound (create_name/create_icon)` &&
               ` instead of read imperatively via Element.getElementById(...).getValue(). // NOTE: the Create button does sideNavigation.getItem().addItem( new NavigationListItem({ text, expanded: true, icon }) ), so` &&
               ` the main tnt:NavigationList is a BOUND aggregation here (the app-241 pattern): the four static tnt:NavigationListItem entries (Home/Building/Mileage/Transport) collapse into one bound template, so` &&
               ` three NavigationListItem controls are missing vs the original count, and creating appends a row with the same defaults ('New Navigation Item' / sap-icon://building). The rows bind with`.
    lv_text1 = lv_text1 && ` omit_initial_paths for EXPANDED so an item that does not set it keeps the control default. // POST-1.71: NavigationListItem.selectable (@since 1.116) is kept 1:1 (selectable=false on the Quick Create` &&
               ` and External Link fixedItem entries). @since verified in sap.tnt/src/sap/tnt/NavigationListItem.js. // POST-1.71: NavigationListItem.design="Action" and NavigationListItem.ariaHasPopup="Dialog" (both` &&
               ` @since 1.133) are kept 1:1 on the Quick Create item. @since verified in sap.tnt/src/sap/tnt/NavigationListItem.js. // LIVE-TEST: not yet run in a system: the TOGGLE_EXPAND round-trip` &&
               ` (collapse/expand), the quick-create popup round-trip and the Create append (new row shows up in the bound NavigationList with the typed name/icon or the defaults).`.
    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.SideNavigation`                name = `SideNavigationActions`                         class = `z2ui5_cl_dmo_app_299` path = `src/05/b08/z2ui5_cl_dmo_app_299.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `NavigationListItem.selectable (@since 1.116) is kept 1:1 (selectable=false on the Quick Create and External Link fixedItem entries). @since verified in sap.tnt/src/sap/tnt/NavigationListItem.js. //` &&
                 ` NavigationListItem.design="Action" and NavigationListItem.ariaHasPopup="Dialog" (both @since 1.133) are kept 1:1 on the Quick Create item. @since verified in` &&
                 ` sap.tnt/src/sap/tnt/NavigationListItem.js.` ) ).

    lv_text1 = `NOTE: onToggleSideNav does Fragment.load('Popover.fragment.xml') + openBy(the ShellBar menu button). The port rebuilds the fragment 1:1 in popover_sidenav_display and shows it with` &&
               ` client->popover_display( xml, by_id ), anchoring on the menu button id transported as ${$parameters>/button}.getId() in the TOGGLE_SIDE_NAV t_arg. The original's toggle branch (close when already` &&
               ` open) is not reproduced: the backend cannot know whether the popover is still open (the user can dismiss it by clicking outside), so every menuButtonPressed re-opens it. // NOTE: onItemSelect sets` &&
               ` the target page's Text imperatively (oText.setText('Fired event to load page ' + key.replace('page',''))) and calls oNavCon.to(page). The port two-way binds the Text controls instead - the home page` &&
               ` keeps its own field (home_text, seeded with the original lorem-ipsum literal) and the twelve page1..page12 Texts share one field (page_text), which is observationally identical because the` &&
               ` NavContainer shows exactly one page and every page is reached through its own select. Navigation itself is the 1:1 frontend action follow_up_action( control_by_id, 'pageContainer', 'to', <page id> ).`.
    lv_text1 = lv_text1 && ` The added text bindings are extra attributes on the originally empty <Text/> elements. // NOTE: onQuickActionPress builds a sap.m.Dialog imperatively (new Dialog({...}).open()); expressed as a` &&
               ` core:FragmentDefinition shown via client->popup_display. Its Dialog, Text and two Button controls are extra vs the archived V.view.xml/Popover.fragment.xml. The Create button only closes the dialog,` &&
               ` exactly like the original. // POST-1.71: sap.m.Avatar (control @since 1.73) is kept 1:1 in the ShellBar's f:profile aggregation (initials 'SN'). Newer than UI5 1.71 (app 152 precedent, control-level` &&
               ` declaration). // POST-1.71: sap.tnt.NavigationListGroup (control @since 1.121) is used 1:1 for the 'Business Areas for selected user role' group. Newer than UI5 1.71. // POST-1.71:` &&
               ` NavigationListItem.selectable (@since 1.116) is kept 1:1 (selectable=false on Manufacturing management, Employee Services, Create, App Finder and Legal). // POST-1.71:` &&
               ` NavigationListItem.design="Action" and NavigationListItem.ariaHasPopup="Dialog" (both @since 1.133) are kept 1:1 on the Create item; SideNavigation.design="Plain" (@since 1.132) is kept 1:1 on the`.
    lv_text1 = lv_text1 && ` popover's side navigation. // LIVE-TEST: not yet run in a system: the ShellBar menuButtonPressed -> anchored popover round-trip, the itemSelect -> NavContainer 'to' frontend action plus the bound` &&
               ` page text, and the quick-create popup. // NOTE: two URLs are re-hosted per the repository's offline asset/host rule: the ShellBar homeIcon './resources/sap/ui/documentation/sdk/images/logo_sap.png'` &&
               ` is absolutized to https://sdk.openui5.org/resources/sap/ui/documentation/sdk/images/logo_sap.png (app 110 precedent), and the 'App Finder' href https://openui5.hana.ondemand.com/demoapps points at` &&
               ` the commercial SAPUI5 host, so it is served from https://sdk.openui5.org/demoapps instead.`.
    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.SideNavigation`                name = `SideNavigationOverlayMode`                     class = `z2ui5_cl_dmo_app_301` path = `src/05/b08/z2ui5_cl_dmo_app_301.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.34`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.Avatar (control @since 1.73) is kept 1:1 in the ShellBar's f:profile aggregation (initials 'SN'). Newer than UI5 1.71 (app 152 precedent, control-level declaration). //` &&
                 ` sap.tnt.NavigationListGroup (control @since 1.121) is used 1:1 for the 'Business Areas for selected user role' group. Newer than UI5 1.71. // NavigationListItem.selectable (@since 1.116) is kept 1:1` &&
                 ` (selectable=false on Manufacturing management, Employee Services, Create, App Finder and Legal). // NavigationListItem.design="Action" and NavigationListItem.ariaHasPopup="Dialog" (both @since 1.133)` &&
                 ` are kept 1:1 on the Create item; SideNavigation.design="Plain" (@since 1.132) is kept 1:1 on the popover's side navigation.` ) ).

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
               ` NOTE: quickActionPress dialog: reproduced as a core:FragmentDefinition shown via client->popup_display - the controller-built sap.m.Dialog with two Label + Input pairs (Name/Icon, the Inputs two-way` &&
               ` bound to create_name/create_icon) and Create/Cancel Buttons. These Dialog/Label/Input/Button controls are extra vs the original view.xml, which declared none of them. **The Create button now works`.
    lv_text1 = lv_text1 && ` 1:1 (2026-08-05)**: the original does sideNavigation.getItem().addItem( new NavigationListItem({ text, expanded, icon }) ), so the main NavigationList is a BOUND aggregation here (the app-085/203` &&
               ` pattern) and creating appends a row with the same defaults ('New Navigation Item' / sap-icon://building). Consequently the five static tnt:NavigationListItem declarations became one template plus a` &&
               ` nested one for Mileage's children - 4 instead of 9 against the original count - and the rows bind with omit_initial_paths so an item without an icon/href keeps the control default, while SELECTABLE` &&
               ` stays outside that list because the two external links must send their explicit false. The earlier 'dynamic addItem is not expressible' rationale is retired. // NOTE: live-verified 2026-08-04` &&
               ` (nightly e2e interaction): The 2026-07-27 live check predates the 2026-07-30 prevent-default rewire (status reset checked -> generated per the invalidation rule): re-verify that with the checkbox set` &&
               ` a press does NOT change the selection (eBP cancels the default) and still toasts 'Default was prevented:', that with the checkbox clear selection changes normally, and that the PREVENT_TOGGLE redraw`.
    lv_text1 = lv_text1 && ` keeps working (expanded state and checkbox survive it via their two-way bindings). onCollapseExpandPress (expanded two-way + TOGGLE_EXPAND round-trip), the ITEM_PRESS modifier-key transport and the` &&
               ` popup round-trips were live-verified 2026-07-27. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): with the checkbox set, the PREVENT_TOGGLE redraw re-bakes the` &&
               ` wires and pressing 'Building' toasts 'Default was prevented:' - the eBP wire fires and round-trips; the visual no-selection-change and the popup paths remain for the live check.`.
    lv_text2 = `NavigationListItemBase.press event (@since 1.133) is the whole point of this sample; wired 1:1 on every NavigationListItem (press) to a backend ITEM_PRESS event. @since verified in` &&
               ` fork-openui5/src/sap.tnt/src/sap/tnt/NavigationListItemBase.js:74-79. Requires a UI5 release >= 1.133. // The press event parameters ctrlKey/shiftKey/altKey/metaKey (@since 1.137) are transported via` &&
               ` ${$parameters>/ctrlKey} etc. in the ITEM_PRESS t_arg and echoed into the toast, exactly as the original itemPress reads them. @since verified NavigationListItemBase.js:88-109. Requires a UI5 release` &&
               ` >= 1.137 (the property gate is blind to sap.tnt event params). // NavigationListItem.selectable (@since 1.116) is used 1:1 (selectable=false) on Link 1/Link 2, Quick Create and External Link. @since` &&
               ` verified NavigationListItem.js:101-103. // NavigationListItem.design="Action" and NavigationListItem.ariaHasPopup="Dialog" (both @since 1.133.0) are kept 1:1 on the Quick Create item. @since verified` &&
               ` NavigationListItem.js:131-139.`.
    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.SideNavigation`                name = `SideNavigationPressEvent`                      class = `z2ui5_cl_dmo_app_241` path = `src/05/b07/z2ui5_cl_dmo_app_241.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        is_post171 = abap_true
        notes = lv_text1
        post171 = lv_text2 ) ).

    lv_text1 = `POST-1.71: sap.tnt.NavigationListItem.selectable (@since 1.116) is used 1:1 on the unselectable parent items (Building/Mileage/Transport) and the fixed External Link item - it is the whole point of` &&
               ` this sample. Kept per the members-newer-than-1.71 fidelity policy; @since verified by hand against fork-openui5/src/sap.tnt/src/sap/tnt/NavigationListItem.js line 101-103 (property gate is blind to` &&
               ` sap.tnt). Requires a UI5 release >= 1.116 to render. // NOTE: onCollapseExpandPress reproduced server-side: SideNavigation.expanded is two-way bound (initial false as in the original` &&
               ` expanded="false") and flipped on a backend round-trip (TOGGLE_EXPAND) instead of the original imperative byId().setExpanded(!expanded). Same technique as app 128. The literal expanded="false"` &&
               ` becoming a {/EXPANDED} binding needs a live render check. **e2e-verified 2026-07-31** (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): the Toggle Collapse/Expand round-trip` &&
               ` expands the SideNavigation - the sub items 'Office 01'/'Office 02' appear, so the two-way bound expanded flag really flipped in ABAP. // NOTE: onItemSelect reproduced roundtrip-free: the`.
    lv_text1 = lv_text1 && ` SideNavigation itemSelect event fires a client-composed MessageToast (control_global MESSAGE_TOAST/show, template 'Item selected: {0}' filled by the client-resolved ${$parameters>/item}.getText()) -` &&
               ` the 1:1 equivalent of the original MessageToast.show(``Item selected: ${sText}``). Same idiom as app 060; CAPABILITIES marks it expressible, live render/click check pending. **e2e-verified` &&
               ` 2026-07-31** (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): selecting 'Office 01' raises the client-composed 'Item selected: Office 01' toast.`.
    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.SideNavigation`                name = `SideNavigationUnselectableParents`             class = `z2ui5_cl_dmo_app_172` path = `src/05/b06/z2ui5_cl_dmo_app_172.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
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
      ( module = `sap.tnt`            control = `sap.tnt.SideNavigation`                name = `SideNavigationWithTags`                        class = `z2ui5_cl_dmo_app_132` path = `src/05/b03/z2ui5_cl_dmo_app_132.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        is_post171 = abap_true
        notes = lv_text1
        post171 = lv_text2 ) ).

    lv_text1 = `NOTE: onCollapseExpandPress (byId('sideNavigation').setExpanded(!expanded)) is reproduced by two-way binding SideNavigation.expanded to a boolean model field, seeded true exactly like the original` &&
               ` literal, and flipping it on the TOGGLE_EXPAND round-trip. // NOTE: quickActionPress dialog: the controller-built sap.m.Dialog is expressed as a core:FragmentDefinition shown via` &&
               ` client->popup_display. Its Dialog, Label, Input and Button controls are extra vs the archived V.view.xml, which declares none of them; the two Inputs are two-way bound (create_name/create_icon)` &&
               ` instead of read imperatively via Element.getElementById(...).getValue(). // IMPROVISED: the Create button of the quick-create dialog does sideNavigation.getItem().addItem( new NavigationListItem(...)` &&
               ` ) in the original. Here it only closes the dialog: the main tnt:NavigationList mixes tnt:NavigationListItem and tnt:NavigationListGroup children, and abap2UI5 binds an aggregation with ONE template` &&
               ` control, so a bound list (the app-241/299 pattern) cannot reproduce that mixed structure. The 24 static NavigationListItem entries and both NavigationListGroups are kept 1:1 instead - view fidelity`.
    lv_text1 = lv_text1 && ` wins over the append behaviour, which is the loss declared here. // POST-1.71: sap.tnt.NavigationListGroup (control @since 1.121) is used 1:1 for the 'System & Administration Management' and` &&
               ` 'Business operations' groups. Newer than UI5 1.71; the app needs UI5 >= 1.121 to render them. // POST-1.71: NavigationListItem.selectable (@since 1.116) is kept 1:1 (selectable=false on the` &&
               ` training-portal, service-management, financial-reports, CRM, Quick Create and SAP Support entries). // POST-1.71: NavigationListItem.design="Action" and NavigationListItem.ariaHasPopup="Dialog" (both` &&
               ` @since 1.133) are kept 1:1 on the Quick Create item. // LIVE-TEST: not yet run in a system: the TOGGLE_EXPAND round-trip (collapse/expand of the 20rem side navigation) and the quick-create popup` &&
               ` round-trip.`.
    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.SideNavigation`                name = `SideNavigationWrapping`                        class = `z2ui5_cl_dmo_app_300` path = `src/05/b08/z2ui5_cl_dmo_app_300.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.34`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.tnt.NavigationListGroup (control @since 1.121) is used 1:1 for the 'System & Administration Management' and 'Business operations' groups. Newer than UI5 1.71; the app needs UI5 >= 1.121 to render` &&
                 ` them. // NavigationListItem.selectable (@since 1.116) is kept 1:1 (selectable=false on the training-portal, service-management, financial-reports, CRM, Quick Create and SAP Support entries). //` &&
                 ` NavigationListItem.design="Action" and NavigationListItem.ariaHasPopup="Dialog" (both @since 1.133) are kept 1:1 on the Quick Create item.` ) ).

    lv_text1 = `NOTE: the two 'Prоduct Name' menu/select texts contain CYRILLIC SMALL LETTER O (U+043E) in place of the Latin o - reproduced verbatim from the original V.view.xml, which carries the same homoglyph` &&
               ` (upstream defect kept for 1:1 fidelity; do not ASCII-fix it). // NOTE: live-verified 2026-08-04 (nightly e2e interaction): The SAP-logo Image and profile Avatar presses show client-side MessageToasts` &&
               ` ('Logo pressed!' / 'Avatar pressed!'), matching the original onLogoPressed / onAvatarPressed. The original's Device.media handler (which toggles productName/secondTitle/searchField/searchButton` &&
               ` visibility per screen range) is a device-responsive behaviour not reproduced server-side; those controls keep their static initial visibility (searchButton visible='false'). **e2e-verified` &&
               ` 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the logo Image press toasts 'Logo pressed!'; the Avatar press is the identical wire but not exercised, and the Device.media` &&
               ` visibility branch stays out of scope. // NOTE: Both ToolHeaders, all OverflowToolbarLayoutData priorities/groups, the ToolHeaderUtilitySeparator and the OverflowToolbarButtons are reproduced 1:1,`.
    lv_text1 = lv_text1 && ` including the original's Cyrillic-o typo in 'Prоduct Name'. The SAP_Logo.png and Woman_avatar_01.png srcs are the original's host-relative test-resources/sap/tnt/images/ paths rewritten to the` &&
               ` OpenUI5 host https://sdk.openui5.org/test-resources/sap/tnt/images/ per the runtime asset-URL rule (app 152 precedent). // POST-1.71: sap.m.Avatar (control @since 1.73) is used 1:1 as the profile` &&
               ` avatar in both ToolHeaders (src image, displaySize XS, press). Newer than UI5 1.71; declared per the property-171 policy (control-level, app 152 precedent), so the app needs UI5 >= 1.73 to render the` &&
               ` avatars. Found by the 2026-07-27 review sweep.`.
    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.ToolHeader`                    name = `ToolHeader`                                    class = `z2ui5_cl_dmo_app_134` path = `src/05/b04/z2ui5_cl_dmo_app_134.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.Avatar (control @since 1.73) is used 1:1 as the profile avatar in both ToolHeaders (src image, displaySize XS, press). Newer than UI5 1.71; declared per the property-171 policy (control-level,` &&
                 ` app 152 precedent), so the app needs UI5 >= 1.73 to render the avatars. Found by the 2026-07-27 review sweep.` ) ).

    lv_text1 = `NOTE: The three home Buttons reset their sibling IconTabHeader again since 2026-08-05. The original reaches into the DOM (event.oSource.getParent().getDomRef()...) only to FIND that header - each` &&
               ` button knows it statically here - and selectedKey is a BINDABLE property, so the reset is a bound value rather than a frontend action (the prefer-a-bindable-property rule, which the linter enforces):` &&
               ` each header's selectedKey is two-way bound, the press round-trips and the backend writes 'invalidKey' back. The three headers keep that as their seeded value, as in the original view. // POST-1.71:` &&
               ` IconTabFilter interactionMode='SelectLeavesOnly' (property since 1.121) is kept 1:1 on the parent filters of the second ToolHeader's IconTabHeader (iconTabHeaderOneClickArea); requires a UI5 release` &&
               ` >= 1.121. // POST-1.71: IconTabFilter items (the nested sub-filter aggregation, since 1.77 per IconTabFilter.js JSDoc) is kept 1:1 in the second and third ToolHeaders' IconTabHeaders (nested` &&
               ` User/Identity/Monitoring filters); requires a UI5 release >= 1.77. Aggregation-level member, invisible to the property gate (it scans attributes only) - declared by policy, found in review`.
    lv_text1 = lv_text1 && ` 2026-07-27. // NOTE: Fully static view reproduced 1:1: three tnt:ToolHeaders, each with a home Button, an IconTabHeader (mode='Inline', backgroundDesign='Transparent', selectedKey='invalidKey') with` &&
               ` OverflowToolbarLayoutData, search/comment Buttons and a MenuButton with a Menu (Edit/Save). The second/third ToolHeaders use nested IconTabFilter items; no bound data.`.
    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.ToolHeader`                    name = `ToolHeaderIconTabHeader`                       class = `z2ui5_cl_dmo_app_221` path = `src/05/b06/z2ui5_cl_dmo_app_221.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `IconTabFilter interactionMode='SelectLeavesOnly' (property since 1.121) is kept 1:1 on the parent filters of the second ToolHeader's IconTabHeader (iconTabHeaderOneClickArea); requires a UI5 release` &&
                 ` >= 1.121. // IconTabFilter items (the nested sub-filter aggregation, since 1.77 per IconTabFilter.js JSDoc) is kept 1:1 in the second and third ToolHeaders' IconTabHeaders (nested` &&
                 ` User/Identity/Monitoring filters); requires a UI5 release >= 1.77. Aggregation-level member, invisible to the property gate (it scans attributes only) - declared by policy, found in review` &&
                 ` 2026-07-27.` ) ).

    lv_text1 = `NOTE: NavigationListItem.selectable is the expression binding {= ${items}.length > 3} in the original; per the thin-frontend rule that presentation logic is computed in ABAP into a flat 'selectable'` &&
               ` field (children count > 3) and bound directly. **Sidecar corrected 2026-08-05**: the text still described the port as it looked before its rework and claimed the controller handlers were STATIC` &&
               ` toasts - they are not, and have not been for a while. onSideNavButtonPress is the two-way bound ToolPage.sideExpanded (prefer-a-bindable-property); onItemPress carries the item text into a` &&
               ` client-composed toast (${$parameters>/item}.getText(), the app-060/172 idiom); onItemSelect navigates the NavContainer roundtrip-free through control_by_id 'to' with the key resolved on the client;` &&
               ` handleUserNamePress rebuilds the controller's Popover (no header, Bottom, three transparent buttons) and opens it at the pressed button; onQuickActionPress reproduces the design=Action guard and the` &&
               ` Create Item dialog. What remains is the selectable computation above - a bound field instead of the original's expression - which is the thin-frontend rule working. // POST-1.71: Several members`.
    lv_text1 = lv_text1 && ` newer than UI5 1.71 are kept 1:1 from the original. sap.tnt.NavigationListItem: selectable (@since 1.116), design (@since 1.133.0, sap.tnt.NavigationListItemDesign), press (event, @since 1.133 on` &&
               ` NavigationListItemBase), ariaHasPopup (@since 1.133.0). sap.m.Button.ariaHasPopup (@since 1.84) on the header 'Alan Smith' button. Declared per the property-171 policy; the tnt members were` &&
               ` previously mis/under-declared (the earlier note cited only sap.m.Button 1.84 for ariaHasPopup, which is the Button version, not the tnt member's 1.133) because the property gate is blind to sap.tnt -` &&
               ` corrected by the non-sap.m @since audit 2026-07-24. NavigationListItem.expanded is also kept 1:1; its @since reads 1.121 because the property was relocated to the new sap.tnt.NavigationListItemBase` &&
               ` in 1.121 (the property itself predates 1.71), but the property gate resolves the base-class version, so it is declared here for the gate. // NOTE: The full 14-item navigation tree (with its nested` &&
               ` child lists, incl. Root Item 3's 38 children) and the 4-item fixed navigation are inlined from data.json. Where data.json omits a property the UI5 default is seeded explicitly (enabled true, expanded`.
    lv_text1 = lv_text1 && ` false, and on Fixed Item 1-3 the enum fields ariaHasPopup None / design Default - an empty string would throw in validateProperty). The page2 ScrollContainer's multi-paragraph lorem-ipsum filler text` &&
               ` is abbreviated to a short placeholder. // NOTE: Faked-event-value audit fix (2026-07-30): four substituted handlers are now the original behaviours. onItemPress: client-composed toast 'Fired` &&
               ` itemPress, item: {0}' filled by ${$parameters>/item}.getText() (was the static 'Item pressed'). onItemSelect: pageContainer.to(item key page) via roundtrip-free _event_client control_by_id 'to' with` &&
               ` ${$parameters>/item}.getKey() (was a static toast; a key without a matching page logs a NavContainer error client-side exactly like the original's createId miss). onSideNavButtonPress:` &&
               ` ToolPage.sideExpanded is two-way bound (added attr, declared) and flipped on the SIDE_TOGGLE round-trip; the button's tooltip is bound (added attr, declared) and set from the PRE-toggle state` &&
               ` ('Large/Small Size Navigation') exactly like _setToggleButtonTooltip; init seeds the desktop default 'Small Size Navigation' (the Device.system.desktop branch resolved statically).`.
    lv_text1 = lv_text1 && ` handleUserNamePress: the controller-built Popover (showHeader false, Bottom, Feedback/Help/Logout transparent buttons, sapMOTAPopover sapTntToolHeaderPopover classes) is rebuilt 1:1 via` &&
               ` popover_display by_id = $event.oSource.sId - Popover + 3 Buttons are extra controls vs the original view.xml (controller-built). onQuickActionPress: the design guard runs server-side on the` &&
               ` transported ${$source>/design} and a design=Action item opens the 'Create Item' Message Dialog (Text 'Create New Navigation List Item', Create/Cancel closing via popup_close) via popup_display -` &&
               ` Dialog/Text/Button extra controls declared here too. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): Child Item 1 press toasts 'Fired itemPress, item: Child` &&
               ` Item 1' and the Alan Smith press opens the Feedback/Help/Logout popover; the side toggle, key navigation target and Quick Create dialog remain unexercised.`.
    lv_text2 = `Several members newer than UI5 1.71 are kept 1:1 from the original. sap.tnt.NavigationListItem: selectable (@since 1.116), design (@since 1.133.0, sap.tnt.NavigationListItemDesign), press (event,` &&
               ` @since 1.133 on NavigationListItemBase), ariaHasPopup (@since 1.133.0). sap.m.Button.ariaHasPopup (@since 1.84) on the header 'Alan Smith' button. Declared per the property-171 policy; the tnt` &&
               ` members were previously mis/under-declared (the earlier note cited only sap.m.Button 1.84 for ariaHasPopup, which is the Button version, not the tnt member's 1.133) because the property gate is blind` &&
               ` to sap.tnt - corrected by the non-sap.m @since audit 2026-07-24. NavigationListItem.expanded is also kept 1:1; its @since reads 1.121 because the property was relocated to the new` &&
               ` sap.tnt.NavigationListItemBase in 1.121 (the property itself predates 1.71), but the property gate resolves the base-class version, so it is declared here for the gate.`.
    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.ToolPage`                      name = `ToolPage`                                      class = `z2ui5_cl_dmo_app_167` path = `src/05/b06/z2ui5_cl_dmo_app_167.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        is_post171 = abap_true
        notes = lv_text1
        post171 = lv_text2 ) ).

    lv_text1 = `NOTE: onItemSelect does byId('pageContainer').to(createId(item.getKey())); the port transports the key with ${$parameters>/item}.getKey() and calls the same method through follow_up_action(` &&
               ` control_by_id, 'pageContainer', 'to', <key> ) - the NavContainer has no bindable current-page property. // IMPROVISED: _handleMediaChange is dropped. The controller attaches a sap.ui.Device.media` &&
               ` handler and, per StdExt range (LargeDesktop/Desktop/Tablet/Phone), toggles the visibility of productName/secondTitle/searchField/searchButton and shows a MessageToast naming the range. abap2UI5 does` &&
               ` serve the device> model, but it publishes the media range on the Std set only ({device>/media/range} = Phone/Tablet/Desktop), which cannot tell StdExt's LargeDesktop from Desktop - the very` &&
               ` distinction two of the four branches turn on - and a resize does not round-trip, so the range toasts have no equivalent either. The four controls therefore keep the visibility the view declares` &&
               ` (searchButton visible=false, the rest visible) and no range toast is shown. // POST-1.71: sap.tnt.ToolPage aggregation subHeader (@since 1.93) carries the horizontal IconTabHeader navigation - it is`.
    lv_text1 = lv_text1 && ` the whole point of this sample and is kept 1:1. Newer than UI5 1.71. // POST-1.71: IconTabFilter.interactionMode="SelectLeavesOnly" (@since 1.121) is kept 1:1 on the top-level filter template, and` &&
               ` sap.m.Avatar (control @since 1.73) is kept 1:1 as the profile avatar of the ToolHeader. Both newer than UI5 1.71. // NOTE: the profile Avatar src 'test-resources/sap/tnt/images/Woman_avatar_01.png'` &&
               ` is absolutized to the OpenUI5 host (https://sdk.openui5.org/test-resources/sap/tnt/images/Woman_avatar_01.png) per the repository asset-URL rule; the original uses the relative path. // LIVE-TEST:` &&
               ` not yet run in a system: the IconTabHeader select -> NavContainer 'to' frontend action and the two-way bound selectedKey.`.
    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.ToolPage`                      name = `ToolPageHorizontalNavigation`                  class = `z2ui5_cl_dmo_app_303` path = `src/05/b08/z2ui5_cl_dmo_app_303.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.34`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.tnt.ToolPage aggregation subHeader (@since 1.93) carries the horizontal IconTabHeader navigation - it is the whole point of this sample and is kept 1:1. Newer than UI5 1.71. //` &&
                 ` IconTabFilter.interactionMode="SelectLeavesOnly" (@since 1.121) is kept 1:1 on the top-level filter template, and sap.m.Avatar (control @since 1.73) is kept 1:1 as the profile avatar of the` &&
                 ` ToolHeader. Both newer than UI5 1.71.` ) ).

    lv_text1 = `NOTE: onItemSelect does byId('pageContainer').to(createId(item.getKey())); the port transports the key with ${$parameters>/item}.getKey() and calls the same method through follow_up_action(` &&
               ` control_by_id, 'pageContainer', 'to', <key> ) - the NavContainer has no bindable current-page property. The IconTabHeader and the SideNavigation share the one two-way bound selectedKey, exactly like` &&
               ` the original's {/selectedKey}. // NOTE: onSideNavButtonPress sets ToolPage.sideExpanded imperatively; the property is bindable, so the port two-way binds it (sideExpanded, an attribute the original` &&
               ` view does not declare) and flips it on the SIDE_NAV_TOGGLE round-trip. _setToggleButtonTooltip is reproduced the same way: the toggle Button's tooltip is bound and updated from the pre-toggle state,` &&
               ` seeded at init from !Device.system.desktop via the device data the framework mirrors server-side (client->get( )-s_device-system). // NOTE: the device> named model bindings visible="{=` &&
               ` ${device>/system/phone}}" (toggle Button, side SideNavigation) and visible="{=! ${device>/system/phone}}" (subHeader ToolHeader) are kept 1:1 - abap2UI5 serves the device> model on every view slot`.
    lv_text1 = lv_text1 && ` (CAPABILITIES.md), so the original's phone branch stays a branch. // IMPROVISED: _handleMediaChange is dropped. The controller attaches a sap.ui.Device.media handler and, per StdExt range` &&
               ` (LargeDesktop/Desktop/Tablet/Phone), toggles the visibility of productName/secondTitle/searchField/searchButton and shows a MessageToast naming the range. The device> model publishes the media range` &&
               ` on the Std set only ({device>/media/range} = Phone/Tablet/Desktop), which cannot tell StdExt's LargeDesktop from Desktop - the distinction two of the four branches turn on - and a resize does not` &&
               ` round-trip, so the range toasts have no equivalent either. The four controls keep the visibility the view declares (searchButton visible=false, the rest visible). // POST-1.71: sap.tnt.ToolPage` &&
               ` aggregation subHeader (@since 1.93) carries the horizontal IconTabHeader navigation and is kept 1:1; IconTabFilter.interactionMode="SelectLeavesOnly" (@since 1.121) is kept 1:1 on the top-level` &&
               ` filter template; sap.m.Avatar (control @since 1.73) is kept 1:1 as the ToolHeader profile avatar. All newer than UI5 1.71. // NOTE: the profile Avatar src`.
    lv_text1 = lv_text1 && ` 'test-resources/sap/tnt/images/Woman_avatar_01.png' is absolutized to the OpenUI5 host (https://sdk.openui5.org/test-resources/sap/tnt/images/Woman_avatar_01.png) per the repository asset-URL rule;` &&
               ` the original uses the relative path. The ENABLED/EXPANDED fields the templates bind are absent from model/data.json, so every row carries the UI5 property default (true) explicitly - a flat ABAP row` &&
               ` would otherwise serialize them as empty and override that default. // LIVE-TEST: not yet run in a system: the IconTabHeader / SideNavigation select -> NavContainer 'to' frontend action, the two-way` &&
               ` bound selectedKey and the SIDE_NAV_TOGGLE round-trip (sideExpanded plus the tooltip flip).`.
    result = VALUE #( BASE result
      ( module = `sap.tnt`            control = `sap.tnt.ToolPage`                      name = `ToolPageNavigation`                            class = `z2ui5_cl_dmo_app_302` path = `src/05/b08/z2ui5_cl_dmo_app_302.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.34`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.tnt.ToolPage aggregation subHeader (@since 1.93) carries the horizontal IconTabHeader navigation and is kept 1:1; IconTabFilter.interactionMode="SelectLeavesOnly" (@since 1.121) is kept 1:1 on the` &&
                 ` top-level filter template; sap.m.Avatar (control @since 1.73) is kept 1:1 as the ToolHeader profile avatar. All newer than UI5 1.71.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.codeeditor`  control = `sap.ui.codeeditor.CodeEditor`          name = `CodeEditor`                                    class = `z2ui5_cl_dmo_app_114` path = `src/02/b01/z2ui5_cl_dmo_app_114.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.46`
        notes = `NOTE: Breadth-probe: the ACE-based sap.ui.codeeditor CodeEditor (a wrapped third-party editor). **Both findings of the 2026-07-27 review are fixed (2026-08-05)**: the value carries all TWELVE language` &&
                 ` entries of the original verbatim (it had been shortened to four, against the verbatim-data rule), and the brace escaping is right. The original's own view.xml writes value='\{…' - the backslash has` &&
                 ` to SURVIVE into the serialized attribute or the XMLView parser reads the JSON braces as a binding - so the braces come from ``backtick`` literals (taken verbatim) while the body uses |…| templates` &&
                 ` for the real newlines; inside a template \{ would collapse to a bare brace. That distinction is now a linter rule of its own (escaped-brace-in-backtick, the mirror of collapsed-brace-in-style).` ) ).

    lv_text1 = `NOTE: The original's onSelectTab swaps the CodeEditor value per selected key imperatively (A -> example2, B -> example1, any other key -> setValue() i.e. empty) and its onInit seeds the hint '//` &&
               ` select tabs to see value of CodeEditor changing'. Rebuilt on the client with no round-trip: selectedKey is two-way bound to selected_key (seeded with the original's literal 'invalidKey') and the` &&
               ` CodeEditor carries a value expression binding that is the same switch - selected_key === 'A' ? code_a : (selected_key === 'B' ? code_b : code_init). Two consequences for the view: the select` &&
               ` attribute is dropped (it was wired to a SELECT_TAB backend event no branch of this class dispatched - a dead wire, pattern-lint dead-event-wire), and a value attribute is added to ce:CodeEditor,` &&
               ` which the original XML does not carry because its controller sets the value. The original's unreachable default branch (a key that is neither A nor B can only be the initial 'invalidKey') therefore` &&
               ` shows the init hint rather than an empty editor; the two example strings are inlined verbatim, including the original's own A/B swap.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.codeeditor`  control = `sap.ui.codeeditor.CodeEditor`          name = `CodeEditorIconTabHeader`                       class = `z2ui5_cl_dmo_app_150` path = `src/02/b08/z2ui5_cl_dmo_app_150.clas.abap`
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
      ( module = `sap.ui.core`        control = `sap.ui.core.BusyIndicator`             name = `BusyIndicator`                                 class = `z2ui5_cl_dmo_app_147` path = `src/02/b07/z2ui5_cl_dmo_app_147.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The three core:CommandExecution controls (CE_SAVE, CE_DELETE in the Page dependents, CE_SAVE_POPOVER in the popoverCommand dependents) are DROPPED as controls - abap2UI5 renders no` &&
               ` CommandExecution element. Their behaviour IS reproduced since 2026-07-30: the manifest shortcuts Save=Ctrl+S / Delete=Ctrl+D are registered on init via cs_event-keyboard_shortcut (follow_up_action,` &&
               ` combo -> named backend event), and every command-triggering button (press='cmd:Save' / press='cmd:Delete') fires the same backend SAVE/DELETE/PSAVE events, so shortcut and button share one command` &&
               ` path like the original command bus; the backend gates each command on its enabled/visible flags, so a disabled command's button press or shortcut does nothing, as with a disabled CommandExecution.` &&
               ` The last residual closed 2026-08-06: the shortcut registry used to be document-GLOBAL, so the original's popover-local command scope (CE_SAVE_POPOVER shadowing CE_SAVE for the same Save command while` &&
               ` the popover is open) could not be expressed - Ctrl+S always hit the page-level command and its flags. cs_event-keyboard_shortcut now takes an optional third t_arg scoping the registration`.
    lv_text1 = lv_text1 && ` (implemented upstream, pr/keyboard-shortcut-scope). The scope here is the CONTROL id: this Popover is declared in the view's dependents and opened with control_by_id openBy, so it never enters the` &&
               ` framework's popover SLOT - the slot-only form of the request would never have fired, which the e2e interaction found immediately and the upstream change then covered. Ctrl+S is therefore registered` &&
               ` twice - unscoped -> SAVE, and scoped to cs_view-popover -> PSAVE - so the popover's own enabled/visible flags gate the command exactly while it is open, and the page-level one applies again once it` &&
               ` closes. The three CommandExecution CONTROLS themselves stay dropped (abap2UI5 renders no such element); what they DO is now fully reproduced. **e2e-verified 2026-08-06** (scripts/e2e-smoke.mjs` &&
               ` interaction, transpiled backend + real browser): with the popover's own Save switched off and the popover open, Ctrl+S goes silent, while the page-level command is still enabled and fires with the` &&
               ` popover closed. // NOTE: The $cmd> command model bindings enabled='{$cmd>Save/enabled}' / enabled='{$cmd>Delete/enabled}' on the popover footer buttons have no command model to bind to`.
    lv_text1 = lv_text1 && ` (CommandExecution dropped), so they are folded to default-model booleans: the popover buttons bind enabled to {/SAVE_ENABLED}/{/DELETE_ENABLED} (page popover) and {/PSAVE_ENABLED}/{/DELETE_ENABLED}` &&
               ` (command popover). Correspondingly the controller's onToggleSave/onToggleDelete/onTogglePopoverSave (byId('CE_SAVE').setEnabled(state)) and the *Visibility variants (setVisible) are reproduced as` &&
               ` two-way bindings: each Switch state is bound two-way to the matching boolean and the popover buttons additionally bind visible to {/SAVE_VISIBLE}/{/DELETE_VISIBLE}/{/PSAVE_VISIBLE}, so the switches` &&
               ` drive the command-buttons client-side with no round-trip. Consequently the Switch change attributes (change='.onToggleSave' etc., 6 of them) are DROPPED and replaced by the two-way state binding; the` &&
               ` enabled binding value differs from the original $cmd> path. The flags travel with the next event's two-way model update, which is how the server-side command gating reads the current switch state. //`.
    lv_text1 = lv_text1 && ` NOTE: The manifest-declared viewModel named JSON model (bindings {viewModel>/value}, {viewModel>/countries}, {viewModel>/selected}, {viewModel>key}, {viewModel>text}) is folded onto the one default` &&
               ` model as value/t_countries/selected with the same leaf names and the controller's addData seed values (HelloWorld!, DZ Algeria / AR Argentina) - a pure prefix-drop, renders identically,` &&
               ` structural-diff 0 diffs. // POST-1.71: sap.m.Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the two Open-Popover buttons carry ariaHasPopup='Dialog' as in the` &&
               ` original; the app needs a UI5 release >= 1.84 to render it. // NOTE: live-verified 2026-08-04 (nightly e2e interaction): unverified in a running system: (a) the two Open-Popover buttons open the` &&
               ` popover anchored to the button via control_by_id openBy ($event.oSource.sId); (b) the Ctrl+S / Ctrl+D keyboard_shortcut registrations firing the backend SAVE/DELETE round-trips and their` &&
               ` enabled/visible server-side gating; (c) the switch-driven two-way enabled/visible of the popover buttons. The e2e interaction (keyboard Ctrl+S -> save toast) covers (b) for the page-level Save.`.
    lv_text1 = lv_text1 && ` **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): Ctrl+S fires the SAVE round-trip and toasts 'CTRL+S: save triggered on controller'.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.core.CommandExecution`          name = `Commands`                                      class = `z2ui5_cl_dmo_app_232` path = `src/02/b10/z2ui5_cl_dmo_app_232.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.70`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the two Open-Popover buttons carry ariaHasPopup='Dialog' as in the original; the app needs a UI5 release >=` &&
                 ` 1.84 to render it.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.core.Control`                   name = `ControlBusyIndicator`                          class = `z2ui5_cl_dmo_app_130` path = `src/02/b03/z2ui5_cl_dmo_app_130.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: The 'Toggle Busy State' button flips a boolean model field bound to Panel1.busy and the Icon.busy (both added to carry the binding; the original set busy imperatively via byId().setBusy). The` &&
                 ` original set both busy=true then cleared them after a 5s setTimeout; the client-side auto-reset is simplified to a server-side toggle. **e2e-verified 2026-07-30** (transpiled-framework interaction,` &&
                 ` scripts/e2e-smoke.mjs): the toggle round-trip turns the bound controls busy (sapUiLocalBusy present after the click).` ) ).

    lv_text1 = `NOTE: The sample's own idiom is sap.ui.core.Control's fieldGroupIds plus the SimpleForm's validateFieldGroup event, both passed through 1:1: every Input/Select/ComboBox keeps its fieldGroupIds` &&
               ` ('Billing Information' / 'Discount Code' / 'Credit Card' / 'Online') and the form's validateFieldGroup is wired to a backend event carrying ${$parameters>/fieldGroupIds}. The parameter reaches the` &&
               ` backend as the JSON array (["Billing Information"], measured 2026-08-01), so the arg indexes it - ${$parameters>/fieldGroupIds}[0], literally the original's aFieldGroup[0] - and the ABAP CASE is the` &&
               ` controller's mMessageMapping table (group -> strip id + type). // NOTE: The controller sets three properties per MessageStrip imperatively (byId(id).setType(t).setText(s).setVisible(true)); the port` &&
               ` binds that triple (type/text/visible) per strip instead, so the round-trip that classifies the group also updates the strip. onMsgStripClose (oEvt.getSource().setVisible(false)) becomes one close` &&
               ` event per strip - each target is known statically, so no source lookup is needed. // NOTE: onReset does getModel().setData({}) - reproduced by CLEARing the fourteen bound field values.`.
    lv_text1 = lv_text1 && ` onAccept/onCancel/onReset all call hideMessages() first, kept as a helper method. The four MessageToast texts are passed through verbatim ('Validation of field group '<g>' triggered.', 'Accept` &&
               ` triggered', 'Cancel triggered', 'Reset triggered'); the original's duration:500 is dropped because abap2UI5's message_toast_display has no duration parameter. // NOTE: The original controller loads` &&
               ` SampleData.json and element-binds the whole model (bindElement('/')), which makes its {BillingName} & co relative. The port seeds the same fields at the model root and binds them ABSOLUTELY` &&
               ` (client->_bind) - a relative path on a control with no binding context resolves against nothing (AGENTS 5, the class fixed corpus-wide 2026-08-01). SampleData.json's single value (Email) is bound by` &&
               ` no control in the view, so every input starts empty exactly as in the original. // NOTE: live-verified on 2026-08-02 (maintainer live check): legs (c) and (d) too - each strip closes only itself, and` &&
               ` Submit/Cancel/Reset behave as the original.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.core.Control`                   name = `FieldGroup`                                    class = `z2ui5_cl_dmo_app_272` path = `src/02/b15/z2ui5_cl_dmo_app_272.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        checked = `CHECKED (2026-08-02): verified in a running system - human live check 2026-08-02 (maintainer): app started and exercised, no findings.`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.core.HTML`                      name = `Html`                                          class = `z2ui5_cl_dmo_app_120` path = `src/02/b01/z2ui5_cl_dmo_app_120.clas.abap`
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
      ( module = `sap.ui.core`        control = `sap.ui.core.hyphenation.Hyphenation`   name = `HyphenationAPI`                                class = `z2ui5_cl_dmo_app_146` path = `src/02/b07/z2ui5_cl_dmo_app_146.clas.abap`
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
      ( module = `sap.ui.core`        control = `sap.ui.core.Icon`                      name = `Icon`                                          class = `z2ui5_cl_dmo_app_122` path = `src/02/b02/z2ui5_cl_dmo_app_122.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.11.1`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.core.InvisibleMessage`          name = `InvisibleMessage`                              class = `z2ui5_cl_dmo_app_141` path = `src/02/b05/z2ui5_cl_dmo_app_141.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.78`
        since_post171 = abap_true
        is_post171 = abap_true
        notes = `NOTE: The four buttons announce the pressed button's type+text to the sap.ui.core.InvisibleMessage a11y service and echo it into the status Text; here a press updates the bound status Text with a` &&
                 ` generic confirmation (the a11y live-region announce and the per-button identity are not reproduced server-side). The original's 'Infromation' button-text typo is kept 1:1. **e2e-verified 2026-08-01**` &&
                 ` (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): pressing a button really round-trips and the bound status Text shows 'A new message was sent to the invisible messaging` &&
                 ` service.'. What stays unverifiable by machine is the announcement itself - a live region has no assertable rendering.` )
      ( module = `sap.ui.core`        control = `sap.ui.core.InvisibleText`             name = `InvisibleText`                                 class = `z2ui5_cl_dmo_app_127` path = `src/02/b02/z2ui5_cl_dmo_app_127.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.27.0`
        notes = `NOTE: onPress toasts evt.getSource().getId() + ' Pressed'. All twelve presses reproduce that client-side and roundtrip-free (control_global MESSAGE_TOAST.show) with the template '{0} Pressed' filled` &&
                 ` by $event.oSource.sId - the documented transport for the pressed control's runtime id. Until 2026-07-28 the port toasted a bare 'Pressed' on the rationale that the generated id is 'not reproducible` &&
                 ` statically', which was the wrong conclusion: the id does not have to be reproduced, it is read off the event on the client. The id string itself is a UI5 runtime value and will differ from the` &&
                 ` original sample's (the view prefix differs), exactly as it differs between two runs of the original.` ) ).

    lv_text1 = `IMPROVISED: the model is resolved statically. The original controller builds it in the browser: _fetchClasses walks document.styleSheets and collects every cssRule whose selectorText contains` &&
               ` sapTheme, and it re-runs on every Theming.attachApplied. Neither is reachable from ABAP (no DOM, no stylesheet), so the 26 rows are seeded in model_init from the OpenUI5 base theme source` &&
               ` themes/base/parameterClasses.less - same classes, same declaration blocks, but they no longer follow a theme switch at runtime. The two font rows carry the CSS custom property form` &&
               ` (var(--sapFontSize)) where the less source uses the @sapUiFontSize variable, which only exists after theme compilation. // NOTE: the original's per-row border flag plus its onAfterRendering DOM patch` &&
               ` (querySelectorAll('.sampling')[i].style.borderStyle = 'solid') become the computed model column BORDERSTYLE, bound into the core:HTML div's style attribute - the same visible result without touching` &&
               ` the DOM from the frontend. The original's companion elem.style.borderWidth = '1xp' is an upstream typo (no such CSS unit, the browser drops it), so it is not reproduced; the solid border renders at`.
    lv_text1 = lv_text1 && ` the CSS default width in both. // NOTE: the core:HTML content keeps the original's {styleClass} binding as a REAL binding ({STYLECLASS} on the ABAP field), so its braces stay unescaped - the opposite` &&
               ` of the literal-CSS case (app 028), where braces inside a core:HTML content must be escaped. The markup is written decoded (<div ...>) because the builder re-escapes it on stringify. // NOTE: the` &&
               ` third cell's empty class="" attribute of the original Text is dropped - an empty class list is a no-op and the builder writes no attribute for an empty value.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.core.theming`                   name = `ThemeCustomClasses`                            class = `z2ui5_cl_dmo_app_283` path = `src/02/b16/z2ui5_cl_dmo_app_283.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.core.theming.Parameters`        name = `BasicThemeParameters`                          class = `z2ui5_cl_dmo_app_131` path = `src/02/b03/z2ui5_cl_dmo_app_131.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: The sample itself is just a MessageStrip + Link pointing at the Theme Parameter Toolbox (the real demo content lives in that external tool); reproduced 1:1. The Link href is the original's` &&
                 ` host-relative 'test-resources/sap/m/demokit/theming/webapp/index.html' rewritten to the OpenUI5 host https://sdk.openui5.org/test-resources/sap/m/demokit/theming/webapp/index.html per the runtime` &&
                 ` asset-URL rule (an abap2UI5 system does not serve the demokit path; app 152 precedent).` ) ).

    lv_text1 = `POST-1.71: The sample's whole point is the binding-info parameter 'boundFilters' - filter values that are binding expressions, so the aggregation re-filters whenever a value changes through data` &&
               ` binding. It is 'Supported since 1.146.0' (source: fork-openui5/src/sap.ui.core/src/sap/ui/base/ManagedObject.js:3711, the sample's manifest declares minUI5Version 1.146.0) and is passed through 1:1` &&
               ` in the rows binding-info string. A binding-info parameter is invisible to the property gate (it is not a control member), so this is a by-policy declaration; the app needs a UI5 release >= 1.146. //` &&
               ` NOTE: Named-model fold: the controller registers two JSONModels, 'filter' (departmentPrefix / locationPrefix / firstName / lastName, all undefined initially) and 'ui' (showOrganizational: true).` &&
               ` abap2UI5 serves one default model, so both fold onto the default-model root with the same leaf names ({filter>/departmentPrefix} -> {/DEPARTMENTPREFIX}, {ui>/showOrganizational} ->` &&
               ` {/SHOWORGANIZATIONAL}) - same data, same leaves, renders identically, so NOTE and not IMPROVISED (AGENTS §5 settled policy 2026-07-24). The Inputs keep their odata String type 1:1 (core:require`.
    lv_text1 = lv_text1 && ` StringType), which maps empty input to null. // NOTE: onToggleFilters flips ui>/showOrganizational and applies the other filter pair with oListBinding.filter(aFilters, FilterType.ApplicationBound).` &&
               ` abap2UI5 bakes binding info at render time, so the TOGGLE_FILTERS round-trip flips the bound flag and redraws the view with the other boundFilters list in the rows binding (app 241 precedent, 'the` &&
               ` flag is baked into the handler at render time'). Same observable behaviour - the visible Inputs switch via the bound visible expressions and the table re-filters on the other pair - through a redraw` &&
               ` instead of an imperative filter() call; the entered prefixes survive because they are two-way bound. The controller's aOrgFilters order (department, location) is the view's boundFilters order` &&
               ` reversed (location, department); the port keeps the view's order, which is semantically identical (AND-combined). // NOTE: Unverified in a running system: that the bound filter values re-filter the` &&
               ` sap.ui.table rows as the user types (boundFilters + odata String type mapping empty to null, i.e. an empty prefix must drop the filter rather than match nothing), and that the TOGGLE_FILTERS redraw`.
    lv_text1 = lv_text1 && ` swaps the filter pair without losing the entered prefixes. **e2e-verified 2026-07-31** (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): typing 'Manage' into the department` &&
               ` prefix re-filters the bound rows (no 'Development' row left), clearing the prefix brings every row back (the odata String type maps '' to null, so an empty prefix drops the filter instead of matching` &&
               ` nothing), and 'Show Personal Filters' re-bakes the binding into the personal pair (the first/last name inputs appear). That is the whole boundFilters + re-bake-redraw claim.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.model.Filter`                   name = `BoundFilters.FilterBar`                        class = `z2ui5_cl_dmo_app_264` path = `src/02/b13/z2ui5_cl_dmo_app_264.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `The sample's whole point is the binding-info parameter 'boundFilters' - filter values that are binding expressions, so the aggregation re-filters whenever a value changes through data binding. It is` &&
                 ` 'Supported since 1.146.0' (source: fork-openui5/src/sap.ui.core/src/sap/ui/base/ManagedObject.js:3711, the sample's manifest declares minUI5Version 1.146.0) and is passed through 1:1 in the rows` &&
                 ` binding-info string. A binding-info parameter is invisible to the property gate (it is not a control member), so this is a by-policy declaration; the app needs a UI5 release >= 1.146.` ) ).

    lv_text1 = `POST-1.71: The sample's whole point is the binding-info parameter 'boundFilters', 'Supported since 1.146.0' (source: fork-openui5/src/sap.ui.core/src/sap/ui/base/ManagedObject.js:3711; the manifest` &&
               ` declares minUI5Version 1.146.0). Here it filters each row's Select items by the RELATIVE row field value1: '{REGION}', so every row lists only the account managers of its own region and re-filters` &&
               ` when that row's region changes. Passed through 1:1 as a raw binding-info string; a binding-info parameter is invisible to the property gate, so this is a by-policy declaration and the app needs UI5` &&
               ` >= 1.146. // NOTE: No named models in this sample - both arrays (/customers, /accountManagers) already live in the default model and are bound with client->_bind (the Select's items path via _bind(` &&
               ` val = t_accountmanagers path = abap_true ), never as text). Inside the binding-info strings the paths use the ABAP upper-cased field names: 'REGION' in the boundFilters entry and {parts:` &&
               ` ['FIRSTNAME', 'LASTNAME']} in the core:Item text, matching the original's 'region' / ['firstName', 'lastName']. Full mock row set inlined (20 customers, 13 account managers, byte-identical to`.
    lv_text1 = lv_text1 && ` Component.js). // NOTE: Unverified in a running system: that each row's Select really shows only its region's account managers (per-row bound filter over a relative value), that` &&
               ` forceSelection='false' plus selectedKey={ACCOUNTMANAGERID} preselects the right manager, and that the composite {parts: [...]} item text renders 'First Last'. **e2e-verified 2026-07-31**` &&
               ` (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): the first row's Select lists 'John Smith' (Americas, the row's own region) and NOT 'Yuki Tanaka' (APJ) - the per-row bound` &&
               ` filter over the relative value1 '{REGION}' works. Residual: the forceSelection='false' / selectedKey preselection is not separately asserted.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.model.Filter`                   name = `BoundFilters.FilteredListInTable`              class = `z2ui5_cl_dmo_app_265` path = `src/02/b13/z2ui5_cl_dmo_app_265.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `The sample's whole point is the binding-info parameter 'boundFilters', 'Supported since 1.146.0' (source: fork-openui5/src/sap.ui.core/src/sap/ui/base/ManagedObject.js:3711; the manifest declares` &&
                 ` minUI5Version 1.146.0). Here it filters each row's Select items by the RELATIVE row field value1: '{REGION}', so every row lists only the account managers of its own region and re-filters when that` &&
                 ` row's region changes. Passed through 1:1 as a raw binding-info string; a binding-info parameter is invisible to the property gate, so this is a by-policy declaration and the app needs UI5 >= 1.146.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.model.type.Currency`            name = `TypeCurrency`                                  class = `z2ui5_cl_dmo_app_135` path = `src/02/b04/z2ui5_cl_dmo_app_135.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: Composite data-type binding paradigm: the Currency type is pulled in via core:require and every Input/Text binds a composite parts:['/amount','/currency'] with type:'CurrencyType' plus` &&
                 ` formatOptions (showMeasure/showNumber/preserveDecimals/currencyCode/style) 1:1. The two model fields amount ('123456789.123') and currency ('USD') are serialized by abap2UI5 as /AMOUNT and /CURRENCY;` &&
                 ` the paths are generated via _bind (never hardcoded).` ) ).

    lv_text1 = `NOTE: the sample's whole point is a JSON model holding a Date OBJECT (UI5Date.getInstance()), which is exactly what an abap2UI5 model can never carry - the model travels as JSON, so a date is a` &&
               ` string. Every binding therefore keeps the original { path, type: 'DateType', formatOptions: { style / relative } } 1:1 and only ADDS formatOptions.source { pattern: 'yyyy-MM-dd' }, which makes` &&
               ` sap.ui.model.type.Date parse the string model value and write it back in the same form (same paradigm as the sibling port 181 TypeDateAsString and app 017). Without the source pattern the type raises` &&
               ` a FormatException on every binding and the view stays empty. // NOTE: the original seeds the CURRENT date (UI5Date.getInstance()); a fixed date (2026-08-02) is used here so the port is deterministic` &&
               ` - a display-only value. The Relative Time form therefore shows the distance to that fixed day, not to today.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.model.type.Date`                name = `TypeDateAsDate`                                class = `z2ui5_cl_dmo_app_282` path = `src/02/b16/z2ui5_cl_dmo_app_282.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.model.type.Date`                name = `TypeDateAsString`                              class = `z2ui5_cl_dmo_app_181` path = `src/02/b10/z2ui5_cl_dmo_app_181.clas.abap`
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
      ( module = `sap.ui.core`        control = `sap.ui.model.type.DateTime`            name = `TypeDateTime`                                  class = `z2ui5_cl_dmo_app_183` path = `src/02/b10/z2ui5_cl_dmo_app_183.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.model.type.FileSize`            name = `TypeFileSize`                                  class = `z2ui5_cl_dmo_app_180` path = `src/02/b10/z2ui5_cl_dmo_app_180.clas.abap`
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
      ( module = `sap.ui.core`        control = `sap.ui.model.type.Float`               name = `TypeFloat`                                     class = `z2ui5_cl_dmo_app_179` path = `src/02/b10/z2ui5_cl_dmo_app_179.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = `POST-1.71: core:require on the view root (module preloading for the FloatType alias) is kept 1:1 from the original view.xml; core:require needs UI5 >= 1.74 (declared by policy - the property gate` &&
                 ` cannot see view-root require attributes). // NOTE: Data-type binding paradigm: the Float type module is pulled in with core:require='{FloatType: sap/ui/model/type/Float}' and the Input/Text bindings` &&
                 ` carry type:'FloatType' plus formatOptions (min/maxIntegerDigits, min/maxFractionDigits, preserveDecimals) 1:1. The single model field 'number' (initial '123.456', kept as a string like the sample's` &&
                 ` JSON) is serialized by abap2UI5 as /NUMBER, so the original raw '/number' paths are written as '/NUMBER'.`
        post171 = `core:require on the view root (module preloading for the FloatType alias) is kept 1:1 from the original view.xml; core:require needs UI5 >= 1.74 (declared by policy - the property gate cannot see` &&
                 ` view-root require attributes).` )
      ( module = `sap.ui.core`        control = `sap.ui.model.type.Integer`             name = `TypeInteger`                                   class = `z2ui5_cl_dmo_app_129` path = `src/02/b03/z2ui5_cl_dmo_app_129.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: Data-type binding paradigm: the Integer type module is pulled in with core:require='{IntegerType: sap/ui/model/type/Integer}' and the Input/Text bindings carry type:'IntegerType' plus` &&
                 ` formatOptions (min/maxIntegerDigits) 1:1. The single model field 'number' (initial '123') is serialized by abap2UI5 as /NUMBER, so the original raw '/number' paths are written as '/NUMBER'.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.core`        control = `sap.ui.model.type.Time`                name = `TypeTimeAsTime`                                class = `z2ui5_cl_dmo_app_182` path = `src/02/b10/z2ui5_cl_dmo_app_182.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `IMPROVISED: The original model value is a JS Date object (UI5Date.getInstance()) and every TimeType binding has NO source formatOption (the type's default model format is a Date object). abap2UI5` &&
                 ` cannot hold a JS Date object in the JSON model, so a source formatOption { source: { pattern: 'HH:mm:ss' } } is added to each TimeType binding and the field is a parseable time string ('13:30:00') -` &&
                 ` the abap2UI5 equivalent of the Date-object model. Without it view creation crashes ('Time must be a Date object'). Same idiom applies to any TypeTime/TypeDateTime sample whose model is an object; a` &&
                 ` plain string binding is not enough (CAPABILITIES date-object row). // NOTE: The original seeds the current time; a fixed time (13:30:00) is used here so the port is deterministic - a client-only` &&
                 ` display value.` ) ).

    lv_text1 = `NOTE: Rebuilt 1:1 from the breadth probe 2026-08-06: the f:ShellBar (title/secondTitle/homeIcon/copilot/search/notifications/productSwitcher/notificationsNumber, its f:menu Menu+MenuItem and its` &&
               ` f:profile Avatar), the four-tab IconTabBar and both f:GridContainers with all EIGHT sap.ui.integration widgets:Card instances, each with its f:GridContainerItemLayoutData and the sample's own` &&
               ` layout/layoutS GridContainerSettings. The earlier port was a single Card with an invented manifest. // NOTE: The eight card manifests come from model/cardManifests.json verbatim. The original carries` &&
               ` them in a named ``manifests>`` model and binds {manifests>/timeline}; abap2UI5 has one default model, so each manifest is a field bound with _bind - the last path segment stays identical, which is` &&
               ` what structural-diff matches. The seven INLINE manifests are bound with json = abap_true, so they reach the Card as JSON objects: a string manifest is read as a manifest URL (Card.createManifest),` &&
               ` which is what the eighth ('component') card genuinely is, so that one stays a plain string bind. Corrected 2026-08-10 with pr/card-manifest-object - before the flag existed the seven inline manifests`.
    lv_text1 = lv_text1 && ` were quoted strings the control would have fetched as URLs. The JSON never enters the view XML (a raw { would be read as a binding), it travels as model data. Asset URLs inside the manifests are` &&
               ` absolutized to the OpenUI5 host per the asset-URL rule; the mock carries them host-relative. The model's unused ninth entry ('table') is not seeded - the sample's view binds eight. // NOTE: The` &&
               ` controller's three members are all resolved without a round-trip. resolveCardUrl is a formatter turning the component card's relative manifest path into a URL - computed in ABAP instead` &&
               ` (thin-frontend rule). onAction toasts the navigation URL off the event, composed through control_global MESSAGE_TOAST with ${$parameters>/parameters}.url as the argument. onInit's date is DateFormat` &&
               ` over UI5Date.getInstance(), a MOVING value, so it is anchored on a fixed date here (the corpus rule for now/random values, apps 164/181/289). // POST-1.71: sap.f.cards.CardBadgeCustomData (@since` &&
               ` 1.128, with icon/state/announcementText/visibilityMode) is kept 1:1 on the three badged cards, and sap.m.Avatar in the ShellBar's profile is @since 1.73; the Card ``action`` event's ``parameters```.
    lv_text1 = lv_text1 && ` parameter is @since 1.76. All newer than UI5 1.71, declared per the property-171 policy - the app needs a runtime that has them. // NOTE: The 'component' Card keeps its manifest, which is a URL to a` &&
               ` UI5 COMPONENT card (componentCard/manifest.json) rather than an inline card definition. It points at the OpenUI5 host, so whether the component itself loads depends on that host's CORS policy - the` &&
               ` card renders either way, and abap2UI5 has no place to ship a UI5 Component of its own. Declared rather than dropped, so the port keeps the sample's eight cards.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.integration` control = `sap.ui.integration.Card`               name = `CardsLayout`                                   class = `z2ui5_cl_dmo_app_118` path = `src/02/b01/z2ui5_cl_dmo_app_118.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.62`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.f.cards.CardBadgeCustomData (@since 1.128, with icon/state/announcementText/visibilityMode) is kept 1:1 on the three badged cards, and sap.m.Avatar in the ShellBar's profile is @since 1.73; the` &&
                 ` Card ``action`` event's ``parameters`` parameter is @since 1.76. All newer than UI5 1.71, declared per the property-171 policy - the app needs a runtime that has them.` ) ).

    lv_text1 = `NOTE: The sample itself is a Link + Image pointing at the Card Explorer tool (the actual integration Cards live in that tool); Link and Image reproduced 1:1. Since 2026-07-30 the Image press is the` &&
               ` original onImagePress 1:1: URLHelper.redirect('test-resources/sap/ui/integration/demokit/cardExplorer/index.html', true) via _event_client( cs_event-urlhelper, REDIRECT + { URL, NEW_WINDOW: true } )` &&
               ` - the earlier MessageToast substitution is gone. The relative target resolves against the serving origin exactly like the original's (and the Link's href); outside an OpenUI5-hosted origin it 404s in` &&
               ` the new tab, as the original would. // NOTE: live-verified 2026-08-04 (nightly e2e interaction): the urlhelper REDIRECT on the Image press (new-window open of the relative Card Explorer URL) is` &&
               ` unverified in a running system; the same REDIRECT action class is live-verified in app 084.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.integration` control = `sap.ui.integration.widgets.Card`       name = `CardExplorer`                                  class = `z2ui5_cl_dmo_app_149` path = `src/02/b08/z2ui5_cl_dmo_app_149.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.62`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The eleven card manifests come from manifests/cardManifests.json verbatim. The original carries them in a named ``manifests>`` model and the controller pushes them into the Cards on submit;` &&
               ` abap2UI5 has one default model, so each manifest is a bound field on it (the ``manifests>`` prefix is dropped, the last path segment stays identical, which is what structural-diff matches).` &&
               ` model_init is deliberately NOT called from main: the sample's Cards start without a manifest and only get one on the first 'Start loading' press, so the model is seeded in on_event and pushed with` &&
               ` view_model_update - the manifest-less initial state is reproduced 1:1. // NOTE: The manifests' relative data request URLs (sap/ui/integration/sample/CardsLoading/manifests/listData1.json and friends)` &&
               ` are absolutized to the OpenUI5 host (https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLoading/manifests/...), because the original resolves them at runtime through` &&
               ` sap.ui.require.toUrl inside its sinon stub and that resolution has no server-side equivalent. The deliberate typo of the 'error' card (listDat2.json instead of listData2.json - it is the sample's`.
    lv_text1 = lv_text1 && ` error test case) is kept verbatim so the card still demonstrates the request-failure state. // IMPROVISED: The sample's actual point - an ARTIFICIAL loading delay - is not reproducible: the` &&
               ` controller monkey-patches sap.ui.integration.util.RequestDataProvider._fetch with a sinon stub (sap/ui/thirdparty/sinon-4) that wraps every card data request in a setTimeout of the entered number of` &&
               ` seconds. There is no server-side equivalent for delaying a request the CLIENT issues to a foreign host, and stubbing a UI5 private module from the backend would be exactly the kind of frontend logic` &&
               ` the thin-frontend principle forbids. The Input keeps its literal value="-1" from the view (the original view holds the value too; only the client stub reads it), so the loading placeholders are still` &&
               ` visible for as long as the real request takes, just not artificially stretched. Consequently onExit's stub restore has no counterpart either. // NOTE: onFormSubmit's two branches are both reproduced:` &&
               ` the first press publishes the manifests through the model (the original's setManifest branch), every later press issues a follow_up_action control_by_id <cardId>/refresh for each of the eleven Cards`.
    lv_text1 = lv_text1 && ` (the original's oCard.refresh() branch). refresh( ) is a public sap.ui.integration.widgets.Card method that does not match the FrontendAction deny regex, so it runs through the unlisted-method path;` &&
               ` it is unverified in a running system. // LIVE-TEST: Unverified in a running system: whether the eleven spliced JSON manifests render their Cards, whether an empty-string manifest shows the original's` &&
               ` manifest-less placeholder before the first press, and the control_by_id refresh wire on the second press. // NOTE: The eleven manifests reach the Cards as real JSON OBJECTS through client->_bind( val` &&
               ` = manifest_x json = abap_true ). This port is what raised that flag: sap.ui.integration.widgets.Card.createManifest branches on the JS type and reads a STRING manifest as a manifest URL (``if (typeof` &&
               ` vManifest === "string") { mOptions.manifestUrl = vManifest; }``, Card.js), so an inline manifest has to arrive as an object - and a model value could not be one: every value is typed ABAP data, and a`.
    lv_text1 = lv_text1 && ` manifest's keys (``sap.app``, ``sap.card``, ``_version``) are not valid ABAP field names, so it cannot be modelled as a structure either. The framework now splices such a string into the model as a` &&
               ` JSON node instead of quoting it (pr/card-manifest-object, implemented upstream), which is why CardsLoading works at all: unlike LazyLoading (app 342) it keeps all eleven manifests in one combined` &&
               ` manifests/cardManifests.json, so there is no per-card URL to bind instead.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.integration` control = `sap.ui.integration.widgets.Card`       name = `CardsLoading`                                  class = `z2ui5_cl_dmo_app_341` path = `src/02/b19/z2ui5_cl_dmo_app_341.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.62`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The original's GridContainer is empty in the view and the controller creates the Cards in JS (new Card({ manifest, layoutData: new GridContainerItemLayoutData({ columns, minRows: 4 }), dataMode` &&
               ` })) on every submit. The port binds the GridContainer's items aggregation instead and declares the w:Card + f:GridContainerItemLayoutData as its template, so the same cards come out of the model - a` &&
               ` thin frontend with no imperative control creation. structural-diff therefore reports the added controls w:Card and f:GridContainerItemLayoutData, which the original view does not contain; they are` &&
               ` exactly the controller-built ones. // NOTE: The ten manifests are bound as URLs, not as inline JSON: sap.ui.integration.widgets.Card.createManifest reads a STRING manifest as a manifest URL (``if` &&
               ` (typeof vManifest === "string") { mOptions.manifestUrl = vManifest; }``), and LazyLoading keeps one manifest per file, so the URL form is the faithful 1:1 here. The paths are absolutized to the` &&
               ` OpenUI5 host (https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/LazyLoading/manifests/...) because the original resolves them through sap.ui.require.toUrl. The controller's`.
    lv_text1 = lv_text1 && ` baseUrl: './' is dropped with them - with an absolute manifest URL, UI5 uses that URL as the base, which is what the relative resources inside those manifests need. (The bundled-manifest shape that` &&
               ` CANNOT be expressed this way is app 341's; see pr/card-manifest-object.) // NOTE: The controller's aSamples array (key, columns, manifest per card) is inlined verbatim in cards_build as a LOCAL` &&
               ` table: it is never bound, so it stays out of the model that travels on every round-trip. The port keeps the original's cycling (aSamples[i % aSamples.length]) and its dataMode split (Active when the` &&
               ` CheckBox is selected, Auto otherwise), both driven from the two-way bound form fields. manifests/listManifestError.json is archived but not used - the original's aSamples does not list it either. //` &&
               ` IMPROVISED: The artificial request delay is not reproducible and is dropped: the controller monkey-patches sap.ui.integration.util.RequestDataProvider._fetch with a sinon stub` &&
               ` (sap/ui/thirdparty/sinon-4) that wraps every card data request in a setTimeout of the entered number of seconds, and onExit restores it. There is no server-side equivalent for delaying a request the`.
    lv_text1 = lv_text1 && ` CLIENT issues to a foreign host, and stubbing a UI5 private module from the backend is exactly the frontend logic the thin-frontend principle forbids. The 'Time for requesting the card data' Input is` &&
               ` kept 1:1 (the original view gives it no value either) but nothing reads it; the loading placeholders are still visible for as long as the real request takes. // LIVE-TEST: Unverified in a running` &&
               ` system: whether the bound items aggregation instantiates the Cards with their per-row manifest URL, columns and dataMode, and whether the number-of-cards Input round-trip rebuilds the container as` &&
               ` the original's destroyItems/addItem loop does.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.integration` control = `sap.ui.integration.widgets.Card`       name = `LazyLoading`                                   class = `z2ui5_cl_dmo_app_342` path = `src/02/b19/z2ui5_cl_dmo_app_342.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.62`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.BlockLayout`             name = `BlockLayoutCustomBackground`                   class = `z2ui5_cl_dmo_app_140` path = `src/02/b05/z2ui5_cl_dmo_app_140.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-27): verified in a running system 2026-07-27 - BlockLayout renders all 6 rows/7 cells with color shades after the attribute-line repair`
        notes = `NOTE: BlockLayout with six rows / seven cells across background color shades A-F; the Select (11 ColorSet items) and every cell's backgroundColorSet are two-way bound to one model field (initial` &&
                 ` ColorSet5), reproducing the original {/colorSet} wiring. Cell body texts are reproduced 1:1 (long ones split with &&). // POST-1.71: sap.m.Label.showColon is used (since UI5 1.98). The BlockLayout` &&
                 ` entity itself is in scope; showColon renders the label's trailing colon 1:1.`
        post171 = `sap.m.Label.showColon is used (since UI5 1.98). The BlockLayout entity itself is in scope; showColon renders the label's trailing colon 1:1.` ) ).

    lv_text1 = `NOTE: The six core:Fragment references (sap.ui.layout.sample.BlockLayoutCustomBackgroundPerCell.ColorSelect) are inlined: abap2UI5 serves one view per round-trip, so a fragmentName has no file to` &&
               ` resolve. The fragment's content (VBox with the two Labels and the two Selects over eleven ColorSet and six ColorShade core:Item entries) is written into each of the six cells verbatim, so the` &&
               ` rendered result is identical; the dropped core:Fragment elements are what structural-diff reports. // NOTE: Each cell keeps its own element binding: binding="{/cellN}" is built from client->_bind(` &&
               ` val = cellN path = abap_true ) rather than a hard-coded path, and the model carries one nested structure per cell (colorset/colorshade) so the fragment's relative {COLORSET}/{COLORSHADE} bindings` &&
               ` resolve against the cell context exactly as in the original - no flattening to the model root was needed, and the two Selects write back into their own cell. // NOTE: resources/sample.css is injected` &&
               ` through a core:HTML <style> leaf (abap2UI5 ships no separate stylesheet), so the port adds one core:HTML control the original view does not have. The CSS braces are escaped \{ \} in a backtick`.
    lv_text1 = lv_text1 && ` literal so the XMLView parser does not read them as bindings, and the background-image url("Night_sky.jpg") is absolutized to the OpenUI5 host` &&
               ` (https://sdk.openui5.org/test-resources/sap/ui/layout/demokit/sample/BlockLayoutCustomBackgroundPerCell/resources/Night_sky.jpg) per the asset-URL rule - relative to the served app it would not` &&
               ` resolve. // LIVE-TEST: Unverified in a running system: whether the per-cell context binding round-trips (a Select changing its cell's colorSet/colorShade writes back into the nested ABAP structure)` &&
               ` and whether the injected stylesheet paints the image cell.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.BlockLayout`             name = `BlockLayoutCustomBackgroundPerCell`            class = `z2ui5_cl_dmo_app_343` path = `src/02/b19/z2ui5_cl_dmo_app_343.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The Slider's ``liveChange`` attribute is dropped (the expression binding needs no event). **e2e-verified 2026-08-01** (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): one` &&
               ` keyboard step on the Slider moves the containerLayout (VerticalLayout) width to 99% with no round-trip - the expression binding replaces onSliderMoved completely. Residual: the BlockLayout's own` &&
               ` reflow inside the resized layout. // NOTE: live-verified 2026-08-04 (nightly e2e interaction): The SegmentedButton.selectedKey and the BlockLayout.background are both two-way bound to the same` &&
               ` /SELECTEDBACKGROUND field, so changing the segmented button updates the BlockLayout background entirely on the client with no round-trip (the app-048/003 shared-binding idiom, matching the original` &&
               ` {/selectedBackground} on both). The field is seeded with the enum default Default (the original leaves /selectedBackground undefined; an empty string would fail BlockBackgroundType validateProperty).` &&
               ` Live sync unverified. // NOTE: The 123 /ProductCollection rows are inlined from the shared mock ui5/mock/products.json; only the columns the table binds are kept`.
    lv_text1 = lv_text1 && ` (productid,name,suppliername,width,depth,height,dimunit,weightmeasure,weightunit,price,currencycode). Dimension and weight fields are TYPE string to preserve exact decimals for the display templates;` &&
               ` price is TYPE p DECIMALS 2 for the sap.ui.model.type.Currency binding. Data verified against the mock.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.BlockLayout`             name = `BlockLayoutDefault`                            class = `z2ui5_cl_dmo_app_214` path = `src/02/b10/z2ui5_cl_dmo_app_214.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.34`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The Slider's imperative onSliderMoved handler (setWidth on the container) is replaced by the thin-frontend equivalent: the Slider value is two-way bound and the VerticalLayout containerLayout` &&
               ` width is an expression binding {= ${/SLIDERVALUE} + '%' }. The Slider's liveChange attribute is dropped (no event round-trip needed). structural-diff does not flag the literal value=100 becoming a` &&
               ` binding. // NOTE: The SegmentedButton selectedKey and the BlockLayout background are two-way bound to one default-model field selectedbackground, reproducing the original {/selectedBackground}` &&
               ` wiring; it is seeded with the enum default Default (a valid BlockBackgroundType) because an empty enum value crashes validateProperty. The original controller loads sap/ui/demo/mock/products.json as` &&
               ` the unnamed model but no view binding references it, so it is not reproduced.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.BlockLayout`             name = `BlockLayoutLinkTitle`                          class = `z2ui5_cl_dmo_app_223` path = `src/02/b10/z2ui5_cl_dmo_app_223.clas.abap`
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
      ( module = `sap.ui.layout`      control = `sap.ui.layout.cssgrid.CSSGrid`         name = `CSSGrid`                                       class = `z2ui5_cl_dmo_app_124` path = `src/02/b02/z2ui5_cl_dmo_app_124.clas.abap`
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
      ( module = `sap.ui.layout`      control = `sap.ui.layout.cssgrid.CSSGrid`         name = `GridAutoFlow`                                  class = `z2ui5_cl_dmo_app_145` path = `src/02/b06/z2ui5_cl_dmo_app_145.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: The 'Reveal Grid' ToggleButton keeps its label but loses its press attribute: onRevealGrid calls RevealGrid.toggle(['grid1','grid2'], view) from the sample-local module` &&
               ` RevealGrid/RevealGrid.js, which measures the rendered grid and draws an absolutely positioned outline overlay over every grid cell. That is a sample-only JS helper with its own CSS, not a control,` &&
               ` property or whitelisted control method, and it is not loadable in an abap2UI5 app - the same drop as apps 145/222/271. onExit's RevealGrid.destroy goes with it, and RevealGrid/RevealGrid.css is not` &&
               ` injected either since nothing renders those classes. // NOTE: css/main.css (.sapMFlexBox.demoBox, .demoBox .sapMText, .sapMText.message) is injected through an extra core:HTML <style> leaf, because` &&
               ` abap2UI5 ships no separate stylesheet - without the rules behind them the 26 demo boxes would render as unstyled text (the app-122/124 lesson). The CSS braces are escaped \{ \} in a backtick literal` &&
               ` so the XMLView parser does not read them as bindings; the view also declares xmlns:core for it, which the original does not need. // NOTE: Fully static port: the sample has no model and - once the`.
    lv_text1 = lv_text1 && ` RevealGrid toggle is dropped - no event either, so the class is the app-051 shape (a bare check_on_init branch with view_display, no model_init, no on_event).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.cssgrid.CSSGrid`         name = `GridAutoRows`                                  class = `z2ui5_cl_dmo_app_346` path = `src/02/b19/z2ui5_cl_dmo_app_346.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: Both controller handlers become plain bindings, so the port drops the Slider.liveChange and the three Input.change attributes that only carried the imperative setters. (a) onSliderMoved calls` &&
               ` byId('panelCSSGrid').setWidth(fValue + '%'); sap.m.Panel HAS a width property, so the Slider's value is two-way bound and the Panel's width is an expression binding over it - roundtrip-free, the` &&
               ` app-222/176 idiom. (b) onInputChanged switches on the Input id and calls setGridGap / setGridRowGap / setGridColumnGap; each Input is two-way bound to its own field and the CSSGrid binds the matching` &&
               ` property to the SAME field, so typing a value reaches the grid with no dispatcher at all. // NOTE: css/main.css (.sapMFlexBox.demoBox, .demoBox .sapMText, .sapMText.infoText) is injected through an` &&
               ` extra core:HTML <style> leaf - abap2UI5 ships no separate stylesheet, and without the rules the ten demo boxes render unstyled. The CSS braces are escaped \{ \} in a backtick literal so the XMLView` &&
               ` parser does not read them as bindings; the view declares xmlns:core for it, which the original does not need. // LIVE-TEST: Unverified in a running system: whether an empty gridRowGap / gridColumnGap`.
    lv_text1 = lv_text1 && ` serializes acceptably for the CSSGrid's CSSSize properties (the two Inputs carry no value attribute in the original either, so the grid starts on gridGap alone), and whether the Panel width` &&
               ` expression follows the slider live.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.cssgrid.CSSGrid`         name = `GridGap`                                       class = `z2ui5_cl_dmo_app_347` path = `src/02/b19/z2ui5_cl_dmo_app_347.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        notes = lv_text1 ) ).

    lv_text1 = `POST-1.71: sap.ui.layout.cssgrid.ResponsiveColumnLayout (the CSSGrid customLayout this sample is about) and sap.ui.layout.cssgrid.ResponsiveColumnItemLayoutData (its per-card columns/rows layout data)` &&
               ` are both @since 1.72, one minor release past the 1.71 floor, and so is the layout's layoutChange event with its layout parameter. All are kept 1:1 - the sample's owning control` &&
               ` sap.ui.layout.cssgrid.CSSGrid is in scope and the sample is nothing without them; declared per the fidelity-first property-171 policy, so the app needs a UI5 release >= 1.72. // IMPROVISED: The` &&
               ` 'Reveal Grid' ToggleButton keeps its label but loses its press attribute: onRevealGrid calls RevealGrid.toggle('grid1', view) from the sample-local module RevealGrid/RevealGrid.js, which measures the` &&
               ` rendered grid and draws an absolutely positioned outline overlay over every grid cell. That is a sample-only JS helper with its own CSS, not a control, property or whitelisted control method, and it` &&
               ` is not loadable in an abap2UI5 app - the same drop as apps 145/222/271/346. onExit's RevealGrid.destroy goes with it. // NOTE: Slider.liveChange is dropped for a binding: onSliderMoved calls`.
    lv_text1 = lv_text1 && ` byId('panelCSSGrid').setWidth(fValue + '%'), and sap.m.Panel HAS a width property, so the Slider's value is two-way bound and the Panel's width is an expression binding over it - roundtrip-free, the` &&
               ` app-222/176 idiom. onLayoutChange stays a real round-trip because there is nothing to bind against: the layout reports its breakpoint in the layoutChange event, so the wire carries` &&
               ` ${$parameters>/layout} to the backend and on_event writes it into the field the 'Current breakpoint' Text binds - the same write the original's setProperty('/currentBreakpoint', ...) does. // NOTE:` &&
               ` The original's model has one field (currentBreakpoint, initially empty) and the view binds it as {/currentBreakpoint}; folded onto the one default model it is client->_bind( currentbreakpoint ) -` &&
               ` same data, same leaf name. It is seeded empty like the original, so the Text reads 'Current breakpoint: ' until the first layoutChange fires. // LIVE-TEST: Unverified in a running system: whether the` &&
               ` layoutChange round-trip fills the breakpoint Text as the panel is resized, and whether the Panel width expression follows the slider live.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.cssgrid.CSSGrid`         name = `GridResponsiveColumnLayout`                    class = `z2ui5_cl_dmo_app_348` path = `src/02/b19/z2ui5_cl_dmo_app_348.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.60`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.ui.layout.cssgrid.ResponsiveColumnLayout (the CSSGrid customLayout this sample is about) and sap.ui.layout.cssgrid.ResponsiveColumnItemLayoutData (its per-card columns/rows layout data) are both` &&
                 ` @since 1.72, one minor release past the 1.71 floor, and so is the layout's layoutChange event with its layout parameter. All are kept 1:1 - the sample's owning control sap.ui.layout.cssgrid.CSSGrid` &&
                 ` is in scope and the sample is nothing without them; declared per the fidelity-first property-171 policy, so the app needs a UI5 release >= 1.72.` ) ).

    lv_text1 = `NOTE: The sample's css/main.css (.demoBox tile colours, .sapMText.message bold) is injected through a core:HTML <style> leaf (app 122/124 precedent), so that core:HTML control is EXTRA against the` &&
               ` original view (original 0 vs port 1). The CSS is reproduced verbatim, only whitespace-collapsed. // NOTE: The Slider's liveChange attribute is dropped: onSliderMoved calls` &&
               ` byId('panelCSSGrid').setWidth(fValue + '%'), and sap.m.Panel has a width property, so the value is two-way bound and the width is the expression binding {= ${/SLIDER_VALUE} + '%' } (app 214/270` &&
               ` form). Same rendered behaviour without a round-trip. // NOTE: The SegmentedButton's selectionChange attribute is dropped: onSegmentedButtonChange calls grid1.getCustomLayout().setContainerQuery(key` &&
               ` === 'true'). The button's selectedKey and the GridResponsiveLayout's containerQuery share one two-way bound field here - selectedKey={/CONTAINER_QUERY} and containerQuery={= ${/CONTAINER_QUERY} ===` &&
               ` 'true' }, the string-to-boolean step the controller does in JS - so switching the segment reconfigures the layout client-side, with no round-trip and no imperative setter. // IMPROVISED: The 'Reveal`.
    lv_text1 = lv_text1 && ` Grid' ToggleButton keeps its label but loses its press handler: onRevealGrid calls RevealGrid.toggle('grid1', view) from the sample-local module RevealGrid/RevealGrid.js, which draws a debug overlay` &&
               ` of the grid lines on top of the rendered DOM. That is a sample-only JS helper with its own CSS, not an abap2UI5 capability (same drop as app 145's RevealGrid); the button therefore does nothing.` &&
               ` onExit's RevealGrid.destroy goes with it. // NOTE: onAfterRendering seeds the info Text from the layout that is active after the first render` &&
               ` (getCustomLayout().getActiveGridSettings().sParentAggregationName). The backend cannot read that, so the port ships the view's own initial text ('Layout size is: ') and the first real value arrives` &&
               ` with the first layoutChange event - which UI5 fires whenever the active GridSettings change, including on the initial breakpoint evaluation. // NOTE: live-verified 2026-08-04 (nightly e2e` &&
               ` interaction): Unverified in a running system: (a) the layoutChange round-trip (${$parameters>/layout}) writing 'Layout size is: layoutS/layoutM or layoutL/layoutXL' into the bound Text; (b) that the`.
    lv_text1 = lv_text1 && ` containerQuery expression binding really re-evaluates the GridResponsiveLayout when the segment switches; (c) that the three GridSettings breakpoints lay the twelve tiles out as in the original.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.cssgrid.CSSGrid`         name = `GridResponsiveness`                            class = `z2ui5_cl_dmo_app_271` path = `src/02/b14/z2ui5_cl_dmo_app_271.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: Both controller handlers become plain bindings, so the port drops the Slider.liveChange and the two ComboBox.change attributes that only carried the imperative setters. (a) onSliderMoved calls` &&
               ` byId('panelCSSGrid').setWidth(fValue + '%'); sap.m.Panel HAS a width property, so the Slider's value is two-way bound and the Panel's width is an expression binding over it - roundtrip-free, the` &&
               ` app-222/176 idiom. (b) onInputChanged calls setGridTemplateRows / setGridTemplateColumns depending on which ComboBox fired; each ComboBox value is two-way bound and the CSSGrid binds the matching` &&
               ` property to the SAME field, so picking or typing a template reaches the grid with no dispatcher. // NOTE: The grid's gridTemplateColumns starts from the cTem ComboBox's preselected item text "1fr` &&
               ` 1fr" rather than the view's literal "repeat(2,1fr)": both express the same two equal columns, and binding the grid to the ComboBox field is what makes the selection drive the grid at all.` &&
               ` gridTemplateRows keeps "1fr 2fr 1fr", which is both the view literal and the rFr item text. The ComboBoxes keep their selectedKey attributes 1:1. // NOTE: css/main.css (.sapMFlexBox.demoBox and the`.
    lv_text1 = lv_text1 && ` white .sapMTitle/.sapMText inside it) is injected through an extra core:HTML <style> leaf - abap2UI5 ships no separate stylesheet, and without the rules the six demo boxes render unstyled. The CSS` &&
               ` braces are escaped \{ \} in a backtick literal so the XMLView parser does not read them as bindings. // LIVE-TEST: Unverified in a running system: whether a ComboBox free-text entry (the original` &&
               ` reads the change event's value, not the selected key) round-trips into the bound field and re-templates the grid.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.cssgrid.CSSGrid`         name = `GridTemplateRows`                              class = `z2ui5_cl_dmo_app_349` path = `src/02/b19/z2ui5_cl_dmo_app_349.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The sample's css/main.css (the .demoBox / .demoInnerBox colours and radii the grid tiles carry) is injected through a core:HTML leaf with a <style> element in its content attribute - the app` &&
               ` 122/124 precedent, since a port ships no stylesheet. That core:HTML control is therefore EXTRA against the original view (original 0 vs port 1); the CSS itself is reproduced verbatim, only` &&
               ` whitespace-collapsed. // NOTE: The Slider's liveChange attribute is dropped: onSliderMoved calls byId('panelCSSGrid').setWidth(fValue + '%'). sap.m.Panel HAS a width property, so the slider value is` &&
               ` two-way bound ({/SLIDER_VALUE}) and the Panel width is the expression binding {= ${/SLIDER_VALUE} + '%' } - the app 214 form, which needs no round-trip and no imperative setter. Same rendered` &&
               ` behaviour, so NOTE rather than IMPROVISED. // NOTE: **e2e-verified 2026-08-01** (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): driving the Slider with the keyboard resizes` &&
               ` the Panel with no round-trip: the value goes 100 -> 99 and the Panel's width follows as '99%' through the expression binding, so the controller's jQuery width is fully replaced. The nested CSSGrid`.
    lv_text1 = lv_text1 && ` renders its E/F/G boxes. Residual (nothing headless can assert): the visual grid placement from GridItemLayoutData (gridColumn '1 / 3'), which needs the theme CSS the harness does not load.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.cssgrid.CSSGrid`         name = `NestedGrids`                                   class = `z2ui5_cl_dmo_app_270` path = `src/02/b14/z2ui5_cl_dmo_app_270.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.60`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The four core:Fragment references (view/Group1..Group4) are inlined into the one port view: abap2UI5 serves one view per round-trip, so a fragmentName has no file to resolve. Their content (the` &&
               ` VBox with its cssgrid:ResponsiveColumnItemLayoutData, the group Title and the f:GridContainer with all its Cards) is reproduced verbatim, so the rendered result is identical; the dropped` &&
               ` core:Fragment elements are what structural-diff reports. All four fragments declare sap.m as their default xmlns like the main view, so no control changes prefix. // POST-1.71:` &&
               ` sap.ui.layout.cssgrid.ResponsiveColumnLayout and sap.ui.layout.cssgrid.ResponsiveColumnItemLayoutData are @since 1.72 (with the layout's layoutChange event and its layout parameter), sap.m.Avatar is` &&
               ` @since 1.73, and sap.f.GridContainer's columnsChange event carries its columns parameter. All are kept 1:1 - the sample's owning control sap.ui.layout.cssgrid.CSSGrid is in scope and the layout is` &&
               ` what the sample is about; declared per the fidelity-first property-171 policy, so the app needs a UI5 release >= 1.73. // NOTE: The named ``home>`` model (model/home.json) is folded onto the one`.
    lv_text1 = lv_text1 && ` default model: homeIconSrc, user/iconSrc, currentBreakpoint and /layout/groupN/columns/current become fields with the same leaf names. The per-breakpoint column table is NOT shipped to the frontend -` &&
               ` onLayoutChangeMain's lookup ('the value for this breakpoint, else default') is arithmetic, so it lives in ABAP (columns_apply) and only the four resulting column counts are bound, per the` &&
               ` thin-frontend principle. onColumnsChange is the same move: the grid's columns parameter reaches the backend, which decides 4 vs 5 columns for the usersCard/upfCard exactly as the original's` &&
               ` ``iGridColumns < 14 ? 4 : 5``. // NOTE: /layout/<group>/columns/current is null in model/home.json and the original only fills it on the first layoutChange; the port seeds each group with its own` &&
               ` ``default`` value (10/4/7/4) instead, so the grid has a valid column count on the very first render rather than an unset one. The formatSrc formatter (sap.ui.require.toUrl over the sample folder) is` &&
               ` resolved in ABAP - the two images and the two card manifest URLs are absolutized to the OpenUI5 host per the asset-URL rule. // NOTE: The two sap.ui.integration widgets:Card instances (usersCard,`.
    lv_text1 = lv_text1 && ` logonRequestsCard) get their manifest as a bound URL, which is the shape Card.createManifest reads a string manifest as - the original does exactly the same in onInit` &&
               ` (setManifest(this.formatSrc('cards/UsersCard/manifest.json'))). Unlike app 341's bundled manifests this needs no framework change; see pr/card-manifest-object for the case that does. // IMPROVISED:` &&
               ` The two 'Reveal Grid' ToggleButtons keep their labels but lose their press attributes: onRevealGridMain/onRevealGridGroups call RevealGrid.toggle from the sample-local module` &&
               ` RevealGrid/RevealGrid.js, which measures the rendered grid and draws an absolutely positioned outline overlay over every grid cell. That is a sample-only JS helper with its own CSS (the manifest's` &&
               ` only resources/css entry), not a control, property or whitelisted control method - the same drop as apps 145/222/271/346/348, and RevealGrid.css is not injected either since nothing renders those` &&
               ` classes. onExit's RevealGrid.destroy goes with it. // NOTE: The Avatar.press and Link.press attributes of the five 'Frequent Operations' tiles are dropped: the original wires them all to onTilePress,`.
    lv_text1 = lv_text1 && ` which is an EMPTY function. Keeping them would mean a backend round-trip that does nothing (the dead-event-wire class), so the attributes go away rather than being wired to a no-op. // LIVE-TEST:` &&
               ` Unverified in a running system: the layoutChange and columnsChange round-trips re-laying out the four groups and widening the two group-1 cards, and whether the two card manifest URLs load from the` &&
               ` OpenUI5 host (their images are relative to the manifest, which is what an absolute manifest URL makes resolvable).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.cssgrid.CSSGrid`         name = `ProductHomeLayout`                             class = `z2ui5_cl_dmo_app_350` path = `src/02/b19/z2ui5_cl_dmo_app_350.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.60`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.ui.layout.cssgrid.ResponsiveColumnLayout and sap.ui.layout.cssgrid.ResponsiveColumnItemLayoutData are @since 1.72 (with the layout's layoutChange event and its layout parameter), sap.m.Avatar is` &&
                 ` @since 1.73, and sap.f.GridContainer's columnsChange event carries its columns parameter. All are kept 1:1 - the sample's owning control sap.ui.layout.cssgrid.CSSGrid is in scope and the layout is` &&
                 ` what the sample is about; declared per the fidelity-first property-171 policy, so the app needs a UI5 release >= 1.73.` ) ).

    lv_text1 = `NOTE: Two of the original's three controller behaviours are now reproduced rather than wired to nothing. (a) breakpointChanged carries its own currentBreakpoint event parameter to the backend (t_arg` &&
               ` ${$parameters>/currentBreakpoint}) and on_event enables the Toggle button exactly when it is 'S' - what _updateToggleButtonState does; the port therefore adds an enabled attribute to the Toggle` &&
               ` Button, which the original sets from the controller. (b) handleToggleClick calls DynamicSideContent.toggle( ); the port binds showSideContent (the property that setter writes, default true) and flips` &&
               ` it in on_event, so the press has an effect. Both were dead wires before this rework - BP_CHANGED and TOGGLE fired round-trips this class never dispatched (pattern-lint dead-event-wire). The original` &&
               ` also calls _updateToggleButtonState once in onAfterRendering; abap2UI5 has no equivalent hook, so the button starts disabled and takes its state from the first breakpointChanged event. // NOTE: The` &&
               ` width Slider's liveChange is reproduced roundtrip-free since 2026-08-05. The original's handleSliderChange resizes the containing Page through jQuery -`.
    lv_text1 = lv_text1 && ` this.byId('sideContentContainer').$().width(iValue + '%') - i.e. it writes a CSS width straight onto the rendered DOM node, and sap.m.Page has no width property to bind. The ``css`` control method` &&
               ` added upstream for this class of gap (pr/control-inline-style) does the same write from the wire: _event_client( control_by_id, sideContentContainer / css / width / ${$parameters>/value} + '%' ), the` &&
               ` arg being a full UI5 expression (CAPABILITIES). The Slider keeps its value='100' literal and now resizes the page again. // NOTE: The hint Text.visible is bound to a boolean model field (initial` &&
               ` true); the original used a literal visible='getVisible()' (a sample quirk) toggled per Device.system.phone in onBeforeRendering. The two long body texts are shortened representative Lorem (not` &&
               ` gate-compared, static).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.DynamicSideContent`      name = `DynamicSideContent`                            class = `z2ui5_cl_dmo_app_138` path = `src/02/b05/z2ui5_cl_dmo_app_138.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.30`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: The named img> model ({img>/products/pic1} and {img>/products/pic3}, loaded from sap/ui/demo/mock/img.json) is resolved STATICALLY to the two image URLs it points at (HT-7777-large.jpg for` &&
               ` the main content, HT-6100-large.jpg for the side content, on the sdk.openui5.org host per the offline asset rule). abap2UI5 serves one default model and these are pure display assets that never` &&
               ` change, so a lossy-by-definition static fold (app 006 precedent) rather than a NOTE-worthy prefix drop - the live model indirection is gone. // NOTE: The Slider's liveChange is reproduced` &&
               ` roundtrip-free since 2026-08-05: handleSliderChange resizes the DynamicSideContent's container by writing a percentage width onto its DOM node (byId('sideContentContainer').$().width(iValue + '%')),` &&
               ` and the container is a sap.m.Page, which has no width property. The ``css`` control method (pr/control-inline-style) performs that write from the wire - _event_client( control_by_id,` &&
               ` sideContentContainer / css / width / ${$parameters>/value} + '%' ) - so the drag has its original effect; apps 213/214 keep the bound-property path where the target HAS a width. // NOTE:`.
    lv_text1 = lv_text1 && ` **e2e-verified 2026-08-01** (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): shrinking the viewport into the S range makes the DynamicSideContent fire breakpointChanged, the` &&
               ` round-trip transports 'S' and the footer Toggle button becomes enabled through the two-way bound flag - the whole _updateToggleButtonState wire. The main/side content render side by side beforehand.` &&
               ` Residual (nothing headless can assert): that toggle() then really swaps main and side content visually, and the Slider's device-model visible flag on a real phone.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.DynamicSideContent`      name = `DynamicSideContentEqualSplit`                  class = `z2ui5_cl_dmo_app_267` path = `src/02/b14/z2ui5_cl_dmo_app_267.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.30`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: All three controller behaviours are reproduced. (a) breakpointChanged carries its own currentBreakpoint event parameter to the backend (t_arg ${$parameters>/currentBreakpoint}) and on_event` &&
               ` enables the Toggle button exactly when it is 'S' - what _updateToggleButtonState does; the port therefore adds an enabled attribute to the Toggle Button, which the original sets from the controller.` &&
               ` (b) handleToggleClick calls DynamicSideContent.toggle( ); the port binds showSideContent (the property that setter writes, default true) and flips it in on_event. (c) handleSliderChange resizes the` &&
               ` containing Page through jQuery - this.byId('sideContentContainer').$().width(iValue + '%') - and sap.m.Page has no width property to bind, so the port uses the ``css`` control method roundtrip-free:` &&
               ` _event_client( control_by_id, sideContentContainer / css / width / ${$parameters>/value} + '%' ). Same wiring as app 138, which ports the plain DynamicSideContent sample; what this sample adds is` &&
               ` sideContentPosition="Begin", kept 1:1. // NOTE: style.css (.sapUiDSC.sapUiDSCExplored h1 { font-size: 1.5rem }) is injected through a core:HTML <style> leaf, so the port adds one core:HTML control`.
    lv_text1 = lv_text1 && ` the original view does not have - abap2UI5 ships no separate stylesheet. The CSS braces are escaped \{ \} in a backtick literal so the XMLView parser does not read them as bindings. // NOTE:` &&
               ` onBeforeRendering hides the width Slider and the hint Text on a phone (Device.system.phone). Both are bound to the shared device model instead - visible="{= !${device>/system/phone} }" - which is the` &&
               ` live equivalent and needs no round-trip; the original's literal visible="getVisible()" on the hint Text (a sample quirk that evaluates to nothing) is replaced by that binding. The two body texts are` &&
               ` the sample's full Lorem paragraphs verbatim, with the XML attribute's line breaks normalized to single spaces as an XML parser would. // LIVE-TEST: Unverified in a running system: the` &&
               ` breakpointChanged round-trip enabling the Toggle button on S, the showSideContent flip, and the Slider's css width write on the container Page. The same three wires are live-verified on app 138 (the` &&
               ` plain DynamicSideContent sample), which uses them identically.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.DynamicSideContent`      name = `DynamicSideContentPosition`                    class = `z2ui5_cl_dmo_app_344` path = `src/02/b19/z2ui5_cl_dmo_app_344.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.30`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: The named img> model ({img>/products/pic1}, from sap/ui/demo/mock/img.json) is resolved STATICALLY to the URL it points at (HT-7777-large.jpg, on the sdk.openui5.org host per the offline` &&
               ` asset rule) - same fold and same reasoning as app 267: a pure display asset that never changes, but the live model indirection is gone. // NOTE: The Slider's liveChange is reproduced roundtrip-free` &&
               ` since 2026-08-05: handleSliderChange writes a percentage width straight onto the container's DOM node, and that container is a sap.m.Page with no width property. The ``css`` control method` &&
               ` (pr/control-inline-style) does the same write from the wire - _event_client( control_by_id, sideContentContainer / css / width / ${$parameters>/value} + '%' ). Apps 213/214 keep the bound-property` &&
               ` path where the target control HAS a width. // NOTE: The controller's media model (new JSONModel(Device.system)) is abap2UI5's shared device> model, so every {media>/phone} binding becomes {=` &&
               ` !${device>/system/phone}} on the same data - the Close button, the Slider and the width hint Text keep their original visibility rules. A device-branch fold onto the framework's own model, no loss.`.
    lv_text1 = lv_text1 && ` // NOTE: handleSideContentHide / handleSideContentShow call oDSC.setShowSideContent(false/true) in the original. DynamicSideContent.showSideContent is a bindable property, so the port binds it` &&
               ` two-way and only flips the flag server-side (added attribute, no structural diff) - the prefer-a-bindable-property rule, now gated by the linter rule settable-property-via-action. The state then` &&
               ` survives a view rebuild, and the control's own toggle( ) - the Toggle button's client-side wire, kept as it is - writes back into the model instead of drifting from it. // IMPROVISED:` &&
               ` updateShowSideContentButtonVisibility is reproduced only by its breakpoint half. The original computes !(breakpoint === 'S' || oDSC.isSideContentVisible()), i.e. it also hides the 'Open Side Content'` &&
               ` button whenever the side content happens to be visible; isSideContentVisible() is client state the backend cannot read. The port keeps the button's visibility bound to the breakpoint (visible unless` &&
               ` 'S') and flips the same flag in the two press handlers (hide -> button shows, show -> button hides), which matches the original in every path the sample offers - but a side-content visibility change`.
    lv_text1 = lv_text1 && ` caused by anything else (e.g. the Toggle button) does not update it. // NOTE: **e2e-verified 2026-08-01** (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): the feed list renders` &&
               ` all four feed.json rows, the side content's Close button hides the side content through the SIDE_CONTENT_HIDE follow-up action (setShowSideContent false), the Open Side Content button then shows (its` &&
               ` visible flag comes from the breakpointChanged round-trip) and brings it back through SIDE_CONTENT_SHOW. Residual (nothing headless can assert): the FeedListItem layout with its remote author` &&
               ` pictures, and toggle() on a real S-breakpoint device.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.DynamicSideContent`      name = `DynamicSideContentProduct`                     class = `z2ui5_cl_dmo_app_269` path = `src/02/b14/z2ui5_cl_dmo_app_269.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.30`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.FixFlex`                 name = `FixFlexFixedSize`                              class = `z2ui5_cl_dmo_app_338` path = `src/02/b18/z2ui5_cl_dmo_app_338.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.25.0` ) ).

    lv_text1 = `NOTE: The original binds the Image src against a separate 'img' JSON model ({img>/products/pic1}) loaded from sap/ui/demo/mock/img.json. abap2UI5 serves one default model, so the picture path is` &&
               ` folded into it and the src binds it directly (client->_bind( pic1 )) - the 'img>' prefix is dropped and the last path segment is identical, which structural-diff matches. The mock's host-relative` &&
               ` path is resolved to the OpenUI5 host (sdk.openui5.org) per the asset-URL rule. // NOTE: The sample's style.css (background colours on the FixFlex fixed/flexible areas, referenced by` &&
               ` class='fixFlexHorizontal') is loaded via the manifest in the original; abap2UI5 ships no separate css file, so it is injected via a core:HTML <style> node with the CSS braces escaped. This adds a` &&
               ` core:HTML control not present in the original view - an extra control IS flagged by structural-diff (control extra), declared here by name.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.FixFlex`                 name = `FixFlexHorizontal`                             class = `z2ui5_cl_dmo_app_219` path = `src/02/b10/z2ui5_cl_dmo_app_219.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.25.0`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.FixFlex`                 name = `FixFlexMinFlexSize`                            class = `z2ui5_cl_dmo_app_215` path = `src/02/b10/z2ui5_cl_dmo_app_215.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.25.0` ) ).

    lv_text1 = `NOTE: The named-model image path (img>/products/pic1) is resolved to the static OpenUI5 product image https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg (the` &&
               ` mock's actual pic1 value, host-absolutized; wrong-neighbour HT-1000 copy fixed by the 2026-07-24 data audit). Image.src carries the static value where the original binds {img>/products/pic1} - the` &&
               ` app-006 static-fold class. // NOTE: The sample's css/style.css (the .fixFlexVertical > .sapUiFixFlexFixed / .sapUiFixFlexFlexible background colours, loaded via the manifest resources.css) is` &&
               ` INJECTED since 2026-08-05 through a core:HTML content attribute - the documented way to carry a stylesheet into an abap2UI5 view (CAPABILITIES 'Custom CSS', apps 026/028). The class attributes were` &&
               ` already 1:1, so the decorative backgrounds are back; the core:HTML leaf is the one control the original view does not declare. The 2026-07-27 review flagged exactly this as rework.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.FixFlex`                 name = `FixFlexVertical`                               class = `z2ui5_cl_dmo_app_119` path = `src/02/b01/z2ui5_cl_dmo_app_119.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.25.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // NOTE: the Edit button starts enabled="true" instead of the original's enabled="false" plus attachRequestCompleted: the ABAP model` &&
               ` is seeded synchronously in model_init, so the state the original reaches after the mock request completes is the state the port starts in. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel` &&
               ` round-trips (form swap through the bound visible flags and the Cancel restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.Form`               name = `Form_Column_oneGroup`                          class = `z2ui5_cl_dmo_app_320` path = `src/02/b18/z2ui5_cl_dmo_app_320.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // NOTE: the Edit button starts enabled="true" instead of the original's enabled="false" plus attachRequestCompleted: the ABAP model` &&
               ` is seeded synchronously in model_init, so the state the original reaches after the mock request completes is the state the port starts in. // NOTE: the fragments bind {EMail} while the mock key is` &&
               ` Email, so in the original that field renders empty. The port binds the real Email value (john.smith@sap.com) - structural-diff matches either way (it compares the last path segment` &&
               ` case-insensitively), but the address is actually shown here. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel round-trips (form swap through the bound visible flags and the Cancel` &&
               ` restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.Form`               name = `Form_Column_oneGroup234`                       class = `z2ui5_cl_dmo_app_321` path = `src/02/b18/z2ui5_cl_dmo_app_321.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // NOTE: the Edit button starts enabled="true" instead of the original's enabled="false" plus attachRequestCompleted: the ABAP model` &&
               ` is seeded synchronously in model_init, so the state the original reaches after the mock request completes is the state the port starts in. // NOTE: the fragments bind {EMail} while the mock key is` &&
               ` Email, so in the original that field renders empty. The port binds the real Email value (john.smith@sap.com) - structural-diff matches either way (it compares the last path segment` &&
               ` case-insensitively), but the address is actually shown here. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel round-trips (form swap through the bound visible flags and the Cancel` &&
               ` restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.Form`               name = `Form_Column_threeGroups234`                    class = `z2ui5_cl_dmo_app_322` path = `src/02/b18/z2ui5_cl_dmo_app_322.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // NOTE: the Edit button starts enabled="true" instead of the original's enabled="false" plus attachRequestCompleted: the ABAP model` &&
               ` is seeded synchronously in model_init, so the state the original reaches after the mock request completes is the state the port starts in. // NOTE: the fragments bind {EMail} while the mock key is` &&
               ` Email, so in the original that field renders empty. The port binds the real Email value (john.smith@sap.com) - structural-diff matches either way (it compares the last path segment` &&
               ` case-insensitively), but the address is actually shown here. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel round-trips (form swap through the bound visible flags and the Cancel` &&
               ` restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.Form`               name = `Form_Column_threeGroups346`                    class = `z2ui5_cl_dmo_app_323` path = `src/02/b18/z2ui5_cl_dmo_app_323.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // NOTE: the Edit button starts enabled="true" instead of the original's enabled="false" plus attachRequestCompleted: the ABAP model` &&
               ` is seeded synchronously in model_init, so the state the original reaches after the mock request completes is the state the port starts in. // NOTE: the fragments bind {EMail} while the mock key is` &&
               ` Email, so in the original that field renders empty. The port binds the real Email value (john.smith@sap.com) - structural-diff matches either way (it compares the last path segment` &&
               ` case-insensitively), but the address is actually shown here. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel round-trips (form swap through the bound visible flags and the Cancel` &&
               ` restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.Form`               name = `Form_Column_twoGroups234`                      class = `z2ui5_cl_dmo_app_324` path = `src/02/b18/z2ui5_cl_dmo_app_324.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches; the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets edit/save/cancel visible` &&
               ` imperatively; the port binds those three visible attributes to the same edit_mode flag (expression binding for the negated Edit case). handleEditPress clones the record into six server-side backup` &&
               ` fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads sap/ui/demo/mock/supplier.json and does` &&
               ` bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound ABSOLUTELY (client->_bind( suppliername )`.
    lv_text1 = lv_text1 && ` etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. The two composite Texts ({Street} {HouseNumber}, {ZIPCode} {City}) keep their` &&
               ` composite form with the absolute paths. // NOTE: the Edit button starts enabled="true" instead of the original's enabled="false" plus attachRequestCompleted: the ABAP model is seeded synchronously in` &&
               ` model_init, so the state the original reaches after the mock request completes is the state the port starts in. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel round-trips (form swap` &&
               ` through the bound visible flags and the Cancel restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.Form`               name = `Form354`                                       class = `z2ui5_cl_dmo_app_312` path = `src/02/b18/z2ui5_cl_dmo_app_312.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches; the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets edit/save/cancel visible` &&
               ` imperatively; the port binds those three visible attributes to the same edit_mode flag (expression binding for the negated Edit case). handleEditPress clones the record into six server-side backup` &&
               ` fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads sap/ui/demo/mock/supplier.json and does` &&
               ` bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound ABSOLUTELY (client->_bind( suppliername )`.
    lv_text1 = lv_text1 && ` etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. The two composite Texts ({Street} {HouseNumber}, {ZIPCode} {City}) keep their` &&
               ` composite form with the absolute paths. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel round-trips (form swap through the bound visible flags and the Cancel restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.Form`               name = `Form354wide`                                   class = `z2ui5_cl_dmo_app_313` path = `src/02/b18/z2ui5_cl_dmo_app_313.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches; the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets edit/save/cancel visible` &&
               ` imperatively; the port binds those three visible attributes to the same edit_mode flag (expression binding for the negated Edit case). handleEditPress clones the record into six server-side backup` &&
               ` fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads sap/ui/demo/mock/supplier.json and does` &&
               ` bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound ABSOLUTELY (client->_bind( suppliername )`.
    lv_text1 = lv_text1 && ` etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. The two composite Texts ({Street} {HouseNumber}, {ZIPCode} {City}) keep their` &&
               ` composite form with the absolute paths. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel round-trips (form swap through the bound visible flags and the Cancel restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.Form`               name = `Form354wideDual`                               class = `z2ui5_cl_dmo_app_314` path = `src/02/b18/z2ui5_cl_dmo_app_314.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel round-trips (form swap through the bound visible flags and the Cancel` &&
               ` restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.Form`               name = `Form471`                                       class = `z2ui5_cl_dmo_app_315` path = `src/02/b18/z2ui5_cl_dmo_app_315.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel round-trips (form swap through the bound visible flags and the Cancel` &&
               ` restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.Form`               name = `Form480`                                       class = `z2ui5_cl_dmo_app_316` path = `src/02/b18/z2ui5_cl_dmo_app_316.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // NOTE: the fragments bind {EMail} while the mock key is Email, so in the original that field renders empty. The port binds the real` &&
               ` Email value (john.smith@sap.com) - structural-diff matches either way (it compares the last path segment case-insensitively), but the address is actually shown here. // LIVE-TEST: not yet run in a` &&
               ` system: the Edit/Save/Cancel round-trips (form swap through the bound visible flags and the Cancel restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.Form`               name = `Form480_12120`                                 class = `z2ui5_cl_dmo_app_317` path = `src/02/b18/z2ui5_cl_dmo_app_317.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel round-trips (form swap through the bound visible flags and the Cancel` &&
               ` restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.Form`               name = `Form480_12120Dual`                             class = `z2ui5_cl_dmo_app_318` path = `src/02/b18/z2ui5_cl_dmo_app_318.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // NOTE: the fragments bind {EMail} while the mock key is Email, so in the original that field renders empty. The port binds the real` &&
               ` Email value (john.smith@sap.com) - structural-diff matches either way (it compares the last path segment case-insensitively), but the address is actually shown here. // NOTE: Rating` &&
               ` (RatingIndicator.value) and Disposable (ProgressIndicator.percentValue) are numeric UI5 properties, so their ABAP fields are typed i, not string - a bound value that serializes as a JSON string is` &&
               ` rejected on a numeric property. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel round-trips (form swap through the bound visible flags and the Cancel restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.Form`               name = `Form480_Trial`                                 class = `z2ui5_cl_dmo_app_319` path = `src/02/b18/z2ui5_cl_dmo_app_319.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.Form`               name = `FormToolbar`                                   class = `z2ui5_cl_dmo_app_142` path = `src/02/b06/z2ui5_cl_dmo_app_142.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16.0`
        notes = `NOTE: sap.ui.layout.form.Form with two FormContainers, per-container toolbars, ResponsiveGridLayout, FormElements with GridData layoutData and a Select. The original bound an element context` &&
                 ` (/SupplierCollection/0 from the shared demo supplier.json); flattened here to top-level model fields the {…} bindings resolve against. **Corrected 2026-08-01**: those bindings were written RELATIVE` &&
                 ` ({FIELD}) and a relative path on a control with no binding context resolves against nothing — the fields rendered EMPTY in the running app (measured with the e2e harness, the app-207 class). They are` &&
                 ` now bound ABSOLUTELY through client->_bind( field ), which is what a root-seeded record needs.` ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // NOTE: the Edit button starts enabled="true" instead of the original's enabled="false" plus attachRequestCompleted: the ABAP model` &&
               ` is seeded synchronously in model_init, so the state the original reaches after the mock request completes is the state the port starts in. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel` &&
               ` round-trips (form swap through the bound visible flags and the Cancel restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.SimpleForm`         name = `SimpleForm_Column_oneGroup`                    class = `z2ui5_cl_dmo_app_333` path = `src/02/b18/z2ui5_cl_dmo_app_333.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // NOTE: the Edit button starts enabled="true" instead of the original's enabled="false" plus attachRequestCompleted: the ABAP model` &&
               ` is seeded synchronously in model_init, so the state the original reaches after the mock request completes is the state the port starts in. // NOTE: the fragments bind {EMail} while the mock key is` &&
               ` Email, so in the original that field renders empty. The port binds the real Email value (john.smith@sap.com) - structural-diff matches either way (it compares the last path segment` &&
               ` case-insensitively), but the address is actually shown here. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel round-trips (form swap through the bound visible flags and the Cancel` &&
               ` restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.SimpleForm`         name = `SimpleForm_Column_oneGroup234`                 class = `z2ui5_cl_dmo_app_334` path = `src/02/b18/z2ui5_cl_dmo_app_334.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // NOTE: the Edit button starts enabled="true" instead of the original's enabled="false" plus attachRequestCompleted: the ABAP model` &&
               ` is seeded synchronously in model_init, so the state the original reaches after the mock request completes is the state the port starts in. // NOTE: the fragments bind {EMail} while the mock key is` &&
               ` Email, so in the original that field renders empty. The port binds the real Email value (john.smith@sap.com) - structural-diff matches either way (it compares the last path segment` &&
               ` case-insensitively), but the address is actually shown here. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel round-trips (form swap through the bound visible flags and the Cancel` &&
               ` restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.SimpleForm`         name = `SimpleForm_Column_threeGroups234`              class = `z2ui5_cl_dmo_app_335` path = `src/02/b18/z2ui5_cl_dmo_app_335.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // NOTE: the Edit button starts enabled="true" instead of the original's enabled="false" plus attachRequestCompleted: the ABAP model` &&
               ` is seeded synchronously in model_init, so the state the original reaches after the mock request completes is the state the port starts in. // NOTE: the fragments bind {EMail} while the mock key is` &&
               ` Email, so in the original that field renders empty. The port binds the real Email value (john.smith@sap.com) - structural-diff matches either way (it compares the last path segment` &&
               ` case-insensitively), but the address is actually shown here. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel round-trips (form swap through the bound visible flags and the Cancel` &&
               ` restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.SimpleForm`         name = `SimpleForm_Column_threeGroups346`              class = `z2ui5_cl_dmo_app_336` path = `src/02/b18/z2ui5_cl_dmo_app_336.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // NOTE: the Edit button starts enabled="true" instead of the original's enabled="false" plus attachRequestCompleted: the ABAP model` &&
               ` is seeded synchronously in model_init, so the state the original reaches after the mock request completes is the state the port starts in. // NOTE: the fragments bind {EMail} while the mock key is` &&
               ` Email, so in the original that field renders empty. The port binds the real Email value (john.smith@sap.com) - structural-diff matches either way (it compares the last path segment` &&
               ` case-insensitively), but the address is actually shown here. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel round-trips (form swap through the bound visible flags and the Cancel` &&
               ` restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.SimpleForm`         name = `SimpleForm_Column_twoGroups234`                class = `z2ui5_cl_dmo_app_337` path = `src/02/b18/z2ui5_cl_dmo_app_337.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // NOTE: the Edit button starts enabled="true" instead of the original's enabled="false" plus attachRequestCompleted: the ABAP model` &&
               ` is seeded synchronously in model_init, so the state the original reaches after the mock request completes is the state the port starts in. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel` &&
               ` round-trips (form swap through the bound visible flags and the Cancel restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.SimpleForm`         name = `SimpleForm354`                                 class = `z2ui5_cl_dmo_app_325` path = `src/02/b18/z2ui5_cl_dmo_app_325.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // NOTE: the Edit button starts enabled="true" instead of the original's enabled="false" plus attachRequestCompleted: the ABAP model` &&
               ` is seeded synchronously in model_init, so the state the original reaches after the mock request completes is the state the port starts in. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel` &&
               ` round-trips (form swap through the bound visible flags and the Cancel restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.SimpleForm`         name = `SimpleForm354wide`                             class = `z2ui5_cl_dmo_app_326` path = `src/02/b18/z2ui5_cl_dmo_app_326.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // NOTE: the Edit button starts enabled="true" instead of the original's enabled="false" plus attachRequestCompleted: the ABAP model` &&
               ` is seeded synchronously in model_init, so the state the original reaches after the mock request completes is the state the port starts in. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel` &&
               ` round-trips (form swap through the bound visible flags and the Cancel restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.SimpleForm`         name = `SimpleForm354wideDual`                         class = `z2ui5_cl_dmo_app_327` path = `src/02/b18/z2ui5_cl_dmo_app_327.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // NOTE: the Edit button starts enabled="true" instead of the original's enabled="false" plus attachRequestCompleted: the ABAP model` &&
               ` is seeded synchronously in model_init, so the state the original reaches after the mock request completes is the state the port starts in. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel` &&
               ` round-trips (form swap through the bound visible flags and the Cancel restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.SimpleForm`         name = `SimpleForm471`                                 class = `z2ui5_cl_dmo_app_328` path = `src/02/b18/z2ui5_cl_dmo_app_328.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // NOTE: the Edit button starts enabled="true" instead of the original's enabled="false" plus attachRequestCompleted: the ABAP model` &&
               ` is seeded synchronously in model_init, so the state the original reaches after the mock request completes is the state the port starts in. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel` &&
               ` round-trips (form swap through the bound visible flags and the Cancel restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.SimpleForm`         name = `SimpleForm480`                                 class = `z2ui5_cl_dmo_app_329` path = `src/02/b18/z2ui5_cl_dmo_app_329.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // NOTE: the fragments bind {EMail} while the mock key is Email, so in the original that field renders empty. The port binds the real` &&
               ` Email value (john.smith@sap.com) - structural-diff matches either way (it compares the last path segment case-insensitively), but the address is actually shown here. // LIVE-TEST: not yet run in a` &&
               ` system: the Edit/Save/Cancel round-trips (form swap through the bound visible flags and the Cancel restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.SimpleForm`         name = `SimpleForm480_12120`                           class = `z2ui5_cl_dmo_app_330` path = `src/02/b18/z2ui5_cl_dmo_app_330.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel round-trips (form swap through the bound visible flags and the Cancel` &&
               ` restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.SimpleForm`         name = `SimpleForm480_12120Dual`                       class = `z2ui5_cl_dmo_app_331` path = `src/02/b18/z2ui5_cl_dmo_app_331.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: _showFormFragment swaps the Page content between Display.fragment.xml and Change.fragment.xml (removeAllContent + insertContent). Both fragments are inlined into the one port view instead and` &&
               ` switched by the two-way bound edit_mode flag on each VBox's visible attribute, so no core:Fragment reference is left and the Page gains a content aggregation the original view.xml does not declare.` &&
               ` structural-diff unions both fragments into the original side, so the control set matches exactly (0 diffs); the added visible attributes carry the switch. // NOTE: _toggleButtonsAndView sets` &&
               ` edit/save/cancel visible imperatively; the port binds those three visible attributes to the same edit_mode flag (an expression binding for the negated Edit case). handleEditPress clones the record` &&
               ` into server-side backup fields so handleCancelPress can restore it exactly like the original's Object.assign clone; handleSavePress just leaves edit mode. // NOTE: the original loads` &&
               ` sap/ui/demo/mock/supplier.json and does bindElement('/SupplierCollection/0'); abap2UI5 serves one default model with no element binding, so the row-0 fields are seeded at the model root and bound`.
    lv_text1 = lv_text1 && ` ABSOLUTELY (client->_bind( suppliername ) etc.) rather than with the fragments' relative {SupplierName} - a relative path would have no context to resolve against. Composite texts such as {Street}` &&
               ` {HouseNumber} keep their composite form with the absolute paths. // NOTE: the fragments bind {EMail} while the mock key is Email, so in the original that field renders empty. The port binds the real` &&
               ` Email value (john.smith@sap.com) - structural-diff matches either way (it compares the last path segment case-insensitively), but the address is actually shown here. // NOTE: Rating` &&
               ` (RatingIndicator.value) and Disposable (ProgressIndicator.percentValue) are numeric UI5 properties, so their ABAP fields are typed i, not string - a bound value that serializes as a JSON string is` &&
               ` rejected on a numeric property. // LIVE-TEST: not yet run in a system: the Edit/Save/Cancel round-trips (form swap through the bound visible flags and the Cancel restore).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.SimpleForm`         name = `SimpleForm480_Trial`                           class = `z2ui5_cl_dmo_app_332` path = `src/02/b18/z2ui5_cl_dmo_app_332.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.SimpleForm`         name = `SimpleFormToolbar`                             class = `z2ui5_cl_dmo_app_175` path = `src/02/b10/z2ui5_cl_dmo_app_175.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16.0`
        notes = `NOTE: The original controller loads the shared demo supplier.json and element-binds a single record (/SupplierCollection/0); flattened here to top-level default-model fields the {…} SimpleForm` &&
                 ` bindings resolve against. Values are supplier.json SupplierCollection row 0 (Red Point Stores, Maintown); unbound columns (Tel, Sms, Rating, …) are dropped. **Corrected 2026-08-01**: those bindings` &&
                 ` were written RELATIVE ({FIELD}) and a relative path on a control with no binding context resolves against nothing — the fields rendered EMPTY in the running app (measured with the e2e harness, the` &&
                 ` app-207 class). They are now bound ABSOLUTELY through client->_bind( field ), which is what a root-seeded record needs.` ) ).

    lv_text1 = `NOTE: The eight Sliders drive their grid wrappers again since 2026-08-05. The original controller resizes the next wrapper by walking the DOM (oSlider.$().parent().next().find('.gridWrapper'), then` &&
               ` Element.closestTo(...).setWidth(value + '%')), but each wrapper is statically known in the view, so the pair is roundtrip-free: every Slider.value is two-way bound and the matching` &&
               ` VerticalLayout.width is an expression binding {= ${/SLIDER_VALUE_n} + '%' } - exactly how app 176 ports the same onSliderMoved idiom. The liveChange attribute stays dropped because the behaviour now` &&
               ` lives in the bindings; the 2026-07-27 review called the earlier 'no bindable equivalent' rationale wrong, and it was. // NOTE: The sample's styles.css (.GridDataSample .exampleDiv /` &&
               ` .propertiesDisplay / p) is injected via a single core:HTML <style> leaf as the first child of the outer VerticalLayout (abap2UI5 ships no separate css file). CSS braces are escaped \{ \} in a` &&
               ` backtick literal so the backslash survives to the serialized attribute, otherwise the XMLView binding parser would read them as bindings and crash view creation. This adds one core:HTML control not`.
    lv_text1 = lv_text1 && ` present in the original view.xml. // NOTE: The core:HTML 'content' divs and the FormattedText 'htmlText' are written as the decoded literal markup (e.g. <div class=exampleDiv></div>); the original` &&
               ` view.xml carries them HTML-entity-encoded (&lt;div ...&gt;) and the builder re-escapes the literal on stringify. Multi-line div contents in the original are written single-line here (whitespace-only` &&
               ` difference, not a binding).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.Grid`                    name = `GridData`                                      class = `z2ui5_cl_dmo_app_169` path = `src/02/b10/z2ui5_cl_dmo_app_169.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.15.0`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.Grid`                    name = `GridInfo`                                      class = `z2ui5_cl_dmo_app_194` path = `src/02/b10/z2ui5_cl_dmo_app_194.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.15.0` ) ).

    lv_text1 = `NOTE: The eleven Sliders lose their Slider.liveChange attribute: the original's onSliderMoved walks the DOM to find the NEXT grid wrapper (oSlider.$().parent().next().find('.gridWrapper')) and calls` &&
               ` setWidth(iValue + '%') on it. The port binds each Slider's value two-way instead and makes the matching wrapper's width an expression binding over it - width="{= ${/SLIDERnn} + '%' }" - so the resize` &&
               ` happens entirely on the client, with no round-trip, no DOM walk and no frontend action. That is the bindable-property route the porting recipe asks for over an imperative setWidth` &&
               ` (sap.ui.layout.VerticalLayout.width is a plain bindable property). // NOTE: resources/styles.css (.GridPropertiesSample .exampleDiv and .contrastColor) is injected through an extra core:HTML <style>` &&
               ` leaf, so the port has 38 core:HTML controls where the original view has 37 - abap2UI5 ships no separate stylesheet. The CSS braces are escaped \{ \} in a backtick literal so the XMLView parser does` &&
               ` not read them as bindings; without the rules behind them the 37 example divs would render as unstyled empty boxes (the app-122/124 lesson). // LIVE-TEST: Unverified in a running system: whether the`.
    lv_text1 = lv_text1 && ` expression binding over the Slider value resizes its own wrapper live while dragging (it needs no round-trip, so it should follow the slider continuously, unlike the original's per-event DOM write).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.Grid`                    name = `GridProperties`                                class = `z2ui5_cl_dmo_app_345` path = `src/02/b19/z2ui5_cl_dmo_app_345.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.15.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The original binds against the default JSONModel (no named model); the InformationCollection array is reproduced 1:1 on the one abap2UI5 default model. The Grid binding={/InformationCollection}` &&
               ` element-binding and the index-relative child bindings ({0/introText1}, {3/ProductPicUrl2}, {1/ProductPicUrl}, {2/ProductPicUrl}, {1/ProductPicUrl2}, {0/Description1}, {0/Description2}) are kept` &&
               ` verbatim with upper-cased field names. // NOTE: Image asset URLs are host-prefixed to https://sdk.openui5.org/ per the project asset-URL rule: the static demoAppsTeaser.png src, and the bound` &&
               ` ProductPicUrl/ProductPicUrl2 values seeded in model_init (originally host-relative test-resources/ paths). // NOTE: **e2e-verified 2026-08-01** (scripts/e2e-smoke.mjs interaction, transpiled backend` &&
               ` + real browser): the Grid element-binding to the array path resolves against the serialized default model: the {0/INTROTEXT1} index-relative binding renders its real text in the running app.` &&
               ` Residual: the GridData breakpoint behaviour (visibleOnSmall / moveForward), which needs real viewport rendering.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.Grid`                    name = `GridXL`                                        class = `z2ui5_cl_dmo_app_226` path = `src/02/b10/z2ui5_cl_dmo_app_226.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.15.0`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.HorizontalLayout`        name = `HorizontalLayout`                              class = `z2ui5_cl_dmo_app_162` path = `src/02/b09/z2ui5_cl_dmo_app_162.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16.0`
        notes = `NOTE: The original uses a separate 'img' JSON model for the image src ({img>/products/pic1}) alongside the default model for the widths. abap2UI5 has one default model, so the picture path is folded` &&
                 ` into it and the src binds it directly - the 'img>' prefix is dropped and the path flattened to a single field (pic1); the last path segment is identical, which structural-diff matches. Widths use the` &&
                 ` desktop values (the original's phone branch is a client-only Device decision).` ) ).

    lv_text1 = `NOTE: The original keeps the three pane sizes in a separate 'sizes' JSON model ({sizes>/pane1}, {sizes>/pane2}, {sizes>/pane3}) bound on the three SplitterLayoutData.size properties and echoed in each` &&
               ` pane's Text label. abap2UI5 has one default model, so pane1/pane2/pane3 are folded into it and bound directly - the 'sizes>' prefix is dropped and the last path segment is identical, which` &&
               ` structural-diff matches. Same data, renders identically. // NOTE: The shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json) is inlined into model_init with the three columns the` &&
               ` sample binds - ProductId, Name and Quantity (the List's title/counter and the Select's Item key/text). Quantity is the mock integer; the full row set is kept. // NOTE: The two PaneContainer resize` &&
               ` handlers (resize='.onRootContainerResize' on the root container and resize='.onInnerContainerResize' on the inner one) compose an informational MessageToast listing the oldSizes/newSizes pane-size` &&
               ` arrays. **Reproduced roundtrip-free since 2026-08-05**: measured with scripts/probes/event-arg-expression-probe.mjs, ``.join( ',' )`` over an ARRAY-valued event parameter resolves inside an event`.
    lv_text1 = lv_text1 && ` arg, so both arrays travel into a client-composed toast with the original's two-line text (each guarded, since the first resize carries no oldSizes). The earlier rationale - 'an array-valued` &&
               ` container-resize event has no bound-model equivalent' - looked for a MODEL equivalent where the client expression was the answer.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.ResponsiveSplitter`      name = `ResponsiveSplitter`                            class = `z2ui5_cl_dmo_app_186` path = `src/02/b10/z2ui5_cl_dmo_app_186.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.38`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The Splitter's content areas become a BOUND aggregation over one model table, so the three declared areas and every area the buttons add come from the same place. structural-diff therefore sees` &&
               ` fewer declared controls than the original: Button 7 vs 5 and l:SplitterLayoutData 3 vs 1 - the three content Buttons with their three SplitterLayoutData collapse into one bound template (the four` &&
               ` action Buttons of the HorizontalLayout are unchanged). This is what lets btnAddContentArea / btnRemoveContentArea work without addContentArea/removeContentArea calls: they insert or delete a row. //` &&
               ` NOTE: showLayoutOptions( ) builds the whole options panel in JS (an HBox per content area with a title Text, 'Resizable:' + CheckBox, 'Size (CSS):' + Input, 'Min-Size: (in px)' + Input) and re-builds` &&
               ` it after every change. The port binds the mainOptions VerticalLayout's content to the SAME table with that HBox as its template, so the option row and the layout data are two views of one model row -`.
    lv_text1 = lv_text1 && ` a CheckBox or Size Input writes straight into the SplitterLayoutData with no per-row change closure. structural-diff reports the added controls the original view does not declare: HBox, CheckBox, two` &&
               ` Input and four more Text (five vs one). // NOTE: Min-Size needs one round-trip and gets one: sap.ui.layout.SplitterLayoutData.minSize is an INTEGER while sap.m.Input.value is a string, so the row` &&
               ` carries both (minsize_text bound to the Input, minsize bound to the layout data) and the Input's change event triggers the parse - the ABAP equivalent of the original's` &&
               ` parseInt(oEvent.getParameter('value')). No row index has to travel: the whole table returns two-way, so the handler re-parses every row. Size and Resizable need no event at all - they are plain` &&
               ` two-way bindings shared by the Input/CheckBox and the layout data. // NOTE: btnChangeOrientation flips Splitter.orientation, which IS a bindable property, so the port binds it and flips the model` &&
               ` field instead of calling the setter (the prefer-a-bindable-property rule). btnInvalidateSplitter has no bindable equivalent - invalidate( ) forces a re-render without changing a property - so it`.
    lv_text1 = lv_text1 && ` stays a follow_up_action control_by_id mainSplitter/invalidate; invalidate is a public control method that does not match the FrontendAction deny regex. The Splitter's resize event is wired to the` &&
               ` backend, which increments the counter and writes the timestamped 'Resize # n' text the original's handler writes. // IMPROVISED: createExampleContent randomizes the added area (Math.random for size` &&
               ` 'auto' vs 50-350px and for maxSize), which the corpus does not reproduce - the port alternates deterministically between 'auto' and '150px' so it renders the same every run. Its maxSize is dropped` &&
               ` entirely for a different reason: sap.ui.layout.SplitterLayoutData has NO maxSize property (the original's object literal sets a key the control ignores), and writing it makes XMLView.create reject` &&
               ` the view. Its height="100%" is dropped too - the bound Button template is shared with the three declared areas, which set only width. // NOTE: css/splitter.css (.options, .options .paddingRight,` &&
               ` .optionTitle) is injected through an extra core:HTML <style> leaf, since abap2UI5 ships no separate stylesheet; the class names are on the controls the original also puts them on. The eventStatus`.
    lv_text1 = lv_text1 && ` Text keeps its 'Nothing happened so far...' initial label, and the resize timestamp uses the ABAP system date/time in the user's format where the original uses UI5Date.getInstance().toLocaleString()` &&
               ` - a real event timestamp, not an anchored one. // LIVE-TEST: Unverified in a running system: whether inserting/deleting a row re-renders the bound contentAreas aggregation, whether the shared table` &&
               ` keeps the option row and the layout data in sync while dragging a splitter bar, and the control_by_id invalidate wire.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.Splitter`                name = `Splitter`                                      class = `z2ui5_cl_dmo_app_351` path = `src/02/b19/z2ui5_cl_dmo_app_351.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.22.0`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.Splitter`                name = `Splitter2`                                     class = `z2ui5_cl_dmo_app_125` path = `src/02/b02/z2ui5_cl_dmo_app_125.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.Splitter`                name = `Splitter3`                                     class = `z2ui5_cl_dmo_app_339` path = `src/02/b18/z2ui5_cl_dmo_app_339.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.Splitter`                name = `Splitter4`                                     class = `z2ui5_cl_dmo_app_340` path = `src/02/b18/z2ui5_cl_dmo_app_340.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0`
        notes = `NOTE: the original view writes minSize="200px" on the third SplitterLayoutData, but sap.ui.layout.SplitterLayoutData.minSize is typed int - UI5 cannot parse the px suffix. The port writes the numeric` &&
                 ` value 200 the original means.` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.Splitter`                name = `SplitterNested1`                               class = `z2ui5_cl_dmo_app_266` path = `src/02/b14/z2ui5_cl_dmo_app_266.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0` ) ).

    lv_text1 = `NOTE: The original binds the image src against a separate 'img' JSON model ({img>/products/pic1} from sap/ui/demo/mock/img.json) alongside the default model for the widths. abap2UI5 has one default` &&
               ` model, so the picture path is folded into it and the src binds it directly (client->_bind( pic1 )) - the 'img>' prefix is dropped, the last path segment (pic1) is identical and the value is the` &&
               ` mock's own HT-7777-large.jpg absolutized on the sanctioned sdk.openui5.org host, so this is the same-data prefix-drop NOTE case (retyped from IMPROVISED per the settled 2026-07-24 policy). // NOTE:` &&
               ` live-verified 2026-08-04 (nightly e2e interaction): The original computes widthS/M/L from Device.system.phone in the controller (phone: 2/4/6em, else 5/10/15em). The bindings {/widthS..L} are ported` &&
               ` 1:1 on the default model and the seed reproduces the device branch server-side from client->get( )-s_device-system (app 012 precedent, review fix 2026-07-27); the phone-branch seeding is unverified` &&
               ` in a running system.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.layout`      control = `sap.ui.layout.VerticalLayout`          name = `VerticalLayout`                                class = `z2ui5_cl_dmo_app_173` path = `src/02/b10/z2ui5_cl_dmo_app_173.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.16.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: Both filters are applied in ABAP and the Table binds the RESULT, so the controller's Filter objects and its binding.filter( ) calls become one server-side selection - the thin-frontend move. The` &&
               ` SearchField's query filters Name OR Status (the original's _oTxtFilter), the facet selections are ANDed across the two lists and ORed inside each one (its _oFacetFilter), and only a list with a` &&
               ` selection takes part - exactly the two nested Filter groups. handleFacetFilterReset clears every selection and clearAllFilters (the noData Link) clears both filters at once. // NOTE: handleListClose` &&
               ` reads the selected items off the control; the port binds each FacetFilterItem's selected flag two-way instead (an added attribute), so listClose only has to tell the backend that the flags are back -` &&
               ` the app-022 idiom. FacetFilterList.key and FacetFilterItem.key are bound to {TYPE} and {TEXT} rather than the original's {key}: the mock's /ProductCollectionStats/Filters carries no ``key`` field at`.
    lv_text1 = lv_text1 && ` all (the original's binding resolves to nothing), and the list's type / the value's text ARE the identity the filter works on. // NOTE: The named ``ui>`` model (filterValue) is folded onto the one` &&
               ` default model, prefix dropped and leaf name kept. /ProductCollectionStats/Filters is inlined verbatim - both facet lists (Category with 16 values, SupplierName with 12) with their counts. The full` &&
               ` 123-row catalog is returned by a method rather than held in a public attribute: only the filtered rows are bound, so only they belong in the model that travels on every round-trip (the overview-app` &&
               ` lesson in AGENTS section 10). The controller's formatAvailableToObjectState is precomputed into the AVAILABLESTATE column, since business logic belongs in the backend. // IMPROVISED: The footer` &&
               ` OverflowToolbar stays empty: onInit lazily requires sap/ui/table/sample/TableExampleUtils and appends a ToolbarSpacer plus its createInfoButton( ) to it. That helper lives in the demo kit's own` &&
               ` sample folder, not in any UI5 library, and only opens a popover pointing at the sample's source. Every sap.ui.table sample of this batch drops it the same way. // LIVE-TEST: Unverified in a running`.
    lv_text1 = lv_text1 && ` system: whether the two-way bound FacetFilterItem selected flags return with the listClose round-trip and produce the expected server-side selection, and whether the noData Link appears when the` &&
               ` filters leave no rows.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                    name = `Aggregations`                                  class = `z2ui5_cl_dmo_app_352` path = `src/02/b20/z2ui5_cl_dmo_app_352.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: Rebuilt 1:1 from the breadth probe 2026-08-05: all THIRTEEN columns (Text/Input/Label/ObjectStatus/u:Currency/ComboBox/Link/Button/CheckBox/Select/MultiInput/c:Icon/DatePicker templates) over` &&
               ` the full 123-row /ProductCollection of the shared demo mock (sap/ui/demo/mock/products.json), with the Suppliers and Categories arrays the controller derives from it in initSampleDataModel.` &&
               ` ProductPicUrl values are absolutized to the OpenUI5 host (https://sdk.openui5.org/test-resources/...) per the asset-URL rule; the mock carries them host-relative. // NOTE: The controller's two` &&
               ` formatters (Available -> 'Success'/'Error' via ObjectStatus.state, Available -> 'sap-icon://accept'/'sap-icon://decline' via Icon.src) are computed in ABAP into the derived fields AVAILABLESTATE /` &&
               ` AVAILABLEICON and bound plainly (thin-frontend rule). The Available and Heavy fields initSampleDataModel derives (Status === 'Available', WeightMeasure > 1000) are derived in model_init the same way;` &&
               ` Heavy stays a STRING because the CheckBox binding declares type 'sap.ui.model.type.String' in the original. // NOTE: DeliveryDate: the original computes Date.now() - (i % 10 * 4 days), a moving`.
    lv_text1 = lv_text1 && ` value, so it is anchored on a FIXED base date here (the corpus rule for now/random values, apps 164/181/289) and carried as an ISO date STRING rather than a JS epoch number. The DatePicker keeps its` &&
               ` typed binding (sap.ui.model.type.Date) but its formatOptions source pattern becomes 'yyyy-MM-dd' instead of 'timestamp' - the model field type changed, the control binding did not (CAPABILITIES date` &&
               ` row). // NOTE: The MultiInput's suggestionItems template carries key="{ProductId}" in the original although it is bound over /Categories, whose rows only have a Name - so a token added from a` &&
               ` suggestion gets an empty key there. The quirk is ported verbatim (key={PRODUCTID}) rather than repaired; the tokenUpdate handler mirrors the original's filter-by-removed-key, which drops the` &&
               ` empty-key tokens together, and additionally gates on the event's update type ('removed') because the original recomputes from the post-update token list instead of reacting to a type. // NOTE: The` &&
               ` controller's three handlers are all display-only and resolve on the client: handleDetailsPress toasts the row's ProductId, onPaste toasts the pasted data - both composed through control_global`.
    lv_text1 = lv_text1 && ` MESSAGE_TOAST with the row/parameter value as an event argument, so neither needs a round-trip. updateMultipleSelection genuinely mutates the model, so it stays a backend event (TOKEN_UPDATE): the` &&
               ` removed token key and the row's binding context path travel and ABAP deletes the row's token entry. // 1.71: sap.m.plugins.ColumnAIAction (@since 1.136, on the Product Name column, with the` &&
               ` controller's onAIActionPress opening an AI-hint dialog) is dropped: sap.m.plugins does not exist in UI5 1.71, which the corpus targets. The column itself is present, only the plugin aggregation and` &&
               ` its press handler are missing.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                    name = `Basic`                                         class = `z2ui5_cl_dmo_app_115` path = `src/02/b01/z2ui5_cl_dmo_app_115.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: onColumnResize is reproduced 1:1 since 2026-08-05, when the framework gained s_ctrl-prevent_default_expr (pr/conditional-prevent-default, implemented upstream). The original vetoes resizing ONE` &&
               ` column (byId('deliverydate')) and reports every other one; the flag form of the veto is baked per WIRE at render time and would have frozen the whole table, so the port carries the condition as a` &&
               ` client expression instead: ``${$parameters>/column}.getId().indexOf('deliverydate') >= 0``. The event is sent either way (that is eBP's contract), so the if/else of the original's handler lives in` &&
               ` on_event: the vetoed column reports nothing, every other one gets the sample's own text with its LABEL and the new width, both transported off the event parameter. Two things the earlier reduction` &&
               ` dropped are therefore back - the per-column veto and the column label. What stays dropped is the 50ms BUFFER: the original collects the messages of a burst and toasts them joined, a debounce with no` &&
               ` abap2UI5 equivalent, so each resize toasts on its own. The toast also moved from a client MESSAGE_TOAST to the backend, because the decision whether to toast at all is the same if/else.`.
    lv_text1 = lv_text1 && ` **e2e-verified 2026-08-06** (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): one wire, two columns, opposite outcomes - firing columnResize on the delivery-date column returns` &&
               ` false (vetoed) and on any other column returns true, and the non-vetoed one toasts its label and width. // NOTE: Named-model fold with a nested config object: the original binds each Column width to` &&
               ` the ui>/widths/{name,category,image,quantity,date} single object on a separate JSONModel. abap2UI5 has one default model; a nested single-object bind is proven only for row-relative sub-paths` &&
               ` (CAPABILITIES 'Nested single (non-array) structure', app 171) - a top-level struct-component _bind is unproven in this corpus, and writing '/WIDTHS/NAME' as a literal path is disallowed. So the` &&
               ` widths object is folded to five top-level string fields named exactly name/category/image/quantity/date (the sanctioned named-model prefix-drop idiom), each bound via client->_bind so the last path` &&
               ` segment still matches the original (structural-diff normalizes on the last segment). onColumnWidthsChange (SegmentedButton Static/Flexible/Mixed) is reproduced faithfully: the selected key is`.
    lv_text1 = lv_text1 && ` transported via ${$parameters>/item}.getKey() and the width set is recomputed in ABAP (thin-frontend) + view_model_update. // NOTE: DeliveryDate is seeded deterministically. The original computes` &&
               ` DeliveryDate = Date.now() - (i % 10 * 4 days) per load (non-deterministic timestamps); the port uses a fixed base (2026-07-25 in epoch ms) minus the same (i % 10 * 4 days) offset, kept as an epoch-ms` &&
               ` value bound through the original {path:'DeliveryDate', type:'sap.ui.model.type.Date', formatOptions:{source:{pattern:'timestamp'}}} typed binding. // NOTE: ProductPicUrl is resolved to the OpenUI5` &&
               ` host: the mock stores the host-relative 'test-resources/sap/ui/documentation/sdk/images/HT-xxxx.jpg'; the port stores the absolute 'https://sdk.openui5.org/test-resources/...' per the asset-URL rule,` &&
               ` keeping the original {ProductPicUrl} binding. Full 123-row ProductCollection inlined (Name/Category/ProductPicUrl/Quantity/DeliveryDate). // NOTE: **e2e-verified 2026-08-01** (scripts/e2e-smoke.mjs`.
    lv_text1 = lv_text1 && ` interaction, transpiled backend + real browser): the SegmentedButton width switch really round-trips: picking 'Flexible' sends WIDTHS_CHANGE with ${$parameters>/item}.getKey(), the backend recomputes` &&
               ` the widths and the Table's columns come back at 25%. The button sits in an OverflowToolbar, where it renders as a Select - drivable once the 'Additional Options' popover is open (AGENTS 10).` &&
               ` Residual: the columnResize client toast (a real column drag) and the timestamp-typed DeliveryDate formatting.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                    name = `ColumnResizing`                                class = `z2ui5_cl_dmo_app_247` path = `src/02/b12/z2ui5_cl_dmo_app_247.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    lv_text1 = `POST-1.71: sap.m.plugins.ContextMenuSetting (@since 1.121, scope="Selection") is kept 1:1 in both tables' dependents - it is what makes the table's context menu act on the selected row, which the` &&
               ` sample's two context menus rely on. Newer than UI5 1.71; declared per the fidelity-first property-171 policy, so the app needs a UI5 release >= 1.121. // NOTE: The original keeps ONE collection and` &&
               ` splits the two tables by a Rank filter (Rank = 0 available, Rank > 0 selected, sorted by Rank descending), moving a row by rewriting its Rank; the rank arithmetic (initialRank / defaultRank / the` &&
               ` Before-Between-After algorithm) exists only to encode an ORDER inside one array. With abap2UI5's one default model the port keeps two model tables instead, so a move is an insert plus a delete and` &&
               ` the row order IS the rank - same rendered result, no rank column. Consequently each Table's rows binding is a plain aggregation binding rather than the original's filters/sorter binding-info. //` &&
               ` NOTE: Both DragInfo/DragDropInfo lose their dragStart attribute: onDragStart only stashes the dragged row's binding context in the drag session so the drop handler can find it again, which is a`.
    lv_text1 = lv_text1 && ` client-side workaround for something the drop event already carries. The port ships it on the drop instead - ${$parameters>/draggedControl}.getIndex(), plus ${$parameters>/droppedControl}.getIndex()` &&
               ` and ${$parameters>/dropPosition} for table 2 - and does the move/reorder arithmetic in ABAP (the app-148 idiom). A fourth argument tells the two cases apart, because table 2 receives both an incoming` &&
               ` move and an internal reorder through the same handler: ${$parameters>/draggedControl}.getParent().getId().indexOf('table2') >= 0, an event arg being a full UI5 expression. Client indices are 0-based` &&
               ` and ABAP rows 1-based, and every index is range-checked before it is used as a table index - a nonsense index splices harmlessly in JS but dumps in ABAP (the app-148 lesson). // NOTE:` &&
               ` getSelectedRowContext reads the selected row off the control; the port mirrors it into the backend instead - each table's rowSelectionChange carries ${$parameters>/rowIndex}, and` &&
               ` onBeforeOpenContextMenu (which the original uses to select the row under the cursor before opening the menu) carries the same parameter. The two arrow buttons and the context-menu items then work off`.
    lv_text1 = lv_text1 && ` that, with the original's 'Please select a row!' toast when nothing is selected. moveUp/moveDown become an index swap in the selected table, which is what the original's Between-rank arithmetic` &&
               ` achieves. // IMPROVISED: The footer info button is dropped: onInit lazily requires sap/ui/table/sample/TableExampleUtils and appends a ToolbarSpacer plus its createInfoButton( ) to the toolbar. That` &&
               ` helper lives in the demo kit's own sample folder, not in any UI5 library, and only opens a popover pointing at the sample's source. Every sap.ui.table sample of this batch drops it the same way. //` &&
               ` NOTE: The shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json) is inlined with the three columns both tables bind; every product starts in the available table, which is exactly what` &&
               ` the original's initialRank = 0 means. The Quantity columns keep the original's typed complex binding with the path switched to the ABAP field. // LIVE-TEST: Unverified in a running system: whether` &&
               ` the drop wires deliver the row indices and drop position as expected, whether the internal-vs-external drag expression resolves, and whether the context menu's beforeOpenContextMenu round-trip`.
    lv_text1 = lv_text1 && ` arrives before the menu item press.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                    name = `DnD`                                           class = `z2ui5_cl_dmo_app_353` path = `src/02/b20/z2ui5_cl_dmo_app_353.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.plugins.ContextMenuSetting (@since 1.121, scope="Selection") is kept 1:1 in both tables' dependents - it is what makes the table's context menu act on the selected row, which the sample's two` &&
                 ` context menus rely on. Newer than UI5 1.71; declared per the fidelity-first property-171 policy, so the app needs a UI5 release >= 1.121.` ) ).

    lv_text1 = `NOTE: Every filter of this sample is applied in ABAP and the Table binds the RESULT, so the controller's Filter objects and its binding.filter( ) calls become one server-side selection - the` &&
               ` thin-frontend move. The global SearchField filter (Name OR Category contains the query), the availability toggle and the price band are ANDed exactly as _filter( ) combines them, and clearAllFilters` &&
               ` resets all three. The Table's filter event carries the pressed column's filterProperty and the entered value (${$parameters>/column}.getFilterProperty() and ${$parameters>/value}) and sets` &&
               ` s_ctrl-check_prevent_default: the original vetoes the built-in filter only for the price column, here the model is already the filtered result, so it is vetoed for every column. The price column` &&
               ` keeps its special rule - a +/- 20 BAND around the entered value rather than an exact match, which is the point of the original's filterPrice. // NOTE: The named ``ui>`` model (globalFilter,` &&
               ` availabilityFilterOn, cellFilterOn) is folded onto the one default model, prefix dropped and leaf names kept. cellFilterOn needs no handler at all - the ToggleButton's pressed and the Table's`.
    lv_text1 = lv_text1 && ` enableCellFilter bind the same field, which is what the original's two-way {ui>/cellFilterOn} binding already does. The availability ToggleButton keeps its pressed binding AND its press wire, because` &&
               ` pressing it has to re-run the server-side selection. The filterProperty values are the ABAP (upper-cased) field names, since that is what the backend switches on. // NOTE: The full 123-row catalog is` &&
               ` returned by a method rather than held in a public attribute: only the filtered rows are bound, so only they belong in the model that travels on every round-trip (the overview-app lesson in AGENTS` &&
               ` section 10). The controller's formatAvailableToObjectState is precomputed into the AVAILABLESTATE column, since business logic belongs in the backend, and the boolean Available is kept as its own` &&
               ` column because the availability filter needs it. ProductPicUrl values point at the OpenUI5 host per the asset-URL rule; the mock carries them host-relative. // IMPROVISED: The footer OverflowToolbar`.
    lv_text1 = lv_text1 && ` stays empty: onInit lazily requires sap/ui/table/sample/TableExampleUtils and appends a ToolbarSpacer plus its createInfoButton( ) to it. That helper lives in the demo kit's own sample folder, not in` &&
               ` any UI5 library, and only opens a popover pointing at the sample's source. Every sap.ui.table sample of this batch drops it the same way. // LIVE-TEST: Unverified in a running system: whether the` &&
               ` column filter event's prevented default plus the server-side selection show the expected rows, and whether the enableCellFilter binding lets a cell filter fire that same event.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                    name = `Filtering`                                     class = `z2ui5_cl_dmo_app_354` path = `src/02/b20/z2ui5_cl_dmo_app_354.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The two menu-entry toggles need no handler at all: each ToggleButton's pressed and the Table property it drives (enableColumnFreeze / enableCellFilter) bind the SAME field on the one default` &&
               ` model, which is exactly what the original's two-way {ui>/showFreezeMenuEntry} and {ui>/enableCellFilter} bindings do - only the ``ui>`` prefix is dropped. The port is therefore fully static apart` &&
               ` from the model: no on_event, no round-trip. // IMPROVISED: The three CONTROLLER-BUILT menus are dropped, and with them the third ToggleButton's press and the Table's beforeOpenContextMenu attribute.` &&
               ` (a) associateHeaderMenus creates a sap.m.table.columnmenu.Menu plus ActionItems in JS and associates it with the name/productId/quantity columns via setHeaderMenu - a control-returning factory, the` &&
               ` capability boundary CAPABILITIES marks as not expressible, and its two handlers (onQuantityCustomItemSelect, onQuantitySort) go with it. (b) onToggleContextMenu builds a sap.m.Menu with two bound` &&
               ` MenuItems and hands it to setContextMenu / destroyContextMenu; an aggregation of controls built at runtime has no bindable equivalent either. (c) onProductIdCellContextMenu builds a`.
    lv_text1 = lv_text1 && ` sap.ui.unified.Menu on the fly and opens it docked to the clicked cell's DOM ref. The columns, their sortProperty/filterProperty and the table's own header menus are unaffected - what is lost is the` &&
               ` sample's custom menu content. // NOTE: The shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json) is inlined with the five columns the sample binds. The original computes DeliveryDate` &&
               ` from Date.now() with an i-mod-10 offset in 4-day steps; a fixed base date (2026-07-23) is used here so the port is deterministic - the corpus convention of app 164. The Quantity and Delivery Date` &&
               ` columns keep the original's typed complex bindings with the path switched to the ABAP field, and sortProperty/filterProperty carry the ABAP (upper-cased) field names. ProductPicUrl values point at` &&
               ` the OpenUI5 host per the asset-URL rule. // IMPROVISED: The footer OverflowToolbar stays empty: onInit lazily requires sap/ui/table/sample/TableExampleUtils and appends a ToolbarSpacer plus its` &&
               ` createInfoButton( ) to it. That helper lives in the demo kit's own sample folder, not in any UI5 library, and only opens a popover pointing at the sample's source. Every sap.ui.table sample of this`.
    lv_text1 = lv_text1 && ` batch drops it the same way.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                    name = `Menus`                                         class = `z2ui5_cl_dmo_app_355` path = `src/02/b20/z2ui5_cl_dmo_app_355.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                    name = `MultiHeader`                                   class = `z2ui5_cl_dmo_app_137` path = `src/02/b05/z2ui5_cl_dmo_app_137.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: sap.ui.table grid Table with multi-level column headers (multiLabels + headerSpan '3,2'/'2') and an extension OverflowToolbar. The 5 contact rows are inlined from the controller's JSON model;` &&
                 ` column templates bind {SUPPLIER}/{STREET}/{CITY}/{PHONE}/{OPENORDERS} 1:1.` ) ).

    lv_text1 = `NOTE: The sample serves its rows from an in-page OData MockServer (sap/ui/core/util/MockServer over metadata.xml, autoRespondAfter 2000, operationMode Server, threshold 15). An abap2UI5 app has a real` &&
               ` ABAP backend, so the mock service is replaced by the model itself: all 115 rows of the sample's own ProductSet.json are inlined and the Table binds them directly. What that costs is the sample's` &&
               ` server-side paging illusion - the rows arrive in one model instead of in threshold-sized batches - and with it the enableBusyIndicator's visible effect; both attributes are kept 1:1 on the control.` &&
               ` ProductSet.json lives in the sibling OData sample folder upstream (the MockServer's sMockdataBaseUrl points there); it is archived into this sample's folder too so the port is verifiable offline. //` &&
               ` NOTE: The named ``config>`` model (limit, showHeaderSelector, selectionModes, selectionMode) is folded onto the one default model, prefix dropped and leaf names kept. Two of the three config controls`.
    lv_text1 = lv_text1 && ` then need no handler at all: the selection-mode Select's selectedKey and the plugin's selectionMode share one field, and the ToggleButton's pressed and the plugin's showHeaderSelector share another -` &&
               ` which is what the original's two-way {config>/...} bindings already do. The limit keeps its change wire because onLimitChange is not a plain setter: it validates the entry, and the port carries the` &&
               ` limit twice (an integer for the plugin, the Input's string next to it) because sap.m.Input.value is a string property while the plugin's limit is an integer - the original bridges that with a typed` &&
               ` binding, the port parses it in ABAP and snaps the Input back with the same message on a bad entry. // NOTE: onSelectionChange reads state that lives in the plugin, so the wire carries it:` &&
               ` ${$parameters>/limitReached} and ${$source>}.getSelectedIndices().length (an event arg is a full UI5 expression), and the backend composes the same three messages - 'Selection cleared.', 'n row(s)` &&
               ` selected.' and the limit-reached variant naming the current limit. // NOTE: The six column labels are metadata bindings in the original ({/#Product/Name/@sap:label} and friends), which only an OData`.
    lv_text1 = lv_text1 && ` model can resolve. They are replaced by the literal sap:label texts from the sample's own metadata.xml (Product Name, Product ID, Prod. Cat., Company Name, Unit Price, Dimensions) - the same strings` &&
               ` the OData model would have produced. sortProperty / filterProperty carry the ABAP (upper-cased) field names. The Price cell keeps the original's typed String binding and the dimensions cell its` &&
               ` {WIDTH}x{HEIGHT}x{DEPTH} {DIMUNIT} template; the numeric columns stay TYPE string so the mock's exact decimals survive (the display-only rule of the porting recipe). // POST-1.71:` &&
               ` sap.ui.table.plugins.MultiSelectionPlugin is @since 1.64 and in scope, but its enableNotification property is @since 1.71 and its selectionMode property @since 1.100; both are kept 1:1 since the` &&
               ` sample is about exactly this plugin. Declared per the fidelity-first property-171 policy, so the app needs a UI5 release >= 1.100. // LIVE-TEST: Unverified in a running system: whether the plugin` &&
               ` honours the bound limit / selectionMode / showHeaderSelector without a round-trip, and whether the selectionChange expression argument reports the selected count.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                    name = `MultiSelectionPlugin`                          class = `z2ui5_cl_dmo_app_356` path = `src/02/b20/z2ui5_cl_dmo_app_356.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.ui.table.plugins.MultiSelectionPlugin is @since 1.64 and in scope, but its enableNotification property is @since 1.71 and its selectionMode property @since 1.100; both are kept 1:1 since the` &&
                 ` sample is about exactly this plugin. Declared per the fidelity-first property-171 policy, so the app needs a UI5 release >= 1.100.` ) ).

    lv_text1 = `POST-1.71: sap.ui.table.Table.scrollThreshold (@since 1.128) is kept 1:1 from the sample's view - it is one of the two paging knobs (with threshold) this sample is about. Newer than UI5 1.71; declared` &&
               ` per the fidelity-first property-171 policy, so the app needs a UI5 release >= 1.128. // NOTE: The sample serves its rows from an in-page OData MockServer (sap/ui/core/util/MockServer over` &&
               ` metadata.xml, autoRespondAfter 2000, operationMode Server, threshold 15, scrollThreshold 50). An abap2UI5 app has a real ABAP backend, so the mock service is replaced by the model itself: all 115` &&
               ` rows of the sample's own ProductSet.json are inlined and the Table binds them directly. What that costs is the server-side paging illusion - the rows arrive in one model instead of in threshold-sized` &&
               ` batches - and with it the dataRequested/dataReceived handlers that swap the noData BusyIndicator in and out; the noData BusyIndicator, threshold, scrollThreshold and enableBusyIndicator are all kept` &&
               ` 1:1 on the control. // IMPROVISED: onOperationModeChange re-binds the rows with the picked sap.ui.model.odata.OperationMode (Server / Client / Auto) - a binding parameter of an OData model, which has`.
    lv_text1 = lv_text1 && ` no counterpart when the rows come from an ABAP model. The SegmentedButton is kept 1:1 with its three items and stays two-way bound, and picking a mode still re-reads the rows (which is the other half` &&
               ` of what the handler does, via onModelRefresh), but the mode itself no longer changes how the data is fetched. onModelRefresh's binding.refresh( true ) is the plain re-read. // NOTE: The named ``ui>``` &&
               ` model (operationModes, selectedOperationMode) is folded onto the one default model, prefix dropped and leaf names kept. The six column labels are metadata bindings in the original` &&
               ` ({/#Product/Name/@sap:label} and friends), which only an OData model can resolve; they are replaced by the literal sap:label texts from the sample's own metadata.xml (Product Name, Product ID,` &&
               ` Category, Supplier Company Name, Unit Price, Dimensions). sortProperty / filterProperty carry the ABAP (upper-cased) field names. The Price cell keeps the original's typed String binding and the` &&
               ` dimensions cell its {WIDTH}x{HEIGHT}x{DEPTH} {DIMUNIT} template; the numeric columns stay TYPE string so the mock's exact decimals survive. // IMPROVISED: The footer's info button is dropped: onInit`.
    lv_text1 = lv_text1 && ` lazily requires sap/ui/table/sample/TableExampleUtils and appends a ToolbarSpacer plus its createInfoButton( ) to the toolbar that also carries the operation-mode SegmentedButton. That helper lives` &&
               ` in the demo kit's own sample folder, not in any UI5 library, and only opens a popover pointing at the sample's source. Every sap.ui.table sample of this batch drops it the same way. // LIVE-TEST:` &&
               ` Unverified in a running system: whether the 115-row model renders with the sample's threshold/scrollThreshold settings, and whether the refresh and operation-mode round-trips re-read the rows.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                    name = `OData`                                         class = `z2ui5_cl_dmo_app_357` path = `src/02/b20/z2ui5_cl_dmo_app_357.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.ui.table.Table.scrollThreshold (@since 1.128) is kept 1:1 from the sample's view - it is one of the two paging knobs (with threshold) this sample is about. Newer than UI5 1.71; declared per the` &&
                 ` fidelity-first property-171 policy, so the app needs a UI5 release >= 1.128.` ) ).

    lv_text1 = `IMPROVISED: The original binds the Table.columns aggregation to the OData METAMODEL and builds every Column in a JS factory (columnFactory), so its view declares no columns at all. A control-returning` &&
               ` factory is the capability boundary CAPABILITIES marks as not expressible - and the decision it makes belongs in the backend anyway (thin frontend). The port therefore drops the Table.columns binding` &&
               ` attribute and writes out the twenty-one Columns the factory produces from the sample's own metadata.xml, with the same rules: visible unless sap:visible="false" or a unit-of-measure / currency-code` &&
               ` semantic, the width derived from maxLength (>50 -> 15rem, >9 -> 10rem, else 5rem, absent maxLength counting as 10), sortProperty / filterProperty only where sap:sortable / sap:filterable is true, End` &&
               ` alignment for the Edm.Decimal columns, the sap:label as the header text, and a u:Currency template for the one property whose sap:unit carries the currency-code semantic (Price over CurrencyCode) -`.
    lv_text1 = lv_text1 && ` every other one a plain non-wrapping Text. structural-diff therefore reports 21 extra Column, 21 extra m:Label, 20 extra m:Text and one extra u:Currency, all of them the controller-built ones. //` &&
               ` NOTE: The sample serves its rows from an in-page OData MockServer (sap/ui/core/util/MockServer over metadata.xml, autoRespondAfter 2000, threshold 15). An abap2UI5 app has a real ABAP backend, so the` &&
               ` mock service is replaced by the model itself: all 115 rows of ProductSet.json are inlined with every property the metadata declares, because the metadata-driven columns render all of them. What that` &&
               ` costs is the server-side paging illusion and with it the dataRequested/dataReceived handlers that swap the noData BusyIndicator in and out; the noData BusyIndicator, threshold and enableBusyIndicator` &&
               ` are kept 1:1 on the control. ProductSet.json lives in the sibling OData sample folder upstream (the MockServer's sMockdataBaseUrl points there); it is archived into this sample's folder too so the`.
    lv_text1 = lv_text1 && ` port is verifiable offline. The numeric columns stay TYPE string so the mock's exact decimals survive. // NOTE: Fully static port apart from the model: once the column factory is resolved in ABAP the` &&
               ` sample has no event at all, so the class is the app-051 shape (a bare check_on_init branch with model_init and view_display, no on_event).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                    name = `OData2`                                        class = `z2ui5_cl_dmo_app_358` path = `src/02/b20/z2ui5_cl_dmo_app_358.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    lv_text1 = `POST-1.71: sap.ui.table.RowSettings.navigated (@since 1.72) is used 1:1 - it is the property the sample's 'Toggle Navigated Indicators' button drives. Newer than UI5 1.71; declared per the` &&
               ` fidelity-first property-171 policy, so the app needs a UI5 release >= 1.72. // NOTE: The original builds a DIFFERENT RowAction template per mode in the controller (five handlers returning a fresh` &&
               ` RowAction with its RowActionItems, handed to setRowActionTemplate/setRowActionCount). Building controls at runtime is the capability boundary CAPABILITIES marks as not expressible, and the decision` &&
               ` behind it is data, so the port declares the UNION of the items once - Navigation, Delete, Attachment, Search, Edit, Analyze - and switches them with bound visible flags plus a bound rowActionCount` &&
               ` that the backend sets from the picked mode. Every mode renders exactly the items the original's handler would return: Navigation (1 action), Navigation & Delete, Navigation & Custom (the Edit item),` &&
               ` Multiple Actions (all four), No Actions (count 0). The Navigation item keeps the original's per-row visible="{Available}" condition, ANDed with the mode flag in an expression binding. structural-diff`.
    lv_text1 = lv_text1 && ` sees the rowActionTemplate subtree as added controls, which is what the controller built. // NOTE: onNavIndicatorsToggle sets or destroys a RowSettings template; the port declares the RowSettings` &&
               ` once and makes its navigated an expression binding over the ToggleButton's two-way bound state AND the row's own NavigatedState - so the toggle needs no handler at all and its press attribute goes` &&
               ` away. The original marks the SECOND product as navigated (i === 1), which the model reproduces. // NOTE: handleActionPress is client-composed and roundtrip-free: control_global MESSAGE_TOAST with` &&
               ` 'Item {0} pressed for product with id {1}', filled by ${$parameters>/item}.getText() || ${$parameters>/item}.getType() and ${$parameters>/row}.getBindingContext().getProperty('PRODUCTID') - the same` &&
               ` two values the original reads off the event, an event arg being a full UI5 expression. The named ``modes>`` model is folded onto the one default model, prefix dropped and leaf names kept. // NOTE:` &&
               ` The shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json) is inlined with the four columns the sample binds plus the derived Available flag the Navigation item's visible binding`.
    lv_text1 = lv_text1 && ` needs - the controller derives it the same way (Status === 'Available'). // LIVE-TEST: Unverified in a running system: whether the bound rowActionCount plus the per-item visible flags reproduce each` &&
               ` mode's row actions, and whether the two-argument client-composed toast fills both placeholders.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                    name = `RowAction`                                     class = `z2ui5_cl_dmo_app_359` path = `src/02/b20/z2ui5_cl_dmo_app_359.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.ui.table.RowSettings.navigated (@since 1.72) is used 1:1 - it is the property the sample's 'Toggle Navigated Indicators' button drives. Newer than UI5 1.71; declared per the fidelity-first` &&
                 ` property-171 policy, so the app needs a UI5 release >= 1.72.` ) ).

    lv_text1 = `NOTE: The three toolbar handlers imperatively mutate Table properties in the original controller: onSelectionModeChange calls setSelectionMode, onAlternateToggle calls setAlternateRowColors,` &&
               ` onHighlightToggle swaps the rowSettingsTemplate between a RowSettings and null. abap2UI5 is a thin frontend, so all three are reproduced as two-way property bindings on the one default model with no` &&
               ` round-trip (AGENTS section 5 / section 10 'prefer a bindable property'): the Select selectedKey and the Table selectionMode both bind SELECTION_MODE; the 'Toggle Alternate Row Colors' ToggleButton` &&
               ` pressed and the Table alternateRowColors both bind ALTERNATE_ROW_COLORS (the alternateRowColors attribute is added to the Table - it is not in the original view, which only sets it via the` &&
               ` controller); the 'Toggle Highlights' ToggleButton pressed binds SHOW_HIGHLIGHTS, which the RowSettings highlight reads through an expression binding {= ${/SHOW_HIGHLIGHTS} ? ${STATUS} : 'None'} to` &&
               ` reproduce the template-null hide. As a consequence the original event-handler attributes are dropped: the Select change and both ToggleButton press handlers are not emitted (their behaviour now lives`.
    lv_text1 = lv_text1 && ` in the bindings). // NOTE: The highlight state per row (RowSettings highlight={Status}, highlightText={StatusText}) is computed by the original controller in initSampleDataModel (fixed states for the` &&
               ` first five rows, then Success/Warning/Error/Information/Indication01/None derived from the Price thresholds, with the matching custom highlightText). This is business logic, so per the thin-frontend` &&
               ` principle it is computed in ABAP model_init into the STATUS / STATUSTEXT model fields and bound directly (highlight={STATUS} via the expression above, highlightText={STATUSTEXT}) rather than in a` &&
               ` frontend formatter. // NOTE: The shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json) is inlined verbatim into model_init with the five columns the sample binds (Name, ProductId,` &&
               ` Quantity, Price, CurrencyCode). Price is typed as a packed ABAP field (p LENGTH 13 DECIMALS 2) because the u:Currency value property is numeric (float) - UI5 2.x strict-type validation would reject a` &&
               ` string there. The mock's own Status field (all 'Available') is intentionally not carried, since the sample overwrites Status with the highlight classification above. // NOTE: **e2e-verified`.
    lv_text1 = lv_text1 && ` 2026-08-01** (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): all three toolbar controls really drive the grid Table through their bindings - the Toggle Alternate Row Colors` &&
               ` button flips Table.alternateRowColors to true, turning Toggle Highlights off puts every RowSettings highlight back to 'None' through the expression binding, and picking 'Single' in the SelectionMode` &&
               ` Select sets Table.selectionMode. They all sit in the OverflowToolbar, which IS drivable once its 'Additional Options' popover is open (AGENTS 10). All @since-checked members are <= 1.71 so no` &&
               ` POST_171 is needed (RowSettings 1.48, RowSettings.highlightText 1.62, Table.alternateRowColors 1.52, u:Currency 1.21.1).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                    name = `RowHighlights`                                 class = `z2ui5_cl_dmo_app_174` path = `src/02/b10/z2ui5_cl_dmo_app_174.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
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
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                    name = `RowModes`                                      class = `z2ui5_cl_dmo_app_164` path = `src/02/b10/z2ui5_cl_dmo_app_164.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        checked = `CHECKED (2026-07-27): verified in a running system 2026-07-27 - sap.ui.table RowModes renders the regenerated 123-row set; rowMode switching works`
        notes = lv_text1
        post171 = `sap.ui.table.Table.rowMode (aggregation, @since 1.119) is used 1:1 (the RowModes sample binds rowMode to the folded 'ui>' state). Newer than UI5 1.71; declared per the property-171 policy. Previously` &&
                 ` undeclared because the property gate is blind to sap.ui.table (properties.json holds sap.m only); found by the non-sap.m @since audit 2026-07-24.` ) ).

    lv_text1 = `POST-1.71: Three post-1.71 members are kept 1:1 because the sample is built on them: sap.ui.table.Table.rowMode (aggregation, @since 1.119) with the control sap.ui.table.rowmodes.Fixed it holds,` &&
               ` sap.m.plugins.PasteProvider (@since 1.91) in the toolbar Button's dependents, and sap.ui.table.plugins.MultiSelectionPlugin's selectionMode property (@since 1.100). Declared per the fidelity-first` &&
               ` property-171 policy, so the app needs a UI5 release >= 1.119. // NOTE: The sample writes its two plugin controls with a DOTTED element name and no namespace prefix (<plugins.MultiSelectionPlugin>` &&
               ` under the sap.ui.table default xmlns, <m:plugins.PasteProvider>), which UI5 resolves as a sub-package of the element's namespace. The port declares real prefixes for those two packages instead` &&
               ` (xmlns:tp="sap.ui.table.plugins", xmlns:mp="sap.m.plugins") and writes tp:MultiSelectionPlugin / mp:PasteProvider - the same two controls, a namespace-representation difference only. structural-diff` &&
               ` compares the qualified name, so it reports the dotted names as missing and the prefixed ones as extra. // NOTE: onSelectChange disappears: the selection-mode Select's selectedKey and the`.
    lv_text1 = lv_text1 && ` MultiSelectionPlugin's selectionMode bind the SAME field, so picking a mode drives the plugin with no round-trip - the prefer-a-bindable-property rule. The named ``ui>`` model (the three modes and` &&
               ` the initial one) is folded onto the one default model, prefix dropped and leaf names kept. // IMPROVISED: The copy half of the sample is dropped, and with it the toolbar's copy Button: onInit creates` &&
               ` a sap.m.plugins.CellSelector and a sap.m.plugins.CopyProvider in JS (guarded by window.isSecureContext), adds both to the table's dependents and appends the CopyProvider's generated copy Button to` &&
               ` the toolbar. Building controls at runtime is the capability boundary CAPABILITIES marks as not expressible, and the CopyProvider's extractData/copy callbacks are app-authored JS formatters. The` &&
               ` declared PasteProvider Button of the view is kept 1:1. onPaste consequently loses its cell-range branch - the CellSelector that would supply the range is gone - so the port reports the pasted data at` &&
               ` TABLE level, which is the same handler's other branch, with the original's message text. // NOTE: The sample serves its rows from an in-page OData MockServer (over the sibling OData sample's`.
    lv_text1 = lv_text1 && ` metadata.xml and mock data). An abap2UI5 app has a real ABAP backend, so the mock service is replaced by the model itself: all 115 rows of ProductSet.json are inlined and the Table binds them` &&
               ` directly - the server-side paging illusion is what that costs, while threshold, enableBusyIndicator and the noData BusyIndicator stay 1:1. ProductSet.json lives in the sibling OData sample folder` &&
               ` upstream; it is archived into this sample's folder too so the port is verifiable offline. The six column labels are metadata bindings in the original ({/#Product/Name/@sap:label} and friends), which` &&
               ` only an OData model can resolve, and are replaced by the literal sap:label texts from metadata.xml. The numeric columns stay TYPE string so the mock's exact decimals survive. // LIVE-TEST: Unverified` &&
               ` in a running system: whether the paste event delivers the pasted data array to get_event_arg, and whether the bound selectionMode reaches the plugin without a round-trip.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                    name = `SelectCopyPaste`                               class = `z2ui5_cl_dmo_app_360` path = `src/02/b20/z2ui5_cl_dmo_app_360.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Three post-1.71 members are kept 1:1 because the sample is built on them: sap.ui.table.Table.rowMode (aggregation, @since 1.119) with the control sap.ui.table.rowmodes.Fixed it holds,` &&
                 ` sap.m.plugins.PasteProvider (@since 1.91) in the toolbar Button's dependents, and sap.ui.table.plugins.MultiSelectionPlugin's selectionMode property (@since 1.100). Declared per the fidelity-first` &&
                 ` property-171 policy, so the app needs a UI5 release >= 1.119.` ) ).

    lv_text1 = `NOTE: Three of the four controller setters become bound properties. The behaviour Select's selectedKey and the Table's selectionBehavior share one field, and the Switch's state and the Table's` &&
               ` enableSelectAll share another - so onBehaviourModeChange and onSwitchChange disappear and their wires with them: the behaviour Select keeps no change attribute and the Switch loses Switch.change` &&
               ` entirely (the only attribute structural-diff reports missing). onSelectionModeChange is the one that KEEPS its change wire, because it is not a plain setter: it REFUSES the deprecated All mode with a` &&
               ` MessageToast and leaves the table on its previous mode. The port therefore keeps the Select's key and the Table's selectionMode as two separate fields and copies one into the other in the handler,` &&
               ` snapping the Select back when All was picked - exactly the original's behaviour. // NOTE: getSelectedIndices / getContextByIndex read state that lives in the CONTROL, not in the model. Rather than` &&
               ` faking a value, the port mirrors the selection into the model: the Table's rowSelectionChange event carries ${$parameters>/rowIndices} and ${$parameters>/rowIndex} to the backend, and the two buttons`.
    lv_text1 = lv_text1 && ` then report from that - the index list, or 'no item selected' when it is empty, exactly as the original branches. getContextByIndex toasts the last selected row's model path (/T_PRODUCTS/<n>), which` &&
               ` is what a sap.ui.model.Context renders as when the original passes it to MessageToast. clearSelection stays imperative because the selection is control state: follow_up_action control_by_id` &&
               ` table1/clearSelection, plus clearing the mirrored fields. // NOTE: The named ``selectionmodel>`` model (the SelectionMode / SelectionBehavior enum values the controller enumerates at runtime,` &&
               ` skipping Multi) is folded onto the one default model as two tables; the values are the sap.ui.table enum members as of the current release. The controller's two formatters are computed in ABAP per` &&
               ` the thin-frontend principle: formatAvailableToObjectState and formatAvailableToIcon become the precomputed AVAILABLESTATE (Success/Error) and AVAILABLEICON (sap-icon://accept / sap-icon://decline)` &&
               ` columns. handleDetailsPress is client-composed and roundtrip-free: control_global MESSAGE_TOAST with 'Details for product with id {0}' and the row's ${PRODUCTID}. // NOTE: The Suppliers and`.
    lv_text1 = lv_text1 && ` Categories collections the controller derives from the products (the distinct SupplierName / Category values in first-appearance order) are inlined as their own tables, and the two in-cell dropdowns` &&
               ` keep the original's binding-info form with templateShareable - only the path switches to the ABAP table. The Heavy CheckBox and the DeliveryDate DatePicker keep their typed complex bindings 1:1 with` &&
               ` the path pointed at the ABAP field. // NOTE: The shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json) is inlined with the columns the twelve table columns bind. The original` &&
               ` computes DeliveryDate from Date.now() with an i-mod-10 offset in 4-day steps; a fixed base date (2026-07-23) is used here so the port is deterministic - the corpus convention of app 164.` &&
               ` ProductPicUrl values point at the OpenUI5 host per the asset-URL rule; the mock carries them host-relative. // LIVE-TEST: Unverified in a running system: whether rowSelectionChange delivers the index` &&
               ` array as JSON to get_event_arg, whether the two bound Selects drive selectionMode/selectionBehavior without a round-trip, and the control_by_id clearSelection wire.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                    name = `Selection`                                     class = `z2ui5_cl_dmo_app_361` path = `src/02/b20/z2ui5_cl_dmo_app_361.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: Every sort of this sample happens in ABAP. The three toolbar buttons (sortCategoriesAndName / sortCategories / clearAllSortings) and the column header menu all fire a backend event, the model` &&
               ` comes back SORTed and each Column's sortOrder is bound so the indicator follows - the thin-frontend equivalent of the original's oTable.sort( column, order, extend ) and setSortOrder calls.` &&
               ` clearAllSortings re-seeds the model, which restores the mock's own row order, and resets every indicator to None (the original's binding.sort(null) + _resetSortingState). sortCategories keeps the` &&
               ` original's alternating ascending/descending on repeated presses. // NOTE: The Table's sort event carries the pressed column's sortProperty and the requested sortOrder to the backend` &&
               ` (${$parameters>/column}.getSortProperty() and ${$parameters>/sortOrder} - an event arg is a full UI5 expression) and sets s_ctrl-check_prevent_default, so the control's own client-side sort never` &&
               ` runs. The original vetoes it only for the delivery-date column; here the model is the single source of truth for every column, so all of them are vetoed and sorted server-side. The delivery-date`.
    lv_text1 = lv_text1 && ` column is why the original needs a veto at all: its cells hold dd/MM/yyyy STRINGS, which no text compare can order, so it installs a custom Sorter.fnCompare that parses them. The port sorts the` &&
               ` underlying timestamp instead - the same result without any frontend logic. 'No multi-column sorting' is kept: every other indicator is reset before the pressed column is sorted. // NOTE: The row type` &&
               ` carries the raw DeliveryDate timestamp next to the formatted DeliveryDateStr, because that timestamp is the sort key the original's custom compare function reconstructs by parsing. The bound` &&
               ` sortProperty values are the ABAP (upper-cased) field names (NAME, CATEGORY, QUANTITY, DELIVERYDATESTR) rather than the original's JSON key names, since that is what the backend switches on. // NOTE:` &&
               ` The shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json) is inlined with the five columns the sample binds. The original computes DeliveryDate from Date.now() with an i-mod-10` &&
               ` offset in 4-day steps; a fixed base date (2026-07-23) is used here so the port is deterministic - the corpus convention of app 164 - and DeliveryDateStr is that timestamp formatted dd/MM/yyyy,`.
    lv_text1 = lv_text1 && ` exactly what the controller's DateFormat produces. ProductPicUrl values point at the OpenUI5 host per the asset-URL rule; the mock carries them host-relative. The Quantity and Delivery Date columns` &&
               ` keep the original's typed complex bindings 1:1, with their path switched to the ABAP field name. // IMPROVISED: The footer OverflowToolbar stays empty: onInit lazily requires` &&
               ` sap/ui/table/sample/TableExampleUtils and appends a ToolbarSpacer plus its createInfoButton( ) to it. That helper lives in the demo kit's own sample folder, not in any UI5 library, and only opens a` &&
               ` popover pointing at the sample's source - there is nothing to port it to. Every sap.ui.table sample of this batch drops it the same way. // LIVE-TEST: Unverified in a running system: whether the sort` &&
               ` event's prevented default plus the server-side SORT produce the expected order for each column, and whether the bound Column.sortOrder renders the header indicator.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                    name = `Sorting`                                       class = `z2ui5_cl_dmo_app_362` path = `src/02/b20/z2ui5_cl_dmo_app_362.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        notes = lv_text1 ) ).

    lv_text1 = `POST-1.71: sap.ui.table.Table.rowMode (aggregation, @since 1.119) and the control sap.ui.table.rowmodes.Fixed it holds are used 1:1 - the sample declares them in its view and the freeze demo drives` &&
               ` the row mode's fixedTopRowCount / fixedBottomRowCount. Both are newer than UI5 1.71; declared per the fidelity-first property-171 policy, so the app needs a UI5 release >= 1.119. // NOTE: buttonPress` &&
               ` becomes a clamp instead of three setters: the three count Inputs are two-way bound and the Table's fixedColumnCount plus the rowMode's fixedTopRowCount / fixedBottomRowCount bind the SAME fields, so` &&
               ` the Apply press only has to run the original's validation (fixed column count against the column total, fixed top + bottom rows against the visible row total) and push the corrected values back -` &&
               ` with the same two MessageToast texts, verbatim. The two totals the original reads off the live control (getColumns().length, getRows().length) are constants here: twelve columns as declared in the` &&
               ` view, and the ten visible rows the Fixed row mode defaults to. // NOTE: The controller's two formatters are computed in ABAP, per the thin-frontend principle: formatAvailableToObjectState and`.
    lv_text1 = lv_text1 && ` formatAvailableToIcon become the precomputed AVAILABLESTATE (Success/Error) and AVAILABLEICON (sap-icon://accept / sap-icon://decline) columns the ObjectStatus and core:Icon bind. handleDetailsPress` &&
               ` is client-composed and needs no round-trip at all: control_global MESSAGE_TOAST with 'Details for product with id {0}' and the row's ${PRODUCTID} as the argument, which is what the original builds` &&
               ` from the row's binding context. // NOTE: The Suppliers and Categories collections the controller derives from the products (the distinct SupplierName / Category values in first-appearance order) are` &&
               ` inlined as their own tables, and the two in-cell dropdowns keep the original's binding-info form with templateShareable - only the path switches to the ABAP table. The Heavy CheckBox and the` &&
               ` DeliveryDate DatePicker keep their typed complex bindings 1:1 with the path pointed at the ABAP field. // NOTE: The shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json) is inlined` &&
               ` with the columns the twelve table columns bind. The original computes DeliveryDate from Date.now() with an i-mod-10 offset in 4-day steps; a fixed base date (2026-07-23) is used here so the port is`.
    lv_text1 = lv_text1 && ` deterministic - the corpus convention of app 164. Heavy is WeightMeasure > 1000 as the string the typed CheckBox binding expects. ProductPicUrl values point at the OpenUI5 host per the asset-URL` &&
               ` rule; the mock carries them host-relative. // LIVE-TEST: Unverified in a running system: whether the bound fixedColumnCount and the bound rowMode counts freeze the expected columns/rows, and whether` &&
               ` the Apply clamp round-trip updates the Inputs.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`                    name = `TableFreeze`                                   class = `z2ui5_cl_dmo_app_363` path = `src/02/b20/z2ui5_cl_dmo_app_363.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.ui.table.Table.rowMode (aggregation, @since 1.119) and the control sap.ui.table.rowmodes.Fixed it holds are used 1:1 - the sample declares them in its view and the freeze demo drives the row` &&
                 ` mode's fixedTopRowCount / fixedBottomRowCount. Both are newer than UI5 1.71; declared per the fidelity-first property-171 policy, so the app needs a UI5 release >= 1.119.` ) ).

    lv_text1 = `IMPROVISED: The sample's rows come from an OData v2 tree binding over a mock service: the Nodes entity is a FLAT list carrying HierarchyLevel / NodeID / ParentNodeID / DrillState, and the binding's` &&
               ` treeAnnotationProperties (hierarchyLevelFor, hierarchyNodeFor, hierarchyParentNodeFor, hierarchyDrillStateFor) tell the ODataTreeBinding how to assemble it into a tree. abap2UI5 serves one JSON` &&
               ` model, so there is no ODataTreeBinding and no annotation to read: the same sixteen nodes are modelled NESTED instead (one children table per level) and bound with the arrayNames parameter - the JSON` &&
               ` tree binding the framework does support (the app-248 idiom). The rendered tree is identical, every node keeps all four of its own fields and the four columns are unchanged; what is lost is the` &&
               ` annotation-driven assembly itself, and with it the countMode: 'Inline' parameter, which is an OData request option. // NOTE: localService/mockdata/Nodes.json is inlined in full - all sixteen nodes` &&
               ` with the mock's own ids, levels, descriptions, parent ids and drill states; the root nodes' ParentNodeID is null in the JSON and becomes the empty string in the flat ABAP row type. The mock server`.
    lv_text1 = lv_text1 && ` itself (localService/mockserver.js over localService/metadata.xml) has no counterpart in an abap2UI5 app, whose backend IS the service. // LIVE-TEST: Unverified in a running system: whether the` &&
               ` nested model plus arrayNames renders the same expandable tree the OData tree binding produces.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.TreeTable`                name = `TreeTable.BasicODataTreeBinding`               class = `z2ui5_cl_dmo_app_364` path = `src/02/b20/z2ui5_cl_dmo_app_364.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: Collapse all and Expand first level are reproduced 1:1 as frontend actions: onCollapseAll / onExpandFirstLevel call the TreeTable's own collapseAll( ) and expandToLevel( 1 ), which have no` &&
               ` bindable equivalent (the expansion state lives in the control), so they go through _event_client control_by_id TreeTable/collapseAll and TreeTable/expandToLevel with the level as its argument -` &&
               ` roundtrip-free, exactly what the buttons do in the original. // IMPROVISED: The hierarchy MAINTENANCE half of the sample - Cut, Paste and the drag & drop re-parenting - is dropped, and with it the` &&
               ` DragDropInfo's dragStart and drop attributes; the Cut and Paste buttons keep their labels, icons and the Paste button's enabled="false" from the view but do nothing. All three handlers move a node to` &&
               ` an ARBITRARY new parent (onDrop pushes the dragged row's data into the dropped row's ``categories`` array and blanks the source; onCut/onPaste do the same through a clipboard). A JSON tree binding` &&
               ` needs the children nested under their parent, and an ABAP nesting is TYPED and fixed-depth (article inside group inside area inside root, as the JSON's own four levels are), so a node cannot be`.
    lv_text1 = lv_text1 && ` re-parented to a level of a different type - which is precisely what these handlers do. The row-to-node resolution itself would be transportable (a drop event can ship` &&
               ` ${$parameters>/draggedControl}.getBindingContext().getPath()), so this is a limit of modelling a tree as typed ABAP data, not of the event wire. // NOTE: Clothing.json is inlined 1:1 - the full tree` &&
               ` (Women/Men/Girls/Boys) with every leaf's amount/currency/size - as nested types, one per level, so absent leaf fields exist only where the JSON carries them and the Size Select stays hidden via the` &&
               ` original's !!${size} guard. It is byte-identical to the file the sibling TreeTable.JSONTreeBinding sample uses, which app 248 ports; the model and its types are shared with that port. The rows` &&
               ` binding keeps the original's arrayNames parameter with the ABAP (upper-cased) array name. // LIVE-TEST: Unverified in a running system: the two control_by_id wires (collapseAll, and expandToLevel` &&
               ` with its numeric argument - a listed CONTROL_METHODS entry, so the argument is declared and reaches the method).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.TreeTable`                name = `TreeTable.HierarchyMaintenanceJSONTreeBinding` class = `z2ui5_cl_dmo_app_365` path = `src/02/b20/z2ui5_cl_dmo_app_365.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The onInit JSONModel('.../Clothing.json') load is folded into model_init: the full tree (Women/Men/Girls/Boys, every article with amount/currency/size) plus the /sizes list, 1:1 from the mock.` &&
               ` The tree keeps the original's shape - nested types per level under a CATALOG-CLOTHING structure, so the rows binding path '/CATALOG/CLOTHING' with parameters { arrayNames: ['CATEGORIES'] } mirrors` &&
               ` {path:'/catalog/clothing', parameters:{arrayNames:['categories']}}. Homogeneous-type caveat: a level-3 leaf article (Jewelry/Necklace class) carries an empty CATEGORIES array (the ABAP row type is` &&
               ` one shape per level) - JSONTreeBinding treats an empty child array as a leaf, so it renders like the original's absent property; and a level-3 CATEGORY row (Dresses) carries initial` &&
               ` AMOUNT/CURRENCY/SIZE fields its original JSON node omits - SIZE '' keeps the Select hidden through the original's own !!SIZE guard, and the Price guard below keeps the cell empty. // NOTE:` &&
               ` Currency.value is the guarded expression binding ``{= ${AMOUNT} > 0 ? ${AMOUNT} : null }`` (a numeric-string 0.00 from the transpiled runtime is truthy, so the guard compares > 0 instead of testing`.
    lv_text1 = lv_text1 && ` truthiness) instead of the original's plain {amount}: a category row's own AMOUNT serializes as 0 (initial packed - a flat ABAP row serializes every field), and an unguarded 0 would render '0.00'` &&
               ` where the original's absent JSON property renders an empty Price cell. The app-220 optional-value-guard idiom (backtick literal so the braces reach the attribute verbatim); leaf amounts are all > 0,` &&
               ` so no real price is masked. // NOTE: live-verified 2026-08-04 (nightly e2e interaction): unverified in a running system: (a) the nested-structure model root (/CATALOG/CLOTHING via _bind on the` &&
               ` catalog-clothing component) feeding the TreeTable rows binding with arrayNames; (b) Collapse all / Expand first level via roundtrip-free _event_client control_by_id (collapseAll whitelisted,` &&
               ` expandToLevel int); (c) Collapse/Expand selection 1:1 via the $event.oSource.getParent().getParent().getSelectedIndices() expression - the resolved index array reaches the unlisted-but-public` &&
               ` collapse/expand methods through castArgAuto untouched; (d) the two-way Select selectedKey writing a changed size back into the tree row. **e2e-verified 2026-07-30** (transpiled-framework interaction,`.
    lv_text1 = lv_text1 && ` scripts/e2e-smoke.mjs): (a) and (b) are covered - the tree renders its root categories from the nested-structure model, Expand first level reveals the second level (Accessories) and Collapse all` &&
               ` hides it again; (c) selection expand/collapse and (d) the two-way Select remain unexercised. Environment note: the transpiled runtime serializes packed AMOUNT as a numeric string, which is why the` &&
               ` Currency guard compares > 0 instead of truthiness.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.TreeTable`                name = `TreeTable.JSONTreeBinding`                     class = `z2ui5_cl_dmo_app_248` path = `src/02/b12/z2ui5_cl_dmo_app_248.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: The sample's rows come from an OData v2 tree binding over a mock service: the Nodes entity is a FLAT list carrying HierarchyLevel / NodeID / ParentNodeID / DrillState, and the service` &&
               ` METADATA carries the same hierarchy annotations, which the ODataTreeBinding reads on its own. abap2UI5 serves one JSON model, so there is no ODataTreeBinding and no annotation to read: the same` &&
               ` sixteen nodes are modelled NESTED instead (one children table per level) and bound with the arrayNames parameter - the JSON tree binding the framework does support (the app-248 idiom). The rendered` &&
               ` tree is identical, every node keeps all four of its own fields and the four columns are unchanged; what is lost is the annotation-driven assembly itself, and with it the countMode: 'Inline'` &&
               ` parameter, which is an OData request option. numberOfExpandedLevels: 1 IS kept as a binding parameter, so the first level opens like in the original. // NOTE: This sample has no controller at all` &&
               ` (the view names none); the port is correspondingly static - a bare check_on_init branch with model_init and view_display, no on_event. // NOTE: localService/mockdata/Nodes.json is inlined in full -`.
    lv_text1 = lv_text1 && ` all sixteen nodes with the mock's own ids, levels, descriptions, parent ids and drill states; the root nodes' ParentNodeID is null in the JSON and becomes the empty string in the flat ABAP row type.` &&
               ` The mock server itself (localService/mockserver.js over localService/metadata.xml) has no counterpart in an abap2UI5 app, whose backend IS the service. // LIVE-TEST: Unverified in a running system:` &&
               ` whether the nested model plus arrayNames renders the same expandable tree the OData tree binding produces.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.table`       control = `sap.ui.table.TreeTable`                name = `TreeTable.ODataAnnotationsTreeBinding`         class = `z2ui5_cl_dmo_app_366` path = `src/02/b20/z2ui5_cl_dmo_app_366.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: Calendar with primaryCalendarType Islamic / secondaryCalendarType Gregorian. The picked day IS transportable after all - measured 2026-08-05 with` &&
               ` ``scripts/probes/event-arg-expression-probe.mjs`` against real OpenUI5: an event arg is a full UI5 expression, and indexed access into an array-valued getter plus chained calls resolve there` &&
               ` (``$event.oSource.getSelectedDates()[0].getStartDate()``). The earlier rationale - 'select carries no date parameter and the selected DateRange is control state' - was wrong. The wire carries the` &&
               ` three LOCAL date parts as three expression args (year, month+1, day) rather than ``toISOString( )``, which would shift the day for any user east of Greenwich, and each arg is guarded by` &&
               ` ``getSelectedDates().length > 0`` so a re-click that clears the selection arrives as year 0. App 151 now writes the SELECTED day (Gregorian yyyy-MM-dd, matching its label) instead of the server date.` &&
               ` Residual: 'Focus Today' - the original only calls focusDate(today) and changes no text; the port keeps writing today's date and does not move the calendar focus, since focusDate takes a Date OBJECT` &&
               ` no wire can construct.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Calendar`               name = `CalendarCalendarType`                          class = `z2ui5_cl_dmo_app_151` path = `src/02/b08/z2ui5_cl_dmo_app_151.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: handleCalendarSelect/_updateText read the picked day off the control (oCalendar.getSelectedDates()[0].getStartDate()) and format it yyyy-MM-dd. The port transports it as three UI5 expression` &&
               ` args (year, month+1, day - the LOCAL parts, not toISOString( ), which would shift the day east of Greenwich), each guarded by getSelectedDates().length > 0, and formats server-side; the Text gets a` &&
               ` two-way bound text attribute instead of setText (app 139 idiom, probe-verified). The controller's oLastSelectedJSDate becomes a server-side field, so the second click on the same day is recognised` &&
               ` exactly as in the original. // IMPROVISED: the deselection is only reproduced on the LABEL, not on the calendar itself: the original calls oCalendar.removeSelectedDate(oSelectedDate), which takes a` &&
               ` DateRange CONTROL instance no wire can address, so the day stays visually highlighted while the text goes back to 'No Date Selected'. // IMPROVISED: onInit does` &&
               ` byId('calendar').displayDate(UI5Date.getInstance(2021, 6, 1)) to open the calendar on July 2021. Calendar exposes no bindable property for the displayed month and displayDate() takes a JS Date`.
    lv_text1 = lv_text1 && ` argument, which the frontend-action wire cannot carry (CONTROL_METHODS casts only string/int/bool/controlId/anchor kinds), so the port opens on the current month. // POST-1.71:` &&
               ` Calendar.showCurrentDateButton (@since 1.95) is kept 1:1 from the original view. Newer than UI5 1.71. // LIVE-TEST: not yet run in a system: the CAL_SELECT expression-arg round-trip and the same-day` &&
               ` second click clearing the label.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Calendar`               name = `CalendarDateDeselection`                       class = `z2ui5_cl_dmo_app_305` path = `src/02/b15/z2ui5_cl_dmo_app_305.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.22.0`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Calendar.showCurrentDateButton (@since 1.95) is kept 1:1 from the original view. Newer than UI5 1.71.` ) ).

    lv_text1 = `NOTE: The object-typed calendar date properties (Calendar.minDate, Calendar.maxDate and the disabledDates DateRange startDate/endDate) are fed from plain ISO strings in the model and converted at the` &&
               ` point of use with Formatter.DateCreateObject from the curated module (core:require='{Formatter: z2ui5/model/formatter}'). A plain string binding would crash view creation (Date must be a JS/UI5Date` &&
               ` object). The original's UI5Date.getInstance(year, month0, day) values are normalized to ISO 1:1 (month is 0-based: minDate 2000-01-01, maxDate 2050-12-31, disabled ranges 2016-01-04..2016-01-10 and` &&
               ` 2016-01-15). // NOTE: The second disabled range is a SINGLE day: the original's row omits end entirely (undefined is falsy), and one bound DateRange template cannot omit an attribute per row. A plain` &&
               ` formatter binding over the empty end field crashed the app - Formatter.DateCreateObject('') is new Date('') = Invalid Date, DateRange.endDate accepts it (type object) and Month._checkDateEnabled then`.
    lv_text1 = lv_text1 && ` runs CalendarDate.fromLocalJSDate on every TRUTHY endDate, which throws. Fixed 2026-07-28 by guarding the conversion in the binding itself: endDate="{= ${END} ? Formatter.DateCreateObject(${END}) :` &&
               ` null }" - written as a backtick literal so the braces survive to the attribute. Probe-verified against the real OpenUI5 runtime (scripts/probes/calendar-empty-enddate-probe.mjs, headless Chromium,` &&
               ` calendar focused on the affected month): the old binding throws and renders 0 days, the guarded one yields endDate null for the empty row and renders all 42. This also matters for the semantics, not` &&
               ` only the crash: Month._checkDateEnabled disables a single day ONLY through the no-endDate branch (the range branch compares strictly exclusive, oTimeStamp > start && < end), so seeding end = start` &&
               ` would disable nothing. // NOTE: handleCalendarSelect formats the picked day with DateFormat.getInstance({style:'long'}) and writes it into the 'selectedDate' Text. The picked day IS transportable` &&
               ` after all - measured 2026-08-05 with ``scripts/probes/event-arg-expression-probe.mjs`` against real OpenUI5: an event arg is a full UI5 expression, and indexed access into an array-valued getter plus`.
    lv_text1 = lv_text1 && ` chained calls resolve there (``$event.oSource.getSelectedDates()[0].getStartDate()``). The earlier rationale - 'select carries no date parameter and the selected DateRange is control state' - was` &&
               ` wrong. The wire carries the three LOCAL date parts as three expression args (year, month+1, day) rather than ``toISOString( )``, which would shift the day for any user east of Greenwich, and each arg` &&
               ` is guarded by ``getSelectedDates().length > 0`` so a re-click that clears the selection arrives as year 0. The port reproduces it: the select wire was added (the Text is bound instead of carrying the` &&
               ` literal 'No Date Selected'), and the English long form ('March 17, 2026') is composed in ABAP from the transported parts - the thin-frontend answer to a locale formatter, as in app 024. // NOTE: The` &&
               ` original Switch (state='true') toggles Calendar week numbers via an imperative change handler (setShowWeekNumbers). This is folded into a two-way binding shared by the Switch state and a Calendar`.
    lv_text1 = lv_text1 && ` showWeekNumbers property (both bound to show_week_numbers, seeded true), so the toggle runs on the client with no round-trip - the thin-frontend move. The Switch change attribute is therefore dropped` &&
               ` and a showWeekNumbers attribute (absent from the original view) is added. // POST-1.71: Formatter.DateCreateObject is referenced via core:require, which needs UI5 >= 1.74. sap.ui.unified.Calendar` &&
               ` itself and its minDate/maxDate/disabledDates/showWeekNumbers members are all <= 1.71 (in scope).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Calendar`               name = `CalendarMinMax`                                class = `z2ui5_cl_dmo_app_220` path = `src/02/b10/z2ui5_cl_dmo_app_220.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Formatter.DateCreateObject is referenced via core:require, which needs UI5 >= 1.74. sap.ui.unified.Calendar itself and its minDate/maxDate/disabledDates/showWeekNumbers members are all <= 1.71 (in` &&
                 ` scope).` ) ).

    lv_text1 = `NOTE: handleCalendarSelect walks oCalendar.getSelectedDates() and rebuilds the JSON model with one yyyy-MM-dd string per selected day. An event arg is a full UI5 expression but the grammar has no` &&
               ` loop, so the wire carries a FIXED set of 31 index-guarded expression args (one per selectable slot), each formatting getSelectedDates()[i].getStartDate() to yyyy-MM-dd from its LOCAL parts on the` &&
               ` client and yielding an empty string past the end of the aggregation. on_event stops at the first empty arg and rebuilds the bound table from the rest. // IMPROVISED: the 31-slot cap is a real limit,` &&
               ` not a formality: 31 is the most days one displayed month can hold, but the user can navigate months and keep selecting, and every day past the 31st is silently dropped from the list (the calendar` &&
               ` itself still shows it selected). A loop-free expression grammar leaves no way to transport a variable-length aggregation in one arg. // IMPROVISED: handleRemoveSelection calls` &&
               ` byId('calendar').removeAllSelectedDates() and then clears the model. Only the model half is reproducible: the frontend-action method denylist blocks every 'removeAll*' name`.
    lv_text1 = lv_text1 && ` (CONTROL_METHOD_DENY_PREFIXES in app/webapp/core/FrontendAction.js, aimed at the GENERIC reflection mutators), so the named per-aggregation removeAllSelectedDates cannot be called either - the list` &&
               ` empties but the days stay highlighted in the calendar. Filed as pr/control-method-named-removeall. // LIVE-TEST: not yet run in a system: the multi-select round-trip filling the List and the Remove` &&
               ` All button clearing it.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Calendar`               name = `CalendarMultipleDaySelection`                  class = `z2ui5_cl_dmo_app_307` path = `src/02/b15/z2ui5_cl_dmo_app_307.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.22.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: handleCalendarSelect/_updateText read the picked day off the control (oCalendar.getSelectedDates()[0].getStartDate()) and format it yyyy-MM-dd. The port transports it as three UI5 expression` &&
               ` args (year, month+1, day - the LOCAL parts, not toISOString( ), which would shift the day east of Greenwich), each guarded by getSelectedDates().length > 0, and formats server-side; the Text gets a` &&
               ` two-way bound text attribute instead of setText (app 139 idiom, probe-verified). // NOTE: handleSelectToday does removeAllSelectedDates() + addSelectedDate(new DateRange({startDate: today})) and` &&
               ` reformats. The port only writes the text: the server date IS today, so the label is 1:1, but the calendar's own highlight of that day is not moved - addSelectedDate takes a DateRange CONTROL, which` &&
               ` no wire can construct (same residual as app 139). // LIVE-TEST: not yet run in a system: the CAL_SELECT expression-arg round-trip across the two displayed months and the SELECT_TODAY text update.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Calendar`               name = `CalendarMultipleMonth`                         class = `z2ui5_cl_dmo_app_304` path = `src/02/b15/z2ui5_cl_dmo_app_304.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The picked day IS transportable after all - measured 2026-08-05 with ``scripts/probes/event-arg-expression-probe.mjs`` against real OpenUI5: an event arg is a full UI5 expression, and indexed` &&
               ` access into an array-valued getter plus chained calls resolve there (``$event.oSource.getSelectedDates()[0].getStartDate()``). The earlier rationale - 'select carries no date parameter and the` &&
               ` selected DateRange is control state' - was wrong. The wire carries the three LOCAL date parts as three expression args (year, month+1, day) rather than ``toISOString( )``, which would shift the day` &&
               ` for any user east of Greenwich, and each arg is guarded by ``getSelectedDates().length > 0`` so a re-click that clears the selection arrives as year 0. App 139 now formats the SELECTED day as the` &&
               ` original's yyyy-MM-dd (DateFormat pattern) instead of the server date. Residual: 'Select Today' still only writes the text - the server date IS today, so the text is 1:1, but the calendar's own` &&
               ` highlight is not moved, because addSelectedDate takes a DateRange CONTROL that no wire can construct.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Calendar`               name = `CalendarSingleDaySelection`                    class = `z2ui5_cl_dmo_app_139` path = `src/02/b05/z2ui5_cl_dmo_app_139.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: handleCalendarSelect/_updateText read the picked interval off the control (getSelectedDates()[0].getStartDate()/getEndDate()) and format both ends yyyy-MM-dd. The port transports six UI5` &&
               ` expression args (the LOCAL year/month+1/day of each end, not toISOString( ), which would shift the day east of Greenwich), each guarded so a missing end arrives as 0 and renders the original's 'No` &&
               ` Date Selected'; the two Texts get two-way bound text attributes instead of setText (app 139 idiom, probe-verified). // NOTE: handleWeekNumberSelect reads the weekNumber and the weekDays DateRange` &&
               ` parameters; both travel as expression args (${$parameters>/weekNumber} and the local date parts of ${$parameters>/weekDays}.getStartDate()/getEndDate()), and the every-fifth-week refusal toast is` &&
               ` composed server-side, exactly as the original composes it. // IMPROVISED: the refusal is only a toast: the original also calls oEvent.preventDefault() so the forbidden week is NOT selected. abap2UI5` &&
               ` bakes s_ctrl-check_prevent_default into the handler at RENDER time (app 241), which cannot express a condition evaluated per event (weekNumber % 5 === 0), so the week highlights and only the message`.
    lv_text1 = lv_text1 && ` says it is not allowed. // LIVE-TEST: not yet run in a system: the CAL_SELECT interval round-trip and the WEEK_SELECT branch (toast on every fifth week, labels otherwise).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Calendar`               name = `CalendarSingleIntervalSelection`               class = `z2ui5_cl_dmo_app_306` path = `src/02/b15/z2ui5_cl_dmo_app_306.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.22.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: handleShowSpecialDays adds the special dates and the legend items imperatively (oCal.addSpecialDate(new DateTypeRange({...})), oLeg.addItem(new CalendarLegendItem({...}))) and destroys them` &&
               ` again when the ToggleButton is released. The port binds the two Calendars' specialDates and the two CalendarLegends' items aggregations to four ABAP tables and fills/clears them on the` &&
               ` SHOW_SPECIAL_DAYS round-trip, so the u:DateTypeRange and u:CalendarLegendItem templates plus the specialDates/items aggregation nodes are extra vs the archived view.xml (which declares none of them).` &&
               ` The ToggleButton also gains a two-way bound pressed attribute so its state survives the round-trip. Every date is day n of the CURRENT month, exactly like the original's setDate(n) on a fresh` &&
               ` reference date. // NOTE: DateTypeRange.startDate/endDate are typed 'object' and demand a real JS Date; the model carries ISO strings and Formatter.DateCreateObject (the curated formatter pack)` &&
               ` converts them at the point of use via core:require. endDate is set on exactly one range, so its conversion is guarded with an expression binding - an unguarded new Date('') is an Invalid Date, which`.
    lv_text1 = lv_text1 && ` is truthy and takes the whole view down. Rows without color/secondaryType/tooltip bind through omit_initial_paths so the UI5 default applies instead of an empty string. // POST-1.71:` &&
               ` DateTypeRange.color (@since 1.76) and DateTypeRange.secondaryType (@since 1.81) are kept 1:1 from the original controller, and the Formatter.DateCreateObject core:require path needs UI5 >= 1.74. All` &&
               ` newer than UI5 1.71. // LIVE-TEST: not yet run in a system: the ToggleButton round-trip filling and clearing both calendars' special dates and both legends.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Calendar`               name = `CalendarSpecialDaysLegend`                     class = `z2ui5_cl_dmo_app_308` path = `src/02/b15/z2ui5_cl_dmo_app_308.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `DateTypeRange.color (@since 1.76) and DateTypeRange.secondaryType (@since 1.81) are kept 1:1 from the original controller, and the Formatter.DateCreateObject core:require path needs UI5 >= 1.74. All` &&
                 ` newer than UI5 1.71.` ) ).

    lv_text1 = `NOTE: The picked day IS transportable after all - measured 2026-08-05 with ``scripts/probes/event-arg-expression-probe.mjs`` against real OpenUI5: an event arg is a full UI5 expression, and indexed` &&
               ` access into an array-valued getter plus chained calls resolve there (``$event.oSource.getSelectedDates()[0].getStartDate()``). The earlier rationale - 'select carries no date parameter and the` &&
               ` selected DateRange is control state' - was wrong. The wire carries the three LOCAL date parts as three expression args (year, month+1, day) rather than ``toISOString( )``, which would shift the day` &&
               ` for any user east of Greenwich, and each arg is guarded by ``getSelectedDates().length > 0`` so a re-click that clears the selection arrives as year 0. App 177 now formats the SELECTED day as` &&
               ` yyyy-MM-dd, and the original's else-branch is reproduced exactly: re-clicking the same day removes it from the selection, the guard reports year 0 and the Text falls back to 'No Date Selected'.` &&
               ` Residual: 'Select Today' writes the text (server date = today) without moving the calendar's highlight. // NOTE: The CAL_SELECT / SELECT_TODAY round-trips updating the bound selectedDate Text are`.
    lv_text1 = lv_text1 && ` unverified in a running system. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): 'Select Today' round-trips and the bound #selectedDate Text shows the yyyy-MM-dd` &&
               ` value; CAL_SELECT is the same handler.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.CalendarDateInterval`   name = `CalendarDateIntervalBasic`                     class = `z2ui5_cl_dmo_app_177` path = `src/02/b10/z2ui5_cl_dmo_app_177.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
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
      ( module = `sap.ui.unified`     control = `sap.ui.unified.CalendarLegend`         name = `CalendarLegendNavigation`                      class = `z2ui5_cl_dmo_app_240` path = `src/02/b11/z2ui5_cl_dmo_app_240.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.22.0`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `DateTypeRange.startDate is a date-object (type object) property, so it is bound through core:require="{Formatter: 'z2ui5/model/formatter'}" + formatter 'Formatter.DateCreateObject' (the curated` &&
                 ` module), which needs UI5 >= 1.74 - a plain ISO-string binding would crash view creation (CAPABILITIES 'Date-object properties'; same idiom as apps 108/109). The xmlns:core + core:require were added` &&
                 ` for it; the original view had neither.` ) ).

    lv_text1 = `NOTE: openPopover builds a sap.m.ResponsivePopover with a nested sap.ui.unified.ColorPicker imperatively and calls openBy(oEvent.getSource()). The port expresses it as a core:FragmentDefinition shown` &&
               ` with client->popover_display( xml, by_id = $event.oSource.sId ) - the CAPABILITIES.md 1:1 path for a controller-built popover. Its ResponsivePopover, ColorPicker and the two Buttons are extra vs the` &&
               ` archived View.view.xml, which declares only the inline ColorPicker and the trigger Button. // NOTE: the controller's Device.system.phone branch (phone: keep the header and add Submit/Cancel buttons;` &&
               ` otherwise setShowHeader(false)) stays a branch: abap2UI5 serves the device> named model on every view slot, so ResponsivePopover.showHeader and the two buttons' visible bind {=` &&
               ` ${device>/system/phone}} instead of being resolved to one value at render time (apps 277/279 precedent). Both buttons close the popover client-side via _event_client( popover_close ), matching the` &&
               ` original's oRP.close(). // LIVE-TEST: not yet run in a system: the anchored popover round-trip and the phone-only Submit/Cancel buttons.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.ColorPicker`            name = `ColorPicker`                                   class = `z2ui5_cl_dmo_app_309` path = `src/02/b15/z2ui5_cl_dmo_app_309.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.48.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: openPopover builds a sap.m.ResponsivePopover with a nested sap.ui.unified.ColorPicker imperatively and calls openBy(oEvent.getSource()). The port expresses it as a core:FragmentDefinition shown` &&
               ` with client->popover_display( xml, by_id = $event.oSource.sId ) - the CAPABILITIES.md 1:1 path for a controller-built popover. Its ResponsivePopover, ColorPicker and the two Buttons are extra vs the` &&
               ` archived View.view.xml, which declares only the inline ColorPicker and the trigger Button. The Large displayMode (@since 1.58) is kept 1:1 on both pickers. // NOTE: the controller's` &&
               ` Device.system.phone branch (phone: keep the header and add Submit/Cancel buttons; otherwise setShowHeader(false)) stays a branch: abap2UI5 serves the device> named model on every view slot, so` &&
               ` ResponsivePopover.showHeader and the two buttons' visible bind {= ${device>/system/phone}} instead of being resolved to one value at render time (apps 277/279 precedent). Both buttons close the` &&
               ` popover client-side via _event_client( popover_close ), matching the original's oRP.close(). // LIVE-TEST: not yet run in a system: the anchored popover round-trip and the phone-only Submit/Cancel` &&
               ` buttons.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.ColorPicker`            name = `ColorPickerLarge`                              class = `z2ui5_cl_dmo_app_310` path = `src/02/b15/z2ui5_cl_dmo_app_310.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.48.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: Breadth-probe (cross-library capability test). Inline sap.ui.unified ColorPicker (HSL / Simplified); the view itself is a 1:1 rebuild. Since 2026-07-30 the button's controller-built` &&
               ` ResponsivePopover-with-ColorPicker is reproduced 1:1 via popover_display( xml = fragment by_id = $event.oSource.sId ): a core:FragmentDefinition with ResponsivePopover (title 'Color Picker'), a` &&
               ` second u:ColorPicker (HSL/Simplified) in its content and Submit/Cancel Button pair - all extra controls vs the original view.xml, which declared none of them (controller-built). The original's` &&
               ` Device.system.phone branch (phone: begin/end Submit/Cancel buttons that close; desktop: setShowHeader(false)) is expressed declaratively: showHeader='{device>/system/phone}' and` &&
               ` visible='{device>/system/phone}' on both buttons, so phone and desktop render as the original without a JS branch; the buttons close via the popover_close frontend action (oRP.close()). // NOTE:` &&
               ` live-verified 2026-08-04 (nightly e2e interaction): the anchored ResponsivePopover open (popover_display by_id) with the embedded ColorPicker and the device-bound header/button variants are`.
    lv_text1 = lv_text1 && ` unverified in a running system. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the button press opens the ResponsivePopover anchored with the embedded` &&
               ` ColorPicker attached (the picker's inner sliders render zero-size headless, so only the container is asserted).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.ColorPicker`            name = `ColorPickerSimplified`                         class = `z2ui5_cl_dmo_app_112` path = `src/02/b01/z2ui5_cl_dmo_app_112.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.48.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The four u:ColorPickerPopover controls are EXTRA in the port (original 0 vs port 4): the controller creates them lazily in JS (new ColorPickerPopover('oColorPickerPopover', { colorString:` &&
               ` 'blue', mode: 'HSL', change: ... }) and the Large/Simplified/liveChange variants) and opens each with openBy(oEvent.getSource()). abap2UI5 declares them up front in the Table's dependents aggregation` &&
               ` with the same ids, colorStrings (blue/green/pink/orange), displayModes and mode='HSL', and each Input's valueHelpRequest opens its own popover roundtrip-free via _event_client( control_by_id,` &&
               ` <id>/openBy/$event.oSource.sId ) - the anchored-open idiom of apps 016/060. Same controls, same configuration, declared instead of constructed; the lazy instantiation and the onExit destroy() are` &&
               ` gone with the JS. // IMPROVISED: The Inputs' change handler is dropped: handleInputChange validates the typed text with sap.ui.core.CSSColor.isValid and sets the Input's valueState to Error for an` &&
               ` invalid color. Colour-string validation is frontend logic with no ABAP equivalent that runs per keystroke, and abap2UI5's thin-frontend rule forbids reimplementing it in a formatter or expression`.
    lv_text1 = lv_text1 && ` binding; a round-trip per change would be a different behaviour. The Input.value stays two-way bound so the typed text reaches the backend, but an invalid entry is not flagged. handleChange's own` &&
               ` valueState reset (ValueState.None after picking a colour) is therefore not needed either. // NOTE: live-verified 2026-08-04 (nightly e2e interaction): Unverified in a running system: (b) that the` &&
               ` popover's change round-trip writes the chosen colorString into the right Input and toasts 'Chosen color string: <color>' like handleChange - the original tracks the source Input in this.inputId,` &&
               ` while here every popover has its own event so the target is known statically; (c) that the liveChange round-trip keeps the Text under the last Input in sync while the user drags in the picker. Leg` &&
               ` (a) is closed: **e2e-verified 2026-08-01** (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): clicking the first row's value-help icon opens THAT Input's own ColorPickerPopover` &&
               ` anchored at the input (control_by_id openBy + domRef), with the ColorPicker inside it. Picking a colour needs the picker's own drag/slider controls, which carry zero-size boxes headless, so (b)/(c)`.
    lv_text1 = lv_text1 && ` stay a human check.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.ColorPickerPopover`     name = `ColorPickerPopover`                            class = `z2ui5_cl_dmo_app_268` path = `src/02/b14/z2ui5_cl_dmo_app_268.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.48.0`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: The controller's Formatting.setCustomCurrencies({BGN4:{digits:4}, WWWW:{digits:5}}) is reproduced 1:1 since 2026-08-05: a follow_up_action( cs_event-control_global,` &&
               ` FORMATTING/setCustomCurrencies ) carries the same JSON payload, so list five renders BGN4 with 4 and WWWW with 5 decimals like the original. The FORMATTING global target was added upstream for` &&
               ` exactly this gap (pr/custom-currency-formatting); it is lazy-required, so a runtime older than UI5 1.120 logs 'not available' instead of failing the app. // NOTE: The various/nonDecimal arrays back` &&
               ` the u:Currency value property (float) as ABAP packed fields, matching the sample's JSON numbers; the bigNumber array (JSON strings) and the customCurrency array (JSON numbers bound to the string` &&
               ` property stringValue, so UI5 coerces them) are ABAP string fields keeping the exact literals (123.45676 has 5 decimals). listSix binds the numeric variousNumberDataModel/price to stringValue (number` &&
               ` coerced to string, as in the original). **e2e-verified 2026-08-01** (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): the serialized model reaches the controls: the lists`.
    lv_text1 = lv_text1 && ` render, the u:Currency controls come up and their currencies (EUR, JPY) are on screen. Residual: the exact digit formatting per list (maxPrecision, the custom BGN4/WWWW digits), which is the` &&
               ` browser's locale formatting rather than the port's data.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Currency`               name = `Currency`                                      class = `z2ui5_cl_dmo_app_196` path = `src/02/b10/z2ui5_cl_dmo_app_196.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.21.1`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Currency`               name = `CurrencyInTable`                               class = `z2ui5_cl_dmo_app_171` path = `src/02/b10/z2ui5_cl_dmo_app_171.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted, reviewed). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.21.1`
        checked = `CHECKED (2026-07-27): verified in a running system 2026-07-27 - nested transactionAmount/size + currency bindings resolve at runtime (u:Currency renders values)`
        notes = `NOTE: live-verified 2026-07-27: u:Currency binds a nested object path (value={transactionAmount/size}, currency={transactionAmount/currency}). Ported as a nested ABAP structure TRANSACTION_AMOUNT` &&
                 ` (fields SIZE/CURRENCY), bound {TRANSACTION_AMOUNT/SIZE} / {TRANSACTION_AMOUNT/CURRENCY}. CAPABILITIES.md documents nested TABLES/trees but not a nested single (non-array) structure within a row, so` &&
                 ` the nested-object serialization + relative sub-path binding needs a live render check.` )
      ( module = `sap.ui.unified`     control = `sap.ui.unified.FileUploader`           name = `FileUploaderBasic`                             class = `z2ui5_cl_dmo_app_126` path = `src/02/b02/z2ui5_cl_dmo_app_126.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = `NOTE: live-verified 2026-08-04 (nightly e2e interaction): The full upload cycle is backend/endpoint dependent, so it is reduced to client-side MessageToasts: 'Upload File' press shows an` &&
                 ` upload-started toast (original handleUploadPress ran checkFileReadable().then(upload)), and FileUploader.uploadComplete shows the hardcoded success message the original built (handleUploadComplete` &&
                 ` parsed a hardcoded 'Status: 200' response and toasted '(Upload Success)'). The uploadUrl='upload/' is kept 1:1.` ) ).

    lv_text1 = `NOTE: handleUploadPress reproduced since 2026-07-30: the Upload File press fires a backend UPLOAD round-trip; FileUploader.value is two-way bound (an added value attribute, declared) so the backend` &&
               ` runs the original's empty check - no file chosen toasts 'Choose a file first' (1:1), else follow_up_action control_by_id fileUploader upload + clear reproduce oFileUploader.upload() then clear()` &&
               ` (both public non-denied methods via the generalized allowlist). The earlier tooltip-derived 'Uploading file to the local server ...' toast is gone. NOT reproduced: checkFileReadable() - a client-side` &&
               ` File API probe whose rejection branch ('The file cannot be read. It may have changed.') has no declarative equivalent; the port uploads without the readability pre-check. // NOTE:` &&
               ` handleUploadComplete: the original parses a hardcoded 'File upload complete. Status: 200' response and toasts '<response> (Upload Success)'. Reproduced as a client-composed MessageToast with the` &&
               ` resolved literal 'File upload complete. Status: 200 (Upload Success)' (endpoint-independent, same as app 126). // NOTE: change and typeMissmatch handlers are reproduced 1:1 as roundtrip-free`.
    lv_text1 = lv_text1 && ` client-composed MessageToasts (control_global MESSAGE_TOAST.show): change -> "Press 'Upload File' to upload file '{0}'" filled by ${$parameters>/newValue}; typeMissmatch -> 'The file type *.{0} is` &&
               ` not supported. Choose one of the following types: txt, jpg' filled by ${$parameters>/fileType}. The allowed-types list is folded to the literal 'txt, jpg' (the static fileType property the original` &&
               ` builds it from); the original's aFileTypes.map(...) result is unused there too, so the message text matches. // NOTE: live-verified 2026-08-04 (nightly e2e interaction): The client-composed toasts` &&
               ` (change/typeMissmatch/uploadComplete/press via control_global MESSAGE_TOAST) and the ${$parameters>/newValue} / ${$parameters>/fileType} event-arg resolution are view-create verified (render-smoke)` &&
               ` but not yet live-verified in a running system. **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): pressing 'Upload File' with no chosen file round-trips and toasts` &&
               ` 'Choose a file first'; the change/typeMissmatch toasts need a real file dialog and remain unexercised.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.FileUploader`           name = `FileUploaderComplex`                           class = `z2ui5_cl_dmo_app_246` path = `src/02/b12/z2ui5_cl_dmo_app_246.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    lv_text1 = `POST-1.71: Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it. // NOTE: anchored open works since the framework` &&
               ` fallback of 2026-07-27 (pr/unified-menu-open-anchored, implemented): the openBy dispatch detects that sap.ui.unified.Menu has no openBy and calls open(false, anchor, 'begin top', 'begin bottom',` &&
               ` anchor) with the button as opener and dock reference - the previously declared no-op wire is now functional, unchanged in the port. Still dropped either way: the keyboard flag (controller` &&
               ` attachBrowserEvent tab/keyup tracking) and the explicit Popup.Dock.BeginTop/BeginBottom constants (default docking is visually equivalent). // NOTE: the fragment Menu (added in the controller via` &&
               ` getView().addDependent(this._menu)) is declared 1:1 inside the Button's ``dependents`` aggregation (the addDependent equivalent, same as app 060) - structurally identical, no loss; structural-diff` &&
               ` ignores the aggregation name. // NOTE: the selected item text/value is read with ${$parameters>/item}.getText() (and .getValue() for the MenuTextFieldItem), a method call on the resolved MenuItemBase`.
    lv_text1 = lv_text1 && ` control, NOT ${$parameters>/item/text}: the $parameters model exposes 'item' as the control object and UI5 keeps properties in the control's internal store, so the path .../item/text reads an` &&
               ` undefined field and the toast arrives empty (same finding as app 060). // NOTE: live-verified 2026-08-04 (nightly e2e interaction): unverified in a running system: (a) the button press opens the Menu` &&
               ` via the 2026-07-27 anchored-open fallback - verify the open in a running system; (b) each MenuItem select toasts "'<text>' pressed" via ${$parameters>/item}.getText() and the MenuTextFieldItem select` &&
               ` toasts "'<value>' entered" via ${$parameters>/item}.getValue(). **e2e-verified 2026-07-30** (transpiled-framework interaction, scripts/e2e-smoke.mjs): the button press opens the sap.ui.unified.Menu` &&
               ` anchored via the openBy->open() fallback ('My 1st Item' visible); the item-select toasts remain unexercised.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Menu`                   name = `MenuItemEventing`                              class = `z2ui5_cl_dmo_app_227` path = `src/02/b10/z2ui5_cl_dmo_app_227.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.21.0`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it.` ) ).

    lv_text1 = `POST-1.71: Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it. // NOTE: anchored open works since the framework` &&
               ` fallback of 2026-07-27 (pr/unified-menu-open-anchored, implemented): the openBy dispatch detects that sap.ui.unified.Menu has no openBy and calls open(false, anchor, 'begin top', 'begin bottom',` &&
               ` anchor) with the button as opener and dock reference - the previously declared no-op wire is now functional, unchanged in the port. Still dropped either way: the keyboard flag (controller` &&
               ` attachBrowserEvent tab/keyup tracking) and the explicit Popup.Dock.BeginTop/BeginBottom constants (default docking is visually equivalent). // NOTE: the sample's handleMenuItemPress branches on the` &&
               ` runtime item: a parent that only opens its submenu is skipped, a sap.ui.unified.MenuTextFieldItem reports getValue() + ' entered', every other item getText() + ' pressed'. **Reproduced 1:1 since` &&
               ` 2026-08-05**: measured with scripts/probes/event-arg-expression-probe.mjs, a class-name ternary resolves inside an event arg, so the whole branch travels as ONE client expression and the`.
    lv_text1 = lv_text1 && ` client-composed toast (a {0} template) prints exactly what the original composes - including the empty text for a submenu parent. The earlier claim that the class cannot be inspected was about the` &&
               ` BACKEND; the expression runs on the client, where the sample's own code runs too. Distinct from app 060's parent-chain breadcrumb, which stays impossible: the expression grammar has no loop. // NOTE:` &&
               ` the fragment Menu (added in the controller via getView().addDependent(this._menu)) is declared 1:1 inside the Button's ``dependents`` aggregation (the addDependent equivalent, same as app 060) -` &&
               ` structurally identical, no loss; structural-diff ignores the aggregation name. // NOTE: the selected item text is read with ${$parameters>/item}.getText() (a method call on the resolved MenuItemBase` &&
               ` control), NOT ${$parameters>/item/text}: the $parameters model exposes 'item' as the control object and UI5 keeps properties in the control's internal store, so the path .../item/text reads an` &&
               ` undefined field and the toast arrives empty (same finding as app 060). // NOTE: unverified in a running system: (a) the button press opens the Menu via the 2026-07-27 anchored-open fallback - verify`.
    lv_text1 = lv_text1 && ` the open in a running system; (b) selecting a menu item toasts "'<text>' pressed" via the Menu-level itemSelect + ${$parameters>/item}.getText(). **e2e-verified 2026-07-31** (scripts/e2e-smoke.mjs` &&
               ` interaction, transpiled backend + real browser): the button press opens the sap.ui.unified.Menu through the 2026-07-27 openBy fallback (open(false, anchor, ...) for a control without its own openBy)` &&
               ` and selecting an item raises the client-composed "'My 1st Item' pressed" toast.`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Menu`                   name = `MenuMenuEventing`                              class = `z2ui5_cl_dmo_app_228` path = `src/02/b10/z2ui5_cl_dmo_app_228.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 0 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
                 ` look.`
        since = `1.21.0`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it.` ) ).

    lv_text1 = `NOTE: handlePressOpenMenu lazily loads Menu.fragment.xml and calls menu.open(bKeyboard, oButton, Popup.Dock.BeginTop, Popup.Dock.BeginBottom, oButton). The port inlines the fragment into the Button's` &&
               ` dependents aggregation (the declarative addDependent equivalent, app 060/227) and opens it client-side through control_by_id/openBy with $event.oSource.sId as the anchor: the openBy dispatch detects` &&
               ` that sap.ui.unified.Menu has no own openBy and falls back to open(false, anchor, 'begin top', 'begin bottom', anchor) - the same call the original makes. Dropped either way: the keyboard flag the` &&
               ` controller collects from a 'tab keyup' browser event (open's first argument), and the explicit Dock constants, which the fallback hardcodes to the same values. // NOTE: namespace representation: the` &&
               ` archived Menu.fragment.xml declares xmlns="sap.ui.unified", so its Menu, MenuItem and MenuItemGroup controls are unprefixed there, while Page.view.xml declares xmlns="sap.m". One port view can carry`.
    lv_text1 = lv_text1 && ` only one default namespace, so it keeps sap.m (matching the view) and writes the two Menu controls, the fourteen MenuItem controls and the three MenuItemGroup controls with the u: prefix. Same tree,` &&
               ` different prefix - no functional difference. // POST-1.71: sap.ui.unified.MenuItemGroup (control @since 1.127) with itemSelectionMode SingleSelect/MultiSelect and MenuItem.selected (@since 1.127) are` &&
               ` the whole point of this sample and are kept 1:1; sap.m.Button.ariaHasPopup (@since 1.84) is kept 1:1 on the trigger button. All newer than UI5 1.71. // LIVE-TEST: not yet run in a system: the` &&
               ` anchored open of the unified Menu and the selectable item groups (single/multi select state).`.
    result = VALUE #( BASE result
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Menu`                   name = `MenuSelectable`                                class = `z2ui5_cl_dmo_app_311` path = `src/02/b15/z2ui5_cl_dmo_app_311.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.21.0`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.ui.unified.MenuItemGroup (control @since 1.127) with itemSelectionMode SingleSelect/MultiSelect and MenuItem.selected (@since 1.127) are the whole point of this sample and are kept 1:1;` &&
                 ` sap.m.Button.ariaHasPopup (@since 1.84) is kept 1:1 on the trigger button. All newer than UI5 1.71.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.HeaderFacetPattern`           name = `ObjectPageSectionShowTitle`                    class = `z2ui5_cl_dmo_app_200` path = `src/03/b02/z2ui5_cl_dmo_app_200.clas.abap`
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

    lv_text1 = `NOTE: Named-model fold: the sample's whole point is the uxap:ModelMapping element inside a custom BlockBase (sample:ModelMappingBlock), which maps the external named model jsonModel (at` &&
               ` {jsonModel>/externalPath}, resolving to /Employee) onto the block's internal named model Contact, so {Contact>firstName}/{Contact>lastName} render John/Miller. abap2UI5 serves a single default model` &&
               ` - a second, independent ABAP-fed named model was DECLINED 2026-07-19 (pr/named-json-models, too complex: one serialized JSONModel per slot). So the two named models are folded into the one default` &&
               ` model: firstName/lastName are seeded at the default-model root and bound {/FIRSTNAME}/{/LASTNAME} (last-segment match with the original {Contact>firstName}/{Contact>lastName}). Consequently the` &&
               ` ModelMapping control (the sample entity, a pure model-mapping config with no visual output) is absent, the externalPath indirection is resolved statically to /Employee, and the ModelMappingBlock` &&
               ` BlockBase wrapper is inlined to its own view content: its forms:SimpleForm (core:Title + two Text) is rendered directly, since ObjectPageSubSection/block content is standard controls (CAPABILITIES`.
    lv_text1 = lv_text1 && ` BlockBase row, apps 161/178). ModelMappingBlock and ModelMapping are therefore both absent and a forms:SimpleForm/core:Title/Text are present in their place.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ModelMapping`                 name = `BoundModelMapping`                             class = `z2ui5_cl_dmo_app_230` path = `src/03/b02/z2ui5_cl_dmo_app_230.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26`
        notes = lv_text1 ) ).

    lv_text1 = `IMPROVISED: Block->content inlining (app 161/187 precedent, CAPABILITIES 'Custom BlockBase blocks in a sap.uxap.ObjectPageLayout'): the five blocks aggregations each hold the sample's own BlockBase` &&
               ` control sample:mySimpleBlock (xmlns:sample='sap.uxap.sample.AnchorBar.controller.blocks', ids bbt1-bbt5). A BlockBase is only a lazy-loading wrapper around a view; mySimpleBlock's view is an html:div` &&
               ` (style 'font-size: 0.875rem') wrapping a forms:SimpleForm (maxContainerCols=2, layout=ResponsiveGridLayout, editable=false) with one Label 'Content' / Text 'some content goes here...' pair. Since` &&
               ` ObjectPageSubSection.blocks accepts any sap.ui.core.Control, that SimpleForm is inlined 1:1 in each blocks aggregation - no custom JS control, thin frontend preserved. Lost with the wrapper: the five` &&
               ` mySimpleBlock controls with their ids, the html:div font-size:0.875rem styling (a core:HTML leaf cannot wrap controls, so the div is not reproducible around the form) and the block view root's own` &&
               ` width='100%' attribute, which goes with the dropped mvc:View wrapper. // NOTE: ObjectPageDynamicHeaderTitle backgroundDesign='Solid' plus ObjectPageLayout backgroundDesignAnchorBar='Translucent'`.
    lv_text1 = lv_text1 && ` (@since 1.58) are pure rendering properties - the port passes them through 1:1, but the rendered title / anchor-bar background was not verified in a running system. **e2e-verified 2026-07-31**` &&
               ` (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): the anchor bar renders with the sapUxAPObjectPageNavigationTranslucent class, the dynamic header title shows 'Denise Smith' and` &&
               ` every inlined block form renders. Residual (nothing e2e can assert): the title's backgroundDesign='Solid' is a pure paint property with no own DOM marker.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageDynamicHeaderTitle` name = `ObjectPageHeaderBackgroundDesign`              class = `z2ui5_cl_dmo_app_258` path = `src/03/b05/z2ui5_cl_dmo_app_258.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
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
               ` original nests an m:Link inside two m:Title controls (Profile, Product Description) and the port keeps that nesting 1:1. Needs a UI5 runtime >= 1.87; below it the Link would not render. // NOTE:` &&
               ` percentValue='42%' is copied verbatim from the original although sap.m.ProgressIndicator.percentValue is typed float - UI5 parses the leading number, so this renders like the original, but the` &&
               ` rendered indicator plus the RatingIndicator value='4' / iconSize='16px' were not verified in a running system. **e2e-verified 2026-07-31** (scripts/e2e-smoke.mjs interaction, transpiled backend +`.
    lv_text1 = lv_text1 && ` real browser): the header ProgressIndicator renders and displays '42%' (so UI5 parses the '42%' string on the float property exactly like the original) and the RatingIndicator renders; the goals` &&
               ` section shows its inlined block content.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageDynamicHeaderTitle` name = `ObjectPageProgressRatingIndicators`            class = `z2ui5_cl_dmo_app_259` path = `src/03/b05/z2ui5_cl_dmo_app_259.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.Avatar is a control @since 1.73 (scope-of: OUT_OF_SCOPE for a sample entity, kept here because the sample's entity sap.uxap.ObjectPageDynamicHeaderTitle is in scope and 1:1 fidelity wins for` &&
                 ` members/controls used inside): two Avatars (snappedHeading, headerContent) with displayShape='Square', initials='HF', displaySize='L'. Needs a UI5 runtime >= 1.73. // sap.m.Title aggregation` &&
                 ` 'content' is @since 1.87 - the original nests an m:Link inside two m:Title controls (Profile, Product Description) and the port keeps that nesting 1:1. Needs a UI5 runtime >= 1.87; below it the Link` &&
                 ` would not render.` ) ).

    lv_text1 = `NOTE: Block->content inlining (app 188/178/161 precedent, CAPABILITIES 'Custom BlockBase blocks in a sap.uxap.ObjectPageLayout'). The original blocks/moreBlocks aggregations each hold a custom` &&
               ` BlockBase control from the sample's SharedBlocks JS: goals:GoalsBlock (id goalsblock), personal:BlockPhoneNumber (id phone), personal:BlockSocial (id social), personal:BlockAdresses (id adresses),` &&
               ` personal:BlockMailing (id mailing, columnLayout=1), personal:PersonalBlockPart1 (id part1, columnLayout=1) and personal:PersonalBlockPart2 (id part2, columnLayout=1). A BlockBase is only a` &&
               ` lazy-loading wrapper around a view, and ObjectPageSubSection.blocks/moreBlocks accept any sap.ui.core.Control, so each block's rendered content (a sap.ui.layout.form.SimpleForm) is inlined directly` &&
               ` here as a form:SimpleForm holding its core:Title, m:Label and m:Text children. Consequently all seven block controls (GoalsBlock, BlockPhoneNumber, BlockSocial, BlockAdresses, BlockMailing,` &&
               ` PersonalBlockPart1, PersonalBlockPart2) are absent from the port and seven form:SimpleForm controls with their core:Title, m:Label and m:Text content are present in their place (the m:Label count`.
    lv_text1 = lv_text1 && ` rises from 3 to 15). The blocks carry no controller behaviour to port; the ObjectPageModel (employee.json) the controller loads is never bound by the view, so no default model is seeded.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageHeader`             name = `KPIObjectPageHeader`                           class = `z2ui5_cl_dmo_app_217` path = `src/03/b02/z2ui5_cl_dmo_app_217.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
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
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageHeaderActionButton` name = `ObjectPageHeaderActionButtons`                 class = `z2ui5_cl_dmo_app_239` path = `src/03/b03/z2ui5_cl_dmo_app_239.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageHeaderContent`      name = `HeaderContent`                                 class = `z2ui5_cl_dmo_app_216` path = `src/03/b02/z2ui5_cl_dmo_app_216.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.30`
        notes = `NOTE: The view is a 1:1 static rebuild - every ObjectStatus/ObjectNumber/Label/Text/ProgressIndicator/ObjectAttribute/Button/Tokenizer value is a literal, exactly as in the original` &&
                 ` ObjectPageHeaderContent view.xml. The sample's controller loads sap/uxap/sample/SharedJSONData/employee.json into a named 'ObjectPageModel', but the view never binds a single field from it (all` &&
                 ` header content is hard-coded in the XML), so the port carries no model_init - omitting a dead model changes nothing in the rendered view.` ) ).

    lv_text1 = `NOTE: Block->content inlining (app 178/161 precedent, CAPABILITIES 'Custom BlockBase blocks in a sap.uxap.ObjectPageLayout'): the original blocks aggregations each hold a custom BlockBase control` &&
               ` goals:GoalsBlock (from the sample's SharedBlocks JS, xmlns:goals='sap.uxap.sample.SharedBlocks.goals'), used 4 times in the four ObjectPageSubSection blocks aggregations. A BlockBase is only a` &&
               ` lazy-loading wrapper around a view; GoalsBlock's rendered content is a sap.ui.layout.form.SimpleForm (editable='false' layout='ColumnLayout') holding three Label/Text goal pairs. Since` &&
               ` ObjectPageSubSection.blocks accepts any sap.ui.core.Control, each goals:GoalsBlock is inlined here as that SimpleForm (form:SimpleForm) with its m:Label/m:Text content - the whole ObjectPage renders` &&
               ` with the thin generic frontend, no custom JS control. Consequently all four goals:GoalsBlock controls are absent from the port and four form:SimpleForm controls (with their Label/Text children) are` &&
               ` present in their place. GoalsBlock has no controller behaviour to port. // POST-1.71: the sap.m.Avatar control (since UI5 1.73) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5`.
    lv_text1 = lv_text1 && ` release >= 1.73 to render it. @since verified in sap/m/Avatar.js:99 (control-level, which the member-level property gate never saw).`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageHeaderContent`      name = `ObjectPageHeaderContentPriorities`             class = `z2ui5_cl_dmo_app_188` path = `src/03/b02/z2ui5_cl_dmo_app_188.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.30`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `the sap.m.Avatar control (since UI5 1.73) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.73 to render it. @since verified in sap/m/Avatar.js:99 (control-level, which` &&
                 ` the member-level property gate never saw).` ) ).

    lv_text1 = `NOTE: Block->content inlining (app 178/161 precedent, CAPABILITIES 'Custom BlockBase blocks in a sap.uxap.ObjectPageLayout'): the original blocks aggregations each hold a custom BlockBase control` &&
               ` blockcolor:BlockBlue (from the sample's SharedBlocks JS, xmlns:blockcolor='sap.uxap.sample.SharedBlocks'), used 4 times with the id attributes bbt1/bbt2/bbt3/bbt4. A BlockBase is only a lazy-loading` &&
               ` wrapper around a view; BlockBlue's rendered content is a single coloured div (<html:div style='height:4em; background-color: #A9EAFF ;'/>). Since ObjectPageSubSection.blocks accepts any` &&
               ` sap.ui.core.Control, each blockcolor:BlockBlue is inlined as a core:HTML leaf carrying that div in its content attribute - the whole ObjectPage renders with the thin generic frontend, no custom JS` &&
               ` control. Consequently all four blockcolor:BlockBlue controls (and their id attributes bbt1/bbt2/bbt3/bbt4) are absent from the port and four core:HTML controls are present in their place. The empty` &&
               ` BlockBlueCtrl controller (a no-op onParentBlockModeChange stub) carries no behaviour to port.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`             name = `AnchorBarNoPopover`                            class = `z2ui5_cl_dmo_app_187` path = `src/03/b02/z2ui5_cl_dmo_app_187.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: Block->content inlining (app 188/217 precedent, CAPABILITIES 'Custom BlockBase blocks in a sap.uxap.ObjectPageLayout'): the blocks / moreBlocks aggregations hold the SharedBlocks BlockBase` &&
               ` controls goals:GoalsBlock, personal:BlockPhoneNumber / BlockSocial / BlockAdresses / BlockMailing / PersonalBlockPart1 / PersonalBlockPart2. A BlockBase is only a lazy-loading wrapper around a view` &&
               ` and each of those views is a static forms:SimpleForm with core:Title / Label / Text children, so each block view is inlined 1:1 into its aggregation. Absent as a result: the seven BlockBase controls` &&
               ` with their ids (goalsblock, phone, social, adresses, mailing, part1, part2), BlockMailing's BlockBase columnLayout='1', and the block views' own mvc:View roots with their width='100%'. // NOTE: The` &&
               ` controller's three JSONModels (SharedJSONData/employee.json as 'ObjectPageModel', an inline 'buttons' model with text/icon, SharedJSONData/products.json as the default OneWay model) are not` &&
               ` reproduced: no control in this sample's view or in any of its inlined block views binds against them - every text is a literal. The port therefore has no model at all (no model_init), which renders`.
    lv_text1 = lv_text1 && ` identically. // NOTE: preserveHeaderStateOnScroll='true' (@since 1.52) is the whole point of the sample - the header content staying expanded while scrolling on desktop. The property is passed` &&
               ` through 1:1 but the scroll behaviour was not verified in a running system. **e2e-verified 2026-07-31** (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): after scrolling the` &&
               ` ObjectPage wrapper to 1500px the header content ('Cost Center') is still visible - that IS preserveHeaderStateOnScroll; without it the header snaps away.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`             name = `ObjectPageHeaderExpanded`                      class = `z2ui5_cl_dmo_app_260` path = `src/03/b05/z2ui5_cl_dmo_app_260.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 3 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: Block->content inlining (app 188/217 precedent, CAPABILITIES 'Custom BlockBase blocks in a sap.uxap.ObjectPageLayout'): the blocks / moreBlocks aggregations hold SharedBlocks BlockBase controls` &&
               ` - goals:GoalsBlock, personal:BlockPhoneNumber / BlockSocial / BlockAdresses / BlockMailing / PersonalBlockPart1 / PersonalBlockPart2, employment:BlockJobInfoPart1 / BlockJobInfoPart2 /` &&
               ` BlockJobInfoPart3 / BlockEmpDetailPart1 / BlockEmpDetailPart2 / BlockEmpDetailPart3 / EmploymentBlockJob, connections:ConnectionsBlock. Each is only a lazy-loading wrapper around a view, so every` &&
               ` block view is inlined 1:1 into its aggregation (forms:SimpleForm with core:Title / Label / Text, a layout:HorizontalLayout / layout:VerticalLayout tree, the layout:Grid / layout:GridData tree of` &&
               ` EmploymentBlockJobCollapsed, and the six m:Panel / m:VBox / m:Image of ConnectionsBlock). Absent as a result: the 14 BlockBase controls with their ids and their BlockBase columnLayout='1' properties,` &&
               ` and the block views' own mvc:View roots. // IMPROVISED: Named-model fold (app 230 precedent): EmploymentBlockJob and ConnectionsBlock each carry six uxap:ModelMapping elements mapping an external`.
    lv_text1 = lv_text1 && ` model onto the internal models emp1>..emp6> (/Employee/0..5). abap2UI5 serves one default model, so the twelve ModelMapping config controls are gone and the six employee records are seeded as` &&
               ` default-model root fields (emp1_name/_job/_picture .. emp6_*) bound via client->_bind. EmploymentBlockJob is additionally a two-view BlockBase (Collapsed / Expanded with showSubSectionMore='true');` &&
               ` only the Collapsed view (employees 1-2) is inlined - the Expanded view with employees 3-6 and the more/less toggle are lost. // NOTE: The ModelMapping elements in this sample name` &&
               ` externalModelName='data' while the controller registers the JSONModel as 'ObjectPageModel' - upstream those block labels therefore resolve to nothing. The port seeds the evidently intended` &&
               ` SharedJSONData/HRData.json /Employee rows (Michael Adams / Scrum Master, John Miller / Product Owner, Richard Wilson / Ux Designer, Julie Armstrong / Quality Engineer, Denise Smith / Team Member,` &&
               ` Richard Adams / Team Member) and the person.png picture, i.e. it renders the data the sample means rather than the empty labels the name mismatch produces. // NOTE: onNavigate's`.
    lv_text1 = lv_text1 && ` setSelectedSection(null): sap.uxap.ObjectPageLayout.selectedSection is an ASSOCIATION, so it cannot be data-bound and the reset must go through the frontend action. Since 2026-08-05 an EMPTY argument` &&
               ` reaches the setter as null (the controlIdOrNull argument kind, pr/control-method-null-arg; the framework pads a trailing empty argument for that kind, because the wire drops trailing empties), so the` &&
               ` NAVIGATE round-trip - the NavContainer's navigate event, transporting ${$parameters>/toId} - issues follow_up_action( control_by_id, ObjectPageLayout / setSelectedSection / ```` ) and clears the` &&
               ` association exactly like the original. The earlier substitute (naming the first section 'goals', which is what UI5's _adjustSelectedSectionByUXRules falls back to) is gone. The checkbox that guards` &&
               ` the reset is two-way bound ({/RESET_CHECK}, seeded true like the original selected='true'), so the backend can read it without touching the DOM. // POST-1.71: sap.m.Avatar is a control @since 1.73` &&
               ` (kept for 1:1 fidelity, the sample entity sap.uxap.ObjectPageLayout is in scope): the snappedHeading avatar and the headerContent avatar (displaySize='L'). Needs a UI5 runtime >= 1.73. // NOTE: The`.
    lv_text1 = lv_text1 && ` page navigation is roundtrip-free _event_client( control_by_id, navigationContainer / to / page1|page2 ) - the client-side equivalent of the controller's _navTo (oNavContainer.to(oPage)); 'to' is` &&
               ` whitelisted in CONTROL_METHODS. Neither the navigation, the NAVIGATE round-trip nor the setSelectedSection follow-up was verified in a running system. **e2e-verified 2026-07-31**` &&
               ` (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): the 'To ObjectPage' list item navigates to page 2 (NavContainer.to via _event_client control_by_id, ObjectPage with 'Denise` &&
               ` Smith' renders) and the nav-back button returns to page 1. Residual: the setSelectedSection reset itself (NAVIGATE round-trip with the checkbox ticked) is not asserted - the page has no icon tab bar,` &&
               ` so the selected section has no stable DOM marker. // NOTE: The Avatar / Image src values point at the sdk.openui5.org host (imageID_275314.png, linkedin.png, Twitter.png, person.png) per the offline` &&
               ` asset-URL rule; the original and HRData.json use the relative ./test-resources path.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`             name = `ObjectPageResetSelectedSection`                class = `z2ui5_cl_dmo_app_263` path = `src/03/b05/z2ui5_cl_dmo_app_263.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close` &&
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
               ` sap.uxap.ObjectPageLayout is in scope): the snappedHeading avatar (id snappedAvatar) and the headerContent avatar (id headerAvatar). Needs a UI5 runtime >= 1.73. // NOTE: showFooter is two-way bound`.
    lv_text1 = lv_text1 && ` ({/SHOW_FOOTER}, seeded false = the original's ObjectPageLayout default, since the sample sets no showFooter attribute) and the Toggle Footer button flips it on a round-trip (view_model_update) - the` &&
               ` faithful abap2UI5 form of the controller's setShowFooter(!getShowFooter()); a scalar literal -> binding is not a structural diff. The two breadcrumb Link presses and the editHeaderButtonPress raise` &&
               ` client-composed MessageToasts via _event_client control_global MESSAGE_TOAST (roundtrip-free, apps 005/060/244). Footer round-trip, toast wiring and the editHeaderButtonPress attribute are unverified` &&
               ` in a running system. **e2e-verified 2026-07-31** (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): the Toggle Footer press flips the two-way bound showFooter over a real` &&
               ` round-trip (the footer with Accept/Reject appears), and the breadcrumb entry raises its client-composed toast 'Page 1 a very long link clicked' (at this viewport the Breadcrumbs collapse into a` &&
               ` Select, so the entry is picked from its list). Residual: editHeaderButtonPress - the ObjectPage's pencil button only appears on header hover, so its toast stays a human check. // NOTE: Both Avatar`.
    lv_text1 = lv_text1 && ` src values point at the sdk.openui5.org host (https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_275314.png) per the offline asset-URL rule; the original uses the relative` &&
               ` ./test-resources path. Literal src values are not compared by structural-diff.`.
    lv_text2 = `sap.uxap.ObjectPageLayout.breakpointChange (@since 1.147, incl. its currentRange / currentWidth parameters) is the whole point of this sample and is wired 1:1 as a view attribute (an added attr - the` &&
               ` original attaches it imperatively in onInit via attachBreakpointChange): BREAKPOINT_CHANGE transports ${$parameters>/currentRange} and ${$parameters>/currentWidth}, the backend maps Phone->M /` &&
               ` Tablet->L / Desktop and DesktopExtraLarge->XL into the two-way bound Avatar displaySize ({/AVATAR_SIZE}, an added attribute on both Avatars, seeded L like the controller's default branch) and toasts` &&
               ` 'Media Range: <range> (<width>px) / Avatar Size: <size>' exactly like onBreakpointChange. Same wiring as app 244 (the sap.f.DynamicPage twin of this sample). Requires a UI5 release >= 1.147; on older` &&
               ` releases the event never fires and both Avatars keep the seeded L. // sap.m.Avatar is a control @since 1.73 (kept for 1:1 fidelity, the sample entity sap.uxap.ObjectPageLayout is in scope): the` &&
               ` snappedHeading avatar (id snappedAvatar) and the headerContent avatar (id headerAvatar). Needs a UI5 runtime >= 1.73.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`             name = `ObjectPageResponsiveAvatar`                    class = `z2ui5_cl_dmo_app_262` path = `src/03/b05/z2ui5_cl_dmo_app_262.clas.abap`
        score = 4
        score_tip = `Rating 4 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted, live-test). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26`
        is_post171 = abap_true
        notes = lv_text1
        post171 = lv_text2 ) ).

    lv_text1 = `NOTE: **Rebuilt on 2026-08-05** - it was a breadth probe whose blocks were replaced by a Text and whose third subsection plus both moreBlocks aggregations were dropped. All three subsections and all` &&
               ` TEN sample:MultiViewBlock positions are there now, each inlined with its block view's CONTENT (CAPABILITIES 'Custom BlockBase blocks', apps 161/178/188): a BlockBase is only a lazy-loading wrapper` &&
               ` around a view, and ObjectPageSubSection.blocks/moreBlocks accept any control. MultiViewBlock ships TWO views and picks by the block MODE - Collapsed (Country/Subsidiary) and Expanded (+` &&
               ` Building/Room). abap2UI5 has no BlockBase mode, so each block carries the variant its subsection asks for (mode='Expanded' the expanded form, the default-mode subsection the collapsed one), which is` &&
               ` exactly what the sample renders on load; what is lost is the per-block runtime switching. Structurally that means: the 10 sample:MultiViewBlock controls are absent, 10 forms:SimpleForm are present in` &&
               ` their place (the original side counts the two block VIEWS once, not their ten instances), and their Label/Text children move to the m: prefix - 6 vs 32 each, the same shape every BlockBase port in`.
    lv_text1 = lv_text1 && ` this corpus declares. The view is written out per block rather than through a helper method, so the structural diff can reconstruct it statically.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`             name = `ObjectPageSubSection`                          class = `z2ui5_cl_dmo_app_116` path = `src/03/b01/z2ui5_cl_dmo_app_116.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: Block->content inlining (app 188/217 precedent, CAPABILITIES 'Custom BlockBase blocks in a sap.uxap.ObjectPageLayout'): the blocks / moreBlocks aggregations hold SharedBlocks BlockBase controls` &&
               ` - goals:GoalsBlock, personal:BlockAdresses / BlockPhoneNumber / BlockSocial / BlockMailing / PersonalBlockPart1 / PersonalBlockPart2, employment:BlockJobInfoPart1 / BlockJobInfoPart2 /` &&
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
    lv_text1 = lv_text1 && ` NOTE: live-verified 2026-08-04 (nightly e2e interaction): subSectionLayout='TitleOnLeft' is the point of the sample (subsection titles rendered in a left column instead of above the content). The` &&
               ` property is passed through 1:1 but the resulting layout was not verified in a running system. **e2e-verified 2026-07-31** (scripts/e2e-smoke.mjs interaction, transpiled backend + real browser): the` &&
               ` ObjectPage renders and the folded emp1>/emp2> ModelMapping records show ('Michael Adams'), and the Job Relationship subsection title is there. The TitleOnLeft layout itself stays a human check:` &&
               ` measured in the source, subSectionLayout only changes the subsection's grid column math (ObjectPageSubSection._calculateLayoutConfiguration) - it emits no own CSS class an assertion could hook onto.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`             name = `ObjectPageTitleOnLeft`                         class = `z2ui5_cl_dmo_app_261` path = `src/03/b05/z2ui5_cl_dmo_app_261.clas.abap`
        score = 5
        score_tip = `Rating 5 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 reworked). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26`
        is_post171 = abap_true
        notes = lv_text1
        post171 = `sap.m.Avatar is a control @since 1.73 (kept for 1:1 fidelity, the sample entity sap.uxap.ObjectPageLayout is in scope): src='sap-icon://picture' in the snappedHeading and in the headerContent` &&
                 ` (displaySize='L'). Needs a UI5 runtime >= 1.73.` ) ).

    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`             name = `SingleView`                                    class = `z2ui5_cl_dmo_app_161` path = `src/03/b02/z2ui5_cl_dmo_app_161.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26`
        notes = `NOTE: Wall-break for sap.uxap: the original blocks aggregation holds a custom BlockBase control (blockcolor:BlockBlue from the sample's SharedBlocks JS). A BlockBase is only a lazy-loading wrapper` &&
                 ` around a view; its content (a single coloured div) is inlined here as core:HTML, since ObjectPageSubSection.blocks accepts any sap.ui.core.Control. This removes the need for a custom JS control - the` &&
                 ` whole uxap ObjectPage renders with the thin generic frontend. The blockcolor:BlockBlue control is therefore absent and a core:HTML is present in its place.` ) ).

    lv_text1 = `NOTE: Block->content inlining (app 178/161 precedent, CAPABILITIES 'Custom BlockBase blocks in a sap.uxap.ObjectPageLayout'): the original blocks aggregations each hold a custom BlockBase control` &&
               ` (blockcolor:BlockBlueT1, blockcolor:BlockBlueT2, blockcolor:BlockBlueT3, blockcolor:BlockBlueT4, blockcolor:BlockBlueT5, from the sample's SharedBlocks JS,` &&
               ` xmlns:blockcolor='sap.uxap.sample.SharedBlocks'), used once each with ids bbt1/bbt2/bbt3/bbt4/bbt5. A BlockBase is only a lazy-loading wrapper around a view; each BlockBlueTn's rendered content is a` &&
               ` single coloured div (<html:div style='height:auto;min-height:4em; background-color: #A9EAFF ;line-height: 4em;'>...explanatory text...</html:div>). Since ObjectPageSubSection.blocks accepts any` &&
               ` sap.ui.core.Control, each blockcolor:BlockBlueTn is inlined as a core:HTML leaf carrying that div in its content attribute - the whole ObjectPage renders with the thin generic frontend, no custom JS` &&
               ` control. Consequently all five blockcolor:BlockBlueT1..T5 controls (and their id attributes) are absent from the port and five core:HTML controls are present in their place; the`.
    lv_text1 = lv_text1 && ` xmlns:blockcolor='sap.uxap.sample.SharedBlocks' declaration is dropped and xmlns:core='sap.ui.core' added. The block sources are not archived into ui5/ (matching the scaffolder), read from the` &&
               ` checkout's SharedBlocks/BlockBlueTn.view.xml.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageSection`            name = `ObjectPageSection`                             class = `z2ui5_cl_dmo_app_184` path = `src/03/b02/z2ui5_cl_dmo_app_184.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26`
        notes = lv_text1 ) ).

    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageSubSection`         name = `ObjectPageSubSectionBackground`                class = `z2ui5_cl_dmo_app_293` path = `src/03/b06/z2ui5_cl_dmo_app_293.clas.abap`
        score = 1
        score_tip = `Rating 1 of 5 - how much attention this port deserves (complexity + rework + review + test-priority). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26` ) ).

    lv_text1 = `NOTE: The ObjectNumber state binding differs: the original binds state="{path:'WeightMeasure', formatter:'.weightState'}" to a controller formatter (parseFloat + Success/Warning/Error thresholds).` &&
               ` That is business logic, so - abap2UI5 being a thin frontend - the weightState is computed in ABAP model_init into a WEIGHTSTATE field and bound state="{WEIGHTSTATE}", not via a frontend formatter.` &&
               ` Visually 1:1 with the original (apps 009/010/022/092 precedent). No core:require is dropped - the original registers the formatter as a controller method, not on the view root. // NOTE: The default` &&
               ` JSONModel (products.json) is folded into the one default model: the Table items path {/ProductCollection} and the row bindings ({SupplierName}, Currency parts:[{path:'Price'},...]) keep the same leaf` &&
               ` names, so structural-diff matches 0 diffs. Full 123-row ProductCollection inlined verbatim; only the columns the view binds are kept as fields. The Price Currency composite type binding is kept 1:1` &&
               ` (price TYPE p) - standard client-side type, no version issue.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageSubSection`         name = `ObjectPageSubSectionHiddenTitle`               class = `z2ui5_cl_dmo_app_245` path = `src/03/b04/z2ui5_cl_dmo_app_245.clas.abap`
        score = 3
        score_tip = `Rating 3 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: complex, 2 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
        since = `1.26`
        notes = lv_text1 ) ).

    lv_text1 = `NOTE: Block->content inlining (app 161 precedent, CAPABILITIES 'Custom BlockBase blocks in a sap.uxap.ObjectPageLayout'): the original blocks aggregations each hold a custom BlockBase control` &&
               ` blockcolor:BlockBlue (from the sample's SharedBlocks JS, xmlns:blockcolor='sap.uxap.sample.SharedBlocks'), used 3 times (ids b1/b2/b3). A BlockBase is only a lazy-loading wrapper around a view;` &&
               ` BlockBlue's rendered content is a single coloured div (<html:div style='height:4em; background-color: #A9EAFF ;'/>). Since ObjectPageSubSection.blocks accepts any sap.ui.core.Control, each` &&
               ` blockcolor:BlockBlue is inlined as a core:HTML leaf carrying that div in its content attribute - the whole ObjectPage renders with the thin generic frontend, no custom JS control. Consequently all` &&
               ` three blockcolor:BlockBlue controls (and their id attributes) are absent from the port and three core:HTML controls are present in their place. The empty BlockBlueCtrl controller (a no-op` &&
               ` onParentBlockModeChange stub) carries no behaviour to port.`.
    result = VALUE #( BASE result
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageSubSection`         name = `ObjectPageSubSectionWithActions`               class = `z2ui5_cl_dmo_app_178` path = `src/03/b02/z2ui5_cl_dmo_app_178.clas.abap`
        score = 2
        score_tip = `Rating 2 of 5 - how much attention this port deserves (complexity + rework + review + test-priority: 1 noted). 1 = simple faithful 1:1, 5 = complex / reworked / worth a close look.`
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
