" @keywords sap.ui.core fieldgroup simpleform title label input griddata select item combobox messagestrip toolbar
" @summary A control's field group id can be used to define a virtual group of fields that should be validated together.
CLASS z2ui5_cl_smpc_app_272 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smpc_app_272 IMPLEMENTATION.

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

    " the original controller element-binds the whole model (bindElement('/')),
    " so its {BillingName} & co are relative to the root; the port seeds the
    " same fields at the model root and binds them ABSOLUTELY - a relative
    " path without a binding context resolves against nothing (AGENTS 5)
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:f`    v = `sap.ui.layout.form`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `height`     v = `100%`

        )->ele( `Page`
            )->a( n = `class`      v = `sapUiFioriObjectPage`
            )->a( n = `showHeader` v = `false`

            )->ele( `content`

                )->ele( n = `SimpleForm` ns = `f`
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
                    )->a( n = `validateFieldGroup` v = client->_event( val = `VALIDATE_FIELD_GROUP` arg = `${$parameters>/fieldGroupIds}[0]` )

                    )->ele( n = `content` ns = `f`

                        )->tag( n = `Title` ns = `core`
                            )->a( n = `text` v = `Billing Information`
                        )->tag( `Label`
                            )->a( n = `text` v = `Name`
                        )->tag( `Input`
                            )->a( n = `fieldGroupIds` v = `Billing Information`
                            )->a( n = `value`         v = client->_bind( billingname )
                            )->a( n = `id`            v = `BillingName`
                        )->tag( `Label`
                            )->a( n = `text` v = `Street/No.`
                        )->tag( `Input`
                            )->a( n = `fieldGroupIds` v = `Billing Information`
                            )->a( n = `value`         v = client->_bind( billingstreet )
                            )->a( n = `id`            v = `BillingStreet`

                        )->ele( `Input`
                            )->a( n = `fieldGroupIds` v = `Billing Information`
                            )->a( n = `value`         v = client->_bind( billingstreetnumber )
                            )->a( n = `id`            v = `BillingStreetNumber`

                            )->ele( `layoutData`
                                )->tag( n = `GridData` ns = `l`
                                    )->a( n = `span` v = `L3 M3 S4`

                            )->end(
                        )->end(

                        )->tag( `Label`
                            )->a( n = `text` v = `ZIP Code/City`

                        )->ele( `Input`
                            )->a( n = `fieldGroupIds` v = `Billing Information`
                            )->a( n = `value`         v = client->_bind( billingzipcode )
                            )->a( n = `id`            v = `BillingZipCode`

                            )->ele( `layoutData`
                                )->tag( n = `GridData` ns = `l`
                                    )->a( n = `span` v = `L3 M3 S4`

                            )->end(
                        )->end(

                        )->tag( `Input`
                            )->a( n = `fieldGroupIds` v = `Billing Information`
                            )->a( n = `value`         v = client->_bind( billingcity )
                            )->a( n = `id`            v = `BillingCity`
                        )->tag( `Label`
                            )->a( n = `text` v = `Country`

                        )->ele( `Select`
                            )->a( n = `fieldGroupIds` v = `Billing Information`
                            )->a( n = `width`         v = `100%`
                            )->a( n = `selectedKey`   v = client->_bind( billingcountry )
                            )->a( n = `id`            v = `BillingCountry`

                            )->ele( `items`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Germany`
                                    )->a( n = `key`  v = `Germany`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `United States`
                                    )->a( n = `key`  v = `United States`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Great Britain`
                                    )->a( n = `key`  v = `Great Britain`

                            )->end(
                        )->end(

                        )->tag( n = `Title` ns = `core`
                            )->a( n = `text` v = `Discount Code`
                        )->tag( `Input`
                            )->a( n = `fieldGroupIds` v = `Discount Code`
                            )->a( n = `value`         v = client->_bind( discountcode )
                            )->a( n = `placeholder`   v = `Enter your discout code here...`
                            )->a( n = `id`            v = `DiscountCode`

                        )->tag( n = `Title` ns = `core`
                            )->a( n = `text` v = `Credit Card`
                        )->tag( `Label`
                            )->a( n = `text` v = `Vendor`

                        )->ele( `ComboBox`
                            )->a( n = `fieldGroupIds` v = `Credit Card`
                            )->a( n = `width`         v = `100%`
                            )->a( n = `placeholder`   v = `Choose your card vendor...`
                            )->a( n = `value`         v = client->_bind( creditcardvendor )
                            )->a( n = `id`            v = `CreditCardVendor`

                            )->ele( `items`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = ``
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Mastercard`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Visa`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `American Express`

                            )->end(
                        )->end(

                        )->tag( `Label`
                            )->a( n = `text` v = `Credit Card Number`
                        )->tag( `Input`
                            )->a( n = `fieldGroupIds` v = `Credit Card`
                            )->a( n = `value`         v = client->_bind( creditcardnumber )
                            )->a( n = `maxLength`     v = `16`
                            )->a( n = `id`            v = `CreditCardNumber`
                        )->tag( `Label`
                            )->a( n = `text` v = `Expiry Date`

                        )->ele( `ComboBox`
                            )->a( n = `fieldGroupIds` v = `Credit Card`
                            )->a( n = `placeholder`   v = `Month...`
                            )->a( n = `value`         v = client->_bind( creditcardmonth )
                            )->a( n = `id`            v = `CreditCardMonth`

                            )->ele( `items`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `01`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `02`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `03`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `04`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `05`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `06`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `06`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `07`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `08`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `09`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `10`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `11`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `12`

                            )->end(
                        )->end(

                        )->ele( `ComboBox`
                            )->a( n = `fieldGroupIds` v = `Credit Card`
                            )->a( n = `placeholder`   v = `Year...`
                            )->a( n = `value`         v = client->_bind( creditcardyear )
                            )->a( n = `id`            v = `CreditCardYear`

                            )->ele( `items`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `2015`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `2016`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `2017`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `2018`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `2019`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `2020`

                            )->end(
                        )->end(

                        )->tag( `Label`
                            )->a( n = `text` v = `Validation Code`
                        )->tag( `Input`
                            )->a( n = `fieldGroupIds` v = `Credit Card`
                            )->a( n = `maxLength`     v = `3`
                            )->a( n = `value`         v = client->_bind( creditcardvalidationcode )
                            )->a( n = `id`            v = `CreditCardValidationCode`

                        )->tag( n = `Title` ns = `core`
                            )->a( n = `text` v = `Online`
                        )->tag( `Label`
                            )->a( n = `text` v = `E-Mail`
                        )->tag( `Input`
                            )->a( n = `fieldGroupIds` v = `Online`
                            )->a( n = `value`         v = client->_bind( onlinemail )
                            )->a( n = `id`            v = `OnlineMail`
                        )->tag( `Label`
                            )->a( n = `text` v = `Twitter`
                        )->tag( `Input`
                            )->a( n = `fieldGroupIds` v = `Online`
                            )->a( n = `value`         v = client->_bind( onlinetwitter )
                            )->a( n = `id`            v = `OnlineTwitter`

                    )->end(
                )->end(

            " the controller's byId(...).setType/setText/setVisible per
            " strip is a bound triple here; close sets visible = false
            " server-side, exactly like onMsgStripClose
                )->tag( `MessageStrip`
                    )->a( n = `id`              v = `BillingInformationMessage`
                    )->a( n = `visible`         v = client->_bind( billing_visible )
                    )->a( n = `text`            v = client->_bind( billing_text )
                    )->a( n = `type`            v = client->_bind( billing_type )
                    )->a( n = `showIcon`        v = `true`
                    )->a( n = `showCloseButton` v = `true`
                    )->a( n = `close`           v = client->_event( `CLOSE_BILLING` )
                )->tag( `MessageStrip`
                    )->a( n = `id`              v = `DiscountCodeMessage`
                    )->a( n = `visible`         v = client->_bind( discount_visible )
                    )->a( n = `text`            v = client->_bind( discount_text )
                    )->a( n = `type`            v = client->_bind( discount_type )
                    )->a( n = `showIcon`        v = `true`
                    )->a( n = `showCloseButton` v = `true`
                    )->a( n = `close`           v = client->_event( `CLOSE_DISCOUNT` )
                )->tag( `MessageStrip`
                    )->a( n = `id`              v = `CreditCardMessage`
                    )->a( n = `visible`         v = client->_bind( credit_visible )
                    )->a( n = `text`            v = client->_bind( credit_text )
                    )->a( n = `type`            v = client->_bind( credit_type )
                    )->a( n = `showIcon`        v = `true`
                    )->a( n = `showCloseButton` v = `true`
                    )->a( n = `close`           v = client->_event( `CLOSE_CREDIT` )
                )->tag( `MessageStrip`
                    )->a( n = `id`              v = `OnlineMessage`
                    )->a( n = `visible`         v = client->_bind( online_visible )
                    )->a( n = `text`            v = client->_bind( online_text )
                    )->a( n = `type`            v = client->_bind( online_type )
                    )->a( n = `showIcon`        v = `true`
                    )->a( n = `showCloseButton` v = `true`
                    )->a( n = `close`           v = client->_event( `CLOSE_ONLINE` )

            )->end(

            )->ele( `footer`
                )->ele( `Toolbar`
                    )->ele( `content`
                        )->tag( `Button`
                            )->a( n = `id`    v = `submit`
                            )->a( n = `text`  v = `Submit`
                            )->a( n = `press` v = client->_event( `ACCEPT` )
                            )->a( n = `type`  v = `Accept`
                            )->a( n = `width` v = `33%`
                        )->tag( `Button`
                            )->a( n = `id`    v = `reset`
                            )->a( n = `text`  v = `Reset`
                            )->a( n = `press` v = client->_event( `RESET` )
                            )->a( n = `type`  v = `Reject`
                            )->a( n = `width` v = `33%`
                        )->tag( `Button`
                            )->a( n = `id`    v = `cancel`
                            )->a( n = `text`  v = `Cancel`
                            )->a( n = `press` v = client->_event( `CANCEL` )
                            )->a( n = `width` v = `33%`

                        ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA lv_group TYPE string.
        DATA temp1 TYPE string.
        DATA temp2 TYPE string.
        DATA temp3 TYPE string.
        DATA temp4 TYPE string.
        DATA temp5 TYPE string.
        DATA temp6 TYPE string.
        DATA temp7 TYPE string.
        DATA temp8 TYPE string.
        DATA temp9 TYPE string.
        DATA temp10 TYPE string.
        DATA temp11 TYPE string.
        DATA temp12 TYPE string.
        DATA temp13 TYPE string.
        DATA temp14 TYPE string.

    CASE client->get_event( ).

      WHEN `VALIDATE_FIELD_GROUP`.
        " onValidateFieldGroup: mMessageMapping resolves the group to its own
        " strip + type, the strip shows "Group '<g>' Validation:<type>" and
        " the toast names the validated group
        
        lv_group = client->get_event_arg( ).
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
        client->message_toast_display( text = |Validation of field group '{ lv_group }' triggered.| duration = `500` ).

      WHEN `CLOSE_BILLING`.
        billing_visible = abap_false.

      WHEN `CLOSE_DISCOUNT`.
        discount_visible = abap_false.

      WHEN `CLOSE_CREDIT`.
        credit_visible = abap_false.

      WHEN `CLOSE_ONLINE`.
        online_visible = abap_false.

      WHEN `ACCEPT`.
        hide_messages( ).
        client->message_toast_display( text = `Accept triggered` duration = `500` ).

      WHEN `CANCEL`.
        hide_messages( ).
        client->message_toast_display( text = `Cancel triggered` duration = `500` ).

      WHEN `RESET`.
        " onReset: hide the messages and setData({}) - every bound field back
        " to its initial (empty) value
        hide_messages( ).
        
        CLEAR temp1.
        billingname              = temp1.
        
        CLEAR temp2.
        billingstreet            = temp2.
        
        CLEAR temp3.
        billingstreetnumber      = temp3.
        
        CLEAR temp4.
        billingzipcode           = temp4.
        
        CLEAR temp5.
        billingcity              = temp5.
        
        CLEAR temp6.
        billingcountry           = temp6.
        
        CLEAR temp7.
        discountcode             = temp7.
        
        CLEAR temp8.
        creditcardvendor         = temp8.
        
        CLEAR temp9.
        creditcardnumber         = temp9.
        
        CLEAR temp10.
        creditcardmonth          = temp10.
        
        CLEAR temp11.
        creditcardyear           = temp11.
        
        CLEAR temp12.
        creditcardvalidationcode = temp12.
        
        CLEAR temp13.
        onlinemail               = temp13.
        
        CLEAR temp14.
        onlinetwitter            = temp14.
        client->message_toast_display( text = `Reset triggered` duration = `500` ).

    ENDCASE.

  ENDMETHOD.


  METHOD hide_messages.

    billing_visible  = abap_false.
    discount_visible = abap_false.
    credit_visible   = abap_false.
    online_visible   = abap_false.

  ENDMETHOD.


  METHOD model_init.
    DATA lv_default TYPE string.

    " the sample's SampleData.json carries a single Email field the view never
    " binds, so every bound input starts empty; the four MessageStrips start
    " invisible with the view's own default text and the MessageStrip type
    " default (Information)
    billing_type  = `Information`.
    discount_type = `Information`.
    credit_type   = `Information`.
    online_type   = `Information`.

    
    lv_default = `Default: Lorem ipsum dolor sit amet, consectetur adipisicing elit.`.
    billing_text  = lv_default.
    discount_text = lv_default.
    credit_text   = lv_default.
    online_text   = lv_default.

  ENDMETHOD.

ENDCLASS.
