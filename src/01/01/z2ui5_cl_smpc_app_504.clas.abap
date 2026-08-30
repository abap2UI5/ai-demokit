" @keywords multiinput multi input sap.m multiinputtokenupdate vbox text token
" @summary MultiInput fires several tokenUpdate events depending on when the tokens were validated.
CLASS z2ui5_cl_smpc_app_504 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_token,
             key  TYPE string,
             text TYPE string,
           END OF ty_s_token.
    TYPES ty_t_token TYPE STANDARD TABLE OF ty_s_token WITH EMPTY KEY.

    DATA t_tokens TYPE ty_t_token.
    DATA value    TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS token_add IMPORTING text TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_504 IMPLEMENTATION.

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
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->tag( `Text`
                )->a( n = `text` v = `Open a new Excel file and write the letters from 'a' to 'f' in a column. ` &&
                                     `Copy the column and paste it into the MultiInput below`
            " the JS validator decides per typed text what becomes a token; the same
            " decision is taken in ABAP on the change event, and the delayed cases are
            " driven by the framework's own timer
            )->ele( `MultiInput`
                )->a( n = `id`             v = `tokenUpdateMI`
                )->a( n = `showValueHelp`  v = `false`
                )->a( n = `showSuggestion` v = `false`
                )->a( n = `value`          v = client->_bind( value )
                )->a( n = `tokens`         v = client->_bind( t_tokens )
                )->a( n = `change`         v = client->_event( val = `VALIDATE` arg = `${$parameters>/value}` )
                )->a( n = `tokenUpdate`    v = client->_event( val = `TOKEN_UPDATE` arg = `${$parameters>/type}` )

                )->ele( `tokens`
                    )->tag( `Token`
                        )->a( n = `key`  v = `{KEY}`
                        )->a( n = `text` v = `{TEXT}`

                )->end(
            )->end(

            )->tag( `Text`
                )->a( n = `text` v = `Expected result is that tokens with texts 'c', 'd' and 'f' will be created instantly ` &&
                                     `and a single tokenUpdate will be fired for the three of them.`
            )->tag( `Text`
                )->a( n = `text` v = `Three seconds after that (simulating async validation) a token with text 'a' will be ` &&
                                     `added. Seven seconds later the MultiInput will attempt to add another token with text ` &&
                                     `'f'. Adding that token again will be successful only if in the meantime the user deleted ` &&
                                     `the 'f' token.` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `VALIDATE`.
        " the validator's switch: c/d become themselves, e becomes f, a and f are
        " added after a delay and b is rejected after one
        DATA(text) = client->get_event_arg( ).
        CLEAR value.
        CASE text.
          WHEN `c` OR `d`.
            token_add( text ).
          WHEN `e`.
            token_add( `f` ).
          WHEN `a`.
            client->follow_up_action( val   = client->cs_event-start_timer
                                      t_arg = VALUE #( ( `ADD_A` ) ( `3000` ) ) ).
          WHEN `b`.
            " the original's callback answers null after five seconds - nothing is added
            client->follow_up_action( val   = client->cs_event-start_timer
                                      t_arg = VALUE #( ( `REJECT_B` ) ( `5000` ) ) ).
          WHEN `f`.
            client->follow_up_action( val   = client->cs_event-start_timer
                                      t_arg = VALUE #( ( `ADD_F` ) ( `10000` ) ) ).
        ENDCASE.

      WHEN `ADD_A`.
        token_add( `a` ).

      WHEN `ADD_F`.
        token_add( `f` ).

      WHEN `REJECT_B`.
        RETURN.

      WHEN `TOKEN_UPDATE`.
        " _onTokenUpdate logs and toasts which tokens were added or removed
        client->message_toast_display( |{ client->get_event_arg( ) } tokens| ).

    ENDCASE.

  ENDMETHOD.


  METHOD token_add.

    " a token whose key is already there is not added again - the original's
    " validator relies on the Tokenizer refusing a duplicate key
    IF line_exists( t_tokens[ key = text ] ).
      RETURN.
    ENDIF.
    APPEND VALUE #( key = text text = text ) TO t_tokens.

  ENDMETHOD.

ENDCLASS.
