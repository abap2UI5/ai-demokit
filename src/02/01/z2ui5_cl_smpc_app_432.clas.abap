" @keywords tokenizer sap.m tokenizermultiline text token
" @summary Tokenizer with Multi-line support and Clear All button
CLASS z2ui5_cl_smpc_app_432 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_token,
             text TYPE string,
             key  TYPE string,
           END OF ty_s_token.
    TYPES ty_t_token TYPE STANDARD TABLE OF ty_s_token WITH EMPTY KEY.

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
                                                                 t_arg = VALUE #( ( `$event.getParameter('tokens')[0].getKey()` )
                                                                                  ( `$event.getParameter('tokens').length` ) ) )
                    )->a( n = `multiLine`    v = `true`
                    )->a( n = `showClearAll` v = `true`
                    )->a( n = `tokens`       v = client->_bind( t_tokens )

                    )->tag( `Token`
                        )->a( n = `text` v = `{TEXT}`
                        )->a( n = `key`  v = `{KEY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `TOKEN_DELETE`.

      DATA(del_key)   = client->get_event_arg( ).
      DATA(del_count) = CONV i( client->get_event_arg( 2 ) ).

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
    t_tokens = VALUE #(
      ( text = `Andora` key = `1` )
      ( text = `Argentina` key = `2` )
      ( text = `Brazil` key = `3` )
      ( text = `Bulgaria` key = `4` )
      ( text = `Canada` key = `5` )
      ( text = `China` key = `6` )
      ( text = `Denmark` key = `7` )
      ( text = `Estonia` key = `8` )
      ( text = `The United Kingdom of Great Britain and Northern Ireland` key = `9` )
      ( text = `Finland` key = `10` )
      ( text = `Germany` key = `11` )
      ( text = `Hungary` key = `12` )
      ( text = `Ireland` key = `13` )
      ( text = `Norway` key = `14` )
      ( text = `Japan` key = `15` )
      ( text = `Korea` key = `16` )
      ( text = `Latvia` key = `17` )
      ( text = `Independent and Sovereign Republic of Kiribati` key = `18` )
      ( text = `Italy` key = `19` )
    ).

  ENDMETHOD.

ENDCLASS.
