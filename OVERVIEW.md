# abap2UI5 — app overview

Same as the [coverage](api.md) report, with a **System** column to launch each
ported app directly in the abap2UI5 system.

Every official UI5 demo kit sample per library, marked ✅ ported / ❌ missing.
Overall **132 / 720** (18.3 %).

## Coverage per module

| Module | Samples | Ported | Coverage | |
|--------|--------:|-------:|---------:|---|
| `sap.uxap` | 47 | 14 | 29.8 % | ███░░░░░░░ |
| `sap.ui.integration` | 4 | 1 | 25.0 % | ███░░░░░░░ |
| `sap.ui.layout` | 62 | 15 | 24.2 % | ██░░░░░░░░ |
| `sap.ui.core` | 48 | 9 | 18.8 % | ██░░░░░░░░ |
| `sap.m` | 446 | 83 | 18.6 % | ██░░░░░░░░ |
| `sap.tnt` | 17 | 3 | 17.6 % | ██░░░░░░░░ |
| `sap.f` | 42 | 4 | 9.5 % | █░░░░░░░░░ |
| `sap.ui.unified` | 21 | 2 | 9.5 % | █░░░░░░░░░ |
| `sap.ui.table` | 18 | 1 | 5.6 % | █░░░░░░░░░ |
| `sap.ui.codeeditor` | 2 | 0 | 0.0 % | ░░░░░░░░░░ |
| `sap.ui.mdc` | 13 | 0 | 0.0 % | ░░░░░░░░░░ |
| **Total** | **720** | **132** | **18.3 %** | ██░░░░░░░░ |

## Samples per module

All links are external: **Javascript** → the collected UI5 template
(`ui5/` folder), **ABAP** → the generated class, **Link** → the live
demo kit sample app, **System** → starts the app in the abap2UI5 system.

### `sap.uxap` — 14/47 (29.8 %)

| | Javascript | ABAP | Link | System |
|---|-----------|------|------|--------|
| ❌ | `AlternativeProfileObjectPageHeader` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageHeader/sample/sap.uxap.sample.AlternativeProfileObjectPageHeader) | — |
| ❌ | `AnchorBar` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.AnchorBar) | — |
| ✅ | [`AnchorBarNoPopover`](https://github.com/abap2UI5/api/tree/main/ui5/sap.uxap/z2ui5_cl_api_app_413) | [`z2ui5_cl_api_app_413`](https://github.com/abap2UI5/api/blob/main/src/03/z2ui5_cl_api_app_413.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.AnchorBarNoPopover) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_413) |
| ✅ | [`AnchorBarWithNumbers`](https://github.com/abap2UI5/api/tree/main/ui5/sap.uxap/z2ui5_cl_api_app_532) | [`z2ui5_cl_api_app_532`](https://github.com/abap2UI5/api/blob/main/src/03/z2ui5_cl_api_app_532.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.AnchorBarWithNumbers) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_532) |
| ❌ | `BlockBaseBlockInBlock` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.BlockBase/sample/sap.uxap.sample.BlockBaseBlockInBlock) | — |
| ❌ | `BlockBaseEventing` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.BlockBase/sample/sap.uxap.sample.BlockBaseEventing) | — |
| ❌ | `BoundModelMapping` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ModelMapping/sample/sap.uxap.sample.BoundModelMapping) | — |
| ❌ | `ChildObjectPage` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageHeader/sample/sap.uxap.sample.ChildObjectPage) | — |
| ✅ | [`HeaderContent`](https://github.com/abap2UI5/api/tree/main/ui5/sap.uxap/z2ui5_cl_api_app_531) | [`z2ui5_cl_api_app_531`](https://github.com/abap2UI5/api/blob/main/src/03/z2ui5_cl_api_app_531.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageHeaderContent/sample/sap.uxap.sample.HeaderContent) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_531) |
| ✅ | [`KPIObjectPageHeader`](https://github.com/abap2UI5/api/tree/main/ui5/sap.uxap/z2ui5_cl_api_app_529) | [`z2ui5_cl_api_app_529`](https://github.com/abap2UI5/api/blob/main/src/03/z2ui5_cl_api_app_529.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageHeader/sample/sap.uxap.sample.KPIObjectPageHeader) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_529) |
| ❌ | `MPModelMapping` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ModelMapping/sample/sap.uxap.sample.MPModelMapping) | — |
| ❌ | `ObjectPageBeforeNavigate` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageBeforeNavigate) | — |
| ❌ | `ObjectPageBlockBase` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.BlockBase/sample/sap.uxap.sample.ObjectPageBlockBase) | — |
| ❌ | `ObjectPageBlockViewTypes` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageBlockViewTypes) | — |
| ❌ | `ObjectPageDynamicSideContentBtn` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageHeader/sample/sap.uxap.sample.ObjectPageDynamicSideContentBtn) | — |
| ❌ | `ObjectPageFormFocusableInput` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageFormFocusableInput) | — |
| ❌ | `ObjectPageFormLayout` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageFormLayout) | — |
| ✅ | [`ObjectPageHeaderActionButtons`](https://github.com/abap2UI5/api/tree/main/ui5/sap.uxap/z2ui5_cl_api_app_411) | [`z2ui5_cl_api_app_411`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_411.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.GenericTag/sample/sap.uxap.sample.ObjectPageHeaderActionButtons) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_411) |
| ❌ | `ObjectPageHeaderBackgroundDesign` | — | — | — |
| ✅ | [`ObjectPageHeaderContentPriorities`](https://github.com/abap2UI5/api/tree/main/ui5/sap.uxap/z2ui5_cl_api_app_412) | [`z2ui5_cl_api_app_412`](https://github.com/abap2UI5/api/blob/main/src/03/z2ui5_cl_api_app_412.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageHeaderContent/sample/sap.uxap.sample.ObjectPageHeaderContentPriorities) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_412) |
| ✅ | [`ObjectPageHeaderExpanded`](https://github.com/abap2UI5/api/tree/main/ui5/sap.uxap/z2ui5_cl_api_app_533) | [`z2ui5_cl_api_app_533`](https://github.com/abap2UI5/api/blob/main/src/03/z2ui5_cl_api_app_533.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageHeaderExpanded) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_533) |
| ❌ | `ObjectPageHeaderWithAllControls` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageHeader/sample/sap.uxap.sample.ObjectPageHeaderWithAllControls) | — |
| ✅ | [`ObjectPageLazyLoadingWithoutBlocks`](https://github.com/abap2UI5/api/tree/main/ui5/sap.uxap/z2ui5_cl_api_app_534) | [`z2ui5_cl_api_app_534`](https://github.com/abap2UI5/api/blob/main/src/03/z2ui5_cl_api_app_534.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageLazyLoadingWithoutBlocks) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_534) |
| ❌ | `ObjectPageOnJSON` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageOnJSON) | — |
| ✅ | [`ObjectPageOnJSONWithLazyLoading`](https://github.com/abap2UI5/api/tree/main/ui5/sap.uxap/z2ui5_cl_api_app_535) | [`z2ui5_cl_api_app_535`](https://github.com/abap2UI5/api/blob/main/src/03/z2ui5_cl_api_app_535.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageOnJSONWithLazyLoading) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_535) |
| ❌ | `ObjectPageProgressRatingIndicators` | — | — | — |
| ❌ | `ObjectPageResetSelectedSection` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageResetSelectedSection) | — |
| ❌ | `ObjectPageResponsiveAvatar` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageResponsiveAvatar) | — |
| ✅ | [`ObjectPageSection`](https://github.com/abap2UI5/api/tree/main/ui5/sap.uxap/z2ui5_cl_api_app_414) | [`z2ui5_cl_api_app_414`](https://github.com/abap2UI5/api/blob/main/src/03/z2ui5_cl_api_app_414.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageSection/sample/sap.uxap.sample.ObjectPageSection) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_414) |
| ❌ | `ObjectPageSectionShowTitle` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.HeaderFacetPattern/sample/sap.uxap.sample.ObjectPageSectionShowTitle) | — |
| ✅ | [`ObjectPageSelectedSection`](https://github.com/abap2UI5/api/tree/main/ui5/sap.uxap/z2ui5_cl_api_app_536) | [`z2ui5_cl_api_app_536`](https://github.com/abap2UI5/api/blob/main/src/03/z2ui5_cl_api_app_536.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageSelectedSection) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_536) |
| ❌ | `ObjectPageState` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageState) | — |
| ❌ | `ObjectPageSubSection` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageSubSection/sample/sap.uxap.sample.ObjectPageSubSection) | — |
| ❌ | `ObjectPageSubSectionBackground` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageSubSection/sample/sap.uxap.sample.ObjectPageSubSectionBackground) | — |
| ❌ | `ObjectPageSubSectionHiddenTitle` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageSubSection/sample/sap.uxap.sample.ObjectPageSubSectionHiddenTitle) | — |
| ❌ | `ObjectPageSubSectionMultiView` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageSubSection/sample/sap.uxap.sample.ObjectPageSubSectionMultiView) | — |
| ❌ | `ObjectPageSubSectionSized` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageSubSection/sample/sap.uxap.sample.ObjectPageSubSectionSized) | — |
| ✅ | [`ObjectPageSubSectionWithActions`](https://github.com/abap2UI5/api/tree/main/ui5/sap.uxap/z2ui5_cl_api_app_415) | [`z2ui5_cl_api_app_415`](https://github.com/abap2UI5/api/blob/main/src/03/z2ui5_cl_api_app_415.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageSubSection/sample/sap.uxap.sample.ObjectPageSubSectionWithActions) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_415) |
| ✅ | [`ObjectPageTabNavigationMode`](https://github.com/abap2UI5/api/tree/main/ui5/sap.uxap/z2ui5_cl_api_app_537) | [`z2ui5_cl_api_app_537`](https://github.com/abap2UI5/api/blob/main/src/03/z2ui5_cl_api_app_537.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageTabNavigationMode) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_537) |
| ❌ | `ObjectPageTitleOnLeft` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageTitleOnLeft) | — |
| ❌ | `ObjectPageWithHeaderContainer` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageWithHeaderContainer) | — |
| ❌ | `ObjectPageWithLinksAndObjectStatus` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.HeaderFacetPattern/sample/sap.uxap.sample.ObjectPageWithLinksAndObjectStatus) | — |
| ❌ | `ObjectPageXML` | — | — | — |
| ✅ | [`ProfileObjectPageHeader`](https://github.com/abap2UI5/api/tree/main/ui5/sap.uxap/z2ui5_cl_api_app_530) | [`z2ui5_cl_api_app_530`](https://github.com/abap2UI5/api/blob/main/src/03/z2ui5_cl_api_app_530.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageHeader/sample/sap.uxap.sample.ProfileObjectPageHeader) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_530) |
| ❌ | `SharedBlocks` | — | — | — |
| ❌ | `SharedJSONData` | — | — | — |
| ❌ | `SingleView` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.BlockBase/sample/sap.uxap.sample.SingleView) | — |

### `sap.ui.integration` — 1/4 (25.0 %)

| | Javascript | ABAP | Link | System |
|---|-----------|------|------|--------|
| ✅ | [`CardExplorer`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.integration/z2ui5_cl_api_app_510) | [`z2ui5_cl_api_app_510`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_510.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.integration.widgets.Card/sample/sap.ui.integration.sample.CardExplorer) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_510) |
| ❌ | `CardsLayout` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.integration.widgets.Card/sample/sap.ui.integration.sample.CardsLayout) | — |
| ❌ | `CardsLoading` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.integration.widgets.Card/sample/sap.ui.integration.sample.CardsLoading) | — |
| ❌ | `LazyLoading` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.integration.widgets.Card/sample/sap.ui.integration.sample.LazyLoading) | — |

### `sap.ui.layout` — 15/62 (24.2 %)

