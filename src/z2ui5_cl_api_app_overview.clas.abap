"! Generated overview app - lists every abap2UI5 api sample app in a table.
"! In the Sample column the name links the OpenUI5 source and the ↗ starts the
"! live OpenUI5 sample; in the abap2UI5 column the class name links the generated
"! ABAP class and the ↗ starts the app; Control links the OpenUI5 API - all
"! opening in a new browser tab. The Note column shows a green check when the
"! port was manually verified in a running system, and a hint button that opens
"! a popup with the port's generation caveats when present. Do not edit by hand -
"! regenerate with scripts/generate-overview.mjs
CLASS z2ui5_cl_api_app_overview DEFINITION PUBLIC.

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
    TYPES ty_t_app TYPE STANDARD TABLE OF ty_s_app WITH DEFAULT KEY.

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


CLASS z2ui5_cl_api_app_overview IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
        TYPES temp1 TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
DATA lt_line TYPE temp1.
        DATA popup TYPE REF TO z2ui5_cl_api_xml.
        DATA box TYPE REF TO z2ui5_cl_api_xml.
        DATA lv_line LIKE LINE OF lt_line.

    CASE client->get( )-event.

      WHEN `SHOW_NOTES`.
        " one Text per bullet of the clicked row's generation notes
        

        SPLIT client->get_event_arg( ) AT ` // ` INTO TABLE lt_line.

        
        popup = z2ui5_cl_api_xml=>factory( ).
        
        box = popup->open( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`

            )->open( `Dialog`
                )->a( n = `title`        v = `Generation notes`
                )->a( n = `contentWidth` v = `34rem`

                )->open( `VBox`
                    )->a( n = `class` v = `sapUiContentPadding` ).

        
        LOOP AT lt_line INTO lv_line.
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
    DATA start TYPE string.
    FIELD-SYMBOLS <app> LIKE LINE OF t_app.
      DATA libpath TYPE string.
      DATA dot TYPE i.
      DATA temp1 TYPE z2ui5_cl_api_app_overview=>ty_s_app-ctrl_name.
      DATA temp3 TYPE xsdboolean.
      DATA temp4 TYPE xsdboolean.
      DATA temp5 TYPE xsdboolean.
    DATA view TYPE REF TO z2ui5_cl_api_xml.
    DATA temp2 TYPE string_table.
    start = |{ client->get( )-s_config-origin }{ client->get( )-s_config-pathname }?app_start=|.

    t_app = get_catalog( ).
    
    LOOP AT t_app ASSIGNING <app>.

      
      libpath = replace( val = <app>-module
                               sub = `.`
                               with = `/`
                               occ = 0 ).

      " display only the bare control, without its namespace (sap.f.GridList -> GridList)
      
      dot = find( val = <app>-control sub = `.` occ = -1 ).
      
      IF dot >= 0.
        temp1 = substring( val = <app>-control off = dot + 1 ).
      ELSE.
        temp1 = <app>-control.
      ENDIF.
      <app>-ctrl_name = temp1.

      <app>-api_url   = |https://sdk.openui5.org/api/{ <app>-control }|.
      <app>-js_url    = |https://github.com/SAP/openui5/tree/master/src/{ <app>-module }| &&
                        |/test/{ libpath }/demokit/sample/{ <app>-name }|.
      <app>-ui5_url   = |https://sdk.openui5.org/resources/sap/ui/documentation/sdk/index.html| &&
                        |?sap-ui-xx-sample-id={ <app>-module }.sample.{ <app>-name }| &&
                        |&sap-ui-xx-sample-lib={ <app>-module }|.
      <app>-abap_url  = |https://github.com/abap2UI5/api/blob/main/{ <app>-path }|.
      <app>-start_url = |{ start }{ to_upper( <app>-class ) }|.
      
      temp3 = boolc( <app>-checked IS NOT INITIAL ).
      <app>-has_check = temp3.
      
      temp4 = boolc( <app>-notes IS NOT INITIAL ).
      <app>-has_notes = temp4.
      
      temp5 = boolc( <app>-post171 IS NOT INITIAL ).
      <app>-has_p171  = temp5.

    ENDLOOP.

    
    view = z2ui5_cl_api_xml=>factory( ).

    
    CLEAR temp2.
    INSERT `${NOTES}` INTO TABLE temp2.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( `Shell`
            )->open( `Page`
                )->a( n = `title`          v = `abap2UI5 - api`
                )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
                )->a( n = `showNavButton`  v = z2ui5_cl_api_xml=>as_bool( client->check_app_prev_stack( ) )

                )->open( `Table`
                    )->a( n = `sticky` v = `ColumnHeaders`
                    )->a( n = `items`  v = client->_bind_edit( t_app )

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
                                        )->a( n = `press`   v = client->_event( val = `SHOW_NOTES` t_arg = temp2 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD get_catalog.

    DATA temp4 TYPE z2ui5_cl_api_app_overview=>ty_t_app.
    DATA temp5 LIKE LINE OF temp4.
    CLEAR temp4.
    
    temp5-module = `sap.m`.
    temp5-control = `sap.m.Breadcrumbs`.
    temp5-name = `Breadcrumbs`.
    temp5-class = `z2ui5_cl_api_app_530`.
    temp5-path = `src/01/b01/z2ui5_cl_api_app_530.clas.abap`.
    temp5-checked = `CHECKED (2026-07-15): manually verified in a running system - the ${$source>/text} event arg delivers the clicked link's text as expected, everything works like the original.`.
    temp5-notes = `LIVE-TEST: the SEP_CHANGE round-trip (which read a private UI5-internal event path) was removed 2026-07-16 - selectedKey and separatorStyle share one two-way bound path, so the separator switches` &&
` client-side. Confirm the instant separator change in a running system.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.Button`.
    temp5-name = `Button`.
    temp5-class = `z2ui5_cl_api_app_526`.
    temp5-path = `src/01/b03/z2ui5_cl_api_app_526.clas.abap`.
    temp5-checked = `CHECKED (2026-07-15): manually verified in a running system - each press toasts the pressed button's client-side control id, read via the event arg $event.oSource.sId, exactly like the original.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.Carousel`.
    temp5-name = `CarouselWithControls`.
    temp5-class = `z2ui5_cl_api_app_420`.
    temp5-path = `src/01/b04/z2ui5_cl_api_app_420.clas.abap`.
    temp5-checked = `CHECKED (2026-07-15): manually verified in a running system - renders and scrolls like the original (see the note below on the flattened image model).`.
    temp5-notes = `IMPROVISED: the three carousel images bind to a separate named model in the original (img>/products/pic1..3 from sap/ui/demo/mock/img.json); resolved here to static image URLs, as abap2UI5 serves a` &&
` single default model. // SUBSET: the bound /ProductCollection shows a 10-row subset of the 123-row mock (ui5/mock/products.json) - a full unroll adds no demo value. // POST-1.71: ariaLabelledBy on` &&
` the Carousel (since UI5 1.125) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.125 to render it.`.
    temp5-post171 = `ariaLabelledBy on the Carousel (since UI5 1.125) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.125 to render it.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.CheckBox`.
    temp5-name = `CheckBoxTriState`.
    temp5-class = `z2ui5_cl_api_app_421`.
    temp5-path = `src/01/b02/z2ui5_cl_api_app_421.clas.abap`.
    temp5-checked = `CHECKED (2026-07-15): manually verified in a running system - the select-all parent checkbox and its tri-state expression bindings behave like the original.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.ColorPalette`.
    temp5-name = `ColorPalette`.
    temp5-class = `z2ui5_cl_api_app_422`.
    temp5-path = `src/01/b02/z2ui5_cl_api_app_422.clas.abap`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.ComboBox`.
    temp5-name = `ComboBox`.
    temp5-class = `z2ui5_cl_api_app_423`.
    temp5-path = `src/01/b02/z2ui5_cl_api_app_423.clas.abap`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.FacetFilter`.
    temp5-name = `FacetFilterLight`.
    temp5-class = `z2ui5_cl_api_app_401`.
    temp5-path = `src/01/b04/z2ui5_cl_api_app_401.clas.abap`.
    temp5-notes = `IMPROVISED: the bound lists="{/ProductCollectionStats/Filters}" collection is unrolled into two static FacetFilterLists (Category, SupplierName); the facet values inside each list stay bound. //` &&
` IMPROVISED: selection transport - every FacetFilterItem binds selected two-way; on listClose/reset the backend reads/clears the flags and re-filters (the original filters client-side via` &&
` sap.ui.model.Filter). // LIVE-TEST: confirm in a running system that clearing the bound selected flags on Reset also unchecks the facet popover checkboxes (FacetFilterList caches its selection` &&
` client-side). // IMPROVISED: the original controller appends the sap.m.sample.Table component's table with its first cell swapped for an ObjectIdentifier {Name}/{Category}; that table is rebuilt` &&
` inline, its Currency-formatter price column preformatted (PRICE text) and Formatter.js weightState precomputed in WEIGHT_STATE. // IMPROVISED: the appended table's header toolbar keeps only Title and` &&
` ToolbarSpacer - the sample's popin-layout ComboBox (with core:Item entries), the sticky CheckBoxes with their Label and the Hide/Show ToggleButton drive client-side table APIs (setSticky, popin` &&
` layout) with no abap2UI5 equivalent; the infoToolbar (an OverflowToolbar with a Label) and the p:ColumnAIAction column plugin (newer than UI5 1.71) are dropped as well. // SUBSET: data is a 10-row` &&
` subset of the mock /ProductCollection (ui5/mock/products.json), facet counters recomputed for the subset.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.FlexBox`.
    temp5-name = `FlexBoxNested`.
    temp5-class = `z2ui5_cl_api_app_404`.
    temp5-path = `src/01/b04/z2ui5_cl_api_app_404.clas.abap`.
    temp5-notes = `LIVE-TEST: the original colours .item1..item6 and the h2 headings via a separate style.css; here it is injected as a core:HTML content attribute (a style tag, minified - see CAPABILITIES.md). Confirm` &&
` the flex items render with their background colours in a running system.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.GenericTile`.
    temp5-name = `GenericTileAsKPITile`.
    temp5-class = `z2ui5_cl_api_app_431`.
    temp5-path = `src/01/b01/z2ui5_cl_api_app_431.clas.abap`.
    temp5-notes = `POST-1.71: frameType values OneByHalf / TwoByHalf (since UI5 1.83) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.83 to render them; OneByOne / TwoByOne (1.71) were` &&
` never affected. // POST-1.71: systemInfo and appShortcut (since UI5 1.92) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.92 to render them. // POST-1.71: url on the` &&
` link tiles (since UI5 1.76) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.76 to render it. // LIVE-TEST: the custom CSS class tileLayout (float: left) is kept and` &&
` its style.css injected via a core:HTML content attribute (see CAPABILITIES.md) - confirm the float layout in a running system. // IMPROVISED: the relative test-resources image and backgroundImage` &&
` paths are resolved to absolute sdk.openui5.org URLs so the tile images load standalone.`.
    temp5-post171 = `frameType values OneByHalf / TwoByHalf (since UI5 1.83) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.83 to render them; OneByOne / TwoByOne (1.71) were never` &&
` affected. // systemInfo and appShortcut (since UI5 1.92) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.92 to render them. // url on the link tiles (since UI5 1.76)` &&
` is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.76 to render it.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.IconTabBar`.
    temp5-name = `IconTabBarStretchContent`.
    temp5-class = `z2ui5_cl_api_app_433`.
    temp5-path = `src/01/b04/z2ui5_cl_api_app_433.clas.abap`.
    temp5-notes = `LIVE-TEST: the original binds expanded="{device>/isNoPhone}" (a demo-kit helper model); restored 2026-07-16 as the expression {= !${device>/system/phone} } over the framework's device> model` &&
` (source-verified available in main views) - confirm the tab bar collapses on phones. // SUBSET: the bound /ProductCollection shows a 8-row subset of the 123-row mock (ui5/mock/products.json) - a full` &&
` unroll adds no demo value.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.Image`.
    temp5-name = `ImageModeBackground`.
    temp5-class = `z2ui5_cl_api_app_434`.
    temp5-path = `src/01/b01/z2ui5_cl_api_app_434.clas.abap`.
    temp5-notes = `IMPROVISED: the original binds src/mode/height/width to a JSONModel (img>/products, /imageMode, /imageHeight, /imageWidth); the fixed sample values are inlined here as literals (mode Background, the` &&
` HT-7777 / HT-6100 demo images). // IMPROVISED: image height/width are device dependent in the original (5em on a phone) - fixed to 10em here. // IMPROVISED: the custom CSS class imageContainer (light` &&
` blue background) of the box4 HBox is dropped - its stylesheet is not available in abap2UI5.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.Input`.
    temp5-name = `InputValueState`.
    temp5-class = `z2ui5_cl_api_app_439`.
    temp5-path = `src/01/b02/z2ui5_cl_api_app_439.clas.abap`.
    temp5-notes = `POST-1.71: showClearIcon (since UI5 1.94) on three inputs is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.94 to render it. // POST-1.71: the two formattedValueStateText` &&
` aggregations (a FormattedText carrying Links, since UI5 1.78) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.78 to render them. // NOTE: the Links' press` &&
` (.onFormattedTextLinkPress) round-trips as event LINK_PRESS and shows the controller's toast text; the original docks the MessageToast at CenterCenter and calls preventDefault - not expressible via` &&
` message_toast_display, the toast appears at the default position.`.
    temp5-post171 = `showClearIcon (since UI5 1.94) on three inputs is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.94 to render it. // the two formattedValueStateText aggregations (a` &&
` FormattedText carrying Links, since UI5 1.78) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.78 to render them.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.Link`.
    temp5-name = `LinkEmphasized`.
    temp5-class = `z2ui5_cl_api_app_440`.
    temp5-path = `src/01/b01/z2ui5_cl_api_app_440.clas.abap`.
    temp5-notes = `IMPROVISED: the last column's original number binding is a sap.ui.model.type.Currency formatter (parts Price/CurrencyCode, formatOptions showMeasure:false); it is replaced by a plain ObjectNumber with` &&
` a preformatted price text (number={PRICE} unit={CURRENCY_CODE}). // SUBSET: the bound /ProductCollection shows a 6-row subset of the 123-row mock (ui5/mock/products.json); HT-1002 is not part of the` &&
` subset.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.List`.
    temp5-name = `ListCounter`.
    temp5-class = `z2ui5_cl_api_app_441`.
    temp5-path = `src/01/b04/z2ui5_cl_api_app_441.clas.abap`.
    temp5-notes = `POST-1.71: headerLevel="H2" on the List (since UI5 1.117) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.117 to render it. // SUBSET: the bound /ProductCollection` &&
` shows a 11-row subset of the 123-row mock (ui5/mock/products.json) - a full unroll adds no demo value.`.
    temp5-post171 = `headerLevel="H2" on the List (since UI5 1.117) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.117 to render it.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.List`.
    temp5-name = `ListNoData`.
    temp5-class = `z2ui5_cl_api_app_445`.
    temp5-path = `src/01/b04/z2ui5_cl_api_app_445.clas.abap`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.MessageBox`.
    temp5-name = `MessageBoxInitialFocus`.
    temp5-class = `z2ui5_cl_api_app_447`.
    temp5-path = `src/01/b03/z2ui5_cl_api_app_447.clas.abap`.
    temp5-notes = `IMPROVISED: the sample opens a sap.m.MessageBox from its controller; there is no such control in the view. It is mapped to abap2UI5's client->message_box_display, driven by two buttons wired to` &&
` events. // POST-1.71: ariaHasPopup="Dialog" on both buttons (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it. // POST-1.71: the` &&
` MessageBox emphasizedAction option (since UI5 1.75) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.75 to render it. // IMPROVISED: the MessageBox dependentOn option` &&
` (since UI5 1.124) of the original is not restored - the abap2UI5 API does not expose it (message_box_display in z2ui5_if_client has no such parameter).`.
    temp5-post171 = `ariaHasPopup="Dialog" on both buttons (since UI5 1.84) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.84 to render it. // the MessageBox emphasizedAction option (since` &&
` UI5 1.75) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.75 to render it.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.MessageToast`.
    temp5-name = `MessageToast`.
    temp5-class = `z2ui5_cl_api_app_448`.
    temp5-path = `src/01/b03/z2ui5_cl_api_app_448.clas.abap`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.MessageView`.
    temp5-name = `MessageViewMessageManager`.
    temp5-class = `z2ui5_cl_api_app_449`.
    temp5-path = `src/01/b03/z2ui5_cl_api_app_449.clas.abap`.
    temp5-notes = `IMPROVISED: the MessageManager/message model of the original is not available in abap2UI5 - the messages are bound from a hardcoded table instead.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.MultiComboBox`.
    temp5-name = `MultiComboBoxGrouping`.
    temp5-class = `z2ui5_cl_api_app_452`.
    temp5-path = `src/01/b02/z2ui5_cl_api_app_452.clas.abap`.
    temp5-notes = `IMPROVISED: the custom groupHeaderFactory '.getGroupHeader' (controller code) is replaced by UI5's default group headers - the sample's factory builds a SeparatorItem with the group key, which is what` &&
` the default renders anyway. The items are a bound template with the original's sorter (path SUPPLIER_NAME, group: true) as a raw binding-info string. // SUBSET: 16-row subset of the 123-row mock` &&
` (ui5/mock/products.json). // LIVE-TEST: confirm the group SeparatorItem headers render per supplier in the MultiComboBox picker (bound template + group sorter, converted 2026-07-16; string` &&
` pass-through source-verified).`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.MultiInput`.
    temp5-name = `MultiInput`.
    temp5-class = `z2ui5_cl_api_app_454`.
    temp5-path = `src/01/b02/z2ui5_cl_api_app_454.clas.abap`.
    temp5-notes = `IMPROVISED: the controller's onInit pre-sets the tokens on both MultiInputs (Token 1..6 and one long token); they are declared statically in the view's tokens aggregation instead - same rendering. //` &&
` IMPROVISED: the controller's addValidator (typing free text + Enter creates a token client-side) is dropped - abap2UI5 has no client-side validator hook. // SUBSET: the suggestion data is a 16-row` &&
` subset of the mock /ProductCollection (ui5/mock/products.json). // NOTE: The original's stray placeholder attributes on the two Labels (not a Label property) are dropped. // POST-1.71: showClearIcon` &&
` (since UI5 1.94) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.94 to render it.`.
    temp5-post171 = `showClearIcon (since UI5 1.94) is newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >= 1.94 to render it.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.ObjectHeader`.
    temp5-name = `ObjectHeader`.
    temp5-class = `z2ui5_cl_api_app_460`.
    temp5-path = `src/01/b01/z2ui5_cl_api_app_460.clas.abap`.
    temp5-notes = `IMPROVISED: the sample binds the ObjectHeader to {/ProductCollection/0} and its title/number/attributes to model fields (with a Currency type formatter on number). The port carries no model, so those` &&
` bindings are resolved to the static values of the first ProductCollection product (Notebook Basic 15).`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.ObjectStatus`.
    temp5-name = `ObjectStatus`.
    temp5-class = `z2ui5_cl_api_app_529`.
    temp5-path = `src/01/b01/z2ui5_cl_api_app_529.clas.abap`.
    temp5-notes = `POST-1.71: the ObjectStatus state values Indication06-Indication08 (since UI5 1.75) and Indication09-Indication20 (since UI5 1.120) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5` &&
` release >= 1.120 to render them all (>= 1.75 for Indication06-Indication08). // LIVE-TEST: the active status press opens the controller-built Dialog 1:1 (core:FragmentDefinition + popup_display, per` &&
` CAPABILITIES.md): a Dialog with a VBox, a Text and an OK Button - these popup controls are extra to the view XML. Confirm the popup opens and closes in a running system.`.
    temp5-post171 = `the ObjectStatus state values Indication06-Indication08 (since UI5 1.75) and Indication09-Indication20 (since UI5 1.120) are newer than 1.71 but kept for the 1:1 port - the app needs a UI5 release >=` &&
` 1.120 to render them all (>= 1.75 for Indication06-Indication08).`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.Panel`.
    temp5-name = `PanelExpanded`.
    temp5-class = `z2ui5_cl_api_app_471`.
    temp5-path = `src/01/b04/z2ui5_cl_api_app_471.clas.abap`.
    temp5-notes = `IMPROVISED: the original controller toggles the third panel imperatively (onOverflowToolbarPress -> oPanel.setExpanded(!oPanel.getExpanded())). It is reproduced with a two-way bound ``expanded``` &&
` property plus a TOOLBAR_PRESSED event that flips it - the view therefore carries an ``expanded`` binding and a ``press`` the original view.xml does not have.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.PDFViewer`.
    temp5-name = `PDFViewerPopup`.
    temp5-class = `z2ui5_cl_api_app_469`.
    temp5-path = `src/01/b03/z2ui5_cl_api_app_469.clas.abap`.
    temp5-notes = `IMPROVISED: the sample's onInit gives each Image its own JSONModel and onPress opens a controller-created sap.m.PDFViewer in popup mode via JavaScript. Here the per-image Source/Preview URLs are` &&
` resolved statically and the PDFViewer is embedded into a sap.m.Dialog opened on the press event instead, closed by an added OK Button (the popup-mode PDFViewer brings its own close button). //` &&
` POST-1.71: the PDFViewer property isTrustedSource (since UI5 1.121, backported to maintenance patches down to 1.71.63; the original controller passes isTrustedSource: true) is newer than 1.71 but` &&
` kept for the 1:1 port - the app needs a UI5 release >= 1.121 (or a patched maintenance release) to render it. // LIVE-TEST: confirm the PDFViewer renders inside the dialog at height 100% in a running` &&
` system.`.
    temp5-post171 = `the PDFViewer property isTrustedSource (since UI5 1.121, backported to maintenance patches down to 1.71.63; the original controller passes isTrustedSource: true) is newer than 1.71 but kept for the` &&
` 1:1 port - the app needs a UI5 release >= 1.121 (or a patched maintenance release) to render it.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.RangeSlider`.
    temp5-name = `RangeSlider`.
    temp5-class = `z2ui5_cl_api_app_472`.
    temp5-path = `src/01/b02/z2ui5_cl_api_app_472.clas.abap`.
    temp5-notes = `IMPROVISED: the sample binds the composite RangeSlider "range" property (an array [low, high] - range="{/RS1}" / range="0,100"). abap2UI5 binds scalar ABAP fields, so each range is expressed as the` &&
` equivalent value / value2 properties the control keeps in sync - identical rendering.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.ScrollContainer`.
    temp5-name = `ScrollContainer`.
    temp5-class = `z2ui5_cl_api_app_473`.
    temp5-path = `src/01/b04/z2ui5_cl_api_app_473.clas.abap`.
    temp5-notes = `IMPROVISED: the Image src binds {img>/products/pic1} in the original, a JSON image model not available server-side; a static demo image URL is used instead. // LIVE-TEST: the original narrows the` &&
` width to 50em on phones via sap/ui/Device in the controller; restored 2026-07-16 as the expression {= ${device>/system/phone} ? '50em' : '100em' } over the framework's device> model (source-verified` &&
` available in main views) - confirm the width switches on a phone.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.SegmentedButton`.
    temp5-name = `SegmentedButton`.
    temp5-class = `z2ui5_cl_api_app_474`.
    temp5-path = `src/01/b03/z2ui5_cl_api_app_474.clas.abap`.
    temp5-notes = `IMPROVISED: the original reads the selected item via oEvent.getParameter("item").getText() / getSelectedItem(). Here the items get keys (one/two/three - an addition, SB1 has none in the sample) and` &&
` selectedKey is two-way bound, so the selection arrives with the event and no private event path is needed (see CAPABILITIES.md). // LIVE-TEST: confirm the two-way bound selectedKey is updated before` &&
` on_event runs, so the toast shows the newly selected item.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.Select`.
    temp5-name = `Select`.
    temp5-class = `z2ui5_cl_api_app_527`.
    temp5-path = `src/01/b02/z2ui5_cl_api_app_527.clas.abap`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.StepInput`.
    temp5-name = `StepInput`.
    temp5-class = `z2ui5_cl_api_app_481`.
    temp5-path = `src/01/b02/z2ui5_cl_api_app_481.clas.abap`.
    temp5-notes = `IMPROVISED: the sample binds a List to the JSON model /modelData and renders one templated CustomListItem per row. The rows are unrolled into static list items here because every row sets a different` &&
` subset of the StepInput properties - an empty ABAP model field would bind as "" instead of leaving the property at its default, so a bound template would not render 1:1. Template properties no row` &&
` ever sets (valueState) are dropped with it.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.Switch`.
    temp5-name = `Switch`.
    temp5-class = `z2ui5_cl_api_app_528`.
    temp5-path = `src/01/b02/z2ui5_cl_api_app_528.clas.abap`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.Text`.
    temp5-name = `Text`.
    temp5-class = `z2ui5_cl_api_app_408`.
    temp5-path = `src/01/b01/z2ui5_cl_api_app_408.clas.abap`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.TextArea`.
    temp5-name = `TextArea`.
    temp5-class = `z2ui5_cl_api_app_409`.
    temp5-path = `src/01/b01/z2ui5_cl_api_app_409.clas.abap`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.Toolbar`.
    temp5-name = `ToolbarShrinkable`.
    temp5-class = `z2ui5_cl_api_app_486`.
    temp5-path = `src/01/b03/z2ui5_cl_api_app_486.clas.abap`.
    temp5-notes = `IMPROVISED: the sample's controller onSliderLiveChange resizes the toolbars in JS; there is no width in the source XML. Rebuilt as a client-side expression binding {= slider + '%' } on each Toolbar` &&
` width - no event round-trip, resizes instantly like the original (see CAPABILITIES.md). // LIVE-TEST: confirm the expression-bound widths follow the slider in a running system.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-module = `sap.m`.
    temp5-control = `sap.m.Tree`.
    temp5-name = `Tree`.
    temp5-class = `z2ui5_cl_api_app_487`.
    temp5-path = `src/01/b04/z2ui5_cl_api_app_487.clas.abap`.
    temp5-notes = `LIVE-TEST: the sample's view is flat (one Tree bound to '/', one StandardTreeItem template); the hierarchy is carried entirely by the model. Each row's nested ``nodes`` sub-table (5 levels deep) is` &&
` what UI5's JSONModel tree binding walks to build the child nodes - confirm the nested tables render as expandable levels in a running system.`.
    INSERT temp5 INTO TABLE temp4.
    result = temp4.

  ENDMETHOD.

ENDCLASS.
