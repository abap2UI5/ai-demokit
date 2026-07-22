CLASS z2ui5_cl_ai_app_085 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_token,
        text TYPE string,
        key  TYPE string,
      END OF ty_s_token.
    DATA t_tokens    TYPE STANDARD TABLE OF ty_s_token WITH EMPTY KEY.
    DATA input_value TYPE string.
    DATA editable    TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_085 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( n = `HorizontalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->leaf( `Input`
                )->a( n = `id`          v = `tokenInput`
                )->a( n = `placeholder` v = `Insert token text`
                )->a( n = `width`       v = `320px`
                )->a( n = `value`       v = client->_bind( input_value )
            )->leaf( `Button`
                )->a( n = `class` v = `sapUiTinyMarginStart`
                )->a( n = `text`  v = `Add Token`
                )->a( n = `press` v = client->_event( `ADD` )
            )->leaf( `CheckBox`
                )->a( n = `text`     v = `Editable`
                )->a( n = `selected` v = client->_bind( editable )

        )->shut(

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`
            )->open( `Tokenizer`
                )->a( n = `id`          v = `tokenizer`
                )->a( n = `width`       v = `65%`
                )->a( n = `editable`    v = client->_bind( editable )
                )->a( n = `tokenDelete` v = client->_event( val   = `DELETE`
                                                            t_arg = VALUE #( ( `$event.getParameter('tokens')[0].getKey()` ) ) )
                )->a( n = `tokens`      v = client->_bind( t_tokens )

                )->leaf( `Token`
                    )->a( n = `text` v = `{TEXT}`
                    )->a( n = `key`  v = `{KEY}`

            )->shut(
        )->shut(

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->leaf( `Label`
                )->a( n = `text`  v = `Disabled tokenizer`
                )->a( n = `class` v = `sapUiLargeMarginTop`
                )->a( n = `width` v = `100%`
            )->open( `Tokenizer`
                )->a( n = `id`      v = `tokenizerDisabled`
                )->a( n = `width`   v = `320px`
                )->a( n = `enabled` v = `false`
                )->open( `tokens`
                    )->leaf( `Token`
                        )->a( n = `text` v = `Disabled token`
                        )->a( n = `key`  v = `1`
                    )->leaf( `Token`
                        )->a( n = `text` v = `Disabled token 2`
                        )->a( n = `key`  v = `2`
                    )->leaf( `Token`
                        )->a( n = `text` v = `Another disabled token`
                        )->a( n = `key`  v = `3`

                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `ADD`.
        " onAddToken: append a Token from the input value (default text if empty), then clear the input
        DATA(text) = COND #( WHEN input_value IS NOT INITIAL THEN input_value ELSE `One more token` ).
        APPEND VALUE #( text = text key = text ) TO t_tokens.
        client->message_toast_display( |Token added: { text }| ).
        input_value = ``.
        client->view_model_update( ).
      WHEN `DELETE`.
        " onTokenDelete: remove the deleted token(s) by key from the bound model
        DATA(key) = client->get_event_arg( ).
        DELETE t_tokens WHERE key = key.
        client->message_toast_display( |Token deleted: { key }| ).
        client->view_model_update( ).
    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    editable = abap_true.
    t_tokens = VALUE #(
      ( text = `First token`  key = `1` )
      ( text = `Second token` key = `2` )
      ( text = `Third token`  key = `3` ) ).

  ENDMETHOD.

ENDCLASS.
