CLASS z2ui5_cl_dmo_app_236 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    " id of the FeedInput whose action button opened the dialog (original:
    " oEvent.getSource().getParent()) - transported as a static button t_arg
    DATA action_feed_id TYPE string.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_action_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_236 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " the original controller's onPost does MessageToast.show( "Posted new feed entry: " + evt.getParameter( "value" ) );
    " reproduced roundtrip-free as a client-composed toast, {0} filled by the post event's value parameter
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->leaf( `Label`
            )->a( n = `text`  v = `Without Icon`
            )->a( n = `class` v = `sapUiSmallMarginTop sapUiTinyMarginBottom`
        )->leaf( `FeedInput`
            )->a( n = `post`     v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Posted new feed entry: {0}` ) ( `${$parameters>/value}` ) ) )
            )->a( n = `showIcon` v = `false`

        )->leaf( `Label`
            )->a( n = `text`  v = `With Icon Placeholder`
            )->a( n = `class` v = `sapUiSmallMarginTop sapUiTinyMarginBottom`
        )->leaf( `FeedInput`
            )->a( n = `post`     v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Posted new feed entry: {0}` ) ( `${$parameters>/value}` ) ) )
            )->a( n = `showIcon` v = `true`

        )->leaf( `Label`
            )->a( n = `text`  v = `With Icon`
            )->a( n = `class` v = `sapUiSmallMarginTop sapUiTinyMarginBottom`
        )->leaf( `FeedInput`
            )->a( n = `post`     v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Posted new feed entry: {0}` ) ( `${$parameters>/value}` ) ) )
            )->a( n = `showIcon` v = `true`
            " test-resources image rehosted to the OpenUI5 host per the asset-URL rule
            )->a( n = `icon`     v = `https://sdk.openui5.org/test-resources/sap/m/images/george_washington.jpg`

        )->leaf( `Label`
            )->a( n = `text`  v = `Disabled`
            )->a( n = `class` v = `sapUiSmallMarginTop sapUiTinyMarginBottom`
        )->leaf( `FeedInput`
            )->a( n = `post`     v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Posted new feed entry: {0}` ) ( `${$parameters>/value}` ) ) )
            )->a( n = `enabled`  v = `false`
            )->a( n = `showIcon` v = `true`
            )->a( n = `icon`     v = `https://sdk.openui5.org/test-resources/sap/m/images/george_washington.jpg`

        )->leaf( `Label`
            )->a( n = `text`  v = `Rows Set to 5`
            )->a( n = `class` v = `sapUiSmallMarginTop sapUiTinyMarginBottom`
        )->leaf( `FeedInput`
            )->a( n = `post` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Posted new feed entry: {0}` ) ( `${$parameters>/value}` ) ) )
            )->a( n = `rows` v = `5`

        )->leaf( `Label`
            )->a( n = `text`  v = `With Exceeded Text`
            )->a( n = `class` v = `sapUiSmallMarginTop sapUiTinyMarginBottom`
        )->leaf( `FeedInput`
            )->a( n = `post`             v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Posted new feed entry: {0}` ) ( `${$parameters>/value}` ) ) )
            )->a( n = `maxLength`        v = `20`
            )->a( n = `showExceededText` v = `true`

        )->leaf( `Label`
            )->a( n = `text`  v = `With Growing`
            )->a( n = `class` v = `sapUiSmallMarginTop sapUiTinyMarginBottom`
        )->leaf( `FeedInput`
            )->a( n = `post`    v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Posted new feed entry: {0}` ) ( `${$parameters>/value}` ) ) )
            )->a( n = `growing` v = `true`

        )->leaf( `Label`
            )->a( n = `text`  v = `Without Icon and an enabled Action Button`
            )->a( n = `class` v = `sapUiSmallMarginTop sapUiTinyMarginBottom`
        )->open( `FeedInput`
            )->a( n = `id`       v = `feedActionPlain`
            )->a( n = `post`     v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Posted new feed entry: {0}` ) ( `${$parameters>/value}` ) ) )
            )->a( n = `showIcon` v = `false`

            )->open( `actions`
                )->leaf( `Button`
                    )->a( n = `icon`  v = `sap-icon://action`
                    )->a( n = `press` v = client->_event( val = `ACTION_PRESS` t_arg = VALUE #( ( `feedActionPlain` ) ) )

            )->shut(
        )->shut(

        )->leaf( `Label`
            )->a( n = `text`  v = `With an Icon Placeholder and an enabled Action Button`
            )->a( n = `class` v = `sapUiSmallMarginTop sapUiTinyMarginBottom`
        )->open( `FeedInput`
            )->a( n = `id`       v = `feedActionIcon`
            )->a( n = `post`     v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Posted new feed entry: {0}` ) ( `${$parameters>/value}` ) ) )
            )->a( n = `showIcon` v = `true`

            )->open( `actions`
                )->leaf( `Button`
                    )->a( n = `icon`  v = `sap-icon://action`
                    )->a( n = `press` v = client->_event( val = `ACTION_PRESS` t_arg = VALUE #( ( `feedActionIcon` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `ACTION_PRESS`.
        action_feed_id = client->get_event_arg( ).
        popup_action_display( ).

      WHEN `ENABLE_POST`.
        " original: oFeedInput.enablePostButton( true ) - 1:1 via the
        " CONTROL_METHODS entry enablePostButton (framework 2026-07-27)
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( action_feed_id ) ( `enablePostButton` ) ( `X` ) ) ).
        client->popup_destroy( ).

      WHEN `DISABLE_POST`.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( action_feed_id ) ( `enablePostButton` ) ( `false` ) ) ).
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_action_display.

    DATA(popup) = z2ui5_cl_ai_xml=>factory( ).

    " the original onActionButtonPress builds this Dialog imperatively (new Dialog({...}).open());
    " expressed 1:1 as a core:FragmentDefinition shown via popup_display. The begin/end buttons
    " toggle the owning FeedInput's Post button via the whitelisted enablePostButton
    " control method (framework 2026-07-27) and close the popup server-side
    popup->open( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( `Dialog`
            )->a( n = `title` v = `Action Button Dialog`

            )->open( `content`
                )->leaf( `Text`
                    )->a( n = `text` v = `Choose an action.`

            )->shut(
            )->open( `beginButton`
                )->leaf( `Button`
                    )->a( n = `text`  v = `Enable Post Button`
                    )->a( n = `press` v = client->_event( `ENABLE_POST` )

            )->shut(
            )->open( `endButton`
                )->leaf( `Button`
                    )->a( n = `text`  v = `Disable Post Button`
                    )->a( n = `press` v = client->_event( `DISABLE_POST` ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
