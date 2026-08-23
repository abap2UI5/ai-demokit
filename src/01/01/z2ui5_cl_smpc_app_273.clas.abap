" @keywords dialog sap.m dialogmessage verticallayout button text
" @summary Creating a dialog for showing UI messages. The possible messages types are: 'None', 'Success', 'Warning' and 'Error'.
CLASS z2ui5_cl_smpc_app_273 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.
    METHODS on_event.
    METHODS popup_message_display
      IMPORTING
        title TYPE string
        state TYPE string
        text  TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_273 IMPLEMENTATION.

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
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Button`
                )->a( n = `text`  v = `Message Dialog`
                )->a( n = `width` v = `230px`
                )->a( n = `press` v = client->_event( `DEFAULT_DIALOG` )
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->tag( `Button`
                )->a( n = `text`  v = `Message Dialog (Success)`
                )->a( n = `width` v = `230px`
                )->a( n = `press` v = client->_event( `SUCCESS_DIALOG` )
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->tag( `Button`
                )->a( n = `text`  v = `Message Dialog (Warning)`
                )->a( n = `width` v = `230px`
                )->a( n = `press` v = client->_event( `WARNING_DIALOG` )
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->tag( `Button`
                )->a( n = `text`  v = `Message Dialog (Error)`
                )->a( n = `width` v = `230px`
                )->a( n = `press` v = client->_event( `ERROR_DIALOG` )
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->tag( `Button`
                )->a( n = `text`  v = `Message Dialog (Information)`
                )->a( n = `width` v = `230px`
                )->a( n = `press` v = client->_event( `INFORMATION_DIALOG` )
                )->a( n = `class` v = `sapUiSmallMarginBottom` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    " the five controller-built Dialogs, one per press handler: same type,
    " title, state and content text, and the same single Emphasized OK button
    CASE client->get_event( ).

      WHEN `DEFAULT_DIALOG`.
        popup_message_display( title = `Default Message`
                               state = ``
                               text  = `Build enterprise-ready web applications, responsive to all devices and ` &&
                                       `running on the browser of your choice. That's OpenUI5.` ).

      WHEN `SUCCESS_DIALOG`.
        popup_message_display( title = `Success`
                               state = `Success`
                               text  = `One of the keys to success is creating realistic goals that can be ` &&
                                       `achieved in a reasonable amount of time.` ).

      WHEN `WARNING_DIALOG`.
        popup_message_display( title = `Warning`
                               state = `Warning`
                               text  = `Ruling the world is a time-consuming task. You will not have a lot of ` &&
                                       `spare time.` ).

      WHEN `ERROR_DIALOG`.
        popup_message_display( title = `Error`
                               state = `Error`
                               text  = `The only error you can make is to not even try.` ).

      WHEN `INFORMATION_DIALOG`.
        popup_message_display( title = `Information`
                               state = `Information`
                               text  = `Dialog with value state Information.` ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_message_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

    " the OK button closes the dialog roundtrip-free (the original's
    " press handler is a plain this.oDialog.close())
    DATA(dialog) = popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `Dialog`
            )->a( n = `type`  v = `Message`
            )->a( n = `title` v = title ).

    " the default dialog is the only one the original builds without a state
    IF state IS NOT INITIAL.
      dialog->a( n = `state` v = state ).
    ENDIF.

    dialog->ele( `content`
        )->tag( `Text`
            )->a( n = `text` v = text

    )->end(
        )->ele( `beginButton`
            )->tag( `Button`
                )->a( n = `type`  v = `Emphasized`
                )->a( n = `text`  v = `OK`
                )->a( n = `press` v = client->follow_up_action( client->cs_event-popup_close ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the sample has no model - the five dialogs are built from literals

  ENDMETHOD.

ENDCLASS.
