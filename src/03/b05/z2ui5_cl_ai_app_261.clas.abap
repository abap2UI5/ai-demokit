CLASS z2ui5_cl_ai_app_261 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA emp1_name TYPE string.
    DATA emp1_job  TYPE string.
    DATA emp2_name TYPE string.
    DATA emp2_job  TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_261 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " Block->content inlining (app 188/217 precedent) plus the named-model fold
    " of app 230: the blocks aggregations hold SharedBlocks BlockBase controls,
    " each a lazy-loading wrapper around a static view - inlined 1:1 below. The
    " EmploymentBlockJob block additionally carries uxap:ModelMapping elements
    " mapping ObjectPageModel>/Employee/N onto internal models empN>; abap2UI5
    " serves one default model, so those are folded onto root fields.
    view->open( n = `View` ns = `mvc`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:forms`  v = `sap.ui.layout.form`

        )->open( `ObjectPageLayout`
            )->a( n = `id`                       v = `ObjectPageLayout`
            )->a( n = `subSectionLayout`         v = `TitleOnLeft`
            )->a( n = `showTitleInHeaderContent` v = `true`
            )->a( n = `upperCaseAnchorBar`       v = `false`

            )->open( `headerTitle`
                )->open( `ObjectPageDynamicHeaderTitle`
                    )->open( `expandedHeading`
                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text`     v = `Denise Smith`
                            )->a( n = `wrapping` v = `true`

                    )->shut(

                    )->open( `snappedHeading`
                        )->open( n = `FlexBox` ns = `m`
                            )->a( n = `fitContainer` v = `true`
                            )->a( n = `alignItems`   v = `Center`

                            )->leaf( n = `Avatar` ns = `m`
                                )->a( n = `src`   v = `sap-icon://picture`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                            )->leaf( n = `Title` ns = `m`
                                )->a( n = `text`     v = `Denise Smith`
                                )->a( n = `wrapping` v = `true`

                        )->shut(
                    )->shut(

                    )->open( `expandedContent`
                        )->leaf( n = `Text` ns = `m`
                            )->a( n = `text` v = `Senior UI Developer`

                    )->shut(

                    )->open( `snappedContent`
                        )->leaf( n = `Text` ns = `m`
                            )->a( n = `text` v = `Senior UI Developer`

                    )->shut(

                    )->open( `snappedTitleOnMobile`
                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text` v = `Senior UI Developer`

                    )->shut(

                    )->open( `actions`
                        )->leaf( n = `Button` ns = `m`
                            )->a( n = `text` v = `Edit`
                            )->a( n = `type` v = `Emphasized`
                        )->leaf( n = `Button` ns = `m`
                            )->a( n = `type` v = `Transparent`
                            )->a( n = `text` v = `Delete`
                        )->leaf( n = `Button` ns = `m`
                            )->a( n = `type` v = `Transparent`
                            )->a( n = `text` v = `Copy`
                        )->leaf( n = `OverflowToolbarButton` ns = `m`
                            )->a( n = `icon`    v = `sap-icon://action`
                            )->a( n = `type`    v = `Transparent`
                            )->a( n = `text`    v = `Share`
                            )->a( n = `tooltip` v = `action`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `headerContent`
                )->open( n = `FlexBox` ns = `m`
                    )->a( n = `wrap`         v = `Wrap`
                    )->a( n = `fitContainer` v = `true`

                    )->leaf( n = `Avatar` ns = `m`
                        )->a( n = `src`         v = `sap-icon://picture`
                        )->a( n = `displaySize` v = `L`
                        )->a( n = `class`       v = `sapUiTinyMarginEnd`

                    )->open( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBeginEnd`

                        )->leaf( n = `Link` ns = `m`
                            )->a( n = `text` v = `+33 6 4512 5158`
                        )->leaf( n = `Link` ns = `m`
                            )->a( n = `text` v = `DeniseSmith@sap.com`

                        )->open( n = `HorizontalLayout` ns = `layout`
                            )->a( n = `class` v = `sapUiSmallMarginEnd`

                            )->leaf( n = `Image` ns = `m`
                                )->a( n = `src` v = `./test-resources/sap/uxap/images/linkedin.png`
                            )->leaf( n = `Image` ns = `m`
                                )->a( n = `src`   v = `./test-resources/sap/uxap/images/Twitter.png`
                                )->a( n = `class` v = `sapUiSmallMarginBegin`

                        )->shut(
                    )->shut(

                    )->open( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBeginEnd`

                        )->leaf( n = `Label` ns = `m`
                            )->a( n = `text` v = `Hello! I am Denise and I use UxAP`

                        )->open( n = `VBox` ns = `m`
                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Achieved goals`
                            )->leaf( n = `ProgressIndicator` ns = `m`
                                )->a( n = `percentValue` v = `30`
                                )->a( n = `displayValue` v = `30%`

                        )->shut(
                    )->shut(

                    )->open( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBeginEnd`

                        )->leaf( n = `Label` ns = `m`
                            )->a( n = `text` v = `San Jose, USA`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `sections`
                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `2014 Goals Plan`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Goal summary`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`

                                " goals:GoalsBlock inlined
                                )->open( n = `SimpleForm` ns = `forms`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Evangelize the UI framework across the company`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `4 days overdue Cascaded`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Get trained in development management direction`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Due Nov 21`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Mentor junior developers`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Due Dec 31 Cascaded`

                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(

                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Personal`

                    )->open( `subSections`

                        " the four Connect blocks sit in the subsection's
                        " default (blocks) aggregation in the original - no
                        " <blocks> tag - so they are added directly here too
                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Connect`
                            )->a( n = `titleUppercase` v = `false`

                            " personal:BlockAdresses inlined
                            )->open( n = `SimpleForm` ns = `forms`
                                )->a( n = `layout`   v = `ColumnLayout`
                                )->a( n = `editable` v = `false`
                                )->a( n = `width`    v = `100%`

                                )->leaf( n = `Title` ns = `core`
                                    )->a( n = `text` v = `Addresses`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Home Address`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `2096 Mission Street`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Mailing Address`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `PO Box 32114`

                            )->shut(

                            " personal:BlockPhoneNumber inlined
                            )->open( n = `SimpleForm` ns = `forms`
                                )->a( n = `layout` v = `ColumnLayout`
                                )->a( n = `width`  v = `100%`

                                )->leaf( n = `Title` ns = `core`
                                    )->a( n = `text` v = `Phone Numbers`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Home`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `+ 1 415-321-1234`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Office phone`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `+ 1 415-321-5555`

                            )->shut(

                            " personal:BlockSocial inlined
                            )->open( n = `SimpleForm` ns = `forms`
                                )->a( n = `editable`         v = `false`
                                )->a( n = `labelSpanL`       v = `4`
                                )->a( n = `labelSpanM`       v = `4`
                                )->a( n = `labelSpanS`       v = `4`
                                )->a( n = `emptySpanL`       v = `0`
                                )->a( n = `emptySpanM`       v = `0`
                                )->a( n = `emptySpanS`       v = `0`
                                )->a( n = `maxContainerCols` v = `2`
                                )->a( n = `width`            v = `100%`

                                )->leaf( n = `Title` ns = `core`
                                    )->a( n = `text` v = `Social Accounts`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `LinkedIn`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `/DeniseSmith`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Twitter`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `@DeniseSmith`

                            )->shut(

                            " personal:BlockMailing inlined
                            )->open( n = `SimpleForm` ns = `forms`
                                )->a( n = `layout` v = `ColumnLayout`
                                )->a( n = `width`  v = `100%`

                                )->leaf( n = `Title` ns = `core`
                                    )->a( n = `text` v = `Mailing Address`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Work`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `DeniseSmith@sap.com`

                            )->shut(
                        )->shut(

                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Payment information`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`

                                " personal:PersonalBlockPart1 inlined
                                )->open( n = `SimpleForm` ns = `forms`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->leaf( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Main Payment Method`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Bank Transfer`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Sparkasse Heimfeld, Germany`

                                )->shut(
                            )->shut(

                            )->open( `moreBlocks`

                                " personal:PersonalBlockPart2 inlined
                                )->open( n = `SimpleForm` ns = `forms`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->leaf( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Payment method for Expenses`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Extra Travel Expenses`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Cash 100 USD`

                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(

                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Employment`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Job information`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`

                                " employment:BlockJobInfoPart1 inlined
                                )->open( n = `SimpleForm` ns = `forms`
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

                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Job classification`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Senior Ui Developer (UIDEV-SR)`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = ` `
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Pay Grade`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Salary Grade 18 (GR-14)`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = ` `
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Job title`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Developer`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = ` `
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Local Job Title`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Ui Developer`

                                )->shut(

                                " employment:BlockJobInfoPart2 inlined
                                )->open( n = `SimpleForm` ns = `forms`
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

                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Employee Class`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Employee`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = ` `
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `FTE`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `1`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = ` `
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Standard Weekly Hours`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `40`

                                )->shut(

                                " employment:BlockJobInfoPart3 inlined
                                )->open( n = `HorizontalLayout` ns = `layout`
                                    )->a( n = `class` v = `sapUiSmallMarginTop`

                                    )->open( n = `VerticalLayout` ns = `layout`
                                        )->leaf( n = `Label` ns = `m`
                                            )->a( n = `text` v = `Manager`

                                        )->open( n = `HorizontalLayout` ns = `layout`
                                            )->open( n = `content` ns = `layout`
                                                )->open( n = `VerticalLayout` ns = `layout`
                                                    )->leaf( n = `Text` ns = `m`
                                                        )->a( n = `text` v = `James Smith`
                                                    )->leaf( n = `Text` ns = `m`
                                                        )->a( n = `text` v = `Development Manager`

                                                )->shut(
                                            )->shut(
                                        )->shut(
                                    )->shut(
                                )->shut(
                            )->shut(
                        )->shut(

                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Employee Details`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`

                                " employment:BlockEmpDetailPart1 inlined
                                )->open( n = `SimpleForm` ns = `forms`
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

                                    )->leaf( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Termination information`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Ok to return`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `No`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Regret Termination`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Yes`

                                )->shut(
                            )->shut(

                            )->open( `moreBlocks`

                                " employment:BlockEmpDetailPart2 inlined
                                )->open( n = `SimpleForm` ns = `forms`
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

                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Start Date`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Jan 01, 2001`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `End Date`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Jun 30, 2014`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Last Date Worked`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Jun 01, 2014`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Payroll End Date`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Jun 01, 2014`

                                )->shut(

                                " employment:BlockEmpDetailPart3 inlined
                                )->open( n = `SimpleForm` ns = `forms`
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

                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Payroll End Date`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Jan 01, 2014`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Benefits End Date`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Jun 30, 2014`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Stock End Date`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Jun 01, 2014`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Eligible for Salary Contribution`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `No`

                                )->shut(
                            )->shut(
                        )->shut(

                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Job Relationship`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`

                                " employment:EmploymentBlockJob inlined with its
                                " Collapsed view (the block's initial mode); the
                                " empN> models fold onto the default-model root
                                )->open( n = `Grid` ns = `layout`
                                    )->a( n = `defaultSpan` v = `L4 M6 S12`
                                    )->a( n = `hSpacing`    v = `0`
                                    )->a( n = `width`       v = `100%`

                                    )->open( n = `content` ns = `layout`
                                        )->open( n = `VerticalLayout` ns = `layout`
                                            )->open( n = `HorizontalLayout` ns = `layout`
                                                )->open( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->open( n = `content` ns = `layout`
                                                        )->open( n = `VerticalLayout` ns = `layout`
                                                            )->leaf( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_name )
                                                            )->leaf( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_job )

                                                            )->open( n = `layoutData` ns = `layout`
                                                                )->leaf( n = `GridData` ns = `layout`
                                                                    )->a( n = `span` v = `L12 M12 S12`

                                                            )->shut(
                                                        )->shut(
                                                    )->shut(
                                                )->shut(
                                            )->shut(

                                            )->open( n = `layoutData` ns = `layout`
                                                )->leaf( n = `GridData` ns = `layout`
                                                    )->a( n = `linebreak` v = `true`

                                            )->shut(

                                            )->open( n = `HorizontalLayout` ns = `layout`
                                                )->open( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->open( n = `VerticalLayout` ns = `layout`
                                                        )->leaf( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_name )
                                                        )->leaf( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_job )

                                                        )->open( n = `layoutData` ns = `layout`
                                                            )->leaf( n = `GridData` ns = `layout`
                                                                )->a( n = `span` v = `L12 M12 S12`

                                                        ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " ObjectPageModel>/Employee rows 0 and 1, the two records the block's
    " uxap:ModelMapping elements map onto the internal models emp1> / emp2>
    emp1_name = `Michael Adams`.
    emp1_job  = `Scrum Master`.
    emp2_name = `John Miller`.
    emp2_job  = `Product Owner`.

  ENDMETHOD.

ENDCLASS.
