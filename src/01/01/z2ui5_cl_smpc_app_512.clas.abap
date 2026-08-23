" @keywords multiinput multi input sap.m multiinputmodelupdate verticallayout label token item list standardlistitem
" @summary This sample illustrates how the model bound to the MultiInput can be updated upon token creation or deletion.
CLASS z2ui5_cl_smpc_app_512 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_item,
             key       TYPE string,
             text      TYPE string,
             list_text TYPE string,
             list_info TYPE string,
           END OF ty_s_item.
    TYPES ty_t_item TYPE STANDARD TABLE OF ty_s_item WITH EMPTY KEY.

    DATA t_items TYPE ty_t_item.
    DATA value   TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_512 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
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
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Label`
                )->a( n = `text`     v = `Adding and removeing tokens in the MultiInput below will update the model.`
                )->a( n = `labelFor` v = `multiInput`
            " the validator creates a token from the typed text and the tokenUpdate
            " handler keeps /items in sync - both happen in ABAP here, on the same
            " one table the tokens and the List below are bound to
            )->ele( `MultiInput`
                )->a( n = `width`           v = `50%`
                )->a( n = `id`              v = `multiInput`
                )->a( n = `value`           v = client->_bind( value )
                )->a( n = `tokens`          v = client->_bind( t_items )
                )->a( n = `change`          v = client->_event( val   = `ADD_TOKEN`
                                                                t_arg = VALUE #( ( `${$parameters>/value}` ) ) )
                )->a( n = `tokenUpdate`     v = client->_event( val   = `TOKEN_UPDATE`
                                                                t_arg = VALUE #( ( `${$parameters>/type}` )
                                                                                 ( `${$parameters>/removedTokens}[0].getKey()` ) ) )
                )->a( n = `suggestionItems` v = client->_bind( t_items )
                )->a( n = `showValueHelp`   v = `false`

                )->ele( `tokens`
                    )->tag( `Token`
                        )->a( n = `key`  v = `{KEY}`
                        )->a( n = `text` v = `{TEXT}`

                )->end(

                )->ele( `suggestionItems`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `{KEY}`
                        )->a( n = `text` v = `{TEXT}`

                )->end(
            )->end(

            )->tag( `Label`
                )->a( n = `text` v = `Items in the model:`
            " _textFormatter / _keyFormatter only prefix the two values - computed in
            " ABAP and bound as plain fields (business logic belongs in the backend)
            )->ele( `List`
                )->a( n = `width` v = `50%`
                )->a( n = `items` v = client->_bind( t_items )

                )->tag( `StandardListItem`
                    )->a( n = `title` v = `{LIST_TEXT}`
                    )->a( n = `info`  v = `{LIST_INFO}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `ADD_TOKEN`.
        " the validator: the typed text becomes a token with the same key
        DATA(text) = client->get_event_arg( ).
        CLEAR value.
        IF text IS NOT INITIAL AND NOT line_exists( t_items[ key = text ] ).
          APPEND VALUE #( key       = text
                          text      = text
                          list_text = |text: { text }|
                          list_info = |key: { text }| ) TO t_items.
        ENDIF.

      WHEN `TOKEN_UPDATE`.
        " the removed branch of the original's tokenUpdate handler
        IF client->get_event_arg( ) = `removed`.
          DATA(removed_key) = client->get_event_arg( 2 ).
          DELETE t_items WHERE key = removed_key.
        ENDIF.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
