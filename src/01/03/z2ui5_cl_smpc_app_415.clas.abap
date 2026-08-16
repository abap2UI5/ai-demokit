" @keywords objectpageheader object header sap.uxap objectpageheaderwithallcontrols objectpagelayout objectpageheaderactionbutton objectpageheaderlayoutdata objectpagesection objectpagesubsection responsivepopover list
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
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " Block->content inlining (app 217/188/161 precedent, CAPABILITIES 'Custom
    " BlockBase blocks in a sap.uxap.ObjectPageLayout'): the original blocks
    " and moreBlocks aggregations hold custom BlockBase controls from the
    " sample's SharedBlocks JS - a BlockBase is only a lazy-loading wrapper
    " around a view, so each block's content (a sap.ui.layout.form.SimpleForm)
    " is inlined directly here.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
        )->a( n = `height`       v = `100%`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->ele( `headerTitle`
                " the two press events transport the pressed control's id via
                " $event.oSource.sId as the popover anchor (the original anchors
                " at oEvent.getParameter('domRef') - see the sidecar note);
                " objectImageURI absolutized from ./test-resources/... to the
                " sdk.openui5.org host (asset-URL rule)
                )->ele( `ObjectPageHeader`
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

                    )->ele( `actions`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`       v = `sap-icon://action`
                            )->a( n = `text`       v = `action`
                            )->a( n = `importance` v = `Low`
                            )->a( n = `tooltip`    v = `action`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`       v = `sap-icon://action-settings`
                            )->a( n = `text`       v = `settings`
                            )->a( n = `importance` v = `Low`
                            )->a( n = `tooltip`    v = `action-settings`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`       v = `sap-icon://edit`
                            )->a( n = `text`       v = `edit`
                            )->a( n = `importance` v = `Medium`
                            )->a( n = `tooltip`    v = `edit`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = `sap-icon://save`
                            )->a( n = `text`    v = `save`
                            )->a( n = `visible` v = `false`
                            )->a( n = `tooltip` v = `save`
                        " the 'buttons' named model (text/icon) is flattened into
                        " the default model; the original's .onFormat formatter
                        " returns the constant 'formatted link', computed in
                        " model_init per the thin-frontend rule
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = `sap-icon://refresh`
                            )->a( n = `text`    v = client->_bind( text )
                            )->a( n = `tooltip` v = `refresh`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = client->_bind( icon )
                            )->a( n = `text`    v = client->_bind( formatted_text )
                            )->a( n = `tooltip` v = `chain-link`

                    )->end(

                    )->ele( `breadcrumbs`
                        )->ele( n = `Breadcrumbs` ns = `m`
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text`  v = `Page 1 a very long link`
                                )->a( n = `press` v = client->_event( `LINK1` )
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text`  v = `Page 2 long link`
                                )->a( n = `press` v = client->_event( `LINK2` )

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `headerContent`
                )->ele( n = `VerticalLayout` ns = `layout`
                    )->tag( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `User ID`
                        )->a( n = `text`  v = `12345678`
                    )->tag( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `Functional Area`
                        )->a( n = `text`  v = `Developement`
                    )->tag( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `Cost Center`
                        )->a( n = `text`  v = `PI DFA GD Programs and Product`
                    )->tag( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `Email`
                        )->a( n = `text`  v = `email@address.com`

                )->end(

                )->tag( n = `Text` ns = `m`
                    )->a( n = `width` v = `200px`
                    )->a( n = `text`  v = `Hi, I'm Denise. I am passionate about what I do and I'll go the extra mile to make the customer win.`

                )->tag( n = `ObjectStatus` ns = `m`
                    )->a( n = `text`  v = `In Stock`
                    )->a( n = `state` v = `Error`

                )->tag( n = `ObjectStatus` ns = `m`
                    )->a( n = `title` v = `Label`
                    )->a( n = `text`  v = `In Stock`
                    )->a( n = `state` v = `Warning`

                )->tag( n = `ObjectNumber` ns = `m`
                    )->a( n = `number`     v = `1000`
                    )->a( n = `unit`       v = `SOOK`
                    )->a( n = `emphasized` v = `false`
                    )->a( n = `state`      v = `Success`

                )->tag( n = `ProgressIndicator` ns = `m`
                    )->a( n = `percentValue` v = `30`
                    )->a( n = `displayValue` v = `30%`
                    )->a( n = `showValue`    v = `true`
                    )->a( n = `state`        v = `None`

                )->ele( n = `VerticalLayout` ns = `layout`
                    )->tag( n = `Label` ns = `m`
                        )->a( n = `text` v = `PC, Unrestricted-Use Stock`
                    )->tag( n = `ObjectNumber` ns = `m`
                        )->a( n = `class`  v = `sapMObjectNumberLarge`
                        )->a( n = `number` v = `219`
                        )->a( n = `unit`   v = `K`

                )->end(

                )->ele( n = `VerticalLayout` ns = `layout`
                    )->ele( n = `layoutData` ns = `layout`
                        )->tag( `ObjectPageHeaderLayoutData`
                            )->a( n = `visibleS` v = `false`

                    )->end(
                    )->tag( n = `Label` ns = `m`
                        )->a( n = `text` v = `PC, Not in Small Size`
                    )->tag( n = `ObjectNumber` ns = `m`
                        )->a( n = `class`  v = `sapMObjectNumberLarge`
                        )->a( n = `number` v = `220`
                        )->a( n = `unit`   v = `K`

                )->end(

                )->ele( n = `VerticalLayout` ns = `layout`
                    )->ele( n = `layoutData` ns = `layout`
                        )->tag( `ObjectPageHeaderLayoutData`
                            )->a( n = `visibleM` v = `false`

                    )->end(
                    )->tag( n = `Label` ns = `m`
                        )->a( n = `text` v = `PC, Not in Medium Size`
                    )->tag( n = `ObjectNumber` ns = `m`
                        )->a( n = `class`  v = `sapMObjectNumberLarge`
                        )->a( n = `number` v = `221`
                        )->a( n = `unit`   v = `K`

                )->end(

                )->ele( n = `VerticalLayout` ns = `layout`
                    )->ele( n = `layoutData` ns = `layout`
                        )->tag( `ObjectPageHeaderLayoutData`
                            )->a( n = `visibleL` v = `false`

                    )->end(
                    )->tag( n = `Label` ns = `m`
                        )->a( n = `text` v = `PC, Not in Large Size`
                    )->tag( n = `ObjectNumber` ns = `m`
                        )->a( n = `class`  v = `sapMObjectNumberLarge`
                        )->a( n = `number` v = `219`
                        )->a( n = `unit`   v = `K`

                )->end(

                )->tag( n = `ObjectAttribute` ns = `m`
                    )->a( n = `title` v = `Label`
                    )->a( n = `text`  v = `In Stock`

                )->tag( n = `Button` ns = `m`
                    )->a( n = `icon`    v = `sap-icon://nurse`
                    )->a( n = `tooltip` v = `nurse`

                )->ele( n = `Tokenizer` ns = `m`
                    )->tag( n = `Token` ns = `m`
                        )->a( n = `text` v = `Wayne Enterprises`
                    )->tag( n = `Token` ns = `m`
                        )->a( n = `text` v = `Big's Caramels`

                )->end(

                )->tag( n = `RatingIndicator` ns = `m`
                    )->a( n = `maxValue` v = `8`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                    )->a( n = `value`    v = `4`
                    )->a( n = `tooltip`  v = `Rating Tooltip`

            )->end(

            )->ele( `sections`
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `2014 Goals Plan`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `titleUppercase` v = `false`

                            " goals:GoalsBlock (id goalsblock) inlined
                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `form`
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

                            " personal:BlockPhoneNumber (id phone), BlockSocial (id
                            " social), BlockAdresses (id adresses) and BlockMailing
                            " (id mailing, columnLayout=1) inlined
                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `form`
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

                                )->ele( n = `SimpleForm` ns = `form`
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

                                )->ele( n = `SimpleForm` ns = `form`
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

                                )->ele( n = `SimpleForm` ns = `form`
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
                            )->a( n = `titleUppercase` v = `false`

                            " personal:PersonalBlockPart1 (id part1, columnLayout=1)
                            " inlined
                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `form`
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

                            " personal:PersonalBlockPart2 (id part2, columnLayout=1)
                            " inlined
                            )->ele( `moreBlocks`
                                )->ele( n = `SimpleForm` ns = `form`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Payment method for Expenses`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Extra Travel Expenses`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Cash 100 USD` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).
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

    DATA(popover) = z2ui5_cl_ui5_view_builder=>factory( ).

    " Popover.fragment.xml 1:1; anchored at the ObjectPageHeader control id
    " transported as $event.oSource.sId (the original uses the titleSelectorPress
    " event's domRef parameter - the title-arrow DOM element)
    popover->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `ResponsivePopover`
            )->a( n = `title`     v = `Select Product by`
            )->a( n = `placement` v = `Bottom`

            )->ele( `content`
                )->ele( `List`
                    )->a( n = `mode`                   v = `SingleSelectMaster`
                    )->a( n = `includeItemInSelection` v = `true`
                    )->a( n = `selectionChange`        v = client->_event( `ITEM_SELECT` )
                    )->a( n = `items`                  v = client->_bind( productcollection )

                    )->tag( `StandardListItem`
                        )->a( n = `title` v = `{TEXT}` ).

    client->popover_display( xml   = popover->stringify( )
                             by_id = client->get_event_arg( ) ).

  ENDMETHOD.


  METHOD popover_lock_display.

    DATA(popover) = z2ui5_cl_ui5_view_builder=>factory( ).

    " PopoverLock.fragment.xml 1:1; anchored at the ObjectPageHeader control id
    " transported as $event.oSource.sId (the original uses the markLockedPress
    " event's domRef parameter - the lock icon's DOM element)
    popover->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `ResponsivePopover`
            )->a( n = `title`     v = `Locked`
            )->a( n = `class`     v = `sapUiContentPadding`
            )->a( n = `placement` v = `Bottom`

            )->ele( `content`
                )->tag( `Label`
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
