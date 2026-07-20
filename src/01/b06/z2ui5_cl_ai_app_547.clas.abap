CLASS z2ui5_cl_ai_app_547 DEFINITION PUBLIC.

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
    DATA t_entries TYPE STANDARD TABLE OF ty_s_entry WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_547 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    t_entries = VALUE #(
      ( author         = `Alexandrina Victoria`
        author_pic_url = `https://sdk.openui5.org/test-resources/sap/m/images/dronning_victoria.jpg`
        type           = `Request`
        date           = `March 03 2013`
        text           = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
                         `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. ` &&
                         `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, seddiamnonumyeirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. ` &&
                         `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. ` &&
                         `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. ` &&
                         `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` )
      ( author         = `George Washington`
        author_pic_url = `https://sdk.openui5.org/test-resources/sap/m/images/george_washington.jpg`
        type           = `Reply`
        date           = `March 04 2013`
        text           = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore` )
      ( author         = `Alexandrina Victoria`
        author_pic_url = `https://sdk.openui5.org/test-resources/sap/m/images/dronning_victoria.jpg`
        type           = `Request`
        date           = `March 05 2013`
        text           = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat` )
      ( author         = `George Washington`
        author_pic_url = `https://sdk.openui5.org/test-resources/sap/m/images/george_washington.jpg`
        type           = `Rejection`
        date           = `March 07 2013`
        text           = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.` ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->leaf( `FeedInput`
            )->a( n = `post`  v = client->_event( val   = `POST`
                                                  t_arg = VALUE #( ( `${$parameters>/value}` ) ) )
            )->a( n = `icon`  v = `https://sdk.openui5.org/test-resources/sap/m/images/dronning_victoria.jpg`
            )->a( n = `class` v = `sapUiSmallMarginTopBottom`

        )->open( `List`
            )->a( n = `showSeparators` v = `Inner`
            )->a( n = `items`          v = client->_bind( t_entries )

            )->leaf( `FeedListItem`
                )->a( n = `sender`                   v = `{AUTHOR}`
                )->a( n = `icon`                     v = `{AUTHOR_PIC_URL}`
                )->a( n = `senderPress`              v = client->_event( val   = `SENDER_PRESS`
                                                                         t_arg = VALUE #( ( `${$source>/sender}` ) ) )
                )->a( n = `iconPress`                v = client->_event( val   = `ICON_PRESS`
                                                                         t_arg = VALUE #( ( `${$source>/sender}` ) ) )
                )->a( n = `info`                     v = `{TYPE}`
                )->a( n = `timestamp`                v = `{DATE}`
                )->a( n = `text`                     v = `{TEXT}`
                )->a( n = `convertLinksToAnchorTags` v = `All` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `POST`.
        " original: DateFormat.getDateTimeInstance({ style: 'medium' }).format(new Date()) - rebuilt server-side
        DATA(month_names) = VALUE string_table( ( `Jan` ) ( `Feb` ) ( `Mar` ) ( `Apr` ) ( `May` ) ( `Jun` ) ( `Jul` ) ( `Aug` ) ( `Sep` ) ( `Oct` ) ( `Nov` ) ( `Dec` ) ).
        DATA(hour) = CONV i( sy-uzeit(2) ).
        DATA(meridiem) = COND string( WHEN hour < 12 THEN `AM` ELSE `PM` ).
        hour = COND #( WHEN hour MOD 12 = 0 THEN 12 ELSE hour MOD 12 ).
        DATA(date_formatted) = |{ month_names[ sy-datum+4(2) ] } { CONV i( sy-datum+6(2) ) }, { sy-datum(4) }, { hour }:{ sy-uzeit+2(2) }:{ sy-uzeit+4(2) } { meridiem }|.
        INSERT VALUE #( author         = `Alexandrina Victoria`
                        author_pic_url = `http://upload.wikimedia.org/wikipedia/commons/a/aa/Dronning_victoria.jpg`
                        type           = `Reply`
                        date           = date_formatted
                        text           = client->get_event_arg( ) )
               INTO t_entries INDEX 1.
        client->view_model_update( ).

      WHEN `SENDER_PRESS`.
        client->message_toast_display( |Clicked on Link: { client->get_event_arg( ) }| ).

      WHEN `ICON_PRESS`.
        client->message_toast_display( |Clicked on Image: { client->get_event_arg( ) }| ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
