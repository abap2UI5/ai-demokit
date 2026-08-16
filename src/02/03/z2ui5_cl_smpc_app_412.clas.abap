" @keywords headerfacetpattern header facet pattern sap.uxap objectpagewithlinksandobjectstatus objectpagelayout objectpagedynamicheadertitle objectpagesection objectpagesubsection quickview quickviewpage
CLASS z2ui5_cl_smpc_app_412 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_element,
             label        TYPE string,
             value        TYPE string,
             url          TYPE string,
             elementtype  TYPE string,
             pagelinkid   TYPE string,
             emailsubject TYPE string,
             target       TYPE string,
           END OF ty_s_element.
    TYPES ty_t_element TYPE STANDARD TABLE OF ty_s_element WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_group,
             heading  TYPE string,
             elements TYPE ty_t_element,
           END OF ty_s_group.
    TYPES ty_t_group TYPE STANDARD TABLE OF ty_s_group WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_page,
             pageid       TYPE string,
             header       TYPE string,
             title        TYPE string,
             titleurl     TYPE string,
             icon         TYPE string,
             displayshape TYPE string,
             description  TYPE string,
             groups       TYPE ty_t_group,
           END OF ty_s_page.
    TYPES ty_t_page TYPE STANDARD TABLE OF ty_s_page WITH EMPTY KEY.
    DATA t_pages TYPE ty_t_page.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_quickview_display IMPORTING by_id TYPE string.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_412 IMPLEMENTATION.

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

    " Block->content inlining (app 402 precedent): the blocks and moreBlocks
    " aggregations hold SharedBlocks BlockBase controls, each a lazy-loading
    " wrapper around a static view - inlined 1:1 below.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:forms`  v = `sap.ui.layout.form`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `height`       v = `100%`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                       v = `ObjectPageLayout`
            )->a( n = `showTitleInHeaderContent` v = `true`
            )->a( n = `upperCaseAnchorBar`       v = `false`

            )->ele( `headerTitle`
                )->ele( `ObjectPageDynamicHeaderTitle`
                    )->ele( `expandedHeading`
                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text`     v = `Object Page Header with Links, Rating Indicator, and Object Status`
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
                                    )->a( n = `text`     v = `Object Page Header with Links, Rating Indicator, and Object Status`
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
                            )->a( n = `text` v = `Object Page Header with Links, Rating Indicator, and Object Status`

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
                        )->a( n = `src`         v = `./test-resources/sap/uxap/images/imageID_275314.png`
                        )->a( n = `class`       v = `sapUiMediumMarginEnd`
                        )->a( n = `displaySize` v = `L`

                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

                        )->ele( n = `Title` ns = `m`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`

                            " onOrderDetailsPress: selectedSection is an association (not bindable),
                            " scrolled roundtrip-free via the control_by_id frontend action
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text`  v = `Order Details`
                                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                                t_arg = VALUE #( ( `ObjectPageLayout` ) ( `setSelectedSection` ) ( `orderDetailsSection` ) ) )

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
                                )->a( n = `text`  v = `Robotech (234242343)`
                                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Navigate to external application.` ) ) )

                        )->end(
                    )->end(

                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

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
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

                        )->ele( n = `HBox` ns = `m`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text`  v = `Created By:`
                                )->a( n = `class` v = `sapUiSmallMarginEnd`
                            " handleTitleSelectorPress: the QuickView popover opens anchored
                            " at the pressed link, transported via $event.oSource.sId
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text`  v = `Julie Armstrong`
                                )->a( n = `press` v = client->_event( val   = `TITLE_SELECTOR`
                                                                      t_arg = VALUE #( ( `$event.oSource.sId` ) ) )

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
                                )->a( n = `text`  v = `John Miller`
                                )->a( n = `press` v = client->_event( val   = `TITLE_SELECTOR`
                                                                      t_arg = VALUE #( ( `$event.oSource.sId` ) ) )

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
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

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
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

                        )->ele( n = `Title` ns = `m`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`

                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text`  v = `Status`
                                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` )
                                                                                              ( `Navigate to another page in the same application (List of delivery items)` ) ) )

                        )->end(

                        )->tag( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `Delivery`
                            )->a( n = `state` v = `Success`
                            )->a( n = `class` v = `sapMObjectStatusLarge`

                    )->end(

                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Delivery Time`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`
                        )->tag( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `12 Days`
                            )->a( n = `icon`  v = `sap-icon://shipping-status`
                            )->a( n = `class` v = `sapMObjectStatusLarge`

                    )->end(

                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Assembly Option`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`
                        )->tag( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `To Be Selected`
                            )->a( n = `state` v = `Error`
                            )->a( n = `class` v = `sapMObjectStatusLarge`

                    )->end(

                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiLargeMarginEnd`

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
                                )->a( n = `text`  v = `Average User Rating`
                                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Navigate to external application.` ) ) )

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
                    )->a( n = `anchorBarButtonColor` v = `Negative`
                    )->a( n = `titleUppercase`       v = `false`
                    )->a( n = `id`                   v = `goalsSection`
                    )->a( n = `title`                v = `2014 Goals Plan`

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
                    )->a( n = `anchorBarButtonColor` v = `Positive`
                    )->a( n = `titleUppercase`       v = `false`
                    )->a( n = `id`                   v = `personalSection`
                    )->a( n = `title`                v = `Personal`
                    )->a( n = `importance`           v = `Medium`

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
                    )->a( n = `anchorBarButtonColor` v = `Critical`
                    )->a( n = `titleUppercase`       v = `false`
                    )->a( n = `id`                   v = `employmentSection`
                    )->a( n = `title`                v = `Employment`

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
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `id`             v = `orderDetailsSection`
                    )->a( n = `title`          v = `Order Details`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`     v = `Order Details`
                            )->a( n = `showTitle` v = `false`

                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `class`     v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `layout`    v = `ColumnLayout`
                                    )->a( n = `columnsM`  v = `2`
                                    )->a( n = `columnsL`  v = `3`
                                    )->a( n = `columnsXL` v = `4`

                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Order Details`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Order ID`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `589946637`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Cotract`
                                    )->tag( n = `Link` ns = `m`
                                        )->a( n = `text` v = `10045876`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Transaction Date:`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `May 6, 2018`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Expected Delivery Date`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `June 23, 2018`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Factory`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Orlando, FL`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Supplier`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Robotech`
                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Configuration Accounts`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Model`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Robot Arm Series 9`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Color`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `White (default)`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Socket`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Default Socket 10`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Leasing Instalment`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `379.99 USD per month`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Axis`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `6 Axis`

                                )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `TITLE_SELECTOR`.
      " handleTitleSelectorPress: open the QuickView anchored at the pressed link
      popup_quickview_display( client->get_event_arg( ) ).
    ENDIF.

  ENDMETHOD.


  METHOD popup_quickview_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

    " the fragment's navigate='.onNavigate' is dropped - the sample's
    " controller defines no onNavigate handler, the wire is dead upstream
    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `QuickView`
            )->a( n = `id`    v = `quickView`
            )->a( n = `pages` v = client->_bind( t_pages )

            )->ele( `QuickViewPage`
                )->a( n = `pageId`      v = `{PAGEID}`
                )->a( n = `header`      v = `{HEADER}`
                )->a( n = `title`       v = `{TITLE}`
                )->a( n = `titleUrl`    v = `{TITLEURL}`
                )->a( n = `description` v = `{DESCRIPTION}`
                )->a( n = `groups`      v = `{path: 'GROUPS', templateShareable: true}`

                )->ele( `avatar`
                    )->tag( `Avatar`
                        )->a( n = `src`          v = `{ICON}`
                        )->a( n = `displayShape` v = `{DISPLAYSHAPE}`

                )->end(
                )->ele( `QuickViewGroup`
                    )->a( n = `heading`  v = `{HEADING}`
                    )->a( n = `elements` v = `{path: 'ELEMENTS', templateShareable: true}`

                    )->tag( `QuickViewGroupElement`
                        )->a( n = `label`        v = `{LABEL}`
                        )->a( n = `value`        v = `{VALUE}`
                        )->a( n = `url`          v = `{URL}`
                        )->a( n = `type`         v = `{ELEMENTTYPE}`
                        )->a( n = `pageLinkId`   v = `{PAGELINKID}`
                        )->a( n = `emailSubject` v = `{EMAILSUBJECT}`
                        )->a( n = `target`       v = `{TARGET}`

                )->end(
            )->end(
        )->end( ).

    client->popover_display( xml   = popup->stringify( )
                             by_id = by_id ).

  ENDMETHOD.


  METHOD model_init.

    " CompanyData.json /pages verbatim. target seeds the UI5 default '_blank'
    " explicitly, and the page-2 Address/Slogan rows seed elementtype 'text'
    " (the QuickViewGroupElementType default) - a serialized empty string
    " would override the UI5 enum/property defaults
    t_pages = VALUE #(
      ( pageid       = `companyPageId`
        header       = `Company Info`
        title        = `Adventure Company`
        titleurl     = `http://sap.com`
        icon         = `sap-icon://building`
        displayshape = `Square`
        description  = `John Doe`
        groups       = VALUE #(
          ( heading  = `Contact Details`
            elements = VALUE #(
              ( label = `Phone`   value = `+001 6101 34869-0` elementtype = `phone` target = `_blank` )
              ( label = `Address` value = `550 Larkin Street, 4F, Mountain View, CA, 94102 San Francisco USA` elementtype = `text` target = `_blank` ) ) )
          ( heading  = `Main Contact`
            elements = VALUE #(
              ( label = `Name`   value = `John Doe`                 elementtype = `pageLink` pagelinkid = `companyEmployeePageId` target = `_blank` )
              ( label = `Mobile` value = `+001 6101 34869-0`        elementtype = `mobile` target = `_blank` )
              ( label = `Phone`  value = `+001 6101 34869-0`        elementtype = `phone` target = `_blank` )
              ( label = `Email`  value = `main.contact@company.com` elementtype = `email` emailsubject = `Subject` target = `_blank` ) ) ) ) )
      ( pageid       = `companyEmployeePageId`
        header       = `Employee Info`
        title        = `John Doe`
        icon         = `sap-icon://person-placeholder`
        displayshape = `Circle`
        description  = `Department Manager`
        groups       = VALUE #(
          ( heading  = `Company`
            elements = VALUE #(
              ( label = `Name`    value = `Adventure Company`             url = `http://sap.com` elementtype = `link` target = `_blank` )
              ( label = `Address` value = `Sofia, Boris III, 136A`        elementtype = `text` target = `_blank` )
              ( label = `Slogan`  value = `Innovation through technology` elementtype = `text` target = `_blank` ) ) )
          ( heading  = `Other`
            elements = VALUE #(
              ( label = `Email` value = `john.doe@sap.com`  elementtype = `email` emailsubject = `Subject` target = `_blank` )
              ( label = `Phone` value = `+359 888 888 888`  elementtype = `phone` target = `_blank` ) ) ) ) ) ).

  ENDMETHOD.

ENDCLASS.
