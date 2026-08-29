" @keywords objectpagelayout object layout sap.uxap objectpageresetselectedsection navcontainer verticallayout messagestrip list standardlistitem checkbox objectpagedynamicheadertitle
" @summary Object Page sample showing how to ensure the page is always scrolled to the top on any subsequent navigation to the page, regardless of its previously selected section in the preceding navigation.
CLASS z2ui5_cl_smpc_app_263 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA reset_check   TYPE abap_bool.
    DATA emp1_name     TYPE string.
    DATA emp1_job      TYPE string.
    DATA emp1_picture  TYPE string.
    DATA emp2_name     TYPE string.
    DATA emp2_job      TYPE string.
    DATA emp2_picture  TYPE string.
    DATA emp3_name     TYPE string.
    DATA emp3_job      TYPE string.
    DATA emp3_picture  TYPE string.
    DATA emp4_name     TYPE string.
    DATA emp4_job      TYPE string.
    DATA emp4_picture  TYPE string.
    DATA emp5_name     TYPE string.
    DATA emp5_job      TYPE string.
    DATA emp5_picture  TYPE string.
    DATA emp6_name     TYPE string.
    DATA emp6_job      TYPE string.
    DATA emp6_picture  TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_263 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " Navigation: _navTo(page) is the client-side NavContainer.to() - wired
    " roundtrip-free via follow_up_action( control_by_id ). The navigate event
    " itself goes to the backend (NAVIGATE) because onNavigate reads the
    " checkbox state before resetting the ObjectPage's selected section.
    " Blocks: every SharedBlocks BlockBase is inlined with its view content
    " (app 188/217 precedent); the empN> named models the ModelMapping
    " elements feed are folded onto default-model root fields (app 230).
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:forms`  v = `sap.ui.layout.form`

        )->ele( n = `NavContainer` ns = `m`
            )->a( n = `id`       v = `navigationContainer`
            )->a( n = `navigate` v = client->_event( val = `NAVIGATE` arg = `${$parameters>/toId}` )

            )->ele( n = `Page` ns = `m`
                )->a( n = `id`    v = `page1`
                )->a( n = `title` v = `Page 1`

                )->ele( n = `VerticalLayout` ns = `layout`
                    )->a( n = `class` v = `sapUiContentPadding`
                    )->a( n = `width` v = `100%`

                    )->tag( n = `MessageStrip` ns = `m`
                        )->a( n = `showIcon` v = `true`
                        )->a( n = `text`     v = `This example shows how to reset the selected section of the ObjectPage `
                                              && `to the first visible and scroll to the top upon revisiting the page.`

                    )->ele( n = `List` ns = `m`
                        )->tag( n = `StandardListItem` ns = `m`
                            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                            t_arg = VALUE #( ( `navigationContainer` ) ( `to` ) ( `page2` ) ) )
                            )->a( n = `title` v = `To ObjectPage`
                            )->a( n = `type`  v = `Navigation`

                    )->end(

                    )->tag( n = `CheckBox` ns = `m`
                        )->a( n = `id`       v = `resetCheck`
                        )->a( n = `selected` v = client->_bind( reset_check )
                        )->a( n = `text`     v = `reset its selected section to the first visible and scroll to the top`

                )->end(
            )->end(

            )->ele( n = `Page` ns = `m`
                )->a( n = `id`              v = `page2`
                )->a( n = `title`           v = `Page 2`
                )->a( n = `showNavButton`   v = `true`
                )->a( n = `navButtonPress`  v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                          t_arg = VALUE #( ( `navigationContainer` ) ( `to` ) ( `page1` ) ) )

                )->ele( `ObjectPageLayout`
                    )->a( n = `id`                       v = `ObjectPageLayout`
                    )->a( n = `enableLazyLoading`        v = `true`
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
                                        " initial mode); emp1>/emp2> fold onto
                                        " default-model root fields
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
                                                                        )->a( n = `text` v = client->_bind( emp1_name )
                                                                    )->tag( n = `Label` ns = `m`
                                                                        )->a( n = `text` v = client->_bind( emp1_job )

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
                                                                    )->a( n = `text` v = client->_bind( emp2_name )
                                                                )->tag( n = `Label` ns = `m`
                                                                    )->a( n = `text` v = client->_bind( emp2_job )

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
                                        " six Panels over emp1>..emp6>, folded
                                        " onto default-model root fields
                                        )->ele( n = `Panel` ns = `m`
                                            )->ele( n = `VBox` ns = `m`
                                                )->tag( n = `Image` ns = `m`
                                                    )->a( n = `src` v = client->_bind( emp1_picture )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp1_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp1_job )

                                            )->end(
                                        )->end(

                                        )->ele( n = `Panel` ns = `m`
                                            )->ele( n = `VBox` ns = `m`
                                                )->tag( n = `Image` ns = `m`
                                                    )->a( n = `src` v = client->_bind( emp2_picture )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp2_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp2_job )

                                            )->end(
                                        )->end(

                                        )->ele( n = `Panel` ns = `m`
                                            )->ele( n = `VBox` ns = `m`
                                                )->tag( n = `Image` ns = `m`
                                                    )->a( n = `src` v = client->_bind( emp3_picture )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp3_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp3_job )

                                            )->end(
                                        )->end(

                                        )->ele( n = `Panel` ns = `m`
                                            )->ele( n = `VBox` ns = `m`
                                                )->tag( n = `Image` ns = `m`
                                                    )->a( n = `src` v = client->_bind( emp4_picture )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp4_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp4_job )

                                            )->end(
                                        )->end(

                                        )->ele( n = `Panel` ns = `m`
                                            )->ele( n = `VBox` ns = `m`
                                                )->tag( n = `Image` ns = `m`
                                                    )->a( n = `src` v = client->_bind( emp5_picture )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp5_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp5_job )

                                            )->end(
                                        )->end(

                                        )->ele( n = `Panel` ns = `m`
                                            )->ele( n = `VBox` ns = `m`
                                                )->tag( n = `Image` ns = `m`
                                                    )->a( n = `src` v = client->_bind( emp6_picture )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp6_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp6_job )

                                        ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    " onNavigate: when page2 becomes the destination and the checkbox is
    " ticked, the controller calls setSelectedSection(null) so the page
    " reopens on its first visible section. Reproduced 1:1 since the
    " association setters take an EMPTY argument as null (the
    " controlIdOrNull argument kind); the earlier substitute - naming the
    " first section explicitly - is gone.
    IF client->get_event( ) = `NAVIGATE`
        AND reset_check = abap_true
        AND client->get_event_arg( ) CS `page2`.
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = VALUE #( ( `ObjectPageLayout` ) ( `setSelectedSection` ) ( `` ) ) ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " SharedJSONData/HRData.json /Employee rows 0-5, the records the block
    " ModelMapping elements map onto the internal models emp1>..emp6>
    reset_check  = abap_true.
    emp1_name    = `Michael Adams`.
    emp1_job     = `Scrum Master`.
    emp1_picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png`.
    emp2_name    = `John Miller`.
    emp2_job     = `Product Owner`.
    emp2_picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png`.
    emp3_name    = `Richard Wilson`.
    emp3_job     = `Ux Designer`.
    emp3_picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png`.
    emp4_name    = `Julie Armstrong`.
    emp4_job     = `Quality Engineer`.
    emp4_picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png`.
    emp5_name    = `Denise Smith`.
    emp5_job     = `Team Member`.
    emp5_picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png`.
    emp6_name    = `Richard Adams`.
    emp6_job     = `Team Member`.
    emp6_picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png`.

  ENDMETHOD.

ENDCLASS.
