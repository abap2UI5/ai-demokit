CLASS z2ui5_cl_ai_app_085 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

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
                )->a( n = `tokenDelete` v = client->_event( `DELETE` )
                )->open( `tokens`
                    )->leaf( `Token`
                        )->a( n = `text` v = `First token`
                        )->a( n = `key`  v = `1`
                    )->leaf( `Token`
                        )->a( n = `text` v = `Second token`
                        )->a( n = `key`  v = `2`
                    )->leaf( `Token`
                        )->a( n = `text` v = `Third token`
                        )->a( n = `key`  v = `3`

                )->shut(
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
        " the original adds a Token from the input value; the tokens are static XML here, so add is shown as a toast (not appended to the static aggregation)
        DATA(text) = COND #( WHEN input_value IS NOT INITIAL THEN input_value ELSE `One more token` ).
        client->message_toast_display( |Token added: { text }| ).
        input_value = ``.
        client->view_model_update( ).
      WHEN `DELETE`.
        client->message_toast_display( `Token deleted` ).
    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    editable = abap_true.

  ENDMETHOD.

ENDCLASS.