| | Javascript | ABAP | Link | System |
|---|-----------|------|------|--------|
| ✅ | [`BlockLayoutCustomBackground`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.layout/z2ui5_cl_api_app_511) | [`z2ui5_cl_api_app_511`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_511.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.BlockLayout/sample/sap.ui.layout.sample.BlockLayoutCustomBackground) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_511) |
| ❌ | `BlockLayoutCustomBackgroundPerCell` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.BlockLayout/sample/sap.ui.layout.sample.BlockLayoutCustomBackgroundPerCell) | — |
| ✅ | [`BlockLayoutDefault`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.layout/z2ui5_cl_api_app_512) | [`z2ui5_cl_api_app_512`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_512.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.BlockLayout/sample/sap.ui.layout.sample.BlockLayoutDefault) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_512) |
| ✅ | [`BlockLayoutLinkTitle`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.layout/z2ui5_cl_api_app_513) | [`z2ui5_cl_api_app_513`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_513.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.BlockLayout/sample/sap.ui.layout.sample.BlockLayoutLinkTitle) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_513) |
| ✅ | [`CSSGrid`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.layout/z2ui5_cl_api_app_521) | [`z2ui5_cl_api_app_521`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_521.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.cssgrid.CSSGrid/sample/sap.ui.layout.sample.CSSGrid) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_521) |
| ❌ | `DynamicSideContent` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.DynamicSideContent/sample/sap.ui.layout.sample.DynamicSideContent) | — |
| ❌ | `DynamicSideContentEqualSplit` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.DynamicSideContent/sample/sap.ui.layout.sample.DynamicSideContentEqualSplit) | — |
| ❌ | `DynamicSideContentPosition` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.DynamicSideContent/sample/sap.ui.layout.sample.DynamicSideContentPosition) | — |
| ❌ | `DynamicSideContentProduct` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.DynamicSideContent/sample/sap.ui.layout.sample.DynamicSideContentProduct) | — |
| ✅ | [`FixFlexFixedSize`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.layout/z2ui5_cl_api_app_410) | [`z2ui5_cl_api_app_410`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_410.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.FixFlex/sample/sap.ui.layout.sample.FixFlexFixedSize) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_410) |
| ✅ | [`FixFlexHorizontal`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.layout/z2ui5_cl_api_app_514) | [`z2ui5_cl_api_app_514`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_514.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.FixFlex/sample/sap.ui.layout.sample.FixFlexHorizontal) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_514) |
| ✅ | [`FixFlexMinFlexSize`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.layout/z2ui5_cl_api_app_515) | [`z2ui5_cl_api_app_515`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_515.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.FixFlex/sample/sap.ui.layout.sample.FixFlexMinFlexSize) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_515) |
| ✅ | [`FixFlexVertical`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.layout/z2ui5_cl_api_app_516) | [`z2ui5_cl_api_app_516`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_516.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.FixFlex/sample/sap.ui.layout.sample.FixFlexVertical) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_516) |
| ❌ | `Form_Column_oneGroup` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.Form/sample/sap.ui.layout.sample.Form_Column_oneGroup) | — |
| ❌ | `Form_Column_oneGroup234` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.Form/sample/sap.ui.layout.sample.Form_Column_oneGroup234) | — |
| ❌ | `Form_Column_threeGroups234` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.Form/sample/sap.ui.layout.sample.Form_Column_threeGroups234) | — |
| ❌ | `Form_Column_threeGroups346` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.Form/sample/sap.ui.layout.sample.Form_Column_threeGroups346) | — |
| ❌ | `Form_Column_twoGroups234` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.Form/sample/sap.ui.layout.sample.Form_Column_twoGroups234) | — |
| ❌ | `Form354` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.Form/sample/sap.ui.layout.sample.Form354) | — |
| ❌ | `Form354wide` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.Form/sample/sap.ui.layout.sample.Form354wide) | — |
| ❌ | `Form354wideDual` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.Form/sample/sap.ui.layout.sample.Form354wideDual) | — |
| ❌ | `Form471` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.Form/sample/sap.ui.layout.sample.Form471) | — |
| ❌ | `Form480` | — | — | — |
| ❌ | `Form480_12120` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.Form/sample/sap.ui.layout.sample.Form480_12120) | — |
| ❌ | `Form480_12120Dual` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.Form/sample/sap.ui.layout.sample.Form480_12120Dual) | — |
| ❌ | `Form480_Trial` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.Form/sample/sap.ui.layout.sample.Form480_Trial) | — |
| ✅ | [`FormToolbar`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.layout/z2ui5_cl_api_app_523) | [`z2ui5_cl_api_app_523`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_523.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.Form/sample/sap.ui.layout.sample.FormToolbar) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_523) |
| ❌ | `GridAutoFlow` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.cssgrid.CSSGrid/sample/sap.ui.layout.sample.GridAutoFlow) | — |
| ❌ | `GridAutoRows` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.cssgrid.CSSGrid/sample/sap.ui.layout.sample.GridAutoRows) | — |
| ❌ | `GridData` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.Grid/sample/sap.ui.layout.sample.GridData) | — |
| ❌ | `GridGap` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.cssgrid.CSSGrid/sample/sap.ui.layout.sample.GridGap) | — |
| ✅ | [`GridInfo`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.layout/z2ui5_cl_api_app_517) | [`z2ui5_cl_api_app_517`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_517.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.Grid/sample/sap.ui.layout.sample.GridInfo) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_517) |
| ❌ | `GridProperties` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.Grid/sample/sap.ui.layout.sample.GridProperties) | — |
| ❌ | `GridResponsiveColumnLayout` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.cssgrid.CSSGrid/sample/sap.ui.layout.sample.GridResponsiveColumnLayout) | — |
| ❌ | `GridResponsiveness` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.cssgrid.CSSGrid/sample/sap.ui.layout.sample.GridResponsiveness) | — |
| ❌ | `GridTemplateRows` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.cssgrid.CSSGrid/sample/sap.ui.layout.sample.GridTemplateRows) | — |
| ✅ | [`GridXL`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.layout/z2ui5_cl_api_app_518) | [`z2ui5_cl_api_app_518`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_518.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.Grid/sample/sap.ui.layout.sample.GridXL) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_518) |
| ✅ | [`HorizontalLayout`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.layout/z2ui5_cl_api_app_519) | [`z2ui5_cl_api_app_519`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_519.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.HorizontalLayout/sample/sap.ui.layout.sample.HorizontalLayout) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_519) |
| ✅ | [`NestedGrids`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.layout/z2ui5_cl_api_app_522) | [`z2ui5_cl_api_app_522`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_522.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.cssgrid.CSSGrid/sample/sap.ui.layout.sample.NestedGrids) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_522) |
| ❌ | `ProductHomeLayout` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.cssgrid.CSSGrid/sample/sap.ui.layout.sample.ProductHomeLayout) | — |
| ❌ | `ResponsiveSplitter` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.ResponsiveSplitter/sample/sap.ui.layout.sample.ResponsiveSplitter) | — |
| ❌ | `SimpleForm_Column_oneGroup` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.SimpleForm/sample/sap.ui.layout.sample.SimpleForm_Column_oneGroup) | — |
| ❌ | `SimpleForm_Column_oneGroup234` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.SimpleForm/sample/sap.ui.layout.sample.SimpleForm_Column_oneGroup234) | — |
| ❌ | `SimpleForm_Column_threeGroups234` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.SimpleForm/sample/sap.ui.layout.sample.SimpleForm_Column_threeGroups234) | — |
| ❌ | `SimpleForm_Column_threeGroups346` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.SimpleForm/sample/sap.ui.layout.sample.SimpleForm_Column_threeGroups346) | — |
| ❌ | `SimpleForm_Column_twoGroups234` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.SimpleForm/sample/sap.ui.layout.sample.SimpleForm_Column_twoGroups234) | — |
| ❌ | `SimpleForm354` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.SimpleForm/sample/sap.ui.layout.sample.SimpleForm354) | — |
| ❌ | `SimpleForm354wide` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.SimpleForm/sample/sap.ui.layout.sample.SimpleForm354wide) | — |
| ❌ | `SimpleForm354wideDual` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.SimpleForm/sample/sap.ui.layout.sample.SimpleForm354wideDual) | — |
| ❌ | `SimpleForm471` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.SimpleForm/sample/sap.ui.layout.sample.SimpleForm471) | — |
| ❌ | `SimpleForm480` | — | — | — |
| ❌ | `SimpleForm480_12120` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.SimpleForm/sample/sap.ui.layout.sample.SimpleForm480_12120) | — |
| ❌ | `SimpleForm480_12120Dual` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.SimpleForm/sample/sap.ui.layout.sample.SimpleForm480_12120Dual) | — |
| ❌ | `SimpleForm480_Trial` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.SimpleForm/sample/sap.ui.layout.sample.SimpleForm480_Trial) | — |
| ✅ | [`SimpleFormToolbar`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.layout/z2ui5_cl_api_app_524) | [`z2ui5_cl_api_app_524`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_524.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.SimpleForm/sample/sap.ui.layout.sample.SimpleFormToolbar) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_524) |
| ❌ | `Splitter` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.Splitter/sample/sap.ui.layout.sample.Splitter) | — |
| ❌ | `Splitter2` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.Splitter/sample/sap.ui.layout.sample.Splitter2) | — |
| ❌ | `Splitter3` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.Splitter/sample/sap.ui.layout.sample.Splitter3) | — |
| ❌ | `Splitter4` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.Splitter/sample/sap.ui.layout.sample.Splitter4) | — |
| ❌ | `SplitterNested1` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.Splitter/sample/sap.ui.layout.sample.SplitterNested1) | — |
| ❌ | `tests` | — | — | — |
| ✅ | [`VerticalLayout`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.layout/z2ui5_cl_api_app_520) | [`z2ui5_cl_api_app_520`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_520.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.VerticalLayout/sample/sap.ui.layout.sample.VerticalLayout) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_520) |

### `sap.ui.core` — 9/48 (18.8 %)

| | Javascript | ABAP | Link | System |
|---|-----------|------|------|--------|
| ✅ | [`BasicThemeParameters`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.core/z2ui5_cl_api_app_502) | [`z2ui5_cl_api_app_502`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_502.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.theming/sample/sap.ui.core.sample.BasicThemeParameters) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_502) |
| ❌ | `BoundFilters` | — | — | — |
| ❌ | `BusyIndicator` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.BusyIndicator/sample/sap.ui.core.sample.BusyIndicator) | — |
| ❌ | `Commands` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.CommandExecution/sample/sap.ui.core.sample.Commands) | — |
| ❌ | `common` | — | — | — |
| ❌ | `ControlBusyIndicator` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.Control/sample/sap.ui.core.sample.ControlBusyIndicator) | — |
| ❌ | `ControllerExtension` | — | — | — |
| ❌ | `FieldGroup` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.Control/sample/sap.ui.core.sample.FieldGroup) | — |
| ❌ | `gherkin` | — | — | — |
| ❌ | `Html` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.HTML/sample/sap.ui.core.sample.Html) | — |
| ❌ | `HyphenationAPI` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.hyphenation.Hyphenation/sample/sap.ui.core.sample.HyphenationAPI) | — |
| ✅ | [`Icon`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.core/z2ui5_cl_api_app_501) | [`z2ui5_cl_api_app_501`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_501.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.Icon/sample/sap.ui.core.sample.Icon) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_501) |
| ❌ | `InvisibleMessage` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.InvisibleMessage/sample/sap.ui.core.sample.InvisibleMessage) | — |
| ❌ | `InvisibleText` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.InvisibleText/sample/sap.ui.core.sample.InvisibleText) | — |
| ❌ | `matcher` | — | — | — |
| ❌ | `Messaging` | — | — | — |
| ❌ | `odata` | — | — | — |
| ❌ | `OpaAction` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.test.Opa5/sample/sap.ui.core.sample.OpaAction) | — |
| ❌ | `OpaAutoWaitParams` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.test.Opa5/sample/sap.ui.core.sample.OpaAutoWaitParams) | — |
| ❌ | `OpaBusyIndicator` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.test.Opa5/sample/sap.ui.core.sample.OpaBusyIndicator) | — |
| ❌ | `OpaById` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.test.Opa5/sample/sap.ui.core.sample.OpaById) | — |
| ❌ | `OpaDynamicWait` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.test.Opa5/sample/sap.ui.core.sample.OpaDynamicWait) | — |
| ❌ | `OpaGetStarted` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.test.Opa5/sample/sap.ui.core.sample.OpaGetStarted) | — |
| ❌ | `OpaMatchers` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.test.Opa5/sample/sap.ui.core.sample.OpaMatchers) | — |
| ❌ | `OpaPageObject` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.test.Opa5/sample/sap.ui.core.sample.OpaPageObject) | — |
| ❌ | `OpaStartup` | — | — | — |
| ❌ | `OpaStaticAreaControls` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.test.Opa5/sample/sap.ui.core.sample.OpaStaticAreaControls) | — |
| ❌ | `OpaTableAction` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.test.Opa5/sample/sap.ui.core.sample.OpaTableAction) | — |
| ❌ | `OpaTestLibrary` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.test.Opa5/sample/sap.ui.core.sample.OpaTestLibrary) | — |
| ❌ | `OpaURLParameters` | — | — | — |
| ❌ | `OpaWithSupportAssistant` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.test.Opa5/sample/sap.ui.core.sample.OpaWithSupportAssistant) | — |
| ❌ | `PatternMatching` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.routing.Route/sample/sap.ui.core.sample.PatternMatching) | — |
| ❌ | `RoutingFullscreen` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.routing.Router/sample/sap.ui.core.sample.RoutingFullscreen) | — |
| ❌ | `RoutingMasterDetail` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.routing.Router/sample/sap.ui.core.sample.RoutingMasterDetail) | — |
| ❌ | `RoutingNestedComponent` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.routing.Router/sample/sap.ui.core.sample.RoutingNestedComponent) | — |
| ❌ | `TargetsStandalone` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.routing.Targets/sample/sap.ui.core.sample.TargetsStandalone) | — |
| ❌ | `ThemeCustomClasses` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.theming/sample/sap.ui.core.sample.ThemeCustomClasses) | — |
| ✅ | [`TypeCurrency`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.core/z2ui5_cl_api_app_503) | [`z2ui5_cl_api_app_503`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_503.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.model.type.Currency/sample/sap.ui.core.sample.TypeCurrency) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_503) |
| ✅ | [`TypeDateAsDate`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.core/z2ui5_cl_api_app_504) | [`z2ui5_cl_api_app_504`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_504.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.model.type.Date/sample/sap.ui.core.sample.TypeDateAsDate) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_504) |
| ✅ | [`TypeDateAsString`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.core/z2ui5_cl_api_app_505) | [`z2ui5_cl_api_app_505`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_505.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.model.type.Date/sample/sap.ui.core.sample.TypeDateAsString) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_505) |
| ❌ | `TypeDateTime` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.model.type.DateTime/sample/sap.ui.core.sample.TypeDateTime) | — |
| ✅ | [`TypeFileSize`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.core/z2ui5_cl_api_app_506) | [`z2ui5_cl_api_app_506`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_506.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.model.type.FileSize/sample/sap.ui.core.sample.TypeFileSize) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_506) |
| ✅ | [`TypeFloat`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.core/z2ui5_cl_api_app_507) | [`z2ui5_cl_api_app_507`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_507.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.model.type.Float/sample/sap.ui.core.sample.TypeFloat) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_507) |
| ✅ | [`TypeInteger`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.core/z2ui5_cl_api_app_508) | [`z2ui5_cl_api_app_508`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_508.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.model.type.Integer/sample/sap.ui.core.sample.TypeInteger) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_508) |
| ✅ | [`TypeTimeAsTime`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.core/z2ui5_cl_api_app_509) | [`z2ui5_cl_api_app_509`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_509.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.model.type.Time/sample/sap.ui.core.sample.TypeTimeAsTime) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_509) |
| ❌ | `View` | — | — | — |
| ❌ | `ViewTemplate` | — | — | — |
| ❌ | `XMLComposite` | — | — | — |

