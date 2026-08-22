" @keywords input sap.m inputchecked validation valuestate valuestatetext constraints simpletype messagebox verticallayout
CLASS z2ui5_cl_smpc_app_622 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA name        TYPE string.
    DATA email       TYPE string.
    DATA name_state  TYPE string.
    DATA email_state TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS name_validate RETURNING VALUE(result) TYPE abap_bool.
    METHODS email_validate RETURNING VALUE(result) TYPE abap_bool.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_622 IMPLEMENTATION.

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
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Label`
                )->a( n = `text`     v = `Name`
                )->a( n = `labelFor` v = `nameInput`

            " the sample's binding carries a sap.ui.model.type.String with
            " minLength / maxLength constraints, which UI5 checks in the BROWSER;
            " it is kept, and the backend checks the same bounds on submit
            )->tag( `Input`
                )->a( n = `id`             v = `nameInput`
                )->a( n = `class`          v = `sapUiSmallMarginBottom`
                )->a( n = `placeholder`    v = `Enter name`
                )->a( n = `valueStateText` v = `Name must not be empty. Maximum 10 characters.`
                )->a( n = `valueState`     v = client->_bind( name_state )
                )->a( n = `value`          v = |\{ path: '{ client->_bind( val = name path = abap_true ) }', type: 'sap.ui.model.type.String', constraints: \{ minLength: 1, maxLength: 10 \} \}|
                )->a( n = `change`         v = client->_event( `NAME_CHANGE` )

            )->tag( `Label`
                )->a( n = `text`     v = `E-mail`
                )->a( n = `labelFor` v = `emailInput`

            )->tag( `Input`
                )->a( n = `id`             v = `emailInput`
                )->a( n = `class`          v = `sapUiSmallMarginBottom`
                )->a( n = `type`           v = `Email`
                )->a( n = `placeholder`    v = `Enter email`
                )->a( n = `valueStateText` v = `E-mail must be a valid email address.`
                )->a( n = `valueState`     v = client->_bind( email_state )
                )->a( n = `value`          v = client->_bind( email )

            )->tag( `Button`
                )->a( n = `text`  v = `Submit`
                )->a( n = `press` v = client->_event( `SUBMIT` )
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `NAME_CHANGE`.
        " onNameChange validates just that one input
        name_validate( ).

      WHEN `SUBMIT`.
        " onSubmit validates BOTH, then toasts or raises the alert
        DATA(name_bad)  = name_validate( ).
        DATA(email_bad) = email_validate( ).
        IF name_bad = abap_false AND email_bad = abap_false.
          client->message_toast_display( `The input is validated. Your form has been submitted.` ).
        ELSE.
          client->message_box_display( text = `A validation error has occurred. Complete your input first.`
                                       type = `information` ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD name_validate.

    " the binding's own constraints: at least one character, at most ten
    result = xsdbool( strlen( name ) < 1 OR strlen( name ) > 10 ).
    name_state = COND #( WHEN result = abap_true THEN `Error` ELSE `None` ).

  ENDMETHOD.


  METHOD email_validate.

    " customEMailType's regex is /^\w+[\w-+\.]*\@\w+([-\.]\w+)*\.[a-zA-Z]{2,}$/;
    " the same shape without a regex engine: one @ with something before it, and
    " a dot with at least two more characters after it (see sidecar)
    result = abap_true.
    DATA(at) = find( val = email sub = `@` ).
    IF at > 0 AND find( val = email sub = `@` occ = 2 ) < 0.
      DATA(domain) = substring( val = email off = at + 1 ).
      DATA(dot)    = find( val = domain sub = `.` occ = -1 ).
      IF dot > 0 AND strlen( domain ) - dot > 2 AND find( val = email sub = ` ` ) < 0.
        result = abap_false.
      ENDIF.
    ENDIF.

    email_state = COND #( WHEN result = abap_true THEN `Error` ELSE `None` ).

  ENDMETHOD.


  METHOD model_init.

    " onInit seeds an empty name and email; neither input starts in error
    name        = ``.
    email       = ``.
    name_state  = `None`.
    email_state = `None`.

  ENDMETHOD.

ENDCLASS.
