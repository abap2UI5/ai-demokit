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
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    DATA temp5 TYPE string_table.
    DATA temp6 TYPE string_table.
    DATA temp7 TYPE string_table.
    DATA temp8 TYPE string_table.
    DATA temp9 TYPE string_table.
    DATA temp10 TYPE string_table.
    DATA temp11 TYPE string_table.
    DATA temp12 TYPE string_table.
    DATA temp13 TYPE string_table.
    DATA temp14 TYPE string_table.
    DATA temp15 TYPE string_table.
    DATA temp16 TYPE string_table.
    DATA temp17 TYPE string_table.
    DATA temp18 TYPE string_table.
    DATA temp19 TYPE string_table.
    DATA temp20 TYPE string_table.
    DATA temp21 TYPE string_table.
    DATA temp22 TYPE string_table.
    DATA temp23 TYPE string_table.
    DATA temp24 TYPE string_table.
    DATA temp25 TYPE string_table.
    DATA temp26 TYPE string_table.
    DATA temp27 TYPE string_table.
    DATA temp28 TYPE string_table.
    DATA temp29 TYPE string_table.
    DATA temp30 TYPE string_table.
    DATA temp31 TYPE string_table.
    DATA temp32 TYPE string_table.
    DATA temp33 TYPE string_table.
    DATA temp34 TYPE string_table.
    DATA temp35 TYPE string_table.
    DATA temp36 TYPE string_table.
    DATA temp37 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `notificationList` INTO TABLE temp1.
    INSERT `removeItem` INTO TABLE temp1.
    INSERT `$event.oSource.getId()` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `Item Closed: {0}` INTO TABLE temp2.
    INSERT `${$source>/title}` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `Item Pressed: {0}` INTO TABLE temp3.
    INSERT `${$source>/title}` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `MESSAGE_TOAST` INTO TABLE temp4.
    INSERT `show` INTO TABLE temp4.
    INSERT `Accept Button Pressed` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `MESSAGE_TOAST` INTO TABLE temp5.
    INSERT `show` INTO TABLE temp5.
    INSERT `Reject Button Pressed` INTO TABLE temp5.
    
    CLEAR temp6.
    INSERT `notificationList` INTO TABLE temp6.
    INSERT `removeItem` INTO TABLE temp6.
    INSERT `$event.oSource.getId()` INTO TABLE temp6.
    
    CLEAR temp7.
    INSERT `MESSAGE_TOAST` INTO TABLE temp7.
    INSERT `show` INTO TABLE temp7.
    INSERT `Item Closed: {0}` INTO TABLE temp7.
    INSERT `${$source>/title}` INTO TABLE temp7.
    
    CLEAR temp8.
    INSERT `MESSAGE_TOAST` INTO TABLE temp8.
    INSERT `show` INTO TABLE temp8.
    INSERT `Item Pressed: {0}` INTO TABLE temp8.
    INSERT `${$source>/title}` INTO TABLE temp8.
    
    CLEAR temp9.
    INSERT `notificationList` INTO TABLE temp9.
    INSERT `removeItem` INTO TABLE temp9.
    INSERT `$event.oSource.getId()` INTO TABLE temp9.
    
    CLEAR temp10.
    INSERT `MESSAGE_TOAST` INTO TABLE temp10.
    INSERT `show` INTO TABLE temp10.
    INSERT `Item Closed: {0}` INTO TABLE temp10.
    INSERT `${$source>/title}` INTO TABLE temp10.
    
    CLEAR temp11.
    INSERT `MESSAGE_TOAST` INTO TABLE temp11.
    INSERT `show` INTO TABLE temp11.
    INSERT `Item Pressed: {0}` INTO TABLE temp11.
    INSERT `${$source>/title}` INTO TABLE temp11.
    
    CLEAR temp12.
    INSERT `MESSAGE_TOAST` INTO TABLE temp12.
    INSERT `show` INTO TABLE temp12.
    INSERT `Accept Button Pressed` INTO TABLE temp12.
    
    CLEAR temp13.
    INSERT `MESSAGE_TOAST` INTO TABLE temp13.
    INSERT `show` INTO TABLE temp13.
    INSERT `Reject Button Pressed` INTO TABLE temp13.
    
    CLEAR temp14.
    INSERT `notificationList` INTO TABLE temp14.
    INSERT `removeItem` INTO TABLE temp14.
    INSERT `$event.oSource.getId()` INTO TABLE temp14.
    
    CLEAR temp15.
    INSERT `MESSAGE_TOAST` INTO TABLE temp15.
    INSERT `show` INTO TABLE temp15.
    INSERT `Item Closed: {0}` INTO TABLE temp15.
    INSERT `${$source>/title}` INTO TABLE temp15.
    
    CLEAR temp16.
    INSERT `MESSAGE_TOAST` INTO TABLE temp16.
    INSERT `show` INTO TABLE temp16.
    INSERT `Item Pressed: {0}` INTO TABLE temp16.
    INSERT `${$source>/title}` INTO TABLE temp16.
    
    CLEAR temp17.
    INSERT `notificationList` INTO TABLE temp17.
    INSERT `removeItem` INTO TABLE temp17.
    INSERT `$event.oSource.getId()` INTO TABLE temp17.
    
    CLEAR temp18.
    INSERT `MESSAGE_TOAST` INTO TABLE temp18.
    INSERT `show` INTO TABLE temp18.
    INSERT `Item Closed: {0}` INTO TABLE temp18.
    INSERT `${$source>/title}` INTO TABLE temp18.
    
    CLEAR temp19.
    INSERT `MESSAGE_TOAST` INTO TABLE temp19.
    INSERT `show` INTO TABLE temp19.
    INSERT `Item Pressed: {0}` INTO TABLE temp19.
    INSERT `${$source>/title}` INTO TABLE temp19.
    
    CLEAR temp20.
    INSERT `notificationList` INTO TABLE temp20.
    INSERT `removeItem` INTO TABLE temp20.
    INSERT `$event.oSource.getId()` INTO TABLE temp20.
    
    CLEAR temp21.
    INSERT `MESSAGE_TOAST` INTO TABLE temp21.
    INSERT `show` INTO TABLE temp21.
    INSERT `Item Closed: {0}` INTO TABLE temp21.
    INSERT `${$source>/title}` INTO TABLE temp21.
    
    CLEAR temp22.
    INSERT `MESSAGE_TOAST` INTO TABLE temp22.
    INSERT `show` INTO TABLE temp22.
    INSERT `Item Pressed: {0}` INTO TABLE temp22.
    INSERT `${$source>/title}` INTO TABLE temp22.
    
    CLEAR temp23.
    INSERT `MESSAGE_TOAST` INTO TABLE temp23.
    INSERT `show` INTO TABLE temp23.
    INSERT `Accept Button Pressed` INTO TABLE temp23.
    
    CLEAR temp24.
    INSERT `notificationList` INTO TABLE temp24.
    INSERT `removeItem` INTO TABLE temp24.
    INSERT `$event.oSource.getId()` INTO TABLE temp24.
    
    CLEAR temp25.
    INSERT `MESSAGE_TOAST` INTO TABLE temp25.
    INSERT `show` INTO TABLE temp25.
    INSERT `Item Closed: {0}` INTO TABLE temp25.
    INSERT `${$source>/title}` INTO TABLE temp25.
    
    CLEAR temp26.
    INSERT `MESSAGE_TOAST` INTO TABLE temp26.
    INSERT `show` INTO TABLE temp26.
    INSERT `Item Pressed: {0}` INTO TABLE temp26.
    INSERT `${$source>/title}` INTO TABLE temp26.
    
    CLEAR temp27.
    INSERT `MESSAGE_TOAST` INTO TABLE temp27.
    INSERT `show` INTO TABLE temp27.
    INSERT `Accept Button Pressed` INTO TABLE temp27.
    
    CLEAR temp28.
    INSERT `MESSAGE_TOAST` INTO TABLE temp28.
    INSERT `show` INTO TABLE temp28.
    INSERT `Reject Button Pressed` INTO TABLE temp28.
    
    CLEAR temp29.
    INSERT `notificationList` INTO TABLE temp29.
    INSERT `removeItem` INTO TABLE temp29.
    INSERT `$event.oSource.getId()` INTO TABLE temp29.
    
    CLEAR temp30.
    INSERT `MESSAGE_TOAST` INTO TABLE temp30.
    INSERT `show` INTO TABLE temp30.
    INSERT `Item Closed: {0}` INTO TABLE temp30.
    INSERT `${$source>/title}` INTO TABLE temp30.
    
    CLEAR temp31.
    INSERT `MESSAGE_TOAST` INTO TABLE temp31.
    INSERT `show` INTO TABLE temp31.
    INSERT `Item Pressed: {0}` INTO TABLE temp31.
    INSERT `${$source>/title}` INTO TABLE temp31.
    
    CLEAR temp32.
    INSERT `MESSAGE_TOAST` INTO TABLE temp32.
    INSERT `show` INTO TABLE temp32.
    INSERT `Accept Button Pressed` INTO TABLE temp32.
    
    CLEAR temp33.
    INSERT `MESSAGE_TOAST` INTO TABLE temp33.
    INSERT `show` INTO TABLE temp33.
    INSERT `Reject Button Pressed` INTO TABLE temp33.
    
    CLEAR temp34.
    INSERT `MESSAGE_TOAST` INTO TABLE temp34.
    INSERT `show` INTO TABLE temp34.
    INSERT `Error: Something went wrong.` INTO TABLE temp34.
    
    CLEAR temp35.
    INSERT `notificationList` INTO TABLE temp35.
    INSERT `removeItem` INTO TABLE temp35.
    INSERT `$event.oSource.getId()` INTO TABLE temp35.
    
    CLEAR temp36.
    INSERT `MESSAGE_TOAST` INTO TABLE temp36.
    INSERT `show` INTO TABLE temp36.
    INSERT `Item Closed: {0}` INTO TABLE temp36.
    INSERT `${$source>/title}` INTO TABLE temp36.
    
    CLEAR temp37.
    INSERT `MESSAGE_TOAST` INTO TABLE temp37.
    INSERT `show` INTO TABLE temp37.
    INSERT `Item Pressed: {0}` INTO TABLE temp37.
    INSERT `${$source>/title}` INTO TABLE temp37.
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
                                                                              t_arg = temp1 ) && `; ` &&
                                                    client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = temp2 )
                    )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp3 )
                    )->a( n = `authorName`      v = `Jean Doe`
                    )->a( n = `authorPicture`   v = `https://sdk.openui5.org/test-resources/sap/m/images/Woman_04.png`
                    )->ele( `buttons`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Accept All Requested Information`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp4 )
                        )->tag( `Button`
                            )->a( n = `text`  v = `Reject All Requested Information`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp5 )

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
                                                                              t_arg = temp6 ) && `; ` &&
                                                    client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = temp7 )
                    )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp8 )
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
                                                                                t_arg = temp9 ) && `; ` &&
                                                      client->follow_up_action( val   = client->cs_event-control_global
                                                                                t_arg = temp10 )
                    )->a( n = `press`             v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp11 )
                    )->a( n = `authorName`        v = `Patricia Clark`
                    )->a( n = `authorInitials`    v = `PC`
                    )->a( n = `authorAvatarColor` v = `Accent8`
                    )->ele( `buttons`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Accept`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp12 )
                            )->a( n = `icon`  v = `sap-icon://accept`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Reject`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp13 )
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
                                                                                t_arg = temp14 ) && `; ` &&
                                                      client->follow_up_action( val   = client->cs_event-control_global
                                                                                t_arg = temp15 )
                    )->a( n = `press`             v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp16 )
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
                                                                              t_arg = temp17 ) && `; ` &&
                                                    client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = temp18 )
                    )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp19 )
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
                                                                              t_arg = temp20 ) && `; ` &&
                                                    client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = temp21 )
                    )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp22 )
                    )->a( n = `authorName`      v = `Jean Doe`
                    )->a( n = `authorPicture`   v = `https://sdk.openui5.org/test-resources/sap/m/images/Woman_04.png`
                    )->a( n = `truncate`        v = `false`
                    )->ele( `buttons`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Accept`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp23 )

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
                                                                                 t_arg = temp24 ) && `; ` &&
                                                       client->follow_up_action( val   = client->cs_event-control_global
                                                                                 t_arg = temp25 )
                    )->a( n = `press`              v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp26 )
                    )->a( n = `authorName`         v = `Jean Doe`
                    )->a( n = `authorPicture`      v = `https://sdk.openui5.org/test-resources/sap/m/images/Woman_04.png`
                    )->a( n = `hideShowMoreButton` v = `true`
                    )->a( n = `showButtons`        v = `false`
                    )->ele( `buttons`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Accept`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp27 )
                        )->tag( `Button`
                            )->a( n = `text`  v = `Reject`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp28 )

                    )->end(
                )->end(

                )->ele( `NotificationListItem`
                    )->a( n = `title`           v = `New order (#2523) With a long title without description - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet`
                    )->a( n = `showCloseButton` v = `false`
                    )->a( n = `unread`          v = `false`
                    )->a( n = `datetime`        v = `3 days`
                    )->a( n = `priority`        v = `High`
                    )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                              t_arg = temp29 ) && `; ` &&
                                                    client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = temp30 )
                    )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp31 )
                    )->a( n = `authorName`      v = `Patricia Clark`
                    )->a( n = `authorPicture`   v = `https://sdk.openui5.org/test-resources/sap/m/images/female_BaySu.jpg`
                    )->ele( `buttons`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Accept`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp32 )
                            )->a( n = `icon`  v = `sap-icon://accept`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Reject`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp33 )
                            )->a( n = `icon`  v = `sap-icon://sys-cancel`
                        " the original's onErrorPress sets a MessageStrip processingMessage on the item - shown as a toast here
                        )->tag( `Button`
                            )->a( n = `text`  v = `Get Error`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp34 )
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
                                                                              t_arg = temp35 ) && `; ` &&
                                                    client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = temp36 )
                    )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp37 )

            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
