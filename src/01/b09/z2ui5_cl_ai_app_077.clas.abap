CLASS z2ui5_cl_ai_app_077 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_077 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    DATA(desc_long) = `Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent feugiat, turpis vel scelerisque pharetra, tellus odio ` &&
                      `vehicula dolor, nec elementum lectus turpis at nunc. Mauris non elementum orci, ut sollicitudin ligula. Vestibulum in ` &&
                      `ligula imperdiet, posuere tortor id, dictum nunc.`.

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `class`     v = `sapUiBodyBackground sapContrastPlus sapContrast`

        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->open( `NotificationList`
                )->open( `layoutData`
                    )->leaf( `FlexItemData`
                        )->a( n = `maxWidth` v = `600px`

                )->shut(

                )->open( `NotificationListGroup`
                    )->a( n = `title`           v = `Orders`
                    )->a( n = `showCloseButton` v = `true`
                    )->a( n = `close`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Closed: {0}` ) ( `${$source>/title}` ) ) )
                    )->open( `buttons`
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Accept All`
                            )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Accept Button Pressed` ) ) )

                    )->shut(
                    )->leaf( `NotificationListItem`
                        )->a( n = `title`           v = `New order (#2525)`
                        )->a( n = `description`     v = desc_long
                        )->a( n = `showCloseButton` v = `true`
                        )->a( n = `datetime`        v = `1 hour`
                        )->a( n = `unread`          v = `true`
                        )->a( n = `priority`        v = `None`
                        )->a( n = `close`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Closed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `press`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item Pressed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `authorPicture`   v = `sap-icon://car-rental`
                        )->a( n = `authorAvatarColor` v = `Accent8`
                    )->open( `NotificationListItem`
                        )->a( n = `title`           v = `New order (#2524)`
                        )->a( n = `description`     v = `Aliquam quis varius ligula. In justo lorem, lacinia ac ex at, vulputate dictum turpis. Praesent feugiat, turpis vel scelerisque pharetra, tellus odio vehicula dolor,` &&
                                                         `nec elementum lectus turpis at nunc.`
                        )->a( n = `showCloseButton` v = `true`
                        )->a( n = `datetime`        v = `3 days`
                        )->a( n = `unread`          v = `true`
                        )->a( n = `priority`        v = `High`
                        )->a( n = `close`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Closed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `press`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item Pressed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `authorInitials`  v = `SF`
                        )->a( n = `authorAvatarColor` v = `Random`
                        )->open( `buttons`
                            )->leaf( `Button`
                                )->a( n = `text`  v = `Accept`
                                )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Accept Button Pressed` ) ) )
                            )->leaf( `Button`
                                )->a( n = `text`  v = `Reject`
                                )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Reject Button Pressed` ) ) )

                        )->shut(
                    )->shut(
                    )->open( `NotificationListItem`
                        )->a( n = `title`           v = `New order (#2523)`
                        )->a( n = `description`     v = `Aliquam quis varius ligula.`
                        )->a( n = `showCloseButton` v = `false`
                        )->a( n = `unread`          v = `false`
                        )->a( n = `datetime`        v = `3 days`
                        )->a( n = `priority`        v = `High`
                        )->a( n = `close`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Closed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `press`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item Pressed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `authorInitials`  v = `YR`
                        )->a( n = `authorAvatarColor` v = `Accent7`
                        )->open( `buttons`
                            )->leaf( `Button`
                                )->a( n = `text`  v = `Accept`
                                )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Accept Button Pressed` ) ) )
                            )->leaf( `Button`
                                )->a( n = `text`  v = `Reject`
                                )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Reject Button Pressed` ) ) )

                        )->shut(
                    )->shut(
                )->shut(

                )->open( `NotificationListGroup`
                    )->a( n = `title`           v = `Orders`
                    )->a( n = `showCloseButton` v = `true`
                    )->a( n = `collapsed`       v = `true`
                    )->a( n = `close`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Closed: {0}` ) ( `${$source>/title}` ) ) )
                    )->open( `buttons`
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Accept All`
                            )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Accept Button Pressed` ) ) )
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Reject All`
                            )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Reject Button Pressed` ) ) )

                    )->shut(
                    )->leaf( `NotificationListItem`
                        )->a( n = `title`           v = `New order (#2525)`
                        )->a( n = `description`     v = desc_long
                        )->a( n = `showCloseButton` v = `true`
                        )->a( n = `datetime`        v = `1 hour`
                        )->a( n = `unread`          v = `true`
                        )->a( n = `priority`        v = `None`
                        )->a( n = `close`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Closed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `press`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item Pressed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `authorInitials`  v = `BN`
                    )->open( `NotificationListItem`
                        )->a( n = `title`           v = `New order (#2524)`
                        )->a( n = `description`     v = `Aliquam quis varius ligula. In justo lorem, lacinia ac ex at, vulputate dictum turpis.`
                        )->a( n = `showCloseButton` v = `true`
                        )->a( n = `datetime`        v = `3 days`
                        )->a( n = `unread`          v = `true`
                        )->a( n = `priority`        v = `High`
                        )->a( n = `close`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Closed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `press`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item Pressed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `authorPicture`   v = `sap-icon://car-rental`
                        )->open( `buttons`
                            )->leaf( `Button`
                                )->a( n = `text`  v = `Accept`
                                )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Accept Button Pressed` ) ) )
                            )->leaf( `Button`
                                )->a( n = `text`  v = `Reject`
                                )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Reject Button Pressed` ) ) )

                        )->shut(
                    )->shut(
                    )->open( `NotificationListItem`
                        )->a( n = `title`           v = `New order (#2523)`
                        )->a( n = `description`     v = `Aliquam quis varius ligula.`
                        )->a( n = `showCloseButton` v = `false`
                        )->a( n = `unread`          v = `false`
                        )->a( n = `datetime`        v = `3 days`
                        )->a( n = `priority`        v = `High`
                        )->a( n = `close`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Closed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `press`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item Pressed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `authorInitials`  v = `YR`
                        )->a( n = `authorAvatarColor` v = `Accent7`
                        )->open( `buttons`
                            )->leaf( `Button`
                                )->a( n = `text`  v = `Accept`
                                )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Accept Button Pressed` ) ) )
                            )->leaf( `Button`
                                )->a( n = `text`  v = `Reject`
                                )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Reject Button Pressed` ) ) )

                        )->shut(
                    )->shut(
                )->shut(

                )->open( `NotificationListGroup`
                    )->a( n = `title`           v = `When 'Accept All' is pressed some of the notifications will show an error`
                    )->a( n = `showCloseButton` v = `true`
                    )->a( n = `close`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Closed: {0}` ) ( `${$source>/title}` ) ) )
                    )->open( `buttons`
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Accept All`
                            )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Accept Button Pressed` ) ) )
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Reject All`
                            )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Reject Button Pressed` ) ) )

                    )->shut(
                    )->leaf( `NotificationListItem`
                        )->a( n = `title`           v = `New order (#2525)`
                        )->a( n = `description`     v = desc_long
                        )->a( n = `showCloseButton` v = `true`
                        )->a( n = `datetime`        v = `1 hour`
                        )->a( n = `unread`          v = `true`
                        )->a( n = `priority`        v = `None`
                        )->a( n = `close`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Closed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `press`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item Pressed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `authorPicture`   v = `sap-icon://car-rental`
                        )->a( n = `authorAvatarColor` v = `Accent8`
                    )->open( `NotificationListItem`
                        )->a( n = `title`           v = `New order (#2524)`
                        )->a( n = `description`     v = `Aliquam quis varius ligula. In justo lorem, lacinia ac ex at, vulputate dictum turpis.`
                        )->a( n = `showCloseButton` v = `true`
                        )->a( n = `datetime`        v = `3 days`
                        )->a( n = `unread`          v = `true`
                        )->a( n = `priority`        v = `High`
                        )->a( n = `close`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Closed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `press`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item Pressed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `authorPicture`   v = `sap-icon://car-rental`
                        )->a( n = `authorAvatarColor` v = `Accent8`
                        )->open( `buttons`
                            )->leaf( `Button`
                                )->a( n = `text`  v = `Accept`
                                )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Accept Button Pressed` ) ) )

                        )->shut(
                    )->shut(
                    )->open( `NotificationListItem`
                        )->a( n = `title`           v = `New order (#2523)`
                        )->a( n = `description`     v = `Aliquam quis varius ligula.`
                        )->a( n = `showCloseButton` v = `false`
                        )->a( n = `unread`          v = `false`
                        )->a( n = `datetime`        v = `3 days`
                        )->a( n = `priority`        v = `High`
                        )->a( n = `close`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Closed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `press`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item Pressed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `authorInitials`  v = `BN`
                        )->open( `buttons`
                            )->leaf( `Button`
                                )->a( n = `text`  v = `Accept`
                                )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Accept Button Pressed` ) ) )
                            )->leaf( `Button`
                                )->a( n = `text`  v = `Reject`
                                )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Reject Button Pressed` ) ) )

                        )->shut(
                    )->shut(
                )->shut(

                )->open( `NotificationListGroup`
                    )->a( n = `title`           v = `Group with notifications without footer buttons`
                    )->a( n = `showCloseButton` v = `true`
                    )->a( n = `close`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Closed: {0}` ) ( `${$source>/title}` ) ) )
                    )->leaf( `NotificationListItem`
                        )->a( n = `title`           v = `New order (#2525)`
                        )->a( n = `description`     v = desc_long
                        )->a( n = `showCloseButton` v = `true`
                        )->a( n = `datetime`        v = `1 hour`
                        )->a( n = `unread`          v = `true`
                        )->a( n = `priority`        v = `None`
                        )->a( n = `close`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Closed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `press`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item Pressed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `authorPicture`   v = `sap-icon://car-rental`
                        )->a( n = `authorAvatarColor` v = `Accent8`
                    )->open( `NotificationListItem`
                        )->a( n = `title`           v = `New order (#2524)`
                        )->a( n = `description`     v = `Aliquam quis varius ligula. In justo lorem, lacinia ac ex at, vulputate dictum turpis.`
                        )->a( n = `showCloseButton` v = `true`
                        )->a( n = `datetime`        v = `3 days`
                        )->a( n = `unread`          v = `true`
                        )->a( n = `priority`        v = `High`
                        )->a( n = `close`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Closed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `press`           v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item Pressed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `authorInitials`  v = `BN`
                        )->open( `buttons`
                            )->leaf( `Button`
                                )->a( n = `text`  v = `Accept`
                                )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Accept Button Pressed` ) ) )
                            )->leaf( `Button`
                                )->a( n = `text`  v = `Reject`
                                )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Reject Button Pressed` ) ) )

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
