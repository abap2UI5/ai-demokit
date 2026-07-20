CLASS z2ui5_cl_ai_app_543 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA reject_note TYPE string.
    DATA submit_note TYPE string.
    DATA confirm_note TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_approve_display.
    METHODS popup_reject_display.
    METHODS popup_submit_display.
    METHODS popup_confirm_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_543 IMPLEMENTATION.

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

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->leaf( `Button`
                )->a( n = `text`  v = `Approve`
                )->a( n = `width` v = `230px`
                )->a( n = `press` v = client->_event( `APPROVE_DIALOG` )
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->leaf( `Button`
                )->a( n = `text`  v = `Reject`
                )->a( n = `width` v = `230px`
                )->a( n = `press` v = client->_event( `REJECT_DIALOG` )
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->leaf( `Button`
                )->a( n = `text`  v = `Submit (mandatory note)`
                )->a( n = `width` v = `230px`
                )->a( n = `press` v = client->_event( `SUBMIT_DIALOG` )
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->leaf( `Button`
                )->a( n = `text`  v = `Confirm (optional note)`
                )->a( n = `width` v = `230px`
                )->a( n = `press` v = client->_event( `CONFIRM_DIALOG` )
                )->a( n = `class` v = `sapUiSmallMarginBottom` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `APPROVE_DIALOG`.
        popup_approve_display( ).

      WHEN `APPROVE_SUBMIT`.
        client->message_toast_display( `Submit pressed!` ).
        client->popup_destroy( ).

      WHEN `REJECT_DIALOG`.
        popup_reject_display( ).

      WHEN `REJECT_SUBMIT`.
        client->message_toast_display( |Note is: { reject_note }| ).
        client->popup_destroy( ).

      WHEN `SUBMIT_DIALOG`.
        popup_submit_display( ).

      WHEN `SUBMIT_SUBMIT`.
        client->message_toast_display( |Note is: { submit_note }| ).
        client->popup_destroy( ).

      WHEN `CONFIRM_DIALOG`.
        popup_confirm_display( ).

      WHEN `CONFIRM_SUBMIT`.
        client->message_toast_display( |Note is: { confirm_note }| ).
        client->popup_destroy( ).

      WHEN `DIALOG_CANCEL`.
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_approve_display.

    DATA(popup) = z2ui5_cl_ai_xml=>factory( ).

    popup->open( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( `Dialog`
            )->a( n = `type`  v = `Message`
            )->a( n = `title` v = `Confirm`

            )->open( `content`
                )->leaf( `Text`
                    )->a( n = `text` v = `Do you want to submit this order?`

            )->shut(
            )->open( `beginButton`
                )->leaf( `Button`
                    )->a( n = `type`  v = `Emphasized`
                    )->a( n = `text`  v = `Submit`
                    )->a( n = `press` v = client->_event( `APPROVE_SUBMIT` )

            )->shut(
            )->open( `endButton`
                )->leaf( `Button`
                    )->a( n = `text`  v = `Cancel`
                    )->a( n = `press` v = client->_event_client( client->cs_event-popup_close ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD popup_reject_display.

    DATA(popup) = z2ui5_cl_ai_xml=>factory( ).

    popup->open( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( `Dialog`
            )->a( n = `title` v = `Reject`
            )->a( n = `type`  v = `Message`

            )->open( `content`
                )->leaf( `Label`
                    )->a( n = `text`     v = `Do you want to reject this order?`
                    )->a( n = `labelFor` v = `rejectionNote`
                " original reads the note imperatively via getValue - here the value is two-way bound
                )->leaf( `TextArea`
                    )->a( n = `id`          v = `rejectionNote`
                    )->a( n = `value`       v = client->_bind( reject_note )
                    )->a( n = `width`       v = `100%`
                    )->a( n = `placeholder` v = `Add note (optional)`

            )->shut(
            )->open( `beginButton`
                )->leaf( `Button`
                    )->a( n = `type`  v = `Emphasized`
                    )->a( n = `text`  v = `Reject`
                    )->a( n = `press` v = client->_event( `REJECT_SUBMIT` )

            )->shut(
            )->open( `endButton`
                )->leaf( `Button`
                    )->a( n = `text`  v = `Cancel`
                    )->a( n = `press` v = client->_event( `DIALOG_CANCEL` ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD popup_submit_display.

    DATA(popup) = z2ui5_cl_ai_xml=>factory( ).

    popup->open( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( `Dialog`
            )->a( n = `type`  v = `Message`
            )->a( n = `title` v = `Confirm`

            )->open( `content`
                )->leaf( `Label`
                    )->a( n = `text`     v = `Do you want to submit this order?`
                    )->a( n = `labelFor` v = `submissionNote`
                " valueLiveUpdate replaces the original liveChange handler feeding the button's enabled state
                )->leaf( `TextArea`
                    )->a( n = `id`              v = `submissionNote`
                    )->a( n = `value`           v = client->_bind( submit_note )
                    )->a( n = `valueLiveUpdate` v = `true`
                    )->a( n = `width`           v = `100%`
                    )->a( n = `placeholder`     v = `Add note (required)`

            )->shut(
            )->open( `beginButton`
                " enabled while the note is non-empty - expression binding instead of the liveChange round-trip
                )->leaf( `Button`
                    )->a( n = `type`    v = `Emphasized`
                    )->a( n = `text`    v = `Submit`
                    )->a( n = `enabled` v = |\{= ${ client->_bind( submit_note ) }.length > 0 \}|
                    )->a( n = `press`   v = client->_event( `SUBMIT_SUBMIT` )

            )->shut(
            )->open( `endButton`
                )->leaf( `Button`
                    )->a( n = `text`  v = `Cancel`
                    )->a( n = `press` v = client->_event( `DIALOG_CANCEL` ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD popup_confirm_display.

    DATA(popup) = z2ui5_cl_ai_xml=>factory( ).

    popup->open( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( `Dialog`
            )->a( n = `type`  v = `Message`
            )->a( n = `title` v = `Confirm`

            )->open( `content`
                )->open( n = `HorizontalLayout` ns = `l`
                    )->open( n = `VerticalLayout` ns = `l`
                        )->a( n = `width` v = `120px`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Type: `
                        )->leaf( `Text`
                            )->a( n = `text` v = `Delivery: `
                        )->leaf( `Text`
                            )->a( n = `text` v = `Items count: `

                    )->shut(
                    )->open( n = `VerticalLayout` ns = `l`
                        )->leaf( `Text`
                            )->a( n = `text` v = `Shopping Cart`
                        )->leaf( `Text`
                            )->a( n = `text` v = `Jun 26, 2013`
                        )->leaf( `Text`
                            )->a( n = `text` v = `2`

                    )->shut(
                )->shut(
                )->leaf( `TextArea`
                    )->a( n = `id`          v = `confirmationNote`
                    )->a( n = `value`       v = client->_bind( confirm_note )
                    )->a( n = `width`       v = `100%`
                    )->a( n = `placeholder` v = `Add note (optional)`

            )->shut(
            )->open( `beginButton`
                )->leaf( `Button`
                    )->a( n = `type`  v = `Emphasized`
                    )->a( n = `text`  v = `Submit`
                    )->a( n = `press` v = client->_event( `CONFIRM_SUBMIT` )

            )->shut(
            )->open( `endButton`
                )->leaf( `Button`
                    )->a( n = `text`  v = `Cancel`
                    )->a( n = `press` v = client->_event( `DIALOG_CANCEL` ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
