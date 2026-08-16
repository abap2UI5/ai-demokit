CLASS z2ui5_cl_smpc_app_259 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_259 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " Block->content inlining (app 188/217 precedent): every blocks /
    " moreBlocks aggregation of the original holds a SharedBlocks BlockBase
    " control (goals:GoalsBlock, personal:*, employment:*). A BlockBase is only
    " a lazy-loading wrapper around a view, and each of these views is a static
    " SimpleForm (or layout) - so the view content is inlined here 1:1, keeping
    " the block's own class attribute where the original sets one.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:forms`  v = `sap.ui.layout.form`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->ele( `headerTitle`
                )->ele( `ObjectPageDynamicHeaderTitle`
                    )->ele( `expandedHeading`
                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text`     v = `Object Page Header with Progress Indicator and Rating Indicator`
                            )->a( n = `wrapping` v = `true`

                    )->end(

                    )->ele( `snappedHeading`
                        )->ele( n = `HBox` ns = `m`
                            )->ele( n = `VBox` ns = `m`
                                )->tag( n = `Avatar` ns = `m`
                                    )->a( n = `class`        v = `sapUiSmallMarginEnd`
                                    )->a( n = `displayShape` v = `Square`
                                    )->a( n = `initials`     v = `HF`

                            )->end(

                            )->ele( n = `VBox` ns = `m`
                                )->tag( n = `Title` ns = `m`
                                    )->a( n = `text`     v = `Object Page Header with Progress Indicator and Rating Indicator`
                                    )->a( n = `wrapping` v = `true`
                                )->tag( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Example of an ObjectPage with header facet`

                            )->end(
                        )->end(
                    )->end(

                    )->ele( `expandedContent`
                        )->tag( n = `Label` ns = `m`
                            )->a( n = `text` v = `Example of an ObjectPage with header facet`

                    )->end(

                    )->ele( `snappedTitleOnMobile`
                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text` v = `Object Page Header with Progress Indicator and Rating Indicator`

                    )->end(

                    )->ele( `actions`
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `text` v = `Edit`
                            )->a( n = `type` v = `Emphasized`
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `text` v = `Delete`
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `text` v = `Copy`
                        )->tag( n = `OverflowToolbarButton` ns = `m`
                            )->a( n = `icon`    v = `sap-icon://action`
                            )->a( n = `type`    v = `Transparent`
                            )->a( n = `text`    v = `Share`
                            )->a( n = `tooltip` v = `action`

                    )->end(
                )->end(
            )->end(

            )->ele( `headerContent`
                )->ele( n = `FlexBox` ns = `m`
                    )->a( n = `wrap`         v = `Wrap`
                    )->a( n = `fitContainer` v = `true`

                    )->tag( n = `Avatar` ns = `m`
                        )->a( n = `class`        v = `sapUiMediumMarginEnd sapUiSmallMarginBottom`
                        )->a( n = `displayShape` v = `Square`
                        )->a( n = `initials`     v = `HF`
                        )->a( n = `displaySize`  v = `L`

                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

                        )->ele( n = `Title` ns = `m`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`

                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text` v = `Profile`

                        )->end(

                        )->tag( n = `Label` ns = `m`
                            )->a( n = `text` v = `Personal Information`
                        )->tag( n = `ProgressIndicator` ns = `m`
                            )->a( n = `displayValue` v = `42%`
                            )->a( n = `percentValue` v = `42`
                            )->a( n = `state`        v = `Information`

                    )->end(

                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiSmallMarginBottom sapUiLargeMarginEnd`

                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Reliability`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`
                        )->tag( n = `Label` ns = `m`
                            )->a( n = `text` v = `Based on fulfiled contracts`
                        )->tag( n = `RatingIndicator` ns = `m`
                            )->a( n = `value`    v = `4`
                            )->a( n = `iconSize` v = `16px`

                    )->end(

                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `width` v = `448px`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`

                        )->ele( n = `Title` ns = `m`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`

                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text` v = `Product Description`

                        )->end(

                        )->tag( n = `Text` ns = `m`
                            )->a( n = `text` v = `Top-design high-quality coffee mug - ideal for a comforting moment; `
                                              && `Pack: 6; material: Porcelain - durable dishwasher and microwave-safe `
                                              && `porcelain that cleans easily and is ideal for everyday service. `
                                              && `Comes in two bright colors.`

                    )->end(
                )->end(
            )->end(

            )->ele( `sections`
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `id`             v = `goalsSection`
                    )->a( n = `title`          v = `2014 Goals Plan`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `id`             v = `goalsSectionSS1`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`

                                " goals:GoalsBlock inlined
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `class`    v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Evangelize the UI framework across the company`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `4 days overdue Cascaded`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Get trained in development management direction`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Due Nov 21`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Mentor junior developers`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Due Dec 31 Cascaded`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `id`             v = `personalSection`
                    )->a( n = `title`          v = `Personal`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `id`             v = `personalSectionSS1`
                            )->a( n = `title`          v = `Connect`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`

                                " personal:BlockPhoneNumber inlined
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `class`  v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `layout` v = `ColumnLayout`
                                    )->a( n = `width`  v = `100%`

                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Phone Numbers`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Home`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `+ 1 415-321-1234`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Office phone`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `+ 1 415-321-5555`

                                )->end(

                                " personal:BlockSocial inlined
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `labelSpanL`       v = `4`
                                    )->a( n = `labelSpanM`       v = `4`
                                    )->a( n = `labelSpanS`       v = `4`
                                    )->a( n = `emptySpanL`       v = `0`
                                    )->a( n = `emptySpanM`       v = `0`
                                    )->a( n = `emptySpanS`       v = `0`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `width`            v = `100%`

                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Social Accounts`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `LinkedIn`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `/DeniseSmith`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Twitter`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `@DeniseSmith`

                                )->end(

                                " personal:BlockAdresses inlined
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `class`    v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `layout`   v = `ColumnLayout`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `width`    v = `100%`

                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Addresses`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Home Address`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `2096 Mission Street`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Mailing Address`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `PO Box 32114`

                                )->end(

                                " personal:BlockMailing inlined (the block's own
                                " columnLayout='1' is a BlockBase property and
                                " has no counterpart on the inlined form)
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `class`  v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `layout` v = `ColumnLayout`
                                    )->a( n = `width`  v = `100%`

                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Mailing Address`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Work`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `DeniseSmith@sap.com`

                                )->end(
                            )->end(
                        )->end(

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `id`             v = `personalSectionSS2`
                            )->a( n = `title`          v = `Payment information`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`

                                " personal:PersonalBlockPart1 inlined
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `class`    v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Main Payment Method`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Bank Transfer`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Sparkasse Heimfeld, Germany`

                                )->end(
                            )->end(

                            )->ele( `moreBlocks`

                                " personal:PersonalBlockPart2 inlined
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `class`    v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Payment method for Expenses`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Extra Travel Expenses`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Cash 100 USD`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `id`             v = `employmentSection`
                    )->a( n = `title`          v = `Employment`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `id`             v = `employmentSectionSS1`
                            )->a( n = `title`          v = `Job information`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`

                                " employment:BlockJobInfoPart1 inlined
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `labelSpanL`       v = `4`
                                    )->a( n = `labelSpanM`       v = `4`
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `labelSpanS`       v = `4`
                                    )->a( n = `emptySpanL`       v = `0`
                                    )->a( n = `emptySpanM`       v = `0`
                                    )->a( n = `emptySpanS`       v = `0`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `width`            v = `100%`

                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Job classification`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Senior Ui Developer (UIDEV-SR)`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = ` `
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Pay Grade`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Salary Grade 18 (GR-14)`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = ` `
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Job title`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Developer`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = ` `
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Local Job Title`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Ui Developer`

                                )->end(

                                " employment:BlockJobInfoPart2 inlined
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `labelSpanL`       v = `4`
                                    )->a( n = `labelSpanM`       v = `4`
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `labelSpanS`       v = `4`
                                    )->a( n = `emptySpanL`       v = `0`
                                    )->a( n = `emptySpanM`       v = `0`
                                    )->a( n = `emptySpanS`       v = `0`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `width`            v = `100%`

                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Employee Class`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Employee`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = ` `
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `FTE`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `1`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = ` `
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Standard Weekly Hours`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `40`

                                )->end(

                                " employment:BlockJobInfoPart3 inlined
                                )->ele( n = `HorizontalLayout` ns = `layout`
                                    )->a( n = `class` v = `sapUiSmallMarginTop`

                                    )->ele( n = `VerticalLayout` ns = `layout`
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = `Manager`

                                        )->ele( n = `HorizontalLayout` ns = `layout`
                                            )->ele( n = `content` ns = `layout`
                                                )->ele( n = `VerticalLayout` ns = `layout`
                                                    )->tag( n = `Text` ns = `m`
                                                        )->a( n = `text` v = `James Smith`
                                                    )->tag( n = `Text` ns = `m`
                                                        )->a( n = `text` v = `Development Manager`

                                                )->end(
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `id`             v = `employmentSectionSS2`
                            )->a( n = `title`          v = `Employee Details`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`

                                " employment:BlockEmpDetailPart1 inlined
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `labelSpanL`       v = `4`
                                    )->a( n = `labelSpanM`       v = `4`
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `labelSpanS`       v = `4`
                                    )->a( n = `emptySpanL`       v = `0`
                                    )->a( n = `emptySpanM`       v = `0`
                                    )->a( n = `emptySpanS`       v = `0`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `width`            v = `100%`

                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Termination information`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Ok to return`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `No`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Regret Termination`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Yes`

                                )->end(
                            )->end(

                            )->ele( `moreBlocks`

                                " employment:BlockEmpDetailPart2 inlined
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `labelSpanL`       v = `4`
                                    )->a( n = `labelSpanM`       v = `4`
                                    )->a( n = `labelSpanS`       v = `4`
                                    )->a( n = `emptySpanL`       v = `0`
                                    )->a( n = `emptySpanM`       v = `0`
                                    )->a( n = `emptySpanS`       v = `0`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `width`            v = `100%`

                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Start Date`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Jan 01, 2001`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `End Date`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Jun 30, 2014`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Last Date Worked`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Jun 01, 2014`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Payroll End Date`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Jun 01, 2014`

                                )->end(

                                " employment:BlockEmpDetailPart3 inlined
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `labelSpanL`       v = `4`
                                    )->a( n = `labelSpanM`       v = `4`
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `labelSpanS`       v = `4`
                                    )->a( n = `emptySpanL`       v = `0`
                                    )->a( n = `emptySpanM`       v = `0`
                                    )->a( n = `emptySpanS`       v = `0`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `width`            v = `100%`

                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Payroll End Date`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Jan 01, 2014`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Benefits End Date`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Jun 30, 2014`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Stock End Date`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Jun 01, 2014`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Eligible for Salary Contribution`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `No`
                                ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
