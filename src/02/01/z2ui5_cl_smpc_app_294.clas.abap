" @keywords messageview message sap.m messageviewwithgrouping overflowtoolbar button toolbarspacer dialog bar text messageitem link
" @summary A sample with Message View and inside a Dialog and grouping of items
CLASS z2ui5_cl_smpc_app_294 DEFINITION PUBLIC.

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
    TYPES ty_t_message TYPE STANDARD TABLE OF ty_s_message WITH DEFAULT KEY.

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


CLASS z2ui5_cl_smpc_app_294 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`

            )->ele( `content`

            )->end(

            )->ele( `footer`
                )->ele( `OverflowToolbar`

                    )->tag( `Button`
                        )->a( n = `id`    v = `messageViewBtn`
                        )->a( n = `icon`  v = client->_bind( button_icon )
                        )->a( n = `type`  v = client->_bind( button_type )
                        )->a( n = `text`  v = client->_bind( button_text )
                        )->a( n = `press` v = client->_event( `MESSAGE_VIEW` )
                    )->tag( `ToolbarSpacer` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE string_table.

    CASE client->get_event( ).

      WHEN `MESSAGE_VIEW`.
        " handleMessageViewPress navigates the MessageView back and opens the
        " dialog; the popup is rebuilt here, so it always opens on the list page
        back_visible = abap_false.
        popup_display( ).

      WHEN `ITEM_SELECT`.
        back_visible = abap_true.

      WHEN `NAV_BACK`.
        back_visible = abap_false.
        
        CLEAR temp1.
        INSERT `messageView` INTO TABLE temp1.
        INSERT `navigateBack` INTO TABLE temp1.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  view  = client->cs_view-popup
                                  t_arg = temp1 ).

      WHEN `CLOSE`.
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_display.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `Dialog`
            )->a( n = `contentHeight`     v = `50%`
            )->a( n = `contentWidth`      v = `50%`
            )->a( n = `verticalScrolling` v = `false`

            )->ele( `customHeader`

                )->ele( `Bar`

                    )->ele( `contentLeft`
                        )->tag( `Button`
                            )->a( n = `icon`    v = `sap-icon://nav-back`
                            )->a( n = `visible` v = client->_bind( back_visible )
                            )->a( n = `press`   v = client->_event( `NAV_BACK` )

                    )->end(

                    )->ele( `contentMiddle`
                        )->tag( `Text`
                            )->a( n = `text` v = `Publish order`

                    )->end(
                )->end(
            )->end(

            )->ele( `content`

                )->ele( `MessageView`
                    )->a( n = `id`                    v = `messageView`
                    )->a( n = `showDetailsPageHeader` v = `false`
                    )->a( n = `groupItems`            v = `true`
                    )->a( n = `items`                 v = client->_bind( t_messages )
                    )->a( n = `itemSelect`            v = client->_event( `ITEM_SELECT` )

                    )->ele( `items`

                        )->ele( `MessageItem`
                            )->a( n = `type`        v = `{TYPE}`
                            )->a( n = `title`       v = `{TITLE}`
                            )->a( n = `description` v = `{DESCRIPTION}`
                            )->a( n = `subtitle`    v = `{SUBTITLE}`
                            )->a( n = `counter`     v = `{COUNTER}`
                            )->a( n = `groupName`   v = `{GROUP}`

                            )->ele( `link`
                                )->tag( `Link`
                                    )->a( n = `text`   v = `Show more information`
                                    )->a( n = `href`   v = `http://sap.com`
                                    )->a( n = `target` v = `_blank`

                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `endButton`
                )->tag( `Button`
                    )->a( n = `text`  v = `Close`
                    )->a( n = `press` v = client->_event( `CLOSE` ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    DATA lv_desc TYPE string.
    DATA temp3 TYPE z2ui5_cl_smpc_app_294=>ty_t_message.
    DATA temp4 LIKE LINE OF temp3.
    DATA lv_top TYPE string.
    DATA ls_message LIKE LINE OF t_messages.
    DATA temp5 TYPE i.
    DATA x TYPE i.
    DATA ls_row LIKE LINE OF t_messages.
      DATA temp1 TYPE i.
    lv_desc = `First Error message description. ` && |\n| &&
                      `Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod` &&
                      `tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,` &&
                      `quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo` &&
                      `consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse` &&
                      `cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non` &&
                      `proident, sunt in culpa qui officia deserunt mollit anim id est laborum.`.

    " the controller's aMockMessages
    
    CLEAR temp3.
    
    temp4-type = `Error`.
    temp4-title = `Account 801 requires an assignment`.
    temp4-subtitle = `Role is invalid`.
    temp4-group = `Purchase Order 450001`.
    temp4-description = lv_desc.
    INSERT temp4 INTO TABLE temp3.
    temp4-type = `Warning`.
    temp4-title = `Account 821 requires a check`.
    temp4-subtitle = `Undefined task`.
    temp4-group = `Purchase Order 450001`.
    temp4-description = lv_desc.
    INSERT temp4 INTO TABLE temp3.
    temp4-type = `Warning`.
    temp4-title = `Enter a text with maximum 6 characters length`.
    temp4-group = `Purchase Order 450002`.
    temp4-description = lv_desc.
    INSERT temp4 INTO TABLE temp3.
    temp4-type = `Warning`.
    temp4-title = `Enter a text with maximum 8 characters length`.
    temp4-group = `Purchase Order 450002`.
    temp4-description = lv_desc.
    INSERT temp4 INTO TABLE temp3.
    temp4-type = `Error`.
    temp4-title = `Account 802 requires an assignment`.
    temp4-subtitle = `Role is invalid`.
    temp4-group = `Purchase Order 450002`.
    temp4-description = lv_desc.
    INSERT temp4 INTO TABLE temp3.
    temp4-type = `Information`.
    temp4-title = `Account 804 requires an assignment`.
    temp4-subtitle = `Information type subtitle`.
    temp4-group = `Purchase Order 450002`.
    temp4-description = lv_desc.
    INSERT temp4 INTO TABLE temp3.
    temp4-type = `Error`.
    temp4-title = `Technical message without object relation`.
    temp4-group = `General`.
    temp4-description = lv_desc.
    INSERT temp4 INTO TABLE temp3.
    temp4-type = `Warning`.
    temp4-title = `Global System will be down on Sunday`.
    temp4-group = `General`.
    temp4-description = lv_desc.
    INSERT temp4 INTO TABLE temp3.
    temp4-type = `Error`.
    temp4-title = `Global System will be down on Sunday`.
    temp4-group = `General`.
    temp4-description = lv_desc.
    INSERT temp4 INTO TABLE temp3.
    temp4-type = `Error`.
    temp4-title = `An Error`.
    temp4-subtitle = `Ungrouped message`.
    temp4-description = lv_desc.
    INSERT temp4 INTO TABLE temp3.
    temp4-type = `Warning`.
    temp4-title = `A Warning`.
    temp4-subtitle = `Ungrouped message`.
    temp4-description = lv_desc.
    INSERT temp4 INTO TABLE temp3.
    t_messages = temp3.

    " buttonIconFormatter / buttonTypeFormatter / highestSeverityMessages walk
    " the whole message list and pick the highest severity (Error > Warning >
    " Success > Information) plus how many messages carry it. That is a
    " computation over the data, so it happens here and the Button binds the
    " finished values (thin-frontend rule, apps 009/010/022/092)
    
    lv_top = `Information`.
    
    LOOP AT t_messages INTO ls_message.
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

    
    
    x = 0.
    
    LOOP AT t_messages INTO ls_row.
      
      IF ls_row-type = lv_top.
        temp1 = x + 1.
      ELSE.
        temp1 = x.
      ENDIF.
      x = temp1.
    ENDLOOP.
    temp5 = x.
    button_text = |{ temp5 }|.

  ENDMETHOD.

ENDCLASS.
