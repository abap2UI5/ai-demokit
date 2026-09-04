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
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA t_products TYPE ty_t_product.

    DATA t_employees TYPE STANDARD TABLE OF ty_s_employee WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_595 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 LIKE LINE OF t_employees.
    DATA temp2 LIKE sy-tabix.
    DATA temp3 LIKE LINE OF t_employees.
    DATA temp4 LIKE sy-tabix.
    DATA temp5 LIKE LINE OF t_employees.
    DATA temp6 LIKE sy-tabix.
    DATA temp7 LIKE LINE OF t_employees.
    DATA temp8 LIKE sy-tabix.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    
    temp2 = sy-tabix.
    READ TABLE t_employees INDEX 1 INTO temp1.
    sy-tabix = temp2.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp4 = sy-tabix.
    READ TABLE t_employees INDEX 1 INTO temp3.
    sy-tabix = temp4.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp6 = sy-tabix.
    READ TABLE t_employees INDEX 2 INTO temp5.
    sy-tabix = temp6.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp8 = sy-tabix.
    READ TABLE t_employees INDEX 2 INTO temp7.
    sy-tabix = temp8.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
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
                                                                )->a( n = `text` v = client->_bind( val = temp1-name tab = t_employees tab_index = 1 )
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( val = temp3-job tab = t_employees tab_index = 1 )

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
                                                            )->a( n = `text` v = client->_bind( val = temp5-name tab = t_employees tab_index = 2 )
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( val = temp7-job tab = t_employees tab_index = 2 )

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
    DATA temp3 LIKE t_employees.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 TYPE z2ui5_cl_smpc_app_595=>ty_t_product.
    DATA temp6 LIKE LINE OF temp5.
    CLEAR temp3.
    
    temp4-name = `Michael Adams`.
    temp4-job = `Scrum Master`.
    temp4-picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `John Miller`.
    temp4-job = `Product Owner`.
    temp4-picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Richard Wilson`.
    temp4-job = `Ux Designer`.
    temp4-picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Julie Armstrong`.
    temp4-job = `Quality Engineer`.
    temp4-picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Denise Smith`.
    temp4-job = `Team Member`.
    temp4-picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Richard Adams`.
    temp4-job = `Team Member`.
    temp4-picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png`.
    INSERT temp4 INTO TABLE temp3.
    t_employees = temp3.

    " sap/ui/demo/mock/products.json /ProductCollection, already in the order the
    " rows binding's sorter puts it in (path 'Name', ascending) - a thin frontend
    " sorts the data it sends (app 298 idiom)
    " sap/ui/demo/mock/products.json /ProductCollection, seeded verbatim in the
    " file's own order and then put into the order the rows binding's sorter
    " asks for (path 'Name') - a thin frontend sorts the data it sends (app 298)
    
    CLEAR temp5.
    
    temp6-productid = `HT-1000`.
    temp6-name = `Notebook Basic 15`.
    temp6-suppliername = `Very Best Screens`.
    temp6-category = `Laptops`.
    temp6-price = `956`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1001`.
    temp6-name = `Notebook Basic 17`.
    temp6-suppliername = `Very Best Screens`.
    temp6-category = `Laptops`.
    temp6-price = `1249`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1002`.
    temp6-name = `Notebook Basic 18`.
    temp6-suppliername = `Very Best Screens`.
    temp6-category = `Laptops`.
    temp6-price = `1570`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1003`.
    temp6-name = `Notebook Basic 19`.
    temp6-suppliername = `Smartcards`.
    temp6-category = `Laptops`.
    temp6-price = `1650`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1007`.
    temp6-name = `ITelO Vault`.
    temp6-suppliername = `Technocom`.
    temp6-category = `Accessories`.
    temp6-price = `299`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1010`.
    temp6-name = `Notebook Professional 15`.
    temp6-suppliername = `Very Best Screens`.
    temp6-category = `Accessories`.
    temp6-price = `1999`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1011`.
    temp6-name = `Notebook Professional 17`.
    temp6-suppliername = `Very Best Screens`.
    temp6-category = `Laptops`.
    temp6-price = `2299`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1020`.
    temp6-name = `ITelO Vault Net`.
    temp6-suppliername = `Technocom`.
    temp6-category = `Accessories`.
    temp6-price = `459`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1021`.
    temp6-name = `ITelO Vault SAT`.
    temp6-suppliername = `Technocom`.
    temp6-category = `Accessories`.
    temp6-price = `149`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1022`.
    temp6-name = `Comfort Easy`.
    temp6-suppliername = `Technocom`.
    temp6-category = `Accessories`.
    temp6-price = `1679`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1023`.
    temp6-name = `Comfort Senior`.
    temp6-suppliername = `Technocom`.
    temp6-category = `Accessories`.
    temp6-price = `512`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1030`.
    temp6-name = `Ergo Screen E-I`.
    temp6-suppliername = `Very Best Screens`.
    temp6-category = `Flat Screen Monitors`.
    temp6-price = `230`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1031`.
    temp6-name = `Ergo Screen E-II`.
    temp6-suppliername = `Very Best Screens`.
    temp6-category = `Flat Screen Monitors`.
    temp6-price = `285`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1032`.
    temp6-name = `Ergo Screen E-III`.
    temp6-suppliername = `Very Best Screens`.
    temp6-category = `Flat Screen Monitors`.
    temp6-price = `345`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1035`.
    temp6-name = `Flat Basic`.
    temp6-suppliername = `Very Best Screens`.
    temp6-category = `Flat Screen Monitors`.
    temp6-price = `399`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1036`.
    temp6-name = `Flat Future`.
    temp6-suppliername = `Very Best Screens`.
    temp6-category = `Flat Screen Monitors`.
    temp6-price = `430`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1037`.
    temp6-name = `Flat XL`.
    temp6-suppliername = `Very Best Screens`.
    temp6-category = `Flat Screen Monitors`.
    temp6-price = `1230`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1040`.
    temp6-name = `Laser Professional Eco`.
    temp6-suppliername = `Alpha Printers`.
    temp6-category = `Printers`.
    temp6-price = `830`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1041`.
    temp6-name = `Laser Basic`.
    temp6-suppliername = `Alpha Printers`.
    temp6-category = `Printers`.
    temp6-price = `490`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1042`.
    temp6-name = `Laser Allround`.
    temp6-suppliername = `Alpha Printers`.
    temp6-category = `Printers`.
    temp6-price = `349`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1050`.
    temp6-name = `Ultra Jet Super Color`.
    temp6-suppliername = `Alpha Printers`.
    temp6-category = `Printers`.
    temp6-price = `139`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1051`.
    temp6-name = `Ultra Jet Mobile`.
    temp6-suppliername = `Printer for All`.
    temp6-category = `Printers`.
    temp6-price = `99`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1052`.
    temp6-name = `Ultra Jet Super Highspeed`.
    temp6-suppliername = `Printer for All`.
    temp6-category = `Printers`.
    temp6-price = `170`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1055`.
    temp6-name = `Multi Print`.
    temp6-suppliername = `Printer for All`.
    temp6-category = `Multifunction Printers`.
    temp6-price = `99`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1056`.
    temp6-name = `Multi Color`.
    temp6-suppliername = `Printer for All`.
    temp6-category = `Multifunction Printers`.
    temp6-price = `119`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1060`.
    temp6-name = `Cordless Mouse`.
    temp6-suppliername = `Oxynum`.
    temp6-category = `Mice`.
    temp6-price = `9`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1061`.
    temp6-name = `Speed Mouse`.
    temp6-suppliername = `Oxynum`.
    temp6-category = `Mice`.
    temp6-price = `7`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1062`.
    temp6-name = `Track Mouse`.
    temp6-suppliername = `Oxynum`.
    temp6-category = `Mice`.
    temp6-price = `11`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1063`.
    temp6-name = `Ergonomic Keyboard`.
    temp6-suppliername = `Oxynum`.
    temp6-category = `Keyboards`.
    temp6-price = `14`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1064`.
    temp6-name = `Internet Keyboard`.
    temp6-suppliername = `Oxynum`.
    temp6-category = `Keyboards`.
    temp6-price = `16`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1065`.
    temp6-name = `Media Keyboard`.
    temp6-suppliername = `Oxynum`.
    temp6-category = `Keyboards`.
    temp6-price = `26`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1066`.
    temp6-name = `Mousepad`.
    temp6-suppliername = `Oxynum`.
    temp6-category = `Mousepads`.
    temp6-price = `6.99`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1067`.
    temp6-name = `Ergo Mousepad`.
    temp6-suppliername = `Oxynum`.
    temp6-category = `Mousepads`.
    temp6-price = `8.99`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1068`.
    temp6-name = `Designer Mousepad`.
    temp6-suppliername = `Fasttech`.
    temp6-category = `Mousepads`.
    temp6-price = `12.99`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1069`.
    temp6-name = `Universal card reader`.
    temp6-suppliername = `Fasttech`.
    temp6-category = `Computer System Accessories`.
    temp6-price = `14`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1070`.
    temp6-name = `Proctra X`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-category = `Graphic Cards`.
    temp6-price = `70.9`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1071`.
    temp6-name = `Gladiator MX`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-category = `Graphic Cards`.
    temp6-price = `81.7`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1072`.
    temp6-name = `Hurricane GX`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-category = `Graphic Cards`.
    temp6-price = `101.2`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1073`.
    temp6-name = `Hurricane GX/LN`.
    temp6-suppliername = `Smartcards`.
    temp6-category = `Graphic Cards`.
    temp6-price = `139.99`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1080`.
    temp6-name = `Photo Scan`.
    temp6-suppliername = `Printer for All`.
    temp6-category = `Scanners`.
    temp6-price = `129`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1081`.
    temp6-name = `Power Scan`.
    temp6-suppliername = `Printer for All`.
    temp6-category = `Scanners`.
    temp6-price = `89`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1082`.
    temp6-name = `Jet Scan Professional`.
    temp6-suppliername = `Printer for All`.
    temp6-category = `Scanners`.
    temp6-price = `169`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1083`.
    temp6-name = `Jet Scan Professional`.
    temp6-suppliername = `Printer for All`.
    temp6-category = `Scanners`.
    temp6-price = `189`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1085`.
    temp6-name = `Copymaster`.
    temp6-suppliername = `Alpha Printers`.
    temp6-category = `Multifunction Printers`.
    temp6-price = `1499`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1090`.
    temp6-name = `Surround Sound`.
    temp6-suppliername = `Speaker Experts`.
    temp6-category = `Speakers`.
    temp6-price = `39`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1091`.
    temp6-name = `Blaster Extreme`.
    temp6-suppliername = `Speaker Experts`.
    temp6-category = `Speakers`.
    temp6-price = `26`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1092`.
    temp6-name = `Sound Booster`.
    temp6-suppliername = `Speaker Experts`.
    temp6-category = `Speakers`.
    temp6-price = `45`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1095`.
    temp6-name = `Lovely Sound 5.1 Wireless`.
    temp6-suppliername = `Fasttech`.
    temp6-category = `Accessories`.
    temp6-price = `49`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1096`.
    temp6-name = `Lovely Sound 5.1`.
    temp6-suppliername = `Fasttech`.
    temp6-category = `Accessories`.
    temp6-price = `39`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1097`.
    temp6-name = `Lovely Sound Stereo`.
    temp6-suppliername = `Fasttech`.
    temp6-category = `Accessories`.
    temp6-price = `29`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1100`.
    temp6-name = `Smart Office`.
    temp6-suppliername = `Technocom`.
    temp6-category = `Software`.
    temp6-price = `89.9`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1101`.
    temp6-name = `Smart Design`.
    temp6-suppliername = `Technocom`.
    temp6-category = `Software`.
    temp6-price = `79.9`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1102`.
    temp6-name = `Smart Network`.
    temp6-suppliername = `Technocom`.
    temp6-category = `Software`.
    temp6-price = `69`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1103`.
    temp6-name = `Smart Multimedia`.
    temp6-suppliername = `Technocom`.
    temp6-category = `Software`.
    temp6-price = `77`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1104`.
    temp6-name = `Smart Games`.
    temp6-suppliername = `Technocom`.
    temp6-category = `Software`.
    temp6-price = `55`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1105`.
    temp6-name = `Smart Internet Antivirus`.
    temp6-suppliername = `Brainsoft`.
    temp6-category = `Software`.
    temp6-price = `29`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1106`.
    temp6-name = `Smart Firewall`.
    temp6-suppliername = `Brainsoft`.
    temp6-category = `Software`.
    temp6-price = `34`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1107`.
    temp6-name = `Smart Money`.
    temp6-suppliername = `Brainsoft`.
    temp6-category = `Software`.
    temp6-price = `29.9`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1110`.
    temp6-name = `PC Lock`.
    temp6-suppliername = `Red Point Stores`.
    temp6-category = `Computer System Accessories`.
    temp6-price = `8.9`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1111`.
    temp6-name = `Notebook Lock`.
    temp6-suppliername = `Red Point Stores`.
    temp6-category = `Computer System Accessories`.
    temp6-price = `6.9`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1112`.
    temp6-name = `Web cam reality`.
    temp6-suppliername = `Red Point Stores`.
    temp6-category = `Computer System Accessories`.
    temp6-price = `39`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1113`.
    temp6-name = `Screen clean`.
    temp6-suppliername = `Red Point Stores`.
    temp6-category = `Computer System Accessories`.
    temp6-price = `2.3`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1114`.
    temp6-name = `Fabric bag professional`.
    temp6-suppliername = `Red Point Stores`.
    temp6-category = `Computer System Accessories`.
    temp6-price = `31`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1115`.
    temp6-name = `Wireless DSL Router`.
    temp6-suppliername = `Red Point Stores`.
    temp6-category = `Telecommunications`.
    temp6-price = `49`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1116`.
    temp6-name = `Wireless DSL Router / Repeater`.
    temp6-suppliername = `Red Point Stores`.
    temp6-category = `Telecommunications`.
    temp6-price = `59`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1117`.
    temp6-name = `Wireless DSL Router / Repeater and Print Server`.
    temp6-suppliername = `Technocom`.
    temp6-category = `Telecommunications`.
    temp6-price = `69`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1118`.
    temp6-name = `USB Stick`.
    temp6-suppliername = `Technocom`.
    temp6-category = `Computer System Accessories`.
    temp6-price = `35`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1119`.
    temp6-name = `Travel Adapter`.
    temp6-suppliername = `Titanium`.
    temp6-category = `Accessories`.
    temp6-price = `79`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1120`.
    temp6-name = `Cordless Bluetooth Keyboard, english international`.
    temp6-suppliername = `Technocom`.
    temp6-category = `Keyboards`.
    temp6-price = `29`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1137`.
    temp6-name = `Flat XXL`.
    temp6-suppliername = `Technocom`.
    temp6-category = `Flat Screen Monitors`.
    temp6-price = `1430`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1138`.
    temp6-name = `Pocket Mouse`.
    temp6-suppliername = `Technocom`.
    temp6-category = `Mice`.
    temp6-price = `23`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1210`.
    temp6-name = `PC Power Station`.
    temp6-suppliername = `Technocom`.
    temp6-category = `PCs`.
    temp6-price = `2399`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1251`.
    temp6-name = `Astro Laptop 1516`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-category = `Laptops`.
    temp6-price = `989`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1252`.
    temp6-name = `Astro Phone 6`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-category = `Smartphones and Tablets`.
    temp6-price = `649`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1253`.
    temp6-name = `Benda Laptop 1408`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-category = `Laptops`.
    temp6-price = `976`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1254`.
    temp6-name = `Bending Screen 21HD`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-category = `Flat Screens`.
    temp6-price = `250`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1255`.
    temp6-name = `Broad Screen 22HD`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-category = `Flat Screens`.
    temp6-price = `270`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1256`.
    temp6-name = `Cerdik Phone 7`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-category = `Smartphones and Tablets`.
    temp6-price = `549`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1257`.
    temp6-name = `Cepat Tablet 10.5`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-category = `Smartphones and Tablets`.
    temp6-price = `549`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1258`.
    temp6-name = `Cepat Tablet 8`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-category = `Smartphones and Tablets`.
    temp6-price = `529`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1500`.
    temp6-name = `Server Basic`.
    temp6-suppliername = `Technocom`.
    temp6-category = `Servers`.
    temp6-price = `5000`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1501`.
    temp6-name = `Server Professional`.
    temp6-suppliername = `Technocom`.
    temp6-category = `Servers`.
    temp6-price = `15000`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1502`.
    temp6-name = `Server Power Pro`.
    temp6-suppliername = `Technocom`.
    temp6-category = `Servers`.
    temp6-price = `25000`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1600`.
    temp6-name = `Family PC Basic`.
    temp6-suppliername = `Titanium`.
    temp6-category = `Desktop Computers`.
    temp6-price = `600`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1601`.
    temp6-name = `Family PC Pro`.
    temp6-suppliername = `Titanium`.
    temp6-category = `Desktop Computers`.
    temp6-price = `900`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1602`.
    temp6-name = `Gaming Monster`.
    temp6-suppliername = `Titanium`.
    temp6-category = `Desktop Computers`.
    temp6-price = `1200`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1603`.
    temp6-name = `Gaming Monster Pro`.
    temp6-suppliername = `Titanium`.
    temp6-category = `Desktop Computers`.
    temp6-price = `1700`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-2000`.
    temp6-name = `7" Widescreen Portable DVD Player w MP3`.
    temp6-suppliername = `Titanium`.
    temp6-category = `Accessories`.
    temp6-price = `249.99`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-2001`.
    temp6-name = `10" Portable DVD player`.
    temp6-suppliername = `Titanium`.
    temp6-category = `Accessories`.
    temp6-price = `449.99`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-2002`.
    temp6-name = `Portable DVD Player with 9" LCD Monitor`.
    temp6-suppliername = `Technocom`.
    temp6-category = `Accessories`.
    temp6-price = `853.99`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-2025`.
    temp6-name = `CD/DVD case: 264 sleeves`.
    temp6-suppliername = `Titanium`.
    temp6-category = `Accessories`.
    temp6-price = `44.99`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-2026`.
    temp6-name = `Audio/Video Cable Kit - 4m`.
    temp6-suppliername = `Titanium`.
    temp6-category = `Accessories`.
    temp6-price = `29.99`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-2027`.
    temp6-name = `Removable CD/DVD Laser Labels`.
    temp6-suppliername = `Titanium`.
    temp6-category = `Accessories`.
    temp6-price = `8.99`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6100`.
    temp6-name = `Beam Breaker B-1`.
    temp6-suppliername = `Titanium`.
    temp6-category = `Accessories`.
    temp6-price = `469`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6101`.
    temp6-name = `Beam Breaker B-2`.
    temp6-suppliername = `Technocom`.
    temp6-category = `Accessories`.
    temp6-price = `679`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6102`.
    temp6-name = `Beam Breaker B-3`.
    temp6-suppliername = `Technocom`.
    temp6-category = `Accessories`.
    temp6-price = `889`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6110`.
    temp6-name = `Play Movie`.
    temp6-suppliername = `Fasttech`.
    temp6-category = `Accessories`.
    temp6-price = `130`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6111`.
    temp6-name = `Record Movie`.
    temp6-suppliername = `Fasttech`.
    temp6-category = `Accessories`.
    temp6-price = `288`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6120`.
    temp6-name = `ITelo MusicStick`.
    temp6-suppliername = `Fasttech`.
    temp6-category = `Accessories`.
    temp6-price = `45`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6121`.
    temp6-name = `ITelo Jog-Mate`.
    temp6-suppliername = `Fasttech`.
    temp6-category = `Accessories`.
    temp6-price = `63`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6122`.
    temp6-name = `Power Pro Player 40`.
    temp6-suppliername = `Fasttech`.
    temp6-category = `Accessories`.
    temp6-price = `167`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6123`.
    temp6-name = `Power Pro Player 80`.
    temp6-suppliername = `Fasttech`.
    temp6-category = `Accessories`.
    temp6-price = `299`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6130`.
    temp6-name = `Flat Watch HD32`.
    temp6-suppliername = `Very Best Screens`.
    temp6-category = `Flat Screen TVs`.
    temp6-price = `1459`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6131`.
    temp6-name = `Flat Watch HD37`.
    temp6-suppliername = `Very Best Screens`.
    temp6-category = `Flat Screen TVs`.
    temp6-price = `1199`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6132`.
    temp6-name = `Flat Watch HD41`.
    temp6-suppliername = `Very Best Screens`.
    temp6-category = `Flat Screen TVs`.
    temp6-price = `899`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-7000`.
    temp6-name = `Copperberry`.
    temp6-suppliername = `Fasttech`.
    temp6-category = `Accessories`.
    temp6-price = `549`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-7010`.
    temp6-name = `Silverberry`.
    temp6-suppliername = `Fasttech`.
    temp6-category = `Accessories`.
    temp6-price = `549`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-7020`.
    temp6-name = `Goldberry`.
    temp6-suppliername = `Fasttech`.
    temp6-category = `Accessories`.
    temp6-price = `549`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-7030`.
    temp6-name = `Platinberry`.
    temp6-suppliername = `Fasttech`.
    temp6-category = `Accessories`.
    temp6-price = `549`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-8000`.
    temp6-name = `ITelO FlexTop I4000`.
    temp6-suppliername = `Titanium`.
    temp6-category = `Laptops`.
    temp6-price = `799`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-8001`.
    temp6-name = `ITelO FlexTop I6300c`.
    temp6-suppliername = `Titanium`.
    temp6-category = `Laptops`.
    temp6-price = `799`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-8002`.
    temp6-name = `ITelO FlexTop I9100`.
    temp6-suppliername = `Titanium`.
    temp6-category = `Laptops`.
    temp6-price = `1199`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-8003`.
    temp6-name = `ITelO FlexTop I9800`.
    temp6-suppliername = `Titanium`.
    temp6-category = `Laptops`.
    temp6-price = `1388`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-9991`.
    temp6-name = `Smartphone Leather Case`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-category = `Accessories`.
    temp6-price = `25`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-9992`.
    temp6-name = `Smartphone Alpha`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-category = `Smartphones and Tablets`.
    temp6-price = `599`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-9993`.
    temp6-name = `Mini Tablet`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-category = `Smartphones and Tablets`.
    temp6-price = `833`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-9994`.
    temp6-name = `Camcorder View`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-category = `Accessories`.
    temp6-price = `1388`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-9995`.
    temp6-name = `Tablet Pouch`.
    temp6-suppliername = `Titanium`.
    temp6-category = `Accessories`.
    temp6-price = `20`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-9996`.
    temp6-name = `Tablet Pouch`.
    temp6-suppliername = `Titanium`.
    temp6-category = `Accessories`.
    temp6-price = `20`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-9997`.
    temp6-name = `e-Book Reader ReadMe`.
    temp6-suppliername = `Titanium`.
    temp6-category = `Smartphones and Tablets`.
    temp6-price = `33`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-9998`.
    temp6-name = `Smartphone Beta`.
    temp6-suppliername = `Titanium`.
    temp6-category = `Smartphones and Tablets`.
    temp6-price = `30`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-9999`.
    temp6-name = `Maxi Tablet`.
    temp6-suppliername = `Titanium`.
    temp6-category = `Tablets`.
    temp6-price = `749`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `PF-1000`.
    temp6-name = `Flyer`.
    temp6-suppliername = `Titanium`.
    temp6-category = `Accessories`.
    temp6-price = `0`.
    INSERT temp6 INTO TABLE temp5.
    t_products = temp5.

    SORT t_products BY name AS TEXT.

  ENDMETHOD.

ENDCLASS.
