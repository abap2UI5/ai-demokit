"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.MessageView - MessageViewMessageManager
"! https://sdk.openui5.org/entity/sap.m.MessageView/sample/sap.m.sample.MessageViewMessageManager
CLASS z2ui5_cl_api_app_449 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_message,
        type            TYPE string,
        message         TYPE string,
        additional_text TYPE string,
        description     TYPE string,
      END OF ty_s_message.
    DATA t_messages TYPE STANDARD TABLE OF ty_s_message WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS data_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_449 IMPLEMENTATION.

  " NOTES (generation):
  " - IMPROVISED: the MessageManager/message model of the original is not
  "   available in abap2UI5 - the messages are bound from a hardcoded table instead.

  METHOD data_init.

    " messages the original registers on the sap.ui.core.message.MessageManager
    t_messages = VALUE #(
      ( type            = `Error`
        message         = `Error message`
        additional_text = `Example of additionalText`
        description     = `Example of description` )
      ( type            = `Information`
        message         = `Information message`
        additional_text = `Example of additionalText`
        description     = `Example of description` )
      ( type            = `Success`
        message         = `Success message`
        additional_text = `Example of additionalText`
        description     = `Example of description` )
      ( type            = `Warning`
        message         = `Warning message`
        additional_text = `Example of additionalText`
        description     = `Example of description` ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->attr( n = `height`    v = `100%`
        )->attr( n = `xmlns`     v = `sap.m`
        )->attr( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `Page`
            )->attr( n = `id`         v = `messageHandlingPage`
            )->attr( n = `showHeader` v = `false`

            )->open( `MessageView`
                )->attr( n = `items` v = client->_bind( t_messages )

                )->leaf( `MessageItem`
                    )->attr( n = `type`        v = `{TYPE}`
                    )->attr( n = `title`       v = `{MESSAGE}`
                    )->attr( n = `subtitle`    v = `{ADDITIONAL_TEXT}`
                    )->attr( n = `description` v = `{DESCRIPTION}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      data_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
