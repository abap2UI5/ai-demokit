" @keywords notificationlistgroup notification list group sap.m grouped notifications vbox notificationlist flexitemdata button notificationlistitem
" @summary A control suitable for grouping notifications.
CLASS z2ui5_cl_smpc_app_077 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_077 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA desc_long TYPE string.
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
    DATA temp38 TYPE string_table.
    DATA temp39 TYPE string_table.
    DATA temp40 TYPE string_table.
    DATA temp41 TYPE string_table.
    DATA temp42 TYPE string_table.
    DATA temp43 TYPE string_table.
    DATA temp44 TYPE string_table.
    DATA temp45 TYPE string_table.
    DATA temp46 TYPE string_table.
    DATA temp47 TYPE string_table.
    DATA temp48 TYPE string_table.
    DATA temp49 TYPE string_table.
    DATA temp50 TYPE string_table.
    DATA temp51 TYPE string_table.
    DATA temp52 TYPE string_table.
    DATA temp53 TYPE string_table.
    DATA temp54 TYPE string_table.
    DATA temp55 TYPE string_table.
    DATA temp56 TYPE string_table.
    DATA temp57 TYPE string_table.
    DATA temp58 TYPE string_table.
    DATA temp59 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    desc_long = `Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent feugiat, turpis vel scelerisque pharetra, tellus odio ` &&
                      `vehicula dolor, nec elementum lectus turpis at nunc. Mauris non elementum orci, ut sollicitudin ligula. Vestibulum in ` &&
                      `ligula imperdiet, posuere tortor id, dictum nunc.`.

    
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
    INSERT `Accept Button Pressed` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `notificationGroup1` INTO TABLE temp4.
    INSERT `removeItem` INTO TABLE temp4.
    INSERT `$event.oSource.getId()` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `MESSAGE_TOAST` INTO TABLE temp5.
    INSERT `show` INTO TABLE temp5.
    INSERT `Item Closed: {0}` INTO TABLE temp5.
    INSERT `${$source>/title}` INTO TABLE temp5.
    
    CLEAR temp6.
    INSERT `MESSAGE_TOAST` INTO TABLE temp6.
    INSERT `show` INTO TABLE temp6.
    INSERT `Item Pressed: {0}` INTO TABLE temp6.
    INSERT `${$source>/title}` INTO TABLE temp6.
    
    CLEAR temp7.
    INSERT `notificationGroup1` INTO TABLE temp7.
    INSERT `removeItem` INTO TABLE temp7.
    INSERT `$event.oSource.getId()` INTO TABLE temp7.
    
    CLEAR temp8.
    INSERT `MESSAGE_TOAST` INTO TABLE temp8.
    INSERT `show` INTO TABLE temp8.
    INSERT `Item Closed: {0}` INTO TABLE temp8.
    INSERT `${$source>/title}` INTO TABLE temp8.
    
    CLEAR temp9.
    INSERT `MESSAGE_TOAST` INTO TABLE temp9.
    INSERT `show` INTO TABLE temp9.
    INSERT `Item Pressed: {0}` INTO TABLE temp9.
    INSERT `${$source>/title}` INTO TABLE temp9.
    
    CLEAR temp10.
    INSERT `MESSAGE_TOAST` INTO TABLE temp10.
    INSERT `show` INTO TABLE temp10.
    INSERT `Accept Button Pressed` INTO TABLE temp10.
    
    CLEAR temp11.
    INSERT `MESSAGE_TOAST` INTO TABLE temp11.
    INSERT `show` INTO TABLE temp11.
    INSERT `Reject Button Pressed` INTO TABLE temp11.
    
    CLEAR temp12.
    INSERT `notificationGroup1` INTO TABLE temp12.
    INSERT `removeItem` INTO TABLE temp12.
    INSERT `$event.oSource.getId()` INTO TABLE temp12.
    
    CLEAR temp13.
    INSERT `MESSAGE_TOAST` INTO TABLE temp13.
    INSERT `show` INTO TABLE temp13.
    INSERT `Item Closed: {0}` INTO TABLE temp13.
    INSERT `${$source>/title}` INTO TABLE temp13.
    
    CLEAR temp14.
    INSERT `MESSAGE_TOAST` INTO TABLE temp14.
    INSERT `show` INTO TABLE temp14.
    INSERT `Item Pressed: {0}` INTO TABLE temp14.
    INSERT `${$source>/title}` INTO TABLE temp14.
    
    CLEAR temp15.
    INSERT `MESSAGE_TOAST` INTO TABLE temp15.
    INSERT `show` INTO TABLE temp15.
    INSERT `Accept Button Pressed` INTO TABLE temp15.
    
    CLEAR temp16.
    INSERT `MESSAGE_TOAST` INTO TABLE temp16.
    INSERT `show` INTO TABLE temp16.
    INSERT `Reject Button Pressed` INTO TABLE temp16.
    
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
    INSERT `Accept Button Pressed` INTO TABLE temp19.
    
    CLEAR temp20.
    INSERT `MESSAGE_TOAST` INTO TABLE temp20.
    INSERT `show` INTO TABLE temp20.
    INSERT `Reject Button Pressed` INTO TABLE temp20.
    
    CLEAR temp21.
    INSERT `notificationGroup2` INTO TABLE temp21.
    INSERT `removeItem` INTO TABLE temp21.
    INSERT `$event.oSource.getId()` INTO TABLE temp21.
    
    CLEAR temp22.
    INSERT `MESSAGE_TOAST` INTO TABLE temp22.
    INSERT `show` INTO TABLE temp22.
    INSERT `Item Closed: {0}` INTO TABLE temp22.
    INSERT `${$source>/title}` INTO TABLE temp22.
    
    CLEAR temp23.
    INSERT `MESSAGE_TOAST` INTO TABLE temp23.
    INSERT `show` INTO TABLE temp23.
    INSERT `Item Pressed: {0}` INTO TABLE temp23.
    INSERT `${$source>/title}` INTO TABLE temp23.
    
    CLEAR temp24.
    INSERT `notificationGroup2` INTO TABLE temp24.
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
    INSERT `notificationGroup2` INTO TABLE temp29.
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
    INSERT `notificationList` INTO TABLE temp34.
    INSERT `removeItem` INTO TABLE temp34.
    INSERT `$event.oSource.getId()` INTO TABLE temp34.
    
    CLEAR temp35.
    INSERT `MESSAGE_TOAST` INTO TABLE temp35.
    INSERT `show` INTO TABLE temp35.
    INSERT `Item Closed: {0}` INTO TABLE temp35.
    INSERT `${$source>/title}` INTO TABLE temp35.
    
    CLEAR temp36.
    INSERT `MESSAGE_TOAST` INTO TABLE temp36.
    INSERT `show` INTO TABLE temp36.
    INSERT `Accept Button Pressed` INTO TABLE temp36.
    
    CLEAR temp37.
    INSERT `MESSAGE_TOAST` INTO TABLE temp37.
    INSERT `show` INTO TABLE temp37.
    INSERT `Reject Button Pressed` INTO TABLE temp37.
    
    CLEAR temp38.
    INSERT `notificationGroup3` INTO TABLE temp38.
    INSERT `removeItem` INTO TABLE temp38.
    INSERT `$event.oSource.getId()` INTO TABLE temp38.
    
    CLEAR temp39.
    INSERT `MESSAGE_TOAST` INTO TABLE temp39.
    INSERT `show` INTO TABLE temp39.
    INSERT `Item Closed: {0}` INTO TABLE temp39.
    INSERT `${$source>/title}` INTO TABLE temp39.
    
    CLEAR temp40.
    INSERT `MESSAGE_TOAST` INTO TABLE temp40.
    INSERT `show` INTO TABLE temp40.
    INSERT `Item Pressed: {0}` INTO TABLE temp40.
    INSERT `${$source>/title}` INTO TABLE temp40.
    
    CLEAR temp41.
    INSERT `notificationGroup3` INTO TABLE temp41.
    INSERT `removeItem` INTO TABLE temp41.
    INSERT `$event.oSource.getId()` INTO TABLE temp41.
    
    CLEAR temp42.
    INSERT `MESSAGE_TOAST` INTO TABLE temp42.
    INSERT `show` INTO TABLE temp42.
    INSERT `Item Closed: {0}` INTO TABLE temp42.
    INSERT `${$source>/title}` INTO TABLE temp42.
    
    CLEAR temp43.
    INSERT `MESSAGE_TOAST` INTO TABLE temp43.
    INSERT `show` INTO TABLE temp43.
    INSERT `Item Pressed: {0}` INTO TABLE temp43.
    INSERT `${$source>/title}` INTO TABLE temp43.
    
    CLEAR temp44.
    INSERT `MESSAGE_TOAST` INTO TABLE temp44.
    INSERT `show` INTO TABLE temp44.
    INSERT `Accept Button Pressed` INTO TABLE temp44.
    
    CLEAR temp45.
    INSERT `notificationGroup3` INTO TABLE temp45.
    INSERT `removeItem` INTO TABLE temp45.
    INSERT `$event.oSource.getId()` INTO TABLE temp45.
    
    CLEAR temp46.
    INSERT `MESSAGE_TOAST` INTO TABLE temp46.
    INSERT `show` INTO TABLE temp46.
    INSERT `Item Closed: {0}` INTO TABLE temp46.
    INSERT `${$source>/title}` INTO TABLE temp46.
    
    CLEAR temp47.
    INSERT `MESSAGE_TOAST` INTO TABLE temp47.
    INSERT `show` INTO TABLE temp47.
    INSERT `Item Pressed: {0}` INTO TABLE temp47.
    INSERT `${$source>/title}` INTO TABLE temp47.
    
    CLEAR temp48.
    INSERT `MESSAGE_TOAST` INTO TABLE temp48.
    INSERT `show` INTO TABLE temp48.
    INSERT `Accept Button Pressed` INTO TABLE temp48.
    
    CLEAR temp49.
    INSERT `MESSAGE_TOAST` INTO TABLE temp49.
    INSERT `show` INTO TABLE temp49.
    INSERT `Reject Button Pressed` INTO TABLE temp49.
    
    CLEAR temp50.
    INSERT `notificationList` INTO TABLE temp50.
    INSERT `removeItem` INTO TABLE temp50.
    INSERT `$event.oSource.getId()` INTO TABLE temp50.
    
    CLEAR temp51.
    INSERT `MESSAGE_TOAST` INTO TABLE temp51.
    INSERT `show` INTO TABLE temp51.
    INSERT `Item Closed: {0}` INTO TABLE temp51.
    INSERT `${$source>/title}` INTO TABLE temp51.
    
    CLEAR temp52.
    INSERT `notificationGroup4` INTO TABLE temp52.
    INSERT `removeItem` INTO TABLE temp52.
    INSERT `$event.oSource.getId()` INTO TABLE temp52.
    
    CLEAR temp53.
    INSERT `MESSAGE_TOAST` INTO TABLE temp53.
    INSERT `show` INTO TABLE temp53.
    INSERT `Item Closed: {0}` INTO TABLE temp53.
    INSERT `${$source>/title}` INTO TABLE temp53.
    
    CLEAR temp54.
    INSERT `MESSAGE_TOAST` INTO TABLE temp54.
    INSERT `show` INTO TABLE temp54.
    INSERT `Item Pressed: {0}` INTO TABLE temp54.
    INSERT `${$source>/title}` INTO TABLE temp54.
    
    CLEAR temp55.
    INSERT `notificationGroup4` INTO TABLE temp55.
    INSERT `removeItem` INTO TABLE temp55.
    INSERT `$event.oSource.getId()` INTO TABLE temp55.
    
    CLEAR temp56.
    INSERT `MESSAGE_TOAST` INTO TABLE temp56.
    INSERT `show` INTO TABLE temp56.
    INSERT `Item Closed: {0}` INTO TABLE temp56.
    INSERT `${$source>/title}` INTO TABLE temp56.
    
    CLEAR temp57.
    INSERT `MESSAGE_TOAST` INTO TABLE temp57.
    INSERT `show` INTO TABLE temp57.
    INSERT `Item Pressed: {0}` INTO TABLE temp57.
    INSERT `${$source>/title}` INTO TABLE temp57.
    
    CLEAR temp58.
    INSERT `MESSAGE_TOAST` INTO TABLE temp58.
    INSERT `show` INTO TABLE temp58.
    INSERT `Accept Button Pressed` INTO TABLE temp58.
    
    CLEAR temp59.
    INSERT `MESSAGE_TOAST` INTO TABLE temp59.
    INSERT `show` INTO TABLE temp59.
    INSERT `Reject Button Pressed` INTO TABLE temp59.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `class`     v = `sapUiBodyBackground sapContrastPlus sapContrast`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->ele( `NotificationList`
                " id added: oList.removeItem( oItem ) needs a target for the wire
                )->a( n = `id` v = `notificationList`
                )->ele( `layoutData`
                    )->tag( `FlexItemData`
                        )->a( n = `maxWidth` v = `600px`

                )->end(

                )->ele( `NotificationListGroup`
                    )->a( n = `id`              v = `notificationGroup1`
                    )->a( n = `title`           v = `Orders`
                    )->a( n = `showCloseButton` v = `true`
                    " onItemClose removes the item from ITS OWN parent and toasts; the
                    " group closes target the list, the nested item closes target their group
                    )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                              t_arg = temp1 ) && `; ` &&
                                                    client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = temp2 )
                    )->ele( `buttons`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Accept All`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp3 )

                    )->end(
                    )->tag( `NotificationListItem`
                        )->a( n = `title`           v = `New order (#2525)`
                        )->a( n = `description`     v = desc_long
                        )->a( n = `showCloseButton` v = `true`
                        )->a( n = `datetime`        v = `1 hour`
                        )->a( n = `unread`          v = `true`
                        )->a( n = `priority`        v = `None`
                        )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                                  t_arg = temp4 ) && `; ` &&
                                                        client->follow_up_action( val   = client->cs_event-control_global
                                                                                  t_arg = temp5 )
                        )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp6 )
                        )->a( n = `authorPicture`   v = `sap-icon://car-rental`
                        )->a( n = `authorAvatarColor` v = `Accent8`
                    )->ele( `NotificationListItem`
                        )->a( n = `title`           v = `New order (#2524)`
                        )->a( n = `description`     v = `Aliquam quis varius ligula. In justo lorem, lacinia ac ex at, vulputate dictum turpis. Praesent feugiat, turpis vel scelerisque pharetra, tellus odio vehicula dolor, ` &&
                                                         `nec elementum lectus turpis at nunc.`
                        )->a( n = `showCloseButton` v = `true`
                        )->a( n = `datetime`        v = `3 days`
                        )->a( n = `unread`          v = `true`
                        )->a( n = `priority`        v = `High`
                        )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                                  t_arg = temp7 ) && `; ` &&
                                                        client->follow_up_action( val   = client->cs_event-control_global
                                                                                  t_arg = temp8 )
                        )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp9 )
                        )->a( n = `authorInitials`  v = `SF`
                        )->a( n = `authorAvatarColor` v = `Random`
                        )->ele( `buttons`
                            )->tag( `Button`
                                )->a( n = `text`  v = `Accept`
                                )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp10 )
                            )->tag( `Button`
                                )->a( n = `text`  v = `Reject`
                                )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp11 )

                        )->end(
                    )->end(
                    )->ele( `NotificationListItem`
                        )->a( n = `title`           v = `New order (#2523)`
                        )->a( n = `description`     v = `Aliquam quis varius ligula.`
                        )->a( n = `showCloseButton` v = `false`
                        )->a( n = `unread`          v = `false`
                        )->a( n = `datetime`        v = `3 days`
                        )->a( n = `priority`        v = `High`
                        )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                                  t_arg = temp12 ) && `; ` &&
                                                        client->follow_up_action( val   = client->cs_event-control_global
                                                                                  t_arg = temp13 )
                        )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp14 )
                        )->a( n = `authorInitials`  v = `YR`
                        )->a( n = `authorAvatarColor` v = `Accent7`
                        )->ele( `buttons`
                            )->tag( `Button`
                                )->a( n = `text`  v = `Accept`
                                )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp15 )
                            )->tag( `Button`
                                )->a( n = `text`  v = `Reject`
                                )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp16 )

                        )->end(
                    )->end(
                )->end(

                )->ele( `NotificationListGroup`
                    )->a( n = `id`              v = `notificationGroup2`
                    )->a( n = `title`           v = `Orders`
                    )->a( n = `showCloseButton` v = `true`
                    )->a( n = `collapsed`       v = `true`
                    )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                              t_arg = temp17 ) && `; ` &&
                                                    client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = temp18 )
                    )->ele( `buttons`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Accept All`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp19 )
                        )->tag( `Button`
                            )->a( n = `text`  v = `Reject All`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp20 )

                    )->end(
                    )->tag( `NotificationListItem`
                        )->a( n = `title`           v = `New order (#2525)`
                        )->a( n = `description`     v = desc_long
                        )->a( n = `showCloseButton` v = `true`
                        )->a( n = `datetime`        v = `1 hour`
                        )->a( n = `unread`          v = `true`
                        )->a( n = `priority`        v = `None`
                        )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                                  t_arg = temp21 ) && `; ` &&
                                                        client->follow_up_action( val   = client->cs_event-control_global
                                                                                  t_arg = temp22 )
                        )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp23 )
                        )->a( n = `authorInitials`  v = `BN`
                    )->ele( `NotificationListItem`
                        )->a( n = `title`           v = `New order (#2524)`
                        )->a( n = `description`     v = `Aliquam quis varius ligula. In justo lorem, lacinia ac ex at, vulputate dictum turpis.`
                        )->a( n = `showCloseButton` v = `true`
                        )->a( n = `datetime`        v = `3 days`
                        )->a( n = `unread`          v = `true`
                        )->a( n = `priority`        v = `High`
                        )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                                  t_arg = temp24 ) && `; ` &&
                                                        client->follow_up_action( val   = client->cs_event-control_global
                                                                                  t_arg = temp25 )
                        )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp26 )
                        )->a( n = `authorPicture`   v = `sap-icon://car-rental`
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
                        )->a( n = `title`           v = `New order (#2523)`
                        )->a( n = `description`     v = `Aliquam quis varius ligula.`
                        " the original writes showCloseButton="falseue" here - corrected to false (UI5 boolean parsing rejects the typo)
                        )->a( n = `showCloseButton` v = `false`
                        )->a( n = `unread`          v = `false`
                        )->a( n = `datetime`        v = `3 days`
                        )->a( n = `priority`        v = `High`
                        )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                                  t_arg = temp29 ) && `; ` &&
                                                        client->follow_up_action( val   = client->cs_event-control_global
                                                                                  t_arg = temp30 )
                        )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp31 )
                        )->a( n = `authorInitials`  v = `YR`
                        )->a( n = `authorAvatarColor` v = `Accent7`
                        )->ele( `buttons`
                            )->tag( `Button`
                                )->a( n = `text`  v = `Accept`
                                )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp32 )
                            )->tag( `Button`
                                )->a( n = `text`  v = `Reject`
                                )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp33 )

                        )->end(
                    )->end(
                )->end(

                )->ele( `NotificationListGroup`
                    )->a( n = `id`              v = `notificationGroup3`
                    )->a( n = `title`           v = `When 'Accept All' is pressed some of the notifications will show an error`
                    )->a( n = `showCloseButton` v = `true`
                    )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                              t_arg = temp34 ) && `; ` &&
                                                    client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = temp35 )
                    )->ele( `buttons`
                        " the original onAcceptErrors puts a random error MessageStrip on one item - simplified to the accept toast
                        )->tag( `Button`
                            )->a( n = `text`  v = `Accept All`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp36 )
                        )->tag( `Button`
                            )->a( n = `text`  v = `Reject All`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp37 )

                    )->end(
                    )->tag( `NotificationListItem`
                        )->a( n = `title`           v = `New order (#2525)`
                        )->a( n = `description`     v = desc_long
                        )->a( n = `showCloseButton` v = `true`
                        )->a( n = `datetime`        v = `1 hour`
                        )->a( n = `unread`          v = `true`
                        )->a( n = `priority`        v = `None`
                        )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                                  t_arg = temp38 ) && `; ` &&
                                                        client->follow_up_action( val   = client->cs_event-control_global
                                                                                  t_arg = temp39 )
                        )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp40 )
                        )->a( n = `authorPicture`   v = `sap-icon://car-rental`
                        )->a( n = `authorAvatarColor` v = `Accent8`
                    )->ele( `NotificationListItem`
                        )->a( n = `title`           v = `New order (#2524)`
                        )->a( n = `description`     v = `Aliquam quis varius ligula. In justo lorem, lacinia ac ex at, vulputate dictum turpis.`
                        )->a( n = `showCloseButton` v = `true`
                        )->a( n = `datetime`        v = `3 days`
                        )->a( n = `unread`          v = `true`
                        )->a( n = `priority`        v = `High`
                        )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                                  t_arg = temp41 ) && `; ` &&
                                                        client->follow_up_action( val   = client->cs_event-control_global
                                                                                  t_arg = temp42 )
                        )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp43 )
                        )->a( n = `authorPicture`   v = `sap-icon://car-rental`
                        )->a( n = `authorAvatarColor` v = `Accent8`
                        )->ele( `buttons`
                            )->tag( `Button`
                                )->a( n = `text`  v = `Accept`
                                )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp44 )

                        )->end(
                    )->end(
                    )->ele( `NotificationListItem`
                        )->a( n = `title`           v = `New order (#2523)`
                        )->a( n = `description`     v = `Aliquam quis varius ligula.`
                        " the original writes showCloseButton="falseue" here - corrected to false (UI5 boolean parsing rejects the typo)
                        )->a( n = `showCloseButton` v = `false`
                        )->a( n = `unread`          v = `false`
                        )->a( n = `datetime`        v = `3 days`
                        )->a( n = `priority`        v = `High`
                        )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                                  t_arg = temp45 ) && `; ` &&
                                                        client->follow_up_action( val   = client->cs_event-control_global
                                                                                  t_arg = temp46 )
                        )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp47 )
                        )->a( n = `authorInitials`  v = `BN`
                        )->ele( `buttons`
                            )->tag( `Button`
                                )->a( n = `text`  v = `Accept`
                                )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp48 )
                            )->tag( `Button`
                                )->a( n = `text`  v = `Reject`
                                )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp49 )

                        )->end(
                    )->end(
                )->end(

                )->ele( `NotificationListGroup`
                    )->a( n = `id`              v = `notificationGroup4`
                    )->a( n = `title`           v = `Group with notifications without footer buttons`
                    )->a( n = `showCloseButton` v = `true`
                    )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                              t_arg = temp50 ) && `; ` &&
                                                    client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = temp51 )
                    )->tag( `NotificationListItem`
                        )->a( n = `title`           v = `New order (#2525)`
                        )->a( n = `description`     v = desc_long
                        )->a( n = `showCloseButton` v = `true`
                        )->a( n = `datetime`        v = `1 hour`
                        )->a( n = `unread`          v = `true`
                        )->a( n = `priority`        v = `None`
                        )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                                  t_arg = temp52 ) && `; ` &&
                                                        client->follow_up_action( val   = client->cs_event-control_global
                                                                                  t_arg = temp53 )
                        )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp54 )
                        )->a( n = `authorPicture`   v = `sap-icon://car-rental`
                        )->a( n = `authorAvatarColor` v = `Accent8`
                    )->ele( `NotificationListItem`
                        )->a( n = `title`           v = `New order (#2524)`
                        )->a( n = `description`     v = `Aliquam quis varius ligula. In justo lorem, lacinia ac ex at, vulputate dictum turpis.`
                        )->a( n = `showCloseButton` v = `true`
                        )->a( n = `datetime`        v = `3 days`
                        )->a( n = `unread`          v = `true`
                        )->a( n = `priority`        v = `High`
                        )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                                  t_arg = temp55 ) && `; ` &&
                                                        client->follow_up_action( val   = client->cs_event-control_global
                                                                                  t_arg = temp56 )
                        )->a( n = `press`           v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp57 )
                        )->a( n = `authorInitials`  v = `BN`
                        )->ele( `buttons`
                            )->tag( `Button`
                                )->a( n = `text`  v = `Accept`
                                )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp58 )
                            )->tag( `Button`
                                )->a( n = `text`  v = `Reject`
                                )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp59 )

                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
