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
    DATA t_messages TYPE STANDARD TABLE OF ty_s_message WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_449 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " messages the original registers on the sap.ui.core.message.MessageManager
    DATA temp1 LIKE t_messages.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-type = `Error`.
    temp2-message = `Error message`.
    temp2-additional_text = `Example of additionalText`.
    temp2-description = `Example of description`.
    INSERT temp2 INTO TABLE temp1.
    temp2-type = `Information`.
    temp2-message = `Information message`.
    temp2-additional_text = `Example of additionalText`.
    temp2-description = `Example of description`.
    INSERT temp2 INTO TABLE temp1.
    temp2-type = `Success`.
    temp2-message = `Success message`.
    temp2-additional_text = `Example of additionalText`.
    temp2-description = `Example of description`.
    INSERT temp2 INTO TABLE temp1.
    temp2-type = `Warning`.
    temp2-message = `Warning message`.
    temp2-additional_text = `Example of additionalText`.
    temp2-description = `Example of description`.
    INSERT temp2 INTO TABLE temp1.
    t_messages = temp1.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_api_xml.
    view = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `Page`
            )->a( n = `id`         v = `messageHandlingPage`
            )->a( n = `showHeader` v = `false`

            )->open( `MessageView`
                )->a( n = `items` v = client->_bind_edit( t_messages )

                )->leaf( `MessageItem`
                    )->a( n = `type`        v = `{TYPE}`
                    )->a( n = `title`       v = `{MESSAGE}`
                    )->a( n = `subtitle`    v = `{ADDITIONAL_TEXT}`
                    )->a( n = `description` v = `{DESCRIPTION}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