### `sap.m` — 83/446 (18.6 %)

| | Javascript | ABAP | Link | System |
|---|-----------|------|------|--------|
| ❌ | `ActionListItem` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ActionListItem/sample/sap.m.sample.ActionListItem) | — |
| ❌ | `ActionSelect` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ActionSelect/sample/sap.m.sample.ActionSelect) | — |
| ❌ | `ActionSheet` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ActionSheet/sample/sap.m.sample.ActionSheet) | — |
| ❌ | `AIIntegration` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.sample.AIIntegration/sample/sap.m.sample.AIIntegration) | — |
| ❌ | `Avatar` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Avatar/sample/sap.m.sample.Avatar) | — |
| ❌ | `AvatarActiveState` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Avatar/sample/sap.m.sample.AvatarActiveState) | — |
| ❌ | `AvatarBadgeIconColor` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Avatar/sample/sap.m.sample.AvatarBadgeIconColor) | — |
| ❌ | `AvatarValueState` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Avatar/sample/sap.m.sample.AvatarValueState) | — |
| ❌ | `AvatarWithAffordance` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Avatar/sample/sap.m.sample.AvatarWithAffordance) | — |
| ❌ | `Breadcrumbs` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Breadcrumbs/sample/sap.m.sample.Breadcrumbs) | — |
| ❌ | `BreadcrumbsWithCurrentPageLink` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Breadcrumbs/sample/sap.m.sample.BreadcrumbsWithCurrentPageLink) | — |
| ❌ | `BreadcrumbsWithoutCurrentPage` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Breadcrumbs/sample/sap.m.sample.BreadcrumbsWithoutCurrentPage) | — |
| ❌ | `BusyDialog` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.BusyDialog/sample/sap.m.sample.BusyDialog) | — |
| ❌ | `BusyDialogLight` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.BusyDialog/sample/sap.m.sample.BusyDialogLight) | — |
| ❌ | `BusyIndicator` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.BusyIndicator/sample/sap.m.sample.BusyIndicator) | — |
| ❌ | `Button` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Button/sample/sap.m.sample.Button) | — |
| ❌ | `ButtonWithBadge` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Button/sample/sap.m.sample.ButtonWithBadge) | — |
| ❌ | `Carousel` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Carousel/sample/sap.m.sample.Carousel) | — |
| ❌ | `CarouselEmptyMessages` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Carousel/sample/sap.m.sample.CarouselEmptyMessages) | — |
| ✅ | [`CarouselWithControls`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_420) | [`z2ui5_cl_api_app_420`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_420.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Carousel/sample/sap.m.sample.CarouselWithControls) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_420) |
| ❌ | `CarouselWithDisplayOptions` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Carousel/sample/sap.m.sample.CarouselWithDisplayOptions) | — |
| ❌ | `CarouselWithMorePages` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Carousel/sample/sap.m.sample.CarouselWithMorePages) | — |
| ❌ | `CheckBox` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.CheckBox/sample/sap.m.sample.CheckBox) | — |
| ✅ | [`CheckBoxTriState`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_421) | [`z2ui5_cl_api_app_421`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_421.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.CheckBox/sample/sap.m.sample.CheckBoxTriState) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_421) |
| ✅ | [`ColorPalette`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_422) | [`z2ui5_cl_api_app_422`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_422.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ColorPalette/sample/sap.m.sample.ColorPalette) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_422) |
| ❌ | `ColorPalettePopover` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ColorPalette/sample/sap.m.sample.ColorPalettePopover) | — |
| ✅ | [`ComboBox`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_423) | [`z2ui5_cl_api_app_423`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_423.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ComboBox/sample/sap.m.sample.ComboBox) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_423) |
| ✅ | [`ComboBox2Columns`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_424) | [`z2ui5_cl_api_app_424`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_424.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ComboBox/sample/sap.m.sample.ComboBox2Columns) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_424) |
| ❌ | `ComboBoxClearIcon` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ComboBox/sample/sap.m.sample.ComboBoxClearIcon) | — |
| ✅ | [`ComboBoxDefaultFiltering`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_425) | [`z2ui5_cl_api_app_425`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_425.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ComboBox/sample/sap.m.sample.ComboBoxDefaultFiltering) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_425) |
| ❌ | `ComboBoxFilteringContains` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ComboBox/sample/sap.m.sample.ComboBoxFilteringContains) | — |
| ❌ | `ComboBoxFilteringStartsWith` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ComboBox/sample/sap.m.sample.ComboBoxFilteringStartsWith) | — |
| ✅ | [`ComboBoxGrouping`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_428) | [`z2ui5_cl_api_app_428`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_428.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ComboBox/sample/sap.m.sample.ComboBoxGrouping) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_428) |
| ❌ | `ComboBoxLazyLoading` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ComboBox/sample/sap.m.sample.ComboBoxLazyLoading) | — |
| ❌ | `ComboBoxMaxPickerHeight` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ComboBox/sample/sap.m.sample.ComboBoxMaxPickerHeight) | — |
| ❌ | `ComboBoxSearchBoth` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ComboBox/sample/sap.m.sample.ComboBoxSearchBoth) | — |
| ❌ | `ComboBoxValidation` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ComboBox/sample/sap.m.sample.ComboBoxValidation) | — |
| ❌ | `ComboBoxValueState` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ComboBox/sample/sap.m.sample.ComboBoxValueState) | — |
| ❌ | `ComboBoxWrapping` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ComboBox/sample/sap.m.sample.ComboBoxWrapping) | — |
| ❌ | `ComparisonPattern` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ComparisonPattern/sample/sap.m.sample.ComparisonPattern) | — |
| ✅ | [`ContainerNoPadding`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_488) | [`z2ui5_cl_api_app_488`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_488.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.ContainerPadding/sample/sap.m.sample.ContainerNoPadding) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_488) |
| ❌ | `ContainerPadding` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.ContainerPadding/sample/sap.m.sample.ContainerPadding) | — |
| ✅ | [`ContainerPaddingAndMargin`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_489) | [`z2ui5_cl_api_app_489`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_489.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.ContainerPadding/sample/sap.m.sample.ContainerPaddingAndMargin) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_489) |
| ✅ | [`ContainerResponsivePadding`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_490) | [`z2ui5_cl_api_app_490`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_490.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.ContainerPadding/sample/sap.m.sample.ContainerResponsivePadding) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_490) |
| ❌ | `CookieSettingsDialogPattern` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.CookieSettingsDialogPattern/sample/sap.m.sample.CookieSettingsDialogPattern) | — |
| ❌ | `CustomListItem` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.CustomListItem/sample/sap.m.sample.CustomListItem) | — |
| ❌ | `CustomMessageStripDesign` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageStrip/sample/sap.m.sample.CustomMessageStripDesign) | — |
| ✅ | [`CustomTreeItem`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_429) | [`z2ui5_cl_api_app_429`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_429.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.CustomTreeItem/sample/sap.m.sample.CustomTreeItem) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_429) |
| ❌ | `DatePicker` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DatePicker/sample/sap.m.sample.DatePicker) | — |
| ❌ | `DatePickerHidden` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DatePicker/sample/sap.m.sample.DatePickerHidden) | — |
| ❌ | `DatePickerMassEdit` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DatePicker/sample/sap.m.sample.DatePickerMassEdit) | — |
| ❌ | `DatePickerValueState` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DatePicker/sample/sap.m.sample.DatePickerValueState) | — |
| ❌ | `DateRangeSelection` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DateRangeSelection/sample/sap.m.sample.DateRangeSelection) | — |
| ❌ | `DateRangeSelectionHidden` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DateRangeSelection/sample/sap.m.sample.DateRangeSelectionHidden) | — |
| ❌ | `DateRangeSelectionValueState` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DateRangeSelection/sample/sap.m.sample.DateRangeSelectionValueState) | — |
| ❌ | `DateTimeInput` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DateTimeInput/sample/sap.m.sample.DateTimeInput) | — |
| ❌ | `DateTimePicker` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DateTimePicker/sample/sap.m.sample.DateTimePicker) | — |
| ❌ | `DateTimePickerHidden` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DateTimePicker/sample/sap.m.sample.DateTimePickerHidden) | — |
| ❌ | `DateTimePickerValueState` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DateTimePicker/sample/sap.m.sample.DateTimePickerValueState) | — |
| ❌ | `Dialog` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Dialog/sample/sap.m.sample.Dialog) | — |
| ❌ | `DialogConfirm` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Dialog/sample/sap.m.sample.DialogConfirm) | — |
| ❌ | `DialogFullScreen` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Dialog/sample/sap.m.sample.DialogFullScreen) | — |
| ❌ | `DialogMessage` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Dialog/sample/sap.m.sample.DialogMessage) | — |
| ❌ | `DialogSearch` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SearchField/sample/sap.m.sample.DialogSearch) | — |
| ❌ | `DialogWithinArea` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Dialog/sample/sap.m.sample.DialogWithinArea) | — |
| ❌ | `DialogWithMessagePopover` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Dialog/sample/sap.m.sample.DialogWithMessagePopover) | — |
| ✅ | [`DisplayListItem`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_430) | [`z2ui5_cl_api_app_430`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_430.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DisplayListItem/sample/sap.m.sample.DisplayListItem) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_430) |
| ❌ | `DraftIndicator` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DraftIndicator/sample/sap.m.sample.DraftIndicator) | — |
| ❌ | `DynamicDateRange` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DynamicDateRange/sample/sap.m.sample.DynamicDateRange) | — |
| ❌ | `DynamicDateRangeAndCalendarWeekNumbering` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DynamicDateRange/sample/sap.m.sample.DynamicDateRangeAndCalendarWeekNumbering) | — |
| ❌ | `DynamicDateRangeHidden` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DynamicDateRange/sample/sap.m.sample.DynamicDateRangeHidden) | — |
| ❌ | `DynamicDateRangeWithCustomOptions` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DynamicDateRange/sample/sap.m.sample.DynamicDateRangeWithCustomOptions) | — |
| ❌ | `DynamicMessageStripGenerator` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageStrip/sample/sap.m.sample.DynamicMessageStripGenerator) | — |
| ❌ | `ExpandableText` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ExpandableText/sample/sap.m.sample.ExpandableText) | — |
| ❌ | `FacetFilterCustomFilters` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FacetFilter/sample/sap.m.sample.FacetFilterCustomFilters) | — |
| ✅ | [`FacetFilterLight`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_401) | [`z2ui5_cl_api_app_401`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_401.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FacetFilter/sample/sap.m.sample.FacetFilterLight) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_401) |
| ❌ | `FacetFilterSimple` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FacetFilter/sample/sap.m.sample.FacetFilterSimple) | — |
| ❌ | `Feed` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FeedInput/sample/sap.m.sample.Feed) | — |
| ❌ | `FeedContent` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FeedContent/sample/sap.m.sample.FeedContent) | — |
| ❌ | `FeedInput` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FeedInput/sample/sap.m.sample.FeedInput) | — |
| ❌ | `FeedListItem` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FeedListItem/sample/sap.m.sample.FeedListItem) | — |
| ❌ | `FlexBoxBasicAlignment` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxBasicAlignment) | — |
| ✅ | [`FlexBoxCols`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_402) | [`z2ui5_cl_api_app_402`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_402.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxCols) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_402) |
| ❌ | `FlexBoxDirectionOrder` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxDirectionOrder) | — |
| ❌ | `FlexBoxGap` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxGap) | — |
| ✅ | [`FlexBoxNav`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_403) | [`z2ui5_cl_api_app_403`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_403.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxNav) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_403) |
| ✅ | [`FlexBoxNested`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_404) | [`z2ui5_cl_api_app_404`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_404.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxNested) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_404) |
| ❌ | `FlexBoxOpposingAlignment` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxOpposingAlignment) | — |
| ❌ | `FlexBoxRenderType` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxRenderType) | — |
| ✅ | [`FlexBoxSizeAdjustments`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_405) | [`z2ui5_cl_api_app_405`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_405.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxSizeAdjustments) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_405) |
| ❌ | `FormattedText` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FormattedText/sample/sap.m.sample.FormattedText) | — |
| ❌ | `GenericTag` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.GenericTag/sample/sap.m.sample.GenericTag) | — |
| ❌ | `GenericTileAsFeedTile` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.GenericTile/sample/sap.m.sample.GenericTileAsFeedTile) | — |
| ✅ | [`GenericTileAsKPITile`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_431) | [`z2ui5_cl_api_app_431`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_431.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.GenericTile/sample/sap.m.sample.GenericTileAsKPITile) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_431) |
| ❌ | `GenericTileAsLaunchTile` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.GenericTile/sample/sap.m.sample.GenericTileAsLaunchTile) | — |
| ❌ | `GenericTileAsMonitorTile` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.GenericTile/sample/sap.m.sample.GenericTileAsMonitorTile) | — |
| ❌ | `GenericTileLineMode` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.GenericTile/sample/sap.m.sample.GenericTileLineMode) | — |
| ❌ | `GenericTileStates` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.GenericTile/sample/sap.m.sample.GenericTileStates) | — |
| ❌ | `HeaderContainer` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.HeaderContainer/sample/sap.m.sample.HeaderContainer) | — |
| ❌ | `HeaderContainerLazyLoading` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.HeaderContainer/sample/sap.m.sample.HeaderContainerLazyLoading) | — |
| ❌ | `HeaderContainerNoDividers` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.HeaderContainer/sample/sap.m.sample.HeaderContainerNoDividers) | — |
| ❌ | `HeaderContainerOH` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.HeaderContainer/sample/sap.m.sample.HeaderContainerOH) | — |
| ❌ | `HeaderContainerVM` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.HeaderContainer/sample/sap.m.sample.HeaderContainerVM) | — |
| ❌ | `IconTabBar` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBar) | — |
| ❌ | `IconTabBarBackgroundDesign` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarBackgroundDesign) | — |
| ❌ | `IconTabBarBadges` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarBadges) | — |
| ❌ | `IconTabBarDragDrop` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarDragDrop) | — |
| ❌ | `IconTabBarFiori2` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarFiori2) | — |
| ❌ | `IconTabBarInlineIcons` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarInlineIcons) | — |
| ❌ | `IconTabBarInlineMode` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarInlineMode) | — |
| ❌ | `IconTabBarMulti` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarMulti) | — |
| ❌ | `IconTabBarNoIcons` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarNoIcons) | — |
| ✅ | [`IconTabBarOverflowSelectList`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_432) | [`z2ui5_cl_api_app_432`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_432.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarOverflowSelectList) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_432) |
| ❌ | `IconTabBarProcess` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarProcess) | — |
| ❌ | `IconTabBarResponsivePadding` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarResponsivePadding) | — |
| ❌ | `IconTabBarStartAndEndOverflow` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarStartAndEndOverflow) | — |
| ✅ | [`IconTabBarStretchContent`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_433) | [`z2ui5_cl_api_app_433`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_433.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarStretchContent) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_433) |
| ❌ | `IconTabBarSubTabs` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarSubTabs) | — |
| ❌ | `IconTabBarTabDensityMode` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarTabDensityMode) | — |
| ❌ | `IconTabHeader` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabHeader/sample/sap.m.sample.IconTabHeader) | — |
| ❌ | `IconTabSeparator` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabSeparator) | — |
| ❌ | `IllustratedMessageEVR` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IllustratedMessage/sample/sap.m.sample.IllustratedMessageEVR) | — |
| ❌ | `IllustratedMessageInAppCustom` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IllustratedMessage/sample/sap.m.sample.IllustratedMessageInAppCustom) | — |
| ❌ | `IllustratedMessageInCardNoActivities` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IllustratedMessage/sample/sap.m.sample.IllustratedMessageInCardNoActivities) | — |
| ❌ | `IllustratedMessageInCardNoEmail` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IllustratedMessage/sample/sap.m.sample.IllustratedMessageInCardNoEmail) | — |
| ❌ | `IllustratedMessageInDialog` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IllustratedMessage/sample/sap.m.sample.IllustratedMessageInDialog) | — |
| ❌ | `IllustratedMessageInPage` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IllustratedMessage/sample/sap.m.sample.IllustratedMessageInPage) | — |
| ❌ | `IllustratedMessageInPageCustom` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IllustratedMessage/sample/sap.m.sample.IllustratedMessageInPageCustom) | — |
| ❌ | `IllustratedMessageInPageTNT` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IllustratedMessage/sample/sap.m.sample.IllustratedMessageInPageTNT) | — |
| ❌ | `IllustratedMessageInPageWithURI` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IllustratedMessage/sample/sap.m.sample.IllustratedMessageInPageWithURI) | — |
| ❌ | `IllustratedMessageSessionTimeout` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IllustratedMessage/sample/sap.m.sample.IllustratedMessageSessionTimeout) | — |
| ❌ | `Image` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Image/sample/sap.m.sample.Image) | — |
| ❌ | `ImageContent` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ImageContent/sample/sap.m.sample.ImageContent) | — |
| ❌ | `ImageErrorWithIllustration` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Image/sample/sap.m.sample.ImageErrorWithIllustration) | — |
| ✅ | [`ImageModeBackground`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_434) | [`z2ui5_cl_api_app_434`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_434.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Image/sample/sap.m.sample.ImageModeBackground) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_434) |
| ❌ | `InitialPagePattern` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.InitialPagePattern/sample/sap.m.sample.InitialPagePattern) | — |
| ❌ | `InputAssisted` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputAssisted) | — |
| ✅ | [`InputAssistedTabularSuggestions`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_435) | [`z2ui5_cl_api_app_435`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_435.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputAssistedTabularSuggestions) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_435) |
| ✅ | [`InputAssistedTwoValues`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_436) | [`z2ui5_cl_api_app_436`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_436.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputAssistedTwoValues) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_436) |
| ❌ | `InputChecked` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputChecked) | — |
| ❌ | `InputCustomValueHelpIcon` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputCustomValueHelpIcon) | — |
| ❌ | `InputDescription` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputDescription) | — |
| ✅ | [`InputGrouping`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_437) | [`z2ui5_cl_api_app_437`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_437.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputGrouping) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_437) |
| ❌ | `InputKeyValue` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputKeyValue) | — |
| ❌ | `InputKeyValueTabularSuggestions` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputKeyValueTabularSuggestions) | — |
| ❌ | `InputListItem` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.InputListItem/sample/sap.m.sample.InputListItem) | — |
| ❌ | `InputModelUpdate` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.InputModelUpdate/sample/sap.m.sample.InputModelUpdate) | — |
| ❌ | `InputPassword` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputPassword) | — |
| ❌ | `InputStates` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputStates) | — |
| ✅ | [`InputSuggestionsCustomFilter`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_438) | [`z2ui5_cl_api_app_438`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_438.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputSuggestionsCustomFilter) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_438) |
| ❌ | `InputSuggestionsDynamic` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputSuggestionsDynamic) | — |
| ❌ | `InputSuggestionsOpenSearch` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputSuggestionsOpenSearch) | — |
| ❌ | `InputTypes` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputTypes) | — |
| ✅ | [`InputValueState`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_439) | [`z2ui5_cl_api_app_439`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_439.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputValueState) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_439) |
| ❌ | `InputValueUpdate` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputValueUpdate) | — |
| ❌ | `InputWrapping` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputWrapping) | — |
| ❌ | `Label` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Label/sample/sap.m.sample.Label) | — |
| ❌ | `LabelProperties` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Label/sample/sap.m.sample.LabelProperties) | — |
| ❌ | `LightBox` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.LightBox/sample/sap.m.sample.LightBox) | — |
| ❌ | `Link` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Link/sample/sap.m.sample.Link) | — |
| ✅ | [`LinkEmphasized`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_440) | [`z2ui5_cl_api_app_440`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_440.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Link/sample/sap.m.sample.LinkEmphasized) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_440) |
| ❌ | `LinkSubtle` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Link/sample/sap.m.sample.LinkSubtle) | — |
| ❌ | `ListActions` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.List/sample/sap.m.sample.ListActions) | — |
| ✅ | [`ListCounter`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_441) | [`z2ui5_cl_api_app_441`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_441.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.List/sample/sap.m.sample.ListCounter) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_441) |
| ❌ | `ListDeletion` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.List/sample/sap.m.sample.ListDeletion) | — |
| ✅ | [`ListFooter`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_442) | [`z2ui5_cl_api_app_442`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_442.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.List/sample/sap.m.sample.ListFooter) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_442) |
| ❌ | `ListGrouping` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.List/sample/sap.m.sample.ListGrouping) | — |
| ✅ | [`ListGrowing`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_443) | [`z2ui5_cl_api_app_443`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_443.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.List/sample/sap.m.sample.ListGrowing) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_443) |
| ❌ | `ListGrowingUpwards` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.List/sample/sap.m.sample.ListGrowingUpwards) | — |
| ❌ | `ListItemTypes` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.List/sample/sap.m.sample.ListItemTypes) | — |
| ❌ | `ListLoading` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.List/sample/sap.m.sample.ListLoading) | — |
| ✅ | [`ListNavType`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_444) | [`z2ui5_cl_api_app_444`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_444.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.List/sample/sap.m.sample.ListNavType) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_444) |
| ✅ | [`ListNoData`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_445) | [`z2ui5_cl_api_app_445`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_445.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.List/sample/sap.m.sample.ListNoData) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_445) |
| ✅ | [`ListSelection`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_446) | [`z2ui5_cl_api_app_446`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_446.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.List/sample/sap.m.sample.ListSelection) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_446) |
| ❌ | `ListSelectionSearch` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.List/sample/sap.m.sample.ListSelectionSearch) | — |
| ❌ | `ListSwipe` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.List/sample/sap.m.sample.ListSwipe) | — |
| ❌ | `ListToolbar` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.List/sample/sap.m.sample.ListToolbar) | — |
| ❌ | `ListUnread` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.List/sample/sap.m.sample.ListUnread) | — |
| ❌ | `MaskInput` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MaskInput/sample/sap.m.sample.MaskInput) | — |
| ❌ | `MaxNumberOfNotificationsReached` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.NotificationListGroup/sample/sap.m.sample.MaxNumberOfNotificationsReached) | — |
| ❌ | `Menu` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Menu/sample/sap.m.sample.Menu) | — |
| ❌ | `MenuButton` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MenuButton/sample/sap.m.sample.MenuButton) | — |
| ❌ | `MenuEndContent` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Menu/sample/sap.m.sample.MenuEndContent) | — |
| ❌ | `MenuSelectable` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Menu/sample/sap.m.sample.MenuSelectable) | — |
| ❌ | `MessageBox` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageBox/sample/sap.m.sample.MessageBox) | — |
| ❌ | `MessageBoxInfo` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageBox/sample/sap.m.sample.MessageBoxInfo) | — |
| ✅ | [`MessageBoxInitialFocus`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_447) | [`z2ui5_cl_api_app_447`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_447.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageBox/sample/sap.m.sample.MessageBoxInitialFocus) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_447) |
| ❌ | `MessagePage` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessagePage/sample/sap.m.sample.MessagePage) | — |
| ❌ | `MessagePageWithButtons` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessagePage/sample/sap.m.sample.MessagePageWithButtons) | — |
| ❌ | `MessagePopover` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessagePopover/sample/sap.m.sample.MessagePopover) | — |
| ❌ | `MessagePopoverAsyncMessageHandling` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessagePopover/sample/sap.m.sample.MessagePopoverAsyncMessageHandling) | — |
| ❌ | `MessagePopoverMessageHandling` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessagePopover/sample/sap.m.sample.MessagePopoverMessageHandling) | — |
| ❌ | `MessageStrip` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageStrip/sample/sap.m.sample.MessageStrip) | — |
| ❌ | `MessageStripWithEnableFormattedText` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageStrip/sample/sap.m.sample.MessageStripWithEnableFormattedText) | — |
| ✅ | [`MessageToast`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_448) | [`z2ui5_cl_api_app_448`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_448.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageToast/sample/sap.m.sample.MessageToast) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_448) |
| ❌ | `MessageViewInsideDialog` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageView/sample/sap.m.sample.MessageViewInsideDialog) | — |
| ❌ | `MessageViewInsidePopover` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageView/sample/sap.m.sample.MessageViewInsidePopover) | — |
| ❌ | `MessageViewInsideResponsivePopover` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageView/sample/sap.m.sample.MessageViewInsideResponsivePopover) | — |
| ✅ | [`MessageViewMessageManager`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_449) | [`z2ui5_cl_api_app_449`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_449.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageView/sample/sap.m.sample.MessageViewMessageManager) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_449) |
| ❌ | `MessageViewWithGrouping` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageView/sample/sap.m.sample.MessageViewWithGrouping) | — |
| ❌ | `MultiComboBox` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiComboBox/sample/sap.m.sample.MultiComboBox) | — |
| ❌ | `MultiComboBoxClearIcon` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiComboBox/sample/sap.m.sample.MultiComboBoxClearIcon) | — |
| ❌ | `MultiComboBoxCustomFiltering` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiComboBox/sample/sap.m.sample.MultiComboBoxCustomFiltering) | — |
| ✅ | [`MultiComboBoxDefaultFiltering`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_451) | [`z2ui5_cl_api_app_451`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_451.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiComboBox/sample/sap.m.sample.MultiComboBoxDefaultFiltering) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_451) |
| ✅ | [`MultiComboBoxGrouping`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_452) | [`z2ui5_cl_api_app_452`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_452.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiComboBox/sample/sap.m.sample.MultiComboBoxGrouping) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_452) |
| ❌ | `MultiComboBoxMaxPickerHeight` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiComboBox/sample/sap.m.sample.MultiComboBoxMaxPickerHeight) | — |
| ❌ | `MultiComboBoxSelectAll` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiComboBox/sample/sap.m.sample.MultiComboBoxSelectAll) | — |
| ❌ | `MultiComboBoxSuggestionsAndValueState` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiComboBox/sample/sap.m.sample.MultiComboBoxSuggestionsAndValueState) | — |
| ✅ | [`MultiComboBoxTwoColumnsLayout`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_453) | [`z2ui5_cl_api_app_453`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_453.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiComboBox/sample/sap.m.sample.MultiComboBoxTwoColumnsLayout) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_453) |
| ❌ | `MultiComboBoxWrapping` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiComboBox/sample/sap.m.sample.MultiComboBoxWrapping) | — |
| ✅ | [`MultiInput`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_454) | [`z2ui5_cl_api_app_454`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_454.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiInput/sample/sap.m.sample.MultiInput) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_454) |
| ❌ | `MultiInputCustomFiltering` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiInput/sample/sap.m.sample.MultiInputCustomFiltering) | — |
| ✅ | [`MultiInputDatabinding`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_456) | [`z2ui5_cl_api_app_456`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_456.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiInput/sample/sap.m.sample.MultiInputDatabinding) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_456) |
| ❌ | `MultiInputFilteringSuggestions` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiInput/sample/sap.m.sample.MultiInputFilteringSuggestions) | — |
| ✅ | [`MultiInputGrouping`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_457) | [`z2ui5_cl_api_app_457`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_457.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiInput/sample/sap.m.sample.MultiInputGrouping) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_457) |
| ✅ | [`MultiInputMaxTokens`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_458) | [`z2ui5_cl_api_app_458`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_458.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiInput/sample/sap.m.sample.MultiInputMaxTokens) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_458) |
| ❌ | `MultiInputModelUpdate` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiInput/sample/sap.m.sample.MultiInputModelUpdate) | — |
| ❌ | `MultiInputTokenUpdate` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiInput/sample/sap.m.sample.MultiInputTokenUpdate) | — |
| ❌ | `MultiInputValidators` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiInput/sample/sap.m.sample.MultiInputValidators) | — |
| ❌ | `MultiInputValueHelp` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiInput/sample/sap.m.sample.MultiInputValueHelp) | — |
| ❌ | `MultiInputValueStates` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiInput/sample/sap.m.sample.MultiInputValueStates) | — |
| ❌ | `MultiInputWrapping` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiInput/sample/sap.m.sample.MultiInputWrapping) | — |
| ❌ | `NavContainer` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.NavContainer/sample/sap.m.sample.NavContainer) | — |
| ❌ | `NewsContent` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.NewsContent/sample/sap.m.sample.NewsContent) | — |
| ❌ | `NotificationListGroup` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.NotificationListGroup/sample/sap.m.sample.NotificationListGroup) | — |
| ❌ | `NotificationListGroupBindings` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.NotificationListGroup/sample/sap.m.sample.NotificationListGroupBindings) | — |
| ❌ | `NotificationListGroupLazyLoading` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.NotificationListGroup/sample/sap.m.sample.NotificationListGroupLazyLoading) | — |
| ❌ | `NotificationListItem` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.NotificationListItem/sample/sap.m.sample.NotificationListItem) | — |
| ❌ | `NumericContentDifColors` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.NumericContent/sample/sap.m.sample.NumericContentDifColors) | — |
| ❌ | `NumericContentIcon` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.NumericContent/sample/sap.m.sample.NumericContentIcon) | — |
| ❌ | `NumericContentWithoutMargin` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.NumericContent/sample/sap.m.sample.NumericContentWithoutMargin) | — |
| ❌ | `ObjectAttributeInTable` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectAttribute/sample/sap.m.sample.ObjectAttributeInTable) | — |
| ❌ | `ObjectAttributes` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectAttribute/sample/sap.m.sample.ObjectAttributes) | — |
| ✅ | [`ObjectHeader`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_460) | [`z2ui5_cl_api_app_460`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_460.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeader) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_460) |
| ❌ | `ObjectHeaderActiveAttributes` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectAttribute/sample/sap.m.sample.ObjectHeaderActiveAttributes) | — |
| ❌ | `ObjectHeaderCircleImage` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeaderCircleImage) | — |
| ✅ | [`ObjectHeaderCondensed`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_461) | [`z2ui5_cl_api_app_461`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_461.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeaderCondensed) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_461) |
| ✅ | [`ObjectHeaderImage`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_462) | [`z2ui5_cl_api_app_462`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_462.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeaderImage) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_462) |
| ✅ | [`ObjectHeaderMarkers`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_463) | [`z2ui5_cl_api_app_463`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_463.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeaderMarkers) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_463) |
| ✅ | [`ObjectHeaderResponsiveI`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_459) | [`z2ui5_cl_api_app_459`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_459.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectAttribute/sample/sap.m.sample.ObjectHeaderResponsiveI) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_459) |
| ✅ | [`ObjectHeaderResponsiveII`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_464) | [`z2ui5_cl_api_app_464`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_464.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeaderResponsiveII) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_464) |
| ❌ | `ObjectHeaderResponsiveIII` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeaderResponsiveIII) | — |
| ❌ | `ObjectHeaderResponsiveIV` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeaderResponsiveIV) | — |
| ✅ | [`ObjectHeaderResponsiveV`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_465) | [`z2ui5_cl_api_app_465`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_465.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeaderResponsiveV) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_465) |
| ❌ | `ObjectHeaderResponsiveVI` | — | — | — |
| ❌ | `ObjectHeaderTitleActive` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeaderTitleActive) | — |
| ❌ | `ObjectHeaderTitleSel` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeaderTitleSel) | — |
| ✅ | [`ObjectIdentifier`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_466) | [`z2ui5_cl_api_app_466`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_466.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectIdentifier/sample/sap.m.sample.ObjectIdentifier) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_466) |
| ❌ | `ObjectListItem` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectListItem/sample/sap.m.sample.ObjectListItem) | — |
| ❌ | `ObjectListItemMarkers` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectListItem/sample/sap.m.sample.ObjectListItemMarkers) | — |
| ❌ | `ObjectMarker` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectMarker/sample/sap.m.sample.ObjectMarker) | — |
| ✅ | [`ObjectNumber`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_467) | [`z2ui5_cl_api_app_467`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_467.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectNumber/sample/sap.m.sample.ObjectNumber) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_467) |
| ❌ | `ObjectStatus` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectStatus/sample/sap.m.sample.ObjectStatus) | — |
| ❌ | `OverflowToolbarDifferentControls` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.OverflowToolbar/sample/sap.m.sample.OverflowToolbarDifferentControls) | — |
| ❌ | `OverflowToolbarFooter` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.OverflowToolbar/sample/sap.m.sample.OverflowToolbarFooter) | — |
| ❌ | `OverflowToolbarSimple` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.GenericTag/sample/sap.m.sample.OverflowToolbarSimple) | — |
| ❌ | `OverflowToolbarTokenizer` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.OverflowToolbarTokenizer/sample/sap.m.sample.OverflowToolbarTokenizer) | — |
| ❌ | `p13n` | — | — | — |
| ❌ | `Page` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Bar/sample/sap.m.sample.Page) | — |
| ❌ | `PageFloatingFooter` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Page/sample/sap.m.sample.PageFloatingFooter) | — |
| ✅ | [`PageListReportIconTabBar`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_406) | [`z2ui5_cl_api_app_406`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_406.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Page/sample/sap.m.sample.PageListReportIconTabBar) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_406) |
| ✅ | [`PageListReportToolbar`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_407) | [`z2ui5_cl_api_app_407`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_407.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Page/sample/sap.m.sample.PageListReportToolbar) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_407) |
| ✅ | [`PageStandardClasses`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_470) | [`z2ui5_cl_api_app_470`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_470.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Page/sample/sap.m.sample.PageStandardClasses) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_470) |
| ❌ | `Panel` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Panel/sample/sap.m.sample.Panel) | — |
| ❌ | `PanelBackgroundDesign` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Panel/sample/sap.m.sample.PanelBackgroundDesign) | — |
| ✅ | [`PanelExpanded`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_471) | [`z2ui5_cl_api_app_471`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_471.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Panel/sample/sap.m.sample.PanelExpanded) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_471) |
| ❌ | `PanelSticky` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Panel/sample/sap.m.sample.PanelSticky) | — |
| ❌ | `PDFViewerEmbedded` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PDFViewer/sample/sap.m.sample.PDFViewerEmbedded) | — |
| ❌ | `PDFViewerMultiple` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PDFViewer/sample/sap.m.sample.PDFViewerMultiple) | — |
| ✅ | [`PDFViewerPopup`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_469) | [`z2ui5_cl_api_app_469`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_469.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PDFViewer/sample/sap.m.sample.PDFViewerPopup) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_469) |
| ❌ | `PlanningCalendar` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PlanningCalendar/sample/sap.m.sample.PlanningCalendar) | — |
| ❌ | `PlanningCalendarAppointmentSizes` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PlanningCalendar/sample/sap.m.sample.PlanningCalendarAppointmentSizes) | — |
| ❌ | `PlanningCalendarDnD` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PlanningCalendar/sample/sap.m.sample.PlanningCalendarDnD) | — |
| ❌ | `PlanningCalendarMinMax` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PlanningCalendar/sample/sap.m.sample.PlanningCalendarMinMax) | — |
| ❌ | `PlanningCalendarModifyAppointments` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PlanningCalendar/sample/sap.m.sample.PlanningCalendarModifyAppointments) | — |
| ❌ | `PlanningCalendarMulti` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PlanningCalendar/sample/sap.m.sample.PlanningCalendarMulti) | — |
| ❌ | `PlanningCalendarOneLine` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PlanningCalendar/sample/sap.m.sample.PlanningCalendarOneLine) | — |
| ❌ | `PlanningCalendarRecurringItem` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PlanningCalendar/sample/sap.m.sample.PlanningCalendarRecurringItem) | — |
| ❌ | `PlanningCalendarRelativeViews` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PlanningCalendar/sample/sap.m.sample.PlanningCalendarRelativeViews) | — |
| ❌ | `PlanningCalendarSingle` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PlanningCalendar/sample/sap.m.sample.PlanningCalendarSingle) | — |
| ❌ | `PlanningCalendarViews` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PlanningCalendar/sample/sap.m.sample.PlanningCalendarViews) | — |
| ❌ | `PlanningCalendarWeekNumbering` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PlanningCalendar/sample/sap.m.sample.PlanningCalendarWeekNumbering) | — |
| ❌ | `PlanningCalendarWithLegend` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PlanningCalendar/sample/sap.m.sample.PlanningCalendarWithLegend) | — |
| ❌ | `PlanningCalendarWithStickyHeader` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PlanningCalendar/sample/sap.m.sample.PlanningCalendarWithStickyHeader) | — |
| ❌ | `Popover` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Popover/sample/sap.m.sample.Popover) | — |
| ❌ | `PopoverControllingCloseBehavior` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Popover/sample/sap.m.sample.PopoverControllingCloseBehavior) | — |
| ❌ | `PopoverNavCon` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Popover/sample/sap.m.sample.PopoverNavCon) | — |
| ❌ | `PopoverWithinArea` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Popover/sample/sap.m.sample.PopoverWithinArea) | — |
| ❌ | `ProgressIndicator` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ProgressIndicator/sample/sap.m.sample.ProgressIndicator) | — |
| ❌ | `ProgressIndicatorWithAnnouncement` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ProgressIndicator/sample/sap.m.sample.ProgressIndicatorWithAnnouncement) | — |
| ❌ | `PullToRefresh` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PullToRefresh/sample/sap.m.sample.PullToRefresh) | — |
| ❌ | `QuickView` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.QuickView/sample/sap.m.sample.QuickView) | — |
| ❌ | `QuickViewAvatarConfiguration` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.QuickView/sample/sap.m.sample.QuickViewAvatarConfiguration) | — |
| ❌ | `QuickViewCard` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.QuickViewCard/sample/sap.m.sample.QuickViewCard) | — |
| ❌ | `QuickViewCardScrollBar` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.QuickViewCard/sample/sap.m.sample.QuickViewCardScrollBar) | — |
| ❌ | `QuickViewNavOrigin` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.QuickView/sample/sap.m.sample.QuickViewNavOrigin) | — |
| ❌ | `RadioButton` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.RadioButton/sample/sap.m.sample.RadioButton) | — |
| ❌ | `RadioButtonGroup` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.RadioButtonGroup/sample/sap.m.sample.RadioButtonGroup) | — |
| ✅ | [`RangeSlider`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_472) | [`z2ui5_cl_api_app_472`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_472.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.RangeSlider/sample/sap.m.sample.RangeSlider) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_472) |
| ❌ | `RatingIndicator` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.RatingIndicator/sample/sap.m.sample.RatingIndicator) | — |
| ❌ | `RefreshResponsive` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PullToRefresh/sample/sap.m.sample.RefreshResponsive) | — |
| ❌ | `ResponsivePopover` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ResponsivePopover/sample/sap.m.sample.ResponsivePopover) | — |
| ✅ | [`ScrollContainer`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_473) | [`z2ui5_cl_api_app_473`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_473.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ScrollContainer/sample/sap.m.sample.ScrollContainer) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_473) |
| ❌ | `SearchField` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SearchField/sample/sap.m.sample.SearchField) | — |
| ❌ | `SearchFieldSuggestions` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SearchField/sample/sap.m.sample.SearchFieldSuggestions) | — |
| ✅ | [`SegmentedButton`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_474) | [`z2ui5_cl_api_app_474`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_474.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SegmentedButton/sample/sap.m.sample.SegmentedButton) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_474) |
| ❌ | `SegmentedButtonContentModes` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SegmentedButton/sample/sap.m.sample.SegmentedButtonContentModes) | — |
| ❌ | `SegmentedButtonDialog` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SegmentedButton/sample/sap.m.sample.SegmentedButtonDialog) | — |
| ❌ | `SegmentedButtonLI` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SegmentedButton/sample/sap.m.sample.SegmentedButtonLI) | — |
| ❌ | `SegmentedButtonVSD` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SegmentedButton/sample/sap.m.sample.SegmentedButtonVSD) | — |
| ❌ | `Select` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Select/sample/sap.m.sample.Select) | — |
| ❌ | `Select2Columns` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Select/sample/sap.m.sample.Select2Columns) | — |
| ❌ | `SelectChangeEvents` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Select/sample/sap.m.sample.SelectChangeEvents) | — |
| ❌ | `SelectDialog` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SelectDialog/sample/sap.m.sample.SelectDialog) | — |
| ❌ | `SelectDialogLazyLoading` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SelectDialog/sample/sap.m.sample.SelectDialogLazyLoading) | — |
| ✅ | [`SelectList`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_475) | [`z2ui5_cl_api_app_475`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_475.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SelectList/sample/sap.m.sample.SelectList) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_475) |
| ✅ | [`SelectListWithIcons`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_476) | [`z2ui5_cl_api_app_476`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_476.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SelectList/sample/sap.m.sample.SelectListWithIcons) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_476) |
| ❌ | `SelectValueState` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Select/sample/sap.m.sample.SelectValueState) | — |
| ❌ | `SelectWithIcons` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Select/sample/sap.m.sample.SelectWithIcons) | — |
| ❌ | `SelectWithWrappedItemText` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Select/sample/sap.m.sample.SelectWithWrappedItemText) | — |
| ❌ | `SemanticPage` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.semantic.SemanticPage/sample/sap.m.sample.SemanticPage) | — |
| ❌ | `SemanticPageDraftIndicator` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DraftIndicator/sample/sap.m.sample.SemanticPageDraftIndicator) | — |
| ❌ | `SemanticPageFloatingFooter` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.semantic.SemanticPage/sample/sap.m.sample.SemanticPageFloatingFooter) | — |
| ❌ | `SemanticPageFullScreen` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.semantic.SemanticPage/sample/sap.m.sample.SemanticPageFullScreen) | — |
| ❌ | `SinglePlanningCalendar` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SinglePlanningCalendar/sample/sap.m.sample.SinglePlanningCalendar) | — |
| ❌ | `SinglePlanningCalendarCreateApp` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SinglePlanningCalendar/sample/sap.m.sample.SinglePlanningCalendarCreateApp) | — |
| ❌ | `SinglePlanningCalendarDateSelection` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SinglePlanningCalendar/sample/sap.m.sample.SinglePlanningCalendarDateSelection) | — |
| ❌ | `SinglePlanningCalendarDND` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SinglePlanningCalendar/sample/sap.m.sample.SinglePlanningCalendarDND) | — |
| ❌ | `SinglePlanningCalendarRecurringItem` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SinglePlanningCalendar/sample/sap.m.sample.SinglePlanningCalendarRecurringItem) | — |
| ❌ | `SinglePlanningCalendarSnappingHeader` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SinglePlanningCalendar/sample/sap.m.sample.SinglePlanningCalendarSnappingHeader) | — |
| ❌ | `SinglePlanningCalendarWeekNumbering` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SinglePlanningCalendar/sample/sap.m.sample.SinglePlanningCalendarWeekNumbering) | — |
| ❌ | `SinglePlanningCalendarWithCustomViews` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SinglePlanningCalendar/sample/sap.m.sample.SinglePlanningCalendarWithCustomViews) | — |
| ❌ | `SinglePlanningCalendarWithLegend` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SinglePlanningCalendar/sample/sap.m.sample.SinglePlanningCalendarWithLegend) | — |
| ❌ | `SinglePlanningCalendarWithZoomInZoomOut` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SinglePlanningCalendar/sample/sap.m.sample.SinglePlanningCalendarWithZoomInZoomOut) | — |
| ❌ | `Slider` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Slider/sample/sap.m.sample.Slider) | — |
| ❌ | `SlideTile` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SlideTile/sample/sap.m.sample.SlideTile) | — |
| ❌ | `SplitApp` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SplitApp/sample/sap.m.sample.SplitApp) | — |
| ❌ | `SplitContainer` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SplitContainer/sample/sap.m.sample.SplitContainer) | — |
| ✅ | [`StandardListItem`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_477) | [`z2ui5_cl_api_app_477`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_477.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StandardListItem/sample/sap.m.sample.StandardListItem) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_477) |
| ❌ | `StandardListItemAvatar` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StandardListItem/sample/sap.m.sample.StandardListItemAvatar) | — |
| ✅ | [`StandardListItemDescription`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_478) | [`z2ui5_cl_api_app_478`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_478.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StandardListItem/sample/sap.m.sample.StandardListItemDescription) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_478) |
| ✅ | [`StandardListItemIcon`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_479) | [`z2ui5_cl_api_app_479`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_479.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StandardListItem/sample/sap.m.sample.StandardListItemIcon) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_479) |
| ❌ | `StandardListItemInfo` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StandardListItem/sample/sap.m.sample.StandardListItemInfo) | — |
| ❌ | `StandardListItemInfoStateInverted` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StandardListItem/sample/sap.m.sample.StandardListItemInfoStateInverted) | — |
| ❌ | `StandardListItemNavigated` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StandardListItem/sample/sap.m.sample.StandardListItemNavigated) | — |
| ✅ | [`StandardListItemTitle`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_480) | [`z2ui5_cl_api_app_480`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_480.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StandardListItem/sample/sap.m.sample.StandardListItemTitle) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_480) |
| ❌ | `StandardListItemWrapping` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StandardListItem/sample/sap.m.sample.StandardListItemWrapping) | — |
| ✅ | [`StandardMarginsAll`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_491) | [`z2ui5_cl_api_app_491`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_491.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.StandardMargins/sample/sap.m.sample.StandardMarginsAll) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_491) |
| ✅ | [`StandardMarginsCollapse`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_492) | [`z2ui5_cl_api_app_492`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_492.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.StandardMargins/sample/sap.m.sample.StandardMarginsCollapse) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_492) |
| ✅ | [`StandardMarginsEnforceWidthAuto`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_493) | [`z2ui5_cl_api_app_493`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_493.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.StandardMargins/sample/sap.m.sample.StandardMarginsEnforceWidthAuto) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_493) |
| ✅ | [`StandardMarginsResponsive`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_494) | [`z2ui5_cl_api_app_494`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_494.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.StandardMargins/sample/sap.m.sample.StandardMarginsResponsive) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_494) |
| ✅ | [`StandardMarginsSingleSided`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_495) | [`z2ui5_cl_api_app_495`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_495.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.StandardMargins/sample/sap.m.sample.StandardMarginsSingleSided) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_495) |
| ✅ | [`StandardMarginsTwoSided`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_496) | [`z2ui5_cl_api_app_496`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_496.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.StandardMargins/sample/sap.m.sample.StandardMarginsTwoSided) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_496) |
| ❌ | `StandardNegativeMarginsTwoSided` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.StandardMargins/sample/sap.m.sample.StandardNegativeMarginsTwoSided) | — |
| ✅ | [`StandardNoMargins`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_497) | [`z2ui5_cl_api_app_497`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_497.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.StandardMargins/sample/sap.m.sample.StandardNoMargins) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_497) |
| ✅ | [`StepInput`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_481) | [`z2ui5_cl_api_app_481`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_481.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StepInput/sample/sap.m.sample.StepInput) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_481) |
| ❌ | `StepInputValueState` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StepInput/sample/sap.m.sample.StepInputValueState) | — |
| ❌ | `Switch` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Switch/sample/sap.m.sample.Switch) | — |
| ❌ | `TabContainer` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.TabContainer/sample/sap.m.sample.TabContainer) | — |
| ❌ | `TabContainerIcons` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.TabContainer/sample/sap.m.sample.TabContainerIcons) | — |
| ❌ | `TabContainerMHC` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.TabContainer/sample/sap.m.sample.TabContainerMHC) | — |
| ❌ | `Table` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Column/sample/sap.m.sample.Table) | — |
| ✅ | [`TableAlternateRowColors`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_482) | [`z2ui5_cl_api_app_482`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_482.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Table/sample/sap.m.sample.TableAlternateRowColors) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_482) |
| ❌ | `TableAutoPopin` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Table/sample/sap.m.sample.TableAutoPopin) | — |
| ❌ | `TableBreadcrumb` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Table/sample/sap.m.sample.TableBreadcrumb) | — |
| ❌ | `TableColumnWidth` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Table/sample/sap.m.sample.TableColumnWidth) | — |
| ❌ | `TableContextualWidthDynamic` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Table/sample/sap.m.sample.TableContextualWidthDynamic) | — |
| ✅ | [`TableContextualWidthStatic`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_483) | [`z2ui5_cl_api_app_483`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_483.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Table/sample/sap.m.sample.TableContextualWidthStatic) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_483) |
| ❌ | `TableDnD` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Table/sample/sap.m.sample.TableDnD) | — |
| ❌ | `TableEditable` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Table/sample/sap.m.sample.TableEditable) | — |
| ❌ | `TableIColumnHeaderMenu` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Table/sample/sap.m.sample.TableIColumnHeaderMenu) | — |
| ❌ | `TableLayout` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Table/sample/sap.m.sample.TableLayout) | — |
| ❌ | `TableMergeCells` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Table/sample/sap.m.sample.TableMergeCells) | — |
| ❌ | `TableMultiSelectMode` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Table/sample/sap.m.sample.TableMultiSelectMode) | — |
| ❌ | `TableNavigated` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Table/sample/sap.m.sample.TableNavigated) | — |
| ❌ | `TableOutdated` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Table/sample/sap.m.sample.TableOutdated) | — |
| ❌ | `TableScrollToIndex` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Table/sample/sap.m.sample.TableScrollToIndex) | — |
| ❌ | `TableSelectCopy` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Table/sample/sap.m.sample.TableSelectCopy) | — |
| ❌ | `TableSelectDialog` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.TableSelectDialog/sample/sap.m.sample.TableSelectDialog) | — |
| ❌ | `TableSelectDialogGrowing` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.TableSelectDialog/sample/sap.m.sample.TableSelectDialogGrowing) | — |
| ❌ | `TableStrictLayout` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Table/sample/sap.m.sample.TableStrictLayout) | — |
| ❌ | `TableTest` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ColumnListItem/sample/sap.m.sample.TableTest) | — |
| ❌ | `TableVerticalAlignment` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Table/sample/sap.m.sample.TableVerticalAlignment) | — |
| ❌ | `TableViewSettingsDialog` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Table/sample/sap.m.sample.TableViewSettingsDialog) | — |
| ✅ | [`Text`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_408) | [`z2ui5_cl_api_app_408`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_408.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Text/sample/sap.m.sample.Text) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_408) |
| ✅ | [`TextArea`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_409) | [`z2ui5_cl_api_app_409`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_409.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.TextArea/sample/sap.m.sample.TextArea) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_409) |
| ❌ | `TextAreaGrowing` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.TextArea/sample/sap.m.sample.TextAreaGrowing) | — |
| ❌ | `TextAreaMaxLength` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.TextArea/sample/sap.m.sample.TextAreaMaxLength) | — |
| ❌ | `TextAreaValueStates` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.TextArea/sample/sap.m.sample.TextAreaValueStates) | — |
| ✅ | [`TextAreaValueUpdate`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_484) | [`z2ui5_cl_api_app_484`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_484.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.TextArea/sample/sap.m.sample.TextAreaValueUpdate) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_484) |
| ❌ | `TextEmptyIndicator` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Text/sample/sap.m.sample.TextEmptyIndicator) | — |
| ❌ | `TextHyphenation` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Text/sample/sap.m.sample.TextHyphenation) | — |
| ❌ | `TextMaxLines` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Text/sample/sap.m.sample.TextMaxLines) | — |
| ❌ | `TextRenderWhitespace` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Text/sample/sap.m.sample.TextRenderWhitespace) | — |
| ❌ | `TileContainer` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StandardTile/sample/sap.m.sample.TileContainer) | — |
| ❌ | `TileContent` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.TileContent/sample/sap.m.sample.TileContent) | — |
| ❌ | `TimePicker` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.TimePicker/sample/sap.m.sample.TimePicker) | — |
| ❌ | `TimePickerHidden` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.TimePicker/sample/sap.m.sample.TimePickerHidden) | — |
| ❌ | `TimePickerSliders` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.TimePickerSliders/sample/sap.m.sample.TimePickerSliders) | — |
| ❌ | `TimePickerValueState` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.TimePicker/sample/sap.m.sample.TimePickerValueState) | — |
| ✅ | [`Title`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_485) | [`z2ui5_cl_api_app_485`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_485.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Title/sample/sap.m.sample.Title) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_485) |
| ❌ | `TitleLink` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Title/sample/sap.m.sample.TitleLink) | — |
| ❌ | `TitleToolBar` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.OverflowToolbar/sample/sap.m.sample.TitleToolBar) | — |
| ❌ | `TitleWrapping` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Title/sample/sap.m.sample.TitleWrapping) | — |
| ❌ | `ToggleButton` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ToggleButton/sample/sap.m.sample.ToggleButton) | — |
| ❌ | `TokenizerBasic` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Tokenizer/sample/sap.m.sample.TokenizerBasic) | — |
| ❌ | `TokenizerMultiLine` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Tokenizer/sample/sap.m.sample.TokenizerMultiLine) | — |
| ❌ | `ToolbarActive` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.OverflowToolbar/sample/sap.m.sample.ToolbarActive) | — |
| ❌ | `ToolbarAlignment` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.OverflowToolbar/sample/sap.m.sample.ToolbarAlignment) | — |
| ❌ | `ToolbarDesign` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.OverflowToolbar/sample/sap.m.sample.ToolbarDesign) | — |
| ✅ | [`ToolbarEnabled`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_468) | [`z2ui5_cl_api_app_468`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_468.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.OverflowToolbar/sample/sap.m.sample.ToolbarEnabled) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_468) |
| ❌ | `ToolbarResponsive` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Toolbar/sample/sap.m.sample.ToolbarResponsive) | — |
| ✅ | [`ToolbarShrinkable`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_486) | [`z2ui5_cl_api_app_486`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_486.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Toolbar/sample/sap.m.sample.ToolbarShrinkable) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_486) |
| ❌ | `ToolbarVsBar` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Bar/sample/sap.m.sample.ToolbarVsBar) | — |
| ✅ | [`Tree`](https://github.com/abap2UI5/api/tree/main/ui5/sap.m/z2ui5_cl_api_app_487) | [`z2ui5_cl_api_app_487`](https://github.com/abap2UI5/api/blob/main/src/01/z2ui5_cl_api_app_487.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Tree/sample/sap.m.sample.Tree) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_487) |
| ❌ | `TreeDnD` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Tree/sample/sap.m.sample.TreeDnD) | — |
| ❌ | `TreeExpandMulti` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Tree/sample/sap.m.sample.TreeExpandMulti) | — |
| ❌ | `TreeExpandTo` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Tree/sample/sap.m.sample.TreeExpandTo) | — |
| ❌ | `TreeIcon` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Tree/sample/sap.m.sample.TreeIcon) | — |
| ❌ | `TreeJSONLazyLoading` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Tree/sample/sap.m.sample.TreeJSONLazyLoading) | — |
| ❌ | `TreeOData` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Tree/sample/sap.m.sample.TreeOData) | — |
| ❌ | `TreeSelection` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Tree/sample/sap.m.sample.TreeSelection) | — |
| ❌ | `TsHelloWorld` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.sample.TsHelloWorld/sample/sap.m.sample.TsHelloWorld) | — |
| ❌ | `UploadCollection` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.UploadCollection/sample/sap.m.sample.UploadCollection) | — |
| ❌ | `UploadCollectionFolderHierarchy` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.UploadCollection/sample/sap.m.sample.UploadCollectionFolderHierarchy) | — |
| ❌ | `UploadCollectionForPendingUpload` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.UploadCollection/sample/sap.m.sample.UploadCollectionForPendingUpload) | — |
| ❌ | `UploadCollectionSortingFiltering` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.UploadCollection/sample/sap.m.sample.UploadCollectionSortingFiltering) | — |
| ❌ | `UploadCollectionVersioning` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.UploadCollection/sample/sap.m.sample.UploadCollectionVersioning) | — |
| ❌ | `UploadSet` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.upload.UploadSet/sample/sap.m.sample.UploadSet) | — |
| ❌ | `UploadSetCloudUpload` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.upload.UploadSet/sample/sap.m.sample.UploadSetCloudUpload) | — |
| ❌ | `UploadSetCustomUploader` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.upload.UploadSet/sample/sap.m.sample.UploadSetCustomUploader) | — |
| ❌ | `UploadSetDirectoryUploads` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.upload.UploadSet/sample/sap.m.sample.UploadSetDirectoryUploads) | — |
| ❌ | `UploadSetGroupingSortingFiltering` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.upload.UploadSet/sample/sap.m.sample.UploadSetGroupingSortingFiltering) | — |
| ❌ | `UploadSetwithTablePlugin` | — | — | — |
| ❌ | `UrlHelper` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.URLHelper/sample/sap.m.sample.UrlHelper) | — |
| ❌ | `UXCIntegration` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.sample.UXCIntegration/sample/sap.m.sample.UXCIntegration) | — |
| ❌ | `VariantManagement` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.VariantManagement/sample/sap.m.sample.VariantManagement) | — |
| ❌ | `ViewSettingsDialog` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ViewSettingsDialog/sample/sap.m.sample.ViewSettingsDialog) | — |
| ❌ | `ViewSettingsDialogCustom` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ViewSettingsDialog/sample/sap.m.sample.ViewSettingsDialogCustom) | — |
| ❌ | `ViewSettingsDialogCustomFilterDetails` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ViewSettingsDialog/sample/sap.m.sample.ViewSettingsDialogCustomFilterDetails) | — |
| ❌ | `ViewSettingsDialogCustomTabs` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ViewSettingsDialog/sample/sap.m.sample.ViewSettingsDialogCustomTabs) | — |
| ❌ | `WhitespacePattern` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.WhitespacePattern/sample/sap.m.sample.WhitespacePattern) | — |
| ❌ | `Wizard` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Wizard/sample/sap.m.sample.Wizard) | — |
| ❌ | `WizardBranching` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Wizard/sample/sap.m.sample.WizardBranching) | — |
| ❌ | `WizardCurrentStep` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Wizard/sample/sap.m.sample.WizardCurrentStep) | — |
| ❌ | `WizardSingleStep` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Wizard/sample/sap.m.sample.WizardSingleStep) | — |

