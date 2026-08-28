" @keywords notificationlistgroup notification list group sap.m notificationlistgrouplazyloading vbox notificationlist flexitemdata button notificationlistitem
" @summary Notification List Group with lazy loading of the notifications.
CLASS z2ui5_cl_smpc_app_520 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_notification,
             group    TYPE i,
             id       TYPE i,
             title    TYPE string,
             datetime TYPE string,
             priority TYPE string,
           END OF ty_s_notification.
    TYPES ty_t_notification TYPE STANDARD TABLE OF ty_s_notification WITH EMPTY KEY.

    DATA t_group1 TYPE ty_t_notification.
    DATA t_group2 TYPE ty_t_notification.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS group_fill IMPORTING group TYPE i.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_520 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    DATA(list) = view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `class`     v = `sapUiBodyBackground sapContrastPlus`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `NotificationList`
                )->a( n = `class` v = `sapContrast sapContrastPlus` ).

    list->ele( `layoutData`
        )->tag( `FlexItemData`
            )->a( n = `maxWidth` v = `600px` ).

    " the two groups are identical in the original and differ only in the table
    " their lazily loaded items land in
    DO 2 TIMES.
      DATA(group) = sy-index.
      DATA(items) = COND #( WHEN group = 1 THEN client->_bind( t_group1 ) ELSE client->_bind( t_group2 ) ).

      list->ele( `NotificationListGroup`
          )->a( n = `title`                         v = `3 messages. They will be lazy loaded when 'Expand' button is pressed.`
          )->a( n = `showCloseButton`               v = `true`
          )->a( n = `showItemsCounter`              v = `false`
          )->a( n = `collapsed`                     v = `true`
          " onToggleCollapse fills the group the first time it is expanded
          " The collapsed flag travels as a STRING TOKEN, not as the raw boolean:
          " a JSON boolean t_arg is normalised to X/space by ajson on a real
          " system, but reaches the transpiled backend verbatim as 'true'/'false'
          " - and 'false' is not INITIAL, so the group was never filled there
          " (e2e-caught 2026-08-22, the app 421 idiom).
          )->a( n = `onCollapse`                    v = client->_event( val   = `TOGGLE_COLLAPSE`
                                                                        t_arg = VALUE #( ( |{ group }| ) ( `${$parameters>/collapsed} ? 'collapsed' : 'expanded'` ) ) )
          )->a( n = `close`                         v = client->_event( val   = `GROUP_CLOSE`
                                                                        t_arg = VALUE #( ( |{ group }| ) ) )
          )->a( n = `showEmptyGroup`                v = `true`
          )->a( n = `enableCollapseButtonWhenEmpty` v = `true`
          )->a( n = `items`                         v = items

          )->ele( `buttons`
              )->tag( `Button`
                  )->a( n = `text`  v = `Accept All`
                  )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                  t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Accept Button Pressed` ) ) )
              )->tag( `Button`
                  )->a( n = `text`  v = `Reject All`
                  )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                  t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Reject Button Pressed` ) ) )
              )->tag( `Button`
                  )->a( n = `text`  v = `Get items count`
                  )->a( n = `press` v = client->_event( val   = `ITEMS_COUNT`
                                                        t_arg = VALUE #( ( |{ group }| ) ) )

          )->end(

          )->tag( `NotificationListItem`
              )->a( n = `title`           v = `{TITLE}`
              " _addItemsToGroup creates each item with unread: true; ListItemBase
              " defaults it to false, so without this every notification renders read
              )->a( n = `unread`          v = `true`
              )->a( n = `showCloseButton` v = `true`
              )->a( n = `datetime`        v = `{DATETIME}`
              )->a( n = `priority`        v = `{PRIORITY}`
              )->a( n = `close`           v = client->_event( val   = `ITEM_CLOSE`
                                                              t_arg = VALUE #( ( |{ group }| ) ( `${ID}` ) ) )

      )->end( ).
    ENDDO.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    DATA(group) = CONV i( client->get_event_arg( ) ).

    CASE client->get_event( ).

      WHEN `TOGGLE_COLLAPSE`.
        " the group is filled the first time it is EXPANDED
        IF client->get_event_arg( 2 ) = `expanded`.
          group_fill( group ).
        ENDIF.

      WHEN `ITEMS_COUNT`.
        DATA(count) = COND i( WHEN group = 1 THEN lines( t_group1 ) ELSE lines( t_group2 ) ).
        client->message_toast_display( |Number of items in group: { count }| ).

      WHEN `ITEM_CLOSE`.
        DATA(del_id) = CONV i( client->get_event_arg( 2 ) ).
        IF group = 1.
          DELETE t_group1 WHERE id = del_id.
        ELSE.
          DELETE t_group2 WHERE id = del_id.
        ENDIF.
        client->message_toast_display( `Item Closed` ).

      WHEN `GROUP_CLOSE`.
        IF group = 1.
          CLEAR t_group1.
        ELSE.
          CLEAR t_group2.
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD group_fill.

    " _addItemsToGroup adds three notifications with RANDOM title, time and
    " priority; a backend cannot repeat a client-side random draw, so the port
    " walks the same three lists in order
    DATA(titles) = VALUE string_table( ( `New order request` )
                                       ( `Your vacation has been approved` )
                                       ( `New transaction in queue` )
                                       ( `A new request awaits your action` ) ).
    DATA(times) = VALUE string_table( ( `3 days` ) ( `5 minutes` ) ( `1 hour` ) ).
    DATA(priorities) = VALUE string_table( ( `None` ) ( `Low` ) ( `Medium` ) ( `High` ) ).

    IF group = 1 AND t_group1 IS NOT INITIAL.
      RETURN.
    ENDIF.
    IF group = 2 AND t_group2 IS NOT INITIAL.
      RETURN.
    ENDIF.

    DO 3 TIMES.
      DATA(index) = sy-index.
      DATA(item) = VALUE ty_s_notification( group    = group
                                            id       = index
                                            title    = titles[ index MOD 4 + 1 ]
                                            datetime = times[ index MOD 3 + 1 ]
                                            priority = priorities[ index MOD 4 + 1 ] ).
      IF group = 1.
        APPEND item TO t_group1.
      ELSE.
        APPEND item TO t_group2.
      ENDIF.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
