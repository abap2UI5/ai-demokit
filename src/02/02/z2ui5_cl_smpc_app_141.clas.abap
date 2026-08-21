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
    IF client->check_on_init( ).
      statustext = `There is no message sent to the invisible message service. Please, press a button.`.
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
                                                              t_arg = VALUE #( ( `$event.oSource.getType()` )
                                                                               ( `$event.oSource.getText()` ) ) )
                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `type`  v = `Accept`
                        )->a( n = `text`  v = `Success`
                        )->a( n = `press` v = client->_event( val   = `PRESS`
                                                              t_arg = VALUE #( ( `$event.oSource.getType()` )
                                                                               ( `$event.oSource.getText()` ) ) )
                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `text`  v = `Error`
                        )->a( n = `press` v = client->_event( val   = `PRESS`
                                                              t_arg = VALUE #( ( `$event.oSource.getType()` )
                                                                               ( `$event.oSource.getText()` ) ) )
                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(
                    )->tag( `Button`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `text`  v = `Emphasized`
                        )->a( n = `press` v = client->_event( val   = `PRESS`
                                                              t_arg = VALUE #( ( `$event.oSource.getType()` )
                                                                               ( `$event.oSource.getText()` ) ) )

                )->end(
                )->ele( `HBox`
                    )->tag( `Text`
                        )->a( n = `id`   v = `statustext`
                        )->a( n = `text` v = client->_bind( statustext ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `PRESS`.
      " original onPress: announces the pressed button's type+text to the
      " InvisibleMessage a11y service and echoes it into the status Text. The
      " announce itself has no control_global entry and stays dropped, but the
      " pressed button's identity IS read back - type and text ride along as
      " event args and the sentence is composed here, exactly as the original
      " concatenates it.
      statustext = |A new message with text: "Button with type { client->get_event_arg( ) } | &&
                   |and text { client->get_event_arg( 2 ) } is pressed" | &&
                   |was sent to the invisible messaging service.|.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
