CLASS z2ui5_cl_ai_app_065 DEFINITION PUBLIC.

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
        weeklyhours TYPE string,
        unit        TYPE string,
        class       TYPE string,
        fte         TYPE string,
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

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_065 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
      " original onInit: MessageToast.show('Press "Save" to trigger validation.')
      client->message_toast_display( `Press "Save" to trigger validation.` ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`      v = `100%`
        )->a( n = `xmlns`       v = `sap.m`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`  v = `sap.ui.core`
        )->a( n = `xmlns:f`     v = `sap.ui.layout.form`
        )->a( n = `xmlns:z2ui5` v = `z2ui5.cc`

        )->open( `Page`
            )->a( n = `id`         v = `messageHandlingPage`
            )->a( n = `showHeader` v = `false`

            )->open( `content`

                )->open( `VBox`
                    )->a( n = `id`    v = `formContainer`
                    )->a( n = `class` v = `sapUiSmallMargin`
                    )->a( n = `items` v = client->_bind( t_forms )

                    )->open( n = `SimpleForm` ns = `f`
                        )->a( n = `editable` v = `true`
                        )->a( n = `layout`   v = `ColumnLayout`
                        )->a( n = `title`    v = `Personal`
                        )->a( n = `columnsM` v = `2`
                        )->a( n = `columnsL` v = `2`
                        )->a( n = `columnsXL` v = `2`

                        )->open( n = `content` ns = `f`
                            )->leaf( n = `Title` ns = `core`
                                )->a( n = `text` v = `Information`
                            )->leaf( `Label`
                                )->a( n = `text` v = `Name`
                            )->leaf( `Input`
                                )->a( n = `required` v = `true`
                                )->a( n = `value`    v = `{ path: 'NAME', type: 'sap.ui.model.type.String' }`
                                )->a( n = `change`   v = client->_event( `CHANGE` )
                            )->leaf( `Label`
                                )->a( n = `text` v = `Street/No.`
                            )->leaf( `Input`
                                )->a( n = `value` v = `{STREET_NAME}`
                            )->leaf( `Input`
                                )->a( n = `value` v = `{STREET_NUMBER}`
                            )->leaf( `Label`
                                )->a( n = `text` v = `ZIP Code/City`
                            )->leaf( `Input`
                                )->a( n = `value` v = `{ path: 'ZIP_CODE', type: 'sap.ui.model.type.Integer' }`
                            )->leaf( `Input`
                                )->a( n = `value` v = `{ZIP_CITY}`
                            )->leaf( `Label`
                                )->a( n = `text` v = `Country`
                            )->open( `Select`
                                )->a( n = `selectedKey` v = `{COUNTRY}`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `key`  v = `England`
                                    )->a( n = `text` v = `England`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `key`  v = `Germany`
                                    )->a( n = `text` v = `Germany`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `key`  v = `USA`
                                    )->a( n = `text` v = `USA`

                            )->shut(
                            )->leaf( n = `Title` ns = `core`
                                )->a( n = `text` v = `Contact`
                            )->leaf( `Label`
                                )->a( n = `text` v = `Email`
                            )->leaf( `Input`
                                )->a( n = `value` v = `{ path: 'EMAIL', type: 'sap.ui.model.type.String', constraints: { search: '^\\w+[\\w-+\\.]*\\@[a-zA-Z]+.[a-zA-Z]+' } }`
                            )->leaf( `Label`
                                )->a( n = `text` v = `Phone Number`
                            )->leaf( `Input`
                                )->a( n = `value` v = `{PHONE_NUMBER}`
                            )->leaf( `Input`
                                )->a( n = `value` v = `{PHONE_TIME}`
                            )->leaf( `Label`
                                )->a( n = `text` v = `Personal website`
                            )->leaf( `Input`
                                )->a( n = `value` v = `{WEBSITE}`

                        )->shut(
                    )->shut(
                )->shut(

                )->open( `VBox`
                    )->a( n = `id`    v = `formContainerEmployment`
                    )->a( n = `class` v = `sapUiSmallMargin`
                    )->a( n = `items` v = client->_bind( t_employment )

                    )->open( n = `SimpleForm` ns = `f`
                        )->a( n = `editable` v = `true`
                        )->a( n = `layout`   v = `ColumnLayout`
                        )->a( n = `title`    v = `Personal`
                        )->a( n = `columnsM` v = `2`
                        )->a( n = `columnsL` v = `2`
                        )->a( n = `columnsXL` v = `2`

                        )->open( n = `content` ns = `f`
                            )->leaf( n = `Title` ns = `core`
                                )->a( n = `text` v = `Information`
                            )->leaf( `Label`
                                )->a( n = `text` v = `Job Classification`
                            )->leaf( `Input`
                                )->a( n = `value` v = `{JOBTITLE}`
                            )->leaf( `Label`
                                )->a( n = `text` v = `Pay Grade`
                            )->leaf( `Input`
                                )->a( n = `value` v = `{PAYGRADE}`
                            )->leaf( `Label`
                                )->a( n = `text` v = `Standard Weekly Hours`
                            )->leaf( `Input`
                                )->a( n = `value`  v = `{ path: 'WEEKLYHOURS', type: 'sap.ui.model.type.Integer', constraints: { maximum: 40 } }`
                                )->a( n = `change` v = client->_event( `CHANGE` )
                            )->leaf( n = `Title` ns = `core`
                                )->a( n = `text` v = `Rating`
                            )->leaf( `Label`
                                )->a( n = `text` v = `Unit`
                            )->leaf( `Input`
                                )->a( n = `value` v = `{UNIT}`
                            )->leaf( `Label`
                                )->a( n = `text` v = `Employee Class`
                            )->leaf( `Input`
                                )->a( n = `value` v = `{CLASS}`
                            )->leaf( `Label`
                                )->a( n = `text` v = `FTE`
                            )->leaf( `Input`
                                )->a( n = `value` v = `{FTE}`

                        )->shut(
                    )->shut(
                )->shut(

                )->leaf( n = `MessageManager` ns = `z2ui5`
                    )->a( n = `items` v = client->_bind( t_messages )

            )->shut(

            )->open( `footer`
                )->open( `OverflowToolbar`

                    )->open( `Button`
                        )->a( n = `id`           v = `messagePopoverBtn`
                        )->a( n = `visible`      v = |\{= !!$\{message>/\}.length \}|
                        )->a( n = `text`         v = |\{= $\{message>/\}.length \}|
                        )->a( n = `type`         v = `Emphasized`
                        )->a( n = `ariaHasPopup` v = `Dialog`
                        " original: this.oMP.toggle(oEvent.getSource()) - a pure client-side toggle, so
                        " wired roundtrip-free (no on_event) anchored to the button by its own id
                        )->a( n = `press`        v = client->_event_client( val   = client->cs_event-control_by_id
                                                                            t_arg = VALUE #( ( `messagePopover` ) ( `toggleBy` ) ( `messagePopoverBtn` ) ) )

                        )->open( `dependents`
                            )->open( `MessagePopover`
                                )->a( n = `id`              v = `messagePopover`
                                )->a( n = `items`           v = `{message>/}`
                                )->a( n = `groupItems`      v = `true`
                                " activeTitlePress is a MessagePopover event (not MessageItem); it ships the
                                " pressed message's target control id so the handler can scroll+focus it
                                )->a( n = `activeTitlePress` v = client->_event(
                                         val   = `ACTIVE_TITLE`
                                         t_arg = VALUE #( ( `${$parameters>/item}.getBindingContext('message').getObject().getControlIds()[0]` ) ) )
                                )->leaf( `MessageItem`
                                    )->a( n = `title`       v = `{message>message}`
                                    )->a( n = `subtitle`    v = `{message>additionalText}`
                                    )->a( n = `type`        v = `{message>type}`
                                    )->a( n = `description` v = `{message>message}`
                                    )->a( n = `activeTitle` v = `true`
                                    " group name (Personal, <section>): a domain classification computed in
                                    " the backend (see model above) and carried on the Message code field,
                                    " NOT a frontend expression - the original derives it in its controller's
                                    " getGroupName; only Email sits in the Contact group, the rest in Information
                                    )->a( n = `groupName`   v = `{message>code}`

                            )->shut(
                        )->shut(
                    )->shut(

                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Button`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `text`  v = `Save`
                        )->a( n = `press` v = client->_event( `SAVE` )
                    )->leaf( `Button`
                        )->a( n = `text` v = `Cancel`

                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `ACTIVE_TITLE`.
        " original: activeTitlePress scrolls to the message's target control, closes the popover
        " and focuses the control; the full control id travels from the pressed MessageItem's
        " message object (getControlIds()[0]) and the frontend SCROLL_INTO_VIEW + SET_FOCUS act on it
        DATA(lv_control_id) = client->get_event_arg( ).
        IF lv_control_id IS NOT INITIAL.
          client->follow_up_action( val   = client->cs_event-scroll_into_view
                                    t_arg = VALUE #( ( lv_control_id ) ) ).
          client->follow_up_action( val   = client->cs_event-control_by_id
                                    t_arg = VALUE #( ( `messagePopover` ) ( `close` ) ) ).
          client->follow_up_action( val   = client->cs_event-set_focus
                                    t_arg = VALUE #( ( lv_control_id ) ) ).
        ENDIF.

      WHEN `SAVE`.
        " original generateInvalidUserInput(): force a set of fields invalid to demo the message
        " handling, then open the MessagePopover. abap2UI5 only auto-collects validation messages
        " from USER input, not from programmatically-set model values, so Save mirrors the four
        " issues explicitly on the SAME rows the original targets - formContainer.getItems()[4/5/6]
        " = John Miller / Stefan Bosch / Maria Fontes, plus the employment row: it injects the
        " invalid values and authors the matching four messages (3 Errors + 1 Warning), which the
        " z2ui5.cc.MessageManager reconciles into the message manager.
        IF lines( t_forms ) >= 7.
          t_forms[ 5 ]-name     = ``.                 " John Miller  -> /T_FORMS/4/NAME
          t_forms[ 6 ]-zip_code = `AAA`.              " Stefan Bosch -> /T_FORMS/5/ZIP_CODE
          t_forms[ 7 ]-email    = `MariaFontes.com`.  " Maria Fontes -> /T_FORMS/6/EMAIL
        ENDIF.
        IF t_employment IS NOT INITIAL.
          t_employment[ 1 ]-weeklyhours = `400`.
        ENDIF.
        t_messages = VALUE #(
          ( message = `A mandatory field is required` type = `Error` additionaltext = `Name`
            target = `/T_FORMS/4/NAME` )
          ( message = `Enter a number without decimals.` type = `Error` additionaltext = `ZIP Code/City`
            target = `/T_FORMS/5/ZIP_CODE` )
          ( message = `Enter a valid email address.` type = `Error` additionaltext = `Email`
            target = `/T_FORMS/6/EMAIL` )
          ( message = `The value should not exceed 40` type = `Warning` additionaltext = `Standard Weekly Hours`
            description = `The value of the working hours field should not exceed 40 hours.`
            target = `/T_EMPLOYMENT/0/WEEKLYHOURS` ) ).
        " the message group (Personal, <section>) is a domain classification, so
        " it is computed in the backend (thin frontend) and rides on the Message
        " code field - the original derives it in its controller's getGroupName.
        LOOP AT t_messages REFERENCE INTO DATA(lr_msg).
          lr_msg->code = COND #( WHEN lr_msg->additionaltext = `Email`
                                 THEN `Personal, Contact`
                                 ELSE `Personal, Information` ).
        ENDLOOP.
        client->view_model_update( ).
        " original: oMP.openBy(oButton) after the values are set - open the popover anchored to the button
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `messagePopover` ) ( `openBy` ) ( `messagePopoverBtn` ) ) ).

      WHEN `CHANGE`.
        " the sample's onChange manually adds/removes required-field and constraint messages; here
        " the typed binding + constraints collect those AUTOMATICALLY into the message> model
        " (no app code), so the handler only pushes the model back
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

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
      ( jobtitle = `Senior UI Developer (UIDEV-SR)` paygrade = `Salary Grade 18 (GR-14` weeklyhours = `0`
        unit = `ABC` class = `Employee` fte = `1` ) ).

  ENDMETHOD.

ENDCLASS.
