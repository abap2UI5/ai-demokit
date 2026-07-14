"! Generated overview app - lists every abap2UI5 api sample app in a table.
"! In the Sample column the name links the OpenUI5 source and the ↗ starts the
"! live OpenUI5 sample; in the abap2UI5 column the class name links the generated
"! ABAP class and the ↗ starts the app; Control links the OpenUI5 API - all
"! opening in a new browser tab. The Note column shows a popover with the port's
"! generation caveats when present. Do not edit by hand - regenerate with
"! scripts/generate-overview.mjs
"! NOTES (generation):
"! - LIVE-TEST: the Note popover anchors to the pressed control via the event arg
"!   $event.oSource.sId; confirm it resolves the anchor in a running system.
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
        notes     TYPE string,
        has_notes TYPE abap_bool,
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
        " arg1 = the row's NOTES text, arg2 = the pressed control id (popover anchor)
        SPLIT client->get_event_arg( 1 ) AT ` // ` INTO TABLE DATA(lt_line).

        DATA(popover) = z2ui5_cl_api_xml=>factory( ).
        DATA(box) = popover->open( `Popover`
            )->attr( n = `title`        v = `Generation notes`
            )->attr( n = `placement`    v = `Auto`
            )->attr( n = `contentWidth` v = `32rem`

            )->open( `VBox`
                )->attr( n = `class` v = `sapUiContentPadding` ).

        LOOP AT lt_line INTO DATA(lv_line).
          box->leaf( `Text`
              )->attr( n = `text` v = lv_line ).
        ENDLOOP.

        client->popover_display( xml   = popover->stringify( )
                                 by_id = client->get_event_arg( 2 ) ).

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
      <app>-has_notes = xsdbool( <app>-notes IS NOT INITIAL ).

    ENDLOOP.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->attr( n = `xmlns`     v = `sap.m`
        )->attr( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `Shell`
            )->open( `Page`
                )->attr( n = `title`          v = `abap2UI5 - api`
                )->attr( n = `navButtonPress` v = client->_event_nav_app_leave( )
                )->attr( n = `showNavButton`  v = z2ui5_cl_api_xml=>as_bool( client->check_app_prev_stack( ) )

                )->open( `Table`
                    )->attr( n = `sticky` v = `ColumnHeaders`
                    )->attr( n = `items`  v = client->_bind( t_app )

                    )->open( `columns`
                        )->open( `Column`
                            )->leaf( `Text`
                                )->attr( n = `text` v = `Module`

                        )->shut(
                        )->open( `Column`
                            )->leaf( `Text`
                                )->attr( n = `text` v = `Control`

                        )->shut(
                        )->open( `Column`
                            )->leaf( `Text`
                                )->attr( n = `text` v = `Sample`

                        )->shut(
                        )->open( `Column`
                            )->leaf( `Text`
                                )->attr( n = `text` v = `abap2UI5`

                        )->shut(
                        )->open( `Column`
                            )->leaf( `Text`
                                )->attr( n = `text` v = `Note`

                        )->shut(
                    )->shut(

                    )->open( `items`
                        )->open( `ColumnListItem`
                            )->open( `cells`
                                )->leaf( `Text`
                                    )->attr( n = `text` v = `{MODULE}`
                                )->leaf( `Link`
                                    )->attr( n = `text`   v = `{CTRL_NAME}`
                                    )->attr( n = `href`   v = `{API_URL}`
                                    )->attr( n = `target` v = `_blank`

                                )->open( `HBox`
                                    )->leaf( `Link`
                                        )->attr( n = `text`   v = `{NAME}`
                                        )->attr( n = `href`   v = `{JS_URL}`
                                        )->attr( n = `target` v = `_blank`
                                    )->leaf( `Text`
                                        )->attr( n = `text` v = ` `
                                    )->leaf( `Link`
                                        )->attr( n = `text`   v = `↗`
                                        )->attr( n = `href`   v = `{UI5_URL}`
                                        )->attr( n = `target` v = `_blank`

                                )->shut(
                                )->open( `HBox`
                                    )->leaf( `Link`
                                        )->attr( n = `text`   v = `{CLASS}`
                                        )->attr( n = `href`   v = `{ABAP_URL}`
                                        )->attr( n = `target` v = `_blank`
                                    )->leaf( `Text`
                                        )->attr( n = `text` v = ` `
                                    )->leaf( `Link`
                                        )->attr( n = `text`   v = `↗`
                                        )->attr( n = `href`   v = `{START_URL}`
                                        )->attr( n = `target` v = `_blank`

                                )->shut(
                                )->leaf( `Button`
                                    )->attr( n = `icon`    v = `sap-icon://hint`
                                    )->attr( n = `type`    v = `Transparent`
                                    )->attr( n = `tooltip` v = `Generation notes`
                                    )->attr( n = `visible` v = `{HAS_NOTES}`
                                    )->attr( n = `press`   v = client->_event( val   = `SHOW_NOTES`
                                                                               t_arg = VALUE #( ( `{NOTES}` ) ( `$event.oSource.sId` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD get_catalog.

    result = VALUE #(
      ( module = `sap.f`       control = `sap.f.GridList`            name = `GridListBasic`             class = `z2ui5_cl_api_app_416` path = `src/04/z2ui5_cl_api_app_416.clas.abap` )
      ( module = `sap.m`       control = `sap.m.Breadcrumbs`         name = `Breadcrumbs`               class = `z2ui5_cl_api_app_530` path = `src/01/z2ui5_cl_api_app_530.clas.abap`
        notes = `LIVE-TEST: the link press reads the clicked link's text via the event arg ${$source>/text}. This $source> form is not used anywhere else in the repo and is unverified - confirm it delivers the text in` &&
                 ` a running system.` )
      ( module = `sap.m`       control = `sap.m.Button`              name = `Button`                    class = `z2ui5_cl_api_app_526` path = `src/01/z2ui5_cl_api_app_526.clas.abap`
        notes = `IMPROVISED: the original press handler toasts oEvent.getSource().getId() - a client-side control id that does not exist server-side. All presses collapse to one event that shows a static text instead.` )
      ( module = `sap.m`       control = `sap.m.Carousel`            name = `CarouselWithControls`      class = `z2ui5_cl_api_app_420` path = `src/01/z2ui5_cl_api_app_420.clas.abap`
        notes = `IMPROVISED: the three carousel images bind to a separate named model in the original (img>/products/pic1..3 from sap/ui/demo/mock/img.json); resolved here to static image URLs, as abap2UI5 serves a` &&
                 ` single default model.` )
      ( module = `sap.m`       control = `sap.m.CheckBox`            name = `CheckBoxTriState`          class = `z2ui5_cl_api_app_421` path = `src/01/z2ui5_cl_api_app_421.clas.abap` )
      ( module = `sap.m`       control = `sap.m.ColorPalette`        name = `ColorPalette`              class = `z2ui5_cl_api_app_422` path = `src/01/z2ui5_cl_api_app_422.clas.abap` )
      ( module = `sap.m`       control = `sap.m.ComboBox`            name = `ComboBox`                  class = `z2ui5_cl_api_app_423` path = `src/01/z2ui5_cl_api_app_423.clas.abap` )
      ( module = `sap.m`       control = `sap.m.FacetFilter`         name = `FacetFilterLight`          class = `z2ui5_cl_api_app_401` path = `src/01/z2ui5_cl_api_app_401.clas.abap` )
      ( module = `sap.m`       control = `sap.m.FlexBox`             name = `FlexBoxNested`             class = `z2ui5_cl_api_app_404` path = `src/01/z2ui5_cl_api_app_404.clas.abap`
        notes = `IMPROVISED: the original sample colours .item1..item6 and the h2 headings via a separate style.css; the previous port injected it through an html:style block. z2ui5_cl_api_xml has no raw-text/CDATA` &&
                 ` node, so that CSS cannot be emitted - the styleClass attributes are ported 1:1 but the flex items render without their background colours. Dropped.` )
      ( module = `sap.m`       control = `sap.m.GenericTile`         name = `GenericTileAsKPITile`      class = `z2ui5_cl_api_app_431` path = `src/01/z2ui5_cl_api_app_431.clas.abap`
        notes = `1.71: frameType OneByHalf / TwoByHalf dropped on several tiles - both enum values were added in UI5 1.83; OneByOne / TwoByOne (1.71) are kept. // 1.71: systemInfo and appShortcut dropped - both added` &&
                 ` in UI5 1.92. // 1.71: url dropped on the link tiles - added in UI5 1.76. // IMPROVISED: the custom CSS class tileLayout is dropped from the class attribute - the sample's style.css (float: left)` &&
                 ` cannot be injected here. // IMPROVISED: the relative test-resources image and backgroundImage paths are resolved to absolute sdk.openui5.org URLs so the tile images load standalone.` )
      ( module = `sap.m`       control = `sap.m.IconTabBar`          name = `IconTabBarStretchContent`  class = `z2ui5_cl_api_app_433` path = `src/01/z2ui5_cl_api_app_433.clas.abap`
        notes = `IMPROVISED: the IconTabBar property expanded="{device>/isNoPhone}" is dropped - abap2UI5 has no device model, so the phone/non-phone binding cannot be expressed. The tab bar stays expanded.` )
      ( module = `sap.m`       control = `sap.m.Image`               name = `ImageModeBackground`       class = `z2ui5_cl_api_app_434` path = `src/01/z2ui5_cl_api_app_434.clas.abap`
        notes = `IMPROVISED: the original binds src/mode/height/width to a JSONModel (img>/products, /imageMode, /imageHeight, /imageWidth); the fixed sample values are inlined here as literals (mode Background, the` &&
                 ` HT-7777 / HT-6100 demo images). // IMPROVISED: image height/width are device dependent in the original (5em on a phone) - fixed to 10em here. // IMPROVISED: the custom CSS class imageContainer (light` &&
                 ` blue background) of the box4 HBox is dropped - its stylesheet is not available in abap2UI5.` )
      ( module = `sap.m`       control = `sap.m.Input`               name = `InputValueState`           class = `z2ui5_cl_api_app_439` path = `src/01/z2ui5_cl_api_app_439.clas.abap`
        notes = `1.71: Input property showClearIcon (since UI5 1.94) dropped from three inputs. // 1.71: the two formattedValueStateText aggregations (a FormattedText carrying Links, since UI5 1.78) omitted;` &&
                 ` valueState/valueStateText still render the state.` )
      ( module = `sap.m`       control = `sap.m.Link`                name = `LinkEmphasized`            class = `z2ui5_cl_api_app_440` path = `src/01/z2ui5_cl_api_app_440.clas.abap`
        notes = `IMPROVISED: the last column's original number binding is a sap.ui.model.type.Currency formatter (parts Price/CurrencyCode, formatOptions showMeasure:false); it is replaced by a plain ObjectNumber with` &&
                 ` a preformatted price text (number={PRICE} unit={CURRENCY_CODE}).` )
      ( module = `sap.m`       control = `sap.m.List`                name = `ListCounter`               class = `z2ui5_cl_api_app_441` path = `src/01/z2ui5_cl_api_app_441.clas.abap` )
      ( module = `sap.m`       control = `sap.m.List`                name = `ListNoData`                class = `z2ui5_cl_api_app_445` path = `src/01/z2ui5_cl_api_app_445.clas.abap` )
      ( module = `sap.m`       control = `sap.m.MessageBox`          name = `MessageBoxInitialFocus`    class = `z2ui5_cl_api_app_447` path = `src/01/z2ui5_cl_api_app_447.clas.abap`
        notes = `IMPROVISED: the sample opens a sap.m.MessageBox from its controller; there is no such control in the view. It is mapped to abap2UI5's client->message_box_display, driven by two buttons wired to` &&
                 ` events. // 1.71: the buttons' ariaHasPopup="Dialog" is dropped (available only since UI5 1.84). // 1.71: the MessageBox emphasizedAction / dependentOn options of the original are dropped (available` &&
                 ` only since UI5 1.75 / 1.124).` )
      ( module = `sap.m`       control = `sap.m.MessageToast`        name = `MessageToast`              class = `z2ui5_cl_api_app_448` path = `src/01/z2ui5_cl_api_app_448.clas.abap` )
      ( module = `sap.m`       control = `sap.m.MessageView`         name = `MessageViewMessageManager` class = `z2ui5_cl_api_app_449` path = `src/01/z2ui5_cl_api_app_449.clas.abap`
        notes = `IMPROVISED: the MessageManager/message model of the original is not available in abap2UI5 - the messages are bound from a hardcoded table instead.` )
      ( module = `sap.m`       control = `sap.m.MultiComboBox`       name = `MultiComboBoxGrouping`     class = `z2ui5_cl_api_app_452` path = `src/01/z2ui5_cl_api_app_452.clas.abap`
        notes = `IMPROVISED: the original binds items with a model sorter (group: true) and a groupHeaderFactory, neither of which is expressible in abap2UI5 - so the grouped items are rendered statically as` &&
                 ` core:SeparatorItem headers + core:Item entries, built in a LOOP over the ABAP data instead of a bound aggregation.` )
      ( module = `sap.m`       control = `sap.m.MultiInput`          name = `MultiInput`                class = `z2ui5_cl_api_app_454` path = `src/01/z2ui5_cl_api_app_454.clas.abap` )
      ( module = `sap.m`       control = `sap.m.ObjectHeader`        name = `ObjectHeader`              class = `z2ui5_cl_api_app_460` path = `src/01/z2ui5_cl_api_app_460.clas.abap`
        notes = `IMPROVISED: the sample binds the ObjectHeader to {/ProductCollection/0} and its title/number/attributes to model fields (with a Currency type formatter on number). The port carries no model, so those` &&
                 ` bindings are resolved to the static values of the first ProductCollection product (Notebook Basic 15).` )
      ( module = `sap.m`       control = `sap.m.ObjectStatus`        name = `ObjectStatus`              class = `z2ui5_cl_api_app_529` path = `src/01/z2ui5_cl_api_app_529.clas.abap`
        notes = `1.71: ObjectStatus states Indication06-Indication20 are newer than UI5 1.71 (added ~1.130). The controls are kept but their state is set to "None", so the indication colours differ from the original -` &&
                 ` verify if relevant. // IMPROVISED: the active status press originally opens a controller-built Dialog; replaced with message_toast_display, since a Dialog is not a 1:1 view element.` )
      ( module = `sap.m`       control = `sap.m.Panel`               name = `PanelExpanded`             class = `z2ui5_cl_api_app_471` path = `src/01/z2ui5_cl_api_app_471.clas.abap`
        notes = `IMPROVISED: the original controller toggles the third panel imperatively (onOverflowToolbarPress -> oPanel.setExpanded(!oPanel.getExpanded())). It is reproduced with a two-way bound ``expanded``` &&
                 ` property plus a TOOLBAR_PRESSED event that flips it - the view therefore carries an ``expanded`` binding and a ``press`` the original view.xml does not have.` )
      ( module = `sap.m`       control = `sap.m.PDFViewer`           name = `PDFViewerPopup`            class = `z2ui5_cl_api_app_469` path = `src/01/z2ui5_cl_api_app_469.clas.abap`
        notes = `IMPROVISED: the sample's onInit gives each Image its own JSONModel and onPress opens a controller-created sap.m.PDFViewer in popup mode via JavaScript. Here the per-image Source/Preview URLs are` &&
                 ` resolved statically and the PDFViewer is embedded into a sap.m.Dialog opened on the press event instead. // 1.71: the PDFViewer property isTrustedSource of the original is omitted - it is available` &&
                 ` only in UI5 releases higher than 1.71. // LIVE-TEST: confirm the PDFViewer renders inside the dialog at height 100% in a running system.` )
      ( module = `sap.m`       control = `sap.m.RangeSlider`         name = `RangeSlider`               class = `z2ui5_cl_api_app_472` path = `src/01/z2ui5_cl_api_app_472.clas.abap`
        notes = `IMPROVISED: the sample binds the composite RangeSlider "range" property (an array [low, high] - range="{/RS1}" / range="0,100"). abap2UI5 binds scalar ABAP fields, so each range is expressed as the` &&
                 ` equivalent value / value2 properties the control keeps in sync - identical rendering.` )
      ( module = `sap.m`       control = `sap.m.ScrollContainer`     name = `ScrollContainer`           class = `z2ui5_cl_api_app_473` path = `src/01/z2ui5_cl_api_app_473.clas.abap`
        notes = `IMPROVISED: the Image src binds {img>/products/pic1} in the original, a JSON image model not available server-side; a static demo image URL is used instead. // IMPROVISED: the original narrows the` &&
                 ` width to 50em on phone devices via sap/ui/Device (not available server-side); a fixed 100em is used.` )
      ( module = `sap.m`       control = `sap.m.SegmentedButton`     name = `SegmentedButton`           class = `z2ui5_cl_api_app_474` path = `src/01/z2ui5_cl_api_app_474.clas.abap` )
      ( module = `sap.m`       control = `sap.m.Select`              name = `Select`                    class = `z2ui5_cl_api_app_527` path = `src/01/z2ui5_cl_api_app_527.clas.abap` )
      ( module = `sap.m`       control = `sap.m.StepInput`           name = `StepInput`                 class = `z2ui5_cl_api_app_481` path = `src/01/z2ui5_cl_api_app_481.clas.abap`
        notes = `IMPROVISED: the sample binds a List to the JSON model /modelData and renders one templated CustomListItem per row. The rows are unrolled into static list items here because every row sets a different` &&
                 ` subset of the StepInput properties - an empty ABAP model field would bind as "" instead of leaving the property at its default, so a bound template would not render 1:1.` )
      ( module = `sap.m`       control = `sap.m.Switch`              name = `Switch`                    class = `z2ui5_cl_api_app_528` path = `src/01/z2ui5_cl_api_app_528.clas.abap` )
      ( module = `sap.m`       control = `sap.m.Text`                name = `Text`                      class = `z2ui5_cl_api_app_408` path = `src/01/z2ui5_cl_api_app_408.clas.abap` )
      ( module = `sap.m`       control = `sap.m.TextArea`            name = `TextArea`                  class = `z2ui5_cl_api_app_409` path = `src/01/z2ui5_cl_api_app_409.clas.abap` )
      ( module = `sap.m`       control = `sap.m.Toolbar`             name = `ToolbarShrinkable`         class = `z2ui5_cl_api_app_486` path = `src/01/z2ui5_cl_api_app_486.clas.abap`
        notes = `IMPROVISED: the sample's controller onSliderLiveChange resizes the toolbars in JS; there is no width in the source XML. Rebuilt as a bound width on each Toolbar fed by the SLIDER_CHANGE liveChange` &&
                 ` event - this width binding is an addition not present in Toolbar.view.xml.` )
      ( module = `sap.m`       control = `sap.m.Tree`                name = `Tree`                      class = `z2ui5_cl_api_app_487` path = `src/01/z2ui5_cl_api_app_487.clas.abap`
        notes = `LIVE-TEST: the sample's view is flat (one Tree bound to '/', one StandardTreeItem template); the hierarchy is carried entirely by the model. Each row's nested ``nodes`` sub-table (5 levels deep) is` &&
                 ` what UI5's JSONModel tree binding walks to build the child nodes - confirm the nested tables render as expandable levels in a running system.` )
      ( module = `sap.ui.core` control = `sap.ui.model.type.Integer` name = `TypeInteger`               class = `z2ui5_cl_api_app_508` path = `src/02/z2ui5_cl_api_app_508.clas.abap` ) ).

  ENDMETHOD.

ENDCLASS.
