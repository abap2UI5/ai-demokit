" @keywords objectpagelayout object layout sap.uxap objectpagewithheadercontainer objectpagedynamicheadertitle objectpagesection objectpagesubsection
" @summary ObjectPage sample with Header Container
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
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " Block->content inlining (app 188/217/261 precedent): the blocks and
    " moreBlocks aggregations hold SharedBlocks BlockBase controls, each a
    " lazy-loading wrapper around a static view - inlined 1:1 below. This
    " sample has no Job Relationship subsection, so no ModelMapping fold.
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
            )->a( n = `showTitleInHeaderContent` v = `true`
            )->a( n = `upperCaseAnchorBar`       v = `false`

            )->ele( `headerTitle`
                )->ele( `ObjectPageDynamicHeaderTitle`
                    )->ele( `expandedHeading`
                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text`     v = `Object Page Header with Header Container`
                            )->a( n = `wrapping` v = `true`

                    )->end(

                    )->ele( `snappedHeading`
                        )->ele( n = `HBox` ns = `m`
                            )->ele( n = `VBox` ns = `m`
                                )->tag( n = `Avatar` ns = `m`
                                    )->a( n = `src`   v = `./test-resources/sap/uxap/images/imageID_275314.png`
                                    )->a( n = `class` v = `sapUiSmallMarginEnd`

                            )->end(
                            )->ele( n = `VBox` ns = `m`
                                )->tag( n = `Title` ns = `m`
                                    )->a( n = `text`     v = `Object Page Header with Header Container`
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
                            )->a( n = `text` v = `Object Page Header with Header Container`

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
                )->ele( n = `HeaderContainer` ns = `m`
                    )->a( n = `id`            v = `headerContainer`
                    )->a( n = `scrollStep`    v = `200`
                    )->a( n = `showDividers`  v = `false`

                    )->ele( n = `HBox` ns = `m`
                        )->a( n = `class` v = `sapUiSmallMarginEnd sapUiSmallMarginBottom`

                        )->tag( n = `Avatar` ns = `m`
                            )->a( n = `src`         v = `./test-resources/sap/uxap/images/imageID_275314.png`
                            )->a( n = `class`       v = `sapUiMediumMarginEnd`
                            )->a( n = `displaySize` v = `L`

                        )->ele( n = `VBox` ns = `m`
                            )->a( n = `class` v = `sapUiSmallMarginBottom`

                            )->ele( n = `Title` ns = `m`
                                )->a( n = `class` v = `sapUiTinyMarginBottom`

                                )->tag( n = `Link` ns = `m`
                                    )->a( n = `text` v = `Order Details`

                            )->end(

                            )->ele( n = `HBox` ns = `m`
                                )->a( n = `class`      v = `sapUiTinyMarginBottom`
                                )->a( n = `renderType` v = `Bare`

                                )->tag( n = `Label` ns = `m`
                                    )->a( n = `text`  v = `Manufacturer:`
                                    )->a( n = `class` v = `sapUiTinyMarginEnd`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = ` Robotech`

                            )->end(

                            )->ele( n = `HBox` ns = `m`
                                )->a( n = `class`      v = `sapUiTinyMarginBottom`
                                )->a( n = `renderType` v = `Bare`

                                )->tag( n = `Label` ns = `m`
                                    )->a( n = `text`  v = `Factory:`
                                    )->a( n = `class` v = `sapUiTinyMarginEnd`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = ` Florida, OL`

                            )->end(

                            )->ele( n = `HBox` ns = `m`
                                )->tag( n = `Label` ns = `m`
                                    )->a( n = `text`  v = `Supplier:`
                                    )->a( n = `class` v = `sapUiTinyMarginEnd`
                                )->tag( n = `Link` ns = `m`
                                    )->a( n = `text` v = `Robotech (234242343)`

                            )->end(
                        )->end(
                    )->end(

                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiSmallMarginEnd sapUiSmallMarginBottom`

                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Contact Information`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`

                        )->ele( n = `HBox` ns = `m`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`

                            )->tag( n = `Icon` ns = `core`
                                )->a( n = `src` v = `sap-icon://account`
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text`  v = ` John Miller`
                                )->a( n = `class` v = `sapUiSmallMarginBegin`

                        )->end(

                        )->ele( n = `HBox` ns = `m`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`

                            )->tag( n = `Icon` ns = `core`
                                )->a( n = `src` v = `sap-icon://outgoing-call`
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text`  v = ` +1 234 5678`
                                )->a( n = `class` v = `sapUiSmallMarginBegin`

                        )->end(

                        )->ele( n = `HBox` ns = `m`
                            )->tag( n = `Icon` ns = `core`
                                )->a( n = `src` v = `sap-icon://email`
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text`  v = `john.miller@company.com`
                                )->a( n = `class` v = `sapUiSmallMarginBegin`

                        )->end(
                    )->end(

                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiSmallMarginEnd sapUiSmallMarginBottom`

                        )->ele( n = `HBox` ns = `m`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text`  v = `Created By:`
                                )->a( n = `class` v = `sapUiSmallMarginEnd`
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text` v = `Julie Armstrong`

                        )->end(

                        )->ele( n = `HBox` ns = `m`
                            )->a( n = `class`      v = `sapUiTinyMarginBottom`
                            )->a( n = `renderType` v = `Bare`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text`  v = `Created On:`
                                )->a( n = `class` v = `sapUiSmallMarginEnd`
                            )->tag( n = `Text` ns = `m`
                                )->a( n = `text` v = ` February 20, 2020`

                        )->end(

                        )->ele( n = `HBox` ns = `m`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text`  v = `Changed By:`
                                )->a( n = `class` v = `sapUiSmallMarginEnd`
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text` v = `John Miller`

                        )->end(

                        )->ele( n = `HBox` ns = `m`
                            )->a( n = `renderType` v = `Bare`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text`  v = `Changed On:`
                                )->a( n = `class` v = `sapUiSmallMarginEnd`
                            )->tag( n = `Text` ns = `m`
                                )->a( n = `text` v = ` February 20, 2020`

                        )->end(
                    )->end(

                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiSmallMarginEnd sapUiSmallMarginBottom`

                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Product Description`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`
                        )->tag( n = `Text` ns = `m`
                            )->a( n = `width` v = `320px`
                            )->a( n = `text`
                                     v = `Top-design high-quality coffee mug - ideal for a comforting moment; Pack: 6; material: Porcelain - durable dishwasher and ` &&
                                         `microwave-safe porcelain that cleans easily and is ideal for everyday service. Comes in two bright colors.`

                    )->end(

                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiSmallMarginEnd sapUiSmallMarginBottom`

                        )->ele( n = `Title` ns = `m`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`

                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text` v = `Status`

                        )->end(

                        )->tag( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `Delivery`
                            )->a( n = `state` v = `Success`
                            )->a( n = `class` v = `sapMObjectStatusLarge`

                    )->end(

                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiSmallMarginEnd sapUiSmallMarginBottom`

                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Delivery Time`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`
                        )->tag( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `12 Days`
                            )->a( n = `icon`  v = `sap-icon://shipping-status`
                            )->a( n = `class` v = `sapMObjectStatusLarge`

                    )->end(

                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiSmallMarginEnd sapUiSmallMarginBottom`

                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Assembly Option`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`
                        )->tag( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `To Be Selected`
                            )->a( n = `state` v = `Error`
                            )->a( n = `class` v = `sapMObjectStatusLarge`

                    )->end(

                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`

                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Price`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`
                        )->tag( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `579 EUR`
                            )->a( n = `class` v = `sapMObjectStatusLarge`

                    )->end(

                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiMediumMarginEnd sapUiSmallMarginBottom`

                        )->ele( n = `Title` ns = `m`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`

                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text` v = `Average User Rating`

                        )->end(

                        )->tag( n = `Label` ns = `m`
                            )->a( n = `text` v = `6 Reviews`
                        )->tag( n = `RatingIndicator` ns = `m`
                            )->a( n = `value`    v = `4`
                            )->a( n = `iconSize` v = `16px`

                        )->ele( n = `VBox` ns = `m`
                            )->a( n = `alignItems` v = `End`

                            )->tag( n = `Text` ns = `m`
                                )->a( n = `text` v = `4.1 out of 5`

                        )->end(
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
                    )->a( n = `importance`     v = `Medium`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `id`             v = `personalSectionSS1`
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

                                " personal:BlockMailing (columnLayout="1") inlined
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
                            )->a( n = `id`             v = `personalSectionSS2`
                            )->a( n = `title`          v = `Payment information`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`

                                " personal:PersonalBlockPart1 (columnLayout="1") inlined
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

                                " personal:PersonalBlockPart2 (columnLayout="1") inlined
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
                            )->a( n = `id`             v = `employmentSectionSS2`
                            )->a( n = `title`          v = `Employee Details`
                            )->a( n = `importance`     v = `Medium`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`

                                " employment:BlockEmpDetailPart1 (columnLayout="1") inlined
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

                                " employment:BlockEmpDetailPart2 (columnLayout="1") inlined
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

                                " employment:BlockEmpDetailPart3 (columnLayout="1") inlined
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
                        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
