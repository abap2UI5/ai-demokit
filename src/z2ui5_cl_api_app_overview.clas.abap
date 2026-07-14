"! Generated overview app - lists every abap2UI5 api sample app grouped by UI5
"! control and starts it in the system. Do not edit by hand - regenerate with
"! scripts/generate-overview.mjs
CLASS z2ui5_cl_api_app_overview DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_app,
        control TYPE string,
        lib     TYPE string,
        name    TYPE string,
        app     TYPE string,
      END OF ty_s_app.
    TYPES ty_t_app TYPE STANDARD TABLE OF ty_s_app WITH DEFAULT KEY.

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

    DATA(t_catalog) = get_catalog( ).

    " base url to launch an app in a new browser tab
    DATA(start) = |{ client->get( )-s_config-origin }{ client->get( )-s_config-pathname }?app_start=|.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - api`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(prev_control) = ``.
    LOOP AT t_catalog INTO DATA(app).

      " every row starts with its control; a new control opens a new block,
      " set off from the previous one by a blank line (top margin)
      DATA(css) = COND string( WHEN prev_control IS NOT INITIAL AND app-control <> prev_control
                               THEN `sapUiTinyMarginBegin sapUiMediumMarginTop`
                               ELSE `sapUiTinyMarginBegin` ).
      prev_control = app-control.

      DATA(url) = |https://sapui5.hana.ondemand.com/sdk/#/entity/{ app-control }/sample/{ app-lib }.sample.{ app-name }|.
      page->hbox( alignitems = `Center`
                  class      = css
          )->text(
              text  = app-control
              class = `sapUiTinyMarginEnd`
          )->link(
              text  = app-name
              press = client->_event_client( val   = client->cs_event-open_new_tab
                                             t_arg = VALUE #( ( |{ start }{ to_upper( app-app ) }| ) ) )
          )->link(
              text   = `->`
              href   = url
              target = `_blank`
              class  = `sapUiSmallMarginBegin` ).

    ENDLOOP.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD get_catalog.

    result = VALUE #(
      ( control = `sap.f.GridList`                   lib = `sap.f`              name = `GridListBasic`                      app = `z2ui5_cl_api_app_416` )
      ( control = `sap.f.GridList`                   lib = `sap.f`              name = `GridListBoxContainer`               app = `z2ui5_cl_api_app_417` )
      ( control = `sap.f.GridList`                   lib = `sap.f`              name = `GridListBoxContainerGrouping`       app = `z2ui5_cl_api_app_418` )
      ( control = `sap.f.ShellBar`                   lib = `sap.f`              name = `ShellBar`                           app = `z2ui5_cl_api_app_419` )
      ( control = `sap.m.Carousel`                   lib = `sap.m`              name = `CarouselWithControls`               app = `z2ui5_cl_api_app_420` )
      ( control = `sap.m.CheckBox`                   lib = `sap.m`              name = `CheckBoxTriState`                   app = `z2ui5_cl_api_app_421` )
      ( control = `sap.m.ColorPalette`               lib = `sap.m`              name = `ColorPalette`                       app = `z2ui5_cl_api_app_422` )
      ( control = `sap.m.ComboBox`                   lib = `sap.m`              name = `ComboBox`                           app = `z2ui5_cl_api_app_423` )
      ( control = `sap.m.ComboBox`                   lib = `sap.m`              name = `ComboBox2Columns`                   app = `z2ui5_cl_api_app_424` )
      ( control = `sap.m.ComboBox`                   lib = `sap.m`              name = `ComboBoxDefaultFiltering`           app = `z2ui5_cl_api_app_425` )
      ( control = `sap.m.ComboBox`                   lib = `sap.m`              name = `ComboBoxGrouping`                   app = `z2ui5_cl_api_app_428` )
      ( control = `sap.m.CustomTreeItem`             lib = `sap.m`              name = `CustomTreeItem`                     app = `z2ui5_cl_api_app_429` )
      ( control = `sap.m.DisplayListItem`            lib = `sap.m`              name = `DisplayListItem`                    app = `z2ui5_cl_api_app_430` )
      ( control = `sap.m.FacetFilter`                lib = `sap.m`              name = `FacetFilterLight`                   app = `z2ui5_cl_api_app_401` )
      ( control = `sap.m.FlexBox`                    lib = `sap.m`              name = `FlexBoxCols`                        app = `z2ui5_cl_api_app_402` )
      ( control = `sap.m.FlexBox`                    lib = `sap.m`              name = `FlexBoxNav`                         app = `z2ui5_cl_api_app_403` )
      ( control = `sap.m.FlexBox`                    lib = `sap.m`              name = `FlexBoxNested`                      app = `z2ui5_cl_api_app_404` )
      ( control = `sap.m.FlexBox`                    lib = `sap.m`              name = `FlexBoxSizeAdjustments`             app = `z2ui5_cl_api_app_405` )
      ( control = `sap.m.GenericTag`                 lib = `sap.uxap`           name = `ObjectPageHeaderActionButtons`      app = `z2ui5_cl_api_app_411` )
      ( control = `sap.m.GenericTile`                lib = `sap.m`              name = `GenericTileAsKPITile`               app = `z2ui5_cl_api_app_431` )
      ( control = `sap.m.IconTabBar`                 lib = `sap.m`              name = `IconTabBarOverflowSelectList`       app = `z2ui5_cl_api_app_432` )
      ( control = `sap.m.IconTabBar`                 lib = `sap.m`              name = `IconTabBarStretchContent`           app = `z2ui5_cl_api_app_433` )
      ( control = `sap.m.Image`                      lib = `sap.m`              name = `ImageModeBackground`                app = `z2ui5_cl_api_app_434` )
      ( control = `sap.m.Input`                      lib = `sap.m`              name = `InputAssistedTabularSuggestions`    app = `z2ui5_cl_api_app_435` )
      ( control = `sap.m.Input`                      lib = `sap.m`              name = `InputAssistedTwoValues`             app = `z2ui5_cl_api_app_436` )
      ( control = `sap.m.Input`                      lib = `sap.m`              name = `InputGrouping`                      app = `z2ui5_cl_api_app_437` )
      ( control = `sap.m.Input`                      lib = `sap.m`              name = `InputSuggestionsCustomFilter`       app = `z2ui5_cl_api_app_438` )
      ( control = `sap.m.Input`                      lib = `sap.m`              name = `InputValueState`                    app = `z2ui5_cl_api_app_439` )
      ( control = `sap.m.Link`                       lib = `sap.m`              name = `LinkEmphasized`                     app = `z2ui5_cl_api_app_440` )
      ( control = `sap.m.List`                       lib = `sap.m`              name = `ListCounter`                        app = `z2ui5_cl_api_app_441` )
      ( control = `sap.m.List`                       lib = `sap.m`              name = `ListFooter`                         app = `z2ui5_cl_api_app_442` )
      ( control = `sap.m.List`                       lib = `sap.m`              name = `ListGrowing`                        app = `z2ui5_cl_api_app_443` )
      ( control = `sap.m.List`                       lib = `sap.m`              name = `ListNavType`                        app = `z2ui5_cl_api_app_444` )
      ( control = `sap.m.List`                       lib = `sap.m`              name = `ListNoData`                         app = `z2ui5_cl_api_app_445` )
      ( control = `sap.m.List`                       lib = `sap.m`              name = `ListSelection`                      app = `z2ui5_cl_api_app_446` )
      ( control = `sap.m.MessageBox`                 lib = `sap.m`              name = `MessageBoxInitialFocus`             app = `z2ui5_cl_api_app_447` )
      ( control = `sap.m.MessageToast`               lib = `sap.m`              name = `MessageToast`                       app = `z2ui5_cl_api_app_448` )
      ( control = `sap.m.MessageView`                lib = `sap.m`              name = `MessageViewMessageManager`          app = `z2ui5_cl_api_app_449` )
      ( control = `sap.m.MultiComboBox`              lib = `sap.m`              name = `MultiComboBoxDefaultFiltering`      app = `z2ui5_cl_api_app_451` )
      ( control = `sap.m.MultiComboBox`              lib = `sap.m`              name = `MultiComboBoxGrouping`              app = `z2ui5_cl_api_app_452` )
      ( control = `sap.m.MultiComboBox`              lib = `sap.m`              name = `MultiComboBoxTwoColumnsLayout`      app = `z2ui5_cl_api_app_453` )
      ( control = `sap.m.MultiInput`                 lib = `sap.m`              name = `MultiInput`                         app = `z2ui5_cl_api_app_454` )
      ( control = `sap.m.MultiInput`                 lib = `sap.m`              name = `MultiInputDatabinding`              app = `z2ui5_cl_api_app_456` )
      ( control = `sap.m.MultiInput`                 lib = `sap.m`              name = `MultiInputGrouping`                 app = `z2ui5_cl_api_app_457` )
      ( control = `sap.m.MultiInput`                 lib = `sap.m`              name = `MultiInputMaxTokens`                app = `z2ui5_cl_api_app_458` )
      ( control = `sap.m.ObjectAttribute`            lib = `sap.m`              name = `ObjectHeaderResponsiveI`            app = `z2ui5_cl_api_app_459` )
      ( control = `sap.m.ObjectHeader`               lib = `sap.m`              name = `ObjectHeader`                       app = `z2ui5_cl_api_app_460` )
      ( control = `sap.m.ObjectHeader`               lib = `sap.m`              name = `ObjectHeaderCondensed`              app = `z2ui5_cl_api_app_461` )
      ( control = `sap.m.ObjectHeader`               lib = `sap.m`              name = `ObjectHeaderImage`                  app = `z2ui5_cl_api_app_462` )
      ( control = `sap.m.ObjectHeader`               lib = `sap.m`              name = `ObjectHeaderMarkers`                app = `z2ui5_cl_api_app_463` )
      ( control = `sap.m.ObjectHeader`               lib = `sap.m`              name = `ObjectHeaderResponsiveII`           app = `z2ui5_cl_api_app_464` )
      ( control = `sap.m.ObjectHeader`               lib = `sap.m`              name = `ObjectHeaderResponsiveV`            app = `z2ui5_cl_api_app_465` )
      ( control = `sap.m.ObjectIdentifier`           lib = `sap.m`              name = `ObjectIdentifier`                   app = `z2ui5_cl_api_app_466` )
      ( control = `sap.m.ObjectNumber`               lib = `sap.m`              name = `ObjectNumber`                       app = `z2ui5_cl_api_app_467` )
      ( control = `sap.m.OverflowToolbar`            lib = `sap.m`              name = `ToolbarEnabled`                     app = `z2ui5_cl_api_app_468` )
      ( control = `sap.m.Page`                       lib = `sap.m`              name = `PageListReportIconTabBar`           app = `z2ui5_cl_api_app_406` )
      ( control = `sap.m.Page`                       lib = `sap.m`              name = `PageListReportToolbar`              app = `z2ui5_cl_api_app_407` )
      ( control = `sap.m.Page`                       lib = `sap.m`              name = `PageStandardClasses`                app = `z2ui5_cl_api_app_470` )
      ( control = `sap.m.Panel`                      lib = `sap.m`              name = `PanelExpanded`                      app = `z2ui5_cl_api_app_471` )
      ( control = `sap.m.PDFViewer`                  lib = `sap.m`              name = `PDFViewerPopup`                     app = `z2ui5_cl_api_app_469` )
      ( control = `sap.m.RangeSlider`                lib = `sap.m`              name = `RangeSlider`                        app = `z2ui5_cl_api_app_472` )
      ( control = `sap.m.ScrollContainer`            lib = `sap.m`              name = `ScrollContainer`                    app = `z2ui5_cl_api_app_473` )
      ( control = `sap.m.SegmentedButton`            lib = `sap.m`              name = `SegmentedButton`                    app = `z2ui5_cl_api_app_474` )
      ( control = `sap.m.SelectList`                 lib = `sap.m`              name = `SelectList`                         app = `z2ui5_cl_api_app_475` )
      ( control = `sap.m.SelectList`                 lib = `sap.m`              name = `SelectListWithIcons`                app = `z2ui5_cl_api_app_476` )
      ( control = `sap.m.StandardListItem`           lib = `sap.m`              name = `StandardListItem`                   app = `z2ui5_cl_api_app_477` )
      ( control = `sap.m.StandardListItem`           lib = `sap.m`              name = `StandardListItemDescription`        app = `z2ui5_cl_api_app_478` )
      ( control = `sap.m.StandardListItem`           lib = `sap.m`              name = `StandardListItemIcon`               app = `z2ui5_cl_api_app_479` )
      ( control = `sap.m.StandardListItem`           lib = `sap.m`              name = `StandardListItemTitle`              app = `z2ui5_cl_api_app_480` )
      ( control = `sap.m.StepInput`                  lib = `sap.m`              name = `StepInput`                          app = `z2ui5_cl_api_app_481` )
      ( control = `sap.m.Table`                      lib = `sap.m`              name = `TableAlternateRowColors`            app = `z2ui5_cl_api_app_482` )
      ( control = `sap.m.Table`                      lib = `sap.m`              name = `TableContextualWidthStatic`         app = `z2ui5_cl_api_app_483` )
      ( control = `sap.m.Text`                       lib = `sap.m`              name = `Text`                               app = `z2ui5_cl_api_app_408` )
      ( control = `sap.m.TextArea`                   lib = `sap.m`              name = `TextArea`                           app = `z2ui5_cl_api_app_409` )
      ( control = `sap.m.TextArea`                   lib = `sap.m`              name = `TextAreaValueUpdate`                app = `z2ui5_cl_api_app_484` )
      ( control = `sap.m.Title`                      lib = `sap.m`              name = `Title`                              app = `z2ui5_cl_api_app_485` )
      ( control = `sap.m.Toolbar`                    lib = `sap.m`              name = `ToolbarShrinkable`                  app = `z2ui5_cl_api_app_486` )
      ( control = `sap.m.Tree`                       lib = `sap.m`              name = `Tree`                               app = `z2ui5_cl_api_app_487` )
      ( control = `sap.tnt.NavigationList`           lib = `sap.tnt`            name = `NavigationList`                     app = `z2ui5_cl_api_app_498` )
      ( control = `sap.tnt.SideNavigation`           lib = `sap.tnt`            name = `SideNavigation`                     app = `z2ui5_cl_api_app_499` )
      ( control = `sap.tnt.ToolHeader`               lib = `sap.tnt`            name = `ToolHeaderIconTabHeader`            app = `z2ui5_cl_api_app_500` )
      ( control = `sap.ui.core.ContainerPadding`     lib = `sap.m`              name = `ContainerNoPadding`                 app = `z2ui5_cl_api_app_488` )
      ( control = `sap.ui.core.ContainerPadding`     lib = `sap.m`              name = `ContainerPaddingAndMargin`          app = `z2ui5_cl_api_app_489` )
      ( control = `sap.ui.core.ContainerPadding`     lib = `sap.m`              name = `ContainerResponsivePadding`         app = `z2ui5_cl_api_app_490` )
      ( control = `sap.ui.core.Icon`                 lib = `sap.ui.core`        name = `Icon`                               app = `z2ui5_cl_api_app_501` )
      ( control = `sap.ui.core.StandardMargins`      lib = `sap.m`              name = `StandardMarginsAll`                 app = `z2ui5_cl_api_app_491` )
      ( control = `sap.ui.core.StandardMargins`      lib = `sap.m`              name = `StandardMarginsCollapse`            app = `z2ui5_cl_api_app_492` )
      ( control = `sap.ui.core.StandardMargins`      lib = `sap.m`              name = `StandardMarginsEnforceWidthAuto`    app = `z2ui5_cl_api_app_493` )
      ( control = `sap.ui.core.StandardMargins`      lib = `sap.m`              name = `StandardMarginsResponsive`          app = `z2ui5_cl_api_app_494` )
      ( control = `sap.ui.core.StandardMargins`      lib = `sap.m`              name = `StandardMarginsSingleSided`         app = `z2ui5_cl_api_app_495` )
      ( control = `sap.ui.core.StandardMargins`      lib = `sap.m`              name = `StandardMarginsTwoSided`            app = `z2ui5_cl_api_app_496` )
      ( control = `sap.ui.core.StandardMargins`      lib = `sap.m`              name = `StandardNoMargins`                  app = `z2ui5_cl_api_app_497` )
      ( control = `sap.ui.core.theming`              lib = `sap.ui.core`        name = `BasicThemeParameters`               app = `z2ui5_cl_api_app_502` )
      ( control = `sap.ui.integration.widgets.Card`  lib = `sap.ui.integration` name = `CardExplorer`                       app = `z2ui5_cl_api_app_510` )
      ( control = `sap.ui.layout.BlockLayout`        lib = `sap.ui.layout`      name = `BlockLayoutCustomBackground`        app = `z2ui5_cl_api_app_511` )
      ( control = `sap.ui.layout.BlockLayout`        lib = `sap.ui.layout`      name = `BlockLayoutDefault`                 app = `z2ui5_cl_api_app_512` )
      ( control = `sap.ui.layout.BlockLayout`        lib = `sap.ui.layout`      name = `BlockLayoutLinkTitle`               app = `z2ui5_cl_api_app_513` )
      ( control = `sap.ui.layout.cssgrid.CSSGrid`    lib = `sap.ui.layout`      name = `CSSGrid`                            app = `z2ui5_cl_api_app_521` )
      ( control = `sap.ui.layout.cssgrid.CSSGrid`    lib = `sap.ui.layout`      name = `NestedGrids`                        app = `z2ui5_cl_api_app_522` )
      ( control = `sap.ui.layout.FixFlex`            lib = `sap.ui.layout`      name = `FixFlexFixedSize`                   app = `z2ui5_cl_api_app_410` )
      ( control = `sap.ui.layout.FixFlex`            lib = `sap.ui.layout`      name = `FixFlexHorizontal`                  app = `z2ui5_cl_api_app_514` )
      ( control = `sap.ui.layout.FixFlex`            lib = `sap.ui.layout`      name = `FixFlexMinFlexSize`                 app = `z2ui5_cl_api_app_515` )
      ( control = `sap.ui.layout.FixFlex`            lib = `sap.ui.layout`      name = `FixFlexVertical`                    app = `z2ui5_cl_api_app_516` )
      ( control = `sap.ui.layout.form.Form`          lib = `sap.ui.layout`      name = `FormToolbar`                        app = `z2ui5_cl_api_app_523` )
      ( control = `sap.ui.layout.form.SimpleForm`    lib = `sap.ui.layout`      name = `SimpleFormToolbar`                  app = `z2ui5_cl_api_app_524` )
      ( control = `sap.ui.layout.Grid`               lib = `sap.ui.layout`      name = `GridInfo`                           app = `z2ui5_cl_api_app_517` )
      ( control = `sap.ui.layout.Grid`               lib = `sap.ui.layout`      name = `GridXL`                             app = `z2ui5_cl_api_app_518` )
      ( control = `sap.ui.layout.HorizontalLayout`   lib = `sap.ui.layout`      name = `HorizontalLayout`                   app = `z2ui5_cl_api_app_519` )
      ( control = `sap.ui.layout.VerticalLayout`     lib = `sap.ui.layout`      name = `VerticalLayout`                     app = `z2ui5_cl_api_app_520` )
      ( control = `sap.ui.model.type.Currency`       lib = `sap.ui.core`        name = `TypeCurrency`                       app = `z2ui5_cl_api_app_503` )
      ( control = `sap.ui.model.type.Date`           lib = `sap.ui.core`        name = `TypeDateAsDate`                     app = `z2ui5_cl_api_app_504` )
      ( control = `sap.ui.model.type.Date`           lib = `sap.ui.core`        name = `TypeDateAsString`                   app = `z2ui5_cl_api_app_505` )
      ( control = `sap.ui.model.type.FileSize`       lib = `sap.ui.core`        name = `TypeFileSize`                       app = `z2ui5_cl_api_app_506` )
      ( control = `sap.ui.model.type.Float`          lib = `sap.ui.core`        name = `TypeFloat`                          app = `z2ui5_cl_api_app_507` )
      ( control = `sap.ui.model.type.Integer`        lib = `sap.ui.core`        name = `TypeInteger`                        app = `z2ui5_cl_api_app_508` )
      ( control = `sap.ui.model.type.Time`           lib = `sap.ui.core`        name = `TypeTimeAsTime`                     app = `z2ui5_cl_api_app_509` )
      ( control = `sap.ui.table.Table`               lib = `sap.ui.table`       name = `MultiHeader`                        app = `z2ui5_cl_api_app_525` )
      ( control = `sap.ui.unified.Currency`          lib = `sap.ui.unified`     name = `Currency`                           app = `z2ui5_cl_api_app_526` )
      ( control = `sap.ui.unified.Currency`          lib = `sap.ui.unified`     name = `CurrencyInTable`                    app = `z2ui5_cl_api_app_527` )
      ( control = `sap.uxap.ObjectPageHeader`        lib = `sap.uxap`           name = `KPIObjectPageHeader`                app = `z2ui5_cl_api_app_529` )
      ( control = `sap.uxap.ObjectPageHeader`        lib = `sap.uxap`           name = `ProfileObjectPageHeader`            app = `z2ui5_cl_api_app_530` )
      ( control = `sap.uxap.ObjectPageHeaderContent` lib = `sap.uxap`           name = `HeaderContent`                      app = `z2ui5_cl_api_app_531` )
      ( control = `sap.uxap.ObjectPageHeaderContent` lib = `sap.uxap`           name = `ObjectPageHeaderContentPriorities`  app = `z2ui5_cl_api_app_412` )
      ( control = `sap.uxap.ObjectPageLayout`        lib = `sap.uxap`           name = `AnchorBarNoPopover`                 app = `z2ui5_cl_api_app_413` )
      ( control = `sap.uxap.ObjectPageLayout`        lib = `sap.uxap`           name = `AnchorBarWithNumbers`               app = `z2ui5_cl_api_app_532` )
      ( control = `sap.uxap.ObjectPageLayout`        lib = `sap.uxap`           name = `ObjectPageHeaderExpanded`           app = `z2ui5_cl_api_app_533` )
      ( control = `sap.uxap.ObjectPageLayout`        lib = `sap.uxap`           name = `ObjectPageLazyLoadingWithoutBlocks` app = `z2ui5_cl_api_app_534` )
      ( control = `sap.uxap.ObjectPageLayout`        lib = `sap.uxap`           name = `ObjectPageOnJSONWithLazyLoading`    app = `z2ui5_cl_api_app_535` )
      ( control = `sap.uxap.ObjectPageLayout`        lib = `sap.uxap`           name = `ObjectPageSelectedSection`          app = `z2ui5_cl_api_app_536` )
      ( control = `sap.uxap.ObjectPageLayout`        lib = `sap.uxap`           name = `ObjectPageTabNavigationMode`        app = `z2ui5_cl_api_app_537` )
      ( control = `sap.uxap.ObjectPageSection`       lib = `sap.uxap`           name = `ObjectPageSection`                  app = `z2ui5_cl_api_app_414` )
      ( control = `sap.uxap.ObjectPageSubSection`    lib = `sap.uxap`           name = `ObjectPageSubSectionWithActions`    app = `z2ui5_cl_api_app_415` ) ).

  ENDMETHOD.

ENDCLASS.
