CLASS z2ui5_cl_dmo_app_412 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_dmo_app_412 IMPLEMENTATION.

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

    " Block->content inlining (app 402 precedent): the blocks and moreBlocks
    " aggregations hold SharedBlocks BlockBase controls, each a lazy-loading
    " wrapper around a static view - inlined 1:1 below.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:forms`  v = `sap.ui.layout.form`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `height`       v = `100%`

        )->open( `ObjectPageLayout`
            )->a( n = `id`                       v = `ObjectPageLayout`
            )->a( n = `showTitleInHeaderContent` v = `true`
            )->a( n = `upperCaseAnchorBar`       v = `false`

            )->open( `headerTitle`
                )->open( `ObjectPageDynamicHeaderTitle`
                    )->open( `expandedHeading`
                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text`     v = `Object Page Header with Links, Rating Indicator, and Object Status`
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
                                    )->a( n = `text`     v = `Object Page Header with Links, Rating Indicator, and Object Status`
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
                            )->a( n = `text` v = `Object Page Header with Links, Rating Indicator, and Object Status`

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
                )->open( n = `FlexBox` ns = `m`
                    )->a( n = `wrap`         v = `Wrap`
                    )->a( n = `fitContainer` v = `true`

                    )->leaf( n = `Avatar` ns = `m`
                        )->a( n = `src`         v = `./test-resources/sap/uxap/images/imageID_275314.png`
                        )->a( n = `class`       v = `sapUiMediumMarginEnd`
                        )->a( n = `displaySize` v = `L`

                    )->open( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

                        )->open( n = `Title` ns = `m`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`

                            " onOrderDetailsPress: selectedSection is an association (not bindable),
                            " scrolled roundtrip-free via the control_by_id frontend action
                            )->leaf( n = `Link` ns = `m`
                                )->a( n = `text`  v = `Order Details`
                                )->a( n = `press` v = client->_event_client( val   = client->cs_event-control_by_id
                                                                             t_arg = VALUE #( ( `ObjectPageLayout` ) ( `setSelectedSection` ) ( `orderDetailsSection` ) ) )

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
                                )->a( n = `text`  v = `Robotech (234242343)`
                                )->a( n = `press` v = client->_event_client( val   = client->cs_event-control_global
                                                                             t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Navigate to external application.` ) ) )

                        )->shut(
                    )->shut(

                    )->open( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

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
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

                        )->open( n = `HBox` ns = `m`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text`  v = `Created By:`
                                )->a( n = `class` v = `sapUiSmallMarginEnd`
                            " handleTitleSelectorPress: the QuickView popover opens anchored
                            " at the pressed link, transported via $event.oSource.sId
                            )->leaf( n = `Link` ns = `m`
                                )->a( n = `text`  v = `Julie Armstrong`
                                )->a( n = `press` v = client->_event( val   = `TITLE_SELECTOR`
                                                                      t_arg = VALUE #( ( `$event.oSource.sId` ) ) )

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
                                )->a( n = `text`  v = `John Miller`
                                )->a( n = `press` v = client->_event( val   = `TITLE_SELECTOR`
                                                                      t_arg = VALUE #( ( `$event.oSource.sId` ) ) )

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
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

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
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

                        )->open( n = `Title` ns = `m`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`

                            )->leaf( n = `Link` ns = `m`
                                )->a( n = `text`  v = `Status`
                                )->a( n = `press` v = client->_event_client( val   = client->cs_event-control_global
                                                                             t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` )
                                                                                              ( `Navigate to another page in the same application (List of delivery items)` ) ) )

                        )->shut(

                        )->leaf( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `Delivery`
                            )->a( n = `state` v = `Success`
                            )->a( n = `class` v = `sapMObjectStatusLarge`

                    )->shut(

                    )->open( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Delivery Time`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`
                        )->leaf( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `12 Days`
                            )->a( n = `icon`  v = `sap-icon://shipping-status`
                            )->a( n = `class` v = `sapMObjectStatusLarge`

                    )->shut(

                    )->open( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Assembly Option`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`
                        )->leaf( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `To Be Selected`
                            )->a( n = `state` v = `Error`
                            )->a( n = `class` v = `sapMObjectStatusLarge`

                    )->shut(

                    )->open( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiLargeMarginEnd`

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
                                )->a( n = `text`  v = `Average User Rating`
                                )->a( n = `press` v = client->_event_client( val   = client->cs_event-control_global
                                                                             t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Navigate to external application.` ) ) )

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
                    )->a( n = `anchorBarButtonColor` v = `Negative`
                    )->a( n = `titleUppercase`       v = `false`
                    )->a( n = `id`                   v = `goalsSection`
                    )->a( n = `title`                v = `2014 Goals Plan`

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
                    )->a( n = `anchorBarButtonColor` v = `Positive`
                    )->a( n = `titleUppercase`       v = `false`
                    )->a( n = `id`                   v = `personalSection`
                    )->a( n = `title`                v = `Personal`
                    )->a( n = `importance`           v = `Medium`

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
                    )->a( n = `anchorBarButtonColor` v = `Critical`
                    )->a( n = `titleUppercase`       v = `false`
                    )->a( n = `id`                   v = `employmentSection`
                    )->a( n = `title`                v = `Employment`

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
                        )->shut(
                    )->shut(
                )->shut(

                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `id`             v = `orderDetailsSection`
                    )->a( n = `title`          v = `Order Details`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`     v = `Order Details`
                            )->a( n = `showTitle` v = `false`

                            )->open( `blocks`
                                )->open( n = `SimpleForm` ns = `forms`
                                    )->a( n = `class`     v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `layout`    v = `ColumnLayout`
                                    )->a( n = `columnsM`  v = `2`
                                    )->a( n = `columnsL`  v = `3`
                                    )->a( n = `columnsXL` v = `4`

                                    )->leaf( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Order Details`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Order ID`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `589946637`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Cotract`
                                    )->leaf( n = `Link` ns = `m`
                                        )->a( n = `text` v = `10045876`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Transaction Date:`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `May 6, 2018`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Expected Delivery Date`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `June 23, 2018`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Factory`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Orlando, FL`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Supplier`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Robotech`
                                    )->leaf( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Configuration Accounts`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Model`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Robot Arm Series 9`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Color`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `White (default)`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Socket`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Default Socket 10`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Leasing Instalment`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `379.99 USD per month`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Axis`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `6 Axis`

                                )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `TITLE_SELECTOR`.
        " handleTitleSelectorPress: open the QuickView anchored at the pressed link
        popup_quickview_display( client->get_event_arg( ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_quickview_display.

    DATA(popup) = z2ui5_cl_ai_xml=>factory( ).

    " the fragment's navigate='.onNavigate' is dropped - the sample's
    " controller defines no onNavigate handler, the wire is dead upstream
    popup->open( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( `QuickView`
            )->a( n = `id`    v = `quickView`
            )->a( n = `pages` v = client->_bind( t_pages )

            )->open( `QuickViewPage`
                )->a( n = `pageId`      v = `{PAGEID}`
                )->a( n = `header`      v = `{HEADER}`
                )->a( n = `title`       v = `{TITLE}`
                )->a( n = `titleUrl`    v = `{TITLEURL}`
                )->a( n = `description` v = `{DESCRIPTION}`
                )->a( n = `groups`      v = `{path: 'GROUPS', templateShareable: true}`

                )->open( `avatar`
                    )->leaf( `Avatar`
                        )->a( n = `src`          v = `{ICON}`
                        )->a( n = `displayShape` v = `{DISPLAYSHAPE}`

                )->shut(
                )->open( `QuickViewGroup`
                    )->a( n = `heading`  v = `{HEADING}`
                    )->a( n = `elements` v = `{path: 'ELEMENTS', templateShareable: true}`

                    )->leaf( `QuickViewGroupElement`
                        )->a( n = `label`        v = `{LABEL}`
                        )->a( n = `value`        v = `{VALUE}`
                        )->a( n = `url`          v = `{URL}`
                        )->a( n = `type`         v = `{ELEMENTTYPE}`
                        )->a( n = `pageLinkId`   v = `{PAGELINKID}`
                        )->a( n = `emailSubject` v = `{EMAILSUBJECT}`
                        )->a( n = `target`       v = `{TARGET}`

                )->shut(
            )->shut(
        )->shut( ).

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
