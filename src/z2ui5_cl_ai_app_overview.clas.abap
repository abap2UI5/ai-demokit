"! Generated overview app - lists every abap2UI5 api sample app in a table.
"! In the Sample column the name links the OpenUI5 source and the ↗ starts the
"! live OpenUI5 sample; in the abap2UI5 column the class name links the generated
"! ABAP class and the ↗ starts the app; Control links the OpenUI5 API - all
"! opening in a new browser tab. The Note column shows a green check when the
"! port was manually verified in a running system, and a hint button that opens
"! a popup with the port's generation caveats when present. Do not edit by hand -
"! regenerate with scripts/generate-overview.mjs
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
      END OF ty_s_app.
    TYPES ty_t_app TYPE STANDARD TABLE OF ty_s_app WITH EMPTY KEY.

    DATA t_app TYPE ty_t_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS get_catalog
      RETURNING
        VALUE(result) TYPE ty_t_app.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_overview IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `SHOW_NOTES`.
        " one Text per bullet of the clicked row's generation notes
        SPLIT client->get_event_arg( ) AT ` // ` INTO TABLE DATA(lt_line).

        DATA(popup) = z2ui5_cl_ai_xml=>factory( ).
        DATA(box) = popup->open( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`

            )->open( `Dialog`
                )->a( n = `title`        v = `Generation notes`
                )->a( n = `contentWidth` v = `34rem`

                )->open( `VBox`
                    )->a( n = `class` v = `sapUiContentPadding` ).

        LOOP AT lt_line INTO DATA(lv_line).
          box->leaf( `Text`
              )->a( n = `text` v = lv_line ).
        ENDLOOP.

        box->shut( )->open( `endButton`
            )->leaf( `Button`
                )->a( n = `text`  v = `Close`
                )->a( n = `press` v = client->_event_client( client->cs_event-popup_close ) ).

        client->popup_display( popup->stringify( ) ).

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

    ENDLOOP.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( `Shell`
            )->open( `Page`
                )->a( n = `title`          v = `abap2UI5 - api`
                )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
                )->a( n = `showNavButton`  v = z2ui5_cl_ai_xml=>as_bool( client->check_app_prev_stack( ) )

                )->open( `Table`
                    )->a( n = `sticky` v = `ColumnHeaders`
                    )->a( n = `items`  v = client->_bind( t_app )

                    )->open( `columns`
                        )->open( `Column`
                            )->leaf( `Text`
                                )->a( n = `text` v = `Module`

                        )->shut(
                        )->open( `Column`
                            )->leaf( `Text`
                                )->a( n = `text` v = `Control`

                        )->shut(
                        )->open( `Column`
                            )->leaf( `Text`
                                )->a( n = `text` v = `Sample`

                        )->shut(
                        )->open( `Column`
                            )->leaf( `Text`
                                )->a( n = `text` v = `abap2UI5`

                        )->shut(
                        )->open( `Column`
                            )->leaf( `Text`
                                )->a( n = `text` v = `Note`

                        )->shut(
                    )->shut(

                    )->open( `items`
                        )->open( `ColumnListItem`
                            )->open( `cells`
                                )->leaf( `Text`
                                    )->a( n = `text` v = `{MODULE}`
                                )->leaf( `Link`
                                    )->a( n = `text`   v = `{CTRL_NAME}`
                                    )->a( n = `href`   v = `{API_URL}`
                                    )->a( n = `target` v = `_blank`

                                )->open( `HBox`
                                    )->leaf( `Link`
                                        )->a( n = `text`   v = `{NAME}`
                                        )->a( n = `href`   v = `{JS_URL}`
                                        )->a( n = `target` v = `_blank`
                                    )->leaf( `Text`
                                        )->a( n = `text` v = ` `
                                    )->leaf( `Link`
                                        )->a( n = `text`   v = `↗`
                                        )->a( n = `href`   v = `{UI5_URL}`
                                        )->a( n = `target` v = `_blank`

                                )->shut(
                                )->open( `HBox`
                                    )->leaf( `Link`
                                        )->a( n = `text`   v = `{CLASS}`
                                        )->a( n = `href`   v = `{ABAP_URL}`
                                        )->a( n = `target` v = `_blank`
                                    )->leaf( `Text`
                                        )->a( n = `text` v = ` `
                                    )->leaf( `Link`
                                        )->a( n = `text`   v = `↗`
                                        )->a( n = `href`   v = `{START_URL}`
                                        )->a( n = `target` v = `_blank`

                                )->shut(
                                )->open( `HBox`
                                    )->a( n = `alignItems` v = `Center`

                                    )->leaf( `core:Icon`
                                        )->a( n = `src`     v = `sap-icon://accept`
                                        )->a( n = `color`   v = `#107e3e`
                                        )->a( n = `tooltip` v = `{CHECKED}`
                                        )->a( n = `visible` v = `{HAS_CHECK}`
                                    " orange badge when the port keeps members newer than UI5 1.71 (POST_171)
                                    )->leaf( `ObjectStatus`
                                        )->a( n = `text`    v = `1.71+`
                                        )->a( n = `state`   v = `Warning`
                                        )->a( n = `tooltip` v = `{POST171}`
                                        )->a( n = `visible` v = `{HAS_P171}`
                                    )->leaf( `Button`
                                        )->a( n = `icon`    v = `sap-icon://hint`
                                        )->a( n = `type`    v = `Transparent`
                                        )->a( n = `tooltip` v = `{NOTES}`
                                        )->a( n = `visible` v = `{HAS_NOTES}`
                                        )->a( n = `press`   v = client->_event( val = `SHOW_NOTES` t_arg = VALUE #( ( `${NOTES}` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD get_catalog.

    result = VALUE #(
      ( module = `sap.m` control = `sap.m.ActionListItem`              name = `ActionListItem`              class = `z2ui5_cl_ai_app_531` path = `src/01/b05/z2ui5_cl_ai_app_531.clas.abap` )
      ( module = `sap.m` control = `sap.m.Bar`                         name = `Page`                        class = `z2ui5_cl_ai_app_532` path = `src/01/b05/z2ui5_cl_ai_app_532.clas.abap` )
      ( module = `sap.m` control = `sap.m.Breadcrumbs`                 name = `Breadcrumbs`                 class = `z2ui5_cl_ai_app_530` path = `src/01/b01/z2ui5_cl_ai_app_530.clas.abap`
        notes = `LIVE-TEST: the SEP_CHANGE round-trip (which read a private UI5-internal event path) was removed 2026-07-16 - selectedKey and separatorStyle share one two-way bound path, so the separator switches` &&
                 ` client-side. Confirm the instant separator change in a running system. NOTE: an earlier version of this port WAS live-checked 2026-07-15 (the ${$source>/text} event arg delivered the clicked link's` &&
                 ` text), but that check predates this rework, so the checked status was reset 2026-07-19 per the checked-invalidation rule (AGENTS.md §10) - re-verify and restamp.` )
      ( module = `sap.m` control = `sap.m.BusyDialog`                  name = `BusyDialog`                  class = `z2ui5_cl_ai_app_533` path = `src/01/b05/z2ui5_cl_ai_app_533.clas.abap`
        notes = `NOTE: the BusyDialog fragment is rebuilt 1:1 as a core:FragmentDefinition shown via client->popup_display (the framework's displayFragment calls .open() on the fragment root, the equivalent of the` &&
                 ` controller's Fragment.load + oBusyDialog.open()); one attribute is added vs the original fragment: id="busyDialog", needed so the backend timer event can close the dialog via the whitelisted` &&
                 ` control_by_id 'close' method (CONTROL_METHODS in FrontendAction.js, no-arg; the id resolves in the POPUP slot via Fragment.byId('popupId', ...)) - the equivalent of the controller's` &&
                 ` oBusyDialog.close(). // NOTE: the controller's simulateServerRequest (setTimeout 3000ms) becomes the framework timer: follow_up_action( cs_event-start_timer, callbackEvent TIMER_FINISHED, 3000 )` &&
                 ` started with the popup. A running frontend timer cannot be cleared from ABAP (the original's clearTimeout in onDialogClosed), so after a cancel the timer still fires one backend round-trip; a` &&
                 ` protected guard flag (check_busy) ignores it - same visible behavior (no second toast, dialog already closed), one extra no-op round-trip. // NOTE: the controller's syncStyleClass('sapUiSizeCompact',` &&
                 ` view, dialog) is dropped: it only copies the compact-density class when the view itself carries it, which the sample view does not; abap2UI5's popup slot has no per-view density sync, so there is` &&
                 ` nothing to propagate. // LIVE-TEST: verify the full cycle in a running system: press -> popup BusyDialog opens -> 3s frontend timer -> TIMER_FINISHED -> control_by_id close on 'busyDialog' in the` &&
                 ` POPUP slot -> BusyDialog close event (cancelPressed=false) -> 'The operation has been completed' toast; and the cancel path within 3s: cancelPressed=true arrives as abap_bool via` &&
                 ` ${$parameters>/cancelPressed} -> 'The operation has been cancelled' toast, stale timer round-trip ignored.` )
      ( module = `sap.m` control = `sap.m.Button`                      name = `Button`                      class = `z2ui5_cl_ai_app_526` path = `src/01/b03/z2ui5_cl_ai_app_526.clas.abap`
        checked = `CHECKED (2026-07-15): manually verified in a running system - each press toasts the pressed button's client-side control id, read via the event arg $event.oSource.sId, exactly like the original.` )
      ( module = `sap.m` control = `sap.m.Carousel`                    name = `CarouselWithControls`        class = `z2ui5_cl_ai_app_420` path = `src/01/b04/z2ui5_cl_ai_app_420.clas.abap`
        checked = `CHECKED (2026-07-15): manually verified in a running system - renders and scrolls like the original (see the note below on the flattened image model).`
        notes = `IMPROVISED: the three carousel images bind to a separate named model in the original (img>/products/pic1..3 from sap/ui/demo/mock/img.json); resolved here to static image URLs, as abap2UI5 serves a` &&
                 ` single default model. // SUBSET: the bound /ProductCollection shows a 10-row subset of the 123-row mock (ui5/mock/products.json) - a full unroll adds no demo value. // POST-1.71: ariaLabelledBy on` &&
                 ` the Carousel (since UI5 1.125) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.125 to render it.`
        post171 = `ariaLabelledBy on the Carousel (since UI5 1.125) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.125 to render it.` )
      ( module = `sap.m` control = `sap.m.CheckBox`                    name = `CheckBoxTriState`            class = `z2ui5_cl_ai_app_421` path = `src/01/b02/z2ui5_cl_ai_app_421.clas.abap`
        checked = `CHECKED (2026-07-15): manually verified in a running system - the select-all parent checkbox and its tri-state expression bindings behave like the original.` )
      ( module = `sap.m` control = `sap.m.ColorPalette`                name = `ColorPalette`                class = `z2ui5_cl_ai_app_422` path = `src/01/b02/z2ui5_cl_ai_app_422.clas.abap` )
      ( module = `sap.m` control = `sap.m.Column`                      name = `Table`                       class = `z2ui5_cl_ai_app_534` path = `src/01/b05/z2ui5_cl_ai_app_534.clas.abap`
        notes = `IMPROVISED: the shared demo kit mock model sap/ui/demo/mock/products.json (/ProductCollection, snapshotted in ui5/mock/products.json) is flattened into the default model: all 123 rows are kept` &&
                 ` verbatim, but only the bound columns (ProductId, Name, SupplierName, WeightMeasure, WeightUnit, Width, Depth, Height, DimUnit, Price, CurrencyCode) are ported - the unbound columns (Category,` &&
                 ` MainCategory, TaxTarifCode, Description, DateOfSale, ProductPicUrl, Status, Quantity, UoM) of the shared mock model are dropped. // IMPROVISED: the controller's onPopinLayoutChanged (ComboBox change` &&
                 ` handler running a PopinLayout switch with a Block default) is expressed as bound properties instead of a round-trip (AGENTS 'prefer a bindable property'): the ComboBox's change attribute is dropped,` &&
                 ` its selectedKey is bound two-way, and the Table gains a popinLayout expression binding that reproduces the switch including its Block default. // IMPROVISED: the controller's onToggleInfoToolbar` &&
                 ` (ToggleButton press handler calling getInfoToolbar().setVisible(!pressed)) is expressed as bound properties instead of a round-trip: the ToggleButton's press attribute is dropped, its pressed` &&
                 ` property is bound two-way, and the infoToolbar's OverflowToolbar gains a visible={= !pressed } expression binding. // IMPROVISED: the controller's onSelect (imperative oTable.setSticky array` &&
                 ` maintenance from the CheckBox text + selected parameter) becomes a sticky property on the Table bound to a plain string table: each CheckBox select event round-trips ${$source>/text} and` &&
                 ` ${$parameters>/selected}, the ABAP handler inserts/removes that option and pushes the model back via view_model_update. // LIVE-TEST: verify the string-table-bound sticky property (type` &&
                 ` sap.m.Sticky[]) applies and clears the sticky behavior on round-trips, and that the popinLayout / infoToolbar-visible expression bindings react client-side without a round-trip. // POST-1.71:` &&
                 ` core:require (since UI5 1.74) on the view root loads the curated formatter module z2ui5/model/formatter for the weightState binding - the app needs a UI5 release >= 1.74 to render it. // NOTE: the` &&
                 ` original's local Formatter.js is referenced as formatter: '.formatter.weightState'; the port keeps the identical parts binding but references the framework's curated formatter module as` &&
                 ` 'Formatter.weightState' (same thresholds/logic, source-verified in abap2UI5 app/webapp/model/formatter.js). // 1.71: the p:ColumnAIAction column plugin (sap.m.plugins, since UI5 1.136 - far newer` &&
                 ` than 1.71) is dropped with its dependents aggregation, the xmlns:p namespace and the press toast - the plugin class does not exist on a 1.71 runtime, so keeping it would break view creation there` &&
                 ` (same decision as app 401).`
        post171 = `core:require (since UI5 1.74) on the view root loads the curated formatter module z2ui5/model/formatter for the weightState binding - the app needs a UI5 release >= 1.74 to render it.` )
      ( module = `sap.m` control = `sap.m.ColumnListItem`              name = `TableTest`                   class = `z2ui5_cl_ai_app_535` path = `src/01/b05/z2ui5_cl_ai_app_535.clas.abap`
        notes = `NOTE: the sample is an OPA-test demo: only the UI app under applicationUnderTest/ (Table.view.xml, Table.controller.js, Formatter.js, products.json) is ported 1:1; the qunit/OPA harness files` &&
                 ` (OpaTableTest.qunit.js, Test.qunit.html, testsuite.qunit.*) are test infrastructure without UI and are not ported. // IMPROVISED: the controller's onPopinLayoutChanged` &&
                 ` (byId(idProductsTable).setPopinLayout per the ComboBox selectedKey switch) is a pure client-side path: two-way bound ComboBox selectedKey feeding a popinLayout expression binding with the same` &&
                 ` GridLarge/GridSmall-else-Block fallback (extra attributes vs the original view, original change handler dropped) - no round-trip, same pattern as app 534; the expression can never emit an empty enum` &&
                 ` value. // NOTE: the controller-built sap.m.Dialog of onMessageDialogPress (title Message, type Message, a Text 'Success' as content, an OK beginButton Button that closes it) is rebuilt 1:1 as a` &&
                 ` core:FragmentDefinition shown via client->popup_display on the ColumnListItem press event; the OK Button closes roundtrip-free via the frontend action _event_client( cs_event-popup_close ), and the` &&
                 ` original's afterClose destroy is the framework's popup lifecycle. The Dialog, its Text and its Button are extra controls vs the original view.xml (controller-created there). // NOTE: the sample's` &&
                 ` local Formatter.weightState is byte-identical in behavior to the framework formatter module's weightState (sap.m.sample.Table shape, source-verified in abap2UI5 app/webapp/model/formatter.js), so the` &&
                 ` state binding string formatter: 'Formatter.weightState' stays 1:1; only the view root's core:require value points at z2ui5/model/formatter instead of the sample's own Formatter module path. //` &&
                 ` POST-1.71: core:require on the view root (since UI5 1.74) wires the formatter module - the app needs a UI5 release >= 1.74 to render it (pre-1.74 the published global z2ui5.Formatter.weightState` &&
                 ` would be the fallback). // IMPROVISED: model flattening: the sample's LOCAL applicationUnderTest/products.json (123 rows) is moved into the default model verbatim, unbound columns dropped. Note: the` &&
                 ` local file is NOT identical to the shared mock ui5/mock/products.json - same 123 ProductIds, but HT-9995 differs in content (local: Smartphone Cover / 15 EUR vs mock: Tablet Pouch / 20 EUR); the port` &&
                 ` follows the local file, the sample's actual model source.`
        post171 = `core:require on the view root (since UI5 1.74) wires the formatter module - the app needs a UI5 release >= 1.74 to render it (pre-1.74 the published global z2ui5.Formatter.weightState would be the` &&
                 ` fallback).` )
      ( module = `sap.m` control = `sap.m.ComboBox`                    name = `ComboBox`                    class = `z2ui5_cl_ai_app_423` path = `src/01/b02/z2ui5_cl_ai_app_423.clas.abap` )
      ( module = `sap.m` control = `sap.m.ComparisonPattern`           name = `ComparisonPattern`           class = `z2ui5_cl_ai_app_536` path = `src/01/b05/z2ui5_cl_ai_app_536.clas.abap`
        notes = `IMPROVISED: the pattern's three views (App.view with sap.m.App id=rootControl, Main.view, Comparison.view) plus manifest routing are merged into ONE view: the App hosts the Main Page and the` &&
                 ` Comparison f:DynamicPage (id page-comparison added) directly as its pages; the router's navTo("page2") is mapped to the documented NavContainer frontend action follow_up_action(` &&
                 ` cs_event-control_by_id, rootControl//to/page-comparison ) with the default slide transition (CAPABILITIES nav row); hash-based routing / browser-back navigation is not wired; the view controllerName` &&
                 ` attributes are dropped. // IMPROVISED: named models flattened into the single default model: the Comparison view's settings> model becomes the bound PAGES_COUNT/IS_DESKTOP fields (pagesCount` &&
                 ` initialized to 1, the CarouselLayout.visiblePagesCount UI5 default, instead of the original's undefined-until-routeMatched), and its products> model (Products/Props) becomes` &&
                 ` T_COMP_PRODUCTS/T_COMP_PROPS; the shared mock products.json default model is flattened into a flat upper-cased row type (all 20 JSON columns kept; rows without DateOfSale carry an empty string where` &&
                 ` the original JSON omits the key - a harmless string property, no enum/default override). // SUBSET: only the 11 Category=Laptops rows of the mock /ProductCollection (ui5/mock/products.json) are` &&
                 ` loaded - the original loads all 123 rows and filters client-side; the original's onAfterRendering binding filter (Category EQ Laptops) is still applied 1:1 via follow_up_action( cs_event-binding_call` &&
                 ` ) on the items binding, so behaviour is identical for the rows shown. // IMPROVISED: the '.formatter.url' iconSrc formatter flattened to absolute https://sdk.openui5.org image URLs - source-verified` &&
                 ` against the now-archived app/model/formatter.js (it only prefixes '../../../../../../', i.e. resolves to the test-resources root), so the absolute URLs are the faithful equivalent. // NOTE: compare` &&
                 ` button: the controller's onSelection setText/setVisible is replaced by bound COMPARE_TEXT/COMPARE_VISIBLE model properties updated in the SELECTION handler (same count>1 logic, text only refreshed` &&
                 ` while shown, like the original); the ColumnListItem gains a selected="{SELECTED}" two-way binding - the sanctioned selection-read pattern (CAPABILITIES 'Controller-read list selection') replacing` &&
                 ` getSelectedContextPaths - which is an extra attribute vs the original template, and the initial visible="false"/absent text of the Button become bindings. // IMPROVISED: the ResizeHandler-driven` &&
                 ` pagesCount/isDesktop recalculation (_onResize/_getPagesCount) is replaced by a one-shot computation at COMPARE time from client->get( )-s_device-resize-width using the original's 600/1024 thresholds` &&
                 ` and the cap at the selected-items count; no live recalculation on window resize. // NOTE: Panel expand: the controller's onPanelExpanded (walking the sibling HBox controls and calling setVisible) is` &&
                 ` replaced by a bound VISIBLE flag per comparison value row, toggled in the PANEL_EXPANDED event via t_arg ${KEY} + ${$parameters>/expand}; the description HBox's literal visible="false" becomes the` &&
                 ` {VISIBLE} binding (initial false). // LIVE-TEST: the PAGE_CHANGED event arg ${$parameters>/activePages/0} (array-element path over the event-parameters model, standing in for the controller's` &&
                 ` activePages[0]) is unverified; if it resolves empty the window recompute degrades gracefully to page 0. Also confirm the init-roundtrip binding_call filter and the control_by_id 'to' navigation` &&
                 ` render as expected. // IMPROVISED: snapped/expanded Carousel re-sync stays dropped although Carousel.setActivePage is whitelisted upstream since 2026-07-20 (pr/control-methods-openby-setactivepage):` &&
                 ` the carousels' pages are aggregation-template CLONES whose ids (templateId-parentId-index, view-prefixed; nondeterministic under extended change detection) are not addressable from the backend -` &&
                 ` restoring the re-sync would need an index-based page-resolution mechanism, a new framework idea if more samples turn out to need it. // NOTE: the DynamicPageTitle stateChange handler (.onStateChange,` &&
                 ` add/removeSnappedContent of the snapped Carousel as a Carousel-animation workaround) is dropped together with its stateChange attribute - imperative aggregation surgery with no framework equivalent;` &&
                 ` the snapped/expanded content still switches natively with the DynamicPage header state. // NOTE: comparison Props are built from a fixed 19-key list in the mock JSON key order (the original iterates` &&
                 ` the FIRST selected product's own keys, skipping ProductPicUrl - so a first product without DateOfSale would drop that row, and missing values rendered '<strong>undefined</strong>' where the port` &&
                 ` renders an empty <strong></strong>); selected products are taken in model row order, not click order; the original's per-product information cache is unnecessary server-side. The controller's` &&
                 ` handleButtonPress (MessageBox) is dead code referenced by no view and not ported.` )
      ( module = `sap.m` control = `sap.m.CookieSettingsDialogPattern` name = `CookieSettingsDialogPattern` class = `z2ui5_cl_ai_app_537` path = `src/01/b05/z2ui5_cl_ai_app_537.clas.abap`
        notes = `IMPROVISED: the i18n> ResourceModel (i18n/i18n.properties) has no framework i18n mechanism here - all texts (dialog title, section titles/summaries/details, button labels) are inlined as the resolved` &&
                 ` English literals from the properties file; this covers every i18n>-bound text incl. the Panel headerText 'More Info'. // IMPROVISED: the cookieData> named JSON model is flattened into the default` &&
                 ` model: /showCookieDetails becomes the bound abap_bool show_cookie_details; every visible binding and expression binding keeps its original shape over the flattened path (named ABAP-fed JSON models` &&
                 ` are not expressible, CAPABILITIES.md). // IMPROVISED: custom:DivContainer (xmlns:custom="sap.ui.documentation", a demo-kit-internal plain-div wrapper control not shipped in any UI5 library) is` &&
                 ` rebuilt as a sap.m.VBox with the same class sapUiSmallMargin. // IMPROVISED: the controller's toggleStyleClass/addStyleClass/removeStyleClass('cookiesDetailedView') on the dialog is dropped: the` &&
                 ` class's CSS is not part of the sample's shipped files (manifest references css/style.css but does not list it under sample files, and it is not archived) and no whitelisted frontend action toggles` &&
                 ` style classes. // NOTE: the controller's lazy Fragment.load + cached-instance open()/close() lifecycle maps to client->popup_display (the fragment XML is rebuilt per open, forcing` &&
                 ` showCookieDetails=false like the original's openCookieSettingsDialog) and client->popup_destroy in the close handlers; the original's empty 'insert your ... logic here' placeholders remain as backend` &&
                 ` event branches (ACCEPT_ALL_COOKIES/REJECT_ALL_COOKIES/SAVE_COOKIES) that only close the dialog. // LIVE-TEST: the focus flow (afterOpen -> actionSetPreferences, showCookieDetails ->` &&
                 ` actionSavePreferences, hideCookieDetails -> actionSetPreferences) is wired via follow_up_action control_by_id with method 'focus' in the POPUP slot (focus is whitelisted with no args, source-verified` &&
                 ` in FrontendAction.js CONTROL_METHODS); needs a live check that the buttons are already rendered when the follow-up runs after Dialog.open()/popup_model_update - the original guards with` &&
                 ` attachAfterOpen and an onAfterRendering delegate, Element.focus() on an unrendered control is a no-op.` )
      ( module = `sap.m` control = `sap.m.CustomListItem`              name = `CustomListItem`              class = `z2ui5_cl_ai_app_538` path = `src/01/b05/z2ui5_cl_ai_app_538.clas.abap`
        notes = `IMPROVISED: the shared mock model /ProductCollection (ui5/mock/products.json) is flattened into the default model with only the three bound columns (ProductId, Name, ProductPicUrl); all unbound` &&
                 ` columns are dropped. The full 123-row set is kept verbatim. // NOTE: the ProductPicUrl values point at the OpenUI5 host (https://sdk.openui5.org/test-resources/...) per the asset-URL rule; they are` &&
                 ` rebuilt per row from ProductId in a LOOP in model_init - path and file name are identical to the mock values, only the host prefix is added. // NOTE: the controller-built Dialog of handlePress (Image` &&
                 ` + Close button, afterClose destroy) is rebuilt 1:1 as a core:FragmentDefinition -> Dialog shown via client->popup_display (the CAPABILITIES.md pattern, app 529). The Link press ships the row's` &&
                 ` ProductPicUrl via t_arg ${PRODUCT_PIC_URL} - the original reads evt.getSource().getTarget(), whose target property is bound to the same column. The Close button maps to client->_event_client(` &&
                 ` popup_close ); the original's afterClose destroy is handled by the framework's popup lifecycle and is not wired separately. // LIVE-TEST: confirm the image Dialog opens with the pressed product's` &&
                 ` picture, and that closing it via Escape (which bypasses the Close button's popup_close action; the next popup_display replaces the popup slot) leaves the app in a clean state.` )
      ( module = `sap.m` control = `sap.m.CustomTreeItem`              name = `CustomTreeItem`              class = `z2ui5_cl_ai_app_539` path = `src/01/b05/z2ui5_cl_ai_app_539.clas.abap`
        notes = `NOTE: the original binds the Tree's items to the whole JSON model root (items="{path: '/'}", the model IS the node array from Tree.json); abap2UI5 serves a single default model, so the array is` &&
                 ` flattened into it as the bound table T_TREE and the binding-info keeps its shape with the bound path substituted for '/' (nested tree binding is expressible per CAPABILITIES.md, proven by app 487).` &&
                 ` // NOTE: the flat ABAP row types serialize an empty NODES array on leaf rows where the original Tree.json simply omits the 'nodes' property (levels 1-4; the level-5 row type carries no NODES field at` &&
                 ` all); ClientTreeBinding treats an empty child array as a childless node, so the rendered tree matches. TEXT and REF are present on every original node - no absent-property/empty-string enum risk.` )
      ( module = `sap.m` control = `sap.m.DatePicker`                  name = `DatePickerHidden`            class = `z2ui5_cl_ai_app_540` path = `src/01/b05/z2ui5_cl_ai_app_540.clas.abap`
        notes = `LIVE-TEST: the 1:1 openBy wiring (press -> backend event -> follow_up_action control_by_id HiddenDP//openBy/<anchorId>) is whitelisted upstream since 2026-07-20` &&
                 ` (pr/control-methods-openby-setactivepage: new domRef arg kind resolves the anchor id to its DOM element, control fallback) - confirm in a running system that each of the three anchors (Button, icon` &&
                 ` Button, Link) opens the hidden DatePicker anchored to itself and the change toast shows the picked date. // POST-1.71: Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1` &&
                 ` port on both Buttons - the app needs a UI5 release >= 1.84 to render it. // POST-1.71: Link.ariaHasPopup (since UI5 1.86) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >=` &&
                 ` 1.86 to render it. // POST-1.71: DatePicker.hideInput (since UI5 1.97) is newer than 1.71 but kept for the 1:1 port - the sample's central property (the picker input stays hidden, opened only via the` &&
                 ` anchor controls); openBy is also since 1.97, so the app needs a UI5 release >= 1.97 to render this sample's behavior.`
        post171 = `Button.ariaHasPopup (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port on both Buttons - the app needs a UI5 release >= 1.84 to render it. // Link.ariaHasPopup (since UI5 1.86) is newer` &&
                 ` than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.86 to render it. // DatePicker.hideInput (since UI5 1.97) is newer than 1.71 but kept for the 1:1 port - the sample's central` &&
                 ` property (the picker input stays hidden, opened only via the anchor controls); openBy is also since 1.97, so the app needs a UI5 release >= 1.97 to render this sample's behavior.` )
      ( module = `sap.m` control = `sap.m.DateRangeSelection`          name = `DateRangeSelection`          class = `z2ui5_cl_ai_app_541` path = `src/01/b06/z2ui5_cl_ai_app_541.clas.abap`
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
                 ` used in the sample. // LIVE-TEST: confirm the CHANGE round-trip: $event.oSource.sId plus ${$parameters>/from|/to|/valid} reach get_event_arg and the valueState updates; note the from/to Date` &&
                 ` parameters are JSON-serialized on the wire, so the Text shows ISO timestamp strings where the original shows the JS Date toString format.`
        post171 = `core:require (UI5 >= 1.74) on the view root loads z2ui5/model/formatter for the DRS2 minDate/maxDate Formatter.DateCreateObject bindings - the app needs a UI5 release >= 1.74 to render it. //` &&
                 ` showCurrentDateButton (since UI5 1.95) on DRS3 is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.95 to render it.` )
      ( module = `sap.m` control = `sap.m.DateTimePicker`              name = `DateTimePicker`              class = `z2ui5_cl_ai_app_542` path = `src/01/b06/z2ui5_cl_ai_app_542.clas.abap`
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
                 ` and the sap.ui.model.odata.type.DateTimeWithTimezone binding type of DTP10/DTP11 (since UI5 1.99) is kept 1:1 - the app needs a UI5 release >= 1.99 overall. // LIVE-TEST: REMAINS after the 2026-07-20` &&
                 ` visual pass (rendering of the DateTimeWithTimezone composites, the empty-string DTP11 timezone-only display and the Islamic secondary calendar on DTP4 all confirmed on screen): the CHANGE round-trip` &&
                 ` - $event.oSource.sId / ${$parameters>/value} / valid reach get_event_arg, textResult and the per-picker valueState update.`
        post171 = `showCurrentDateButton (since UI5 1.95) on DTP2 is kept for the 1:1 port. // showCurrentTimeButton (since UI5 1.98) on DTP2 and DTP11 is kept for the 1:1 port. // showTimezone (since UI5 1.99) on DTP8` &&
                 ` and DTP11 is kept for the 1:1 port. // timezone (since UI5 1.99) on DTP8 is kept for the 1:1 port. // core:require of the z2ui5/model/formatter module on the view root needs UI5 >= 1.74, and the` &&
                 ` sap.ui.model.odata.type.DateTimeWithTimezone binding type of DTP10/DTP11 (since UI5 1.99) is kept 1:1 - the app needs a UI5 release >= 1.99 overall.` )
      ( module = `sap.m` control = `sap.m.Dialog`                      name = `DialogConfirm`               class = `z2ui5_cl_ai_app_543` path = `src/01/b06/z2ui5_cl_ai_app_543.clas.abap`
        notes = `NOTE: the original builds its four Dialogs imperatively in the controller (new Dialog({...}).open()); the port expresses each as a core:FragmentDefinition popup shown via client->popup_display on the` &&
                 ` button press event - the CAPABILITIES.md 1:1 path for controller-built Dialogs. The four Dialog fragments are therefore extra vs the archived V.view.xml, which holds only the four trigger Buttons;` &&
                 ` every fragment control is EXTRA vs the archived V.view.xml (only the four trigger Buttons exist there): Dialog, Text, TextArea, Label, Button and the l:VerticalLayout / l:HorizontalLayout wrappers` &&
                 ` inside the dialogs. // NOTE: the controller reads each note imperatively (Element.getElementById(...).getValue()); the port two-way binds the three TextArea values` &&
                 ` (reject_note/submit_note/confirm_note) and builds the 'Note is: ...' toasts from the synced ABAP fields in on_event - an extra value attribute per TextArea vs the original construction. // NOTE: the` &&
                 ` submission dialog's liveChange handler (enable the Submit button while the note is non-empty, enabled: false initially) is replaced round-trip-free by valueLiveUpdate=true on the TextArea plus an` &&
                 ` expression binding {= ${...}.length > 0 } on the begin button's enabled - same behavior, starts disabled with the empty note (CAPABILITIES.md: prefer a pure expression binding over an event` &&
                 ` round-trip). // NOTE: Cancel: the approve dialog (no inputs) closes client-side via _event_client popup_close; the three note dialogs cancel through a backend DIALOG_CANCEL event + popup_destroy so` &&
                 ` the two-way model sync keeps the typed note across a reopen, matching the original's reused cached dialog instances. // LIVE-TEST: verify the four popup dialogs open/close correctly, the toast texts` &&
                 ` (Submit pressed! / Note is: ...), the note retention across cancel+reopen, and the live enabling of the mandatory-note Submit button via valueLiveUpdate + expression binding.` )
      ( module = `sap.m` control = `sap.m.DisplayListItem`             name = `DisplayListItem`             class = `z2ui5_cl_ai_app_544` path = `src/01/b06/z2ui5_cl_ai_app_544.clas.abap`
        notes = `IMPROVISED: the shared mock model sap/ui/demo/mock/supplier.json is flattened into the default model: the row type keeps only the six bound columns (SupplierName, Street, HouseNumber, ZIPCode, City,` &&
                 ` Country) of the single /SupplierCollection record and drops the unbound columns (Url, Twitter, Tel, Sms, Mobile, Pager, Fax, Email, Rating, Prime, Disposable); the record itself is kept verbatim. //` &&
                 ` NOTE: the sample controller loads the shared mock sap/ui/demo/mock/supplier.json - snapshotted byte-identical into ui5/mock/supplier.json (2026-07-20, git sparse checkout of SAP/openui5 master); one` &&
                 ` SupplierCollection record, full row set, values verifiable offline. // NOTE: element binding binding="{/T_SUPPLIERS/0}" with relative DisplayListItem value bindings - the binding= context mechanism` &&
                 ` is already live-verified via app 460 (checked 2026-07-19); the /0 array-index path variant is a plain JSONModel path resolution, source-decidable, so no LIVE_TEST is carried.` )
      ( module = `sap.m` control = `sap.m.DraftIndicator`              name = `DraftIndicator`              class = `z2ui5_cl_ai_app_545` path = `src/01/b06/z2ui5_cl_ai_app_545.clas.abap`
        notes = `IMPROVISED: the controller's imperative DraftIndicator calls (showDraftSaving/showDraftSaved/clearDraftState on byId('draftIndi')) are not in the FrontendAction CONTROL_METHODS whitelist; per AGENTS` &&
                 ` 'prefer a bindable property over a frontend action' the port two-way binds the control's public state property (sap.m.DraftIndicatorState, since 1.32) and sets Saving/Saved/Clear in the three event` &&
                 ` handlers. Source-verified equivalent: a binding update calls the public mutator (ManagedObjectBindingSupport.updateProperty -> _sMutator), and DraftIndicator.setState queues exactly what the three` &&
                 ` methods queue (setState('Saving') queues Saving+Clear like showDraftSaving, sap/m/DraftIndicator.js). Adds the state attribute on the DraftIndicator vs the original view.xml. // NOTE: pressing the` &&
                 ` same button twice in direct succession does not re-run the indicator - the model value is unchanged, so no binding change fires and setState is not called again (the original re-queues on every` &&
                 ` method call); pressing a different button in between restores the behaviour.` )
      ( module = `sap.m` control = `sap.m.FacetFilter`                 name = `FacetFilterLight`            class = `z2ui5_cl_ai_app_401` path = `src/01/b04/z2ui5_cl_ai_app_401.clas.abap`
        notes = `NOTE: the bound lists="{/ProductCollectionStats/Filters}" collection is represented as two static FacetFilterLists (Category, SupplierName) - the original's stats model yields exactly these two lists,` &&
                 ` so this is a faithful equivalent; the facet values inside each list stay bound to a FacetFilterItem template. A doubly-nested variant (bind the FacetFilter lists aggregation to a nested table,` &&
                 ` FacetFilterList template with a relative items binding over each filter's values) is source-plausible now that nested binding is expressible, but no port proves that aggregation-of-aggregation` &&
                 ` template shape yet - LIVE_TEST before adopting it. // NOTE: selection transport - every FacetFilterItem binds selected two-way; on listClose/reset the backend reads/clears the flags and re-filters.` &&
                 ` This is the documented 1:1 path (CAPABILITIES.md marks controller-read FacetFilter/List multi-select as expressible with app 401 as its evidence port), not a workaround; the model is applied before` &&
                 ` on_event runs. // LIVE-TEST: confirm in a running system that clearing the bound selected flags on Reset also unchecks the facet popover checkboxes (FacetFilterList caches its selection client-side).` &&
                 ` // IMPROVISED: the original controller appends the sap.m.sample.Table component's table with its first cell swapped for an ObjectIdentifier {Name}/{Category}; that table is rebuilt inline. The price` &&
                 ` column keeps the original sap.ui.model.type.Currency composite binding 1:1 (raw binding-info string over a numeric PRICE field). // NOTE: the weight column keeps the original parts+formatter binding` &&
                 ` 1:1: the framework ships the sample's weightState in its curated formatter module (standard app layout model/formatter.js, a served script, CSP-clean - see pr/formatter-registry, implemented` &&
                 ` 2026-07-18 after an eval-based register_formatter was rejected for security). The view requires it like the original controller requires './Formatter': core:require="{Formatter:` &&
                 ` 'z2ui5/model/formatter'}" on the view root, state binds { parts: [WEIGHT_MEASURE, WEIGHT_UNIT], formatter: 'Formatter.weightState' } - the alias reference mirrors the original's` &&
                 ` '.formatter.weightState'. The earlier precomputed WEIGHT_STATE column stays gone. // POST-1.71: core:require on the view root (since UI5 1.74) is newer than 1.71 but used for the formatter wiring -` &&
                 ` the app needs a UI5 release >= 1.74; on older releases reference the published global instead (formatter: 'z2ui5.Formatter.weightState'). // NOTE: the appended table's header toolbar is restored` &&
                 ` except for the sticky controls: the popin-layout ComboBox keeps its core:Item entries and binds selectedKey two-way in place of the original's change handler (the controller switch is a pure` &&
                 ` key-to-property pass-through; the Table's added popinLayout expression binding maps an empty selection to the Block default), and the Hide/Show ToggleButton binds pressed two-way in place of its` &&
                 ` press handler, with the restored infoToolbar's OverflowToolbar carrying a visible expression binding over the same flag - both per the prefer-a-bindable-property rule, no round-trip. // IMPROVISED:` &&
                 ` the sticky options Label and the three sticky CheckBox controls (with their select handlers) are dropped - Table.sticky is an array-valued property the controller mutates via setSticky, and neither` &&
                 ` an array property binding nor a setSticky whitelist entry is a proven path; a bound-array LIVE_TEST port could disprove this later. // 1.71: the p:ColumnAIAction column plugin (sap.m.plugins, far` &&
                 ` newer than UI5 1.71) is dropped with its dependents aggregation and press toast - the plugin class does not exist on a 1.71 runtime, so keeping it would crash view creation there. // NOTE: the` &&
                 ` original's nested items-binding filter (ORs inside each facet group, AND across the groups, model untouched) is expressed 1:1 as a declarative compound filter: apply_filter builds the groups JSON` &&
                 ` from the two-way bound selected flags and schedules follow_up_action cs_event-binding_call filter on idProductsTable/items (compound groups implemented upstream 2026-07-20,` &&
                 ` pr/binding-call-compound-filters); the earlier ABAP-side model rebuild and the t_products_all mirror are gone. // LIVE-TEST: confirm the compound facet filter in a running system: selecting` &&
                 ` categories/suppliers filters the table (OR inside a facet, AND across facets), clearing all selections shows every row, and rows deselected by the filter keep their client-side state (the` &&
                 ` model-untouched advantage). // SUBSET: data is a 10-row subset of the mock /ProductCollection (ui5/mock/products.json), facet counters recomputed for the subset. // LIVE-TEST: confirm in a running` &&
                 ` system that the popin layout switches via the two-way ComboBox selectedKey and that the ToggleButton hides/shows the infoToolbar via the visible expression binding (restored 2026-07-19).`
        post171 = `core:require on the view root (since UI5 1.74) is newer than 1.71 but used for the formatter wiring - the app needs a UI5 release >= 1.74; on older releases reference the published global instead` &&
                 ` (formatter: 'z2ui5.Formatter.weightState').` )
      ( module = `sap.m` control = `sap.m.FeedContent`                 name = `FeedContent`                 class = `z2ui5_cl_ai_app_546` path = `src/01/b06/z2ui5_cl_ai_app_546.clas.abap` )
      ( module = `sap.m` control = `sap.m.FeedInput`                   name = `Feed`                        class = `z2ui5_cl_ai_app_547` path = `src/01/b06/z2ui5_cl_ai_app_547.clas.abap`
        notes = `IMPROVISED: the controller's client-side DateFormat.getDateTimeInstance({ style: 'medium' }).format(new Date()) for the new entry's Date is rebuilt server-side in ABAP from sy-datum/sy-uzeit as an` &&
                 ` English medium-style timestamp (e.g. 'Jul 20, 2026, 1:23:45 PM') - the locale-dependent client formatter is not available in the backend round-trip; the value is a plain model string exactly like in` &&
                 ` the original; note the source differs too: sy-datum/sy-uzeit is the SERVER date/time and timezone, while the original renders the browser-local new Date() - around midnight or across timezones the` &&
                 ` displayed timestamp of a new entry can differ from a client-side clock. // LIVE-TEST: the senderPress/iconPress toasts read the pressed FeedListItem's sender via the client-side resolved event arg` &&
                 ` ${$source>/sender} (the getSource().getSender() equivalent, same pattern as app 530's ${$source>/text}) - confirm the sender name arrives in the toast in a running system.` )
      ( module = `sap.m` control = `sap.m.FeedListItem`                name = `FeedListItem`                class = `z2ui5_cl_ai_app_548` path = `src/01/b06/z2ui5_cl_ai_app_548.clas.abap`
        notes = `LIVE-TEST: confirm the ACTION_PRESSED event args resolve as expected: ``${KEY}`` against the FeedListItemAction's Actions-row binding context, and the deleted entry's index via` &&
                 ` ``${$parameters>/item/oParent}.indexOfItem(${$parameters>/item})`` (the DnD-sample-proven method-call $-arg form over the press event's ``item`` parameter) - delete must remove the right feed entry;` &&
                 ` also confirm ``${AUTHOR}`` reaches the PRESSED toast from both senderPress and iconPress. // NOTE: the original's removeItem derives the entry index from the item's binding-context path` &&
                 ` (getBindingContext().getPath().split('/').pop()); the port transports the List's indexOfItem(item) instead - the aggregation index equals the model index for this bound list, so the spliced row is` &&
                 ` the same. // NOTE: feed.json entries 2 and 4 have no Actions property; the flat ABAP row type serializes ACTIONS as an empty array ([] instead of undefined) - the actions aggregation renders no` &&
                 ` actions either way, and an empty array is not an empty-string/enum hazard. // NOTE: the relative AuthorPicUrl asset paths (test-resources/sap/m/images/*.jpg) are rewritten to absolute` &&
                 ` https://sdk.openui5.org/test-resources/... per the project rule for runtime asset URLs.` )
      ( module = `sap.m` control = `sap.m.FlexBox`                     name = `FlexBoxNested`               class = `z2ui5_cl_ai_app_404` path = `src/01/b04/z2ui5_cl_ai_app_404.clas.abap`
        checked = `CHECKED (2026-07-19): verified in a running system - human visual pass 2026-07-19 over all apps: the six flex items and the h2 headings render with their injected-CSS background colours like the` &&
                 ` original.`
        notes = `NOTE: the original colours .item1..item6 and the h2 headings via a separate style.css; here it is injected as a core:HTML content attribute (a style tag, minified - see CAPABILITIES.md; the EXTRA` &&
                 ` core:HTML control vs the original view). Confirmed rendering via the human visual pass 2026-07-19.` )
      ( module = `sap.m` control = `sap.m.GenericTag`                  name = `GenericTag`                  class = `z2ui5_cl_ai_app_549` path = `src/01/b06/z2ui5_cl_ai_app_549.clas.abap`
        notes = `POST-1.71: ariaLabelledBy (since UI5 1.97) on the labeled GenericTag is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.97 to render it. // NOTE: the sample's` &&
                 ` Page.controller.js defines a press handler (MessageToast 'The GenericTag is pressed.') that is not referenced anywhere in Page.view.xml - no GenericTag carries a press attribute - so the port wires` &&
                 ` no event; the rendered view is a faithful 1:1 rebuild.`
        post171 = `ariaLabelledBy (since UI5 1.97) on the labeled GenericTag is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.97 to render it.` )
      ( module = `sap.m` control = `sap.m.GenericTile`                 name = `GenericTileAsKPITile`        class = `z2ui5_cl_ai_app_431` path = `src/01/b01/z2ui5_cl_ai_app_431.clas.abap`
        checked = `CHECKED (2026-07-19): verified in a running system - human visual pass 2026-07-19 over all apps: the KPI tiles float left via the injected tileLayout CSS and render like the original.`
        notes = `POST-1.71: frameType values OneByHalf / TwoByHalf (since UI5 1.83) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.83 to render them; OneByOne / TwoByOne (1.71) were` &&
                 ` never affected. // POST-1.71: systemInfo and appShortcut (since UI5 1.92) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.92 to render them. // POST-1.71: url on the` &&
                 ` link tiles (since UI5 1.76) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.76 to render it. // IMPROVISED: the relative test-resources image and backgroundImage paths` &&
                 ` are resolved to absolute sdk.openui5.org URLs so the tile images load standalone. // NOTE: the custom CSS class tileLayout (float: left) is kept and its style.css injected via a core:HTML content` &&
                 ` attribute (see CAPABILITIES.md; the EXTRA core:HTML control vs the original view). Confirmed rendering via the human visual pass 2026-07-19.`
        post171 = `frameType values OneByHalf / TwoByHalf (since UI5 1.83) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.83 to render them; OneByOne / TwoByOne (1.71) were never` &&
                 ` affected. // systemInfo and appShortcut (since UI5 1.92) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.92 to render them. // url on the link tiles (since UI5 1.76)` &&
                 ` is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.76 to render it.` )
      ( module = `sap.m` control = `sap.m.HeaderContainer`             name = `HeaderContainer`             class = `z2ui5_cl_ai_app_550` path = `src/01/b06/z2ui5_cl_ai_app_550.clas.abap`
        notes = `NOTE: the Select's literal selectedKey="1" is replaced by a two-way binding {SELECTED_KEY} (seeded with '1') so the SCROLL_CHANGED handler can read the chosen key on the backend - the` &&
                 ` CAPABILITIES-approved controller-read-selection pattern (bind selectedKey two-way; the incoming model is applied before on_event runs). The original controller reads` &&
                 ` oEvent.getParameter('selectedItem').getKey(), which has no public $parameters path (selectedItem is a control; reading private control internals is banned). // NOTE: the controller's` &&
                 ` setScrollStepByItem(0 | Number(key)) calls on both containers expressed as a shared two-way scrollStepByItem binding (typed i for a real JSON number; the method is not in the CONTROL_METHODS` &&
                 ` whitelist and the prefer-a-bindable-property rule applies). Seeded 1 - the UI5 property default (HeaderContainer.js defaultValue: 1; the property carries no @since, present since the control) - so` &&
                 ` the initial arrow scroll is one item, exactly the original's untouched state; selecting px sets 0 (px stepping via scrollStep), like the controller. // LIVE-TEST: confirm the scroll-step switching` &&
                 ` end to end: changing the Select round-trips SCROLL_CHANGED, updates SCROLL_STEP_BY_ITEM in the model, and both HeaderContainers then scroll by 1/2/3 items resp. 200px like the original's` &&
                 ` setScrollStepByItem calls.` )
      ( module = `sap.m` control = `sap.m.IconTabBar`                  name = `IconTabBarStretchContent`    class = `z2ui5_cl_ai_app_433` path = `src/01/b04/z2ui5_cl_ai_app_433.clas.abap`
        notes = `LIVE-TEST: the original binds expanded="{device>/isNoPhone}" (a demo-kit helper model); restored 2026-07-16 as the expression {= !${device>/system/phone} } over the framework's device> model` &&
                 ` (source-verified available in main views) - confirm the tab bar collapses on phones. // SUBSET: the bound /ProductCollection shows a 8-row subset of the 123-row mock (ui5/mock/products.json) - a full` &&
                 ` unroll adds no demo value.` )
      ( module = `sap.m` control = `sap.m.Image`                       name = `ImageModeBackground`         class = `z2ui5_cl_ai_app_434` path = `src/01/b01/z2ui5_cl_ai_app_434.clas.abap`
        notes = `IMPROVISED: the original binds src/mode to a JSONModel (img>/products, /imageMode); these fixed sample values are inlined here as literals (mode Background, the HT-7777 / HT-6100 demo images).` &&
                 ` height/width are restored over the device> model, see below. // LIVE-TEST: image height/width are device dependent in the original (imageHeight/imageWidth = 5em on a phone, 10em otherwise); restored` &&
                 ` as the expression {= ${device>/system/phone} ? '5em' : '10em' } over the framework's device> model (image 4 keeps its fixed 6em width, exactly as the original) - confirm the images shrink on a phone.` &&
                 ` // NOTE: the custom CSS class imageContainer (light blue background) of the box4 HBox is kept and the sample's styles.css injected via a core:HTML content attribute (CAPABILITIES.md CSS row, as apps` &&
                 ` 431/404; the EXTRA core:HTML control vs the original view). Confirmed rendering via the human visual pass 2026-07-19.` )
      ( module = `sap.m` control = `sap.m.Input`                       name = `InputValueState`             class = `z2ui5_cl_ai_app_439` path = `src/01/b02/z2ui5_cl_ai_app_439.clas.abap`
        notes = `POST-1.71: showClearIcon (since UI5 1.94) on three inputs is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.94 to render it. // POST-1.71: the two formattedValueStateText` &&
                 ` aggregations (a FormattedText carrying Links, since UI5 1.78) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.78 to render them. // NOTE: the Links' press` &&
                 ` (.onFormattedTextLinkPress) round-trips as event LINK_PRESS and shows the controller's toast text, docked at CenterCenter 1:1 via message_toast_display( my = 'center center' at = 'center center' )` &&
                 ` (the client method exposes the MessageToast options object - source-verified in Messages.js). The original's preventDefault is not needed: the Links carry no href, so there is no default navigation` &&
                 ` to suppress.`
        post171 = `showClearIcon (since UI5 1.94) on three inputs is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.94 to render it. // the two formattedValueStateText aggregations (a` &&
                 ` FormattedText carrying Links, since UI5 1.78) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.78 to render them.` )
      ( module = `sap.m` control = `sap.m.Link`                        name = `LinkEmphasized`              class = `z2ui5_cl_ai_app_440` path = `src/01/b01/z2ui5_cl_ai_app_440.clas.abap`
        checked = `CHECKED (2026-07-19): verified in a running system - human visual pass 2026-07-19 over all apps: the Currency composite binding renders the formatted price per currency (raw binding-info string over` &&
                 ` PRICE TYPE p).`
        notes = `SUBSET: the bound /ProductCollection shows a 6-row subset of the 123-row mock (ui5/mock/products.json); HT-1002 is not part of the subset.` )
      ( module = `sap.m` control = `sap.m.List`                        name = `ListCounter`                 class = `z2ui5_cl_ai_app_441` path = `src/01/b04/z2ui5_cl_ai_app_441.clas.abap`
        notes = `POST-1.71: headerLevel="H2" on the List (since UI5 1.117) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.117 to render it. // SUBSET: the bound /ProductCollection` &&
                 ` shows a 11-row subset of the 123-row mock (ui5/mock/products.json) - a full unroll adds no demo value.`
        post171 = `headerLevel="H2" on the List (since UI5 1.117) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.117 to render it.` )
      ( module = `sap.m` control = `sap.m.List`                        name = `ListNoData`                  class = `z2ui5_cl_ai_app_445` path = `src/01/b04/z2ui5_cl_ai_app_445.clas.abap` )
      ( module = `sap.m` control = `sap.m.MessageBox`                  name = `MessageBoxInitialFocus`      class = `z2ui5_cl_ai_app_447` path = `src/01/b03/z2ui5_cl_ai_app_447.clas.abap`
        notes = `NOTE: the sample opens a sap.m.MessageBox from its controller; there is no such control in the view. It is driven by two buttons wired to events that call client->message_box_display - the documented` &&
                 ` 1:1 path (CAPABILITIES.md marks sap.m.MessageBox as expressible with app 447 as its evidence port), not a workaround. // POST-1.71: ariaHasPopup="Dialog" on both buttons (since UI5 1.84) is newer` &&
                 ` than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it. // POST-1.71: the MessageBox emphasizedAction option (since UI5 1.75) is newer than 1.71 but kept for the 1:1` &&
                 ` port - the app needs a UI5 release >= 1.75 to render it. // POST-1.71: the MessageBox dependentOn option (since UI5 1.124) is restored via message_box_display's dependenton parameter, pointing at the` &&
                 ` view layout (id messageBoxHost); the app needs a UI5 release >= 1.124 to render it.`
        post171 = `ariaHasPopup="Dialog" on both buttons (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it. // the MessageBox emphasizedAction option (since` &&
                 ` UI5 1.75) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.75 to render it. // the MessageBox dependentOn option (since UI5 1.124) is restored via message_box_display's` &&
                 ` dependenton parameter, pointing at the view layout (id messageBoxHost); the app needs a UI5 release >= 1.124 to render it.` )
      ( module = `sap.m` control = `sap.m.MessageToast`                name = `MessageToast`                class = `z2ui5_cl_ai_app_448` path = `src/01/b03/z2ui5_cl_ai_app_448.clas.abap` )
      ( module = `sap.m` control = `sap.m.MessageView`                 name = `MessageViewMessageManager`   class = `z2ui5_cl_ai_app_449` path = `src/01/b03/z2ui5_cl_ai_app_449.clas.abap`
        notes = `NOTE: the original registers its four messages on the sap.ui.core.message.MessageManager and the MessageView binds them via the message> model. abap2UI5 DOES carry the message> model on every view` &&
                 ` slot since pr/message-model (2026-07-18, auto-collecting control validation messages), but there is no ABAP API to push an arbitrary static message set into it - so for this render-only sample the` &&
                 ` messages are bound as a plain ABAP table on MessageView items with a MessageItem template (client->_bind( t_messages )), the path CAPABILITIES.md explicitly endorses for static message sets. Same` &&
                 ` rendering as the original. Proven by the curated sample z2ui5_cl_demo_app_038 (MessageView + MessageItem + MessagePopover over a bound table).` )
      ( module = `sap.m` control = `sap.m.MultiComboBox`               name = `MultiComboBoxGrouping`       class = `z2ui5_cl_ai_app_452` path = `src/01/b02/z2ui5_cl_ai_app_452.clas.abap`
        notes = `NOTE: the custom groupHeaderFactory '.getGroupHeader' (controller code) is replaced by UI5's default group headers - the sample's factory builds a SeparatorItem with the group key, which is exactly` &&
                 ` what the default renders anyway (CAPABILITIES.md group-sorter row, source-verified on both sides), so this is a faithful 1:1, not a workaround. The items are a bound template with the original's` &&
                 ` sorter (path SUPPLIER_NAME, group: true) as a raw binding-info string. // SUBSET: 16-row subset of the 123-row mock (ui5/mock/products.json). // LIVE-TEST: confirm the group SeparatorItem headers` &&
                 ` render per supplier in the MultiComboBox picker (bound template + group sorter, converted 2026-07-16; string pass-through source-verified).` )
      ( module = `sap.m` control = `sap.m.MultiInput`                  name = `MultiInput`                  class = `z2ui5_cl_ai_app_454` path = `src/01/b02/z2ui5_cl_ai_app_454.clas.abap`
        notes = `NOTE: the controller's onInit pre-sets the tokens on both MultiInputs (Token 1..6 and one long token); they are declared statically in the view's tokens aggregation instead - same rendering` &&
                 ` (CAPABILITIES.md marks controller-filled aggregations as expressible, the tokens aggregation is public since UI5 1.16), so this is a faithful 1:1, not a workaround. // NOTE: the controller's onInit` &&
                 ` addValidator on multiInput1 and multiInput2 (typing free text + Enter -> new Token({key: text, text})) is wired via the bundled invisible companion control z2ui5.cc.MultiInputExt` &&
                 ` (xmlns:z2ui5="z2ui5.cc"): one MultiInputExt per input, referencing it by MultiInputId - the control installs exactly the original's validator (source-verified in app/webapp/cc/MultiInputExt.js). The` &&
                 ` two MultiInputExt elements are extra vs the original view.xml (there the validator lives in the controller); first cc-control usage in these ports (converted 2026-07-18). // LIVE-TEST: confirm free` &&
                 ` text + Enter creates a token on both multiInput1 and multiInput2 via the z2ui5.cc.MultiInputExt companions (first cc-control usage in these ports). // SUBSET: the suggestion data is a 16-row subset` &&
                 ` of the mock /ProductCollection (ui5/mock/products.json). // NOTE: The original's stray placeholder attributes on the two Labels (not a Label property) are dropped. // POST-1.71: showClearIcon (since` &&
                 ` UI5 1.94) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.94 to render it.`
        post171 = `showClearIcon (since UI5 1.94) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.94 to render it.` )
      ( module = `sap.m` control = `sap.m.ObjectHeader`                name = `ObjectHeader`                class = `z2ui5_cl_ai_app_460` path = `src/01/b01/z2ui5_cl_ai_app_460.clas.abap`
        checked = `CHECKED (2026-07-19): verified in a running system - human visual pass 2026-07-19 over all apps: the element binding {/S_PRODUCT} resolves all relative field bindings incl. the Currency number - the` &&
                 ` ObjectHeader renders fully populated.`
        notes = `NOTE: the ObjectHeader keeps the original element binding and relative field bindings 1:1 (title, numberUnit, the ObjectAttribute composite texts and the sap.ui.model.type.Currency number binding);` &&
                 ` only the binding context path changes - a one-record structure /S_PRODUCT in the default model instead of {/ProductCollection/0}, since the port does not carry the whole collection. // SUBSET: the` &&
                 ` model holds exactly the bound record /ProductCollection/0 (Notebook Basic 15) of ui5/mock/products.json, verbatim.` )
      ( module = `sap.m` control = `sap.m.ObjectStatus`                name = `ObjectStatus`                class = `z2ui5_cl_ai_app_529` path = `src/01/b01/z2ui5_cl_ai_app_529.clas.abap`
        notes = `POST-1.71: the ObjectStatus state values Indication06-Indication08 (since UI5 1.75) and Indication09-Indication20 (since UI5 1.120) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5` &&
                 ` release >= 1.120 to render them all (>= 1.75 for Indication06-Indication08). // LIVE-TEST: the active status press opens the controller-built Dialog 1:1 (core:FragmentDefinition + popup_display, per` &&
                 ` CAPABILITIES.md): a Dialog with a VBox, a Text and an OK Button - these popup controls are extra to the view XML. Confirm the popup opens and closes in a running system.`
        post171 = `the ObjectStatus state values Indication06-Indication08 (since UI5 1.75) and Indication09-Indication20 (since UI5 1.120) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >=` &&
                 ` 1.120 to render them all (>= 1.75 for Indication06-Indication08).` )
      ( module = `sap.m` control = `sap.m.Panel`                       name = `PanelExpanded`               class = `z2ui5_cl_ai_app_471` path = `src/01/b04/z2ui5_cl_ai_app_471.clas.abap`
        notes = `NOTE: the original controller toggles the third panel imperatively (onOverflowToolbarPress -> oPanel.setExpanded(!oPanel.getExpanded())). Reproduced 1:1 since the whitelist extension (2026-07-18, see` &&
                 ` pr/control-call-whitelist): the TOOLBAR_PRESSED handler inverts a server-side mirror of the state and calls the whitelisted setExpanded on the panel via client->follow_up_action(` &&
                 ` cs_event-control_by_id ) - the view no longer carries the improvised two-way ``expanded`` binding, matching the original view.xml exactly. // LIVE-TEST: confirm the third panel expands/collapses on` &&
                 ` each toolbar press (the follow-up setExpanded runs after the round-trip) - together with app 469 the first ports using the extended CONTROL_BY_ID whitelist.` )
      ( module = `sap.m` control = `sap.m.PDFViewer`                   name = `PDFViewerPopup`              class = `z2ui5_cl_ai_app_469` path = `src/01/b03/z2ui5_cl_ai_app_469.clas.abap`
        notes = `NOTE: the original onInit creates a popup-mode sap.m.PDFViewer and adds it as a view dependent; it is declared 1:1 in the view's mvc:dependents aggregation (an extra PDFViewer element vs the original` &&
                 ` view.xml, which never carries it - there it lives in the controller). onPress' setSource/setTitle/open() becomes a bound source updated per click, the constant title declared in the view, and the` &&
                 ` whitelisted open via client->follow_up_action( cs_event-control_by_id ) after render - popup mode 1:1, the earlier Dialog embedding workaround is gone (whitelist extended upstream 2026-07-18, see` &&
                 ` pr/control-call-whitelist). // IMPROVISED: the per-image JSONModels of onInit (a Source/Preview URL pair per Image) have no server-side equivalent; the Image src (original {/Preview}) is resolved to` &&
                 ` static absolute sdk.openui5.org URLs and the Source travels through the one bound pdf_source field - same family as pr/named-json-models. // POST-1.71: the PDFViewer property isTrustedSource (since` &&
                 ` UI5 1.121, backported to maintenance patches down to 1.71.63; the original controller passes isTrustedSource: true) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.121` &&
                 ` (or a patched maintenance release) to render it. // LIVE-TEST: confirm the popup-mode PDFViewer opens after the SHOW_PDF round-trip (view_model_update applies the new source before the follow-up open` &&
                 ` runs) and shows the clicked PDF in a running system - first port using the extended CONTROL_BY_ID whitelist.`
        post171 = `the PDFViewer property isTrustedSource (since UI5 1.121, backported to maintenance patches down to 1.71.63; the original controller passes isTrustedSource: true) is newer than 1.71 but kept for the` &&
                 ` 1:1 port - the app needs a UI5 release >= 1.121 (or a patched maintenance release) to render it.` )
      ( module = `sap.m` control = `sap.m.RangeSlider`                 name = `RangeSlider`                 class = `z2ui5_cl_ai_app_472` path = `src/01/b02/z2ui5_cl_ai_app_472.clas.abap`
        notes = `NOTE: the sample binds the composite RangeSlider "range" property (an array [low, high] - range="{/RS1}" / range="0,100"). abap2UI5 binds scalar ABAP fields, so each range is expressed as the` &&
                 ` equivalent value / value2 properties the control keeps in sync - identical rendering.` )
      ( module = `sap.m` control = `sap.m.ScrollContainer`             name = `ScrollContainer`             class = `z2ui5_cl_ai_app_473` path = `src/01/b04/z2ui5_cl_ai_app_473.clas.abap`
        notes = `IMPROVISED: the Image src binds {img>/products/pic1} in the original, a JSON image model not available server-side; a static demo image URL is used instead. // LIVE-TEST: the original narrows the` &&
                 ` width to 50em on phones via sap/ui/Device in the controller; restored 2026-07-16 as the expression {= ${device>/system/phone} ? '50em' : '100em' } over the framework's device> model (source-verified` &&
                 ` available in main views) - confirm the width switches on a phone.` )
      ( module = `sap.m` control = `sap.m.SegmentedButton`             name = `SegmentedButton`             class = `z2ui5_cl_ai_app_474` path = `src/01/b03/z2ui5_cl_ai_app_474.clas.abap`
        notes = `NOTE: the original reads the selected item via oEvent.getParameter("item").getText() / getSelectedItem(). Here the items get keys (one/two/three - an addition, SB1 has none in the sample) and` &&
                 ` selectedKey is two-way bound, so the selection arrives with the event and no private event path is needed - the documented 1:1 path for controller-read selection (CAPABILITIES.md), not a workaround.` &&
                 ` // LIVE-TEST: confirm the two-way bound selectedKey is updated before on_event runs, so the toast shows the newly selected item.` )
      ( module = `sap.m` control = `sap.m.Select`                      name = `Select`                      class = `z2ui5_cl_ai_app_527` path = `src/01/b02/z2ui5_cl_ai_app_527.clas.abap` )
      ( module = `sap.m` control = `sap.m.StepInput`                   name = `StepInput`                   class = `z2ui5_cl_ai_app_481` path = `src/01/b02/z2ui5_cl_ai_app_481.clas.abap`
        notes = `IMPROVISED: the sample binds a List to the JSON model /modelData and renders one templated CustomListItem per row. The rows are unrolled into static list items here because every row sets a different` &&
                 ` subset of the StepInput properties - an empty ABAP model field would bind as "" instead of leaving the property at its default, so a bound template would not render 1:1. Template properties no row` &&
                 ` ever sets (valueState) are dropped with it.` )
      ( module = `sap.m` control = `sap.m.Switch`                      name = `Switch`                      class = `z2ui5_cl_ai_app_528` path = `src/01/b02/z2ui5_cl_ai_app_528.clas.abap` )
      ( module = `sap.m` control = `sap.m.Text`                        name = `Text`                        class = `z2ui5_cl_ai_app_408` path = `src/01/b01/z2ui5_cl_ai_app_408.clas.abap` )
      ( module = `sap.m` control = `sap.m.TextArea`                    name = `TextArea`                    class = `z2ui5_cl_ai_app_409` path = `src/01/b01/z2ui5_cl_ai_app_409.clas.abap` )
      ( module = `sap.m` control = `sap.m.Toolbar`                     name = `ToolbarShrinkable`           class = `z2ui5_cl_ai_app_486` path = `src/01/b03/z2ui5_cl_ai_app_486.clas.abap`
        notes = `NOTE: the sample's controller onSliderLiveChange resizes the toolbars in JS; there is no width in the source XML (the port adds the width attribute, the original wires liveChange instead). Rebuilt as` &&
                 ` a client-side expression binding {= slider + '%' } on each Toolbar width - no event round-trip, resizes instantly like the original; the documented preferred path (CAPABILITIES.md), not a workaround.` &&
                 ` // LIVE-TEST: confirm the expression-bound widths follow the slider in a running system.` )
      ( module = `sap.m` control = `sap.m.Tree`                        name = `Tree`                        class = `z2ui5_cl_ai_app_487` path = `src/01/b04/z2ui5_cl_ai_app_487.clas.abap`
        checked = `CHECKED (2026-07-19): verified in a running system - human visual pass 2026-07-19 over all apps: the nested-table hierarchy renders as an expandable Tree like the original.` ) ).

  ENDMETHOD.

ENDCLASS.
