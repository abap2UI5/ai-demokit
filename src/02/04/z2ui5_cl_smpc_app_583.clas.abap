" @keywords shellbar shell bar sap.f shellbarproductswitch avatar responsivepopover productswitch productswitchitem
" @summary Shell Bar example with enabled Product Switch, configurable by the app developer. The Product Switch control is in experimental state.
CLASS z2ui5_cl_smpc_app_583 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_item,
             src       TYPE string,
             title     TYPE string,
             subtitle  TYPE string,
             targetsrc TYPE string,
             target    TYPE string,
           END OF ty_s_item.
    TYPES ty_t_item TYPE STANDARD TABLE OF ty_s_item WITH DEFAULT KEY.

    DATA t_items TYPE ty_t_item.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popover_display IMPORTING by_id TYPE string.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_583 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.f`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`

        )->ele( `ShellBar`
            )->a( n = `homeIcon`            v = `https://www.sap.com/dam/application/shared/logos/sap-logo-svg.svg.adapt.svg/1493030643828.svg`
            )->a( n = `showCopilot`         v = `true`
            )->a( n = `showProductSwitcher` v = `true`
            " fnOpen anchors the popover on the product-switcher button the event ships
            )->a( n = `productSwitcherPressed` v = client->_event( val = `OPEN_SWITCHER` arg = `${$parameters>/button}.getId()` )

            )->ele( `profile`
                )->tag( n = `Avatar` ns = `m`
                    )->a( n = `initials` v = `UI` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popover_display.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `Change event was fired from {0}. It has targetSrc: {1} and target: {2}.` INTO TABLE temp1.
    INSERT `${$parameters>/itemPressed}.getId()` INTO TABLE temp1.
    INSERT `${$parameters>/itemPressed}.getTargetSrc()` INTO TABLE temp1.
    INSERT `${$parameters>/itemPressed}.getTarget()` INTO TABLE temp1.
    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:f`    v = `sap.f`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `ResponsivePopover`
            )->a( n = `placement`  v = `Bottom`
            )->a( n = `showHeader` v = `false`

            )->ele( n = `ProductSwitch` ns = `f`
                )->a( n = `items`  v = client->_bind( t_items )
                " fnChange toasts the pressed item's id, targetSrc and target -
                " all three resolve on the client, so nothing has to travel
                )->a( n = `change` v = client->follow_up_action(
                          val   = client->cs_event-control_global
                          t_arg = temp1 )

                )->ele( n = `items` ns = `f`
                    )->tag( n = `ProductSwitchItem` ns = `f`
                        )->a( n = `src`       v = `{SRC}`
                        )->a( n = `title`     v = `{TITLE}`
                        )->a( n = `subTitle`  v = `{SUBTITLE}`
                        )->a( n = `targetSrc` v = `{TARGETSRC}`
                        )->a( n = `target`    v = `{TARGET}` ).

    client->popover_display( xml = popup->stringify( ) by_id = by_id ).

  ENDMETHOD.


  METHOD on_event.

    " fnOpen: the popover is anchored on the product-switcher button
    IF client->get_event( ) = `OPEN_SWITCHER`.
      popover_display( client->get_event_arg( ) ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " model/data.json - the fourteen product-switch entries. The fragment binds
    " subTitle, targetSrc and target too; the mock sets only src, title and a
    " subtitle on some rows, so the rest stay empty here as they are undefined there
    DATA temp3 TYPE z2ui5_cl_smpc_app_583=>ty_t_item.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp3.
    
    temp4-src = `sap-icon://home`.
    temp4-title = `Home`.
    temp4-subtitle = `Central Home`.
    INSERT temp4 INTO TABLE temp3.
    temp4-src = `sap-icon://business-objects-experience`.
    temp4-title = `Analytics Cloud`.
    temp4-subtitle = `Analytics Cloud`.
    INSERT temp4 INTO TABLE temp3.
    temp4-src = `sap-icon://contacts`.
    temp4-title = `Catalog`.
    temp4-subtitle = `Ariba`.
    INSERT temp4 INTO TABLE temp3.
    temp4-src = `sap-icon://credit-card`.
    temp4-title = `Guided Buying`.
    temp4-subtitle = ``.
    INSERT temp4 INTO TABLE temp3.
    temp4-src = `sap-icon://cart-3`.
    temp4-title = `Strategic Procurement`.
    temp4-subtitle = ``.
    INSERT temp4 INTO TABLE temp3.
    temp4-src = `sap-icon://flight`.
    temp4-title = `Travel & Expense`.
    temp4-subtitle = `Concur`.
    INSERT temp4 INTO TABLE temp3.
    temp4-src = `sap-icon://shipping-status`.
    temp4-title = `Vendor Management`.
    temp4-subtitle = `Fieldglass`.
    INSERT temp4 INTO TABLE temp3.
    temp4-src = `sap-icon://customer`.
    temp4-title = `Human Capital Management`.
    temp4-subtitle = ``.
    INSERT temp4 INTO TABLE temp3.
    temp4-src = `sap-icon://sales-notification`.
    temp4-title = `Sales Cloud`.
    temp4-subtitle = `Sales Cloud`.
    INSERT temp4 INTO TABLE temp3.
    temp4-src = `sap-icon://retail-store`.
    temp4-title = `Commerce Cloud`.
    temp4-subtitle = `Commerce cloud`.
    INSERT temp4 INTO TABLE temp3.
    temp4-src = `sap-icon://marketing-campaign`.
    temp4-title = `Marketing Cloud`.
    temp4-subtitle = `Marketing Cloud`.
    INSERT temp4 INTO TABLE temp3.
    temp4-src = `sap-icon://family-care`.
    temp4-title = `Service Cloud`.
    temp4-subtitle = ``.
    INSERT temp4 INTO TABLE temp3.
    temp4-src = `sap-icon://customer-briefing`.
    temp4-title = `Customer Data Cloud`.
    temp4-subtitle = ``.
    INSERT temp4 INTO TABLE temp3.
    temp4-src = `sap-icon://batch-payments`.
    temp4-title = `S/4HANA`.
    temp4-subtitle = ``.
    INSERT temp4 INTO TABLE temp3.
    t_items = temp3.

  ENDMETHOD.

ENDCLASS.
