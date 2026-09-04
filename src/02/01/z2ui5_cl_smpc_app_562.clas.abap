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

    DATA t_forms      TYPE STANDARD TABLE OF ty_s_form WITH DEFAULT KEY.
    DATA t_employment TYPE STANDARD TABLE OF ty_s_employment WITH DEFAULT KEY.
    DATA t_messages   TYPE STANDARD TABLE OF ty_s_message WITH DEFAULT KEY.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

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

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA dialog TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA content TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

    
    dialog = popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`       v = `sap.m`
        )->a( n = `xmlns:f`     v = `sap.ui.layout.form`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`  v = `sap.ui.core`
        )->a( n = `xmlns:z2ui5` v = `z2ui5.cc`

        )->ele( `Dialog`
            )->a( n = `id`    v = `mainDialog`
            )->a( n = `title` v = |Hello { client->_bind( recipient_name ) }| ).

    
    content = dialog->ele( `content` ).

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

    
    CLEAR temp1.
    INSERT `messagePopover` INTO TABLE temp1.
    INSERT `toggleBy` INTO TABLE temp1.
    INSERT `messagePopoverBtn` INTO TABLE temp1.
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
                                                                           t_arg = temp1 )

                    )->ele( `dependents`
                        )->ele( `MessagePopover`
                            )->a( n = `id`         v = `messagePopover`
                            )->a( n = `items`      v = `{message>/}`
                            )->a( n = `groupItems` v = `true`
                            " activeTitlePress ships the pressed message's target control id so
                            " the handler can scroll to it and focus it
                            )->a( n = `activeTitlePress` v = client->_event( val = `ACTIVE_TITLE` arg = `${$parameters>/item}.getBindingContext('message').getObject().getControlIds()[0]` )

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
        DATA control_id TYPE string.
          DATA temp3 TYPE string_table.
          DATA temp5 TYPE string_table.
          DATA temp7 TYPE string_table.
          FIELD-SYMBOLS <temp9> LIKE LINE OF t_forms.
          DATA temp10 LIKE sy-tabix.
          FIELD-SYMBOLS <temp11> LIKE LINE OF t_forms.
          DATA temp12 LIKE sy-tabix.
          FIELD-SYMBOLS <temp13> LIKE LINE OF t_forms.
          DATA temp14 LIKE sy-tabix.
          FIELD-SYMBOLS <temp15> LIKE LINE OF t_employment.
          DATA temp16 LIKE sy-tabix.
        DATA temp17 LIKE t_messages.
        DATA temp18 LIKE LINE OF temp17.
        DATA temp19 TYPE string_table.

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
        
        control_id = client->get_event_arg( ).
        IF control_id IS NOT INITIAL.
          
          CLEAR temp3.
          INSERT control_id INTO TABLE temp3.
          client->follow_up_action( val   = client->cs_event-scroll_into_view
                                    t_arg = temp3 ).
          
          CLEAR temp5.
          INSERT `messagePopover` INTO TABLE temp5.
          INSERT `close` INTO TABLE temp5.
          client->follow_up_action( val   = client->cs_event-control_by_id
                                    t_arg = temp5 ).
          
          CLEAR temp7.
          INSERT control_id INTO TABLE temp7.
          client->follow_up_action( val   = client->cs_event-set_focus
                                    t_arg = temp7 ).
        ENDIF.

      WHEN `SAVE`.
        " _generateInvalidUserInput(): force a set of fields invalid to demo the
        " message handling, then open the MessagePopover. abap2UI5 only auto-collects
        " validation messages from USER input, not from programmatically-set model
        " values, so Save mirrors the issues explicitly on the SAME rows the original
        " reaches through formContainer.getItems()[4/5/6] - John Miller / Stefan Bosch
        " / Maria Fontes - plus the employment row, and authors the matching messages
        IF lines( t_forms ) >= 7.
          
          
          temp10 = sy-tabix.
          READ TABLE t_forms INDEX 5 ASSIGNING <temp9>.
          sy-tabix = temp10.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          <temp9>-name     = ``.
          
          
          temp12 = sy-tabix.
          READ TABLE t_forms INDEX 6 ASSIGNING <temp11>.
          sy-tabix = temp12.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          <temp11>-zip_code = `AAA`.
          
          
          temp14 = sy-tabix.
          READ TABLE t_forms INDEX 7 ASSIGNING <temp13>.
          sy-tabix = temp14.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          <temp13>-email    = `MariaFontes.com`.
        ENDIF.
        IF t_employment IS NOT INITIAL.
          
          
          temp16 = sy-tabix.
          READ TABLE t_employment INDEX 1 ASSIGNING <temp15>.
          sy-tabix = temp16.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          <temp15>-weeklyhours = `400`.
        ENDIF.
        " the group name is `<form title>, <group title>`: the Personal form's
        " Information and Contact groups, and the employment form's Rating group
        " (Standard Weekly Hours sits there in this sample)
        
        CLEAR temp17.
        
        temp18-message = `A mandatory field is required`.
        temp18-type = `Error`.
        temp18-additionaltext = `Name`.
        temp18-target = `/T_FORMS/4/NAME`.
        temp18-code = `Personal, Information`.
        INSERT temp18 INTO TABLE temp17.
        temp18-message = `Enter a number without decimals.`.
        temp18-type = `Error`.
        temp18-additionaltext = `ZIP Code/City`.
        temp18-target = `/T_FORMS/5/ZIP_CODE`.
        temp18-code = `Personal, Information`.
        INSERT temp18 INTO TABLE temp17.
        temp18-message = `Enter a valid email address.`.
        temp18-type = `Error`.
        temp18-additionaltext = `Email`.
        temp18-target = `/T_FORMS/6/EMAIL`.
        temp18-code = `Personal, Contact`.
        INSERT temp18 INTO TABLE temp17.
        temp18-message = `The value should not exceed 40`.
        temp18-type = `Warning`.
        temp18-additionaltext = `Standard Weekly Hours`.
        temp18-description = `The value of the working hours field should not exceed 40 hours.`.
        temp18-target = `/T_EMPLOYMENT/0/WEEKLYHOURS`.
        temp18-code = `Personal, Rating`.
        INSERT temp18 INTO TABLE temp17.
        t_messages = temp17.
        button_severity_set( ).
        " the binding-change handler navigates the popover back and refreshes the
        " button, then oMP.openBy(oButton) opens it anchored to the button
        
        CLEAR temp19.
        INSERT `messagePopover` INTO TABLE temp19.
        INSERT `openBy` INTO TABLE temp19.
        INSERT `messagePopoverBtn` INTO TABLE temp19.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp19 ).

      WHEN `CHANGE`.
        " onChange manually adds/removes the required-field and constraint messages;
        " here the typed bindings with constraints collect those AUTOMATICALLY into
        " the message> model (no app code), so the handler only pushes the model back

    ENDCASE.

  ENDMETHOD.


  METHOD button_severity_set.
    DATA msg LIKE LINE OF t_messages.
    DATA temp21 TYPE string.
    DATA highest LIKE temp21.
    DATA temp22 TYPE i.
    DATA n TYPE i.
    DATA m LIKE LINE OF t_messages.
      DATA temp1 TYPE i.
    DATA count LIKE temp22.
    DATA temp23 TYPE string.

    " buttonTypeFormatter / buttonIconFormatter: Error > Warning > Success > Info
    CLEAR btn_icon.
    CLEAR btn_type.

    
    LOOP AT t_messages INTO msg.
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
    
    CASE btn_type.
      WHEN `Negative`.
        temp21 = `Error`.
      WHEN `Critical`.
        temp21 = `Warning`.
      WHEN `Success`.
        temp21 = `Success`.
      WHEN OTHERS.
        temp21 = `Information`.
    ENDCASE.
    
    highest = temp21.
    
    
    n = 0.
    
    LOOP AT t_messages INTO m.
      
      IF m-type = highest.
        temp1 = n + 1.
      ELSE.
        temp1 = n.
      ENDIF.
      n = temp1.
    ENDLOOP.
    temp22 = n.
    
    count = temp22.
    
    IF count = 0.
      temp23 = ``.
    ELSE.
      temp23 = |{ count }|.
    ENDIF.
    btn_text = temp23.

    " the formatter returns undefined while no message carries a severity; an empty
    " string would override the enum DEFAULT and reject the whole view
    IF btn_type IS INITIAL.
      btn_type = `Default`.
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " the shared demo kit forms.json - all 8 forms and the single employment row
    DATA temp24 LIKE t_forms.
    DATA temp25 LIKE LINE OF temp24.
    DATA temp26 LIKE t_employment.
    DATA temp27 LIKE LINE OF temp26.
    CLEAR temp24.
    
    temp25-name = `Julie Armstrong`.
    temp25-street_name = `Mainstreet`.
    temp25-street_number = `1278`.
    temp25-zip_code = `12345`.
    temp25-zip_city = `Maintown`.
    temp25-country = `Germany`.
    temp25-email = `Julie.Armstrong@company.com`.
    temp25-phone_number = `+1 (610) 661-1000`.
    temp25-phone_time = `12:00`.
    temp25-website = `n/a`.
    INSERT temp25 INTO TABLE temp24.
    temp25-name = `Denise Smith`.
    temp25-street_name = `Mainstreet`.
    temp25-street_number = `1567`.
    temp25-zip_code = `12345`.
    temp25-zip_city = `Maintown`.
    temp25-country = `Germany`.
    temp25-email = `Denise.Smith@company.com`.
    temp25-phone_number = `+1 (610) 661-1000`.
    temp25-phone_time = `12:00`.
    temp25-website = `n/a`.
    INSERT temp25 INTO TABLE temp24.
    temp25-name = `Richard Wilson`.
    temp25-street_name = `Mainstreet`.
    temp25-street_number = `2984`.
    temp25-zip_code = `12345`.
    temp25-zip_city = `Maintown`.
    temp25-country = `Germany`.
    temp25-email = `Richard.Wilson@company.com`.
    temp25-phone_number = `+1 (610) 661-1000`.
    temp25-phone_time = `12:00`.
    temp25-website = `n/a`.
    INSERT temp25 INTO TABLE temp24.
    temp25-name = `Gerd Becker`.
    temp25-street_name = `Mainstreet`.
    temp25-street_number = `3614`.
    temp25-zip_code = `12345`.
    temp25-zip_city = `Maintown`.
    temp25-country = `Germany`.
    temp25-email = `Gerd.Becker@company.com`.
    temp25-phone_number = `+1 (610) 661-1000`.
    temp25-phone_time = `12:00`.
    temp25-website = `n/a`.
    INSERT temp25 INTO TABLE temp24.
    temp25-name = `John Miller`.
    temp25-street_name = `Mainstreet`.
    temp25-street_number = `1618`.
    temp25-zip_code = `AAA`.
    temp25-zip_city = `Maintown`.
    temp25-country = `Germany`.
    temp25-email = `John.Miller@company.com`.
    temp25-phone_number = `+1 (610) 661-1000`.
    temp25-phone_time = `12:00`.
    temp25-website = `n/a`.
    INSERT temp25 INTO TABLE temp24.
    temp25-name = `Stefan Bosch`.
    temp25-street_name = `Mainstreet`.
    temp25-street_number = `4864`.
    temp25-zip_code = `12345`.
    temp25-zip_city = `Maintown`.
    temp25-country = `Germany`.
    temp25-email = `Stefan.Bosch@company.com`.
    temp25-phone_number = `+1 (610) 661-1000`.
    temp25-phone_time = `12:00`.
    temp25-website = `n/a`.
    INSERT temp25 INTO TABLE temp24.
    temp25-name = `Maria Fontes`.
    temp25-street_name = `Mainstreet`.
    temp25-street_number = `4864`.
    temp25-zip_code = `12345`.
    temp25-zip_city = `Maintown`.
    temp25-country = `Germany`.
    temp25-email = ``.
    temp25-phone_number = `+1 (610) 661-1000`.
    temp25-phone_time = `12:00`.
    temp25-website = `MariaFontescompany.com`.
    INSERT temp25 INTO TABLE temp24.
    temp25-name = `Antonio Ferrari`.
    temp25-street_name = `Mainstreet`.
    temp25-street_number = `2598`.
    temp25-zip_code = `12345`.
    temp25-zip_city = `Maintown`.
    temp25-country = `Germany`.
    temp25-email = `Antonio.Ferrari@company.com`.
    temp25-phone_number = `+1 (610) 661-1000`.
    temp25-phone_time = `12:00`.
    temp25-website = `n/a`.
    INSERT temp25 INTO TABLE temp24.
    t_forms = temp24.

    
    CLEAR temp26.
    
    temp27-jobtitle = `Senior UI Developer (UIDEV-SR)`.
    temp27-paygrade = `Salary Grade 18 (GR-14`.
    temp27-unit = `ABC`.
    temp27-class = `Employee`.
    temp27-fte = `1`.
    temp27-weeklyhours = `0`.
    INSERT temp27 INTO TABLE temp26.
    t_employment = temp26.

  ENDMETHOD.

ENDCLASS.
