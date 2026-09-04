" @keywords feedlistitem feed list item sap.m provides set verticallayout feedlistitemaction
" @summary The Feed List Item provides a standard UI for 'feeds' where multiple users publish information on regular basis on a certain topic.
CLASS z2ui5_cl_smpc_app_025 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_action,
        text TYPE string,
        icon TYPE string,
        key  TYPE string,
      END OF ty_s_action.
    TYPES ty_t_action TYPE STANDARD TABLE OF ty_s_action WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_s_entry,
        author         TYPE string,
        author_pic_url TYPE string,
        type           TYPE string,
        date           TYPE string,
        actions        TYPE ty_t_action,
        text           TYPE string,
      END OF ty_s_entry.
    DATA t_entry_collection TYPE STANDARD TABLE OF ty_s_entry WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_025 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `${KEY}` INTO TABLE temp1.
    INSERT `${$parameters>/item}.getParent().indexOfItem(${$parameters>/item})` INTO TABLE temp1.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->ele( n = `content` ns = `l`
                )->ele( `List`
                    )->a( n = `headerText` v = `Feed Entries`
                    )->a( n = `items`      v = client->_bind( t_entry_collection )

                    )->ele( `FeedListItem`
                        )->a( n = `sender`                   v = `{AUTHOR}`
                        )->a( n = `icon`                     v = `{AUTHOR_PIC_URL}`
                        )->a( n = `senderPress`              v = client->_event( val = `PRESSED` arg = `${AUTHOR}` )
                        )->a( n = `iconPress`                v = client->_event( val = `PRESSED` arg = `${AUTHOR}` )
                        )->a( n = `info`                     v = `{TYPE}`
                        )->a( n = `timestamp`                v = `{DATE}`
                        )->a( n = `text`                     v = `{TEXT}`
                        )->a( n = `convertLinksToAnchorTags` v = `All`
                        )->a( n = `actions`                  v = `{path: 'ACTIONS', templateShareable: false}`

                        " the item index for the original's removeItem travels via the List's indexOfItem on the event's item parameter
                        )->tag( `FeedListItemAction`
                            )->a( n = `text`  v = `{TEXT}`
                            )->a( n = `icon`  v = `{ICON}`
                            )->a( n = `key`   v = `{KEY}`
                            )->a( n = `press` v = client->_event( val   = `ACTION_PRESSED`
                                                                  t_arg = temp1 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA action TYPE string.
          DATA temp3 TYPE i.
          DATA index TYPE i.

    CASE client->get_event( ).

      WHEN `PRESSED`.
        client->message_toast_display( |Pressed on { client->get_event_arg( ) }| ).

      WHEN `ACTION_PRESSED`.
        
        action = client->get_event_arg( ).
        IF action = `delete`.
          " the original's removeItem: splice the entry out of the collection (index arrives zero-based)
          
          temp3 = client->get_event_arg( 2 ).
          
          index = temp3 + 1.
          DELETE t_entry_collection INDEX index.
          client->message_toast_display( `Item deleted` ).
        ELSE.
          client->message_toast_display( |Action "{ action }" pressed.| ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the sample's feed.json; AuthorPicUrl rewritten to the OpenUI5 host, entries without Actions keep an empty table
    DATA temp4 LIKE t_entry_collection.
    DATA temp5 LIKE LINE OF temp4.
    DATA temp1 TYPE z2ui5_cl_smpc_app_025=>ty_t_action.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE z2ui5_cl_smpc_app_025=>ty_t_action.
    DATA temp6 LIKE LINE OF temp3.
    CLEAR temp4.
    
    temp5-author = `Alexandrina Victoria`.
    temp5-author_pic_url = `https://sdk.openui5.org/test-resources/sap/m/images/dronning_victoria.jpg`.
    temp5-type = `Request`.
    temp5-date = `March 03 2013`.
    
    CLEAR temp1.
    
    temp2-text = `Delete`.
    temp2-icon = `sap-icon://delete`.
    temp2-key = `delete`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `Share`.
    temp2-icon = `sap-icon://share-2`.
    temp2-key = `share`.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `Edit`.
    temp2-icon = `sap-icon://edit`.
    temp2-key = `edit`.
    INSERT temp2 INTO TABLE temp1.
    temp5-actions = temp1.
    temp5-text = `Lorem <strong>ipsum dolor sit amet</strong>, <em>consetetur sadipscing elitr</em>, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, ` &&
`<a href='http://www.sap.com'>sed diam voluptua</a>. At vero eos et accusam et justo duo dolores et ea rebum.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod ` &&
`<strong>tempor invidunt ut labore et dolore magna</strong> aliquyam erat, sed diam voluptua. <em>At vero eos et accusam et justo</em> duo dolores et ea rebum. ` &&
`Lorem ipsum dolor sit amet, consetetur sadipscing elitr, seddiamnonumyeirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. ` &&
`Lorem ipsum dolor sit amet, consetetur sadipscing elitr, <u>sed diam nonumy eirmod tempor invidunt ut labore</u> et dolore magna aliquyam erat, sed diam voluptua. ` &&
`<strong>At vero eos et accusam</strong> et justo duo dolores et ea rebum. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod ` &&
`<a href='//www.sap.com'>tempor invidunt</a> ut labore et dolore magna aliquyam erat, sed diam voluptua. <em>At vero eos et accusam</em> et justo duo dolores et ea rebum. ` &&
`Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.`.
    INSERT temp5 INTO TABLE temp4.
    temp5-author = `George Washington`.
    temp5-author_pic_url = `https://sdk.openui5.org/test-resources/sap/m/images/george_washington.jpg`.
    temp5-type = `Reply`.
    temp5-date = `March 04 2013`.
    temp5-text = `Lorem ipsum dolor sit <a href='http://www.sap.com'>amet</a>, consetetur sadipscing elitr, <em>sed diam</em> nonumy <strong>eirmod tempor</strong> invidunt ut labore`.
    INSERT temp5 INTO TABLE temp4.
    temp5-author = `Alexandrina Victoria`.
    temp5-author_pic_url = `https://sdk.openui5.org/test-resources/sap/m/images/dronning_victoria.jpg`.
    temp5-type = `Request`.
    temp5-date = `March 05 2013`.
    
    CLEAR temp3.
    
    temp6-text = `Delete`.
    temp6-icon = `sap-icon://delete`.
    temp6-key = `delete`.
    INSERT temp6 INTO TABLE temp3.
    temp6-text = `Share`.
    temp6-icon = `sap-icon://share-2`.
    temp6-key = `share`.
    INSERT temp6 INTO TABLE temp3.
    temp6-text = `Edit`.
    temp6-icon = `sap-icon://edit`.
    temp6-key = `edit`.
    INSERT temp6 INTO TABLE temp3.
    temp5-actions = temp3.
    temp5-text = `Lorem ipsum dolor sit amet, <u>consetetur sadipscing elitr</u>, sed diam nonumy eirmod tempor <strong>invidunt ut labore et dolore magna</strong> aliquyam erat`.
    INSERT temp5 INTO TABLE temp4.
    temp5-author = `George Washington`.
    temp5-author_pic_url = `https://sdk.openui5.org/test-resources/sap/m/images/george_washington.jpg`.
    temp5-type = `Rejection`.
    temp5-date = `March 07 2013`.
    temp5-text = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, www.sap.com sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.`.
    INSERT temp5 INTO TABLE temp4.
    t_entry_collection = temp4.

  ENDMETHOD.

ENDCLASS.
