" @keywords semanticpage semantic sap.m.semantic floating footer splitcontainer masterpage sortselect item filteraction groupaction addaction
" @summary Integration of Floating Footer inside Semantic Page
CLASS z2ui5_cl_smpc_app_106 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_filter,
             type TYPE string,
           END OF ty_s_filter.
    TYPES: BEGIN OF ty_s_message,
             message     TYPE string,
             description TYPE string,
             type        TYPE string,
           END OF ty_s_message.
    DATA t_filters  TYPE STANDARD TABLE OF ty_s_filter WITH EMPTY KEY.
    DATA t_messages TYPE STANDARD TABLE OF ty_s_message WITH EMPTY KEY.
    DATA sort_key   TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_106 IMPLEMENTATION.

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
        )->a( n = `height`         v = `100%`
        )->a( n = `xmlns:core`     v = `sap.ui.core`
        )->a( n = `xmlns:mvc`      v = `sap.ui.core.mvc`
        )->a( n = `xmlns`          v = `sap.m`
        )->a( n = `xmlns:semantic` v = `sap.m.semantic`
        )->a( n = `xmlns:z2ui5`    v = `z2ui5.cc`
        )->a( n = `xmlns:ui`       v = `sap.ca.ui`
        )->a( n = `displayBlock`   v = `true`

        )->ele( `SplitContainer`
            )->ele( `masterPages`
                )->ele( n = `MasterPage` ns = `semantic`
                    )->a( n = `title`          v = `Master Page Title`
                    )->a( n = `floatingFooter` v = `true`

                    )->ele( n = `sort` ns = `semantic`
                        )->ele( n = `SortSelect` ns = `semantic`
                            )->a( n = `change`      v = client->_event( `SELECT_CHANGE` )
                            )->a( n = `selectedKey` v = client->_bind( sort_key )
                            )->a( n = `items` v = |\{ path: '{ client->_bind( val = t_filters path = abap_true ) }', sorter: \{ path: 'Name' \} \}|

                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `{TYPE}`
                                )->a( n = `text` v = `{TYPE}`

                        )->end(
                    )->end(
                    )->ele( n = `filter` ns = `semantic`
                        )->tag( n = `FilterAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `FilterAction` ) ) )

                    )->end(
                    )->ele( n = `group` ns = `semantic`
                        )->tag( n = `GroupAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `GroupAction` ) ) )

                    )->end(
                    )->ele( n = `addAction` ns = `semantic`
                        )->tag( n = `AddAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `AddAction` ) ) )

                    )->end(
                    )->ele( n = `multiSelectAction` ns = `semantic`
                        )->tag( n = `MultiSelectAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val   = `MULTI`
                                                                  t_arg = VALUE #( ( `${$source>/pressed}` ) ) )

                    )->end(
                )->end(
            )->end(
            )->ele( `detailPages`
                )->ele( n = `DetailPage` ns = `semantic`
                    )->a( n = `title`          v = `Detail Page Title`
                    )->a( n = `floatingFooter` v = `true`

                    )->ele( n = `positiveAction` ns = `semantic`
                        )->tag( n = `PositiveAction` ns = `semantic`
                            )->a( n = `text`  v = `Positive`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `PositiveAction` ) ) )

                    )->end(
                    )->ele( n = `negativeAction` ns = `semantic`
                        )->tag( n = `NegativeAction` ns = `semantic`
                            )->a( n = `text`  v = `Negative`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `NegativeAction` ) ) )

                    )->end(
                    )->ele( n = `forwardAction` ns = `semantic`
                        )->tag( n = `ForwardAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `ForwardAction` ) ) )

                    )->end(
                    )->ele( n = `flagAction` ns = `semantic`
                        )->tag( n = `FlagAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `FlagAction` ) ) )

                    )->end(
                    )->ele( n = `favoriteAction` ns = `semantic`
                        )->tag( n = `FavoriteAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `FavoriteAction` ) ) )

                    )->end(
                    )->ele( n = `sendEmailAction` ns = `semantic`
                        )->tag( n = `SendEmailAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `SendEmailAction` ) ) )

                    )->end(
                    )->ele( n = `sendMessageAction` ns = `semantic`
                        )->tag( n = `SendMessageAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `SendMessageAction` ) ) )

                    )->end(
                    )->ele( n = `discussInJamAction` ns = `semantic`
                        )->tag( n = `DiscussInJamAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `DiscussInJamAction` ) ) )

                    )->end(
                    )->ele( n = `shareInJamAction` ns = `semantic`
                        )->tag( n = `ShareInJamAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `ShareInJamAction` ) ) )

                    )->end(
                    )->ele( n = `printAction` ns = `semantic`
                        )->tag( n = `PrintAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `PrintAction` ) ) )

                    )->end(
                    )->ele( n = `messagesIndicator` ns = `semantic`
                        )->ele( n = `MessagesIndicator` ns = `semantic`
                            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                            t_arg = VALUE #( ( `semMessagePopover` ) ( `toggleBy` ) ( `$event.oSource.sId` ) ) )

                            " the original's controller-built MessagePopover over the
                            " message model, declared as a dependent of its anchor
                            )->ele( n = `dependents` ns = `semantic`
                                )->ele( `MessagePopover`
                                    )->a( n = `id`    v = `semMessagePopover`
                                    )->a( n = `items` v = `{message>/}`

                                    )->tag( `MessageItem`
                                        )->a( n = `description` v = `{message>description}`
                                        )->a( n = `type`        v = `{message>type}`
                                        )->a( n = `title`       v = `{message>message}`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                    )->ele( n = `pagingAction` ns = `semantic`
                        )->tag( `PagingButton`
                            )->a( n = `count`          v = `5`
                            )->a( n = `positionChange` v = client->_event( val = `POSITION` t_arg = VALUE #( ( `${$parameters>/newPosition}` ) ) )

                    )->end(
                    )->ele( n = `customFooterContent` ns = `semantic`
                        )->tag( `OverflowToolbarButton`
                            )->a( n = `icon`  v = `sap-icon://settings`
                            )->a( n = `text`  v = `Settings`
                            )->a( n = `press` v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                        )->tag( `OverflowToolbarButton`
                            )->a( n = `icon`  v = `sap-icon://video`
                            )->a( n = `text`  v = `Video`
                            )->a( n = `press` v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) )

                    )->end(
                    )->ele( n = `content` ns = `semantic`
                        " added container (declared): the z2ui5.cc.MessageManager bridge
                        " reproducing onInit's MessageManager.addMessages seed
                        )->tag( n = `MessageManager` ns = `z2ui5`
                            )->a( n = `items` v = client->_bind( t_messages )

                    )->end(
                    )->ele( n = `customShareMenuContent` ns = `semantic`
                        )->tag( `Button`
                            )->a( n = `text`  v = `CustomShareBtn1`
                            )->a( n = `icon`  v = `sap-icon://color-fill`
                            )->a( n = `press` v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                        )->tag( `Button`
                            )->a( n = `text`  v = `CustomShareBtn2`
                            )->a( n = `icon`  v = `sap-icon://crop`
                            )->a( n = `press` v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `SEM`.
        client->message_toast_display( |Pressed: { client->get_event_arg( ) }| ).

      WHEN `SELECT_CHANGE`.
        client->message_toast_display( |Selected: { sort_key }| ).

      WHEN `MULTI`.
        " onMultiSelectPress: getPressed() ? 'MultiSelect Pressed' : 'MultiSelect Unpressed'
        DATA(lv_pressed) = CONV abap_bool( client->get_event_arg( ) ).
        client->message_toast_display( COND #( WHEN lv_pressed = abap_true
                                               THEN `MultiSelect Pressed`
                                               ELSE `MultiSelect Unpressed` ) ).

      WHEN `POSITION`.
        client->message_toast_display( |Positioned changed to { client->get_event_arg( ) }| ).

      WHEN `PRESS`.
        client->message_toast_display( |Pressed custom button { client->get_event_arg( ) }| ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    t_filters = VALUE #( ( type = `Category` ) ( type = `SupplierName` ) ).

    " onInit: MessageManager.addMessages(new Message({ message: 'Something wrong
    " happened', type: Error })) - reconciled by the z2ui5.cc.MessageManager
    t_messages = VALUE #( ( message = `Something wrong happened` type = `Error` ) ).

  ENDMETHOD.

ENDCLASS.
