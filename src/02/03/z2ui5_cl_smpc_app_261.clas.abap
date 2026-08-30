" @keywords objectpagelayout object layout sap.uxap objectpagetitleonleft objectpagedynamicheadertitle title flexbox avatar text button overflowtoolbarbutton
" @summary Object Page sample showing a layout with subsection titles on the left.
CLASS z2ui5_cl_smpc_app_261 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_employee,
        name TYPE string,
        job  TYPE string,
      END OF ty_s_employee.

    DATA t_employees TYPE STANDARD TABLE OF ty_s_employee WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_261 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " Block->content inlining (app 188/217 precedent) plus the named-model fold
    " of app 230: the blocks aggregations hold SharedBlocks BlockBase controls,
    " each a lazy-loading wrapper around a static view - inlined 1:1 below. The
    " EmploymentBlockJob block additionally carries uxap:ModelMapping elements
    " mapping ObjectPageModel>/Employee/N onto internal models empN>; abap2UI5
    " serves one default model, so those fold onto one table addressed per row.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:forms`  v = `sap.ui.layout.form`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                       v = `ObjectPageLayout`
            )->a( n = `subSectionLayout`         v = `TitleOnLeft`
            )->a( n = `showTitleInHeaderContent` v = `true`
            )->a( n = `upperCaseAnchorBar`       v = `false`

            )->ele( `headerTitle`
                )->ele( `ObjectPageDynamicHeaderTitle`
                    )->ele( `expandedHeading`
                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text`     v = `Denise Smith`
                            )->a( n = `wrapping` v = `true`

                    )->end(

                    )->ele( `snappedHeading`
                        )->ele( n = `FlexBox` ns = `m`
                            )->a( n = `fitContainer` v = `true`
                            )->a( n = `alignItems`   v = `Center`

                            )->tag( n = `Avatar` ns = `m`
                                )->a( n = `src`   v = `sap-icon://picture`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                            )->tag( n = `Title` ns = `m`
                                )->a( n = `text`     v = `Denise Smith`
                                )->a( n = `wrapping` v = `true`

                        )->end(
                    )->end(

                    )->ele( `expandedContent`
                        )->tag( n = `Text` ns = `m`
                            )->a( n = `text` v = `Senior UI Developer`

                    )->end(

                    )->ele( `snappedContent`
                        )->tag( n = `Text` ns = `m`
                            )->a( n = `text` v = `Senior UI Developer`

                    )->end(

                    )->ele( `snappedTitleOnMobile`
                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text` v = `Senior UI Developer`

                    )->end(

                    )->ele( `actions`
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `text` v = `Edit`
                            )->a( n = `type` v = `Emphasized`
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `type` v = `Transparent`
                            )->a( n = `text` v = `Delete`
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `type` v = `Transparent`
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
                        )->a( n = `src`         v = `sap-icon://picture`
                        )->a( n = `displaySize` v = `L`
                        )->a( n = `class`       v = `sapUiTinyMarginEnd`

                    )->ele( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBeginEnd`

                        )->tag( n = `Link` ns = `m`
                            )->a( n = `text` v = `+33 6 4512 5158`
                        )->tag( n = `Link` ns = `m`
                            )->a( n = `text` v = `DeniseSmith@sap.com`

                        )->ele( n = `HorizontalLayout` ns = `layout`
                            )->a( n = `class` v = `sapUiSmallMarginEnd`

                            )->tag( n = `Image` ns = `m`
                                )->a( n = `src` v = `https://sdk.openui5.org/test-resources/sap/uxap/images/linkedin.png`
                            )->tag( n = `Image` ns = `m`
                                )->a( n = `src`   v = `https://sdk.openui5.org/test-resources/sap/uxap/images/Twitter.png`
                                )->a( n = `class` v = `sapUiSmallMarginBegin`

                        )->end(
                    )->end(

                    )->ele( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBeginEnd`

                        )->tag( n = `Label` ns = `m`
                            )->a( n = `text` v = `Hello! I am Denise and I use UxAP`

                        )->ele( n = `VBox` ns = `m`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Achieved goals`
                            )->tag( n = `ProgressIndicator` ns = `m`
                                )->a( n = `percentValue` v = `30`
                                )->a( n = `displayValue` v = `30%`

                        )->end(
                    )->end(

                    )->ele( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBeginEnd`

                        )->tag( n = `Label` ns = `m`
                            )->a( n = `text` v = `San Jose, USA`

                    )->end(
                )->end(
            )->end(

            )->ele( `sections`
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `2014 Goals Plan`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Goal summary`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`

                                " goals:GoalsBlock inlined
                                )->ele( n = `SimpleForm` ns = `forms`
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
                    )->a( n = `title`          v = `Personal`

                    )->ele( `subSections`

                        " the four Connect blocks sit in the subsection's
                        " default (blocks) aggregation in the original - no
                        " <blocks> tag - so they are added directly here too
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Connect`
                            )->a( n = `titleUppercase` v = `false`

                            " personal:BlockAdresses inlined
                            )->ele( n = `SimpleForm` ns = `forms`
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

                            " personal:BlockPhoneNumber inlined
                            )->ele( n = `SimpleForm` ns = `forms`
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

                            " personal:BlockMailing inlined
                            )->ele( n = `SimpleForm` ns = `forms`
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

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Payment information`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`

                                " personal:PersonalBlockPart1 inlined
                                )->ele( n = `SimpleForm` ns = `forms`
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
                    )->a( n = `title`          v = `Employment`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Job information`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`

                                " employment:BlockJobInfoPart1 inlined
                                )->ele( n = `SimpleForm` ns = `forms`
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
                            )->a( n = `title`          v = `Employee Details`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`

                                " employment:BlockEmpDetailPart1 inlined
                                )->ele( n = `SimpleForm` ns = `forms`
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

                                )->end(
                            )->end(
                        )->end(

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Job Relationship`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`

                                " employment:EmploymentBlockJob inlined with its
                                " Collapsed view (the block's initial mode); the
                                " empN> models are the rows of one table
                                )->ele( n = `Grid` ns = `layout`
                                    )->a( n = `defaultSpan` v = `L4 M6 S12`
                                    )->a( n = `hSpacing`    v = `0`
                                    )->a( n = `width`       v = `100%`

                                    )->ele( n = `content` ns = `layout`
                                        )->ele( n = `VerticalLayout` ns = `layout`
                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `content` ns = `layout`
                                                        )->ele( n = `VerticalLayout` ns = `layout`
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( val = t_employees[ 1 ]-name tab = t_employees tab_index = 1 )
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( val = t_employees[ 1 ]-job tab = t_employees tab_index = 1 )

                                                            )->ele( n = `layoutData` ns = `layout`
                                                                )->tag( n = `GridData` ns = `layout`
                                                                    )->a( n = `span` v = `L12 M12 S12`

                                                            )->end(
                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(

                                            )->ele( n = `layoutData` ns = `layout`
                                                )->tag( n = `GridData` ns = `layout`
                                                    )->a( n = `linebreak` v = `true`

                                            )->end(

                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `VerticalLayout` ns = `layout`
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( val = t_employees[ 2 ]-name tab = t_employees tab_index = 2 )
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( val = t_employees[ 2 ]-job tab = t_employees tab_index = 2 )

                                                        )->ele( n = `layoutData` ns = `layout`
                                                            )->tag( n = `GridData` ns = `layout`
                                                                )->a( n = `span` v = `L12 M12 S12`

                                                        ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " ObjectPageModel>/Employee rows 0 and 1, the two records the block's
    " uxap:ModelMapping elements map onto the internal models emp1> / emp2>
    t_employees = VALUE #(
      ( name = `Michael Adams`
        job  = `Scrum Master` )
      ( name = `John Miller`
        job  = `Product Owner` ) ).

  ENDMETHOD.

ENDCLASS.
