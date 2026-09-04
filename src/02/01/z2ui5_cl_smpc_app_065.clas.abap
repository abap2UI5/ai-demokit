" @keywords messagepopover message popover sap.m handling vbox simpleform title label input select item
" @summary The message handling concept sample shows how you can connect an error inside the page (such as input validation error) with an error, visualized as an item in a message popover.
CLASS z2ui5_cl_smpc_app_065 DEFINITION PUBLIC.

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

    DATA t_forms      TYPE STANDARD TABLE OF ty_s_form WITH DEFAULT KEY.
    DATA t_employment TYPE STANDARD TABLE OF ty_s_employment WITH DEFAULT KEY.
    DATA t_messages   TYPE STANDARD TABLE OF ty_s_message WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_065 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
      " original onInit: MessageToast.show('Press "Save" to trigger validation.')
      client->message_toast_display( `Press "Save" to trigger validation.` ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `messagePopover` INTO TABLE temp1.
    INSERT `toggleBy` INTO TABLE temp1.
    INSERT `messagePopoverBtn` INTO TABLE temp1.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`      v = `100%`
        )->a( n = `xmlns`       v = `sap.m`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`  v = `sap.ui.core`
        )->a( n = `xmlns:f`     v = `sap.ui.layout.form`
        )->a( n = `xmlns:z2ui5` v = `z2ui5.cc`

        )->ele( `Page`
            )->a( n = `id`         v = `messageHandlingPage`
            )->a( n = `showHeader` v = `false`

            )->ele( `content`

                )->ele( `VBox`
                    )->a( n = `id`    v = `formContainer`
                    )->a( n = `class` v = `sapUiSmallMargin`
                    )->a( n = `items` v = client->_bind( t_forms )

                    )->ele( n = `SimpleForm` ns = `f`
                        )->a( n = `editable` v = `true`
                        )->a( n = `layout`   v = `ColumnLayout`
                        )->a( n = `title`    v = `Personal`
                        )->a( n = `columnsM` v = `2`
                        )->a( n = `columnsL` v = `2`
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
                            )->tag( `Input`
                                )->a( n = `value` v = `{STREET_NUMBER}`
                            )->tag( `Label`
                                )->a( n = `text` v = `ZIP Code/City`
                            )->tag( `Input`
                                )->a( n = `value` v = `{ path: 'ZIP_CODE', type: 'sap.ui.model.type.Integer' }`
                            )->tag( `Input`
                                )->a( n = `value` v = `{ZIP_CITY}`
                            )->tag( `Label`
                                )->a( n = `text` v = `Country`
                            )->ele( `Select`
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
                            )->tag( `Input`
                                )->a( n = `value` v = `{PHONE_TIME}`
                            )->tag( `Label`
                                )->a( n = `text` v = `Personal website`
                            )->tag( `Input`
                                )->a( n = `value` v = `{WEBSITE}`

                        )->end(
                    )->end(
                )->end(

                )->ele( `VBox`
                    )->a( n = `id`    v = `formContainerEmployment`
                    )->a( n = `class` v = `sapUiSmallMargin`
                    )->a( n = `items` v = client->_bind( t_employment )

                    )->ele( n = `SimpleForm` ns = `f`
                        )->a( n = `editable` v = `true`
                        )->a( n = `layout`   v = `ColumnLayout`
                        )->a( n = `title`    v = `Personal`
                        )->a( n = `columnsM` v = `2`
                        )->a( n = `columnsL` v = `2`
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
                                )->a( n = `text` v = `Standard Weekly Hours`
                            )->tag( `Input`
                                )->a( n = `value`  v = `{ path: 'WEEKLYHOURS', type: 'sap.ui.model.type.Integer', constraints: { maximum: 40 } }`
                                )->a( n = `change` v = client->_event( `CHANGE` )
                            )->tag( n = `Title` ns = `core`
                                )->a( n = `text` v = `Rating`
                            )->tag( `Label`
                                )->a( n = `text` v = `Unit`
                            )->tag( `Input`
                                )->a( n = `value` v = `{UNIT}`
                            )->tag( `Label`
                                )->a( n = `text` v = `Employee Class`
                            )->tag( `Input`
                                )->a( n = `value` v = `{CLASS}`
                            )->tag( `Label`
                                )->a( n = `text` v = `FTE`
                            )->tag( `Input`
                                )->a( n = `value` v = `{FTE}`

                        )->end(
                    )->end(
                )->end(

                )->tag( n = `MessageManager` ns = `z2ui5`
                    )->a( n = `items` v = client->_bind( t_messages )

            )->end(

            )->ele( `footer`
                )->ele( `OverflowToolbar`

                    )->ele( `Button`
                        )->a( n = `id`           v = `messagePopoverBtn`
                        )->a( n = `visible`      v = |\{= !!$\{message>/\}.length \}|
                        )->a( n = `text`         v = |\{= $\{message>/\}.length \}|
                        )->a( n = `type`         v = `Emphasized`
                        )->a( n = `ariaHasPopup` v = `Dialog`
                        " original: this.oMP.toggle(oEvent.getSource()) - a pure client-side toggle, so
                        " wired roundtrip-free (no on_event) anchored to the button by its own id
                        )->a( n = `press`        v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                               t_arg = temp1 )

                        )->ele( `dependents`
                            )->ele( `MessagePopover`
                                )->a( n = `id`              v = `messagePopover`
                                )->a( n = `items`           v = `{message>/}`
                                )->a( n = `groupItems`      v = `true`
                                " activeTitlePress is a MessagePopover event (not MessageItem); it ships the
                                " pressed message's target control id so the handler can scroll+focus it
                                )->a( n = `activeTitlePress` v = client->_event( val = `ACTIVE_TITLE` arg = `${$parameters>/item}.getBindingContext('message').getObject().getControlIds()[0]` )
                                )->tag( `MessageItem`
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

                            )->end(
                        )->end(
                    )->end(

                    )->tag( `ToolbarSpacer`
                    )->tag( `Button`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `text`  v = `Save`
                        )->a( n = `press` v = client->_event( `SAVE` )
                    )->tag( `Button`
                        )->a( n = `text` v = `Cancel`

                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA lv_control_id TYPE string.
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
        DATA temp19 LIKE LINE OF t_messages.
        DATA lr_msg LIKE REF TO temp19.
          DATA temp20 TYPE z2ui5_cl_smpc_app_065=>ty_s_message-code.
        DATA temp21 TYPE string_table.

    CASE client->get_event( ).

      WHEN `ACTIVE_TITLE`.
        " original: activeTitlePress scrolls to the message's target control, closes the popover
        " and focuses the control; the full control id travels from the pressed MessageItem's
        " message object (getControlIds()[0]) and the frontend SCROLL_INTO_VIEW + SET_FOCUS act on it
        
        lv_control_id = client->get_event_arg( ).
        IF lv_control_id IS NOT INITIAL.
          
          CLEAR temp3.
          INSERT lv_control_id INTO TABLE temp3.
          client->follow_up_action( val   = client->cs_event-scroll_into_view
                                    t_arg = temp3 ).
          
          CLEAR temp5.
          INSERT `messagePopover` INTO TABLE temp5.
          INSERT `close` INTO TABLE temp5.
          client->follow_up_action( val   = client->cs_event-control_by_id
                                    t_arg = temp5 ).
          
          CLEAR temp7.
          INSERT lv_control_id INTO TABLE temp7.
          client->follow_up_action( val   = client->cs_event-set_focus
                                    t_arg = temp7 ).
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
          " John Miller  -> /T_FORMS/4/NAME
          
          
          temp10 = sy-tabix.
          READ TABLE t_forms INDEX 5 ASSIGNING <temp9>.
          sy-tabix = temp10.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          <temp9>-name     = ``.
          " Stefan Bosch -> /T_FORMS/5/ZIP_CODE
          
          
          temp12 = sy-tabix.
          READ TABLE t_forms INDEX 6 ASSIGNING <temp11>.
          sy-tabix = temp12.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          <temp11>-zip_code = `AAA`.
          " Maria Fontes -> /T_FORMS/6/EMAIL
          
          
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
        
        CLEAR temp17.
        
        temp18-message = `A mandatory field is required`.
        temp18-type = `Error`.
        temp18-additionaltext = `Name`.
        temp18-target = `/T_FORMS/4/NAME`.
        INSERT temp18 INTO TABLE temp17.
        temp18-message = `Enter a number with no decimal places`.
        temp18-type = `Error`.
        temp18-additionaltext = `ZIP Code/City`.
        temp18-target = `/T_FORMS/5/ZIP_CODE`.
        INSERT temp18 INTO TABLE temp17.
        temp18-message = `Enter a valid value`.
        temp18-type = `Error`.
        temp18-additionaltext = `Email`.
        temp18-target = `/T_FORMS/6/EMAIL`.
        INSERT temp18 INTO TABLE temp17.
        temp18-message = `The value should not exceed 40`.
        temp18-type = `Warning`.
        temp18-additionaltext = `Standard Weekly Hours`.
        temp18-description = `The value of the working hours field should not exceed 40 hours.`.
        temp18-target = `/T_EMPLOYMENT/0/WEEKLYHOURS`.
        INSERT temp18 INTO TABLE temp17.
        t_messages = temp17.
        " the message group (Personal, <section>) is a domain classification, so
        " it is computed in the backend (thin frontend) and rides on the Message
        " code field - the original derives it in its controller's getGroupName.
        
        
        LOOP AT t_messages REFERENCE INTO lr_msg.
          
          IF lr_msg->additionaltext = `Email`.
            temp20 = `Personal, Contact`.
          ELSE.
            temp20 = `Personal, Information`.
          ENDIF.
          lr_msg->code = temp20.
        ENDLOOP.
        " original: oMP.openBy(oButton) after the values are set - open the popover anchored to the button
        
        CLEAR temp21.
        INSERT `messagePopover` INTO TABLE temp21.
        INSERT `openBy` INTO TABLE temp21.
        INSERT `messagePopoverBtn` INTO TABLE temp21.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp21 ).

      WHEN `CHANGE`.
        " the sample's onChange manually adds/removes required-field and constraint messages; here
        " the typed binding + constraints collect those AUTOMATICALLY into the message> model
        " (no app code), so the handler only pushes the model back

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    DATA temp23 LIKE t_forms.
    DATA temp24 LIKE LINE OF temp23.
    DATA temp25 LIKE t_employment.
    DATA temp26 LIKE LINE OF temp25.
    CLEAR temp23.
    
    temp24-name = `Julie Armstrong`.
    temp24-street_name = `Mainstreet`.
    temp24-street_number = `1278`.
    temp24-zip_code = `12345`.
    temp24-zip_city = `Maintown`.
    temp24-country = `Germany`.
    temp24-email = `Julie.Armstrong@company.com`.
    temp24-phone_number = `+1 (610) 661-1000`.
    temp24-phone_time = `12:00`.
    temp24-website = `n/a`.
    INSERT temp24 INTO TABLE temp23.
    temp24-name = `Denise Smith`.
    temp24-street_name = `Mainstreet`.
    temp24-street_number = `1567`.
    temp24-zip_code = `12345`.
    temp24-zip_city = `Maintown`.
    temp24-country = `Germany`.
    temp24-email = `Denise.Smith@company.com`.
    temp24-phone_number = `+1 (610) 661-1000`.
    temp24-phone_time = `12:00`.
    temp24-website = `n/a`.
    INSERT temp24 INTO TABLE temp23.
    temp24-name = `Richard Wilson`.
    temp24-street_name = `Mainstreet`.
    temp24-street_number = `2984`.
    temp24-zip_code = `12345`.
    temp24-zip_city = `Maintown`.
    temp24-country = `Germany`.
    temp24-email = `Richard.Wilson@company.com`.
    temp24-phone_number = `+1 (610) 661-1000`.
    temp24-phone_time = `12:00`.
    temp24-website = `n/a`.
    INSERT temp24 INTO TABLE temp23.
    temp24-name = `Gerd Becker`.
    temp24-street_name = `Mainstreet`.
    temp24-street_number = `3614`.
    temp24-zip_code = `12345`.
    temp24-zip_city = `Maintown`.
    temp24-country = `Germany`.
    temp24-email = `Gerd.Becker@company.com`.
    temp24-phone_number = `+1 (610) 661-1000`.
    temp24-phone_time = `12:00`.
    temp24-website = `n/a`.
    INSERT temp24 INTO TABLE temp23.
    temp24-name = `John Miller`.
    temp24-street_name = `Mainstreet`.
    temp24-street_number = `1618`.
    temp24-zip_code = `AAA`.
    temp24-zip_city = `Maintown`.
    temp24-country = `Germany`.
    temp24-email = `John.Miller@company.com`.
    temp24-phone_number = `+1 (610) 661-1000`.
    temp24-phone_time = `12:00`.
    temp24-website = `n/a`.
    INSERT temp24 INTO TABLE temp23.
    temp24-name = `Stefan Bosch`.
    temp24-street_name = `Mainstreet`.
    temp24-street_number = `4864`.
    temp24-zip_code = `12345`.
    temp24-zip_city = `Maintown`.
    temp24-country = `Germany`.
    temp24-email = `Stefan.Bosch@company.com`.
    temp24-phone_number = `+1 (610) 661-1000`.
    temp24-phone_time = `12:00`.
    temp24-website = `n/a`.
    INSERT temp24 INTO TABLE temp23.
    temp24-name = `Maria Fontes`.
    temp24-street_name = `Mainstreet`.
    temp24-street_number = `4864`.
    temp24-zip_code = `12345`.
    temp24-zip_city = `Maintown`.
    temp24-country = `Germany`.
    temp24-email = ``.
    temp24-phone_number = `+1 (610) 661-1000`.
    temp24-phone_time = `12:00`.
    temp24-website = `MariaFontescompany.com`.
    INSERT temp24 INTO TABLE temp23.
    temp24-name = `Antonio Ferrari`.
    temp24-street_name = `Mainstreet`.
    temp24-street_number = `2598`.
    temp24-zip_code = `12345`.
    temp24-zip_city = `Maintown`.
    temp24-country = `Germany`.
    temp24-email = `Antonio.Ferrari@company.com`.
    temp24-phone_number = `+1 (610) 661-1000`.
    temp24-phone_time = `12:00`.
    temp24-website = `n/a`.
    INSERT temp24 INTO TABLE temp23.
    t_forms = temp23.

    
    CLEAR temp25.
    
    temp26-jobtitle = `Senior UI Developer (UIDEV-SR)`.
    temp26-paygrade = `Salary Grade 18 (GR-14`.
    temp26-weeklyhours = `0`.
    temp26-unit = `ABC`.
    temp26-class = `Employee`.
    temp26-fte = `1`.
    INSERT temp26 INTO TABLE temp25.
    t_employment = temp25.

  ENDMETHOD.

ENDCLASS.
