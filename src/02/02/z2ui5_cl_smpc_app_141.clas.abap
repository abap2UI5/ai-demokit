" @keywords invisiblemessage invisible message sap.ui.core a11y hbox button flexitemdata text
" @summary The InvisibleMessage provides a way to programmaticaly expose dynamic content changes in a way that can be announced by screen readers.
CLASS z2ui5_cl_smpc_app_141 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA statustext TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_141 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      statustext = `There is no message sent to the invisible message service. Please, press a button.`.
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `$event.oSource.getType()` INTO TABLE temp1.
    INSERT `$event.oSource.getText()` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `$event.oSource.getType()` INTO TABLE temp2.
    INSERT `$event.oSource.getText()` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `$event.oSource.getType()` INTO TABLE temp3.
    INSERT `$event.oSource.getText()` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `$event.oSource.getType()` INTO TABLE temp4.
    INSERT `$event.oSource.getText()` INTO TABLE temp4.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `height`     v = `100%`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`
            )->a( n = `class`      v = `sapUiContentPadding`

            )->ele( `content`
                )->ele( `HBox`
                    )->ele( `Button`
                        )->a( n = `text`  v = `Infromation`
                        )->a( n = `press` v = client->_event( val   = `PRESS`
                                                              t_arg = temp1 )
                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `type`  v = `Accept`
                        )->a( n = `text`  v = `Success`
                        )->a( n = `press` v = client->_event( val   = `PRESS`
                                                              t_arg = temp2 )
                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `text`  v = `Error`
                        )->a( n = `press` v = client->_event( val   = `PRESS`
                                                              t_arg = temp3 )
                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(
                    )->tag( `Button`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `text`  v = `Emphasized`
                        )->a( n = `press` v = client->_event( val   = `PRESS`
                                                              t_arg = temp4 )

                )->end(
                )->ele( `HBox`
                    )->tag( `Text`
                        )->a( n = `id`   v = `statustext`
                        )->a( n = `text` v = client->_bind( statustext ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
      DATA message TYPE string.
      DATA temp3 TYPE string_table.

    IF client->get_event( ) = `PRESS`.
      " original onPress: announces the pressed button's type+text to the
      " InvisibleMessage a11y service and echoes it into the status Text. The
      " pressed button's identity rides along as event args, the message is
      " composed here exactly as the original concatenates it, and the
      " announcement itself goes out through the INVISIBLE_MESSAGE global
      " target - the singleton has no control id, so control_global is the
      " only route to it (same wire as apps 289 and 435)
      
      message = |Button with type { client->get_event_arg( ) } | &&
                      |and text { client->get_event_arg( 2 ) } is pressed|.

      
      CLEAR temp3.
      INSERT `INVISIBLE_MESSAGE` INTO TABLE temp3.
      INSERT `announce` INTO TABLE temp3.
      INSERT message INTO TABLE temp3.
      INSERT `Assertive` INTO TABLE temp3.
      client->follow_up_action( val   = client->cs_event-control_global
                                t_arg = temp3 ).

      statustext = |A new message with text: "{ message }" | &&
                   |was sent to the invisible messaging service.|.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
