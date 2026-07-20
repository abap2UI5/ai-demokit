CLASS z2ui5_cl_ai_app_038 DEFINITION PUBLIC.

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

    METHODS model_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_038 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

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

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `Page`
            )->a( n = `id`         v = `messageHandlingPage`
            )->a( n = `showHeader` v = `false`

            )->open( `MessageView`
                )->a( n = `items` v = client->_bind( t_messages )

                )->leaf( `MessageItem`
                    )->a( n = `type`        v = `{TYPE}`
                    )->a( n = `title`       v = `{MESSAGE}`
                    )->a( n = `subtitle`    v = `{ADDITIONAL_TEXT}`
                    )->a( n = `description` v = `{DESCRIPTION}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
