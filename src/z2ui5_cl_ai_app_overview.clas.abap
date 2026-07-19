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
      ( module = `sap.m` control = `sap.m.Breadcrumbs`     name = `Breadcrumbs`               class = `z2ui5_cl_ai_app_530` path = `src/01/b01/z2ui5_cl_ai_app_530.clas.abap`
        checked = `CHECKED (2026-07-15): manually verified in a running system - the ${$source>/text} event arg delivers the clicked link's text as expected, everything works like the original.`
        notes = `LIVE-TEST: the SEP_CHANGE round-trip (which read a private UI5-internal event path) was removed 2026-07-16 - selectedKey and separatorStyle share one two-way bound path, so the separator switches` &&
                 ` client-side. Confirm the instant separator change in a running system.` )
      ( module = `sap.m` control = `sap.m.Button`          name = `Button`                    class = `z2ui5_cl_ai_app_526` path = `src/01/b03/z2ui5_cl_ai_app_526.clas.abap`
        checked = `CHECKED (2026-07-15): manually verified in a running system - each press toasts the pressed button's client-side control id, read via the event arg $event.oSource.sId, exactly like the original.` )
      ( module = `sap.m` control = `sap.m.Carousel`        name = `CarouselWithControls`      class = `z2ui5_cl_ai_app_420` path = `src/01/b04/z2ui5_cl_ai_app_420.clas.abap`
        checked = `CHECKED (2026-07-15): manually verified in a running system - renders and scrolls like the original (see the note below on the flattened image model).`
        notes = `IMPROVISED: the three carousel images bind to a separate named model in the original (img>/products/pic1..3 from sap/ui/demo/mock/img.json); resolved here to static image URLs, as abap2UI5 serves a` &&
                 ` single default model. // SUBSET: the bound /ProductCollection shows a 10-row subset of the 123-row mock (ui5/mock/products.json) - a full unroll adds no demo value. // POST-1.71: ariaLabelledBy on` &&
                 ` the Carousel (since UI5 1.125) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.125 to render it.`
        post171 = `ariaLabelledBy on the Carousel (since UI5 1.125) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.125 to render it.` )
      ( module = `sap.m` control = `sap.m.CheckBox`        name = `CheckBoxTriState`          class = `z2ui5_cl_ai_app_421` path = `src/01/b02/z2ui5_cl_ai_app_421.clas.abap`
        checked = `CHECKED (2026-07-15): manually verified in a running system - the select-all parent checkbox and its tri-state expression bindings behave like the original.` )
      ( module = `sap.m` control = `sap.m.ColorPalette`    name = `ColorPalette`              class = `z2ui5_cl_ai_app_422` path = `src/01/b02/z2ui5_cl_ai_app_422.clas.abap` )
      ( module = `sap.m` control = `sap.m.ComboBox`        name = `ComboBox`                  class = `z2ui5_cl_ai_app_423` path = `src/01/b02/z2ui5_cl_ai_app_423.clas.abap` )
      ( module = `sap.m` control = `sap.m.FacetFilter`     name = `FacetFilterLight`          class = `z2ui5_cl_ai_app_401` path = `src/01/b04/z2ui5_cl_ai_app_401.clas.abap`
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
                 ` the app needs a UI5 release >= 1.74; on older releases reference the published global instead (formatter: 'z2ui5.Formatter.weightState'). // LIVE-TEST: confirm the weight states render` &&
                 ` Success/Warning/Error per row via the core:require'd Formatter.weightState (first port referencing the curated formatter module, converted 2026-07-18). // IMPROVISED: the appended table's header` &&
                 ` toolbar keeps only Title and ToolbarSpacer - the sample's popin-layout ComboBox (with core:Item entries), the sticky CheckBoxes with their Label and the Hide/Show ToggleButton drive client-side table` &&
                 ` APIs (setSticky, popin layout) with no abap2UI5 equivalent; the infoToolbar (an OverflowToolbar with a Label) and the p:ColumnAIAction column plugin (newer than UI5 1.71) are dropped as well. //` &&
                 ` SUBSET: data is a 10-row subset of the mock /ProductCollection (ui5/mock/products.json), facet counters recomputed for the subset.`
        post171 = `core:require on the view root (since UI5 1.74) is newer than 1.71 but used for the formatter wiring - the app needs a UI5 release >= 1.74; on older releases reference the published global instead` &&
                 ` (formatter: 'z2ui5.Formatter.weightState').` )
      ( module = `sap.m` control = `sap.m.FlexBox`         name = `FlexBoxNested`             class = `z2ui5_cl_ai_app_404` path = `src/01/b04/z2ui5_cl_ai_app_404.clas.abap`
        notes = `LIVE-TEST: the original colours .item1..item6 and the h2 headings via a separate style.css; here it is injected as a core:HTML content attribute (a style tag, minified - see CAPABILITIES.md). Confirm` &&
                 ` the flex items render with their background colours in a running system.` )
      ( module = `sap.m` control = `sap.m.GenericTile`     name = `GenericTileAsKPITile`      class = `z2ui5_cl_ai_app_431` path = `src/01/b01/z2ui5_cl_ai_app_431.clas.abap`
        notes = `POST-1.71: frameType values OneByHalf / TwoByHalf (since UI5 1.83) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.83 to render them; OneByOne / TwoByOne (1.71) were` &&
                 ` never affected. // POST-1.71: systemInfo and appShortcut (since UI5 1.92) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.92 to render them. // POST-1.71: url on the` &&
                 ` link tiles (since UI5 1.76) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.76 to render it. // LIVE-TEST: the custom CSS class tileLayout (float: left) is kept and` &&
                 ` its style.css injected via a core:HTML content attribute (see CAPABILITIES.md) - confirm the float layout in a running system. // IMPROVISED: the relative test-resources image and backgroundImage` &&
                 ` paths are resolved to absolute sdk.openui5.org URLs so the tile images load standalone.`
        post171 = `frameType values OneByHalf / TwoByHalf (since UI5 1.83) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.83 to render them; OneByOne / TwoByOne (1.71) were never` &&
                 ` affected. // systemInfo and appShortcut (since UI5 1.92) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.92 to render them. // url on the link tiles (since UI5 1.76)` &&
                 ` is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.76 to render it.` )
      ( module = `sap.m` control = `sap.m.IconTabBar`      name = `IconTabBarStretchContent`  class = `z2ui5_cl_ai_app_433` path = `src/01/b04/z2ui5_cl_ai_app_433.clas.abap`
        notes = `LIVE-TEST: the original binds expanded="{device>/isNoPhone}" (a demo-kit helper model); restored 2026-07-16 as the expression {= !${device>/system/phone} } over the framework's device> model` &&
                 ` (source-verified available in main views) - confirm the tab bar collapses on phones. // SUBSET: the bound /ProductCollection shows a 8-row subset of the 123-row mock (ui5/mock/products.json) - a full` &&
                 ` unroll adds no demo value.` )
      ( module = `sap.m` control = `sap.m.Image`           name = `ImageModeBackground`       class = `z2ui5_cl_ai_app_434` path = `src/01/b01/z2ui5_cl_ai_app_434.clas.abap`
        notes = `IMPROVISED: the original binds src/mode to a JSONModel (img>/products, /imageMode); these fixed sample values are inlined here as literals (mode Background, the HT-7777 / HT-6100 demo images).` &&
                 ` height/width are restored over the device> model, see below. // LIVE-TEST: image height/width are device dependent in the original (imageHeight/imageWidth = 5em on a phone, 10em otherwise); restored` &&
                 ` as the expression {= ${device>/system/phone} ? '5em' : '10em' } over the framework's device> model (image 4 keeps its fixed 6em width, exactly as the original) - confirm the images shrink on a phone.` &&
                 ` // LIVE-TEST: the custom CSS class imageContainer (light blue background) of the box4 HBox is kept and the sample's styles.css (.imageContainer{background-color:#A9EAFF}) injected via a core:HTML` &&
                 ` content attribute (CAPABILITIES.md CSS row, as apps 431/404) - confirm the light-blue background renders behind image 4.` )
      ( module = `sap.m` control = `sap.m.Input`           name = `InputValueState`           class = `z2ui5_cl_ai_app_439` path = `src/01/b02/z2ui5_cl_ai_app_439.clas.abap`
        notes = `POST-1.71: showClearIcon (since UI5 1.94) on three inputs is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.94 to render it. // POST-1.71: the two formattedValueStateText` &&
                 ` aggregations (a FormattedText carrying Links, since UI5 1.78) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.78 to render them. // NOTE: the Links' press` &&
                 ` (.onFormattedTextLinkPress) round-trips as event LINK_PRESS and shows the controller's toast text, docked at CenterCenter 1:1 via message_toast_display( my = 'center center' at = 'center center' )` &&
                 ` (the client method exposes the MessageToast options object - source-verified in Messages.js). The original's preventDefault is not needed: the Links carry no href, so there is no default navigation` &&
                 ` to suppress.`
        post171 = `showClearIcon (since UI5 1.94) on three inputs is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.94 to render it. // the two formattedValueStateText aggregations (a` &&
                 ` FormattedText carrying Links, since UI5 1.78) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.78 to render them.` )
      ( module = `sap.m` control = `sap.m.Link`            name = `LinkEmphasized`            class = `z2ui5_cl_ai_app_440` path = `src/01/b01/z2ui5_cl_ai_app_440.clas.abap`
        notes = `LIVE-TEST: the last column keeps the original sap.ui.model.type.Currency composite binding 1:1 - number={ parts:[{path:'PRICE'},{path:'CURRENCY_CODE'}], type:'sap.ui.model.type.Currency',` &&
                 ` formatOptions:{showMeasure:false} } over a numeric PRICE field (TYPE p) - via a raw binding-info string (client-side standard type, no framework change; the same idiom the curated samples use, e.g.` &&
                 ` z2ui5_cl_demo_app_369). Confirm the price renders formatted per currency. // SUBSET: the bound /ProductCollection shows a 6-row subset of the 123-row mock (ui5/mock/products.json); HT-1002 is not` &&
                 ` part of the subset.` )
      ( module = `sap.m` control = `sap.m.List`            name = `ListCounter`               class = `z2ui5_cl_ai_app_441` path = `src/01/b04/z2ui5_cl_ai_app_441.clas.abap`
        notes = `POST-1.71: headerLevel="H2" on the List (since UI5 1.117) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.117 to render it. // SUBSET: the bound /ProductCollection` &&
                 ` shows a 11-row subset of the 123-row mock (ui5/mock/products.json) - a full unroll adds no demo value.`
        post171 = `headerLevel="H2" on the List (since UI5 1.117) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.117 to render it.` )
      ( module = `sap.m` control = `sap.m.List`            name = `ListNoData`                class = `z2ui5_cl_ai_app_445` path = `src/01/b04/z2ui5_cl_ai_app_445.clas.abap` )
      ( module = `sap.m` control = `sap.m.MessageBox`      name = `MessageBoxInitialFocus`    class = `z2ui5_cl_ai_app_447` path = `src/01/b03/z2ui5_cl_ai_app_447.clas.abap`
        notes = `NOTE: the sample opens a sap.m.MessageBox from its controller; there is no such control in the view. It is driven by two buttons wired to events that call client->message_box_display - the documented` &&
                 ` 1:1 path (CAPABILITIES.md marks sap.m.MessageBox as expressible with app 447 as its evidence port), not a workaround. // POST-1.71: ariaHasPopup="Dialog" on both buttons (since UI5 1.84) is newer` &&
                 ` than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it. // POST-1.71: the MessageBox emphasizedAction option (since UI5 1.75) is newer than 1.71 but kept for the 1:1` &&
                 ` port - the app needs a UI5 release >= 1.75 to render it. // POST-1.71: the MessageBox dependentOn option (since UI5 1.124) is restored via message_box_display's dependenton parameter, pointing at the` &&
                 ` view layout (id messageBoxHost); the app needs a UI5 release >= 1.124 to render it.`
        post171 = `ariaHasPopup="Dialog" on both buttons (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it. // the MessageBox emphasizedAction option (since` &&
                 ` UI5 1.75) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.75 to render it. // the MessageBox dependentOn option (since UI5 1.124) is restored via message_box_display's` &&
                 ` dependenton parameter, pointing at the view layout (id messageBoxHost); the app needs a UI5 release >= 1.124 to render it.` )
      ( module = `sap.m` control = `sap.m.MessageToast`    name = `MessageToast`              class = `z2ui5_cl_ai_app_448` path = `src/01/b03/z2ui5_cl_ai_app_448.clas.abap` )
      ( module = `sap.m` control = `sap.m.MessageView`     name = `MessageViewMessageManager` class = `z2ui5_cl_ai_app_449` path = `src/01/b03/z2ui5_cl_ai_app_449.clas.abap`
        notes = `NOTE: the original registers its four messages on the sap.ui.core.message.MessageManager and the MessageView binds them via the message> model; abap2UI5 has no MessageManager auto-collection model,` &&
                 ` but that is not needed to render a MessageView - the messages are bound as a plain ABAP table on MessageView items with a MessageItem template (client->_bind( t_messages )), which is the documented` &&
                 ` 1:1 path (CAPABILITIES.md), not a workaround. Same rendering as the original's static message set. The framework MessageManager auto-collection (gathering control validation messages client-side) is` &&
                 ` a separate, rarely-needed mechanism and out of scope for this render-only sample. Proven by the curated sample z2ui5_cl_demo_app_038 (MessageView + MessageItem + MessagePopover over a bound table).` )
      ( module = `sap.m` control = `sap.m.MultiComboBox`   name = `MultiComboBoxGrouping`     class = `z2ui5_cl_ai_app_452` path = `src/01/b02/z2ui5_cl_ai_app_452.clas.abap`
        notes = `NOTE: the custom groupHeaderFactory '.getGroupHeader' (controller code) is replaced by UI5's default group headers - the sample's factory builds a SeparatorItem with the group key, which is exactly` &&
                 ` what the default renders anyway (CAPABILITIES.md group-sorter row, source-verified on both sides), so this is a faithful 1:1, not a workaround. The items are a bound template with the original's` &&
                 ` sorter (path SUPPLIER_NAME, group: true) as a raw binding-info string. // SUBSET: 16-row subset of the 123-row mock (ui5/mock/products.json). // LIVE-TEST: confirm the group SeparatorItem headers` &&
                 ` render per supplier in the MultiComboBox picker (bound template + group sorter, converted 2026-07-16; string pass-through source-verified).` )
      ( module = `sap.m` control = `sap.m.MultiInput`      name = `MultiInput`                class = `z2ui5_cl_ai_app_454` path = `src/01/b02/z2ui5_cl_ai_app_454.clas.abap`
        notes = `NOTE: the controller's onInit pre-sets the tokens on both MultiInputs (Token 1..6 and one long token); they are declared statically in the view's tokens aggregation instead - same rendering` &&
                 ` (CAPABILITIES.md marks controller-filled aggregations as expressible, the tokens aggregation is public since UI5 1.16), so this is a faithful 1:1, not a workaround. // NOTE: the controller's onInit` &&
                 ` addValidator on multiInput1 and multiInput2 (typing free text + Enter -> new Token({key: text, text})) is wired via the bundled invisible companion control z2ui5.cc.MultiInputExt` &&
                 ` (xmlns:z2ui5="z2ui5.cc"): one MultiInputExt per input, referencing it by MultiInputId - the control installs exactly the original's validator (source-verified in app/webapp/cc/MultiInputExt.js). The` &&
                 ` two MultiInputExt elements are extra vs the original view.xml (there the validator lives in the controller); first cc-control usage in these ports (converted 2026-07-18). // LIVE-TEST: confirm free` &&
                 ` text + Enter creates a token on both multiInput1 and multiInput2 via the z2ui5.cc.MultiInputExt companions (first cc-control usage in these ports). // SUBSET: the suggestion data is a 16-row subset` &&
                 ` of the mock /ProductCollection (ui5/mock/products.json). // NOTE: The original's stray placeholder attributes on the two Labels (not a Label property) are dropped. // POST-1.71: showClearIcon (since` &&
                 ` UI5 1.94) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.94 to render it.`
        post171 = `showClearIcon (since UI5 1.94) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.94 to render it.` )
      ( module = `sap.m` control = `sap.m.ObjectHeader`    name = `ObjectHeader`              class = `z2ui5_cl_ai_app_460` path = `src/01/b01/z2ui5_cl_ai_app_460.clas.abap`
        notes = `IMPROVISED: the sample binds the ObjectHeader to {/ProductCollection/0} and its title/number/attributes to model fields (with a Currency type formatter on number). The port carries no model, so those` &&
                 ` bindings are resolved to the static values of the first ProductCollection product (Notebook Basic 15) - incl. the ObjectAttribute texts ({Description}, weight, dimensions, www.sap.com) and the` &&
                 ` numberUnit {CurrencyCode}.` )
      ( module = `sap.m` control = `sap.m.ObjectStatus`    name = `ObjectStatus`              class = `z2ui5_cl_ai_app_529` path = `src/01/b01/z2ui5_cl_ai_app_529.clas.abap`
        notes = `POST-1.71: the ObjectStatus state values Indication06-Indication08 (since UI5 1.75) and Indication09-Indication20 (since UI5 1.120) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5` &&
                 ` release >= 1.120 to render them all (>= 1.75 for Indication06-Indication08). // LIVE-TEST: the active status press opens the controller-built Dialog 1:1 (core:FragmentDefinition + popup_display, per` &&
                 ` CAPABILITIES.md): a Dialog with a VBox, a Text and an OK Button - these popup controls are extra to the view XML. Confirm the popup opens and closes in a running system.`
        post171 = `the ObjectStatus state values Indication06-Indication08 (since UI5 1.75) and Indication09-Indication20 (since UI5 1.120) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >=` &&
                 ` 1.120 to render them all (>= 1.75 for Indication06-Indication08).` )
      ( module = `sap.m` control = `sap.m.Panel`           name = `PanelExpanded`             class = `z2ui5_cl_ai_app_471` path = `src/01/b04/z2ui5_cl_ai_app_471.clas.abap`
        notes = `NOTE: the original controller toggles the third panel imperatively (onOverflowToolbarPress -> oPanel.setExpanded(!oPanel.getExpanded())). Reproduced 1:1 since the whitelist extension (2026-07-18, see` &&
                 ` pr/control-call-whitelist): the TOOLBAR_PRESSED handler inverts a server-side mirror of the state and calls client->control_call_by_id( method = setExpanded ) on the panel - the view no longer` &&
                 ` carries the improvised two-way ``expanded`` binding, matching the original view.xml exactly. // LIVE-TEST: confirm the third panel expands/collapses on each toolbar press (the follow-up setExpanded` &&
                 ` runs after the round-trip) - together with app 469 the first ports using the extended control_call_by_id whitelist.` )
      ( module = `sap.m` control = `sap.m.PDFViewer`       name = `PDFViewerPopup`            class = `z2ui5_cl_ai_app_469` path = `src/01/b03/z2ui5_cl_ai_app_469.clas.abap`
        notes = `NOTE: the original onInit creates a popup-mode sap.m.PDFViewer and adds it as a view dependent; it is declared 1:1 in the view's mvc:dependents aggregation (an extra PDFViewer element vs the original` &&
                 ` view.xml, which never carries it - there it lives in the controller). onPress' setSource/setTitle/open() becomes a bound source updated per click, the constant title declared in the view, and the` &&
                 ` whitelisted open via client->control_call_by_id after render - popup mode 1:1, the earlier Dialog embedding workaround is gone (whitelist extended upstream 2026-07-18, see pr/control-call-whitelist).` &&
                 ` // IMPROVISED: the per-image JSONModels of onInit (a Source/Preview URL pair per Image) have no server-side equivalent; the Image src (original {/Preview}) is resolved to static absolute` &&
                 ` sdk.openui5.org URLs and the Source travels through the one bound pdf_source field - same family as pr/named-json-models. // POST-1.71: the PDFViewer property isTrustedSource (since UI5 1.121,` &&
                 ` backported to maintenance patches down to 1.71.63; the original controller passes isTrustedSource: true) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.121 (or a` &&
                 ` patched maintenance release) to render it. // LIVE-TEST: confirm the popup-mode PDFViewer opens after the SHOW_PDF round-trip (view_model_update applies the new source before the follow-up open runs)` &&
                 ` and shows the clicked PDF in a running system - first port using the extended control_call_by_id whitelist.`
        post171 = `the PDFViewer property isTrustedSource (since UI5 1.121, backported to maintenance patches down to 1.71.63; the original controller passes isTrustedSource: true) is newer than 1.71 but kept for the` &&
                 ` 1:1 port - the app needs a UI5 release >= 1.121 (or a patched maintenance release) to render it.` )
      ( module = `sap.m` control = `sap.m.RangeSlider`     name = `RangeSlider`               class = `z2ui5_cl_ai_app_472` path = `src/01/b02/z2ui5_cl_ai_app_472.clas.abap`
        notes = `IMPROVISED: the sample binds the composite RangeSlider "range" property (an array [low, high] - range="{/RS1}" / range="0,100"). abap2UI5 binds scalar ABAP fields, so each range is expressed as the` &&
                 ` equivalent value / value2 properties the control keeps in sync - identical rendering.` )
      ( module = `sap.m` control = `sap.m.ScrollContainer` name = `ScrollContainer`           class = `z2ui5_cl_ai_app_473` path = `src/01/b04/z2ui5_cl_ai_app_473.clas.abap`
        notes = `IMPROVISED: the Image src binds {img>/products/pic1} in the original, a JSON image model not available server-side; a static demo image URL is used instead. // LIVE-TEST: the original narrows the` &&
                 ` width to 50em on phones via sap/ui/Device in the controller; restored 2026-07-16 as the expression {= ${device>/system/phone} ? '50em' : '100em' } over the framework's device> model (source-verified` &&
                 ` available in main views) - confirm the width switches on a phone.` )
      ( module = `sap.m` control = `sap.m.SegmentedButton` name = `SegmentedButton`           class = `z2ui5_cl_ai_app_474` path = `src/01/b03/z2ui5_cl_ai_app_474.clas.abap`
        notes = `IMPROVISED: the original reads the selected item via oEvent.getParameter("item").getText() / getSelectedItem(). Here the items get keys (one/two/three - an addition, SB1 has none in the sample) and` &&
                 ` selectedKey is two-way bound, so the selection arrives with the event and no private event path is needed (see CAPABILITIES.md). // LIVE-TEST: confirm the two-way bound selectedKey is updated before` &&
                 ` on_event runs, so the toast shows the newly selected item.` )
      ( module = `sap.m` control = `sap.m.Select`          name = `Select`                    class = `z2ui5_cl_ai_app_527` path = `src/01/b02/z2ui5_cl_ai_app_527.clas.abap` )
      ( module = `sap.m` control = `sap.m.StepInput`       name = `StepInput`                 class = `z2ui5_cl_ai_app_481` path = `src/01/b02/z2ui5_cl_ai_app_481.clas.abap`
        notes = `IMPROVISED: the sample binds a List to the JSON model /modelData and renders one templated CustomListItem per row. The rows are unrolled into static list items here because every row sets a different` &&
                 ` subset of the StepInput properties - an empty ABAP model field would bind as "" instead of leaving the property at its default, so a bound template would not render 1:1. Template properties no row` &&
                 ` ever sets (valueState) are dropped with it.` )
      ( module = `sap.m` control = `sap.m.Switch`          name = `Switch`                    class = `z2ui5_cl_ai_app_528` path = `src/01/b02/z2ui5_cl_ai_app_528.clas.abap` )
      ( module = `sap.m` control = `sap.m.Text`            name = `Text`                      class = `z2ui5_cl_ai_app_408` path = `src/01/b01/z2ui5_cl_ai_app_408.clas.abap` )
      ( module = `sap.m` control = `sap.m.TextArea`        name = `TextArea`                  class = `z2ui5_cl_ai_app_409` path = `src/01/b01/z2ui5_cl_ai_app_409.clas.abap` )
      ( module = `sap.m` control = `sap.m.Toolbar`         name = `ToolbarShrinkable`         class = `z2ui5_cl_ai_app_486` path = `src/01/b03/z2ui5_cl_ai_app_486.clas.abap`
        notes = `IMPROVISED: the sample's controller onSliderLiveChange resizes the toolbars in JS; there is no width in the source XML. Rebuilt as a client-side expression binding {= slider + '%' } on each Toolbar` &&
                 ` width - no event round-trip, resizes instantly like the original (see CAPABILITIES.md). // LIVE-TEST: confirm the expression-bound widths follow the slider in a running system.` )
      ( module = `sap.m` control = `sap.m.Tree`            name = `Tree`                      class = `z2ui5_cl_ai_app_487` path = `src/01/b04/z2ui5_cl_ai_app_487.clas.abap`
        notes = `LIVE-TEST: the sample's view is flat (one Tree bound to '/', one StandardTreeItem template); the hierarchy is carried entirely by the model. Each row's nested ``nodes`` sub-table (5 levels deep) is` &&
                 ` what UI5's JSONModel tree binding walks to build the child nodes - confirm the nested tables render as expandable levels in a running system.` ) ).

  ENDMETHOD.

ENDCLASS.
