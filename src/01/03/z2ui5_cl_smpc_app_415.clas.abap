CLASS z2ui5_cl_smpc_app_415 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        text TYPE string,
      END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    DATA productcollection TYPE ty_t_product.
    DATA text TYPE string.
    DATA icon TYPE string.
    DATA formatted_text TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popover_select_display.
    METHODS popover_lock_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_415 IMPLEMENTATION.

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

    " Block->content inlining (app 217/188/161 precedent, CAPABILITIES 'Custom
    " BlockBase blocks in a sap.uxap.ObjectPageLayout'): the original blocks
    " and moreBlocks aggregations hold custom BlockBase controls from the
    " sample's SharedBlocks JS - a BlockBase is only a lazy-loading wrapper
    " around a view, so each block's content (a sap.ui.layout.form.SimpleForm)
    " is inlined directly here.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
        )->a( n = `height`       v = `100%`

        )->open( `ObjectPageLayout`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->open( `headerTitle`
                " the two press events transport the pressed control's id via
                " $event.oSource.sId as the popover anchor (the original anchors
                " at oEvent.getParameter('domRef') - see the sidecar note);
                " objectImageURI absolutized from ./test-resources/... to the
                " sdk.openui5.org host (asset-URL rule)
                )->open( `ObjectPageHeader`
                    )->a( n = `id`                   v = `headerForTest`
                    )->a( n = `objectTitle`          v = `Long title that wraps and goes over more lines`
                    )->a( n = `showTitleSelector`    v = `true`
                    )->a( n = `titleSelectorPress`   v = client->_event( val   = `TITLE_SELECTOR`
                                                                         t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                    )->a( n = `showMarkers`          v = `true`
                    )->a( n = `markFavorite`         v = `true`
                    )->a( n = `markLocked`           v = `true`
                    )->a( n = `markFlagged`          v = `true`
                    )->a( n = `markLockedPress`      v = client->_event( val   = `MARK_LOCKED`
                                                                         t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                    )->a( n = `objectSubtitle`       v = `Long subtitle that wraps and goes over more lines`
                    )->a( n = `objectImageShape`     v = `Circle`
                    )->a( n = `objectImageURI`       v = `https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_275314.png`
                    )->a( n = `titleSelectorTooltip` v = `Custom Tooltip`

                    )->open( `actions`
                        )->leaf( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`       v = `sap-icon://action`
                            )->a( n = `text`       v = `action`
                            )->a( n = `importance` v = `Low`
                            )->a( n = `tooltip`    v = `action`
                        )->leaf( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`       v = `sap-icon://action-settings`
                            )->a( n = `text`       v = `settings`
                            )->a( n = `importance` v = `Low`
                            )->a( n = `tooltip`    v = `action-settings`
                        )->leaf( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`       v = `sap-icon://edit`
                            )->a( n = `text`       v = `edit`
                            )->a( n = `importance` v = `Medium`
                            )->a( n = `tooltip`    v = `edit`
                        )->leaf( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = `sap-icon://save`
                            )->a( n = `text`    v = `save`
                            )->a( n = `visible` v = `false`
                            )->a( n = `tooltip` v = `save`
                        " the 'buttons' named model (text/icon) is flattened into
                        " the default model; the original's .onFormat formatter
                        " returns the constant 'formatted link', computed in
                        " model_init per the thin-frontend rule
                        )->leaf( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = `sap-icon://refresh`
                            )->a( n = `text`    v = client->_bind( text )
                            )->a( n = `tooltip` v = `refresh`
                        )->leaf( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = client->_bind( icon )
                            )->a( n = `text`    v = client->_bind( formatted_text )
                            )->a( n = `tooltip` v = `chain-link`

                    )->shut(

                    )->open( `breadcrumbs`
                        )->open( n = `Breadcrumbs` ns = `m`
                            )->leaf( n = `Link` ns = `m`
                                )->a( n = `text`  v = `Page 1 a very long link`
                                )->a( n = `press` v = client->_event( `LINK1` )
                            )->leaf( n = `Link` ns = `m`
                                )->a( n = `text`  v = `Page 2 long link`
                                )->a( n = `press` v = client->_event( `LINK2` )

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( `headerContent`
                )->open( n = `VerticalLayout` ns = `layout`
                    )->leaf( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `User ID`
                        )->a( n = `text`  v = `12345678`
                    )->leaf( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `Functional Area`
                        )->a( n = `text`  v = `Developement`
                    )->leaf( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `Cost Center`
                        )->a( n = `text`  v = `PI DFA GD Programs and Product`
                    )->leaf( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `Email`
                        )->a( n = `text`  v = `email@address.com`

                )->shut(

                )->leaf( n = `Text` ns = `m`
                    )->a( n = `width` v = `200px`
                    )->a( n = `text`  v = `Hi, I'm Denise. I am passionate about what I do and I'll go the extra mile to make the customer win.`

                )->leaf( n = `ObjectStatus` ns = `m`
                    )->a( n = `text`  v = `In Stock`
                    )->a( n = `state` v = `Error`

                )->leaf( n = `ObjectStatus` ns = `m`
                    )->a( n = `title` v = `Label`
                    )->a( n = `text`  v = `In Stock`
                    )->a( n = `state` v = `Warning`

                )->leaf( n = `ObjectNumber` ns = `m`
                    )->a( n = `number`     v = `1000`
                    )->a( n = `unit`       v = `SOOK`
                    )->a( n = `emphasized` v = `false`
                    )->a( n = `state`      v = `Success`

                )->leaf( n = `ProgressIndicator` ns = `m`
                    )->a( n = `percentValue` v = `30`
                    )->a( n = `displayValue` v = `30%`
                    )->a( n = `showValue`    v = `true`
                    )->a( n = `state`        v = `None`

                )->open( n = `VerticalLayout` ns = `layout`
                    )->leaf( n = `Label` ns = `m`
                        )->a( n = `text` v = `PC, Unrestricted-Use Stock`
                    )->leaf( n = `ObjectNumber` ns = `m`
                        )->a( n = `class`  v = `sapMObjectNumberLarge`
                        )->a( n = `number` v = `219`
                        )->a( n = `unit`   v = `K`

                )->shut(

                )->open( n = `VerticalLayout` ns = `layout`
                    )->open( n = `layoutData` ns = `layout`
                        )->leaf( `ObjectPageHeaderLayoutData`
                            )->a( n = `visibleS` v = `false`

                    )->shut(
                    )->leaf( n = `Label` ns = `m`
                        )->a( n = `text` v = `PC, Not in Small Size`
                    )->leaf( n = `ObjectNumber` ns = `m`
                        )->a( n = `class`  v = `sapMObjectNumberLarge`
                        )->a( n = `number` v = `220`
                        )->a( n = `unit`   v = `K`

                )->shut(

                )->open( n = `VerticalLayout` ns = `layout`
                    )->open( n = `layoutData` ns = `layout`
                        )->leaf( `ObjectPageHeaderLayoutData`
                            )->a( n = `visibleM` v = `false`

                    )->shut(
                    )->leaf( n = `Label` ns = `m`
                        )->a( n = `text` v = `PC, Not in Medium Size`
                    )->leaf( n = `ObjectNumber` ns = `m`
                        )->a( n = `class`  v = `sapMObjectNumberLarge`
                        )->a( n = `number` v = `221`
                        )->a( n = `unit`   v = `K`

                )->shut(

                )->open( n = `VerticalLayout` ns = `layout`
                    )->open( n = `layoutData` ns = `layout`
                        )->leaf( `ObjectPageHeaderLayoutData`
                            )->a( n = `visibleL` v = `false`

                    )->shut(
                    )->leaf( n = `Label` ns = `m`
                        )->a( n = `text` v = `PC, Not in Large Size`
                    )->leaf( n = `ObjectNumber` ns = `m`
                        )->a( n = `class`  v = `sapMObjectNumberLarge`
                        )->a( n = `number` v = `219`
                        )->a( n = `unit`   v = `K`

                )->shut(

                )->leaf( n = `ObjectAttribute` ns = `m`
                    )->a( n = `title` v = `Label`
                    )->a( n = `text`  v = `In Stock`

                )->leaf( n = `Button` ns = `m`
                    )->a( n = `icon`    v = `sap-icon://nurse`
                    )->a( n = `tooltip` v = `nurse`

                )->open( n = `Tokenizer` ns = `m`
                    )->leaf( n = `Token` ns = `m`
                        )->a( n = `text` v = `Wayne Enterprises`
                    )->leaf( n = `Token` ns = `m`
                        )->a( n = `text` v = `Big's Caramels`

                )->shut(

                )->leaf( n = `RatingIndicator` ns = `m`
                    )->a( n = `maxValue` v = `8`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                    )->a( n = `value`    v = `4`
                    )->a( n = `tooltip`  v = `Rating Tooltip`

            )->shut(

            )->open( `sections`
                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `2014 Goals Plan`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `titleUppercase` v = `false`

                            " goals:GoalsBlock (id goalsblock) inlined
                            )->open( `blocks`
                                )->open( n = `SimpleForm` ns = `form`
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
                    )->a( n = `title`          v = `Personal`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Connect`
                            )->a( n = `titleUppercase` v = `false`

                            " personal:BlockPhoneNumber (id phone), BlockSocial (id
                            " social), BlockAdresses (id adresses) and BlockMailing
                            " (id mailing, columnLayout=1) inlined
                            )->open( `blocks`
                                )->open( n = `SimpleForm` ns = `form`
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

                                )->open( n = `SimpleForm` ns = `form`
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

                                )->open( n = `SimpleForm` ns = `form`
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

                                )->open( n = `SimpleForm` ns = `form`
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
                            )->a( n = `id`             v = `paymentSubSection`
                            )->a( n = `title`          v = `Payment information`
                            )->a( n = `titleUppercase` v = `false`

                            " personal:PersonalBlockPart1 (id part1, columnLayout=1)
                            " inlined
                            )->open( `blocks`
                                )->open( n = `SimpleForm` ns = `form`
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

                            " personal:PersonalBlockPart2 (id part2, columnLayout=1)
                            " inlined
                            )->open( `moreBlocks`
                                )->open( n = `SimpleForm` ns = `form`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->leaf( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Payment method for Expenses`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Extra Travel Expenses`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Cash 100 USD` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `TITLE_SELECTOR`.
        popover_select_display( ).
      WHEN `MARK_LOCKED`.
        popover_lock_display( ).
      WHEN `ITEM_SELECT`.
        " 1:1 with handleItemSelect - selecting an item only closes the popover
        client->follow_up_action( client->cs_event-popover_close ).
      WHEN `LINK1`.
        client->message_toast_display( `Page 1 a very long link clicked` ).
      WHEN `LINK2`.
        client->message_toast_display( `Page 2 long link clicked` ).
    ENDCASE.

  ENDMETHOD.


  METHOD popover_select_display.

    DATA(popover) = z2ui5_cl_ai_xml=>factory( ).

    " Popover.fragment.xml 1:1; anchored at the ObjectPageHeader control id
    " transported as $event.oSource.sId (the original uses the titleSelectorPress
    " event's domRef parameter - the title-arrow DOM element)
    popover->open( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( `ResponsivePopover`
            )->a( n = `title`     v = `Select Product by`
            )->a( n = `placement` v = `Bottom`

            )->open( `content`
                )->open( `List`
                    )->a( n = `mode`                   v = `SingleSelectMaster`
                    )->a( n = `includeItemInSelection` v = `true`
                    )->a( n = `selectionChange`        v = client->_event( `ITEM_SELECT` )
                    )->a( n = `items`                  v = client->_bind( productcollection )

                    )->leaf( `StandardListItem`
                        )->a( n = `title` v = `{TEXT}` ).

    client->popover_display( xml   = popover->stringify( )
                             by_id = client->get_event_arg( ) ).

  ENDMETHOD.


  METHOD popover_lock_display.

    DATA(popover) = z2ui5_cl_ai_xml=>factory( ).

    " PopoverLock.fragment.xml 1:1; anchored at the ObjectPageHeader control id
    " transported as $event.oSource.sId (the original uses the markLockedPress
    " event's domRef parameter - the lock icon's DOM element)
    popover->open( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( `ResponsivePopover`
            )->a( n = `title`     v = `Locked`
            )->a( n = `class`     v = `sapUiContentPadding`
            )->a( n = `placement` v = `Bottom`

            )->open( `content`
                )->leaf( `Label`
                    )->a( n = `text` v = `This profile is being edited by another user.` ).

    client->popover_display( xml   = popover->stringify( )
                             by_id = client->get_event_arg( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the 'buttons' JSONModel of the controller, flattened into the default model
    text = `working binding`.
    icon = `sap-icon://chain-link`.
    " the controller's .onFormat formatter returns this constant - computed in
    " the backend per the thin-frontend rule
    formatted_text = `formatted link`.

    " SharedJSONData/products.json /ProductCollection, verbatim (the Popover
    " fragment's List binds it; only the bound 'text' field per row)
    productcollection = VALUE #(
      ( text = `Product` )
      ( text = `Name` )
      ( text = `Category` )
      ( text = `Supplier` )
      ( text = `Description` )
      ( text = `Price` ) ).

  ENDMETHOD.

ENDCLASS.
