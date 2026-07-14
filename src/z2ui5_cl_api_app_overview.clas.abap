"! Generated overview app - lists every abap2UI5 api sample app in a table.
"! Each row links the OpenUI5 control API, the OpenUI5 sample source, the live
"! OpenUI5 fullscreen sample, the generated ABAP class and a start link for the
"! abap2UI5 app - all opening in a new browser tab. Do not edit by hand -
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
      END OF ty_s_app.
    TYPES ty_t_app TYPE STANDARD TABLE OF ty_s_app WITH DEFAULT KEY.

    DATA t_app TYPE ty_t_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
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
    ENDIF.

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

    ENDLOOP.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(tab) = view->shell(
        )->page(
            title          = `abap2UI5 - api`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( )
        )->table(
            sticky = `ColumnHeaders`
            items  = client->_bind( t_app ) ).

    tab->columns(
        )->column( )->text( `Module` )->get_parent(
        )->column( )->text( `Control` )->get_parent(
        )->column( )->text( `Sample` )->get_parent(
        )->column( )->text( `JavaScript` )->get_parent(
        )->column( )->text( `UI5 App` )->get_parent(
        )->column( )->text( `ABAP` )->get_parent(
        )->column( )->text( `abap2UI5 App` ).

    tab->items(
        )->column_list_item(
            )->cells(
                )->text( `{MODULE}`
                )->link( text   = `{CTRL_NAME}`
                         href   = `{API_URL}`
                         target = `_blank`
                )->text( `{NAME}`
                )->link( text   = `↗`
                         href   = `{JS_URL}`
                         target = `_blank`
                )->link( text   = `↗`
                         href   = `{UI5_URL}`
                         target = `_blank`
                )->link( text   = `↗`
                         href   = `{ABAP_URL}`
                         target = `_blank`
                )->link( text   = `↗`
                         href   = `{START_URL}`
                         target = `_blank` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD get_catalog.

    result = VALUE #(
      ( module = `sap.f`              control = `sap.f.GridList`                   name = `GridListBasic`                      class = `z2ui5_cl_api_app_416` path = `src/04/z2ui5_cl_api_app_416.clas.abap` )
      ( module = `sap.f`              control = `sap.f.GridList`                   name = `GridListBoxContainer`               class = `z2ui5_cl_api_app_417` path = `src/04/z2ui5_cl_api_app_417.clas.abap` )
      ( module = `sap.f`              control = `sap.f.GridList`                   name = `GridListBoxContainerGrouping`       class = `z2ui5_cl_api_app_418` path = `src/04/z2ui5_cl_api_app_418.clas.abap` )
      ( module = `sap.f`              control = `sap.f.ShellBar`                   name = `ShellBar`                           class = `z2ui5_cl_api_app_419` path = `src/04/z2ui5_cl_api_app_419.clas.abap` )
      ( module = `sap.m`              control = `sap.m.Carousel`                   name = `CarouselWithControls`               class = `z2ui5_cl_api_app_420` path = `src/01/z2ui5_cl_api_app_420.clas.abap` )
      ( module = `sap.m`              control = `sap.m.CheckBox`                   name = `CheckBoxTriState`                   class = `z2ui5_cl_api_app_421` path = `src/01/z2ui5_cl_api_app_421.clas.abap` )
      ( module = `sap.m`              control = `sap.m.ColorPalette`               name = `ColorPalette`                       class = `z2ui5_cl_api_app_422` path = `src/01/z2ui5_cl_api_app_422.clas.abap` )
      ( module = `sap.m`              control = `sap.m.ComboBox`                   name = `ComboBox`                           class = `z2ui5_cl_api_app_423` path = `src/01/z2ui5_cl_api_app_423.clas.abap` )
      ( module = `sap.m`              control = `sap.m.ComboBox`                   name = `ComboBox2Columns`                   class = `z2ui5_cl_api_app_424` path = `src/01/z2ui5_cl_api_app_424.clas.abap` )
      ( module = `sap.m`              control = `sap.m.ComboBox`                   name = `ComboBoxDefaultFiltering`           class = `z2ui5_cl_api_app_425` path = `src/01/z2ui5_cl_api_app_425.clas.abap` )
      ( module = `sap.m`              control = `sap.m.ComboBox`                   name = `ComboBoxGrouping`                   class = `z2ui5_cl_api_app_428` path = `src/01/z2ui5_cl_api_app_428.clas.abap` )
      ( module = `sap.m`              control = `sap.m.CustomTreeItem`             name = `CustomTreeItem`                     class = `z2ui5_cl_api_app_429` path = `src/01/z2ui5_cl_api_app_429.clas.abap` )
      ( module = `sap.m`              control = `sap.m.DisplayListItem`            name = `DisplayListItem`                    class = `z2ui5_cl_api_app_430` path = `src/01/z2ui5_cl_api_app_430.clas.abap` )
      ( module = `sap.m`              control = `sap.m.FacetFilter`                name = `FacetFilterLight`                   class = `z2ui5_cl_api_app_401` path = `src/01/z2ui5_cl_api_app_401.clas.abap` )
      ( module = `sap.m`              control = `sap.m.FlexBox`                    name = `FlexBoxCols`                        class = `z2ui5_cl_api_app_402` path = `src/01/z2ui5_cl_api_app_402.clas.abap` )
      ( module = `sap.m`              control = `sap.m.FlexBox`                    name = `FlexBoxNav`                         class = `z2ui5_cl_api_app_403` path = `src/01/z2ui5_cl_api_app_403.clas.abap` )
      ( module = `sap.m`              control = `sap.m.FlexBox`                    name = `FlexBoxNested`                      class = `z2ui5_cl_api_app_404` path = `src/01/z2ui5_cl_api_app_404.clas.abap` )
      ( module = `sap.m`              control = `sap.m.FlexBox`                    name = `FlexBoxSizeAdjustments`             class = `z2ui5_cl_api_app_405` path = `src/01/z2ui5_cl_api_app_405.clas.abap` )
      ( module = `sap.m`              control = `sap.m.GenericTile`                name = `GenericTileAsKPITile`               class = `z2ui5_cl_api_app_431` path = `src/01/z2ui5_cl_api_app_431.clas.abap` )
      ( module = `sap.m`              control = `sap.m.IconTabBar`                 name = `IconTabBarOverflowSelectList`       class = `z2ui5_cl_api_app_432` path = `src/01/z2ui5_cl_api_app_432.clas.abap` )
      ( module = `sap.m`              control = `sap.m.IconTabBar`                 name = `IconTabBarStretchContent`           class = `z2ui5_cl_api_app_433` path = `src/01/z2ui5_cl_api_app_433.clas.abap` )
      ( module = `sap.m`              control = `sap.m.Image`                      name = `ImageModeBackground`                class = `z2ui5_cl_api_app_434` path = `src/01/z2ui5_cl_api_app_434.clas.abap` )
      ( module = `sap.m`              control = `sap.m.Input`                      name = `InputAssistedTabularSuggestions`    class = `z2ui5_cl_api_app_435` path = `src/01/z2ui5_cl_api_app_435.clas.abap` )
      ( module = `sap.m`              control = `sap.m.Input`                      name = `InputAssistedTwoValues`             class = `z2ui5_cl_api_app_436` path = `src/01/z2ui5_cl_api_app_436.clas.abap` )
      ( module = `sap.m`              control = `sap.m.Input`                      name = `InputGrouping`                      class = `z2ui5_cl_api_app_437` path = `src/01/z2ui5_cl_api_app_437.clas.abap` )
      ( module = `sap.m`              control = `sap.m.Input`                      name = `InputSuggestionsCustomFilter`       class = `z2ui5_cl_api_app_438` path = `src/01/z2ui5_cl_api_app_438.clas.abap` )
      ( module = `sap.m`              control = `sap.m.Input`                      name = `InputValueState`                    class = `z2ui5_cl_api_app_439` path = `src/01/z2ui5_cl_api_app_439.clas.abap` )
      ( module = `sap.m`              control = `sap.m.Link`                       name = `LinkEmphasized`                     class = `z2ui5_cl_api_app_440` path = `src/01/z2ui5_cl_api_app_440.clas.abap` )
      ( module = `sap.m`              control = `sap.m.List`                       name = `ListCounter`                        class = `z2ui5_cl_api_app_441` path = `src/01/z2ui5_cl_api_app_441.clas.abap` )
      ( module = `sap.m`              control = `sap.m.List`                       name = `ListFooter`                         class = `z2ui5_cl_api_app_442` path = `src/01/z2ui5_cl_api_app_442.clas.abap` )
      ( module = `sap.m`              control = `sap.m.List`                       name = `ListGrowing`                        class = `z2ui5_cl_api_app_443` path = `src/01/z2ui5_cl_api_app_443.clas.abap` )
      ( module = `sap.m`              control = `sap.m.List`                       name = `ListNavType`                        class = `z2ui5_cl_api_app_444` path = `src/01/z2ui5_cl_api_app_444.clas.abap` )
      ( module = `sap.m`              control = `sap.m.List`                       name = `ListNoData`                         class = `z2ui5_cl_api_app_445` path = `src/01/z2ui5_cl_api_app_445.clas.abap` )
      ( module = `sap.m`              control = `sap.m.List`                       name = `ListSelection`                      class = `z2ui5_cl_api_app_446` path = `src/01/z2ui5_cl_api_app_446.clas.abap` )
      ( module = `sap.m`              control = `sap.m.MessageBox`                 name = `MessageBoxInitialFocus`             class = `z2ui5_cl_api_app_447` path = `src/01/z2ui5_cl_api_app_447.clas.abap` )
      ( module = `sap.m`              control = `sap.m.MessageToast`               name = `MessageToast`                       class = `z2ui5_cl_api_app_448` path = `src/01/z2ui5_cl_api_app_448.clas.abap` )
      ( module = `sap.m`              control = `sap.m.MessageView`                name = `MessageViewMessageManager`          class = `z2ui5_cl_api_app_449` path = `src/01/z2ui5_cl_api_app_449.clas.abap` )
      ( module = `sap.m`              control = `sap.m.MultiComboBox`              name = `MultiComboBoxDefaultFiltering`      class = `z2ui5_cl_api_app_451` path = `src/01/z2ui5_cl_api_app_451.clas.abap` )
      ( module = `sap.m`              control = `sap.m.MultiComboBox`              name = `MultiComboBoxGrouping`              class = `z2ui5_cl_api_app_452` path = `src/01/z2ui5_cl_api_app_452.clas.abap` )
      ( module = `sap.m`              control = `sap.m.MultiComboBox`              name = `MultiComboBoxTwoColumnsLayout`      class = `z2ui5_cl_api_app_453` path = `src/01/z2ui5_cl_api_app_453.clas.abap` )
      ( module = `sap.m`              control = `sap.m.MultiInput`                 name = `MultiInput`                         class = `z2ui5_cl_api_app_454` path = `src/01/z2ui5_cl_api_app_454.clas.abap` )
      ( module = `sap.m`              control = `sap.m.MultiInput`                 name = `MultiInputDatabinding`              class = `z2ui5_cl_api_app_456` path = `src/01/z2ui5_cl_api_app_456.clas.abap` )
      ( module = `sap.m`              control = `sap.m.MultiInput`                 name = `MultiInputGrouping`                 class = `z2ui5_cl_api_app_457` path = `src/01/z2ui5_cl_api_app_457.clas.abap` )
      ( module = `sap.m`              control = `sap.m.MultiInput`                 name = `MultiInputMaxTokens`                class = `z2ui5_cl_api_app_458` path = `src/01/z2ui5_cl_api_app_458.clas.abap` )
      ( module = `sap.m`              control = `sap.m.ObjectAttribute`            name = `ObjectHeaderResponsiveI`            class = `z2ui5_cl_api_app_459` path = `src/01/z2ui5_cl_api_app_459.clas.abap` )
      ( module = `sap.m`              control = `sap.m.ObjectHeader`               name = `ObjectHeader`                       class = `z2ui5_cl_api_app_460` path = `src/01/z2ui5_cl_api_app_460.clas.abap` )
      ( module = `sap.m`              control = `sap.m.ObjectHeader`               name = `ObjectHeaderCondensed`              class = `z2ui5_cl_api_app_461` path = `src/01/z2ui5_cl_api_app_461.clas.abap` )
      ( module = `sap.m`              control = `sap.m.ObjectHeader`               name = `ObjectHeaderImage`                  class = `z2ui5_cl_api_app_462` path = `src/01/z2ui5_cl_api_app_462.clas.abap` )
      ( module = `sap.m`              control = `sap.m.ObjectHeader`               name = `ObjectHeaderMarkers`                class = `z2ui5_cl_api_app_463` path = `src/01/z2ui5_cl_api_app_463.clas.abap` )
      ( module = `sap.m`              control = `sap.m.ObjectHeader`               name = `ObjectHeaderResponsiveII`           class = `z2ui5_cl_api_app_464` path = `src/01/z2ui5_cl_api_app_464.clas.abap` )
      ( module = `sap.m`              control = `sap.m.ObjectHeader`               name = `ObjectHeaderResponsiveV`            class = `z2ui5_cl_api_app_465` path = `src/01/z2ui5_cl_api_app_465.clas.abap` )
      ( module = `sap.m`              control = `sap.m.ObjectIdentifier`           name = `ObjectIdentifier`                   class = `z2ui5_cl_api_app_466` path = `src/01/z2ui5_cl_api_app_466.clas.abap` )
      ( module = `sap.m`              control = `sap.m.ObjectNumber`               name = `ObjectNumber`                       class = `z2ui5_cl_api_app_467` path = `src/01/z2ui5_cl_api_app_467.clas.abap` )
      ( module = `sap.m`              control = `sap.m.OverflowToolbar`            name = `ToolbarEnabled`                     class = `z2ui5_cl_api_app_468` path = `src/01/z2ui5_cl_api_app_468.clas.abap` )
      ( module = `sap.m`              control = `sap.m.Page`                       name = `PageListReportIconTabBar`           class = `z2ui5_cl_api_app_406` path = `src/01/z2ui5_cl_api_app_406.clas.abap` )
      ( module = `sap.m`              control = `sap.m.Page`                       name = `PageListReportToolbar`              class = `z2ui5_cl_api_app_407` path = `src/01/z2ui5_cl_api_app_407.clas.abap` )
      ( module = `sap.m`              control = `sap.m.Page`                       name = `PageStandardClasses`                class = `z2ui5_cl_api_app_470` path = `src/01/z2ui5_cl_api_app_470.clas.abap` )
      ( module = `sap.m`              control = `sap.m.Panel`                      name = `PanelExpanded`                      class = `z2ui5_cl_api_app_471` path = `src/01/z2ui5_cl_api_app_471.clas.abap` )
      ( module = `sap.m`              control = `sap.m.PDFViewer`                  name = `PDFViewerPopup`                     class = `z2ui5_cl_api_app_469` path = `src/01/z2ui5_cl_api_app_469.clas.abap` )
      ( module = `sap.m`              control = `sap.m.RangeSlider`                name = `RangeSlider`                        class = `z2ui5_cl_api_app_472` path = `src/01/z2ui5_cl_api_app_472.clas.abap` )
      ( module = `sap.m`              control = `sap.m.ScrollContainer`            name = `ScrollContainer`                    class = `z2ui5_cl_api_app_473` path = `src/01/z2ui5_cl_api_app_473.clas.abap` )
      ( module = `sap.m`              control = `sap.m.SegmentedButton`            name = `SegmentedButton`                    class = `z2ui5_cl_api_app_474` path = `src/01/z2ui5_cl_api_app_474.clas.abap` )
      ( module = `sap.m`              control = `sap.m.SelectList`                 name = `SelectList`                         class = `z2ui5_cl_api_app_475` path = `src/01/z2ui5_cl_api_app_475.clas.abap` )
      ( module = `sap.m`              control = `sap.m.SelectList`                 name = `SelectListWithIcons`                class = `z2ui5_cl_api_app_476` path = `src/01/z2ui5_cl_api_app_476.clas.abap` )
      ( module = `sap.m`              control = `sap.m.StandardListItem`           name = `StandardListItem`                   class = `z2ui5_cl_api_app_477` path = `src/01/z2ui5_cl_api_app_477.clas.abap` )
      ( module = `sap.m`              control = `sap.m.StandardListItem`           name = `StandardListItemDescription`        class = `z2ui5_cl_api_app_478` path = `src/01/z2ui5_cl_api_app_478.clas.abap` )
      ( module = `sap.m`              control = `sap.m.StandardListItem`           name = `StandardListItemIcon`               class = `z2ui5_cl_api_app_479` path = `src/01/z2ui5_cl_api_app_479.clas.abap` )
      ( module = `sap.m`              control = `sap.m.StandardListItem`           name = `StandardListItemTitle`              class = `z2ui5_cl_api_app_480` path = `src/01/z2ui5_cl_api_app_480.clas.abap` )
      ( module = `sap.m`              control = `sap.m.StepInput`                  name = `StepInput`                          class = `z2ui5_cl_api_app_481` path = `src/01/z2ui5_cl_api_app_481.clas.abap` )
      ( module = `sap.m`              control = `sap.m.Table`                      name = `TableAlternateRowColors`            class = `z2ui5_cl_api_app_482` path = `src/01/z2ui5_cl_api_app_482.clas.abap` )
      ( module = `sap.m`              control = `sap.m.Table`                      name = `TableContextualWidthStatic`         class = `z2ui5_cl_api_app_483` path = `src/01/z2ui5_cl_api_app_483.clas.abap` )
      ( module = `sap.m`              control = `sap.m.Text`                       name = `Text`                               class = `z2ui5_cl_api_app_408` path = `src/01/z2ui5_cl_api_app_408.clas.abap` )
      ( module = `sap.m`              control = `sap.m.TextArea`                   name = `TextArea`                           class = `z2ui5_cl_api_app_409` path = `src/01/z2ui5_cl_api_app_409.clas.abap` )
      ( module = `sap.m`              control = `sap.m.TextArea`                   name = `TextAreaValueUpdate`                class = `z2ui5_cl_api_app_484` path = `src/01/z2ui5_cl_api_app_484.clas.abap` )
      ( module = `sap.m`              control = `sap.m.Title`                      name = `Title`                              class = `z2ui5_cl_api_app_485` path = `src/01/z2ui5_cl_api_app_485.clas.abap` )
      ( module = `sap.m`              control = `sap.m.Toolbar`                    name = `ToolbarShrinkable`                  class = `z2ui5_cl_api_app_486` path = `src/01/z2ui5_cl_api_app_486.clas.abap` )
      ( module = `sap.m`              control = `sap.m.Tree`                       name = `Tree`                               class = `z2ui5_cl_api_app_487` path = `src/01/z2ui5_cl_api_app_487.clas.abap` )
      ( module = `sap.m`              control = `sap.ui.core.ContainerPadding`     name = `ContainerNoPadding`                 class = `z2ui5_cl_api_app_488` path = `src/02/z2ui5_cl_api_app_488.clas.abap` )
      ( module = `sap.m`              control = `sap.ui.core.ContainerPadding`     name = `ContainerPaddingAndMargin`          class = `z2ui5_cl_api_app_489` path = `src/02/z2ui5_cl_api_app_489.clas.abap` )
      ( module = `sap.m`              control = `sap.ui.core.ContainerPadding`     name = `ContainerResponsivePadding`         class = `z2ui5_cl_api_app_490` path = `src/02/z2ui5_cl_api_app_490.clas.abap` )
      ( module = `sap.m`              control = `sap.ui.core.StandardMargins`      name = `StandardMarginsAll`                 class = `z2ui5_cl_api_app_491` path = `src/02/z2ui5_cl_api_app_491.clas.abap` )
      ( module = `sap.m`              control = `sap.ui.core.StandardMargins`      name = `StandardMarginsCollapse`            class = `z2ui5_cl_api_app_492` path = `src/02/z2ui5_cl_api_app_492.clas.abap` )
      ( module = `sap.m`              control = `sap.ui.core.StandardMargins`      name = `StandardMarginsEnforceWidthAuto`    class = `z2ui5_cl_api_app_493` path = `src/02/z2ui5_cl_api_app_493.clas.abap` )
      ( module = `sap.m`              control = `sap.ui.core.StandardMargins`      name = `StandardMarginsResponsive`          class = `z2ui5_cl_api_app_494` path = `src/02/z2ui5_cl_api_app_494.clas.abap` )
      ( module = `sap.m`              control = `sap.ui.core.StandardMargins`      name = `StandardMarginsSingleSided`         class = `z2ui5_cl_api_app_495` path = `src/02/z2ui5_cl_api_app_495.clas.abap` )
      ( module = `sap.m`              control = `sap.ui.core.StandardMargins`      name = `StandardMarginsTwoSided`            class = `z2ui5_cl_api_app_496` path = `src/02/z2ui5_cl_api_app_496.clas.abap` )
      ( module = `sap.m`              control = `sap.ui.core.StandardMargins`      name = `StandardNoMargins`                  class = `z2ui5_cl_api_app_497` path = `src/02/z2ui5_cl_api_app_497.clas.abap` )
      ( module = `sap.tnt`            control = `sap.tnt.NavigationList`           name = `NavigationList`                     class = `z2ui5_cl_api_app_498` path = `src/05/z2ui5_cl_api_app_498.clas.abap` )
      ( module = `sap.tnt`            control = `sap.tnt.SideNavigation`           name = `SideNavigation`                     class = `z2ui5_cl_api_app_499` path = `src/05/z2ui5_cl_api_app_499.clas.abap` )
      ( module = `sap.tnt`            control = `sap.tnt.ToolHeader`               name = `ToolHeaderIconTabHeader`            class = `z2ui5_cl_api_app_500` path = `src/05/z2ui5_cl_api_app_500.clas.abap` )
      ( module = `sap.ui.core`        control = `sap.ui.core.Icon`                 name = `Icon`                               class = `z2ui5_cl_api_app_501` path = `src/02/z2ui5_cl_api_app_501.clas.abap` )
      ( module = `sap.ui.core`        control = `sap.ui.core.theming`              name = `BasicThemeParameters`               class = `z2ui5_cl_api_app_502` path = `src/02/z2ui5_cl_api_app_502.clas.abap` )
      ( module = `sap.ui.core`        control = `sap.ui.model.type.Currency`       name = `TypeCurrency`                       class = `z2ui5_cl_api_app_503` path = `src/02/z2ui5_cl_api_app_503.clas.abap` )
      ( module = `sap.ui.core`        control = `sap.ui.model.type.Date`           name = `TypeDateAsDate`                     class = `z2ui5_cl_api_app_504` path = `src/02/z2ui5_cl_api_app_504.clas.abap` )
      ( module = `sap.ui.core`        control = `sap.ui.model.type.Date`           name = `TypeDateAsString`                   class = `z2ui5_cl_api_app_505` path = `src/02/z2ui5_cl_api_app_505.clas.abap` )
      ( module = `sap.ui.core`        control = `sap.ui.model.type.FileSize`       name = `TypeFileSize`                       class = `z2ui5_cl_api_app_506` path = `src/02/z2ui5_cl_api_app_506.clas.abap` )
      ( module = `sap.ui.core`        control = `sap.ui.model.type.Float`          name = `TypeFloat`                          class = `z2ui5_cl_api_app_507` path = `src/02/z2ui5_cl_api_app_507.clas.abap` )
      ( module = `sap.ui.core`        control = `sap.ui.model.type.Integer`        name = `TypeInteger`                        class = `z2ui5_cl_api_app_508` path = `src/02/z2ui5_cl_api_app_508.clas.abap` )
      ( module = `sap.ui.core`        control = `sap.ui.model.type.Time`           name = `TypeTimeAsTime`                     class = `z2ui5_cl_api_app_509` path = `src/02/z2ui5_cl_api_app_509.clas.abap` )
      ( module = `sap.ui.integration` control = `sap.ui.integration.widgets.Card`  name = `CardExplorer`                       class = `z2ui5_cl_api_app_510` path = `src/02/z2ui5_cl_api_app_510.clas.abap` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.BlockLayout`        name = `BlockLayoutCustomBackground`        class = `z2ui5_cl_api_app_511` path = `src/02/z2ui5_cl_api_app_511.clas.abap` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.BlockLayout`        name = `BlockLayoutDefault`                 class = `z2ui5_cl_api_app_512` path = `src/02/z2ui5_cl_api_app_512.clas.abap` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.BlockLayout`        name = `BlockLayoutLinkTitle`               class = `z2ui5_cl_api_app_513` path = `src/02/z2ui5_cl_api_app_513.clas.abap` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.cssgrid.CSSGrid`    name = `CSSGrid`                            class = `z2ui5_cl_api_app_521` path = `src/02/z2ui5_cl_api_app_521.clas.abap` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.cssgrid.CSSGrid`    name = `NestedGrids`                        class = `z2ui5_cl_api_app_522` path = `src/02/z2ui5_cl_api_app_522.clas.abap` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.FixFlex`            name = `FixFlexFixedSize`                   class = `z2ui5_cl_api_app_410` path = `src/02/z2ui5_cl_api_app_410.clas.abap` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.FixFlex`            name = `FixFlexHorizontal`                  class = `z2ui5_cl_api_app_514` path = `src/02/z2ui5_cl_api_app_514.clas.abap` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.FixFlex`            name = `FixFlexMinFlexSize`                 class = `z2ui5_cl_api_app_515` path = `src/02/z2ui5_cl_api_app_515.clas.abap` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.FixFlex`            name = `FixFlexVertical`                    class = `z2ui5_cl_api_app_516` path = `src/02/z2ui5_cl_api_app_516.clas.abap` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.Form`          name = `FormToolbar`                        class = `z2ui5_cl_api_app_523` path = `src/02/z2ui5_cl_api_app_523.clas.abap` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.form.SimpleForm`    name = `SimpleFormToolbar`                  class = `z2ui5_cl_api_app_524` path = `src/02/z2ui5_cl_api_app_524.clas.abap` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.Grid`               name = `GridInfo`                           class = `z2ui5_cl_api_app_517` path = `src/02/z2ui5_cl_api_app_517.clas.abap` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.Grid`               name = `GridXL`                             class = `z2ui5_cl_api_app_518` path = `src/02/z2ui5_cl_api_app_518.clas.abap` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.HorizontalLayout`   name = `HorizontalLayout`                   class = `z2ui5_cl_api_app_519` path = `src/02/z2ui5_cl_api_app_519.clas.abap` )
      ( module = `sap.ui.layout`      control = `sap.ui.layout.VerticalLayout`     name = `VerticalLayout`                     class = `z2ui5_cl_api_app_520` path = `src/02/z2ui5_cl_api_app_520.clas.abap` )
      ( module = `sap.ui.table`       control = `sap.ui.table.Table`               name = `MultiHeader`                        class = `z2ui5_cl_api_app_525` path = `src/02/z2ui5_cl_api_app_525.clas.abap` )
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Currency`          name = `Currency`                           class = `z2ui5_cl_api_app_526` path = `src/02/z2ui5_cl_api_app_526.clas.abap` )
      ( module = `sap.ui.unified`     control = `sap.ui.unified.Currency`          name = `CurrencyInTable`                    class = `z2ui5_cl_api_app_527` path = `src/02/z2ui5_cl_api_app_527.clas.abap` )
      ( module = `sap.uxap`           control = `sap.m.GenericTag`                 name = `ObjectPageHeaderActionButtons`      class = `z2ui5_cl_api_app_411` path = `src/01/z2ui5_cl_api_app_411.clas.abap` )
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageHeader`        name = `KPIObjectPageHeader`                class = `z2ui5_cl_api_app_529` path = `src/03/z2ui5_cl_api_app_529.clas.abap` )
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageHeader`        name = `ProfileObjectPageHeader`            class = `z2ui5_cl_api_app_530` path = `src/03/z2ui5_cl_api_app_530.clas.abap` )
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageHeaderContent` name = `HeaderContent`                      class = `z2ui5_cl_api_app_531` path = `src/03/z2ui5_cl_api_app_531.clas.abap` )
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageHeaderContent` name = `ObjectPageHeaderContentPriorities`  class = `z2ui5_cl_api_app_412` path = `src/03/z2ui5_cl_api_app_412.clas.abap` )
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`        name = `AnchorBarNoPopover`                 class = `z2ui5_cl_api_app_413` path = `src/03/z2ui5_cl_api_app_413.clas.abap` )
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`        name = `AnchorBarWithNumbers`               class = `z2ui5_cl_api_app_532` path = `src/03/z2ui5_cl_api_app_532.clas.abap` )
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`        name = `ObjectPageHeaderExpanded`           class = `z2ui5_cl_api_app_533` path = `src/03/z2ui5_cl_api_app_533.clas.abap` )
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`        name = `ObjectPageLazyLoadingWithoutBlocks` class = `z2ui5_cl_api_app_534` path = `src/03/z2ui5_cl_api_app_534.clas.abap` )
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`        name = `ObjectPageOnJSONWithLazyLoading`    class = `z2ui5_cl_api_app_535` path = `src/03/z2ui5_cl_api_app_535.clas.abap` )
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`        name = `ObjectPageSelectedSection`          class = `z2ui5_cl_api_app_536` path = `src/03/z2ui5_cl_api_app_536.clas.abap` )
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageLayout`        name = `ObjectPageTabNavigationMode`        class = `z2ui5_cl_api_app_537` path = `src/03/z2ui5_cl_api_app_537.clas.abap` )
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageSection`       name = `ObjectPageSection`                  class = `z2ui5_cl_api_app_414` path = `src/03/z2ui5_cl_api_app_414.clas.abap` )
      ( module = `sap.uxap`           control = `sap.uxap.ObjectPageSubSection`    name = `ObjectPageSubSectionWithActions`    class = `z2ui5_cl_api_app_415` path = `src/03/z2ui5_cl_api_app_415.clas.abap` ) ).

  ENDMETHOD.

ENDCLASS.
