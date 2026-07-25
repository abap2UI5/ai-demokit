CLASS z2ui5_cl_ai_app_236 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_action_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_236 IMPLEMENTATION.

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
            )->a( n = `post`     v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Posted new feed entry: {0}` ) ( `${$parameters>/value}` ) ) )
            )->a( n = `showIcon` v = `false`

            )->open( `actions`
                )->leaf( `Button`
                    )->a( n = `icon`  v = `sap-icon://action`
                    )->a( n = `press` v = client->_event( `ACTION_PRESS` )

            )->shut(
        )->shut(

        )->leaf( `Label`
            )->a( n = `text`  v = `With an Icon Placeholder and an enabled Action Button`
            )->a( n = `class` v = `sapUiSmallMarginTop sapUiTinyMarginBottom`
        )->open( `FeedInput`
            )->a( n = `post`     v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Posted new feed entry: {0}` ) ( `${$parameters>/value}` ) ) )
            )->a( n = `showIcon` v = `true`

            )->open( `actions`
                )->leaf( `Button`
                    )->a( n = `icon`  v = `sap-icon://action`
                    )->a( n = `press` v = client->_event( `ACTION_PRESS` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `ACTION_PRESS`.
        popup_action_display( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_action_display.

    DATA(popup) = z2ui5_cl_ai_xml=>factory( ).

    " the original onActionButtonPress builds this Dialog imperatively (new Dialog({...}).open());
    " expressed 1:1 as a core:FragmentDefinition shown via popup_display. The begin/end buttons
    " only close the popup - the original's oFeedInput.enablePostButton(true/false) is not in the
    " CONTROL_METHODS whitelist, so the post-button toggle cannot be reproduced (see IMPROVISED deviation)
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
                    )->a( n = `press` v = client->_event_client( client->cs_event-popup_close )

            )->shut(
            )->open( `endButton`
                )->leaf( `Button`
                    )->a( n = `text`  v = `Disable Post Button`
                    )->a( n = `press` v = client->_event_client( client->cs_event-popup_close ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
