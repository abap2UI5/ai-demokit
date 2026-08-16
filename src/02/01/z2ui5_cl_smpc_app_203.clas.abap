CLASS z2ui5_cl_smpc_app_203 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_token,
             text TYPE string,
             key  TYPE string,
           END OF ty_s_token.
    DATA t_tokens  TYPE STANDARD TABLE OF ty_s_token WITH EMPTY KEY.
    DATA new_token TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_203 IMPLEMENTATION.

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

        )->ele( `Toolbar`
            " sap.m.OverflowToolbarTokenizer is @ui5-experimental-since 1.139 (no plain @since tag,
            " invisible to scope-of/property gate) - out of 1.71 scope, see the sidecar deviation
            )->ele( `OverflowToolbarTokenizer`
                )->a( n = `id`        v = `toolbarTokenizer`
                )->a( n = `width`     v = `50%`
                )->a( n = `labelText` v = `Tokenizer in sap.m.Toolbar:`
                " this is the tokenizer onAddToken/onTokenDelete work on, so its three
                " static tokens are folded into a bound aggregation (the app-085 pattern):
                " adding appends a row, deleting removes the row by its key
                )->a( n = `tokens`    v = client->_bind( t_tokens )
                )->a( n = `tokenDelete` v = client->_event( val   = `TOKEN_DELETE`
                                                            t_arg = VALUE #( ( `${$parameters>/tokens}[0].getKey()` ) ) )
                )->ele( `tokens`
                    )->tag( `Token`
                        )->a( n = `text` v = `{TEXT}`
                        )->a( n = `key`  v = `{KEY}`

                )->end(
            )->end(
            )->tag( `Text`
                )->a( n = `text`  v = `Enter a token to add:`
                )->a( n = `width` v = `150px`
            )->tag( `Input`
                )->a( n = `id`    v = `NewTokenInput`
                )->a( n = `width` v = `200px`
                )->a( n = `value` v = client->_bind( new_token )
            )->tag( `Button`
                )->a( n = `text`  v = `Add Token`
                )->a( n = `press` v = client->_event( `ADD_TOKEN` )

        )->end(
        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->ele( `Label`
                )->a( n = `text` v = `OverflowToolbar with Tokenizer`
                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `Low`

                )->end(
            )->end(
            )->ele( `OverflowToolbar`
                )->a( n = `id`    v = `otbFilter`
                )->a( n = `width` v = `auto`
                )->ele( `content`
                    )->ele( `Button`
                        )->a( n = `icon` v = `sap-icon://notes`
                        )->a( n = `text` v = `Notes`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`

                        )->end(
                    )->end(
                    )->ele( `OverflowToolbarTokenizer`
                        )->a( n = `id`        v = `overflowToolbarTokenizer`
                        )->a( n = `width`     v = `75%`
                        )->a( n = `labelText` v = `Filter by:`
                        " onTokenDelete removes the token and toasts its text. The token is
                        " static here, so the wire removes it by ID - removeAggregation accepts
                        " an id (measured, scripts/probes/event-arg-expression-probe.mjs) - and
                        " the toast is composed on the client from the same event
                        )->a( n = `tokenDelete` v = client->follow_up_action(
                                  val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `overflowToolbarTokenizer` )
                                                   ( `removeToken` )
                                                   ( `${$parameters>/tokens}[0].getId()` ) ) )
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `High`

                        )->end(
                        )->ele( `tokens`
                            )->tag( `Token`
                                )->a( n = `text` v = `Token 1`
                                )->a( n = `key`  v = `0001`
                            )->tag( `Token`
                                )->a( n = `text` v = `Token 2`
                                )->a( n = `key`  v = `0002`
                            )->tag( `Token`
                                )->a( n = `text` v = `Token 3`
                                )->a( n = `key`  v = `0003`
                            )->tag( `Token`
                                )->a( n = `text` v = `Token 4`
                                )->a( n = `key`  v = `0004`
                            )->tag( `Token`
                                )->a( n = `text` v = `Token 5`
                                )->a( n = `key`  v = `0005`
                            )->tag( `Token`
                                )->a( n = `text` v = `Token 6`
                                )->a( n = `key`  v = `0006`
                            )->tag( `Token`
                                )->a( n = `text` v = `Token 7`
                                )->a( n = `key`  v = `0007`
                            )->tag( `Token`
                                )->a( n = `text` v = `Token 8`
                                )->a( n = `key`  v = `0008`

                        )->end(
                    )->end(
                    )->tag( `ToolbarSpacer`

                )->end(
            )->end(
            )->tag( `Label`
                )->a( n = `text` v = `Tokenizer with max-width in OverflowToolbar`

            )->ele( `OverflowToolbar`
                )->a( n = `id`    v = `otbMaxWidth`
                )->a( n = `width` v = `100%`
                )->ele( `content`
                    )->ele( `Button`
                        )->a( n = `icon` v = `sap-icon://add`
                        )->a( n = `text` v = `Add custom criteria`
                        )->a( n = `type` v = `Transparent`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`

                        )->end(
                    )->end(
                    )->ele( `OverflowToolbarTokenizer`
                        )->a( n = `id`        v = `tokenizerMaxWidth`
                        )->a( n = `width`     v = `45%`
                        )->a( n = `maxWidth`  v = `85%`
                        )->a( n = `labelText` v = `Random label text:`
                        " onTokenDelete removes the token and toasts its text. The token is
                        " static here, so the wire removes it by ID - removeAggregation accepts
                        " an id (measured, scripts/probes/event-arg-expression-probe.mjs) - and
                        " the toast is composed on the client from the same event
                        )->a( n = `tokenDelete` v = client->follow_up_action(
                                  val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `tokenizerMaxWidth` )
                                                   ( `removeToken` )
                                                   ( `${$parameters>/tokens}[0].getId()` ) ) )
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `High`

                        )->end(
                        )->ele( `tokens`
                            )->tag( `Token`
                                )->a( n = `text` v = `Token 1`
                                )->a( n = `key`  v = `0001`
                            )->tag( `Token`
                                )->a( n = `text` v = `Token 2`
                                )->a( n = `key`  v = `0002`
                            )->tag( `Token`
                                )->a( n = `text` v = `Token 3`
                                )->a( n = `key`  v = `0003`
                            )->tag( `Token`
                                )->a( n = `text` v = `Token 4`
                                )->a( n = `key`  v = `0004`
                            )->tag( `Token`
                                )->a( n = `text` v = `Token 5`
                                )->a( n = `key`  v = `0005`
                            )->tag( `Token`
                                )->a( n = `text` v = `Token 1`
                                )->a( n = `key`  v = `0006`
                            )->tag( `Token`
                                )->a( n = `text` v = `Token 2`
                                )->a( n = `key`  v = `0007`
                            )->tag( `Token`
                                )->a( n = `text` v = `Token 3`
                                )->a( n = `key`  v = `0008`

                        )->end(
                    )->end(
                    )->ele( `Title`
                        )->a( n = `text`  v = `Title with Icon`
                        )->a( n = `level` v = `H1`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`

                        )->end(
                    )->end(
                    )->tag( n = `Icon` ns = `core`
                        )->a( n = `src` v = `sap-icon://collaborate`
                    )->tag( `ToolbarSpacer`

                    )->ele( `Text`
                        )->a( n = `text` v = `Just a Simple Text`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `text` v = `Accept`
                        )->a( n = `type` v = `Accept`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`

                        )->end(
                    )->end(
                )->end(
            )->end(
            )->tag( `Label`
                )->a( n = `text`  v = `Complex OverflowToolbar with input controls`
                )->a( n = `width` v = `100%`

            )->ele( `OverflowToolbar`
                )->a( n = `id`           v = `otbComplex`
                )->a( n = `width`        v = `100%`
                )->a( n = `ariaHasPopup` v = `dialog`
                )->a( n = `tooltip`      v = `This is a bar with tokenizer`
                )->ele( `content`
                    )->tag( n = `Icon` ns = `core`
                        )->a( n = `src` v = `sap-icon://collaborate`

                    )->ele( `Label`
                        )->a( n = `text` v = `Input controls`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `text` v = `Regular Button`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`

                        )->end(
                    )->end(
                    )->ele( `ToggleButton`
                        )->a( n = `text` v = `Toggle me`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`

                        )->end(
                    )->end(
                    )->ele( `Input`
                        )->a( n = `placeholder` v = `Input`
                        )->a( n = `width`       v = `200px`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`

                        )->end(
                    )->end(
                    )->ele( `DateTimePicker`
                        )->a( n = `placeholder` v = `DateTimePicker`
                        )->a( n = `width`       v = `200px`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`

                        )->end(
                    )->end(
                    )->ele( `DateRangeSelection`
                        )->a( n = `placeholder` v = `DateRangeSelection`
                        )->a( n = `width`       v = `200px`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`

                        )->end(
                    )->end(
                    )->ele( `RadioButton`
                        )->a( n = `text`      v = `Option a`
                        )->a( n = `groupName` v = `a`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`

                        )->end(
                    )->end(
                    )->ele( `RadioButton`
                        )->a( n = `text`      v = `Option b`
                        )->a( n = `groupName` v = `a`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`

                        )->end(
                    )->end(
                    )->ele( `OverflowToolbarTokenizer`
                        )->a( n = `id`        v = `tokenizerShowItems`
                        )->a( n = `width`     v = `35%`
                        )->a( n = `labelText` v = `Show items:`
                        " tokenDelete event handler dropped - it removes static tokens imperatively
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `High`

                        )->end(
                        )->ele( `tokens`
                            )->tag( `Token`
                                )->a( n = `text` v = `Token 1`
                                )->a( n = `key`  v = `0001`
                            )->tag( `Token`
                                )->a( n = `text` v = `Token 2`
                                )->a( n = `key`  v = `0002`
                            )->tag( `Token`
                                )->a( n = `text` v = `Token 3`
                                )->a( n = `key`  v = `0003`
                            )->tag( `Token`
                                )->a( n = `text` v = `Token 4 - long text example`
                                )->a( n = `key`  v = `0004`
                            )->tag( `Token`
                                )->a( n = `text` v = `Token 5`
                                )->a( n = `key`  v = `0005`

                        )->end(
                    )->end(
                    )->ele( `SegmentedButton`
                        )->ele( `items`
                            )->tag( `SegmentedButtonItem`
                                )->a( n = `text` v = `Left Button`
                            )->tag( `SegmentedButtonItem`
                                )->a( n = `icon`    v = `sap-icon://notes`
                                )->a( n = `tooltip` v = `Notes`
                            )->tag( `SegmentedButtonItem`
                                )->a( n = `text`    v = `Disabled Button`
                                )->a( n = `enabled` v = `false`
                            )->tag( `SegmentedButtonItem`
                                )->a( n = `text` v = `Right Button`

                        )->end(
                    )->end(
                    )->tag( `ToolbarSpacer`
                    )->tag( `Title`
                        )->a( n = `text`  v = `Example Title`
                        )->a( n = `level` v = `H1` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `ADD_TOKEN`.
        " onAddToken: an empty input only toasts, otherwise the token is appended
        " with text = key = the entered value and the input is cleared
        IF new_token IS INITIAL.
          client->message_toast_display( `Please enter a token text.` ).
          RETURN.
        ENDIF.
        INSERT VALUE #( text = new_token
                        key  = new_token ) INTO TABLE t_tokens.
        client->message_toast_display( |Token added: { new_token }| ).
        CLEAR new_token.

      WHEN `TOKEN_DELETE`.
        " onTokenDelete: remove the deleted token and toast its text
        DATA(deleted_key) = client->get_event_arg( ).
        DATA(deleted) = VALUE #( t_tokens[ key = deleted_key ] OPTIONAL ).
        DELETE t_tokens WHERE key = deleted_key.
        client->message_toast_display( |Token deleted: { deleted-text }| ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the three tokens the sample declares on the first tokenizer
    t_tokens = VALUE #(
      ( text = `Token 1` key = `0001` )
      ( text = `Token 2` key = `0002` )
      ( text = `Token 3` key = `0003` ) ).

  ENDMETHOD.

ENDCLASS.
