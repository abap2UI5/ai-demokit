" @keywords objectpagelayout object layout sap.uxap objectpagestate objectpagedynamicheadertitle title flexbox avatar text button overflowtoolbarbutton
" @summary This example shows how the page can be accessed directly to a specific vertical position, with "See More" enabled
CLASS z2ui5_cl_smpc_app_595 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_employee,
        name    TYPE string,
        job     TYPE string,
        picture TYPE string,
      END OF ty_s_employee.

    TYPES: BEGIN OF ty_s_product,
             productid    TYPE string,
             " the field the rows binding's sorter uses; no column shows it
             name         TYPE string,
             suppliername TYPE string,
             category     TYPE string,
             price        TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    DATA t_products TYPE ty_t_product.

    DATA t_employees TYPE STANDARD TABLE OF ty_s_employee WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_595 IMPLEMENTATION.

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

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:forms`  v = `sap.ui.layout.form`
        )->a( n = `xmlns:ui`     v = `sap.ui.table`
        )->a( n = `xmlns:uirm`   v = `sap.ui.table.rowmodes`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                       v = `ObjectPageLayout`
            )->a( n = `showTitleInHeaderContent` v = `true`
            " the page opens on the Payment information SUBSECTION, set by id
            )->a( n = `selectedSection`          v = `paymentSubSection`
            )->a( n = `useIconTabBar`            v = `true`
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
                                )->a( n = `src`   v = `https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_275314.png`
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
                        )->a( n = `class`       v = `sapUiSmallMarginEnd`
                        )->a( n = `src`         v = `https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_275314.png`
                        )->a( n = `displaySize` v = `L`

                    )->ele( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBeginEnd`

                        )->tag( n = `Link` ns = `m`
                            )->a( n = `text` v = `+33 6 4512 5158`
                        )->tag( n = `Link` ns = `m`
                            )->a( n = `text` v = `DeniseSmith@sap.com`

                    )->end(

                    )->ele( n = `HorizontalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBeginEnd`

                        )->tag( n = `Image` ns = `m`
                            )->a( n = `src` v = `https://sdk.openui5.org/test-resources/sap/uxap/images/linkedin.png`
                        )->tag( n = `Image` ns = `m`
                            )->a( n = `src`   v = `https://sdk.openui5.org/test-resources/sap/uxap/images/Twitter.png`
                            )->a( n = `class` v = `sapUiSmallMarginBegin`

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
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Connect`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`

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
                        )->end(

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `id`             v = `paymentSubSection`
                            )->a( n = `title`          v = `Payment information`
                            )->a( n = `mode`           v = `Expanded`
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

                                " employment:EmploymentBlockJob inlined
                                " with its Collapsed view (the block's
                                " initial mode); emp1>/emp2> are rows
                                " 1-2 of the one seeded table
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

                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Table information`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Personal Belongings`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( n = `Table` ns = `ui`
                                    )->a( n = `id`   v = `idProductsTable`
                                    )->a( n = `rows` v = client->_bind( t_products )

                                    )->ele( n = `rowMode` ns = `ui`
                                        )->tag( n = `Auto` ns = `uirm`
                                            )->a( n = `minRowCount` v = `2`
                                    )->end(

                                    )->ele( n = `columns` ns = `ui`
                                        )->ele( n = `Column` ns = `ui`
                                            )->a( n = `label` v = `Product`
                                            )->ele( n = `template` ns = `ui`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = `{PRODUCTID}`
                                            )->end(
                                        )->end(
                                        )->ele( n = `Column` ns = `ui`
                                            )->a( n = `label` v = `Supplier`
                                            )->ele( n = `template` ns = `ui`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = `{SUPPLIERNAME}`
                                            )->end(
                                        )->end(
                                        )->ele( n = `Column` ns = `ui`
                                            )->a( n = `label` v = `Category`
                                            )->ele( n = `template` ns = `ui`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = `{CATEGORY}`
                                            )->end(
                                        )->end(
                                        )->ele( n = `Column` ns = `ui`
                                            )->a( n = `label` v = `Price`
                                            )->ele( n = `template` ns = `ui`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = `{PRICE}`
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " SharedJSONData/HRData.json /Employee rows 0-5, the records the block
    " ModelMapping elements map onto the internal models emp1>..emp6> - one
    " table, so the model keeps the array shape the original addresses and the
    " view addresses it per row (client->_bind( tab / tab_index ))
    t_employees = VALUE #(
      ( name    = `Michael Adams`
        job     = `Scrum Master`
        picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png` )
      ( name    = `John Miller`
        job     = `Product Owner`
        picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png` )
      ( name    = `Richard Wilson`
        job     = `Ux Designer`
        picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png` )
      ( name    = `Julie Armstrong`
        job     = `Quality Engineer`
        picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png` )
      ( name    = `Denise Smith`
        job     = `Team Member`
        picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png` )
      ( name    = `Richard Adams`
        job     = `Team Member`
        picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png` ) ).

    " sap/ui/demo/mock/products.json /ProductCollection, already in the order the
    " rows binding's sorter puts it in (path 'Name', ascending) - a thin frontend
    " sorts the data it sends (app 298 idiom)
    " sap/ui/demo/mock/products.json /ProductCollection, seeded verbatim in the
    " file's own order and then put into the order the rows binding's sorter
    " asks for (path 'Name') - a thin frontend sorts the data it sends (app 298)
    t_products = VALUE #(
      ( productid = `HT-1000` name = `Notebook Basic 15`                                  suppliername = `Very Best Screens` category = `Laptops`                     price = `956` )
      ( productid = `HT-1001` name = `Notebook Basic 17`                                  suppliername = `Very Best Screens` category = `Laptops`                     price = `1249` )
      ( productid = `HT-1002` name = `Notebook Basic 18`                                  suppliername = `Very Best Screens` category = `Laptops`                     price = `1570` )
      ( productid = `HT-1003` name = `Notebook Basic 19`                                  suppliername = `Smartcards`        category = `Laptops`                     price = `1650` )
      ( productid = `HT-1007` name = `ITelO Vault`                                        suppliername = `Technocom`         category = `Accessories`                 price = `299` )
      ( productid = `HT-1010` name = `Notebook Professional 15`                           suppliername = `Very Best Screens` category = `Accessories`                 price = `1999` )
      ( productid = `HT-1011` name = `Notebook Professional 17`                           suppliername = `Very Best Screens` category = `Laptops`                     price = `2299` )
      ( productid = `HT-1020` name = `ITelO Vault Net`                                    suppliername = `Technocom`         category = `Accessories`                 price = `459` )
      ( productid = `HT-1021` name = `ITelO Vault SAT`                                    suppliername = `Technocom`         category = `Accessories`                 price = `149` )
      ( productid = `HT-1022` name = `Comfort Easy`                                       suppliername = `Technocom`         category = `Accessories`                 price = `1679` )
      ( productid = `HT-1023` name = `Comfort Senior`                                     suppliername = `Technocom`         category = `Accessories`                 price = `512` )
      ( productid = `HT-1030` name = `Ergo Screen E-I`                                    suppliername = `Very Best Screens` category = `Flat Screen Monitors`        price = `230` )
      ( productid = `HT-1031` name = `Ergo Screen E-II`                                   suppliername = `Very Best Screens` category = `Flat Screen Monitors`        price = `285` )
      ( productid = `HT-1032` name = `Ergo Screen E-III`                                  suppliername = `Very Best Screens` category = `Flat Screen Monitors`        price = `345` )
      ( productid = `HT-1035` name = `Flat Basic`                                         suppliername = `Very Best Screens` category = `Flat Screen Monitors`        price = `399` )
      ( productid = `HT-1036` name = `Flat Future`                                        suppliername = `Very Best Screens` category = `Flat Screen Monitors`        price = `430` )
      ( productid = `HT-1037` name = `Flat XL`                                            suppliername = `Very Best Screens` category = `Flat Screen Monitors`        price = `1230` )
      ( productid = `HT-1040` name = `Laser Professional Eco`                             suppliername = `Alpha Printers`    category = `Printers`                    price = `830` )
      ( productid = `HT-1041` name = `Laser Basic`                                        suppliername = `Alpha Printers`    category = `Printers`                    price = `490` )
      ( productid = `HT-1042` name = `Laser Allround`                                     suppliername = `Alpha Printers`    category = `Printers`                    price = `349` )
      ( productid = `HT-1050` name = `Ultra Jet Super Color`                              suppliername = `Alpha Printers`    category = `Printers`                    price = `139` )
      ( productid = `HT-1051` name = `Ultra Jet Mobile`                                   suppliername = `Printer for All`   category = `Printers`                    price = `99` )
      ( productid = `HT-1052` name = `Ultra Jet Super Highspeed`                          suppliername = `Printer for All`   category = `Printers`                    price = `170` )
      ( productid = `HT-1055` name = `Multi Print`                                        suppliername = `Printer for All`   category = `Multifunction Printers`      price = `99` )
      ( productid = `HT-1056` name = `Multi Color`                                        suppliername = `Printer for All`   category = `Multifunction Printers`      price = `119` )
      ( productid = `HT-1060` name = `Cordless Mouse`                                     suppliername = `Oxynum`            category = `Mice`                        price = `9` )
      ( productid = `HT-1061` name = `Speed Mouse`                                        suppliername = `Oxynum`            category = `Mice`                        price = `7` )
      ( productid = `HT-1062` name = `Track Mouse`                                        suppliername = `Oxynum`            category = `Mice`                        price = `11` )
      ( productid = `HT-1063` name = `Ergonomic Keyboard`                                 suppliername = `Oxynum`            category = `Keyboards`                   price = `14` )
      ( productid = `HT-1064` name = `Internet Keyboard`                                  suppliername = `Oxynum`            category = `Keyboards`                   price = `16` )
      ( productid = `HT-1065` name = `Media Keyboard`                                     suppliername = `Oxynum`            category = `Keyboards`                   price = `26` )
      ( productid = `HT-1066` name = `Mousepad`                                           suppliername = `Oxynum`            category = `Mousepads`                   price = `6.99` )
      ( productid = `HT-1067` name = `Ergo Mousepad`                                      suppliername = `Oxynum`            category = `Mousepads`                   price = `8.99` )
      ( productid = `HT-1068` name = `Designer Mousepad`                                  suppliername = `Fasttech`          category = `Mousepads`                   price = `12.99` )
      ( productid = `HT-1069` name = `Universal card reader`                              suppliername = `Fasttech`          category = `Computer System Accessories` price = `14` )
      ( productid = `HT-1070` name = `Proctra X`                                          suppliername = `Ultrasonic United` category = `Graphic Cards`               price = `70.9` )
      ( productid = `HT-1071` name = `Gladiator MX`                                       suppliername = `Ultrasonic United` category = `Graphic Cards`               price = `81.7` )
      ( productid = `HT-1072` name = `Hurricane GX`                                       suppliername = `Ultrasonic United` category = `Graphic Cards`               price = `101.2` )
      ( productid = `HT-1073` name = `Hurricane GX/LN`                                    suppliername = `Smartcards`        category = `Graphic Cards`               price = `139.99` )
      ( productid = `HT-1080` name = `Photo Scan`                                         suppliername = `Printer for All`   category = `Scanners`                    price = `129` )
      ( productid = `HT-1081` name = `Power Scan`                                         suppliername = `Printer for All`   category = `Scanners`                    price = `89` )
      ( productid = `HT-1082` name = `Jet Scan Professional`                              suppliername = `Printer for All`   category = `Scanners`                    price = `169` )
      ( productid = `HT-1083` name = `Jet Scan Professional`                              suppliername = `Printer for All`   category = `Scanners`                    price = `189` )
      ( productid = `HT-1085` name = `Copymaster`                                         suppliername = `Alpha Printers`    category = `Multifunction Printers`      price = `1499` )
      ( productid = `HT-1090` name = `Surround Sound`                                     suppliername = `Speaker Experts`   category = `Speakers`                    price = `39` )
      ( productid = `HT-1091` name = `Blaster Extreme`                                    suppliername = `Speaker Experts`   category = `Speakers`                    price = `26` )
      ( productid = `HT-1092` name = `Sound Booster`                                      suppliername = `Speaker Experts`   category = `Speakers`                    price = `45` )
      ( productid = `HT-1095` name = `Lovely Sound 5.1 Wireless`                          suppliername = `Fasttech`          category = `Accessories`                 price = `49` )
      ( productid = `HT-1096` name = `Lovely Sound 5.1`                                   suppliername = `Fasttech`          category = `Accessories`                 price = `39` )
      ( productid = `HT-1097` name = `Lovely Sound Stereo`                                suppliername = `Fasttech`          category = `Accessories`                 price = `29` )
      ( productid = `HT-1100` name = `Smart Office`                                       suppliername = `Technocom`         category = `Software`                    price = `89.9` )
      ( productid = `HT-1101` name = `Smart Design`                                       suppliername = `Technocom`         category = `Software`                    price = `79.9` )
      ( productid = `HT-1102` name = `Smart Network`                                      suppliername = `Technocom`         category = `Software`                    price = `69` )
      ( productid = `HT-1103` name = `Smart Multimedia`                                   suppliername = `Technocom`         category = `Software`                    price = `77` )
      ( productid = `HT-1104` name = `Smart Games`                                        suppliername = `Technocom`         category = `Software`                    price = `55` )
      ( productid = `HT-1105` name = `Smart Internet Antivirus`                           suppliername = `Brainsoft`         category = `Software`                    price = `29` )
      ( productid = `HT-1106` name = `Smart Firewall`                                     suppliername = `Brainsoft`         category = `Software`                    price = `34` )
      ( productid = `HT-1107` name = `Smart Money`                                        suppliername = `Brainsoft`         category = `Software`                    price = `29.9` )
      ( productid = `HT-1110` name = `PC Lock`                                            suppliername = `Red Point Stores`  category = `Computer System Accessories` price = `8.9` )
      ( productid = `HT-1111` name = `Notebook Lock`                                      suppliername = `Red Point Stores`  category = `Computer System Accessories` price = `6.9` )
      ( productid = `HT-1112` name = `Web cam reality`                                    suppliername = `Red Point Stores`  category = `Computer System Accessories` price = `39` )
      ( productid = `HT-1113` name = `Screen clean`                                       suppliername = `Red Point Stores`  category = `Computer System Accessories` price = `2.3` )
      ( productid = `HT-1114` name = `Fabric bag professional`                            suppliername = `Red Point Stores`  category = `Computer System Accessories` price = `31` )
      ( productid = `HT-1115` name = `Wireless DSL Router`                                suppliername = `Red Point Stores`  category = `Telecommunications`          price = `49` )
      ( productid = `HT-1116` name = `Wireless DSL Router / Repeater`                     suppliername = `Red Point Stores`  category = `Telecommunications`          price = `59` )
      ( productid = `HT-1117` name = `Wireless DSL Router / Repeater and Print Server`    suppliername = `Technocom`         category = `Telecommunications`          price = `69` )
      ( productid = `HT-1118` name = `USB Stick`                                          suppliername = `Technocom`         category = `Computer System Accessories` price = `35` )
      ( productid = `HT-1119` name = `Travel Adapter`                                     suppliername = `Titanium`          category = `Accessories`                 price = `79` )
      ( productid = `HT-1120` name = `Cordless Bluetooth Keyboard, english international` suppliername = `Technocom`         category = `Keyboards`                   price = `29` )
      ( productid = `HT-1137` name = `Flat XXL`                                           suppliername = `Technocom`         category = `Flat Screen Monitors`        price = `1430` )
      ( productid = `HT-1138` name = `Pocket Mouse`                                       suppliername = `Technocom`         category = `Mice`                        price = `23` )
      ( productid = `HT-1210` name = `PC Power Station`                                   suppliername = `Technocom`         category = `PCs`                         price = `2399` )
      ( productid = `HT-1251` name = `Astro Laptop 1516`                                  suppliername = `Ultrasonic United` category = `Laptops`                     price = `989` )
      ( productid = `HT-1252` name = `Astro Phone 6`                                      suppliername = `Ultrasonic United` category = `Smartphones and Tablets`     price = `649` )
      ( productid = `HT-1253` name = `Benda Laptop 1408`                                  suppliername = `Ultrasonic United` category = `Laptops`                     price = `976` )
      ( productid = `HT-1254` name = `Bending Screen 21HD`                                suppliername = `Ultrasonic United` category = `Flat Screens`                price = `250` )
      ( productid = `HT-1255` name = `Broad Screen 22HD`                                  suppliername = `Ultrasonic United` category = `Flat Screens`                price = `270` )
      ( productid = `HT-1256` name = `Cerdik Phone 7`                                     suppliername = `Ultrasonic United` category = `Smartphones and Tablets`     price = `549` )
      ( productid = `HT-1257` name = `Cepat Tablet 10.5`                                  suppliername = `Ultrasonic United` category = `Smartphones and Tablets`     price = `549` )
      ( productid = `HT-1258` name = `Cepat Tablet 8`                                     suppliername = `Ultrasonic United` category = `Smartphones and Tablets`     price = `529` )
      ( productid = `HT-1500` name = `Server Basic`                                       suppliername = `Technocom`         category = `Servers`                     price = `5000` )
      ( productid = `HT-1501` name = `Server Professional`                                suppliername = `Technocom`         category = `Servers`                     price = `15000` )
      ( productid = `HT-1502` name = `Server Power Pro`                                   suppliername = `Technocom`         category = `Servers`                     price = `25000` )
      ( productid = `HT-1600` name = `Family PC Basic`                                    suppliername = `Titanium`          category = `Desktop Computers`           price = `600` )
      ( productid = `HT-1601` name = `Family PC Pro`                                      suppliername = `Titanium`          category = `Desktop Computers`           price = `900` )
      ( productid = `HT-1602` name = `Gaming Monster`                                     suppliername = `Titanium`          category = `Desktop Computers`           price = `1200` )
      ( productid = `HT-1603` name = `Gaming Monster Pro`                                 suppliername = `Titanium`          category = `Desktop Computers`           price = `1700` )
      ( productid = `HT-2000` name = `7" Widescreen Portable DVD Player w MP3`            suppliername = `Titanium`          category = `Accessories`                 price = `249.99` )
      ( productid = `HT-2001` name = `10" Portable DVD player`                            suppliername = `Titanium`          category = `Accessories`                 price = `449.99` )
      ( productid = `HT-2002` name = `Portable DVD Player with 9" LCD Monitor`            suppliername = `Technocom`         category = `Accessories`                 price = `853.99` )
      ( productid = `HT-2025` name = `CD/DVD case: 264 sleeves`                           suppliername = `Titanium`          category = `Accessories`                 price = `44.99` )
      ( productid = `HT-2026` name = `Audio/Video Cable Kit - 4m`                         suppliername = `Titanium`          category = `Accessories`                 price = `29.99` )
      ( productid = `HT-2027` name = `Removable CD/DVD Laser Labels`                      suppliername = `Titanium`          category = `Accessories`                 price = `8.99` )
      ( productid = `HT-6100` name = `Beam Breaker B-1`                                   suppliername = `Titanium`          category = `Accessories`                 price = `469` )
      ( productid = `HT-6101` name = `Beam Breaker B-2`                                   suppliername = `Technocom`         category = `Accessories`                 price = `679` )
      ( productid = `HT-6102` name = `Beam Breaker B-3`                                   suppliername = `Technocom`         category = `Accessories`                 price = `889` )
      ( productid = `HT-6110` name = `Play Movie`                                         suppliername = `Fasttech`          category = `Accessories`                 price = `130` )
      ( productid = `HT-6111` name = `Record Movie`                                       suppliername = `Fasttech`          category = `Accessories`                 price = `288` )
      ( productid = `HT-6120` name = `ITelo MusicStick`                                   suppliername = `Fasttech`          category = `Accessories`                 price = `45` )
      ( productid = `HT-6121` name = `ITelo Jog-Mate`                                     suppliername = `Fasttech`          category = `Accessories`                 price = `63` )
      ( productid = `HT-6122` name = `Power Pro Player 40`                                suppliername = `Fasttech`          category = `Accessories`                 price = `167` )
      ( productid = `HT-6123` name = `Power Pro Player 80`                                suppliername = `Fasttech`          category = `Accessories`                 price = `299` )
      ( productid = `HT-6130` name = `Flat Watch HD32`                                    suppliername = `Very Best Screens` category = `Flat Screen TVs`             price = `1459` )
      ( productid = `HT-6131` name = `Flat Watch HD37`                                    suppliername = `Very Best Screens` category = `Flat Screen TVs`             price = `1199` )
      ( productid = `HT-6132` name = `Flat Watch HD41`                                    suppliername = `Very Best Screens` category = `Flat Screen TVs`             price = `899` )
      ( productid = `HT-7000` name = `Copperberry`                                        suppliername = `Fasttech`          category = `Accessories`                 price = `549` )
      ( productid = `HT-7010` name = `Silverberry`                                        suppliername = `Fasttech`          category = `Accessories`                 price = `549` )
      ( productid = `HT-7020` name = `Goldberry`                                          suppliername = `Fasttech`          category = `Accessories`                 price = `549` )
      ( productid = `HT-7030` name = `Platinberry`                                        suppliername = `Fasttech`          category = `Accessories`                 price = `549` )
      ( productid = `HT-8000` name = `ITelO FlexTop I4000`                                suppliername = `Titanium`          category = `Laptops`                     price = `799` )
      ( productid = `HT-8001` name = `ITelO FlexTop I6300c`                               suppliername = `Titanium`          category = `Laptops`                     price = `799` )
      ( productid = `HT-8002` name = `ITelO FlexTop I9100`                                suppliername = `Titanium`          category = `Laptops`                     price = `1199` )
      ( productid = `HT-8003` name = `ITelO FlexTop I9800`                                suppliername = `Titanium`          category = `Laptops`                     price = `1388` )
      ( productid = `HT-9991` name = `Smartphone Leather Case`                            suppliername = `Ultrasonic United` category = `Accessories`                 price = `25` )
      ( productid = `HT-9992` name = `Smartphone Alpha`                                   suppliername = `Ultrasonic United` category = `Smartphones and Tablets`     price = `599` )
      ( productid = `HT-9993` name = `Mini Tablet`                                        suppliername = `Ultrasonic United` category = `Smartphones and Tablets`     price = `833` )
      ( productid = `HT-9994` name = `Camcorder View`                                     suppliername = `Ultrasonic United` category = `Accessories`                 price = `1388` )
      ( productid = `HT-9995` name = `Tablet Pouch`                                       suppliername = `Titanium`          category = `Accessories`                 price = `20` )
      ( productid = `HT-9996` name = `Tablet Pouch`                                       suppliername = `Titanium`          category = `Accessories`                 price = `20` )
      ( productid = `HT-9997` name = `e-Book Reader ReadMe`                               suppliername = `Titanium`          category = `Smartphones and Tablets`     price = `33` )
      ( productid = `HT-9998` name = `Smartphone Beta`                                    suppliername = `Titanium`          category = `Smartphones and Tablets`     price = `30` )
      ( productid = `HT-9999` name = `Maxi Tablet`                                        suppliername = `Titanium`          category = `Tablets`                     price = `749` )
      ( productid = `PF-1000` name = `Flyer`                                              suppliername = `Titanium`          category = `Accessories`                 price = `0` )
    ).

    SORT t_products BY name AS TEXT.

  ENDMETHOD.

ENDCLASS.
