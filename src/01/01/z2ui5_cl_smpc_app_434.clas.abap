" @keywords containerpadding container padding sap.ui.core messagestrip button dialog text
" @summary Apply the CSS class 'sapUiContentPadding' on a UI5 container control to add a default padding of 1rem (16px) around the container content area.
CLASS z2ui5_cl_smpc_app_434 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_dialog_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_434 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->tag( `MessageStrip`
            )->a( n = `text`  v = `A dialog and other container controls by default have no content padding. By setting the CSS ` &&
                                  `class 'sapUiContentPadding' to the container control you will get a default padding of 1rem ` &&
                                  `(16px) around the content area.`
            )->a( n = `class` v = `sapUiTinyMargin`

        )->tag( `Button`
            )->a( n = `text`  v = `Show Dialog with content padding`
            )->a( n = `press` v = client->_event( `DIALOG_OPEN` )
            )->a( n = `class` v = `sapUiTinyMargin` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `DIALOG_OPEN`.
      popup_dialog_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD popup_dialog_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:app`  v = `http://schemas.sap.com/sapui5/extension/sap.ui.core.CustomData/1`

        )->ele( `Dialog`
            )->a( n = `title` v = `Content padding example`
            )->a( n = `class` v = `sapUiContentPadding`

            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text` v = `'sapUiContentPadding' class is applied to the Dialog's content.`

            )->end(
            )->ele( `beginButton`
                " onDialogCloseButton closes the dialog - the client-side popup_close does the same
                )->tag( `Button`
                    )->a( n = `text`           v = `Ok`
                    )->a( n = `app:dialogType` v = `Std`
                    )->a( n = `press`          v = client->follow_up_action( client->cs_event-popup_close )

            )->end(
            )->ele( `endButton`
                )->tag( `Button`
                    )->a( n = `text`           v = `Cancel`
                    )->a( n = `app:dialogType` v = `Std`
                    )->a( n = `press`          v = client->follow_up_action( client->cs_event-popup_close ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
