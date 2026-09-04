" @keywords tokenizer sap.m tokens editable delete horizontallayout input button checkbox verticallayout token label
" @summary Basic Tokenizer with tokens
CLASS z2ui5_cl_smpc_app_085 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_token,
        text TYPE string,
        key  TYPE string,
      END OF ty_s_token.
    DATA t_tokens    TYPE STANDARD TABLE OF ty_s_token WITH DEFAULT KEY.
    DATA input_value TYPE string.
    DATA editable    TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_085 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( n = `HorizontalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->tag( `Input`
                )->a( n = `id`          v = `tokenInput`
                )->a( n = `placeholder` v = `Insert token text`
                )->a( n = `width`       v = `320px`
                )->a( n = `value`       v = client->_bind( input_value )
            )->tag( `Button`
                )->a( n = `class` v = `sapUiTinyMarginStart`
                )->a( n = `text`  v = `Add Token`
                )->a( n = `press` v = client->_event( `ADD` )
            )->tag( `CheckBox`
                )->a( n = `text`     v = `Editable`
                )->a( n = `selected` v = client->_bind( editable )

        )->end(

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`
            )->ele( `Tokenizer`
                )->a( n = `id`          v = `tokenizer`
                )->a( n = `width`       v = `65%`
                )->a( n = `editable`    v = client->_bind( editable )
                )->a( n = `tokenDelete` v = client->_event( val = `DELETE` arg = `$event.getParameter('tokens')[0].getKey()` )
                )->a( n = `tokens`      v = client->_bind( t_tokens )

                )->tag( `Token`
                    )->a( n = `text` v = `{TEXT}`
                    )->a( n = `key`  v = `{KEY}`

            )->end(
        )->end(

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->tag( `Label`
                )->a( n = `text`  v = `Disabled tokenizer`
                )->a( n = `class` v = `sapUiLargeMarginTop`
                )->a( n = `width` v = `100%`
            )->ele( `Tokenizer`
                )->a( n = `id`      v = `tokenizerDisabled`
                )->a( n = `width`   v = `320px`
                )->a( n = `enabled` v = `false`
                )->ele( `tokens`
                    )->tag( `Token`
                        )->a( n = `text` v = `Disabled token`
                        )->a( n = `key`  v = `1`
                    )->tag( `Token`
                        )->a( n = `text` v = `Disabled token 2`
                        )->a( n = `key`  v = `2`
                    )->tag( `Token`
                        )->a( n = `text` v = `Another disabled token`
                        )->a( n = `key`  v = `3`

                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE string.
        DATA text LIKE temp1.
        DATA temp2 TYPE z2ui5_cl_smpc_app_085=>ty_s_token.
        DATA del_key TYPE string.
        DATA temp3 TYPE z2ui5_cl_smpc_app_085=>ty_s_token-text.
        DATA temp4 TYPE z2ui5_cl_smpc_app_085=>ty_s_token.
        DATA deleted_text LIKE temp3.

    CASE client->get_event( ).
      WHEN `ADD`.
        " onAddToken: append a Token from the input value (default text if empty), then clear the input
        
        IF input_value IS NOT INITIAL.
          temp1 = input_value.
        ELSE.
          temp1 = `One more token`.
        ENDIF.
        
        text = temp1.
        
        CLEAR temp2.
        temp2-text = text.
        temp2-key = text.
        APPEND temp2 TO t_tokens.
        client->message_toast_display( |Token added: { text }| ).
        input_value = ``.
      WHEN `DELETE`.
        " onTokenDelete: remove the deleted token(s) by key from the bound model; the toast carries the text like the original's oToken.getText()
        
        del_key = client->get_event_arg( ).
        
        CLEAR temp3.
        
        READ TABLE t_tokens INTO temp4 WITH KEY key = del_key.
        IF sy-subrc = 0.
          temp3 = temp4-text.
        ENDIF.
        
        deleted_text = temp3.
        DELETE t_tokens WHERE key = del_key.
        client->message_toast_display( |Token deleted: { deleted_text }| ).
    ENDCASE.

  ENDMETHOD.


  METHOD model_init.
    DATA temp5 LIKE t_tokens.
    DATA temp6 LIKE LINE OF temp5.

    editable = abap_true.
    
    CLEAR temp5.
    
    temp6-text = `First token`.
    temp6-key = `1`.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Second token`.
    temp6-key = `2`.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Third token`.
    temp6-key = `3`.
    INSERT temp6 INTO TABLE temp5.
    t_tokens = temp5.

  ENDMETHOD.

ENDCLASS.
