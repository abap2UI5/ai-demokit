" @keywords shellbar sap.f shellbarproductswitch productswitch productswitchitem responsivepopover avatar
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
    TYPES ty_t_item TYPE STANDARD TABLE OF ty_s_item WITH EMPTY KEY.

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
            )->a( n = `productSwitcherPressed` v = client->_event( val   = `OPEN_SWITCHER`
                                                                   t_arg = VALUE #( ( `${$parameters>/button}.getId()` ) ) )

            )->ele( `profile`
                )->tag( n = `Avatar` ns = `m`
                    )->a( n = `initials` v = `UI` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popover_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

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
                          t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                           ( `show` )
                                           ( `Change event was fired from {0}. It has targetSrc: {1} and target: {2}.` )
                                           ( `${$parameters>/itemPressed}.getId()` )
                                           ( `${$parameters>/itemPressed}.getTargetSrc()` )
                                           ( `${$parameters>/itemPressed}.getTarget()` ) ) )

                )->ele( n = `items` ns = `f`
                    )->tag( n = `ProductSwitchItem` ns = `f`
                        )->a( n = `src`       v = `{SRC}`
                        )->a( n = `title`     v = `{TITLE}`
                        )->a( n = `subTitle`  v = `{SUBTITLE}`
                        )->a( n = `targetSrc` v = `{TARGETSRC}`
                        )->a( n = `target`    v = `{TARGET}` ).

    client->popover_display( xml   = popup->stringify( )
                             by_id = by_id ).

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
    t_items = VALUE #(
      ( src = `sap-icon://home` title = `Home` subtitle = `Central Home` )
      ( src = `sap-icon://business-objects-experience` title = `Analytics Cloud` subtitle = `Analytics Cloud` )
      ( src = `sap-icon://contacts` title = `Catalog` subtitle = `Ariba` )
      ( src = `sap-icon://credit-card` title = `Guided Buying` subtitle = `` )
      ( src = `sap-icon://cart-3` title = `Strategic Procurement` subtitle = `` )
      ( src = `sap-icon://flight` title = `Travel & Expense` subtitle = `Concur` )
      ( src = `sap-icon://shipping-status` title = `Vendor Management` subtitle = `Fieldglass` )
      ( src = `sap-icon://customer` title = `Human Capital Management` subtitle = `` )
      ( src = `sap-icon://sales-notification` title = `Sales Cloud` subtitle = `Sales Cloud` )
      ( src = `sap-icon://retail-store` title = `Commerce Cloud` subtitle = `Commerce cloud` )
      ( src = `sap-icon://marketing-campaign` title = `Marketing Cloud` subtitle = `Marketing Cloud` )
      ( src = `sap-icon://family-care` title = `Service Cloud` subtitle = `` )
      ( src = `sap-icon://customer-briefing` title = `Customer Data Cloud` subtitle = `` )
      ( src = `sap-icon://batch-payments` title = `S/4HANA` subtitle = `` ) ).

  ENDMETHOD.

ENDCLASS.
