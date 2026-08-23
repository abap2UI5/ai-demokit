" @keywords dialog sap.m dialogwithmessagepopover button simpleform title label input columnelementdata select item toolbar
" @summary Dialog with custom footer and support for message popover.
CLASS z2ui5_cl_smpc_app_562 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_form,
        name          TYPE string,
        street_name   TYPE string,
        street_number TYPE string,
        zip_code      TYPE string,
        zip_city      TYPE string,
        country       TYPE string,
        email         TYPE string,
        phone_number  TYPE string,
        phone_time    TYPE string,
        website       TYPE string,
      END OF ty_s_form.

    TYPES:
      BEGIN OF ty_s_employment,
        jobtitle    TYPE string,
        paygrade    TYPE string,
        unit        TYPE string,
        class       TYPE string,
        fte         TYPE string,
        weeklyhours TYPE string,
      END OF ty_s_employment.

    TYPES:
      BEGIN OF ty_s_message,
        message        TYPE string,
        description    TYPE string,
        type           TYPE string,
        target         TYPE string,
        additionaltext TYPE string,
        code           TYPE string,
      END OF ty_s_message.

    DATA t_forms      TYPE STANDARD TABLE OF ty_s_form WITH EMPTY KEY.
    DATA t_employment TYPE STANDARD TABLE OF ty_s_employment WITH EMPTY KEY.
    DATA t_messages   TYPE STANDARD TABLE OF ty_s_message WITH EMPTY KEY.

    " the fragment's title is `Hello {/recipient/name}` - the shared demo kit
    " forms.json carries no `recipient` node at all, so the original renders a
    " bare `Hello `; the empty field keeps that 1:1
    DATA recipient_name TYPE string.

    " buttonIconFormatter / buttonTypeFormatter / highestSeverityMessages
    DATA btn_icon TYPE string.
    DATA btn_type TYPE string VALUE `Default`.
    DATA btn_text TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS popup_dialog_display.
    METHODS on_event.
    METHODS model_init.
    METHODS button_severity_set.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_562 IMPLEMENTATION.

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
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( `Page`
            )->a( n = `id`         v = `messageHandlingPage`
            )->a( n = `showHeader` v = `false`

            )->tag( `Button`
                )->a( n = `text`         v = `Open Dialog With Message Popover`
                )->a( n = `class`        v = `sapUiMediumMargin`
                )->a( n = `ariaHasPopup` v = `Dialog`
                )->a( n = `press`        v = client->_event( `OPEN_DIALOG` )

        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popup_dialog_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

    DATA(dialog) = popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`       v = `sap.m`
        )->a( n = `xmlns:f`     v = `sap.ui.layout.form`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`  v = `sap.ui.core`
        )->a( n = `xmlns:z2ui5` v = `z2ui5.cc`

        )->ele( `Dialog`
            )->a( n = `id`    v = `mainDialog`
            )->a( n = `title` v = |Hello { client->_bind( recipient_name ) }| ).

    DATA(content) = dialog->ele( `content` ).

    content->ele( `VBox`
        )->a( n = `id`    v = `formContainer`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->a( n = `items` v = client->_bind( t_forms )

        )->ele( n = `SimpleForm` ns = `f`
            )->a( n = `id`        v = `SimpleFormChangeColumn_twoGroups234`
            )->a( n = `editable`  v = `true`
            )->a( n = `layout`    v = `ColumnLayout`
            )->a( n = `title`     v = `Personal`
            )->a( n = `columnsM`  v = `2`
            )->a( n = `columnsL`  v = `2`
            )->a( n = `columnsXL` v = `2`

            )->ele( n = `content` ns = `f`
                )->tag( n = `Title` ns = `core`
                    )->a( n = `text` v = `Information`
                )->tag( `Label`
                    )->a( n = `text` v = `Name`
                )->tag( `Input`
                    )->a( n = `required` v = `true`
                    )->a( n = `value`    v = `{ path: 'NAME', type: 'sap.ui.model.type.String' }`
                    )->a( n = `change`   v = client->_event( `CHANGE` )
                )->tag( `Label`
                    )->a( n = `text` v = `Street/No.`
                )->tag( `Input`
                    )->a( n = `value` v = `{STREET_NAME}`
                )->ele( `Input`
                    )->a( n = `value` v = `{STREET_NUMBER}`
                    )->ele( `layoutData`
                        )->tag( n = `ColumnElementData` ns = `f`
                            )->a( n = `cellsSmall` v = `2`
                            )->a( n = `cellsLarge` v = `2`

                    )->end(
                )->end(
                )->tag( `Label`
                    )->a( n = `text` v = `ZIP Code/City`
                )->ele( `Input`
                    )->a( n = `value` v = `{ path: 'ZIP_CODE', type: 'sap.ui.model.type.Integer' }`
                    )->ele( `layoutData`
                        )->tag( n = `ColumnElementData` ns = `f`
                            )->a( n = `cellsSmall` v = `3`
                            )->a( n = `cellsLarge` v = `2`

                    )->end(
                )->end(
                )->tag( `Input`
                    )->a( n = `value` v = `{ZIP_CITY}`
                )->tag( `Label`
                    )->a( n = `text` v = `Country`
                )->ele( `Select`
                    )->a( n = `id`          v = `country`
                    )->a( n = `selectedKey` v = `{COUNTRY}`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `England`
                        )->a( n = `text` v = `England`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `Germany`
                        )->a( n = `text` v = `Germany`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `USA`
                        )->a( n = `text` v = `USA`

                )->end(
                )->tag( n = `Title` ns = `core`
                    )->a( n = `text` v = `Contact`
                )->tag( `Label`
                    )->a( n = `text` v = `Email`
                )->tag( `Input`
                    )->a( n = `value` v = `{ path: 'EMAIL', type: 'sap.ui.model.type.String', constraints: { search: '^\\w+[\\w-+\\.]*\\@[a-zA-Z]+.[a-zA-Z]+' } }`
                )->tag( `Label`
                    )->a( n = `text` v = `Phone Number`
                )->tag( `Input`
                    )->a( n = `value` v = `{PHONE_NUMBER}`
                )->ele( `Input`
                    )->a( n = `value` v = `{PHONE_TIME}`
                    )->ele( `layoutData`
                        )->tag( n = `ColumnElementData` ns = `f`
                            )->a( n = `cellsSmall` v = `2`
                            )->a( n = `cellsLarge` v = `2`

                    )->end(
                )->end(
                )->tag( `Label`
                    )->a( n = `text` v = `Personal website`
                )->tag( `Input`
                    )->a( n = `value` v = `{WEBSITE}`

            )->end(
        )->end(
    )->end( ).

    content->ele( `VBox`
        )->a( n = `id`    v = `formContainerEmployment`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->a( n = `items` v = client->_bind( t_employment )

        )->ele( n = `SimpleForm` ns = `f`
            )->a( n = `editable`  v = `true`
            )->a( n = `layout`    v = `ColumnLayout`
            )->a( n = `title`     v = `Personal`
            )->a( n = `columnsM`  v = `2`
            )->a( n = `columnsL`  v = `2`
            )->a( n = `columnsXL` v = `2`

            )->ele( n = `content` ns = `f`
                )->tag( n = `Title` ns = `core`
                    )->a( n = `text` v = `Information`
                )->tag( `Label`
                    )->a( n = `text` v = `Job Classification`
                )->tag( `Input`
                    )->a( n = `value` v = `{JOBTITLE}`
                )->tag( `Label`
                    )->a( n = `text` v = `Pay Grade`
                )->tag( `Input`
                    )->a( n = `value` v = `{PAYGRADE}`
                )->tag( `Label`
                    )->a( n = `text` v = `Unit`
                )->tag( `Input`
                    )->a( n = `value` v = `{UNIT}`
                )->tag( n = `Title` ns = `core`
                    )->a( n = `text` v = `Rating`
                )->tag( `Label`
                    )->a( n = `text` v = `Employee Class`
                )->tag( `Input`
                    )->a( n = `value` v = `{CLASS}`
                )->tag( `Label`
                    )->a( n = `text` v = `FTE`
                )->tag( `Input`
                    )->a( n = `value` v = `{FTE}`
                )->tag( `Label`
                    )->a( n = `text` v = `Standard Weekly Hours`
                )->tag( `Input`
                    )->a( n = `value`  v = `{ path: 'WEEKLYHOURS', type: 'sap.ui.model.type.Integer', constraints: { maximum: 40 } }`
                    )->a( n = `change` v = client->_event( `CHANGE` )

            )->end(
        )->end(
    )->end( ).

    " abap2UI5 feeds app-authored messages into the message manager through this
    " companion control (app 065 idiom) - the original calls Messaging.addMessages
    content->tag( n = `MessageManager` ns = `z2ui5`
        )->a( n = `items` v = client->_bind( t_messages ) ).

    dialog->ele( `footer`
        )->ele( `Toolbar`
            )->ele( `content`

                )->ele( `Button`
                    )->a( n = `id`           v = `messagePopoverBtn`
                    )->a( n = `visible`      v = |\{= !!$\{message>/\}.length \}|
                    )->a( n = `icon`         v = client->_bind( btn_icon )
                    )->a( n = `type`         v = client->_bind( btn_type )
                    )->a( n = `text`         v = client->_bind( btn_text )
                    )->a( n = `ariaHasPopup` v = `Dialog`
                    " handleMessagePopoverPress: this.oMP.toggle(oEvent.getSource()) - a pure
                    " client-side toggle, so wired roundtrip-free onto the button's own id
                    )->a( n = `press`        v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                           t_arg = VALUE #( ( `messagePopover` ) ( `toggleBy` ) ( `messagePopoverBtn` ) ) )

                    )->ele( `dependents`
                        )->ele( `MessagePopover`
                            )->a( n = `id`         v = `messagePopover`
                            )->a( n = `items`      v = `{message>/}`
                            )->a( n = `groupItems` v = `true`
                            " activeTitlePress ships the pressed message's target control id so
                            " the handler can scroll to it and focus it
                            )->a( n = `activeTitlePress` v = client->_event(
                                     val   = `ACTIVE_TITLE`
                                     t_arg = VALUE #( ( `${$parameters>/item}.getBindingContext('message').getObject().getControlIds()[0]` ) ) )

                            )->tag( `MessageItem`
                                )->a( n = `title`       v = `{message>message}`
                                )->a( n = `subtitle`    v = `{message>additionalText}`
                                )->a( n = `type`        v = `{message>type}`
                                )->a( n = `description` v = `{message>message}`
                                )->a( n = `activeTitle` v = `true`
                                " getGroupName reads the form titles around the target control -
                                " a domain classification, so it is computed in the backend and
                                " rides on the Message code field (see model below)
                                )->a( n = `groupName`   v = `{message>code}`

                        )->end(
                    )->end(
                )->end(

                )->tag( `ToolbarSpacer`
                )->tag( `Button`
                    )->a( n = `type`  v = `Accept`
                    )->a( n = `text`  v = `Save`
                    )->a( n = `press` v = client->_event( `SAVE` )
                )->tag( `Button`
                    )->a( n = `id`           v = `Reject`
                    )->a( n = `text`         v = `Reject`
                    )->a( n = `type`         v = `Reject`
                    )->a( n = `ariaHasPopup` v = `Dialog`
                    )->a( n = `press`        v = client->_event( `CLOSE_DIALOG` )

            )->end(
        )->end(
    )->end( ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `OPEN_DIALOG`.
        popup_dialog_display( ).
        client->message_toast_display( `Press "Save" to trigger validation.` ).

      WHEN `CLOSE_DIALOG`.
        client->popup_destroy( ).

      WHEN `ACTIVE_TITLE`.
        " activeTitlePress scrolls to the message's target control, closes the popover
        " and focuses the control; the full control id travels from the pressed
        " MessageItem's message object (getControlIds()[0])
        DATA(control_id) = client->get_event_arg( ).
        IF control_id IS NOT INITIAL.
          client->follow_up_action( val   = client->cs_event-scroll_into_view
                                    t_arg = VALUE #( ( control_id ) ) ).
          client->follow_up_action( val   = client->cs_event-control_by_id
                                    t_arg = VALUE #( ( `messagePopover` ) ( `close` ) ) ).
          client->follow_up_action( val   = client->cs_event-set_focus
                                    t_arg = VALUE #( ( control_id ) ) ).
        ENDIF.

      WHEN `SAVE`.
        " _generateInvalidUserInput(): force a set of fields invalid to demo the
        " message handling, then open the MessagePopover. abap2UI5 only auto-collects
        " validation messages from USER input, not from programmatically-set model
        " values, so Save mirrors the issues explicitly on the SAME rows the original
        " reaches through formContainer.getItems()[4/5/6] - John Miller / Stefan Bosch
        " / Maria Fontes - plus the employment row, and authors the matching messages
        IF lines( t_forms ) >= 7.
          t_forms[ 5 ]-name     = ``.
          t_forms[ 6 ]-zip_code = `AAA`.
          t_forms[ 7 ]-email    = `MariaFontes.com`.
        ENDIF.
        IF t_employment IS NOT INITIAL.
          t_employment[ 1 ]-weeklyhours = `400`.
        ENDIF.
        " the group name is `<form title>, <group title>`: the Personal form's
        " Information and Contact groups, and the employment form's Rating group
        " (Standard Weekly Hours sits there in this sample)
        t_messages = VALUE #(
          ( message = `A mandatory field is required` type = `Error` additionaltext = `Name`
            target = `/T_FORMS/4/NAME` code = `Personal, Information` )
          ( message = `Enter a number without decimals.` type = `Error` additionaltext = `ZIP Code/City`
            target = `/T_FORMS/5/ZIP_CODE` code = `Personal, Information` )
          ( message = `Enter a valid email address.` type = `Error` additionaltext = `Email`
            target = `/T_FORMS/6/EMAIL` code = `Personal, Contact` )
          ( message = `The value should not exceed 40` type = `Warning` additionaltext = `Standard Weekly Hours`
            description = `The value of the working hours field should not exceed 40 hours.`
            target = `/T_EMPLOYMENT/0/WEEKLYHOURS` code = `Personal, Rating` ) ).
        button_severity_set( ).
        " the binding-change handler navigates the popover back and refreshes the
        " button, then oMP.openBy(oButton) opens it anchored to the button
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `messagePopover` ) ( `openBy` ) ( `messagePopoverBtn` ) ) ).

      WHEN `CHANGE`.
        " onChange manually adds/removes the required-field and constraint messages;
        " here the typed bindings with constraints collect those AUTOMATICALLY into
        " the message> model (no app code), so the handler only pushes the model back

    ENDCASE.

  ENDMETHOD.


  METHOD button_severity_set.

    " buttonTypeFormatter / buttonIconFormatter: Error > Warning > Success > Info
    CLEAR btn_icon.
    CLEAR btn_type.

    LOOP AT t_messages INTO DATA(msg).
      CASE msg-type.
        WHEN `Error`.
          btn_type = `Negative`.
          btn_icon = `sap-icon://error`.
        WHEN `Warning`.
          IF btn_type <> `Negative`.
            btn_type = `Critical`.
          ENDIF.
          IF btn_icon <> `sap-icon://error`.
            btn_icon = `sap-icon://alert`.
          ENDIF.
        WHEN `Success`.
          IF btn_type <> `Negative` AND btn_type <> `Critical`.
            btn_type = `Success`.
          ENDIF.
          IF btn_icon <> `sap-icon://error` AND btn_icon <> `sap-icon://alert`.
            btn_icon = `sap-icon://sys-enter-2`.
          ENDIF.
        WHEN OTHERS.
          IF btn_type IS INITIAL.
            btn_type = `Neutral`.
          ENDIF.
          IF btn_icon IS INITIAL.
            btn_icon = `sap-icon://information`.
          ENDIF.
      ENDCASE.
    ENDLOOP.

    " highestSeverityMessages: how many messages carry the highest severity found
    DATA(highest) = SWITCH string( btn_type
                                   WHEN `Negative` THEN `Error`
                                   WHEN `Critical` THEN `Warning`
                                   WHEN `Success`  THEN `Success`
                                   ELSE `Information` ).
    DATA(count) = REDUCE i( INIT n = 0
                            FOR m IN t_messages
                            NEXT n = COND #( WHEN m-type = highest THEN n + 1 ELSE n ) ).
    btn_text = COND #( WHEN count = 0 THEN `` ELSE |{ count }| ).

    " the formatter returns undefined while no message carries a severity; an empty
    " string would override the enum DEFAULT and reject the whole view
    IF btn_type IS INITIAL.
      btn_type = `Default`.
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " the shared demo kit forms.json - all 8 forms and the single employment row
    t_forms = VALUE #(
      ( name = `Julie Armstrong` street_name = `Mainstreet` street_number = `1278`
        zip_code = `12345` zip_city = `Maintown` country = `Germany`
        email = `Julie.Armstrong@company.com` phone_number = `+1 (610) 661-1000` phone_time = `12:00` website = `n/a` )
      ( name = `Denise Smith` street_name = `Mainstreet` street_number = `1567`
        zip_code = `12345` zip_city = `Maintown` country = `Germany`
        email = `Denise.Smith@company.com` phone_number = `+1 (610) 661-1000` phone_time = `12:00` website = `n/a` )
      ( name = `Richard Wilson` street_name = `Mainstreet` street_number = `2984`
        zip_code = `12345` zip_city = `Maintown` country = `Germany`
        email = `Richard.Wilson@company.com` phone_number = `+1 (610) 661-1000` phone_time = `12:00` website = `n/a` )
      ( name = `Gerd Becker` street_name = `Mainstreet` street_number = `3614`
        zip_code = `12345` zip_city = `Maintown` country = `Germany`
        email = `Gerd.Becker@company.com` phone_number = `+1 (610) 661-1000` phone_time = `12:00` website = `n/a` )
      ( name = `John Miller` street_name = `Mainstreet` street_number = `1618`
        zip_code = `AAA` zip_city = `Maintown` country = `Germany`
        email = `John.Miller@company.com` phone_number = `+1 (610) 661-1000` phone_time = `12:00` website = `n/a` )
      ( name = `Stefan Bosch` street_name = `Mainstreet` street_number = `4864`
        zip_code = `12345` zip_city = `Maintown` country = `Germany`
        email = `Stefan.Bosch@company.com` phone_number = `+1 (610) 661-1000` phone_time = `12:00` website = `n/a` )
      ( name = `Maria Fontes` street_name = `Mainstreet` street_number = `4864`
        zip_code = `12345` zip_city = `Maintown` country = `Germany`
        email = `` phone_number = `+1 (610) 661-1000` phone_time = `12:00` website = `MariaFontescompany.com` )
      ( name = `Antonio Ferrari` street_name = `Mainstreet` street_number = `2598`
        zip_code = `12345` zip_city = `Maintown` country = `Germany`
        email = `Antonio.Ferrari@company.com` phone_number = `+1 (610) 661-1000` phone_time = `12:00` website = `n/a` ) ).

    t_employment = VALUE #(
      ( jobtitle = `Senior UI Developer (UIDEV-SR)` paygrade = `Salary Grade 18 (GR-14`
        unit = `ABC` class = `Employee` fte = `1` weeklyhours = `0` ) ).

  ENDMETHOD.

ENDCLASS.
