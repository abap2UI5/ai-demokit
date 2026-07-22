CLASS z2ui5_cl_ai_app_076 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_076 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `class`     v = `sapUiBodyBackground sapContrastPlus`

        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->open( `NotificationList`
                )->open( `layoutData`
                    )->leaf( `FlexItemData`
                        )->a( n = `maxWidth` v = `600px`

                )->shut(

                )->open( `NotificationListItem`
                    )->a( n = `title`           v = `New order (#2525) With a very long title - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent feugiat, turpis vel scelerisque pharetra, tellus odio` &&
                                                     `vehicula dolor, nec elementum lectus turpis at nunc.`
                    )->a( n = `description`     v = `And with a very long description and long labels of the action buttons - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent feugiat, turpis vel` &&
                                                     `scelerisque pharetra, tellus odio vehicula dolor, nec elementum lectus` &&
                                                     `turpis at nunc.`
                    )->a( n = `showCloseButton` v = `true`
                    )->a( n = `datetime`        v = `1 hour`
                    )->a( n = `unread`          v = `true`
                    )->a( n = `priority`        v = `None`
                    )->a( n = `close`           v = client->_event( val = `CLOSE` t_arg = VALUE #( ( `${$source>/title}` ) ) )
                    )->a( n = `press`           v = client->_event( val = `PRESS` t_arg = VALUE #( ( `${$source>/title}` ) ) )
                    )->a( n = `authorName`      v = `Jean Doe`
                    )->a( n = `authorPicture`   v = `test-resources/sap/m/images/Woman_04.png`
                    )->open( `buttons`
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Accept All Requested Information`
                            )->a( n = `press` v = client->_event( `ACCEPT` )
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Reject All Requested Information`
                            )->a( n = `press` v = client->_event( `REJECT` )

                    )->shut(
                )->shut(

                )->leaf( `NotificationListItem`
                    )->a( n = `title`           v = `New order (#2524), without action buttons`
                    )->a( n = `description`     v = `Short description`
                    )->a( n = `showCloseButton` v = `true`
                    )->a( n = `datetime`        v = `3 days`
                    )->a( n = `unread`          v = `true`
                    )->a( n = `priority`        v = `High`
                    )->a( n = `close`           v = client->_event( val = `CLOSE` t_arg = VALUE #( ( `${$source>/title}` ) ) )
                    )->a( n = `press`           v = client->_event( val = `PRESS` t_arg = VALUE #( ( `${$source>/title}` ) ) )
                    )->a( n = `authorName`      v = `Office Notification`
                    )->a( n = `authorPicture`   v = `sap-icon://group`

                )->open( `NotificationListItem`
                    )->a( n = `title`             v = `New order (#2523) With a long title - Lorem ipsum dolor sit amet, consectetur adipiscing elit.`
                    )->a( n = `description`       v = `And short description`
                    )->a( n = `showCloseButton`   v = `false`
                    )->a( n = `unread`            v = `false`
                    )->a( n = `datetime`          v = `3 days`
                    )->a( n = `priority`          v = `High`
                    )->a( n = `close`             v = client->_event( val = `CLOSE` t_arg = VALUE #( ( `${$source>/title}` ) ) )
                    )->a( n = `press`             v = client->_event( val = `PRESS` t_arg = VALUE #( ( `${$source>/title}` ) ) )
                    )->a( n = `authorName`        v = `Patricia Clark`
                    )->a( n = `authorInitials`    v = `PC`
                    )->a( n = `authorAvatarColor` v = `Accent8`
                    )->open( `buttons`
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Accept`
                            )->a( n = `press` v = client->_event( `ACCEPT` )
                            )->a( n = `icon`  v = `sap-icon://accept`
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Reject`
                            )->a( n = `press` v = client->_event( `REJECT` )
                            )->a( n = `icon`  v = `sap-icon://sys-cancel`

                    )->shut(
                )->shut(

                )->leaf( `NotificationListItem`
                    )->a( n = `title`             v = `New order (#2522)`
                    )->a( n = `description`       v = `With a very long description - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent feugiat, turpis vel scelerisque pharetra, tellus odio vehicula` &&
                                                       `dolor, nec elementum lectus turpis at nunc.`
                    )->a( n = `showCloseButton`   v = `true`
                    )->a( n = `datetime`          v = `3 days`
                    )->a( n = `unread`            v = `true`
                    )->a( n = `priority`          v = `Medium`
                    )->a( n = `close`             v = client->_event( val = `CLOSE` t_arg = VALUE #( ( `${$source>/title}` ) ) )
                    )->a( n = `press`             v = client->_event( val = `PRESS` t_arg = VALUE #( ( `${$source>/title}` ) ) )
                    )->a( n = `authorName`        v = `John Smith`
                    )->a( n = `authorInitials`    v = `JS`
                    )->a( n = `authorAvatarColor` v = `Accent4`

                )->leaf( `NotificationListItem`
                    )->a( n = `title`           v = `New order (#2521)`
                    )->a( n = `description`     v = `With a very long description and no action buttons below - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent feugiat, turpis vel scelerisque` &&
                                                     `pharetra, tellus odio vehicula dolor, nec elementum lectus turpis at` &&
                                                     `nunc.`
                    )->a( n = `showCloseButton` v = `true`
                    )->a( n = `datetime`        v = `3 days`
                    )->a( n = `unread`          v = `true`
                    )->a( n = `priority`        v = `Low`
                    )->a( n = `close`           v = client->_event( val = `CLOSE` t_arg = VALUE #( ( `${$source>/title}` ) ) )
                    )->a( n = `press`           v = client->_event( val = `PRESS` t_arg = VALUE #( ( `${$source>/title}` ) ) )
                    )->a( n = `authorName`      v = `John Smith`
                    )->a( n = `authorPicture`   v = `test-resources/sap/m/images/headerImg2.jpg`

                )->open( `NotificationListItem`
                    )->a( n = `title`           v = `New order (#2525) With a very long title and truncation disabled by default! Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent feugiat, turpis vel` &&
                                                     `scelerisque pharetra, tellus odio vehicula dolor, nec elementum` &&
                                                     `lectus turpis at nunc.`
                    )->a( n = `description`     v = `And a very long description and long labels of the action buttons - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent feugiat, turpis vel scelerisque` &&
                                                     `pharetra, tellus odio vehicula dolor, nec elementum lectus` &&
                                                     `turpis at nunc.`
                    )->a( n = `showCloseButton` v = `true`
                    )->a( n = `datetime`        v = `2 day`
                    )->a( n = `unread`          v = `false`
                    )->a( n = `priority`        v = `Low`
                    )->a( n = `close`           v = client->_event( val = `CLOSE` t_arg = VALUE #( ( `${$source>/title}` ) ) )
                    )->a( n = `press`           v = client->_event( val = `PRESS` t_arg = VALUE #( ( `${$source>/title}` ) ) )
                    )->a( n = `authorName`      v = `Jean Doe`
                    )->a( n = `authorPicture`   v = `test-resources/sap/m/images/Woman_04.png`
                    )->a( n = `truncate`        v = `false`
                    )->open( `buttons`
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Accept`
                            )->a( n = `press` v = client->_event( `ACCEPT` )

                    )->shut(
                )->shut(

                )->open( `NotificationListItem`
                    )->a( n = `title`              v = `New order (#2525) With a very long title and with truncation enabled but 'Show More' hidden! Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent` &&
                                                        `feugiat, turpis vel scelerisque pharetra, tellus odio vehicula dolor,` &&
                                                        `nec elementum lectus turpis at nunc.`
                    )->a( n = `description`        v = `And a very long description and long labels of the action buttons - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent feugiat, turpis vel scelerisque` &&
                                                        `pharetra, tellus odio vehicula dolor, nec elementum lectus` &&
                                                        `turpis at nunc.`
                    )->a( n = `showCloseButton`    v = `true`
                    )->a( n = `datetime`           v = `2 day`
                    )->a( n = `unread`             v = `false`
                    )->a( n = `priority`           v = `Low`
                    )->a( n = `close`              v = client->_event( val = `CLOSE` t_arg = VALUE #( ( `${$source>/title}` ) ) )
                    )->a( n = `press`              v = client->_event( val = `PRESS` t_arg = VALUE #( ( `${$source>/title}` ) ) )
                    )->a( n = `authorName`         v = `Jean Doe`
                    )->a( n = `authorPicture`      v = `test-resources/sap/m/images/Woman_04.png`
                    )->a( n = `hideShowMoreButton` v = `true`
                    )->a( n = `showButtons`        v = `false`
                    )->open( `buttons`
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Accept`
                            )->a( n = `press` v = client->_event( `ACCEPT` )
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Reject`
                            )->a( n = `press` v = client->_event( `REJECT` )

                    )->shut(
                )->shut(

                )->open( `NotificationListItem`
                    )->a( n = `title`           v = `New order (#2523) With a long title without description - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet`
                    )->a( n = `showCloseButton` v = `false`
                    )->a( n = `unread`          v = `false`
                    )->a( n = `datetime`        v = `3 days`
                    )->a( n = `priority`        v = `High`
                    )->a( n = `close`           v = client->_event( val = `CLOSE` t_arg = VALUE #( ( `${$source>/title}` ) ) )
                    )->a( n = `press`           v = client->_event( val = `PRESS` t_arg = VALUE #( ( `${$source>/title}` ) ) )
                    )->a( n = `authorName`      v = `Patricia Clark`
                    )->a( n = `authorPicture`   v = `test-resources/sap/m/images/female_BaySu.jpg`
                    )->open( `buttons`
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Accept`
                            )->a( n = `press` v = client->_event( `ACCEPT` )
                            )->a( n = `icon`  v = `sap-icon://accept`
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Reject`
                            )->a( n = `press` v = client->_event( `REJECT` )
                            )->a( n = `icon`  v = `sap-icon://sys-cancel`
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Get Error`
                            )->a( n = `press` v = client->_event( `ERROR` )
                            )->a( n = `icon`  v = `sap-icon://sys-cancel`

                    )->shut(
                )->shut(

                )->leaf( `NotificationListItem`
                    )->a( n = `title`           v = `New order (#2523) With a long title without description`
                    )->a( n = `showCloseButton` v = `true`
                    )->a( n = `unread`          v = `false`
                    )->a( n = `datetime`        v = `3 days`
                    )->a( n = `priority`        v = `High`
                    )->a( n = `close`           v = client->_event( val = `CLOSE` t_arg = VALUE #( ( `${$source>/title}` ) ) )
                    )->a( n = `press`           v = client->_event( val = `PRESS` t_arg = VALUE #( ( `${$source>/title}` ) ) )

            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `PRESS`.
        client->message_toast_display( |Item Pressed: { client->get_event_arg( ) }| ).
      WHEN `CLOSE`.
        " the original's onItemClose also removes the item from the list (client-side removeItem) - not mirrored server-side for the static list
        client->message_toast_display( |Item Closed: { client->get_event_arg( ) }| ).
      WHEN `ACCEPT`.
        client->message_toast_display( `Accept Button Pressed` ).
      WHEN `REJECT`.
        client->message_toast_display( `Reject Button Pressed` ).
      WHEN `ERROR`.
        " the original's onErrorPress attaches a processingMessage MessageStrip to the item - shown here as a toast
        client->message_toast_display( `Error: Something went wrong.` ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
