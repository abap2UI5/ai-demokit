" @keywords messagebox message box sap.m verticallayout text button
" @summary MessageBox is an easy way of displaying a message-type dialog to the user. You can display different types of dialogs: - Types of message (Alert, Confirmation, etc.) - Initial focus can be set to the buttons or the controls used in the message
CLASS z2ui5_cl_smpc_app_278 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_278 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
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
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`

        )->ele( n = `VerticalLayout` ns = `l`
            " id added as the dependentOn anchor of the two message boxes below
            )->a( n = `id`    v = `messageBoxHost`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Text`
                )->a( n = `text` v = `Default Behavior`

            )->tag( `Button`
                )->a( n = `text`  v = `Confirm`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `press` v = client->_event( `CONFIRM` )
                )->a( n = `width` v = `280px`
            )->tag( `Button`
                )->a( n = `text`  v = `Alert`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `press` v = client->_event( `ALERT` )
                )->a( n = `width` v = `280px`
            )->tag( `Button`
                )->a( n = `text`  v = `Error`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `press` v = client->_event( `ERROR` )
                )->a( n = `width` v = `280px`
            )->tag( `Button`
                )->a( n = `text`  v = `Info`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `press` v = client->_event( `INFO` )
                )->a( n = `width` v = `280px`
            )->tag( `Button`
                )->a( n = `text`  v = `Warning`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `press` v = client->_event( `WARNING` )
                )->a( n = `width` v = `280px`
            )->tag( `Button`
                )->a( n = `text`  v = `Success`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `press` v = client->_event( `SUCCESS` )
                )->a( n = `width` v = `280px`

            )->tag( `Text`
                )->a( n = `text` v = `More Actions`

            )->tag( `Button`
                )->a( n = `text`  v = `Error with custom action`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `press` v = client->_event( `ERROR_CUSTOM_ACTION` )
                )->a( n = `width` v = `280px`
            )->tag( `Button`
                )->a( n = `text`  v = `Warning with two actions`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `press` v = client->_event( `WARNING_TWO_ACTIONS` )
                )->a( n = `width` v = `280px`
            )->tag( `Button`
                )->a( n = `text`  v = `Message Box with Responsive Padding`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `press` v = client->_event( `RESPONSIVE_PADDING` )
                )->a( n = `width` v = `280px` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `CONFIRM`.

        client->message_box_display(
          text = `Approve purchase order 12345?`
          type = `confirm` ).

      WHEN `ALERT`.

        client->message_box_display(
          text = `The quantity you have reported exceeds the quantity planed.`
          type = `alert` ).

      WHEN `ERROR`.

        client->message_box_display(
          text = |Select a team in the "Development" area.\n"Marketing" isn't assigned to this area.|
          type = `error` ).

      WHEN `INFO`.

        client->message_box_display(
          text = `Your booking will be reserved for 24 hours.`
          type = `information` ).

      WHEN `WARNING`.

        client->message_box_display(
          text = `The project schedule was last updated over a year ago.`
          type = `warning` ).

      WHEN `SUCCESS`.

        client->message_box_display(
          text = `Project 1234567 was created and assigned to team "ABC".`
          type = `success` ).

      WHEN `RESPONSIVE_PADDING`.

        client->message_box_display(
          text       = `This Message Box has responsive paddings which will adjust based on its content width!`
          type       = `information`
          styleclass = `sapUiResponsivePadding--header sapUiResponsivePadding--content sapUiResponsivePadding--footer` ).

      WHEN `ERROR_CUSTOM_ACTION`.

        " dependentOn ties the message box to the layout's lifecycle (original: this.getView())
        client->message_box_display(
          text             = `Product A does not exist.`
          type             = `error`
          actions          = VALUE #( ( `Manage Products` ) ( `CLOSE` ) )
          emphasizedaction = `Manage Products`
          onclose          = `ACTION_SELECTED`
          dependenton      = `messageBoxHost` ).

      WHEN `WARNING_TWO_ACTIONS`.

        client->message_box_display(
          text             = `The quantity you have reported exceeds the quantity planned.`
          type             = `warning`
          actions          = VALUE #( ( `OK` ) ( `CANCEL` ) )
          emphasizedaction = `OK`
          onclose          = `ACTION_SELECTED`
          dependenton      = `messageBoxHost` ).

      WHEN `ACTION_SELECTED`.

        " the pressed action rides back as the first event argument
        client->message_toast_display( |Action selected: { client->get_event_arg( ) }| ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