### `sap.tnt` — 3/17 (17.6 %)

| | Javascript | ABAP | Link | System |
|---|-----------|------|------|--------|
| ❌ | `InfoLabel` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.InfoLabel/sample/sap.tnt.sample.InfoLabel) | — |
| ❌ | `InfoLabelInDynamicPage` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.InfoLabel/sample/sap.tnt.sample.InfoLabelInDynamicPage) | — |
| ❌ | `InfoLabelInTable` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.InfoLabel/sample/sap.tnt.sample.InfoLabelInTable) | — |
| ✅ | [`NavigationList`](https://github.com/abap2UI5/api/tree/main/ui5/sap.tnt/z2ui5_cl_api_app_498) | [`z2ui5_cl_api_app_498`](https://github.com/abap2UI5/api/blob/main/src/05/z2ui5_cl_api_app_498.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.NavigationList/sample/sap.tnt.sample.NavigationList) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_498) |
| ✅ | [`SideNavigation`](https://github.com/abap2UI5/api/tree/main/ui5/sap.tnt/z2ui5_cl_api_app_499) | [`z2ui5_cl_api_app_499`](https://github.com/abap2UI5/api/blob/main/src/05/z2ui5_cl_api_app_499.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.SideNavigation/sample/sap.tnt.sample.SideNavigation) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_499) |
| ❌ | `SideNavigationActions` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.SideNavigation/sample/sap.tnt.sample.SideNavigationActions) | — |
| ❌ | `SideNavigationOverlayMode` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.SideNavigation/sample/sap.tnt.sample.SideNavigationOverlayMode) | — |
| ❌ | `SideNavigationPressEvent` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.SideNavigation/sample/sap.tnt.sample.SideNavigationPressEvent) | — |
| ❌ | `SideNavigationSearch` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.SideNavigation/sample/sap.tnt.sample.SideNavigationSearch) | — |
| ❌ | `SideNavigationUnselectableParents` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.SideNavigation/sample/sap.tnt.sample.SideNavigationUnselectableParents) | — |
| ❌ | `SideNavigationWithTags` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.SideNavigation/sample/sap.tnt.sample.SideNavigationWithTags) | — |
| ❌ | `SideNavigationWrapping` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.SideNavigation/sample/sap.tnt.sample.SideNavigationWrapping) | — |
| ❌ | `ToolHeader` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.ToolHeader/sample/sap.tnt.sample.ToolHeader) | — |
| ✅ | [`ToolHeaderIconTabHeader`](https://github.com/abap2UI5/api/tree/main/ui5/sap.tnt/z2ui5_cl_api_app_500) | [`z2ui5_cl_api_app_500`](https://github.com/abap2UI5/api/blob/main/src/05/z2ui5_cl_api_app_500.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.ToolHeader/sample/sap.tnt.sample.ToolHeaderIconTabHeader) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_500) |
| ❌ | `ToolPage` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.ToolPage/sample/sap.tnt.sample.ToolPage) | — |
| ❌ | `ToolPageHorizontalNavigation` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.ToolPage/sample/sap.tnt.sample.ToolPageHorizontalNavigation) | — |
| ❌ | `ToolPageNavigation` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.ToolPage/sample/sap.tnt.sample.ToolPageNavigation) | — |

