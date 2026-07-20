CLASS z2ui5_cl_ai_app_025 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_action,
        text TYPE string,
        icon TYPE string,
        key  TYPE string,
      END OF ty_s_action.
    TYPES ty_t_action TYPE STANDARD TABLE OF ty_s_action WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_entry,
        author         TYPE string,
        author_pic_url TYPE string,
        type           TYPE string,
        date           TYPE string,
        actions        TYPE ty_t_action,
        text           TYPE string,
      END OF ty_s_entry.
    DATA t_entry_collection TYPE STANDARD TABLE OF ty_s_entry WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_025 IMPLEMENTATION.

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

    " the sample's feed.json; AuthorPicUrl rewritten to the OpenUI5 host, entries without Actions keep an empty table
    t_entry_collection = VALUE #(
      ( author         = `Alexandrina Victoria`
        author_pic_url = `https://sdk.openui5.org/test-resources/sap/m/images/dronning_victoria.jpg`
        type           = `Request`
        date           = `March 03 2013`
        actions        = VALUE #( ( text = `Delete` icon = `sap-icon://delete` key = `delete` )
                                  ( text = `Share` icon = `sap-icon://share-2` key = `share` )
                                  ( text = `Edit` icon = `sap-icon://edit` key = `edit` ) )
        text           = `Lorem <strong>ipsum dolor sit amet</strong>, <em>consetetur sadipscing elitr</em>, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, ` &&
                         `<a href='http://www.sap.com'>sed diam voluptua</a>. At vero eos et accusam et justo duo dolores et ea rebum.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod ` &&
                         `<strong>tempor invidunt ut labore et dolore magna</strong> aliquyam erat, sed diam voluptua. <em>At vero eos et accusam et justo</em> duo dolores et ea rebum. ` &&
                         `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, seddiamnonumyeirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. ` &&
                         `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, <u>sed diam nonumy eirmod tempor invidunt ut labore</u> et dolore magna aliquyam erat, sed diam voluptua. ` &&
                         `<strong>At vero eos et accusam</strong> et justo duo dolores et ea rebum. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod ` &&
                         `<a href='//www.sap.com'>tempor invidunt</a> ut labore et dolore magna aliquyam erat, sed diam voluptua. <em>At vero eos et accusam</em> et justo duo dolores et ea rebum. ` &&
                         `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` )
      ( author         = `George Washington`
        author_pic_url = `https://sdk.openui5.org/test-resources/sap/m/images/george_washington.jpg`
        type           = `Reply`
        date           = `March 04 2013`
        text           = `Lorem ipsum dolor sit <a href='http://www.sap.com'>amet</a>, consetetur sadipscing elitr, <em>sed diam</em> nonumy <strong>eirmod tempor</strong> invidunt ut labore` )
      ( author         = `Alexandrina Victoria`
        author_pic_url = `https://sdk.openui5.org/test-resources/sap/m/images/dronning_victoria.jpg`
        type           = `Request`
        date           = `March 05 2013`
        actions        = VALUE #( ( text = `Delete` icon = `sap-icon://delete` key = `delete` )
                                  ( text = `Share` icon = `sap-icon://share-2` key = `share` )
                                  ( text = `Edit` icon = `sap-icon://edit` key = `edit` ) )
        text           = `Lorem ipsum dolor sit amet, <u>consetetur sadipscing elitr</u>, sed diam nonumy eirmod tempor <strong>invidunt ut labore et dolore magna</strong> aliquyam erat` )
      ( author         = `George Washington`
        author_pic_url = `https://sdk.openui5.org/test-resources/sap/m/images/george_washington.jpg`
        type           = `Rejection`
        date           = `March 07 2013`
        text           = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, www.sap.com sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.` ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->open( n = `content` ns = `l`
                )->open( `List`
                    )->a( n = `headerText` v = `Feed Entries`
                    )->a( n = `items`      v = client->_bind( t_entry_collection )

                    )->open( `FeedListItem`
                        )->a( n = `sender`                   v = `{AUTHOR}`
                        )->a( n = `icon`                     v = `{AUTHOR_PIC_URL}`
                        )->a( n = `senderPress`              v = client->_event( val   = `PRESSED`
                                                                                 t_arg = VALUE #( ( `${AUTHOR}` ) ) )
                        )->a( n = `iconPress`                v = client->_event( val   = `PRESSED`
                                                                                 t_arg = VALUE #( ( `${AUTHOR}` ) ) )
                        )->a( n = `info`                     v = `{TYPE}`
                        )->a( n = `timestamp`                v = `{DATE}`
                        )->a( n = `text`                     v = `{TEXT}`
                        )->a( n = `convertLinksToAnchorTags` v = `All`
                        )->a( n = `actions`                  v = `{path: 'ACTIONS', templateShareable: false}`

                        " the item index for the original's removeItem travels via the List's indexOfItem on the event's item parameter
                        )->leaf( `FeedListItemAction`
                            )->a( n = `text`  v = `{TEXT}`
                            )->a( n = `icon`  v = `{ICON}`
                            )->a( n = `key`   v = `{KEY}`
                            )->a( n = `press` v = client->_event( val   = `ACTION_PRESSED`
                                                                  t_arg = VALUE #( ( `${KEY}` )
                                                                                   ( `${$parameters>/item/oParent}.indexOfItem(${$parameters>/item})` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `PRESSED`.
        client->message_toast_display( |Pressed on { client->get_event_arg( ) }| ).

      WHEN `ACTION_PRESSED`.
        DATA(action) = client->get_event_arg( ).
        IF action = `delete`.
          " the original's removeItem: splice the entry out of the collection (index arrives zero-based)
          DATA(index) = CONV i( client->get_event_arg( 2 ) ) + 1.
          DELETE t_entry_collection INDEX index.
          client->view_model_update( ).
          client->message_toast_display( `Item deleted` ).
        ELSE.
          client->message_toast_display( |Action "{ action }" pressed.| ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
