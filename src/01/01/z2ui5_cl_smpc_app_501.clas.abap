" @keywords multiinput multi input sap.m multiinputvalidators vbox label hbox token checkbox
" @summary MultiInput uses validators to accept, decline and change tokens.
CLASS z2ui5_cl_smpc_app_501 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_token,
             key  TYPE string,
             text TYPE string,
           END OF ty_s_token.
    TYPES ty_t_token TYPE STANDARD TABLE OF ty_s_token WITH EMPTY KEY.

    DATA t_tokens1 TYPE ty_t_token.
    DATA t_tokens2 TYPE ty_t_token.
    DATA t_tokens3 TYPE ty_t_token.
    DATA value1    TYPE string.
    DATA value2    TYPE string.
    DATA value3    TYPE string.
    DATA validate  TYPE abap_bool VALUE abap_true.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    " the value pending the confirm round-trip of the second MultiInput
    DATA pending TYPE string.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_501 IMPLEMENTATION.

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

            )->ele( `items`
                )->tag( `Label`
                    )->a( n = `text`     v = `MultiInput using two validators:`
                    )->a( n = `labelFor` v = `multiInput1`
                )->tag( `Label`
                    )->a( n = `text`     v = `First validator creates token where the text is the same as input value; ` &&
                                             `second validator adds symbol to token.`
                    )->a( n = `labelFor` v = `multiInput1`
                    )->a( n = `class`    v = `sapUiSmallMarginTop`

                )->ele( `HBox`
                    )->a( n = `renderType` v = `Bare`

                    )->ele( `items`
                        " the two validators run in the backend on the change event: the
                        " CheckBox gates the first one, the second prefixes the token text
                        )->ele( `MultiInput`
                            )->a( n = `id`             v = `multiInput1`
                            )->a( n = `width`          v = `50%`
                            )->a( n = `showSuggestion` v = `false`
                            )->a( n = `showValueHelp`  v = `false`
                            )->a( n = `value`          v = client->_bind( value1 )
                            )->a( n = `tokens`         v = client->_bind( t_tokens1 )
                            )->a( n = `change`         v = client->_event( val   = `VALIDATE1`
                                                                           t_arg = VALUE #( ( `${$parameters>/value}` ) ) )

                            )->ele( `tokens`
                                )->tag( `Token`
                                    )->a( n = `key`  v = `{KEY}`
                                    )->a( n = `text` v = `{TEXT}`

                            )->end(
                        )->end(

                        )->tag( `CheckBox`
                            )->a( n = `id`       v = `checkbox1`
                            )->a( n = `text`     v = `Validate?`
                            )->a( n = `selected` v = client->_bind( validate )

                    )->end(
                )->end(

                )->tag( `Label`
                    )->a( n = `text`     v = `MultiInput using asynchronous validator: add token by callback validation`
                    )->a( n = `width`    v = `100%`
                    )->a( n = `labelFor` v = `multiInput2`
                    )->a( n = `class`    v = `sapUiSmallMarginTop`
                " the asynchronous validator asks with a MessageBox.confirm and adds the
                " token in its callback - the same confirm, answered over a round-trip
                )->ele( `MultiInput`
                    )->a( n = `id`             v = `multiInput2`
                    )->a( n = `width`          v = `50%`
                    )->a( n = `showSuggestion` v = `false`
                    )->a( n = `showValueHelp`  v = `false`
                    )->a( n = `value`          v = client->_bind( value2 )
                    )->a( n = `tokens`         v = client->_bind( t_tokens2 )
                    )->a( n = `change`         v = client->_event( val   = `VALIDATE2`
                                                                   t_arg = VALUE #( ( `${$parameters>/value}` ) ) )

                    )->ele( `tokens`
                        )->tag( `Token`
                            )->a( n = `key`  v = `{KEY}`
                            )->a( n = `text` v = `{TEXT}`

                    )->end(
                )->end(

                )->tag( `Label`
                    )->a( n = `text`     v = `MultiInput with asynchronously validation`
                    )->a( n = `labelFor` v = `multiInput3`
                    )->a( n = `class`    v = `sapUiSmallMarginTop`
                )->ele( `MultiInput`
                    )->a( n = `id`             v = `multiInput3`
                    )->a( n = `width`          v = `50%`
                    )->a( n = `showSuggestion` v = `false`
                    )->a( n = `placeholder`    v = `tokens get validated asynchronously after 500ms`
                    )->a( n = `showValueHelp`  v = `false`
                    )->a( n = `value`          v = client->_bind( value3 )
                    )->a( n = `tokens`         v = client->_bind( t_tokens3 )
                    )->a( n = `change`         v = client->_event( val   = `VALIDATE3`
                                                                   t_arg = VALUE #( ( `${$parameters>/value}` ) ) )

                    )->ele( `tokens`
                        )->tag( `Token`
                            )->a( n = `key`  v = `{KEY}`
                            )->a( n = `text` v = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `VALIDATE1`.
        " validator 1 only produces a token while the CheckBox is selected;
        " validator 2 then rewrites its text to "#: <text>"
        DATA(text1) = client->get_event_arg( ).
        IF validate = abap_true AND text1 IS NOT INITIAL.
          APPEND VALUE #( key = text1 text = |#: { text1 }| ) TO t_tokens1.
        ENDIF.
        CLEAR value1.

      WHEN `VALIDATE2`.
        pending = client->get_event_arg( ).
        CLEAR value2.
        IF pending IS NOT INITIAL.
          client->message_box_display( text    = |Do you really want to add token "{ pending }"?|
                                       type    = `confirm`
                                       title   = `add Token`
                                       onclose = `VALIDATE2_DECIDE` ).
        ENDIF.

      WHEN `VALIDATE2_DECIDE`.
        IF client->get_event_arg( ) = `OK`.
          APPEND VALUE #( key = pending text = pending ) TO t_tokens2.
        ENDIF.
        CLEAR pending.

      WHEN `VALIDATE3`.
        DATA(text3) = client->get_event_arg( ).
        IF text3 IS NOT INITIAL.
          APPEND VALUE #( text = text3 ) TO t_tokens3.
        ENDIF.
        CLEAR value3.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