### `sap.f` — 4/42 (9.5 %)

| | Javascript | ABAP | Link | System |
|---|-----------|------|------|--------|
| ❌ | `AvatarGroup` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.AvatarGroup/sample/sap.f.sample.AvatarGroup) | — |
| ❌ | `Card` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.Card/sample/sap.f.sample.Card) | — |
| ❌ | `DynamicPageAnalyticalTable` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.DynamicPage/sample/sap.f.sample.DynamicPageAnalyticalTable) | — |
| ❌ | `DynamicPageFreeStyle` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.DynamicPage/sample/sap.f.sample.DynamicPageFreeStyle) | — |
| ❌ | `DynamicPageResponsiveAvatar` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.DynamicPage/sample/sap.f.sample.DynamicPageResponsiveAvatar) | — |
| ❌ | `DynamicPageWithStickySubheader` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.DynamicPage/sample/sap.f.sample.DynamicPageWithStickySubheader) | — |
| ❌ | `DynamicPageWithWizard` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.DynamicPage/sample/sap.f.sample.DynamicPageWithWizard) | — |
| ❌ | `FlexibleColumnLayoutColumnResize` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.FlexibleColumnLayout/sample/sap.f.sample.FlexibleColumnLayoutColumnResize) | — |
| ❌ | `FlexibleColumnLayoutLandmarkInfo` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.FlexibleColumnLayout/sample/sap.f.sample.FlexibleColumnLayoutLandmarkInfo) | — |
| ❌ | `FlexibleColumnLayoutLandmarkInfoArrow` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.FlexibleColumnLayout/sample/sap.f.sample.FlexibleColumnLayoutLandmarkInfoArrow) | — |
| ❌ | `FlexibleColumnLayoutSimple` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.FlexibleColumnLayout/sample/sap.f.sample.FlexibleColumnLayoutSimple) | — |
| ❌ | `FlexibleColumnLayoutWithFullscreenPage` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.FlexibleColumnLayout/sample/sap.f.sample.FlexibleColumnLayoutWithFullscreenPage) | — |
| ❌ | `FlexibleColumnLayoutWithOneColumnStart` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.FlexibleColumnLayout/sample/sap.f.sample.FlexibleColumnLayoutWithOneColumnStart) | — |
| ❌ | `FlexibleColumnLayoutWithTwoColumnStart` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.FlexibleColumnLayout/sample/sap.f.sample.FlexibleColumnLayoutWithTwoColumnStart) | — |
| ❌ | `GridContainer` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.GridContainer/sample/sap.f.sample.GridContainer) | — |
| ❌ | `GridContainerDragAndDrop` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.GridContainer/sample/sap.f.sample.GridContainerDragAndDrop) | — |
| ❌ | `GridContainerDragAndDropFromList` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.GridContainer/sample/sap.f.sample.GridContainerDragAndDropFromList) | — |
| ❌ | `GridContainersNavigation` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.GridContainer/sample/sap.f.sample.GridContainersNavigation) | — |
| ✅ | [`GridListBasic`](https://github.com/abap2UI5/api/tree/main/ui5/sap.f/z2ui5_cl_api_app_416) | [`z2ui5_cl_api_app_416`](https://github.com/abap2UI5/api/blob/main/src/04/z2ui5_cl_api_app_416.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.GridList/sample/sap.f.sample.GridListBasic) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_416) |
| ✅ | [`GridListBoxContainer`](https://github.com/abap2UI5/api/tree/main/ui5/sap.f/z2ui5_cl_api_app_417) | [`z2ui5_cl_api_app_417`](https://github.com/abap2UI5/api/blob/main/src/04/z2ui5_cl_api_app_417.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.GridList/sample/sap.f.sample.GridListBoxContainer) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_417) |
| ✅ | [`GridListBoxContainerGrouping`](https://github.com/abap2UI5/api/tree/main/ui5/sap.f/z2ui5_cl_api_app_418) | [`z2ui5_cl_api_app_418`](https://github.com/abap2UI5/api/blob/main/src/04/z2ui5_cl_api_app_418.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.GridList/sample/sap.f.sample.GridListBoxContainerGrouping) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_418) |
| ❌ | `GridListBoxContainerReal` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.GridList/sample/sap.f.sample.GridListBoxContainerReal) | — |
| ❌ | `GridListBreakPoints` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.GridList/sample/sap.f.sample.GridListBreakPoints) | — |
| ❌ | `GridListDragAndDrop` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.GridList/sample/sap.f.sample.GridListDragAndDrop) | — |
| ❌ | `GridListKeyboardArrowsNavigation` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.GridList/sample/sap.f.sample.GridListKeyboardArrowsNavigation) | — |
| ❌ | `GridListModes` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.GridList/sample/sap.f.sample.GridListModes) | — |
| ❌ | `GridListResponsiveColumnLayout` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.GridList/sample/sap.f.sample.GridListResponsiveColumnLayout) | — |
| ❌ | `MomentInPage` | — | — | — |
| ❌ | `ProductSwitchItemWithImageSrc` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.ProductSwitch/sample/sap.f.sample.ProductSwitchItemWithImageSrc) | — |
| ❌ | `ProductSwitchNavigation` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.ProductSwitch/sample/sap.f.sample.ProductSwitchNavigation) | — |
| ❌ | `SemanticPage` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.semantic.SemanticPage/sample/sap.f.sample.SemanticPage) | — |
| ❌ | `SemanticPageFreeStyle` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.semantic.SemanticPage/sample/sap.f.sample.SemanticPageFreeStyle) | — |
| ✅ | [`ShellBar`](https://github.com/abap2UI5/api/tree/main/ui5/sap.f/z2ui5_cl_api_app_419) | [`z2ui5_cl_api_app_419`](https://github.com/abap2UI5/api/blob/main/src/04/z2ui5_cl_api_app_419.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.ShellBar/sample/sap.f.sample.ShellBar) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_419) |
| ❌ | `ShellBarProductSwitch` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.ShellBar/sample/sap.f.sample.ShellBarProductSwitch) | — |
| ❌ | `ShellBarWithFlexibleColumnLayout` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.FlexibleColumnLayout/sample/sap.f.sample.ShellBarWithFlexibleColumnLayout) | — |
| ❌ | `ShellBarWithMenuButton` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.ShellBar/sample/sap.f.sample.ShellBarWithMenuButton) | — |
| ❌ | `ShellBarWithSearch` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.ShellBar/sample/sap.f.sample.ShellBarWithSearch) | — |
| ❌ | `ShellBarWithSplitApp` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.ShellBar/sample/sap.f.sample.ShellBarWithSplitApp) | — |
| ❌ | `SidePanel` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.SidePanel/sample/sap.f.sample.SidePanel) | — |
| ❌ | `SidePanelOverflow` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.SidePanel/sample/sap.f.sample.SidePanelOverflow) | — |
| ❌ | `SidePanelResizable` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.SidePanel/sample/sap.f.sample.SidePanelResizable) | — |
| ❌ | `SidePanelSingle` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.SidePanel/sample/sap.f.sample.SidePanelSingle) | — |

