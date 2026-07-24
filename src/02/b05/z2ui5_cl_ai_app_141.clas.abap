CLASS z2ui5_cl_ai_app_141 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA statustext TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_141 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      statustext = `There is no message sent to the invisible message service. Please, press a button.`.
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `height`     v = `100%`

        )->open( `Page`
            )->a( n = `showHeader` v = `false`
            )->a( n = `class`      v = `sapUiContentPadding`

            )->open( `content`
                )->open( `HBox`
                    )->open( `Button`
                        )->a( n = `text`  v = `Infromation`
                        )->a( n = `press` v = client->_event( `PRESS` )
                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                    )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `type`  v = `Accept`
                        )->a( n = `text`  v = `Success`
                        )->a( n = `press` v = client->_event( `PRESS` )
                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                    )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `text`  v = `Error`
                        )->a( n = `press` v = client->_event( `PRESS` )
                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                    )->shut(
                    )->shut(
                    )->leaf( `Button`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `text`  v = `Emphasized`
                        )->a( n = `press` v = client->_event( `PRESS` )

                )->shut(
                )->open( `HBox`
                    )->leaf( `Text`
                        )->a( n = `id`   v = `statustext`
                        )->a( n = `text` v = client->_bind( statustext ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `PRESS`.
        " original onPress: announces the pressed button's type+text to the
        " InvisibleMessage a11y service and echoes it into the status Text.
        " The pressed button's identity is not read back here (simplified).
        statustext = `A new message was sent to the invisible messaging service.`.
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
