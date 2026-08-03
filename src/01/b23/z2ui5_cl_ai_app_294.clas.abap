CLASS z2ui5_cl_ai_app_294 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_message,
        type        TYPE string,
        title       TYPE string,
        description TYPE string,
        subtitle    TYPE string,
        counter     TYPE i,
        group       TYPE string,
      END OF ty_s_message.
    TYPES ty_t_message TYPE STANDARD TABLE OF ty_s_message WITH EMPTY KEY.

    DATA t_messages   TYPE ty_t_message.
    " the three formatters, computed once in the backend (see model_init)
    DATA button_icon  TYPE string.
    DATA button_type  TYPE string.
    DATA button_text  TYPE string.
    DATA back_visible TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_294 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `Page`
            )->a( n = `showHeader` v = `false`

            )->open( `content`

            )->shut(

            )->open( `footer`
                )->open( `OverflowToolbar`

                    )->leaf( `Button`
                        )->a( n = `id`    v = `messageViewBtn`
                        )->a( n = `icon`  v = client->_bind( button_icon )
                        )->a( n = `type`  v = client->_bind( button_type )
                        )->a( n = `text`  v = client->_bind( button_text )
                        )->a( n = `press` v = client->_event( `MESSAGE_VIEW` )
                    )->leaf( `ToolbarSpacer` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `MESSAGE_VIEW`.
        " handleMessageViewPress navigates the MessageView back and opens the
        " dialog; the popup is rebuilt here, so it always opens on the list page
        back_visible = abap_false.
        popup_display( ).

      WHEN `ITEM_SELECT`.
        back_visible = abap_true.
        client->popup_model_update( ).

      WHEN `NAV_BACK`.
        back_visible = abap_false.
        client->popup_model_update( ).
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  view  = client->cs_view-popup
                                  t_arg = VALUE #( ( `messageView` ) ( `navigateBack` ) ) ).

      WHEN `CLOSE`.
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_display.

    DATA(popup) = z2ui5_cl_ai_xml=>factory( ).

    popup->open( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( `Dialog`
            )->a( n = `contentHeight`     v = `50%`
            )->a( n = `contentWidth`      v = `50%`
            )->a( n = `verticalScrolling` v = `false`

            )->open( `customHeader`

                )->open( `Bar`

                    )->open( `contentLeft`
                        )->leaf( `Button`
                            )->a( n = `icon`    v = `sap-icon://nav-back`
                            )->a( n = `visible` v = client->_bind( back_visible )
                            )->a( n = `press`   v = client->_event( `NAV_BACK` )

                    )->shut(

                    )->open( `contentMiddle`
                        )->leaf( `Text`
                            )->a( n = `text` v = `Publish order`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `content`

                )->open( `MessageView`
                    )->a( n = `id`                    v = `messageView`
                    )->a( n = `showDetailsPageHeader` v = `false`
                    )->a( n = `groupItems`            v = `true`
                    )->a( n = `items`                 v = client->_bind( t_messages )
                    )->a( n = `itemSelect`            v = client->_event( `ITEM_SELECT` )

                    )->open( `items`

                        )->open( `MessageItem`
                            )->a( n = `type`        v = `{TYPE}`
                            )->a( n = `title`       v = `{TITLE}`
                            )->a( n = `description` v = `{DESCRIPTION}`
                            )->a( n = `subtitle`    v = `{SUBTITLE}`
                            )->a( n = `counter`     v = `{COUNTER}`
                            )->a( n = `groupName`   v = `{GROUP}`

                            )->open( `link`
                                )->leaf( `Link`
                                    )->a( n = `text`   v = `Show more information`
                                    )->a( n = `href`   v = `http://sap.com`
                                    )->a( n = `target` v = `_blank`

                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( `endButton`
                )->leaf( `Button`
                    )->a( n = `text`  v = `Close`
                    )->a( n = `press` v = client->_event( `CLOSE` ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    DATA(lv_desc) = `First Error message description. ` && |\n| &&
                      `Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod` &&
                      `tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,` &&
                      `quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo` &&
                      `consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse` &&
                      `cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non` &&
                      `proident, sunt in culpa qui officia deserunt mollit anim id est laborum.`.

    " the controller's aMockMessages
    t_messages = VALUE #(
      ( type        = `Error`
        title       = `Account 801 requires an assignment`
        subtitle    = `Role is invalid`
        group       = `Purchase Order 450001`
        description = lv_desc )
      ( type        = `Warning`
        title       = `Account 821 requires a check`
        subtitle    = `Undefined task`
        group       = `Purchase Order 450001`
        description = lv_desc )
      ( type        = `Warning`
        title       = `Enter a text with maximum 6 characters length`
        group       = `Purchase Order 450002`
        description = lv_desc )
      ( type        = `Warning`
        title       = `Enter a text with maximum 8 characters length`
        group       = `Purchase Order 450002`
        description = lv_desc )
      ( type        = `Error`
        title       = `Account 802 requires an assignment`
        subtitle    = `Role is invalid`
        group       = `Purchase Order 450002`
        description = lv_desc )
      ( type        = `Information`
        title       = `Account 804 requires an assignment`
        subtitle    = `Information type subtitle`
        group       = `Purchase Order 450002`
        description = lv_desc )
      ( type        = `Error`
        title       = `Technical message without object relation`
        group       = `General`
        description = lv_desc )
      ( type        = `Warning`
        title       = `Global System will be down on Sunday`
        group       = `General`
        description = lv_desc )
      ( type        = `Error`
        title       = `Global System will be down on Sunday`
        group       = `General`
        description = lv_desc )
      ( type        = `Error`
        title       = `An Error`
        subtitle    = `Ungrouped message`
        description = lv_desc )
      ( type        = `Warning`
        title       = `A Warning`
        subtitle    = `Ungrouped message`
        description = lv_desc ) ).

    " buttonIconFormatter / buttonTypeFormatter / highestSeverityMessages walk
    " the whole message list and pick the highest severity (Error > Warning >
    " Success > Information) plus how many messages carry it. That is a
    " computation over the data, so it happens here and the Button binds the
    " finished values (thin-frontend rule, apps 009/010/022/092)
    DATA(lv_top) = `Information`.
    LOOP AT t_messages INTO DATA(ls_message).
      CASE ls_message-type.
        WHEN `Error`.
          lv_top = `Error`.
        WHEN `Warning`.
          IF lv_top <> `Error`.
            lv_top = `Warning`.
          ENDIF.
        WHEN `Success`.
          IF lv_top <> `Error` AND lv_top <> `Warning`.
            lv_top = `Success`.
          ENDIF.
      ENDCASE.
    ENDLOOP.

    CASE lv_top.
      WHEN `Error`.
        button_icon = `sap-icon://message-error`.
        button_type = `Negative`.
      WHEN `Warning`.
        button_icon = `sap-icon://message-warning`.
        button_type = `Critical`.
      WHEN `Success`.
        button_icon = `sap-icon://message-success`.
        button_type = `Success`.
      WHEN OTHERS.
        button_icon = `sap-icon://message-information`.
        button_type = `Neutral`.
    ENDCASE.

    button_text = |{ REDUCE i( INIT x = 0 FOR ls_row IN t_messages NEXT x = COND #( WHEN ls_row-type = lv_top THEN x + 1 ELSE x ) ) }|.

  ENDMETHOD.

ENDCLASS.
