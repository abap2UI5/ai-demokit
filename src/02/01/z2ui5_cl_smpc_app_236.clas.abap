" @keywords feedinput feed input sap.m label button dialog text
" @summary This sample shows a standalone feed input with different settings.
CLASS z2ui5_cl_smpc_app_236 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smpc_app_236 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    DATA temp5 TYPE string_table.
    DATA temp6 TYPE string_table.
    DATA temp7 TYPE string_table.
    DATA temp8 TYPE string_table.
    DATA temp9 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " the original controller's onPost does MessageToast.show( "Posted new feed entry: " + evt.getParameter( "value" ) );
    " reproduced roundtrip-free as a client-composed toast, {0} filled by the post event's value parameter
    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `Posted new feed entry: {0}` INTO TABLE temp1.
    INSERT `${$parameters>/value}` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `Posted new feed entry: {0}` INTO TABLE temp2.
    INSERT `${$parameters>/value}` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `Posted new feed entry: {0}` INTO TABLE temp3.
    INSERT `${$parameters>/value}` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `MESSAGE_TOAST` INTO TABLE temp4.
    INSERT `show` INTO TABLE temp4.
    INSERT `Posted new feed entry: {0}` INTO TABLE temp4.
    INSERT `${$parameters>/value}` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `MESSAGE_TOAST` INTO TABLE temp5.
    INSERT `show` INTO TABLE temp5.
    INSERT `Posted new feed entry: {0}` INTO TABLE temp5.
    INSERT `${$parameters>/value}` INTO TABLE temp5.
    
    CLEAR temp6.
    INSERT `MESSAGE_TOAST` INTO TABLE temp6.
    INSERT `show` INTO TABLE temp6.
    INSERT `Posted new feed entry: {0}` INTO TABLE temp6.
    INSERT `${$parameters>/value}` INTO TABLE temp6.
    
    CLEAR temp7.
    INSERT `MESSAGE_TOAST` INTO TABLE temp7.
    INSERT `show` INTO TABLE temp7.
    INSERT `Posted new feed entry: {0}` INTO TABLE temp7.
    INSERT `${$parameters>/value}` INTO TABLE temp7.
    
    CLEAR temp8.
    INSERT `MESSAGE_TOAST` INTO TABLE temp8.
    INSERT `show` INTO TABLE temp8.
    INSERT `Posted new feed entry: {0}` INTO TABLE temp8.
    INSERT `${$parameters>/value}` INTO TABLE temp8.
    
    CLEAR temp9.
    INSERT `MESSAGE_TOAST` INTO TABLE temp9.
    INSERT `show` INTO TABLE temp9.
    INSERT `Posted new feed entry: {0}` INTO TABLE temp9.
    INSERT `${$parameters>/value}` INTO TABLE temp9.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->tag( `Label`
            )->a( n = `text`  v = `Without Icon`
            )->a( n = `class` v = `sapUiSmallMarginTop sapUiTinyMarginBottom`
        )->tag( `FeedInput`
            )->a( n = `post`     v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp1 )
            )->a( n = `showIcon` v = `false`

        )->tag( `Label`
            )->a( n = `text`  v = `With Icon Placeholder`
            )->a( n = `class` v = `sapUiSmallMarginTop sapUiTinyMarginBottom`
        )->tag( `FeedInput`
            )->a( n = `post`     v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp2 )
            )->a( n = `showIcon` v = `true`

        )->tag( `Label`
            )->a( n = `text`  v = `With Icon`
            )->a( n = `class` v = `sapUiSmallMarginTop sapUiTinyMarginBottom`
        )->tag( `FeedInput`
            )->a( n = `post`     v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp3 )
            )->a( n = `showIcon` v = `true`
            " test-resources image rehosted to the OpenUI5 host per the asset-URL rule
            )->a( n = `icon`     v = `https://sdk.openui5.org/test-resources/sap/m/images/george_washington.jpg`

        )->tag( `Label`
            )->a( n = `text`  v = `Disabled`
            )->a( n = `class` v = `sapUiSmallMarginTop sapUiTinyMarginBottom`
        )->tag( `FeedInput`
            )->a( n = `post`     v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp4 )
            )->a( n = `enabled`  v = `false`
            )->a( n = `showIcon` v = `true`
            )->a( n = `icon`     v = `https://sdk.openui5.org/test-resources/sap/m/images/george_washington.jpg`

        )->tag( `Label`
            )->a( n = `text`  v = `Rows Set to 5`
            )->a( n = `class` v = `sapUiSmallMarginTop sapUiTinyMarginBottom`
        )->tag( `FeedInput`
            )->a( n = `post` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp5 )
            )->a( n = `rows` v = `5`

        )->tag( `Label`
            )->a( n = `text`  v = `With Exceeded Text`
            )->a( n = `class` v = `sapUiSmallMarginTop sapUiTinyMarginBottom`
        )->tag( `FeedInput`
            )->a( n = `post`             v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp6 )
            )->a( n = `maxLength`        v = `20`
            )->a( n = `showExceededText` v = `true`

        )->tag( `Label`
            )->a( n = `text`  v = `With Growing`
            )->a( n = `class` v = `sapUiSmallMarginTop sapUiTinyMarginBottom`
        )->tag( `FeedInput`
            )->a( n = `post`    v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp7 )
            )->a( n = `growing` v = `true`

        )->tag( `Label`
            )->a( n = `text`  v = `Without Icon and an enabled Action Button`
            )->a( n = `class` v = `sapUiSmallMarginTop sapUiTinyMarginBottom`
        )->ele( `FeedInput`
            )->a( n = `id`       v = `feedActionPlain`
            )->a( n = `post`     v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp8 )
            )->a( n = `showIcon` v = `false`

            )->ele( `actions`
                )->tag( `Button`
                    )->a( n = `icon`  v = `sap-icon://action`
                    )->a( n = `press` v = client->_event( val = `ACTION_PRESS` arg = `feedActionPlain` )

            )->end(
        )->end(

        )->tag( `Label`
            )->a( n = `text`  v = `With an Icon Placeholder and an enabled Action Button`
            )->a( n = `class` v = `sapUiSmallMarginTop sapUiTinyMarginBottom`
        )->ele( `FeedInput`
            )->a( n = `id`       v = `feedActionIcon`
            )->a( n = `post`     v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp9 )
            )->a( n = `showIcon` v = `true`

            )->ele( `actions`
                )->tag( `Button`
                    )->a( n = `icon`  v = `sap-icon://action`
                    )->a( n = `press` v = client->_event( val = `ACTION_PRESS` arg = `feedActionIcon` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp3 TYPE string_table.
        DATA temp5 TYPE string_table.

    CASE client->get_event( ).

      WHEN `ACTION_PRESS`.
        action_feed_id = client->get_event_arg( ).
        popup_action_display( ).

      WHEN `ENABLE_POST`.
        " original: oFeedInput.enablePostButton( true ) - 1:1 via the
        " CONTROL_METHODS entry enablePostButton (framework 2026-07-27)
        
        CLEAR temp3.
        INSERT action_feed_id INTO TABLE temp3.
        INSERT `enablePostButton` INTO TABLE temp3.
        INSERT `X` INTO TABLE temp3.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp3 ).
        client->popup_destroy( ).

      WHEN `DISABLE_POST`.
        
        CLEAR temp5.
        INSERT action_feed_id INTO TABLE temp5.
        INSERT `enablePostButton` INTO TABLE temp5.
        INSERT `false` INTO TABLE temp5.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp5 ).
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_action_display.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

    " the original onActionButtonPress builds this Dialog imperatively (new Dialog({...}).open());
    " expressed 1:1 as a core:FragmentDefinition shown via popup_display. The begin/end buttons
    " toggle the owning FeedInput's Post button via the whitelisted enablePostButton
    " control method (framework 2026-07-27) and close the popup server-side
    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `Dialog`
            )->a( n = `title` v = `Action Button Dialog`

            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text` v = `Choose an action.`

            )->end(
            )->ele( `beginButton`
                )->tag( `Button`
                    )->a( n = `text`  v = `Enable Post Button`
                    )->a( n = `press` v = client->_event( `ENABLE_POST` )

            )->end(
            )->ele( `endButton`
                )->tag( `Button`
                    )->a( n = `text`  v = `Disable Post Button`
                    )->a( n = `press` v = client->_event( `DISABLE_POST` ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
