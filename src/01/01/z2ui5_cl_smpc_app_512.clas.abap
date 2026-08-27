" @keywords multiinput multi input sap.m multiinputmodelupdate verticallayout label item multiinputext list standardlistitem
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

    " the tokens z2ui5.cc.MultiInputExt mirrors out of the tokenUpdate event -
    " the whole added / removed list, not just its first entry
    TYPES: BEGIN OF ty_s_token,
             key  TYPE string,
             text TYPE string,
           END OF ty_s_token.
    TYPES ty_t_token TYPE STANDARD TABLE OF ty_s_token WITH EMPTY KEY.

    DATA t_items   TYPE ty_t_item.
    DATA t_added   TYPE ty_t_token.
    DATA t_removed TYPE ty_t_token.

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
        )->a( n = `height`      v = `100%`
        )->a( n = `xmlns:l`     v = `sap.ui.layout`
        )->a( n = `xmlns:core`  v = `sap.ui.core`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:z2ui5` v = `z2ui5.cc`
        )->a( n = `xmlns`       v = `sap.m`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Label`
                )->a( n = `text`     v = `Adding and removeing tokens in the MultiInput below will update the model.`
                )->a( n = `labelFor` v = `multiInput`
            )->ele( `MultiInput`
                )->a( n = `width`           v = `50%`
                )->a( n = `id`              v = `multiInput`
                )->a( n = `suggestionItems` v = client->_bind( t_items )
                )->a( n = `showValueHelp`   v = `false`

                )->ele( `suggestionItems`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `{KEY}`
                        )->a( n = `text` v = `{TEXT}`

                )->end(
            )->end(

            " onInit's addValidator( text -> new Token({key: text, text: text}) )
            " and its attachTokenUpdate handler: the bundled companion control
            " installs exactly that validator and mirrors the whole added /
            " removed token list back, so the backend keeps /items in sync
            )->tag( n = `MultiInputExt` ns = `z2ui5`
                )->a( n = `MultiInputId`  v = `multiInput`
                )->a( n = `addedTokens`   v = client->_bind( t_added )
                )->a( n = `removedTokens` v = client->_bind( t_removed )
                )->a( n = `change`        v = client->_event( `TOKEN_UPDATE` )

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

    IF client->get_event( ) = `TOKEN_UPDATE`.
      " the two branches of the original's tokenUpdate handler, over the FULL
      " token lists the companion control mirrors out of the event
      LOOP AT t_removed INTO DATA(removed).
        DELETE t_items WHERE key = removed-key.
      ENDLOOP.

      LOOP AT t_added INTO DATA(added).
        IF NOT line_exists( t_items[ key = added-key ] ).
          " _textFormatter / _keyFormatter, computed in the backend
          APPEND VALUE #( key       = added-key
                          text      = added-text
                          list_text = |text: { added-text }|
                          list_info = |key: { added-key }| ) TO t_items.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
