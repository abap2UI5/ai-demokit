CLASS z2ui5_cl_ai_app_263 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_ai_app_263 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " Navigation: _navTo(page) is the client-side NavContainer.to() - wired
    " roundtrip-free via _event_client( control_by_id ). The navigate event
    " itself goes to the backend (NAVIGATE) because onNavigate reads the
    " checkbox state before resetting the ObjectPage's selected section.
    " Blocks: every SharedBlocks BlockBase is inlined with its view content
    " (app 188/217 precedent); the empN> named models the ModelMapping
    " elements feed are folded onto default-model root fields (app 230).
    view->open( n = `View` ns = `mvc`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:forms`  v = `sap.ui.layout.form`

        )->open( n = `NavContainer` ns = `m`
            )->a( n = `id`       v = `navigationContainer`
            )->a( n = `navigate` v = client->_event( val   = `NAVIGATE`
                                                     t_arg = VALUE #( ( `${$parameters>/toId}` ) ) )

            )->open( n = `Page` ns = `m`
                )->a( n = `id`    v = `page1`
                )->a( n = `title` v = `Page 1`

                )->open( n = `VerticalLayout` ns = `layout`
                    )->a( n = `class` v = `sapUiContentPadding`
                    )->a( n = `width` v = `100%`

                    )->leaf( n = `MessageStrip` ns = `m`
                        )->a( n = `showIcon` v = `true`
                        )->a( n = `text`     v = `This example shows how to reset the selected section of the ObjectPage `
                                              && `to the first visible and scroll to the top upon revisiting the page.`

                    )->open( n = `List` ns = `m`
                        )->leaf( n = `StandardListItem` ns = `m`
                            )->a( n = `press` v = client->_event_client( val   = client->cs_event-control_by_id
                                                                         t_arg = VALUE #( ( `navigationContainer` ) ( `to` ) ( `page2` ) ) )
                            )->a( n = `title` v = `To ObjectPage`
                            )->a( n = `type`  v = `Navigation`

                    )->shut(

                    )->leaf( n = `CheckBox` ns = `m`
                        )->a( n = `id`       v = `resetCheck`
                        )->a( n = `selected` v = client->_bind( reset_check )
                        )->a( n = `text`     v = `reset its selected section to the first visible and scroll to the top`

                )->shut(
            )->shut(

            )->open( n = `Page` ns = `m`
                )->a( n = `id`              v = `page2`
                )->a( n = `title`           v = `Page 2`
                )->a( n = `showNavButton`   v = `true`
                )->a( n = `navButtonPress`  v = client->_event_client( val   = client->cs_event-control_by_id
                                                                       t_arg = VALUE #( ( `navigationContainer` ) ( `to` ) ( `page1` ) ) )

                )->open( `ObjectPageLayout`
                    )->a( n = `id`                       v = `ObjectPageLayout`
                    )->a( n = `enableLazyLoading`        v = `true`
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
                                        )->a( n = `src`   v = `https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_275314.png`
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
                                )->a( n = `class`       v = `sapUiSmallMarginEnd`
                                )->a( n = `src`         v = `https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_275314.png`
                                )->a( n = `displaySize` v = `L`

                            )->open( n = `VerticalLayout` ns = `layout`
                                )->a( n = `class` v = `sapUiSmallMarginBeginEnd`

                                )->leaf( n = `Link` ns = `m`
                                    )->a( n = `text` v = `+33 6 4512 5158`
                                )->leaf( n = `Link` ns = `m`
                                    )->a( n = `text` v = `DeniseSmith@sap.com`

                            )->shut(

                            )->open( n = `HorizontalLayout` ns = `layout`
                                )->a( n = `class` v = `sapUiSmallMarginBeginEnd`

                                )->leaf( n = `Image` ns = `m`
                                    )->a( n = `src` v = `https://sdk.openui5.org/test-resources/sap/uxap/images/linkedin.png`
                                )->leaf( n = `Image` ns = `m`
                                    )->a( n = `src`   v = `https://sdk.openui5.org/test-resources/sap/uxap/images/Twitter.png`
                                    )->a( n = `class` v = `sapUiSmallMarginBegin`

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
                            )->a( n = `id`             v = `goals`
                            )->a( n = `title`          v = `2014 Goals Plan`

                            )->open( `subSections`
                                )->open( `ObjectPageSubSection`
                                    )->a( n = `id`             v = `goalsSS1`
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
                            )->a( n = `id`             v = `personal`
                            )->a( n = `title`          v = `Personal`

                            )->open( `subSections`
                                )->open( `ObjectPageSubSection`
                                    )->a( n = `id`             v = `personalSS1`
                                    )->a( n = `title`          v = `Connect`
                                    )->a( n = `titleUppercase` v = `false`

                                    )->open( `blocks`

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
                                )->shut(

                                )->open( `ObjectPageSubSection`
                                    )->a( n = `id`             v = `personalSS2`
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
                            )->a( n = `id`             v = `employment`
                            )->a( n = `title`          v = `Employment`

                            )->open( `subSections`
                                )->open( `ObjectPageSubSection`
                                    )->a( n = `id`             v = `employmentSS1`
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
                                    )->a( n = `id`             v = `employmentSS2`
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
                                    )->a( n = `id`             v = `employmentSS3`
                                    )->a( n = `title`          v = `Job Relationship`
                                    )->a( n = `titleUppercase` v = `false`

                                    )->open( `blocks`

                                        " employment:EmploymentBlockJob inlined
                                        " with its Collapsed view (the block's
                                        " initial mode); emp1>/emp2> fold onto
                                        " default-model root fields
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

                                                                )->shut(
                                                            )->shut(
                                                        )->shut(
                                                    )->shut(
                                                )->shut(
                                            )->shut(
                                        )->shut(
                                    )->shut(
                                )->shut(
                            )->shut(
                        )->shut(

                        )->open( `ObjectPageSection`
                            )->a( n = `titleUppercase` v = `false`
                            )->a( n = `id`             v = `connections`
                            )->a( n = `title`          v = `Connections`

                            )->open( `subSections`
                                )->open( `ObjectPageSubSection`
                                    )->a( n = `id`             v = `connectionsSS1`
                                    )->a( n = `titleUppercase` v = `false`

                                    )->open( `blocks`

                                        " connections:ConnectionsBlock inlined -
                                        " six Panels over emp1>..emp6>, folded
                                        " onto default-model root fields
                                        )->open( n = `Panel` ns = `m`
                                            )->open( n = `VBox` ns = `m`
                                                )->leaf( n = `Image` ns = `m`
                                                    )->a( n = `src` v = client->_bind( emp1_picture )
                                                )->leaf( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp1_name )
                                                )->leaf( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp1_job )

                                            )->shut(
                                        )->shut(

                                        )->open( n = `Panel` ns = `m`
                                            )->open( n = `VBox` ns = `m`
                                                )->leaf( n = `Image` ns = `m`
                                                    )->a( n = `src` v = client->_bind( emp2_picture )
                                                )->leaf( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp2_name )
                                                )->leaf( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp2_job )

                                            )->shut(
                                        )->shut(

                                        )->open( n = `Panel` ns = `m`
                                            )->open( n = `VBox` ns = `m`
                                                )->leaf( n = `Image` ns = `m`
                                                    )->a( n = `src` v = client->_bind( emp3_picture )
                                                )->leaf( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp3_name )
                                                )->leaf( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp3_job )

                                            )->shut(
                                        )->shut(

                                        )->open( n = `Panel` ns = `m`
                                            )->open( n = `VBox` ns = `m`
                                                )->leaf( n = `Image` ns = `m`
                                                    )->a( n = `src` v = client->_bind( emp4_picture )
                                                )->leaf( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp4_name )
                                                )->leaf( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp4_job )

                                            )->shut(
                                        )->shut(

                                        )->open( n = `Panel` ns = `m`
                                            )->open( n = `VBox` ns = `m`
                                                )->leaf( n = `Image` ns = `m`
                                                    )->a( n = `src` v = client->_bind( emp5_picture )
                                                )->leaf( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp5_name )
                                                )->leaf( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp5_job )

                                            )->shut(
                                        )->shut(

                                        )->open( n = `Panel` ns = `m`
                                            )->open( n = `VBox` ns = `m`
                                                )->leaf( n = `Image` ns = `m`
                                                    )->a( n = `src` v = client->_bind( emp6_picture )
                                                )->leaf( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp6_name )
                                                )->leaf( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( emp6_job )

                                        ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `NAVIGATE`.
        " onNavigate: when page2 becomes the destination and the checkbox is
        " ticked, the controller calls setSelectedSection(null) so the page
        " reopens on its first visible section. Reproduced 1:1 since the
        " association setters take an EMPTY argument as null (the
        " controlIdOrNull argument kind); the earlier substitute - naming the
        " first section explicitly - is gone.
        IF reset_check = abap_true AND client->get_event_arg( ) CS `page2`.
          client->follow_up_action( val   = client->cs_event-control_by_id
                                    t_arg = VALUE #( ( `ObjectPageLayout` ) ( `setSelectedSection` ) ( `` ) ) ).
        ENDIF.
    ENDCASE.

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
