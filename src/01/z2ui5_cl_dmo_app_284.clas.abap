CLASS z2ui5_cl_dmo_app_284 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_message,
        type              TYPE string,
        title             TYPE string,
        activetitle       TYPE abap_bool,
        description       TYPE string,
        subtitle          TYPE string,
        counter           TYPE i,
        markupdescription TYPE abap_bool,
      END OF ty_s_message.
    TYPES ty_t_message TYPE STANDARD TABLE OF ty_s_message WITH EMPTY KEY.

    DATA t_messages   TYPE ty_t_message.
    DATA dialog_title TYPE string.
    DATA back_visible TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_284 IMPLEMENTATION.

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
                )->leaf( `Button`
                    )->a( n = `text`  v = `Delete`
                    )->a( n = `class` v = `sapUiLargeMarginBegin sapUiLargeMarginTop`
                    )->a( n = `press` v = client->_event( `DIALOG` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `DIALOG`.
        " handleDialogPress navigates the MessageView back before opening; the
        " popup is rebuilt here, so only the header state has to reset
        dialog_title = `Messages`.
        back_visible = abap_false.
        popup_display( ).

      WHEN `ITEM_SELECT`.
        " itemSelect reveals the back button and retitles the dialog
        back_visible = abap_true.
        dialog_title = `Message Details`.
        client->popup_model_update( ).

      WHEN `NAV_BACK`.
        back_visible = abap_false.
        dialog_title = `Messages`.
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
            )->a( n = `resizable`         v = `true`
            )->a( n = `state`             v = `Error`
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
                        )->leaf( `Title`
                            )->a( n = `text`  v = client->_bind( dialog_title )
                            )->a( n = `level` v = `H1`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `content`

                )->open( `MessageView`
                    )->a( n = `id`                    v = `messageView`
                    )->a( n = `showDetailsPageHeader` v = `false`
                    )->a( n = `items`                 v = client->_bind( t_messages )
                    )->a( n = `itemSelect`            v = client->_event( `ITEM_SELECT` )
                    " the original composes this toast on the client, so it stays there
                    )->a( n = `activeTitlePress`      v = client->_event_client( val = client->cs_event-control_global
                                                                                 t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Active title pressed` ) ) )

                    )->open( `items`

                        )->open( `MessageItem`
                            )->a( n = `type`              v = `{TYPE}`
                            )->a( n = `title`             v = `{TITLE}`
                            )->a( n = `activeTitle`       v = `{ACTIVETITLE}`
                            )->a( n = `description`       v = `{DESCRIPTION}`
                            )->a( n = `subtitle`          v = `{SUBTITLE}`
                            )->a( n = `counter`           v = `{COUNTER}`
                            )->a( n = `markupDescription` v = `{MARKUPDESCRIPTION}`

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

            )->open( `beginButton`
                )->leaf( `Button`
                    )->a( n = `text`  v = `Close`
                    )->a( n = `press` v = client->_event( `CLOSE` ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    dialog_title = `Messages`.

    " the controller's aMockMessages
    t_messages = VALUE #(
      ( type        = `Error`
        title       = `Error message`
        description = `First Error message description. ` && |\n| && `Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod`
        subtitle    = `Example of subtitle`
        counter     = 1 )
      ( type        = `Warning`
        title       = `Warning without description`
        description = `` )
      ( type        = `Success`
        title       = `Success message`
        description = `First Success message description`
        subtitle    = `Example of subtitle`
        counter     = 1 )
      ( type        = `Error`
        title       = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. `
                   && `Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris `
        description = `Second Error message description`
        subtitle    = `Example of subtitle`
        counter     = 2 )
      ( type        = `Information`
        title       = `Information message`
        description = `First Information message description`
        subtitle    = `Example of long subtitle lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et `
                   && `dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris `
        counter     = 1 )
      ( type        = `Success`
        title       = `Success message with active title`
        description = `Second Success message description`
        subtitle    = `Example of subtitle`
        activetitle = abap_true
        counter     = 1 ) ).

  ENDMETHOD.

ENDCLASS.
