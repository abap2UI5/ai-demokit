" @keywords objectpagelayout object layout sap.uxap objectpageselectedsection objectpagedynamicheadertitle title flexbox avatar text button overflowtoolbarbutton
" @summary Object Page sample showing a layout where the selected section is defined by the user.
CLASS z2ui5_cl_smpc_app_594 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_employee,
        name    TYPE string,
        job     TYPE string,
        picture TYPE string,
      END OF ty_s_employee.

    DATA t_employees TYPE STANDARD TABLE OF ty_s_employee WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_594 IMPLEMENTATION.

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

    " The view is ONE statement, so every /Employee row it binds has to be
    " assigned before the chain starts. Assigned rather than read inside the
    " chain with t_employees[ n ]-field: _bind identifies the cell by data
    " reference, and the downport lowers a component-level table expression
    " to a work-area copy, which the reference match then refuses.
    FIELD-SYMBOLS <emp1> TYPE ty_s_employee.
    FIELD-SYMBOLS <emp2> TYPE ty_s_employee.
    FIELD-SYMBOLS <emp3> TYPE ty_s_employee.
    FIELD-SYMBOLS <emp4> TYPE ty_s_employee.
    FIELD-SYMBOLS <emp5> TYPE ty_s_employee.
    FIELD-SYMBOLS <emp6> TYPE ty_s_employee.

    ASSIGN t_employees[ 1 ] TO <emp1>.
    ASSIGN t_employees[ 2 ] TO <emp2>.
    ASSIGN t_employees[ 3 ] TO <emp3>.
    ASSIGN t_employees[ 4 ] TO <emp4>.
    ASSIGN t_employees[ 5 ] TO <emp5>.
    ASSIGN t_employees[ 6 ] TO <emp6>.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

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
            )->a( n = `enableLazyLoading`        v = `true`
            )->a( n = `useIconTabBar`            v = `true`
            )->a( n = `showTitleInHeaderContent` v = `true`
            " the sample opens on the SECOND section rather than the first - which
            " is what it is about; selectedSection is an association set by id
            )->a( n = `selectedSection`          v = `personal`
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
                    )->a( n = `id`             v = `goals`
                    )->a( n = `title`          v = `2014 Goals Plan`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `id`             v = `goalsSS1`
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
                    )->a( n = `id`             v = `personal`
                    )->a( n = `title`          v = `Personal`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `id`             v = `personalSS1`
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
                            )->a( n = `id`             v = `personalSS2`
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
                    )->a( n = `id`             v = `employment`
                    )->a( n = `title`          v = `Employment`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `id`             v = `employmentSS1`
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
                            )->a( n = `id`             v = `employmentSS2`
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
                            )->a( n = `id`             v = `employmentSS3`
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
                                                                )->a( n = `text` v = client->_bind( val = <emp1>-name tab = t_employees tab_index = 1 )
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( val = <emp1>-job tab = t_employees tab_index = 1 )

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
                                                            )->a( n = `text` v = client->_bind( val = <emp2>-name tab = t_employees tab_index = 2 )
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( val = <emp2>-job tab = t_employees tab_index = 2 )

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
                    )->a( n = `id`             v = `connections`
                    )->a( n = `title`          v = `Connections`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `id`             v = `connectionsSS1`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`

                                " connections:ConnectionsBlock inlined -
                                " six Panels over emp1>..emp6>, which
                                " are the six rows of one table
                                )->ele( n = `Panel` ns = `m`
                                    )->ele( n = `VBox` ns = `m`
                                        )->tag( n = `Image` ns = `m`
                                            )->a( n = `src` v = client->_bind( val = <emp1>-picture tab = t_employees tab_index = 1 )
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = client->_bind( val = <emp1>-name tab = t_employees tab_index = 1 )
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = client->_bind( val = <emp1>-job tab = t_employees tab_index = 1 )

                                    )->end(
                                )->end(

                                )->ele( n = `Panel` ns = `m`
                                    )->ele( n = `VBox` ns = `m`
                                        )->tag( n = `Image` ns = `m`
                                            )->a( n = `src` v = client->_bind( val = <emp2>-picture tab = t_employees tab_index = 2 )
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = client->_bind( val = <emp2>-name tab = t_employees tab_index = 2 )
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = client->_bind( val = <emp2>-job tab = t_employees tab_index = 2 )

                                    )->end(
                                )->end(

                                )->ele( n = `Panel` ns = `m`
                                    )->ele( n = `VBox` ns = `m`
                                        )->tag( n = `Image` ns = `m`
                                            )->a( n = `src` v = client->_bind( val = <emp3>-picture tab = t_employees tab_index = 3 )
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = client->_bind( val = <emp3>-name tab = t_employees tab_index = 3 )
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = client->_bind( val = <emp3>-job tab = t_employees tab_index = 3 )

                                    )->end(
                                )->end(

                                )->ele( n = `Panel` ns = `m`
                                    )->ele( n = `VBox` ns = `m`
                                        )->tag( n = `Image` ns = `m`
                                            )->a( n = `src` v = client->_bind( val = <emp4>-picture tab = t_employees tab_index = 4 )
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = client->_bind( val = <emp4>-name tab = t_employees tab_index = 4 )
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = client->_bind( val = <emp4>-job tab = t_employees tab_index = 4 )

                                    )->end(
                                )->end(

                                )->ele( n = `Panel` ns = `m`
                                    )->ele( n = `VBox` ns = `m`
                                        )->tag( n = `Image` ns = `m`
                                            )->a( n = `src` v = client->_bind( val = <emp5>-picture tab = t_employees tab_index = 5 )
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = client->_bind( val = <emp5>-name tab = t_employees tab_index = 5 )
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = client->_bind( val = <emp5>-job tab = t_employees tab_index = 5 )

                                    )->end(
                                )->end(

                                )->ele( n = `Panel` ns = `m`
                                    )->ele( n = `VBox` ns = `m`
                                        )->tag( n = `Image` ns = `m`
                                            )->a( n = `src` v = client->_bind( val = <emp6>-picture tab = t_employees tab_index = 6 )
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = client->_bind( val = <emp6>-name tab = t_employees tab_index = 6 )
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = client->_bind( val = <emp6>-job tab = t_employees tab_index = 6 )
        ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " SharedJSONData/HRData.json /Employee rows 0-5, the records the block
    " ModelMapping elements map onto the internal models emp1>..emp6> - one
    " table, so the model keeps the array shape the original addresses
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

  ENDMETHOD.

ENDCLASS.
