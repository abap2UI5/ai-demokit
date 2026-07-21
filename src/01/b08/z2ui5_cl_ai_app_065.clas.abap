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
                        )->a( n = `press`        v = client->_event( val   = `SHOW_MESSAGES`
                                                                     t_arg = VALUE #( ( `$event.oSource.sId` ) ) )

                        )->open( `dependents`
                            )->open( `MessagePopover`
                                )->a( n = `id`         v = `messagePopover`
                                )->a( n = `items`      v = `{message>/}`
                                )->a( n = `groupItems` v = `true`
                                )->leaf( `MessageItem`
                                    )->a( n = `title`       v = `{message>message}`
                                    )->a( n = `subtitle`    v = `{message>additionalText}`
                                    )->a( n = `type`        v = `{message>type}`
                                    )->a( n = `description` v = `{message>message}`

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

      WHEN `SHOW_MESSAGES`.
        " original: this.oMP.toggle(oEvent.getSource()) - toggle open/close anchored to the button
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `messagePopover` ) ( `` ) ( `toggleBy` ) ( client->get_event_arg( ) ) ) ).

      WHEN `SAVE`.
        " original: generateInvalidUserInput() sets invalid values to trigger validation and the
        " controller adds MessageManager messages; here the Save authors a demo app message into
        " t_messages - the z2ui5.cc.MessageManager companion reconciles it into the message manager,
        " so it shows in the MessagePopover next to the auto-collected binding-validation messages
        t_messages = VALUE #( ( message        = `A mandatory field is required`
                                type           = `Error`
                                additionaltext = `Name`
                                target         = `/T_FORMS/0/NAME` ) ).
        client->view_model_update( ).

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
      ( name = `John Miller` street_name = `Mainstreet` street_number = `1618`
        zip_code = `AAA` zip_city = `Maintown` country = `Germany`
        email = `John.Miller@company.com` phone_number = `+1 (610) 661-1000` phone_time = `12:00` website = `n/a` ) ).

    t_employment = VALUE #(
      ( jobtitle = `Senior UI Developer (UIDEV-SR)` paygrade = `Salary Grade 18 (GR-14` weeklyhours = `0`
        unit = `ABC` class = `Employee` fte = `1` ) ).

  ENDMETHOD.

ENDCLASS.
