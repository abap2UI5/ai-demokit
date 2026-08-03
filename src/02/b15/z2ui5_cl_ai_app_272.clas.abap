CLASS z2ui5_cl_ai_app_272 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA billingname              TYPE string.
    DATA billingstreet            TYPE string.
    DATA billingstreetnumber      TYPE string.
    DATA billingzipcode           TYPE string.
    DATA billingcity              TYPE string.
    DATA billingcountry           TYPE string.
    DATA discountcode             TYPE string.
    DATA creditcardvendor         TYPE string.
    DATA creditcardnumber         TYPE string.
    DATA creditcardmonth          TYPE string.
    DATA creditcardyear           TYPE string.
    DATA creditcardvalidationcode TYPE string.
    DATA onlinemail               TYPE string.
    DATA onlinetwitter            TYPE string.

    " one MessageStrip per field group - the controller's mMessageMapping
    " (group -> strip id + type) becomes a bound type/text/visible triple
    DATA billing_visible  TYPE abap_bool.
    DATA billing_type     TYPE string.
    DATA billing_text     TYPE string.
    DATA discount_visible TYPE abap_bool.
    DATA discount_type    TYPE string.
    DATA discount_text    TYPE string.
    DATA credit_visible   TYPE abap_bool.
    DATA credit_type      TYPE string.
    DATA credit_text      TYPE string.
    DATA online_visible   TYPE abap_bool.
    DATA online_type      TYPE string.
    DATA online_text      TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.
    METHODS on_event.
    METHODS hide_messages.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_272 IMPLEMENTATION.

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

    " the original controller element-binds the whole model (bindElement('/')),
    " so its {BillingName} & co are relative to the root; the port seeds the
    " same fields at the model root and binds them ABSOLUTELY - a relative
    " path without a binding context resolves against nothing (AGENTS 5)
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:f`    v = `sap.ui.layout.form`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `height`     v = `100%`

        )->open( `Page`
            )->a( n = `class`      v = `sapUiFioriObjectPage`
            )->a( n = `showHeader` v = `false`

            )->open( `content`

                )->open( n = `SimpleForm` ns = `f`
                    )->a( n = `id`               v = `FieldGroupView`
                    )->a( n = `maxContainerCols` v = `2`
                    )->a( n = `editable`         v = `true`
                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                    )->a( n = `title`            v = `Shopping Cart - Checkout`
                    )->a( n = `labelSpanL`       v = `4`
                    )->a( n = `labelSpanM`       v = `4`
                    )->a( n = `emptySpanL`       v = `0`
                    )->a( n = `emptySpanM`       v = `0`
                    )->a( n = `columnsL`         v = `2`
                    )->a( n = `columnsM`         v = `2`
                    " onValidateFieldGroup: the event carries the ids of the
                    " group that lost focus. The parameter reaches the backend
                    " as the JSON array (["Billing Information"]), so the arg
                    " indexes it exactly like the original's aFieldGroup[0]
                    " (measured 2026-08-01 - the expression grammar allows [n])
                    )->a( n = `validateFieldGroup` v = client->_event( val   = `VALIDATE_FIELD_GROUP`
                                                                       t_arg = VALUE #( ( `${$parameters>/fieldGroupIds}[0]` ) ) )

                    )->open( n = `content` ns = `f`

                        )->leaf( n = `Title` ns = `core`
                            )->a( n = `text` v = `Billing Information`
                        )->leaf( `Label`
                            )->a( n = `text` v = `Name`
                        )->leaf( `Input`
                            )->a( n = `fieldGroupIds` v = `Billing Information`
                            )->a( n = `value`         v = client->_bind( billingname )
                            )->a( n = `id`            v = `BillingName`
                        )->leaf( `Label`
                            )->a( n = `text` v = `Street/No.`
                        )->leaf( `Input`
                            )->a( n = `fieldGroupIds` v = `Billing Information`
                            )->a( n = `value`         v = client->_bind( billingstreet )
                            )->a( n = `id`            v = `BillingStreet`

                        )->open( `Input`
                            )->a( n = `fieldGroupIds` v = `Billing Information`
                            )->a( n = `value`         v = client->_bind( billingstreetnumber )
                            )->a( n = `id`            v = `BillingStreetNumber`

                            )->open( `layoutData`
                                )->leaf( n = `GridData` ns = `l`
                                    )->a( n = `span` v = `L3 M3 S4`

                        )->shut(
                        )->shut(

                        )->leaf( `Label`
                            )->a( n = `text` v = `ZIP Code/City`

                        )->open( `Input`
                            )->a( n = `fieldGroupIds` v = `Billing Information`
                            )->a( n = `value`         v = client->_bind( billingzipcode )
                            )->a( n = `id`            v = `BillingZipCode`

                            )->open( `layoutData`
                                )->leaf( n = `GridData` ns = `l`
                                    )->a( n = `span` v = `L3 M3 S4`

                        )->shut(
                        )->shut(

                        )->leaf( `Input`
                            )->a( n = `fieldGroupIds` v = `Billing Information`
                            )->a( n = `value`         v = client->_bind( billingcity )
                            )->a( n = `id`            v = `BillingCity`
                        )->leaf( `Label`
                            )->a( n = `text` v = `Country`

                        )->open( `Select`
                            )->a( n = `fieldGroupIds` v = `Billing Information`
                            )->a( n = `width`         v = `100%`
                            )->a( n = `selectedKey`   v = client->_bind( billingcountry )
                            )->a( n = `id`            v = `BillingCountry`

                            )->open( `items`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Germany`
                                    )->a( n = `key`  v = `Germany`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `United States`
                                    )->a( n = `key`  v = `United States`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Great Britain`
                                    )->a( n = `key`  v = `Great Britain`

                        )->shut(
                        )->shut(

                        )->leaf( n = `Title` ns = `core`
                            )->a( n = `text` v = `Discount Code`
                        )->leaf( `Input`
                            )->a( n = `fieldGroupIds` v = `Discount Code`
                            )->a( n = `value`         v = client->_bind( discountcode )
                            )->a( n = `placeholder`   v = `Enter your discout code here...`
                            )->a( n = `id`            v = `DiscountCode`

                        )->leaf( n = `Title` ns = `core`
                            )->a( n = `text` v = `Credit Card`
                        )->leaf( `Label`
                            )->a( n = `text` v = `Vendor`

                        )->open( `ComboBox`
                            )->a( n = `fieldGroupIds` v = `Credit Card`
                            )->a( n = `width`         v = `100%`
                            )->a( n = `placeholder`   v = `Choose your card vendor...`
                            )->a( n = `value`         v = client->_bind( creditcardvendor )
                            )->a( n = `id`            v = `CreditCardVendor`

                            )->open( `items`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = ``
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Mastercard`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Visa`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `American Express`

                        )->shut(
                        )->shut(

                        )->leaf( `Label`
                            )->a( n = `text` v = `Credit Card Number`
                        )->leaf( `Input`
                            )->a( n = `fieldGroupIds` v = `Credit Card`
                            )->a( n = `value`         v = client->_bind( creditcardnumber )
                            )->a( n = `maxLength`     v = `16`
                            )->a( n = `id`            v = `CreditCardNumber`
                        )->leaf( `Label`
                            )->a( n = `text` v = `Expiry Date`

                        )->open( `ComboBox`
                            )->a( n = `fieldGroupIds` v = `Credit Card`
                            )->a( n = `placeholder`   v = `Month...`
                            )->a( n = `value`         v = client->_bind( creditcardmonth )
                            )->a( n = `id`            v = `CreditCardMonth`

                            )->open( `items`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `01`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `02`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `03`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `04`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `05`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `06`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `06`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `07`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `08`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `09`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `10`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `11`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `12`

                        )->shut(
                        )->shut(

                        )->open( `ComboBox`
                            )->a( n = `fieldGroupIds` v = `Credit Card`
                            )->a( n = `placeholder`   v = `Year...`
                            )->a( n = `value`         v = client->_bind( creditcardyear )
                            )->a( n = `id`            v = `CreditCardYear`

                            )->open( `items`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `2015`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `2016`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `2017`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `2018`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `2019`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `2020`

                        )->shut(
                        )->shut(

                        )->leaf( `Label`
                            )->a( n = `text` v = `Validation Code`
                        )->leaf( `Input`
                            )->a( n = `fieldGroupIds` v = `Credit Card`
                            )->a( n = `maxLength`     v = `3`
                            )->a( n = `value`         v = client->_bind( creditcardvalidationcode )
                            )->a( n = `id`            v = `CreditCardValidationCode`

                        )->leaf( n = `Title` ns = `core`
                            )->a( n = `text` v = `Online`
                        )->leaf( `Label`
                            )->a( n = `text` v = `E-Mail`
                        )->leaf( `Input`
                            )->a( n = `fieldGroupIds` v = `Online`
                            )->a( n = `value`         v = client->_bind( onlinemail )
                            )->a( n = `id`            v = `OnlineMail`
                        )->leaf( `Label`
                            )->a( n = `text` v = `Twitter`
                        )->leaf( `Input`
                            )->a( n = `fieldGroupIds` v = `Online`
                            )->a( n = `value`         v = client->_bind( onlinetwitter )
                            )->a( n = `id`            v = `OnlineTwitter`

                    )->shut(
                    )->shut(

                    " the controller's byId(...).setType/setText/setVisible per
                    " strip is a bound triple here; close sets visible = false
                    " server-side, exactly like onMsgStripClose
                    )->leaf( `MessageStrip`
                        )->a( n = `id`              v = `BillingInformationMessage`
                        )->a( n = `visible`         v = client->_bind( billing_visible )
                        )->a( n = `text`            v = client->_bind( billing_text )
                        )->a( n = `type`            v = client->_bind( billing_type )
                        )->a( n = `showIcon`        v = `true`
                        )->a( n = `showCloseButton` v = `true`
                        )->a( n = `close`           v = client->_event( `CLOSE_BILLING` )
                    )->leaf( `MessageStrip`
                        )->a( n = `id`              v = `DiscountCodeMessage`
                        )->a( n = `visible`         v = client->_bind( discount_visible )
                        )->a( n = `text`            v = client->_bind( discount_text )
                        )->a( n = `type`            v = client->_bind( discount_type )
                        )->a( n = `showIcon`        v = `true`
                        )->a( n = `showCloseButton` v = `true`
                        )->a( n = `close`           v = client->_event( `CLOSE_DISCOUNT` )
                    )->leaf( `MessageStrip`
                        )->a( n = `id`              v = `CreditCardMessage`
                        )->a( n = `visible`         v = client->_bind( credit_visible )
                        )->a( n = `text`            v = client->_bind( credit_text )
                        )->a( n = `type`            v = client->_bind( credit_type )
                        )->a( n = `showIcon`        v = `true`
                        )->a( n = `showCloseButton` v = `true`
                        )->a( n = `close`           v = client->_event( `CLOSE_CREDIT` )
                    )->leaf( `MessageStrip`
                        )->a( n = `id`              v = `OnlineMessage`
                        )->a( n = `visible`         v = client->_bind( online_visible )
                        )->a( n = `text`            v = client->_bind( online_text )
                        )->a( n = `type`            v = client->_bind( online_type )
                        )->a( n = `showIcon`        v = `true`
                        )->a( n = `showCloseButton` v = `true`
                        )->a( n = `close`           v = client->_event( `CLOSE_ONLINE` )

                )->shut(

                )->open( `footer`
                    )->open( `Toolbar`
                        )->open( `content`
                            )->leaf( `Button`
                                )->a( n = `id`    v = `submit`
                                )->a( n = `text`  v = `Submit`
                                )->a( n = `press` v = client->_event( `ACCEPT` )
                                )->a( n = `type`  v = `Accept`
                                )->a( n = `width` v = `33%`
                            )->leaf( `Button`
                                )->a( n = `id`    v = `reset`
                                )->a( n = `text`  v = `Reset`
                                )->a( n = `press` v = client->_event( `RESET` )
                                )->a( n = `type`  v = `Reject`
                                )->a( n = `width` v = `33%`
                            )->leaf( `Button`
                                )->a( n = `id`    v = `cancel`
                                )->a( n = `text`  v = `Cancel`
                                )->a( n = `press` v = client->_event( `CANCEL` )
                                )->a( n = `width` v = `33%`

                            ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `VALIDATE_FIELD_GROUP`.
        " onValidateFieldGroup: mMessageMapping resolves the group to its own
        " strip + type, the strip shows "Group '<g>' Validation:<type>" and
        " the toast names the validated group
        DATA(lv_group) = client->get_event_arg( ).
        CASE lv_group.
          WHEN `Billing Information`.
            billing_type    = `Error`.
            billing_text    = |Group '{ lv_group }' Validation:Error|.
            billing_visible = abap_true.
          WHEN `Credit Card`.
            credit_type    = `Information`.
            credit_text    = |Group '{ lv_group }' Validation:Information|.
            credit_visible = abap_true.
          WHEN `Online`.
            online_type    = `Warning`.
            online_text    = |Group '{ lv_group }' Validation:Warning|.
            online_visible = abap_true.
          WHEN `Discount Code`.
            discount_type    = `Success`.
            discount_text    = |Group '{ lv_group }' Validation:Success|.
            discount_visible = abap_true.
        ENDCASE.
        client->message_toast_display( |Validation of field group '{ lv_group }' triggered.| ).
        client->view_model_update( ).

      WHEN `CLOSE_BILLING`.
        billing_visible = abap_false.
        client->view_model_update( ).

      WHEN `CLOSE_DISCOUNT`.
        discount_visible = abap_false.
        client->view_model_update( ).

      WHEN `CLOSE_CREDIT`.
        credit_visible = abap_false.
        client->view_model_update( ).

      WHEN `CLOSE_ONLINE`.
        online_visible = abap_false.
        client->view_model_update( ).

      WHEN `ACCEPT`.
        hide_messages( ).
        client->message_toast_display( `Accept triggered` ).
        client->view_model_update( ).

      WHEN `CANCEL`.
        hide_messages( ).
        client->message_toast_display( `Cancel triggered` ).
        client->view_model_update( ).

      WHEN `RESET`.
        " onReset: hide the messages and setData({}) - every bound field back
        " to its initial (empty) value
        hide_messages( ).
        billingname              = VALUE #( ).
        billingstreet            = VALUE #( ).
        billingstreetnumber      = VALUE #( ).
        billingzipcode           = VALUE #( ).
        billingcity              = VALUE #( ).
        billingcountry           = VALUE #( ).
        discountcode             = VALUE #( ).
        creditcardvendor         = VALUE #( ).
        creditcardnumber         = VALUE #( ).
        creditcardmonth          = VALUE #( ).
        creditcardyear           = VALUE #( ).
        creditcardvalidationcode = VALUE #( ).
        onlinemail               = VALUE #( ).
        onlinetwitter            = VALUE #( ).
        client->message_toast_display( `Reset triggered` ).
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.


  METHOD hide_messages.

    billing_visible  = abap_false.
    discount_visible = abap_false.
    credit_visible   = abap_false.
    online_visible   = abap_false.

  ENDMETHOD.


  METHOD model_init.

    " the sample's SampleData.json carries a single Email field the view never
    " binds, so every bound input starts empty; the four MessageStrips start
    " invisible with the view's own default text and the MessageStrip type
    " default (Information)
    billing_type  = `Information`.
    discount_type = `Information`.
    credit_type   = `Information`.
    online_type   = `Information`.

    DATA(lv_default) = `Default: Lorem ipsum dolor sit amet, consectetur adipisicing elit.`.
    billing_text  = lv_default.
    discount_text = lv_default.
    credit_text   = lv_default.
    online_text   = lv_default.

  ENDMETHOD.

ENDCLASS.
