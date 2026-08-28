" @keywords notificationlistitem notification list item sap.m variants buttons avatars vbox notificationlist flexitemdata button
" @summary A list item suitable for showing notifications to the user.
CLASS z2ui5_cl_smpc_app_076 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_076 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `class`     v = `sapUiBodyBackground sapContrastPlus`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->ele( `NotificationList`
                " id added: oList.removeItem( oItem ) needs a target for the wire
                )->a( n = `id` v = `notificationList`
                )->ele( `layoutData`
                    )->tag( `FlexItemData`
                        )->a( n = `maxWidth` v = `600px`

                )->end(

                )->ele( `NotificationListItem`
                    )->a( n = `title`           v = `New order (#2525) With a very long title - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent feugiat, turpis vel scelerisque pharetra, tellus odio ` &&
                                                     `vehicula dolor, nec elementum lectus turpis at nunc.`
                    )->a( n = `description`     v = `And with a very long description and long labels of the action buttons - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent feugiat, turpis vel ` &&
                                                     `scelerisque pharetra, tellus odio vehicula dolor, nec elementum lectus ` &&
                                                     `turpis at nunc.`
                    )->a( n = `showCloseButton` v = `true`
                    )->a( n = `datetime`        v = `1 hour`
                    )->a( n = `unread`          v = `true`
                    )->a( n = `priority`        v = `None`
                    " onItemClose 1:1: remove the item from its list, then toast its title -
                    " two client actions on one event, chained with ';' (measured)
                    )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                              t_arg = VALUE #( ( `notificationList` )
                                                                                               ( `removeItem` )
                                                                                               ( `$event.oSource.getId()` ) ) ) && `; ` &&
                                                    client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                                                               ( `show` )
                                                                                               ( `Item Closed: {0}` )
                                                                                               ( `${$source>/title}` ) ) )
                    )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item Pressed: {0}` ) ( `${$source>/title}` ) ) )
                    )->a( n = `authorName`      v = `Jean Doe`
                    )->a( n = `authorPicture`   v = `https://sdk.openui5.org/test-resources/sap/m/images/Woman_04.png`
                    )->ele( `buttons`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Accept All Requested Information`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Accept Button Pressed` ) ) )
                        )->tag( `Button`
                            )->a( n = `text`  v = `Reject All Requested Information`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Reject Button Pressed` ) ) )

                    )->end(
                )->end(

                )->tag( `NotificationListItem`
                    )->a( n = `title`           v = `New order (#2524), without action buttons`
                    )->a( n = `description`     v = `Short description`
                    )->a( n = `showCloseButton` v = `true`
                    )->a( n = `datetime`        v = `3 days`
                    )->a( n = `unread`          v = `true`
                    )->a( n = `priority`        v = `High`
                    )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                              t_arg = VALUE #( ( `notificationList` )
                                                                                               ( `removeItem` )
                                                                                               ( `$event.oSource.getId()` ) ) ) && `; ` &&
                                                    client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                                                               ( `show` )
                                                                                               ( `Item Closed: {0}` )
                                                                                               ( `${$source>/title}` ) ) )
                    )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item Pressed: {0}` ) ( `${$source>/title}` ) ) )
                    )->a( n = `authorName`      v = `Office Notification`
                    )->a( n = `authorPicture`   v = `sap-icon://group`

                )->ele( `NotificationListItem`
                    )->a( n = `title`             v = `New order (#2523) With a long title - Lorem ipsum dolor sit amet, consectetur adipiscing elit.`
                    )->a( n = `description`       v = `And short description`
                    )->a( n = `showCloseButton`   v = `false`
                    )->a( n = `unread`            v = `false`
                    )->a( n = `datetime`          v = `3 days`
                    )->a( n = `priority`          v = `High`
                    )->a( n = `close`             v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                                t_arg = VALUE #( ( `notificationList` )
                                                                                                 ( `removeItem` )
                                                                                                 ( `$event.oSource.getId()` ) ) ) && `; ` &&
                                                      client->follow_up_action( val   = client->cs_event-control_global
                                                                                t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                                                                 ( `show` )
                                                                                                 ( `Item Closed: {0}` )
                                                                                                 ( `${$source>/title}` ) ) )
                    )->a( n = `press`             v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item Pressed: {0}` ) ( `${$source>/title}` ) ) )
                    )->a( n = `authorName`        v = `Patricia Clark`
                    )->a( n = `authorInitials`    v = `PC`
                    )->a( n = `authorAvatarColor` v = `Accent8`
                    )->ele( `buttons`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Accept`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Accept Button Pressed` ) ) )
                            )->a( n = `icon`  v = `sap-icon://accept`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Reject`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Reject Button Pressed` ) ) )
                            )->a( n = `icon`  v = `sap-icon://sys-cancel`

                    )->end(
                )->end(

                )->tag( `NotificationListItem`
                    )->a( n = `title`             v = `New order (#2522)`
                    )->a( n = `description`       v = `With a very long description - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent feugiat, turpis vel scelerisque pharetra, tellus odio vehicula ` &&
                                                       `dolor, nec elementum lectus turpis at nunc.`
                    )->a( n = `showCloseButton`   v = `true`
                    )->a( n = `datetime`          v = `3 days`
                    )->a( n = `unread`            v = `true`
                    )->a( n = `priority`          v = `Medium`
                    )->a( n = `close`             v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                                t_arg = VALUE #( ( `notificationList` )
                                                                                                 ( `removeItem` )
                                                                                                 ( `$event.oSource.getId()` ) ) ) && `; ` &&
                                                      client->follow_up_action( val   = client->cs_event-control_global
                                                                                t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                                                                 ( `show` )
                                                                                                 ( `Item Closed: {0}` )
                                                                                                 ( `${$source>/title}` ) ) )
                    )->a( n = `press`             v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item Pressed: {0}` ) ( `${$source>/title}` ) ) )
                    )->a( n = `authorName`        v = `John Smith`
                    )->a( n = `authorInitials`    v = `JS`
                    )->a( n = `authorAvatarColor` v = `Accent4`

                )->tag( `NotificationListItem`
                    )->a( n = `title`           v = `New order (#2521)`
                    )->a( n = `description`     v = `With a very long description and no action buttons below - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent feugiat, turpis vel scelerisque ` &&
                                                     `pharetra, tellus odio vehicula dolor, nec elementum lectus turpis at ` &&
                                                     `nunc.`
                    )->a( n = `showCloseButton` v = `true`
                    )->a( n = `datetime`        v = `3 days`
                    )->a( n = `unread`          v = `true`
                    )->a( n = `priority`        v = `Low`
                    )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                              t_arg = VALUE #( ( `notificationList` )
                                                                                               ( `removeItem` )
                                                                                               ( `$event.oSource.getId()` ) ) ) && `; ` &&
                                                    client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                                                               ( `show` )
                                                                                               ( `Item Closed: {0}` )
                                                                                               ( `${$source>/title}` ) ) )
                    )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item Pressed: {0}` ) ( `${$source>/title}` ) ) )
                    )->a( n = `authorName`      v = `John Smith`
                    )->a( n = `authorPicture`   v = `https://sdk.openui5.org/test-resources/sap/m/images/headerImg2.jpg`

                )->ele( `NotificationListItem`
                    )->a( n = `title`           v = `New order (#2525) With a very long title and truncation disabled by default! Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent feugiat, turpis vel ` &&
                                                     `scelerisque pharetra, tellus odio vehicula dolor, nec elementum ` &&
                                                     `lectus turpis at nunc.`
                    )->a( n = `description`     v = `And a very long description and long labels of the action buttons - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent feugiat, turpis vel scelerisque ` &&
                                                     `pharetra, tellus odio vehicula dolor, nec elementum lectus ` &&
                                                     `turpis at nunc.`
                    )->a( n = `showCloseButton` v = `true`
                    )->a( n = `datetime`        v = `2 day`
                    )->a( n = `unread`          v = `false`
                    )->a( n = `priority`        v = `Low`
                    )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                              t_arg = VALUE #( ( `notificationList` )
                                                                                               ( `removeItem` )
                                                                                               ( `$event.oSource.getId()` ) ) ) && `; ` &&
                                                    client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                                                               ( `show` )
                                                                                               ( `Item Closed: {0}` )
                                                                                               ( `${$source>/title}` ) ) )
                    )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item Pressed: {0}` ) ( `${$source>/title}` ) ) )
                    )->a( n = `authorName`      v = `Jean Doe`
                    )->a( n = `authorPicture`   v = `https://sdk.openui5.org/test-resources/sap/m/images/Woman_04.png`
                    )->a( n = `truncate`        v = `false`
                    )->ele( `buttons`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Accept`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Accept Button Pressed` ) ) )

                    )->end(
                )->end(

                )->ele( `NotificationListItem`
                    )->a( n = `title`              v = `New order (#2525) With a very long title and with truncation enabled but 'Show More' hidden! Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent ` &&
                                                        `feugiat, turpis vel scelerisque pharetra, tellus odio vehicula dolor, ` &&
                                                        `nec elementum lectus turpis at nunc.`
                    )->a( n = `description`        v = `And a very long description and long labels of the action buttons - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent feugiat, turpis vel scelerisque ` &&
                                                        `pharetra, tellus odio vehicula dolor, nec elementum lectus ` &&
                                                        `turpis at nunc.`
                    )->a( n = `showCloseButton`    v = `true`
                    )->a( n = `datetime`           v = `2 day`
                    )->a( n = `unread`             v = `false`
                    )->a( n = `priority`           v = `Low`
                    )->a( n = `close`              v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                                 t_arg = VALUE #( ( `notificationList` )
                                                                                                  ( `removeItem` )
                                                                                                  ( `$event.oSource.getId()` ) ) ) && `; ` &&
                                                       client->follow_up_action( val   = client->cs_event-control_global
                                                                                 t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                                                                  ( `show` )
                                                                                                  ( `Item Closed: {0}` )
                                                                                                  ( `${$source>/title}` ) ) )
                    )->a( n = `press`              v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item Pressed: {0}` ) ( `${$source>/title}` ) ) )
                    )->a( n = `authorName`         v = `Jean Doe`
                    )->a( n = `authorPicture`      v = `https://sdk.openui5.org/test-resources/sap/m/images/Woman_04.png`
                    )->a( n = `hideShowMoreButton` v = `true`
                    )->a( n = `showButtons`        v = `false`
                    )->ele( `buttons`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Accept`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Accept Button Pressed` ) ) )
                        )->tag( `Button`
                            )->a( n = `text`  v = `Reject`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Reject Button Pressed` ) ) )

                    )->end(
                )->end(

                )->ele( `NotificationListItem`
                    )->a( n = `title`           v = `New order (#2523) With a long title without description - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet`
                    )->a( n = `showCloseButton` v = `false`
                    )->a( n = `unread`          v = `false`
                    )->a( n = `datetime`        v = `3 days`
                    )->a( n = `priority`        v = `High`
                    )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                              t_arg = VALUE #( ( `notificationList` )
                                                                                               ( `removeItem` )
                                                                                               ( `$event.oSource.getId()` ) ) ) && `; ` &&
                                                    client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                                                               ( `show` )
                                                                                               ( `Item Closed: {0}` )
                                                                                               ( `${$source>/title}` ) ) )
                    )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item Pressed: {0}` ) ( `${$source>/title}` ) ) )
                    )->a( n = `authorName`      v = `Patricia Clark`
                    )->a( n = `authorPicture`   v = `https://sdk.openui5.org/test-resources/sap/m/images/female_BaySu.jpg`
                    )->ele( `buttons`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Accept`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Accept Button Pressed` ) ) )
                            )->a( n = `icon`  v = `sap-icon://accept`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Reject`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Reject Button Pressed` ) ) )
                            )->a( n = `icon`  v = `sap-icon://sys-cancel`
                        " the original's onErrorPress sets a MessageStrip processingMessage on the item - shown as a toast here
                        )->tag( `Button`
                            )->a( n = `text`  v = `Get Error`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Error: Something went wrong.` ) ) )
                            )->a( n = `icon`  v = `sap-icon://sys-cancel`

                    )->end(
                )->end(

                )->tag( `NotificationListItem`
                    )->a( n = `title`           v = `New order (#2523) With a long title without description`
                    )->a( n = `showCloseButton` v = `true`
                    )->a( n = `unread`          v = `false`
                    )->a( n = `datetime`        v = `3 days`
                    )->a( n = `priority`        v = `High`
                    )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                              t_arg = VALUE #( ( `notificationList` )
                                                                                               ( `removeItem` )
                                                                                               ( `$event.oSource.getId()` ) ) ) && `; ` &&
                                                    client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                                                               ( `show` )
                                                                                               ( `Item Closed: {0}` )
                                                                                               ( `${$source>/title}` ) ) )
                    )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item Pressed: {0}` ) ( `${$source>/title}` ) ) )

            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
