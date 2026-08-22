" @keywords notificationlistgroup notification list group sap.m maxnumberofnotificationsreached vbox flexitemdata button notificationlistitem
" @summary Notification List Group with max number of notifications reached. The group will render the max amount of notificatons, depending on device type allowed and then show a warning messge.
CLASS z2ui5_cl_smpc_app_444 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_notification,
             id       TYPE i,
             title    TYPE string,
             datetime TYPE string,
             priority TYPE string,
             unread   TYPE abap_bool,
           END OF ty_s_notification.
    TYPES ty_t_notification TYPE STANDARD TABLE OF ty_s_notification WITH EMPTY KEY.

    DATA t_notifications TYPE ty_t_notification.
    DATA group_visible   TYPE abap_bool VALUE abap_true.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS notifications_load.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_444 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
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
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `class`     v = `sapContrastPlus sapContrast`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `List`

                )->ele( `layoutData`
                    )->tag( `FlexItemData`
                        )->a( n = `maxWidth` v = `600px`

                )->end(

                " onItemClose removes the group from the List and toasts its title -
                " the group is bound visible instead, the row set stays untouched
                )->ele( `NotificationListGroup`
                    )->a( n = `title`                         v = `Notification Group`
                    )->a( n = `showCloseButton`               v = `true`
                    )->a( n = `collapsed`                     v = `false`
                    )->a( n = `close`                         v = client->_event( `GROUP_CLOSE` )
                    )->a( n = `showEmptyGroup`                v = `true`
                    )->a( n = `enableCollapseButtonWhenEmpty` v = `true`
                    " NOT `b = <field>`: that parameter writes the LITERAL 'true' or
                    " 'false' into the attribute at render time (view_builder->a),
                    " so a field the event handler changes never reaches the
                    " control - none of these apps re-renders after an event
                    " (e2e-caught on app 505, 2026-08-22)
                    )->a( n = `visible`                       v = client->_bind( group_visible )
                    )->a( n = `items`                         v = client->_bind( t_notifications )

                    )->ele( `buttons`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Load notifications`
                            )->a( n = `press` v = client->_event( `LOAD_NOTIFICATIONS` )

                    )->end(

                    " the items the controller creates in _createNotification; each one
                    " destroys itself on close, which here deletes its row
                    )->tag( `NotificationListItem`
                        )->a( n = `title`           v = `{TITLE}`
                        )->a( n = `showCloseButton` v = `true`
                        )->a( n = `datetime`        v = `{DATETIME}`
                        )->a( n = `unread`          v = `{UNREAD}`
                        )->a( n = `priority`        v = `{PRIORITY}`
                        )->a( n = `close`           v = client->_event( val   = `ITEM_CLOSE`
                                                                        t_arg = VALUE #( ( `${ID}` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `LOAD_NOTIFICATIONS`.
        notifications_load( ).

      WHEN `ITEM_CLOSE`.
        DATA(closed_id) = CONV i( client->get_event_arg( ) ).
        DELETE t_notifications WHERE id = closed_id.

      WHEN `GROUP_CLOSE`.
        group_visible = abap_false.
        client->message_toast_display( `Item Closed: Notification Group` ).
        view_display( ).

    ENDCASE.

  ENDMETHOD.


  METHOD notifications_load.

    " onLoadNotificationsPress fills the group once, with the maximum number of
    " notifications the device takes (400 on desktop, 100 otherwise). The titles,
    " times and priorities are picked at RANDOM there; a backend cannot repeat a
    " client-side Math.random, so the port walks the same three lists in order -
    " same four titles, three times and four priorities, deterministically
    IF t_notifications IS NOT INITIAL.
      RETURN.
    ENDIF.

    DATA(titles) = VALUE string_table( ( `New order request` )
                                       ( `Your vacation has been approved` )
                                       ( `New transaction in queue` )
                                       ( `An new request await your action` ) ).
    DATA(times) = VALUE string_table( ( `3 days` ) ( `5 minutes` ) ( `1 hour` ) ).
    DATA(priorities) = VALUE string_table( ( `None` ) ( `Low` ) ( `Medium` ) ( `High` ) ).

    DO 400 TIMES.
      DATA(index) = sy-index.
      INSERT VALUE #( id       = index
                      title    = |{ titles[ index MOD 4 + 1 ] } { index }|
                      datetime = times[ index MOD 3 + 1 ]
                      priority = priorities[ index MOD 4 + 1 ]
                      unread   = abap_true )
             INTO TABLE t_notifications.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
