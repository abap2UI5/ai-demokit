" @keywords notificationlistgroup notification list group sap.m notificationlistgroupbindings vbox notificationlist flexitemdata button notificationlistitem
" @summary A control suitable for grouping notifications. The sample uses JSON data bindings.
CLASS z2ui5_cl_smpc_app_291 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_button,
        text TYPE string,
      END OF ty_s_button.
    TYPES ty_t_button TYPE STANDARD TABLE OF ty_s_button WITH EMPTY KEY.
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
    TYPES ty_t_item TYPE STANDARD TABLE OF ty_s_item WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_group,
        title           TYPE string,
        showemptygroup  TYPE abap_bool,
        showclosebutton TYPE abap_bool,
        groupitems      TYPE ty_t_item,
        groupbuttons    TYPE ty_t_button,
      END OF ty_s_group.
    TYPES ty_t_group TYPE STANDARD TABLE OF ty_s_group WITH EMPTY KEY.

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

    " three levels of bound aggregation: the groups, each group's items and
    " each group's / item's buttons. Every toast the controller composes from
    " the pressed control stays on the client; only the item close needs the
    " backend, because it removes a row
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
                                                                 omit_initial_paths = VALUE #( ( `AUTHORAVATARCOLOR` ) ) ) }', templateShareable: true \}|

                )->ele( `layoutData`
                    )->tag( `FlexItemData`
                        )->a( n = `maxWidth` v = `600px`

                )->end(

                )->ele( `NotificationListGroup`
                    )->a( n = `title`           v = `{TITLE}`
                    )->a( n = `showCloseButton` v = `{SHOWCLOSEBUTTON}`
                    )->a( n = `showEmptyGroup`  v = `{SHOWEMPTYGROUP}`
                    )->a( n = `close`           v = client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Group Closed: {0}` ) ( `${$source>/title}` ) ) )
                    )->a( n = `items`           v = |\{ path: 'GROUPITEMS', templateShareable: true \}|
                    )->a( n = `buttons`         v = |\{ path: 'GROUPBUTTONS', templateShareable: true \}|

                    )->ele( `buttons`
                        )->tag( `Button`
                            )->a( n = `text`  v = `{TEXT}`
                            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                            t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Group Button '{0}' Pressed` ) ( `${$source>/text}` ) ) )

                    )->end(

                    )->ele( `NotificationListItem`
                        )->a( n = `title`             v = `{TITLE}`
                        )->a( n = `description`       v = `{DESCRIPTION}`
                        )->a( n = `showCloseButton`   v = `{SHOWCLOSEBUTTON}`
                        )->a( n = `datetime`          v = `{CREATIONDATE}`
                        )->a( n = `unread`            v = `{UNREAD}`
                        )->a( n = `priority`          v = `{PRIORITY}`
                        )->a( n = `close`             v = client->_event( val   = `ITEM_CLOSE`
                                                                          t_arg = VALUE #( ( `${TITLE}` ) ) )
                        )->a( n = `press`             v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                    t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item Pressed: {0}` ) ( `${$source>/title}` ) ) )
                        )->a( n = `authorPicture`     v = `{AUTHORPICTURE}`
                        )->a( n = `authorInitials`    v = `{AUTHORINITIALS}`
                        )->a( n = `authorAvatarColor` v = `{AUTHORAVATARCOLOR}`
                        )->a( n = `buttons`           v = |\{ path: 'ITEMBUTTONS', templateShareable: true \}|

                        )->ele( `buttons`
                            )->tag( `Button`
                                )->a( n = `text`  v = `{TEXT}`
                                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item Button '{0}' Pressed` ) ( `${$source>/text}` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `ITEM_CLOSE`.
      " onItemClose removes the item from its group and toasts its title; the
      " row travels by its own title, which is unique in this data
      DATA(lv_title) = client->get_event_arg( ).
      LOOP AT t_groups REFERENCE INTO DATA(group).
        DELETE group->groupitems WHERE title = lv_title.
      ENDLOOP.
      client->message_toast_display( |Item Closed: { lv_title }| ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " model/notifications.json - two groups, the second one deliberately empty
    " so showEmptyGroup can be seen
    t_groups = VALUE #(
      ( title           = `Orders waiting for approval`
        showemptygroup  = abap_true
        showclosebutton = abap_true
        groupitems      = VALUE #(
          ( title             = `New order (#2525)`
            description       = `Aliquam quis varius ligula. In justo lorem, lacinia ac ex at, vulputate dictum turpis.`
            priority          = `High`
            unread            = abap_true
            showclosebutton   = abap_true
            authorpicture     = `sap-icon://person-placeholder`
            authoravatarcolor = `Accent2`
            itembuttons       = VALUE #( ( text = `Accept` ) ( text = `Reject` ) ) )
          ( title           = `New order (#2526)`
            description     = `Lacinia ac ex at, vulputate dictum turpis.`
            priority        = `Low`
            unread          = abap_true
            showclosebutton = abap_true
            authorinitials  = `JS`
            itembuttons     = VALUE #( ( text = `Accept` ) ( text = `Reject` ) ) ) )
        groupbuttons    = VALUE #( ( text = `Accept All` ) ) )
      ( title           = `New order (#2527)`
        showemptygroup  = abap_true
        showclosebutton = abap_true
        groupbuttons    = VALUE #( ( text = `Accept All` ) ( text = `Reject All` ) ) ) ).

  ENDMETHOD.

ENDCLASS.
