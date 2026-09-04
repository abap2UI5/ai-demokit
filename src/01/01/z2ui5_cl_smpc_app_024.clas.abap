" @keywords feedinput feed input sap.m allows user list feedlistitem
" @summary This sample shows you how to build a complete feed user interface by combining a FeedInput with a list of FeedListItems.
CLASS z2ui5_cl_smpc_app_024 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_entry,
        author         TYPE string,
        author_pic_url TYPE string,
        type           TYPE string,
        date           TYPE string,
        text           TYPE string,
      END OF ty_s_entry.
    DATA t_entries TYPE STANDARD TABLE OF ty_s_entry WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_024 IMPLEMENTATION.

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
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->tag( `FeedInput`
            )->a( n = `post`  v = client->_event( val = `POST` arg = `${$parameters>/value}` )
            )->a( n = `icon`  v = `https://sdk.openui5.org/test-resources/sap/m/images/dronning_victoria.jpg`
            )->a( n = `class` v = `sapUiSmallMarginTopBottom`

        )->ele( `List`
            )->a( n = `showSeparators` v = `Inner`
            )->a( n = `items`          v = client->_bind( t_entries )

            )->tag( `FeedListItem`
                )->a( n = `sender`                   v = `{AUTHOR}`
                )->a( n = `icon`                     v = `{AUTHOR_PIC_URL}`
                )->a( n = `senderPress`              v = client->_event( val = `SENDER_PRESS` arg = `${$source>/sender}` )
                )->a( n = `iconPress`                v = client->_event( val = `ICON_PRESS` arg = `${$source>/sender}` )
                )->a( n = `info`                     v = `{TYPE}`
                )->a( n = `timestamp`                v = `{DATE}`
                )->a( n = `text`                     v = `{TEXT}`
                )->a( n = `convertLinksToAnchorTags` v = `All` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE string_table.
        DATA month_names LIKE temp1.
        DATA temp3 TYPE i.
        DATA hour LIKE temp3.
        DATA temp4 TYPE string.
        DATA meridiem LIKE temp4.
        DATA temp5 TYPE i.
        DATA temp6 TYPE i.
        DATA date_formatted TYPE string.
        DATA temp2 LIKE LINE OF month_names.
        DATA temp8 LIKE sy-tabix.
        DATA temp7 TYPE z2ui5_cl_smpc_app_024=>ty_s_entry.

    CASE client->get_event( ).

      WHEN `POST`.
        " original: DateFormat.getDateTimeInstance({ style: 'medium' }).format(new Date()) - rebuilt server-side
        
        CLEAR temp1.
        INSERT `Jan` INTO TABLE temp1.
        INSERT `Feb` INTO TABLE temp1.
        INSERT `Mar` INTO TABLE temp1.
        INSERT `Apr` INTO TABLE temp1.
        INSERT `May` INTO TABLE temp1.
        INSERT `Jun` INTO TABLE temp1.
        INSERT `Jul` INTO TABLE temp1.
        INSERT `Aug` INTO TABLE temp1.
        INSERT `Sep` INTO TABLE temp1.
        INSERT `Oct` INTO TABLE temp1.
        INSERT `Nov` INTO TABLE temp1.
        INSERT `Dec` INTO TABLE temp1.
        
        month_names = temp1.
        
        temp3 = sy-uzeit(2).
        
        hour = temp3.
        
        IF hour < 12.
          temp4 = `AM`.
        ELSE.
          temp4 = `PM`.
        ENDIF.
        
        meridiem = temp4.
        
        IF hour MOD 12 = 0.
          temp5 = 12.
        ELSE.
          temp5 = hour MOD 12.
        ENDIF.
        hour = temp5.
        
        temp6 = sy-datum+6(2).
        
        
        
        temp8 = sy-tabix.
        READ TABLE month_names INDEX sy-datum+4(2) INTO temp2.
        sy-tabix = temp8.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        date_formatted = |{ temp2 } { temp6 }, { sy-datum(4) }, { hour }:{ sy-uzeit+2(2) }:{ sy-uzeit+4(2) } { meridiem }|.
        
        CLEAR temp7.
        temp7-author = `Alexandrina Victoria`.
        temp7-author_pic_url = `http://upload.wikimedia.org/wikipedia/commons/a/aa/Dronning_victoria.jpg`.
        temp7-type = `Reply`.
        temp7-date = date_formatted.
        temp7-text = client->get_event_arg( ).
        INSERT temp7
               INTO t_entries INDEX 1.

      WHEN `SENDER_PRESS`.
        client->message_toast_display( |Clicked on Link: { client->get_event_arg( ) }| ).

      WHEN `ICON_PRESS`.
        client->message_toast_display( |Clicked on Image: { client->get_event_arg( ) }| ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    DATA temp8 LIKE t_entries.
    DATA temp9 LIKE LINE OF temp8.
    CLEAR temp8.
    
    temp9-author = `Alexandrina Victoria`.
    temp9-author_pic_url = `https://sdk.openui5.org/test-resources/sap/m/images/dronning_victoria.jpg`.
    temp9-type = `Request`.
    temp9-date = `March 03 2013`.
    temp9-text = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
`Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. ` &&
`Lorem ipsum dolor sit amet, consetetur sadipscing elitr, seddiamnonumyeirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. ` &&
`Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. ` &&
`Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. ` &&
`Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.`.
    INSERT temp9 INTO TABLE temp8.
    temp9-author = `George Washington`.
    temp9-author_pic_url = `https://sdk.openui5.org/test-resources/sap/m/images/george_washington.jpg`.
    temp9-type = `Reply`.
    temp9-date = `March 04 2013`.
    temp9-text = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore`.
    INSERT temp9 INTO TABLE temp8.
    temp9-author = `Alexandrina Victoria`.
    temp9-author_pic_url = `https://sdk.openui5.org/test-resources/sap/m/images/dronning_victoria.jpg`.
    temp9-type = `Request`.
    temp9-date = `March 05 2013`.
    temp9-text = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat`.
    INSERT temp9 INTO TABLE temp8.
    temp9-author = `George Washington`.
    temp9-author_pic_url = `https://sdk.openui5.org/test-resources/sap/m/images/george_washington.jpg`.
    temp9-type = `Rejection`.
    temp9-date = `March 07 2013`.
    temp9-text = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.`.
    INSERT temp9 INTO TABLE temp8.
    t_entries = temp8.

  ENDMETHOD.

ENDCLASS.