### `sap.ui.unified` — 2/21 (9.5 %)

| | Javascript | ABAP | Link | System |
|---|-----------|------|------|--------|
| ❌ | `CalendarCalendarType` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.Calendar/sample/sap.ui.unified.sample.CalendarCalendarType) | — |
| ❌ | `CalendarDateDeselection` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.Calendar/sample/sap.ui.unified.sample.CalendarDateDeselection) | — |
| ❌ | `CalendarDateIntervalBasic` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.CalendarDateInterval/sample/sap.ui.unified.sample.CalendarDateIntervalBasic) | — |
| ❌ | `CalendarLegendNavigation` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.Calendar/sample/sap.ui.unified.sample.CalendarLegendNavigation) | — |
| ❌ | `CalendarMinMax` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.Calendar/sample/sap.ui.unified.sample.CalendarMinMax) | — |
| ❌ | `CalendarMultipleDaySelection` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.Calendar/sample/sap.ui.unified.sample.CalendarMultipleDaySelection) | — |
| ❌ | `CalendarMultipleMonth` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.Calendar/sample/sap.ui.unified.sample.CalendarMultipleMonth) | — |
| ❌ | `CalendarSingleDaySelection` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.Calendar/sample/sap.ui.unified.sample.CalendarSingleDaySelection) | — |
| ❌ | `CalendarSingleIntervalSelection` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.Calendar/sample/sap.ui.unified.sample.CalendarSingleIntervalSelection) | — |
| ❌ | `CalendarSpecialDaysLegend` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.Calendar/sample/sap.ui.unified.sample.CalendarSpecialDaysLegend) | — |
| ❌ | `ColorPicker` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.ColorPicker/sample/sap.ui.unified.sample.ColorPicker) | — |
| ❌ | `ColorPickerLarge` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.ColorPicker/sample/sap.ui.unified.sample.ColorPickerLarge) | — |
| ❌ | `ColorPickerPopover` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.ColorPicker/sample/sap.ui.unified.sample.ColorPickerPopover) | — |
| ❌ | `ColorPickerSimplified` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.ColorPicker/sample/sap.ui.unified.sample.ColorPickerSimplified) | — |
| ✅ | [`Currency`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.unified/z2ui5_cl_api_app_526) | [`z2ui5_cl_api_app_526`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_526.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.Currency/sample/sap.ui.unified.sample.Currency) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_526) |
| ✅ | [`CurrencyInTable`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.unified/z2ui5_cl_api_app_527) | [`z2ui5_cl_api_app_527`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_527.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.Currency/sample/sap.ui.unified.sample.CurrencyInTable) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_527) |
| ❌ | `FileUploaderBasic` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.FileUploader/sample/sap.ui.unified.sample.FileUploaderBasic) | — |
| ❌ | `FileUploaderComplex` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.FileUploader/sample/sap.ui.unified.sample.FileUploaderComplex) | — |
| ❌ | `MenuItemEventing` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.Menu/sample/sap.ui.unified.sample.MenuItemEventing) | — |
| ❌ | `MenuMenuEventing` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.Menu/sample/sap.ui.unified.sample.MenuMenuEventing) | — |
| ❌ | `MenuSelectable` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.Menu/sample/sap.ui.unified.sample.MenuSelectable) | — |

