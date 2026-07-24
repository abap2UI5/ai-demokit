CLASS z2ui5_cl_ai_app_107 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_filter,
             type TYPE string,
           END OF ty_s_filter.
    DATA t_filters TYPE STANDARD TABLE OF ty_s_filter WITH EMPTY KEY.
    DATA sort_key TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_107 IMPLEMENTATION.

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
        )->a( n = `height`         v = `100%`
        )->a( n = `xmlns:core`     v = `sap.ui.core`
        )->a( n = `xmlns:mvc`      v = `sap.ui.core.mvc`
        )->a( n = `xmlns`          v = `sap.m`
        )->a( n = `xmlns:semantic` v = `sap.m.semantic`
        )->a( n = `displayBlock`   v = `true`

        )->open( `SplitContainer`
            )->open( `masterPages`
                )->open( n = `MasterPage` ns = `semantic`
                    )->a( n = `title` v = `Master Page Title`

                    )->open( n = `landmarkInfo` ns = `semantic`
                        )->leaf( `PageAccessibleLandmarkInfo`
                            )->a( n = `rootLabel`   v = `Root label`
                            )->a( n = `headerLabel` v = `Header label`
                            )->a( n = `footerLabel` v = `Footer label`

                    )->shut(
                    )->open( n = `sort` ns = `semantic`
                        )->open( n = `SortSelect` ns = `semantic`
                            )->a( n = `change`      v = client->_event( `SELECT_CHANGE` )
                            )->a( n = `selectedKey` v = client->_bind( sort_key )
                            )->a( n = `items` v = |\{ path: '{ client->_bind( val = t_filters path = abap_true ) }', sorter: \{ path: 'Name' \} \}|

                            )->leaf( n = `Item` ns = `core`
                                )->a( n = `key`  v = `{TYPE}`
                                )->a( n = `text` v = `{TYPE}`

                    )->shut(
                    )->shut(
                    )->open( n = `filter` ns = `semantic`
                        )->leaf( n = `FilterAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `FilterAction` ) ) )

                    )->shut(
                    )->open( n = `group` ns = `semantic`
                        )->leaf( n = `GroupAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `GroupAction` ) ) )

                    )->shut(
                    )->open( n = `addAction` ns = `semantic`
                        )->leaf( n = `AddAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `AddAction` ) ) )

                    )->shut(
                    )->open( n = `multiSelectAction` ns = `semantic`
                        )->leaf( n = `MultiSelectAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( `MULTI` )

                    )->shut(
                )->shut(
            )->shut(
            )->open( `detailPages`
                )->open( n = `DetailPage` ns = `semantic`
                    )->a( n = `title` v = `Detail Page Title`

                    )->open( n = `positiveAction` ns = `semantic`
                        )->leaf( n = `PositiveAction` ns = `semantic`
                            )->a( n = `text`  v = `Positive`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `PositiveAction` ) ) )

                    )->shut(
                    )->open( n = `negativeAction` ns = `semantic`
                        )->leaf( n = `NegativeAction` ns = `semantic`
                            )->a( n = `text`  v = `Negative`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `NegativeAction` ) ) )

                    )->shut(
                    )->open( n = `forwardAction` ns = `semantic`
                        )->leaf( n = `ForwardAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `ForwardAction` ) ) )

                    )->shut(
                    )->open( n = `flagAction` ns = `semantic`
                        )->leaf( n = `FlagAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `FlagAction` ) ) )

                    )->shut(
                    )->open( n = `favoriteAction` ns = `semantic`
                        )->leaf( n = `FavoriteAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `FavoriteAction` ) ) )

                    )->shut(
                    )->open( n = `sendEmailAction` ns = `semantic`
                        )->leaf( n = `SendEmailAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `SendEmailAction` ) ) )

                    )->shut(
                    )->open( n = `sendMessageAction` ns = `semantic`
                        )->leaf( n = `SendMessageAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `SendMessageAction` ) ) )

                    )->shut(
                    )->open( n = `discussInJamAction` ns = `semantic`
                        )->leaf( n = `DiscussInJamAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `DiscussInJamAction` ) ) )

                    )->shut(
                    )->open( n = `shareInJamAction` ns = `semantic`
                        )->leaf( n = `ShareInJamAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `ShareInJamAction` ) ) )

                    )->shut(
                    )->open( n = `printAction` ns = `semantic`
                        )->leaf( n = `PrintAction` ns = `semantic`
                            )->a( n = `press` v = client->_event( val = `SEM` t_arg = VALUE #( ( `PrintAction` ) ) )

                    )->shut(
                    )->open( n = `messagesIndicator` ns = `semantic`
                        )->leaf( n = `MessagesIndicator` ns = `semantic`
                            )->a( n = `press` v = client->_event( `MESSAGES` )

                    )->shut(
                    )->open( n = `pagingAction` ns = `semantic`
                        )->leaf( `PagingButton`
                            )->a( n = `count`          v = `5`
                            )->a( n = `positionChange` v = client->_event( val = `POSITION` t_arg = VALUE #( ( `${$parameters>/newPosition}` ) ) )

                    )->shut(
                    )->open( n = `customFooterContent` ns = `semantic`
                        )->leaf( `OverflowToolbarButton`
                            )->a( n = `icon`  v = `sap-icon://settings`
                            )->a( n = `text`  v = `Settings`
                            )->a( n = `press` v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                        )->leaf( `OverflowToolbarButton`
                            )->a( n = `icon`  v = `sap-icon://video`
                            )->a( n = `text`  v = `Video`
                            )->a( n = `press` v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) )

                    )->shut(
                    )->open( n = `customShareMenuContent` ns = `semantic`
                        )->leaf( `Button`
                            )->a( n = `text`  v = `CustomShareBtn1`
                            )->a( n = `icon`  v = `sap-icon://color-fill`
                            )->a( n = `press` v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                        )->leaf( `Button`
                            )->a( n = `text`  v = `CustomShareBtn2`
                            )->a( n = `icon`  v = `sap-icon://crop`
                            )->a( n = `press` v = client->_event( val = `PRESS` t_arg = VALUE #( ( `$event.oSource.sId` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `SEM`.
        client->message_toast_display( |Pressed: { client->get_event_arg( ) }| ).

      WHEN `SELECT_CHANGE`.
        client->message_toast_display( |Selected: { sort_key }| ).

      WHEN `MULTI`.
        client->message_toast_display( `MultiSelect Pressed` ).

      WHEN `MESSAGES`.
        client->message_toast_display( `Messages` ).

      WHEN `POSITION`.
        client->message_toast_display( |Positioned changed to { client->get_event_arg( ) }| ).

      WHEN `PRESS`.
        client->message_toast_display( |Pressed custom button { client->get_event_arg( ) }| ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    t_filters = VALUE #( ( type = `Category` ) ( type = `SupplierName` ) ).

  ENDMETHOD.

ENDCLASS.
