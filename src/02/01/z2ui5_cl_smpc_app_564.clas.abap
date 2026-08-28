" @keywords messageview message sap.m messageviewinsideresponsivepopover button responsivepopover bar title messageitem link
" @summary A sample with Message View inside a ResponsivePopover.
CLASS z2ui5_cl_smpc_app_564 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_message,
        type              TYPE string,
        title             TYPE string,
        description       TYPE string,
        subtitle          TYPE string,
        counter           TYPE i,
        markupdescription TYPE abap_bool,
      END OF ty_s_message.
    TYPES ty_t_message TYPE STANDARD TABLE OF ty_s_message WITH EMPTY KEY.

    DATA t_messages     TYPE ty_t_message.
    DATA popover_title  TYPE string.
    DATA back_visible   TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popover_display IMPORTING by_id TYPE string.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_564 IMPLEMENTATION.

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

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`

            )->ele( `content`
                )->tag( `Button`
                    )->a( n = `id`           v = `mVBtn`
                    )->a( n = `text`         v = `Messages`
                    )->a( n = `class`        v = `sapUiLargeMarginTop sapUiLargeMarginBegin`
                    )->a( n = `ariaHasPopup` v = `Dialog`
                    " handlePopoverPress anchors the popover on the pressed button
                    )->a( n = `press`        v = client->_event( val   = `POPOVER`
                                                                 t_arg = VALUE #( ( `$event.oSource.sId` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popover_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `ResponsivePopover`
            )->a( n = `id`                v = `messagePopover`
            )->a( n = `contentWidth`      v = `20%`
            )->a( n = `contentHeight`     v = `40%`
            )->a( n = `verticalScrolling` v = `false`
            )->a( n = `modal`             v = `true`

            )->ele( `customHeader`
                )->ele( `Bar`

                    )->ele( `contentLeft`
                        )->tag( `Button`
                            )->a( n = `icon`    v = `sap-icon://nav-back`
                            )->a( n = `tooltip` v = `Back`
                            )->a( n = `visible` v = client->_bind( back_visible )
                            )->a( n = `press`   v = client->_event( `NAV_BACK` )

                    )->end(

                    )->ele( `contentMiddle`
                        )->tag( `Title`
                            )->a( n = `text` v = client->_bind( popover_title )

                    )->end(
                )->end(
            )->end(

            )->ele( `content`
                )->ele( `MessageView`
                    )->a( n = `id`                    v = `messageView`
                    )->a( n = `showDetailsPageHeader` v = `false`
                    )->a( n = `items`                 v = client->_bind( t_messages )
                    )->a( n = `itemSelect`            v = client->_event( `ITEM_SELECT` )

                    )->ele( `items`
                        )->ele( `MessageItem`
                            )->a( n = `type`              v = `{TYPE}`
                            )->a( n = `title`             v = `{TITLE}`
                            )->a( n = `description`       v = `{DESCRIPTION}`
                            )->a( n = `subtitle`          v = `{SUBTITLE}`
                            )->a( n = `counter`           v = `{COUNTER}`
                            )->a( n = `markupDescription` v = `{MARKUPDESCRIPTION}`

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
                    )->a( n = `class` v = `sapUiTinyMarginEnd`
                    )->a( n = `press` v = client->_event( `CLOSE` ) ).

    client->popover_display( xml = popup->stringify( ) by_id = by_id ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `POPOVER`.
        " handlePopoverPress navigates the MessageView back before opening; the
        " popover is rebuilt here, so only the header state has to reset
        popover_title = `Messages`.
        back_visible = abap_false.
        popover_display( client->get_event_arg( ) ).

      WHEN `ITEM_SELECT`.
        " itemSelect reveals the back button and retitles the popover
        back_visible = abap_true.
        popover_title = `Message Details`.

      WHEN `NAV_BACK`.
        back_visible = abap_false.
        popover_title = `Messages`.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  view  = client->cs_view-popover
                                  t_arg = VALUE #( ( `messageView` ) ( `navigateBack` ) ) ).

      WHEN `CLOSE`.
        client->popover_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    popover_title = `Messages`.

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
        title       = `Error message`
        description = `Second Error message description`
        subtitle    = `Example of subtitle`
        counter     = 2 )
      ( type        = `Information`
        title       = `Information message`
        description = `First Information message description`
        subtitle    = `Example of subtitle`
        counter     = 1 ) ).

  ENDMETHOD.

ENDCLASS.