### `sap.ui.table` — 1/18 (5.6 %)

| | Javascript | ABAP | Link | System |
|---|-----------|------|------|--------|
| ❌ | `Aggregations` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.table.Table/sample/sap.ui.table.sample.Aggregations) | — |
| ❌ | `Basic` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.table.Table/sample/sap.ui.table.sample.Basic) | — |
| ❌ | `ColumnResizing` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.table.Table/sample/sap.ui.table.sample.ColumnResizing) | — |
| ❌ | `DnD` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.table.Table/sample/sap.ui.table.sample.DnD) | — |
| ❌ | `Filtering` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.table.Table/sample/sap.ui.table.sample.Filtering) | — |
| ❌ | `Menus` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.table.Table/sample/sap.ui.table.sample.Menus) | — |
| ✅ | [`MultiHeader`](https://github.com/abap2UI5/api/tree/main/ui5/sap.ui.table/z2ui5_cl_api_app_525) | [`z2ui5_cl_api_app_525`](https://github.com/abap2UI5/api/blob/main/src/02/z2ui5_cl_api_app_525.clas.abap) | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.table.Table/sample/sap.ui.table.sample.MultiHeader) | [start ▶](https://your-system.example.com/sap/bc/z2ui5?app_start=Z2UI5_CL_API_APP_525) |
| ❌ | `MultiSelectionPlugin` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.table.Table/sample/sap.ui.table.sample.MultiSelectionPlugin) | — |
| ❌ | `OData` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.table.Table/sample/sap.ui.table.sample.OData) | — |
| ❌ | `OData2` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.table.Table/sample/sap.ui.table.sample.OData2) | — |
| ❌ | `RowAction` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.table.Table/sample/sap.ui.table.sample.RowAction) | — |
| ❌ | `RowHighlights` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.table.Table/sample/sap.ui.table.sample.RowHighlights) | — |
| ❌ | `RowModes` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.table.Table/sample/sap.ui.table.sample.RowModes) | — |
| ❌ | `SelectCopyPaste` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.table.Table/sample/sap.ui.table.sample.SelectCopyPaste) | — |
| ❌ | `Selection` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.table.Table/sample/sap.ui.table.sample.Selection) | — |
| ❌ | `Sorting` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.table.Table/sample/sap.ui.table.sample.Sorting) | — |
| ❌ | `TableFreeze` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.table.Table/sample/sap.ui.table.sample.TableFreeze) | — |
| ❌ | `TreeTable` | — | — | — |

