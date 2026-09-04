" @keywords notificationlistgroup notification list group sap.m notificationlistgroupbindings vbox notificationlist flexitemdata button notificationlistitem
" @summary A control suitable for grouping notifications. The sample uses JSON data bindings.
CLASS z2ui5_cl_smpc_app_291 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_button,
        text TYPE string,
      END OF ty_s_button.
    TYPES ty_t_button TYPE STANDARD TABLE OF ty_s_button WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_s_item,
        title             TYPE string,
        description       TYPE string,
        priority          TYPE string,
        unread            TYPE abap_bool,
        showclosebutton   TYPE abap_bool,
        creationdate      TYPE string,
        authorpicture     TYPE string,
        authorinitials    TYPE string,
        authoravatarcolor TYPE string,
        itembuttons       TYPE ty_t_button,
      END OF ty_s_item.
    TYPES ty_t_item TYPE STANDARD TABLE OF ty_s_item WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_s_group,
        title           TYPE string,
        showemptygroup  TYPE abap_bool,
        showclosebutton TYPE abap_bool,
        groupitems      TYPE ty_t_item,
        groupbuttons    TYPE ty_t_button,
      END OF ty_s_group.
    TYPES ty_t_group TYPE STANDARD TABLE OF ty_s_group WITH DEFAULT KEY.

    DATA t_groups TYPE ty_t_group.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_291 IMPLEMENTATION.

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
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    DATA temp5 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " three levels of bound aggregation: the groups, each group's items and
    " each group's / item's buttons. Every toast the controller composes from
    " the pressed control stays on the client; only the item close needs the
    " backend, because it removes a row
    
    CLEAR temp1.
    INSERT `AUTHORAVATARCOLOR` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `Group Closed: {0}` INTO TABLE temp2.
    INSERT `${$source>/title}` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `Group Button '{0}' Pressed` INTO TABLE temp3.
    INSERT `${$source>/text}` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `MESSAGE_TOAST` INTO TABLE temp4.
    INSERT `show` INTO TABLE temp4.
    INSERT `Item Pressed: {0}` INTO TABLE temp4.
    INSERT `${$source>/title}` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `MESSAGE_TOAST` INTO TABLE temp5.
    INSERT `show` INTO TABLE temp5.
    INSERT `Item Button '{0}' Pressed` INTO TABLE temp5.
    INSERT `${$source>/text}` INTO TABLE temp5.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `class`     v = `sapUiBodyBackground sapContrastPlus`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `NotificationList`
                " AUTHORAVATARCOLOR is omitted where it is initial: the mock sets
                " authorAvatarColor on one item only, and the property is enum-typed
                " (sap.m.AvatarColor) - an empty string is not a member, so
                " validateProperty THROWS out of the binding rather than falling back
                " to the control's Accent6 default
                )->a( n = `items` v = |\{ path: '{ client->_bind( val                = t_groups
                                                                 path               = abap_true
                                                                 omit_initial_paths = temp1 ) }', templateShareable: true \}|

                )->ele( `layoutData`
                    )->tag( `FlexItemData`
                        )->a( n = `maxWidth` v = `600px`

                )->end(

                )->ele( `NotificationListGroup`
                    )->a( n = `title`           v = `{TITLE}`
                    )->a( n = `showCloseButton` v = `{SHOWCLOSEBUTTON}`
                    )->a( n = `showEmptyGroup`  v = `{SHOWEMPTYGROUP}`
                    )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = temp2 )
                    )->a( n = `items`           v = |\{ path: 'GROUPITEMS', templateShareable: true \}|
                    )->a( n = `buttons`         v = |\{ path: 'GROUPBUTTONS', templateShareable: true \}|

                    )->ele( `buttons`
                        )->tag( `Button`
                            )->a( n = `text`  v = `{TEXT}`
                            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                            t_arg = temp3 )

                    )->end(

                    )->ele( `NotificationListItem`
                        )->a( n = `title`             v = `{TITLE}`
                        )->a( n = `description`       v = `{DESCRIPTION}`
                        )->a( n = `showCloseButton`   v = `{SHOWCLOSEBUTTON}`
                        )->a( n = `datetime`          v = `{CREATIONDATE}`
                        )->a( n = `unread`            v = `{UNREAD}`
                        )->a( n = `priority`          v = `{PRIORITY}`
                        )->a( n = `close`             v = client->_event( val = `ITEM_CLOSE` arg = `${TITLE}` )
                        )->a( n = `press`             v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                    t_arg = temp4 )
                        )->a( n = `authorPicture`     v = `{AUTHORPICTURE}`
                        )->a( n = `authorInitials`    v = `{AUTHORINITIALS}`
                        )->a( n = `authorAvatarColor` v = `{AUTHORAVATARCOLOR}`
                        )->a( n = `buttons`           v = |\{ path: 'ITEMBUTTONS', templateShareable: true \}|

                        )->ele( `buttons`
                            )->tag( `Button`
                                )->a( n = `text`  v = `{TEXT}`
                                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                t_arg = temp5 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
      DATA lv_title TYPE string.
      DATA temp3 LIKE LINE OF t_groups.
      DATA group LIKE REF TO temp3.

    IF client->get_event( ) = `ITEM_CLOSE`.
      " onItemClose removes the item from its group and toasts its title; the
      " row travels by its own title, which is unique in this data
      
      lv_title = client->get_event_arg( ).
      
      
      LOOP AT t_groups REFERENCE INTO group.
        DELETE group->groupitems WHERE title = lv_title.
      ENDLOOP.
      client->message_toast_display( |Item Closed: { lv_title }| ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " model/notifications.json - two groups, the second one deliberately empty
    " so showEmptyGroup can be seen
    DATA temp4 TYPE z2ui5_cl_smpc_app_291=>ty_t_group.
    DATA temp5 LIKE LINE OF temp4.
    DATA temp6 TYPE z2ui5_cl_smpc_app_291=>ty_t_item.
    DATA temp7 LIKE LINE OF temp6.
    DATA temp12 TYPE z2ui5_cl_smpc_app_291=>ty_t_button.
    DATA temp13 LIKE LINE OF temp12.
    DATA temp14 TYPE z2ui5_cl_smpc_app_291=>ty_t_button.
    DATA temp15 LIKE LINE OF temp14.
    DATA temp8 TYPE z2ui5_cl_smpc_app_291=>ty_t_button.
    DATA temp9 LIKE LINE OF temp8.
    DATA temp10 TYPE z2ui5_cl_smpc_app_291=>ty_t_button.
    DATA temp11 LIKE LINE OF temp10.
    CLEAR temp4.
    
    temp5-title = `Orders waiting for approval`.
    temp5-showemptygroup = abap_true.
    temp5-showclosebutton = abap_true.
    
    CLEAR temp6.
    
    temp7-title = `New order (#2525)`.
    temp7-description = `Aliquam quis varius ligula. In justo lorem, lacinia ac ex at, vulputate dictum turpis.`.
    temp7-priority = `High`.
    temp7-unread = abap_true.
    temp7-showclosebutton = abap_true.
    temp7-authorpicture = `sap-icon://person-placeholder`.
    temp7-authoravatarcolor = `Accent2`.
    
    CLEAR temp12.
    
    temp13-text = `Accept`.
    INSERT temp13 INTO TABLE temp12.
    temp13-text = `Reject`.
    INSERT temp13 INTO TABLE temp12.
    temp7-itembuttons = temp12.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `New order (#2526)`.
    temp7-description = `Lacinia ac ex at, vulputate dictum turpis.`.
    temp7-priority = `Low`.
    temp7-unread = abap_true.
    temp7-showclosebutton = abap_true.
    temp7-authorinitials = `JS`.
    
    CLEAR temp14.
    
    temp15-text = `Accept`.
    INSERT temp15 INTO TABLE temp14.
    temp15-text = `Reject`.
    INSERT temp15 INTO TABLE temp14.
    temp7-itembuttons = temp14.
    INSERT temp7 INTO TABLE temp6.
    temp5-groupitems = temp6.
    
    CLEAR temp8.
    
    temp9-text = `Accept All`.
    INSERT temp9 INTO TABLE temp8.
    temp5-groupbuttons = temp8.
    INSERT temp5 INTO TABLE temp4.
    temp5-title = `New order (#2527)`.
    temp5-showemptygroup = abap_true.
    temp5-showclosebutton = abap_true.
    
    CLEAR temp10.
    
    temp11-text = `Accept All`.
    INSERT temp11 INTO TABLE temp10.
    temp11-text = `Reject All`.
    INSERT temp11 INTO TABLE temp10.
    temp5-groupbuttons = temp10.
    INSERT temp5 INTO TABLE temp4.
    t_groups = temp4.

  ENDMETHOD.

ENDCLASS.
