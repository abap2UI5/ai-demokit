" @keywords overflowtoolbartokenizer overflow toolbar tokenizer sap.m token text input button verticallayout label overflowtoolbarlayoutdata
" @summary Tokenizer integration with sap.m.OverflowToolbar
CLASS z2ui5_cl_smpc_app_203 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_token,
             text TYPE string,
             key  TYPE string,
           END OF ty_s_token.
    DATA t_tokens  TYPE STANDARD TABLE OF ty_s_token WITH DEFAULT KEY.
    DATA new_token TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    TYPES: BEGIN OF ty_s_event_token,
             text TYPE string,
             key  TYPE string,
           END OF ty_s_event_token.
    TYPES ty_t_event_token TYPE STANDARD TABLE OF ty_s_event_token WITH DEFAULT KEY.

    METHODS event_tokens
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE ty_t_event_token.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_203 IMPLEMENTATION.

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
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    DATA temp5 TYPE string_table.
    DATA temp6 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `Token deleted: {0}` INTO TABLE temp1.
    INSERT `${$parameters>/tokens}[0].getText()` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `overflowToolbarTokenizer` INTO TABLE temp2.
    INSERT `removeToken` INTO TABLE temp2.
    INSERT `${$parameters>/tokens}[0].getId()` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `Token deleted: {0}` INTO TABLE temp3.
    INSERT `${$parameters>/tokens}[0].getText()` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `tokenizerMaxWidth` INTO TABLE temp4.
    INSERT `removeToken` INTO TABLE temp4.
    INSERT `${$parameters>/tokens}[0].getId()` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `MESSAGE_TOAST` INTO TABLE temp5.
    INSERT `show` INTO TABLE temp5.
    INSERT `Token deleted: {0}` INTO TABLE temp5.
    INSERT `${$parameters>/tokens}[0].getText()` INTO TABLE temp5.
    
    CLEAR temp6.
    INSERT `tokenizerShowItems` INTO TABLE temp6.
    INSERT `removeToken` INTO TABLE temp6.
    INSERT `${$parameters>/tokens}[0].getId()` INTO TABLE temp6.
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
                " onTokenDelete iterates ALL deleted tokens - the event carries the
                " whole selection, not one token - so the ARRAY travels and ABAP
                " loops. The frontend marshals each control into its properties
                " (Lib.normalizeEventArgs), the same route app 103 uses
                )->a( n = `tokenDelete` v = client->_event( val = `TOKEN_DELETE` arg = `${$parameters>/tokens}` )
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
                                  val   = client->cs_event-control_global
                                  t_arg = temp1 ) && `; ` &&
                                              client->follow_up_action(
                                  val   = client->cs_event-control_by_id
                                  t_arg = temp2 )
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
                                  val   = client->cs_event-control_global
                                  t_arg = temp3 ) && `; ` &&
                                              client->follow_up_action(
                                  val   = client->cs_event-control_by_id
                                  t_arg = temp4 )
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
                        )->a( n = `tokenDelete` v = client->follow_up_action(
                                  val   = client->cs_event-control_global
                                  t_arg = temp5 ) && `; ` &&
                                              client->follow_up_action(
                                  val   = client->cs_event-control_by_id
                                  t_arg = temp6 )
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
        DATA temp3 TYPE z2ui5_cl_smpc_app_203=>ty_s_token.
        DATA temp4 TYPE z2ui5_cl_smpc_app_203=>ty_t_event_token.
        DATA temp5 LIKE LINE OF temp4.
        DATA lr_del LIKE REF TO temp5.

    CASE client->get_event( ).

      WHEN `ADD_TOKEN`.
        " onAddToken: an empty input only toasts, otherwise the token is appended
        " with text = key = the entered value and the input is cleared
        IF new_token IS INITIAL.
          client->message_toast_display( `Please enter a token text.` ).
          RETURN.
        ENDIF.
        
        CLEAR temp3.
        temp3-text = new_token.
        temp3-key = new_token.
        INSERT temp3 INTO TABLE t_tokens.
        client->message_toast_display( |Token added: { new_token }| ).
        CLEAR new_token.

      WHEN `TOKEN_DELETE`.
        " onTokenDelete: aDeletedTokens.forEach - toast each token's text and
        " remove it. Selecting several tokens and pressing Delete really does
        " deliver several: Tokenizer fires with getSelectedTokens( ) when there
        " is a selection, and with the focused token otherwise
        
        temp4 = event_tokens( client->get_event_arg( ) ).
        
        
        LOOP AT temp4 REFERENCE INTO lr_del.
          client->message_toast_display( |Token deleted: { lr_del->text }| ).
          DELETE t_tokens WHERE key = lr_del->key.
        ENDLOOP.

    ENDCASE.

  ENDMETHOD.


  METHOD event_tokens.

    DATA lv_json TYPE string.
    lv_json = condense( val ).
    IF lv_json IS INITIAL.
      RETURN.
    ENDIF.

    IF lv_json(1) <> `[`.
      lv_json = |[{ lv_json }]|.
    ENDIF.

    TRY.
        " the frontend marshals a control with ALL its public properties, so
        " only the two fields this port models are mapped - a plain to_abap( )
        " fails on the first extra one
        "
        " z2ui5_cl_ajson is the framework's VENDORED ajson copy and lives
        " outside the released API (src/02); there is no released JSON reader
        " to use instead, the same reasoning as apps 103/298
        " abap2ui5lint-disable-next-line non-released-api -- no released JSON reader exists; see the comment above and the sidecar deviation
        z2ui5_cl_ajson=>parse( lv_json
          )->to_abap_corresponding_only(
          )->to_abap( IMPORTING ev_container = result ).
        " abap2ui5lint-disable-next-line non-released-api -- the exception of the call above
      CATCH z2ui5_cx_ajson_error.
        CLEAR result.
    ENDTRY.

  ENDMETHOD.


  METHOD model_init.

    " the three tokens the sample declares on the first tokenizer
    DATA temp5 LIKE t_tokens.
    DATA temp6 LIKE LINE OF temp5.
    CLEAR temp5.
    
    temp6-text = `Token 1`.
    temp6-key = `0001`.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Token 2`.
    temp6-key = `0002`.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Token 3`.
    temp6-key = `0003`.
    INSERT temp6 INTO TABLE temp5.
    t_tokens = temp5.

  ENDMETHOD.

ENDCLASS.