### `sap.ui.codeeditor` — 0/2 (0.0 %)

| | Javascript | ABAP | Link | System |
|---|-----------|------|------|--------|
| ❌ | `CodeEditor` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.codeeditor.CodeEditor/sample/sap.ui.codeeditor.sample.CodeEditor) | — |
| ❌ | `CodeEditorIconTabHeader` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.codeeditor.CodeEditor/sample/sap.ui.codeeditor.sample.CodeEditorIconTabHeader) | — |

### `sap.ui.mdc` — 0/13 (0.0 %)

| | Javascript | ABAP | Link | System |
|---|-----------|------|------|--------|
| ❌ | `Chart` | — | — | — |
| ❌ | `FieldCustomContent` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.mdc.sample.Field/sample/sap.ui.mdc.sample.FieldCustomContent) | — |
| ❌ | `FieldTypes` | — | [demo kit ↗](https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.mdc.sample.Field/sample/sap.ui.mdc.sample.FieldTypes) | — |
| ❌ | `FieldValueHelpJson` | — | — | — |
| ❌ | `FieldValueHelpTypes` | — | — | — |
| ❌ | `FilterbarCustomContent` | — | — | — |
| ❌ | `FilterbarCustomOperators` | — | — | — |
| ❌ | `FilterbarTypes` | — | — | — |
| ❌ | `FilterbarVisualizeValidationState` | — | — | — |
| ❌ | `LinkPayloadJson` | — | — | — |
| ❌ | `MultiValueField` | — | — | — |
| ❌ | `table` | — | — | — |
| ❌ | `TableFilterBarJson` | — | — | — |
