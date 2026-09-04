" @keywords tokenizer sap.m tokenizermultiline verticallayout text token
" @summary Tokenizer with Multi-line support and Clear All button
CLASS z2ui5_cl_smpc_app_432 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_token,
             text TYPE string,
             key  TYPE string,
           END OF ty_s_token.
    TYPES ty_t_token TYPE STANDARD TABLE OF ty_s_token WITH DEFAULT KEY.

    DATA t_tokens TYPE ty_t_token.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_432 IMPLEMENTATION.

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
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `$event.getParameter('tokens')[0].getKey()` INTO TABLE temp1.
    INSERT `$event.getParameter('tokens').length` INTO TABLE temp1.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `height`     v = `100%`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->ele( n = `VerticalLayout` ns = `l`
                )->a( n = `class` v = `sapUiContentPadding`
                )->a( n = `width` v = `420px`

                )->tag( `Text`
                    )->a( n = `wrapping` v = `true`
                    )->a( n = `text`     v = `With multiLine enabled, tokens are displayed across multiple lines for improved readability.`
                )->tag( `Text`
                    )->a( n = `wrapping` v = `true`
                    )->a( n = `text`     v = `The showClearAll option adds a convenient 'Clear All' button, allowing users to remove all tokens at once.`

            )->end(

            )->ele( n = `VerticalLayout` ns = `l`
                )->a( n = `width` v = `360px`

                " the 19 statically declared Tokens become one bound template over
                " t_tokens - that is what makes onTokenDelete's removeToken( ) expressible
                " in the backend (app 085 precedent)
                )->ele( `Tokenizer`
                    )->a( n = `id`           v = `tokenizerMultiLine`
                    )->a( n = `class`        v = `sapUiTinyMarginBeginEnd`
                    )->a( n = `width`        v = `100%`
                    )->a( n = `tokenDelete`  v = client->_event( val   = `TOKEN_DELETE`
                                                                 t_arg = temp1 )
                    )->a( n = `multiLine`    v = `true`
                    )->a( n = `showClearAll` v = `true`
                    )->a( n = `tokens`       v = client->_bind( t_tokens )

                    )->tag( `Token`
                        )->a( n = `text` v = `{TEXT}`
                        )->a( n = `key`  v = `{KEY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
      DATA del_key TYPE string.
      DATA temp3 TYPE i.
      DATA del_count LIKE temp3.

    IF client->get_event( ) = `TOKEN_DELETE`.

      
      del_key   = client->get_event_arg( ).
      
      temp3 = client->get_event_arg( 2 ).
      
      del_count = temp3.

      " onTokenDelete removes every token the event carries; Clear All fires it
      " once with all of them, the token X with exactly one
      IF del_count >= lines( t_tokens ).
        CLEAR t_tokens.
      ELSE.
        DELETE t_tokens WHERE key = del_key.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " the 19 Tokens the original view declares, verbatim
    DATA temp4 TYPE z2ui5_cl_smpc_app_432=>ty_t_token.
    DATA temp5 LIKE LINE OF temp4.
    CLEAR temp4.
    
    temp5-text = `Andora`.
    temp5-key = `1`.
    INSERT temp5 INTO TABLE temp4.
    temp5-text = `Argentina`.
    temp5-key = `2`.
    INSERT temp5 INTO TABLE temp4.
    temp5-text = `Brazil`.
    temp5-key = `3`.
    INSERT temp5 INTO TABLE temp4.
    temp5-text = `Bulgaria`.
    temp5-key = `4`.
    INSERT temp5 INTO TABLE temp4.
    temp5-text = `Canada`.
    temp5-key = `5`.
    INSERT temp5 INTO TABLE temp4.
    temp5-text = `China`.
    temp5-key = `6`.
    INSERT temp5 INTO TABLE temp4.
    temp5-text = `Denmark`.
    temp5-key = `7`.
    INSERT temp5 INTO TABLE temp4.
    temp5-text = `Estonia`.
    temp5-key = `8`.
    INSERT temp5 INTO TABLE temp4.
    temp5-text = `The United Kingdom of Great Britain and Northern Ireland`.
    temp5-key = `9`.
    INSERT temp5 INTO TABLE temp4.
    temp5-text = `Finland`.
    temp5-key = `10`.
    INSERT temp5 INTO TABLE temp4.
    temp5-text = `Germany`.
    temp5-key = `11`.
    INSERT temp5 INTO TABLE temp4.
    temp5-text = `Hungary`.
    temp5-key = `12`.
    INSERT temp5 INTO TABLE temp4.
    temp5-text = `Ireland`.
    temp5-key = `13`.
    INSERT temp5 INTO TABLE temp4.
    temp5-text = `Norway`.
    temp5-key = `14`.
    INSERT temp5 INTO TABLE temp4.
    temp5-text = `Japan`.
    temp5-key = `15`.
    INSERT temp5 INTO TABLE temp4.
    temp5-text = `Korea`.
    temp5-key = `16`.
    INSERT temp5 INTO TABLE temp4.
    temp5-text = `Latvia`.
    temp5-key = `17`.
    INSERT temp5 INTO TABLE temp4.
    temp5-text = `Independent and Sovereign Republic of Kiribati`.
    temp5-key = `18`.
    INSERT temp5 INTO TABLE temp4.
    temp5-text = `Italy`.
    temp5-key = `19`.
    INSERT temp5 INTO TABLE temp4.
    t_tokens = temp4.

  ENDMETHOD.

ENDCLASS.
