CLASS z2ui5_cl_smpc_app_402 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_402 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " Block->content inlining (app 188/217/261 precedent): the blocks and
    " moreBlocks aggregations hold SharedBlocks BlockBase controls, each a
    " lazy-loading wrapper around a static view - inlined 1:1 below. This
    " sample has no Job Relationship subsection, so no ModelMapping fold.
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
            )->a( n = `showTitleInHeaderContent` v = `true`
            )->a( n = `upperCaseAnchorBar`       v = `false`

            )->open( `headerTitle`
                )->open( `ObjectPageDynamicHeaderTitle`
                    )->open( `expandedHeading`
                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text`     v = `Object Page Header with Header Container`
                            )->a( n = `wrapping` v = `true`

                    )->shut(

                    )->open( `snappedHeading`
                        )->open( n = `HBox` ns = `m`
                            )->open( n = `VBox` ns = `m`
                                )->leaf( n = `Avatar` ns = `m`
                                    )->a( n = `src`   v = `./test-resources/sap/uxap/images/imageID_275314.png`
                                    )->a( n = `class` v = `sapUiSmallMarginEnd`

                            )->shut(
                            )->open( n = `VBox` ns = `m`
                                )->leaf( n = `Title` ns = `m`
                                    )->a( n = `text`     v = `Object Page Header with Header Container`
                                    )->a( n = `wrapping` v = `true`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Example of an ObjectPage with header facet`

                            )->shut(
                        )->shut(
                    )->shut(

                    )->open( `expandedContent`
                        )->leaf( n = `Label` ns = `m`
                            )->a( n = `text` v = `Example of an ObjectPage with header facet`

                    )->shut(

                    )->open( `snappedTitleOnMobile`
                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text` v = `Object Page Header with Header Container`

                    )->shut(

                    )->open( `actions`
                        )->leaf( n = `Button` ns = `m`
                            )->a( n = `text` v = `Edit`
                            )->a( n = `type` v = `Emphasized`
                        )->leaf( n = `Button` ns = `m`
                            )->a( n = `text` v = `Delete`
                        )->leaf( n = `Button` ns = `m`
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
                )->open( n = `HeaderContainer` ns = `m`
                    )->a( n = `id`            v = `headerContainer`
                    )->a( n = `scrollStep`    v = `200`
                    )->a( n = `showDividers`  v = `false`

                    )->open( n = `HBox` ns = `m`
                        )->a( n = `class` v = `sapUiSmallMarginEnd sapUiSmallMarginBottom`

                        )->leaf( n = `Avatar` ns = `m`
                            )->a( n = `src`         v = `./test-resources/sap/uxap/images/imageID_275314.png`
                            )->a( n = `class`       v = `sapUiMediumMarginEnd`
                            )->a( n = `displaySize` v = `L`

                        )->open( n = `VBox` ns = `m`
                            )->a( n = `class` v = `sapUiSmallMarginBottom`

                            )->open( n = `Title` ns = `m`
                                )->a( n = `class` v = `sapUiTinyMarginBottom`

                                )->leaf( n = `Link` ns = `m`
                                    )->a( n = `text` v = `Order Details`

                            )->shut(

                            )->open( n = `HBox` ns = `m`
                                )->a( n = `class`      v = `sapUiTinyMarginBottom`
                                )->a( n = `renderType` v = `Bare`

                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text`  v = `Manufacturer:`
                                    )->a( n = `class` v = `sapUiTinyMarginEnd`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = ` Robotech`

                            )->shut(

                            )->open( n = `HBox` ns = `m`
                                )->a( n = `class`      v = `sapUiTinyMarginBottom`
                                )->a( n = `renderType` v = `Bare`

                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text`  v = `Factory:`
                                    )->a( n = `class` v = `sapUiTinyMarginEnd`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = ` Florida, OL`

                            )->shut(

                            )->open( n = `HBox` ns = `m`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text`  v = `Supplier:`
                                    )->a( n = `class` v = `sapUiTinyMarginEnd`
                                )->leaf( n = `Link` ns = `m`
                                    )->a( n = `text` v = `Robotech (234242343)`

                            )->shut(
                        )->shut(
                    )->shut(

                    )->open( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiSmallMarginEnd sapUiSmallMarginBottom`

                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Contact Information`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`

                        )->open( n = `HBox` ns = `m`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`

                            )->leaf( n = `Icon` ns = `core`
                                )->a( n = `src` v = `sap-icon://account`
                            )->leaf( n = `Link` ns = `m`
                                )->a( n = `text`  v = ` John Miller`
                                )->a( n = `class` v = `sapUiSmallMarginBegin`

                        )->shut(

                        )->open( n = `HBox` ns = `m`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`

                            )->leaf( n = `Icon` ns = `core`
                                )->a( n = `src` v = `sap-icon://outgoing-call`
                            )->leaf( n = `Link` ns = `m`
                                )->a( n = `text`  v = ` +1 234 5678`
                                )->a( n = `class` v = `sapUiSmallMarginBegin`

                        )->shut(

                        )->open( n = `HBox` ns = `m`
                            )->leaf( n = `Icon` ns = `core`
                                )->a( n = `src` v = `sap-icon://email`
                            )->leaf( n = `Link` ns = `m`
                                )->a( n = `text`  v = `john.miller@company.com`
                                )->a( n = `class` v = `sapUiSmallMarginBegin`

                        )->shut(
                    )->shut(

                    )->open( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiSmallMarginEnd sapUiSmallMarginBottom`

                        )->open( n = `HBox` ns = `m`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text`  v = `Created By:`
                                )->a( n = `class` v = `sapUiSmallMarginEnd`
                            )->leaf( n = `Link` ns = `m`
                                )->a( n = `text` v = `Julie Armstrong`

                        )->shut(

                        )->open( n = `HBox` ns = `m`
                            )->a( n = `class`      v = `sapUiTinyMarginBottom`
                            )->a( n = `renderType` v = `Bare`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text`  v = `Created On:`
                                )->a( n = `class` v = `sapUiSmallMarginEnd`
                            )->leaf( n = `Text` ns = `m`
                                )->a( n = `text` v = ` February 20, 2020`

                        )->shut(

                        )->open( n = `HBox` ns = `m`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text`  v = `Changed By:`
                                )->a( n = `class` v = `sapUiSmallMarginEnd`
                            )->leaf( n = `Link` ns = `m`
                                )->a( n = `text` v = `John Miller`

                        )->shut(

                        )->open( n = `HBox` ns = `m`
                            )->a( n = `renderType` v = `Bare`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text`  v = `Changed On:`
                                )->a( n = `class` v = `sapUiSmallMarginEnd`
                            )->leaf( n = `Text` ns = `m`
                                )->a( n = `text` v = ` February 20, 2020`

                        )->shut(
                    )->shut(

                    )->open( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiSmallMarginEnd sapUiSmallMarginBottom`

                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Product Description`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`
                        )->leaf( n = `Text` ns = `m`
                            )->a( n = `width` v = `320px`
                            )->a( n = `text`
                                     v = `Top-design high-quality coffee mug - ideal for a comforting moment; Pack: 6; material: Porcelain - durable dishwasher and ` &&
                                         `microwave-safe porcelain that cleans easily and is ideal for everyday service. Comes in two bright colors.`

                    )->shut(

                    )->open( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiSmallMarginEnd sapUiSmallMarginBottom`

                        )->open( n = `Title` ns = `m`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`

                            )->leaf( n = `Link` ns = `m`
                                )->a( n = `text` v = `Status`

                        )->shut(

                        )->leaf( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `Delivery`
                            )->a( n = `state` v = `Success`
                            )->a( n = `class` v = `sapMObjectStatusLarge`

                    )->shut(

                    )->open( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiSmallMarginEnd sapUiSmallMarginBottom`

                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Delivery Time`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`
                        )->leaf( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `12 Days`
                            )->a( n = `icon`  v = `sap-icon://shipping-status`
                            )->a( n = `class` v = `sapMObjectStatusLarge`

                    )->shut(

                    )->open( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiSmallMarginEnd sapUiSmallMarginBottom`

                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Assembly Option`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`
                        )->leaf( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `To Be Selected`
                            )->a( n = `state` v = `Error`
                            )->a( n = `class` v = `sapMObjectStatusLarge`

                    )->shut(

                    )->open( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`

                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Price`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`
                        )->leaf( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `579 EUR`
                            )->a( n = `class` v = `sapMObjectStatusLarge`

                    )->shut(

                    )->open( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiMediumMarginEnd sapUiSmallMarginBottom`

                        )->open( n = `Title` ns = `m`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`

                            )->leaf( n = `Link` ns = `m`
                                )->a( n = `text` v = `Average User Rating`

                        )->shut(

                        )->leaf( n = `Label` ns = `m`
                            )->a( n = `text` v = `6 Reviews`
                        )->leaf( n = `RatingIndicator` ns = `m`
                            )->a( n = `value`    v = `4`
                            )->a( n = `iconSize` v = `16px`

                        )->open( n = `VBox` ns = `m`
                            )->a( n = `alignItems` v = `End`

                            )->leaf( n = `Text` ns = `m`
                                )->a( n = `text` v = `4.1 out of 5`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( `sections`
                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `id`             v = `goalsSection`
                    )->a( n = `title`          v = `2014 Goals Plan`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `id`             v = `goalsSectionSS1`
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
                    )->a( n = `id`             v = `personalSection`
                    )->a( n = `title`          v = `Personal`
                    )->a( n = `importance`     v = `Medium`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `id`             v = `personalSectionSS1`
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

                            " personal:BlockMailing (columnLayout="1") inlined
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
                            )->a( n = `id`             v = `personalSectionSS2`
                            )->a( n = `title`          v = `Payment information`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`

                                " personal:PersonalBlockPart1 (columnLayout="1") inlined
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

                                " personal:PersonalBlockPart2 (columnLayout="1") inlined
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
                    )->a( n = `id`             v = `employmentSection`
                    )->a( n = `title`          v = `Employment`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `id`             v = `employmentSectionSS1`
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
                            )->a( n = `id`             v = `employmentSectionSS2`
                            )->a( n = `title`          v = `Employee Details`
                            )->a( n = `importance`     v = `Medium`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`

                                " employment:BlockEmpDetailPart1 (columnLayout="1") inlined
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

                                " employment:BlockEmpDetailPart2 (columnLayout="1") inlined
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

                                " employment:BlockEmpDetailPart3 (columnLayout="1") inlined
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
                        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
