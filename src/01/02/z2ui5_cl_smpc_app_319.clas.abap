CLASS z2ui5_cl_smpc_app_319 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA edit_mode    TYPE abap_bool.
    DATA suppliername TYPE string.
    DATA street       TYPE string.
    DATA housenumber  TYPE string.
    DATA zipcode      TYPE string.
    DATA city         TYPE string.
    DATA country      TYPE string.
    DATA url          TYPE string.
    DATA twitter      TYPE string.
    DATA tel          TYPE string.
    DATA sms          TYPE string.
    DATA email        TYPE string.
    DATA rating       TYPE i.
    DATA disposable   TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    " handleEditPress clones the record so Cancel can restore it - the clone is
    " not bound, so it stays out of the round-trip model scan
    DATA backup_suppliername TYPE string.
    DATA backup_street       TYPE string.
    DATA backup_housenumber  TYPE string.
    DATA backup_zipcode      TYPE string.
    DATA backup_city         TYPE string.
    DATA backup_country      TYPE string.
    DATA backup_url          TYPE string.
    DATA backup_twitter      TYPE string.
    DATA backup_tel          TYPE string.
    DATA backup_sms          TYPE string.
    DATA backup_email        TYPE string.
    DATA backup_rating       TYPE i.
    DATA backup_disposable   TYPE i.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_319 IMPLEMENTATION.

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

    " _showFormFragment swaps the Page content between the Display and the Change
    " fragment; both are inlined here and switched by one bound flag instead
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:f`    v = `sap.ui.layout.form`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `Page`
            )->a( n = `id`         v = `page`
            )->a( n = `showHeader` v = `true`

            )->ele( `customHeader`
                )->ele( `Bar`
                    )->ele( `contentRight`
                        )->tag( `Button`
                            )->a( n = `id`      v = `edit`
                            )->a( n = `text`    v = `Edit`
                            )->a( n = `visible` v = |\{= !${ client->_bind( edit_mode ) }\}|
                            )->a( n = `press`   v = client->_event( `EDIT` )
                        )->tag( `Button`
                            )->a( n = `id`      v = `save`
                            )->a( n = `text`    v = `Save`
                            )->a( n = `type`    v = `Emphasized`
                            )->a( n = `visible` v = client->_bind( edit_mode )
                            )->a( n = `press`   v = client->_event( `SAVE` )
                        )->tag( `Button`
                            )->a( n = `id`      v = `cancel`
                            )->a( n = `text`    v = `Cancel`
                            )->a( n = `visible` v = client->_bind( edit_mode )
                            )->a( n = `press`   v = client->_event( `CANCEL` )

                    )->end(
                )->end(
            )->end(
            )->ele( `content`
                " Display.fragment.xml
                )->ele( `VBox`
                    )->a( n = `class`   v = `sapUiSmallMargin`
                    )->a( n = `visible` v = |\{= !${ client->_bind( edit_mode ) }\}|

                    )->ele( n = `Form` ns = `f`
                        )->a( n = `id`       v = `FormDisplay480_Trial`
                        )->a( n = `editable` v = `false`

                        )->ele( n = `title` ns = `f`
                            )->tag( n = `Title` ns = `core`
                                )->a( n = `text` v = `Supplier`

                        )->end(
                        )->ele( n = `layout` ns = `f`
                            )->tag( n = `ResponsiveGridLayout` ns = `f`
                                )->a( n = `labelSpanXL`             v = `4`
                                )->a( n = `labelSpanL`              v = `4`
                                )->a( n = `labelSpanM`              v = `4`
                                )->a( n = `labelSpanS`              v = `12`
                                )->a( n = `adjustLabelSpan`         v = `false`
                                )->a( n = `emptySpanXL`             v = `0`
                                )->a( n = `emptySpanL`              v = `0`
                                )->a( n = `emptySpanM`              v = `0`
                                )->a( n = `emptySpanS`              v = `0`
                                )->a( n = `columnsXL`               v = `3`
                                )->a( n = `columnsL`                v = `2`
                                )->a( n = `columnsM`                v = `2`
                                )->a( n = `singleContainerFullSize` v = `false`

                        )->end(
                        )->ele( n = `formContainers` ns = `f`
                            )->ele( n = `FormContainer` ns = `f`
                                )->a( n = `title` v = `Address`

                                )->ele( n = `formElements` ns = `f`
                                    )->ele( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Name`

                                        )->ele( n = `fields` ns = `f`
                                            )->tag( `Text`
                                                )->a( n = `text` v = client->_bind( suppliername )
                                                )->a( n = `id`   v = `nameText`

                                        )->end(
                                    )->end(
                                    )->ele( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Street`

                                        )->ele( n = `fields` ns = `f`
                                            )->tag( `Text`
                                                )->a( n = `text` v = |{ client->_bind( street ) } { client->_bind( housenumber ) }|

                                        )->end(
                                    )->end(
                                    )->ele( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `ZIP Code/City`

                                        )->ele( n = `fields` ns = `f`
                                            )->tag( `Text`
                                                )->a( n = `text` v = |{ client->_bind( zipcode ) } { client->_bind( city ) }|

                                        )->end(
                                    )->end(
                                    )->ele( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Country`

                                        )->ele( n = `fields` ns = `f`
                                            )->tag( `Text`
                                                )->a( n = `text` v = client->_bind( country )
                                                )->a( n = `id`   v = `countryText`

                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                            )->ele( n = `FormContainer` ns = `f`
                                )->a( n = `title` v = `Online`

                                )->ele( n = `formElements` ns = `f`
                                    )->ele( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Web`

                                        )->ele( n = `fields` ns = `f`
                                            )->tag( `Link`
                                                )->a( n = `text` v = `Url`
                                                )->a( n = `href` v = client->_bind( url )

                                        )->end(
                                    )->end(
                                    )->ele( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Twitter`

                                        )->ele( n = `fields` ns = `f`
                                            )->tag( `Text`
                                                )->a( n = `text` v = client->_bind( twitter )

                                        )->end(
                                    )->end(
                                    )->ele( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Email`

                                        )->ele( n = `fields` ns = `f`
                                            )->tag( `Text`
                                                )->a( n = `text` v = client->_bind( email )

                                        )->end(
                                    )->end(
                                    )->ele( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Tel.`

                                        )->ele( n = `fields` ns = `f`
                                            )->tag( `Text`
                                                )->a( n = `text` v = client->_bind( tel )

                                        )->end(
                                    )->end(
                                    )->ele( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `SMS`

                                        )->ele( n = `fields` ns = `f`
                                            )->tag( `Text`
                                                )->a( n = `text` v = client->_bind( sms )

                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                            )->ele( n = `FormContainer` ns = `f`
                                )->a( n = `title` v = `Other`

                                )->ele( n = `formElements` ns = `f`
                                    )->ele( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Rating`

                                        )->ele( n = `fields` ns = `f`
                                            )->tag( `RatingIndicator`
                                                )->a( n = `value`       v = client->_bind( rating )
                                                )->a( n = `displayOnly` v = `true`

                                        )->end(
                                    )->end(
                                    )->ele( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Disposable`

                                        )->ele( n = `fields` ns = `f`
                                            )->tag( `ProgressIndicator`
                                                )->a( n = `percentValue` v = client->_bind( disposable )
                                                )->a( n = `displayOnly`  v = `true`

                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
                " Change.fragment.xml
                )->ele( `VBox`
                    )->a( n = `class`   v = `sapUiSmallMargin`
                    )->a( n = `visible` v = client->_bind( edit_mode )

                    )->ele( n = `Form` ns = `f`
                        )->a( n = `id`       v = `FormChange480_Trial`
                        )->a( n = `editable` v = `true`

                        )->ele( n = `title` ns = `f`
                            )->tag( n = `Title` ns = `core`
                                )->a( n = `text` v = `Supplier`

                        )->end(
                        )->ele( n = `layout` ns = `f`
                            )->tag( n = `ResponsiveGridLayout` ns = `f`
                                )->a( n = `labelSpanXL`             v = `4`
                                )->a( n = `labelSpanL`              v = `4`
                                )->a( n = `labelSpanM`              v = `4`
                                )->a( n = `labelSpanS`              v = `12`
                                )->a( n = `adjustLabelSpan`         v = `false`
                                )->a( n = `emptySpanXL`             v = `0`
                                )->a( n = `emptySpanL`              v = `0`
                                )->a( n = `emptySpanM`              v = `0`
                                )->a( n = `emptySpanS`              v = `0`
                                )->a( n = `columnsXL`               v = `3`
                                )->a( n = `columnsL`                v = `2`
                                )->a( n = `columnsM`                v = `2`
                                )->a( n = `singleContainerFullSize` v = `false`

                        )->end(
                        )->ele( n = `formContainers` ns = `f`
                            )->ele( n = `FormContainer` ns = `f`
                                )->a( n = `title` v = `Address`

                                )->ele( n = `formElements` ns = `f`
                                    )->ele( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Name`

                                        )->ele( n = `fields` ns = `f`
                                            )->tag( `Input`
                                                )->a( n = `value` v = client->_bind( suppliername )
                                                )->a( n = `id`    v = `name`

                                        )->end(
                                    )->end(
                                    )->ele( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Street`

                                        )->ele( n = `fields` ns = `f`
                                            )->tag( `Input`
                                                )->a( n = `value` v = client->_bind( street )

                                            )->ele( `Input`
                                                )->a( n = `value` v = client->_bind( housenumber )

                                                )->ele( `layoutData`
                                                    )->tag( n = `GridData` ns = `l`
                                                        )->a( n = `span` v = `XL2 L2 M2 S4`

                                                )->end(
                                            )->end(
                                        )->end(
                                    )->end(
                                    )->ele( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `ZIP Code/City`

                                        )->ele( n = `fields` ns = `f`
                                            )->ele( `Input`
                                                )->a( n = `value` v = client->_bind( zipcode )

                                                )->ele( `layoutData`
                                                    )->tag( n = `GridData` ns = `l`
                                                        )->a( n = `span` v = `XL2 L2 M2 S4`

                                                )->end(
                                            )->end(
                                            )->tag( `Input`
                                                )->a( n = `value` v = client->_bind( city )

                                        )->end(
                                    )->end(
                                    )->ele( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Country`

                                        )->ele( n = `fields` ns = `f`
                                            )->ele( `Select`
                                                )->a( n = `id`          v = `country`
                                                )->a( n = `selectedKey` v = client->_bind( country )

                                                )->ele( `items`
                                                    )->tag( n = `Item` ns = `core`
                                                        )->a( n = `text` v = `England`
                                                        )->a( n = `key`  v = `England`
                                                    )->tag( n = `Item` ns = `core`
                                                        )->a( n = `text` v = `Germany`
                                                        )->a( n = `key`  v = `Germany`
                                                    )->tag( n = `Item` ns = `core`
                                                        )->a( n = `text` v = `USA`
                                                        )->a( n = `key`  v = `USA`

                                                )->end(
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                            )->ele( n = `FormContainer` ns = `f`
                                )->a( n = `title` v = `Contact`

                                )->ele( n = `formElements` ns = `f`
                                    )->ele( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Web`

                                        )->ele( n = `fields` ns = `f`
                                            )->tag( `Input`
                                                )->a( n = `value` v = client->_bind( url )
                                                )->a( n = `type`  v = `Url`

                                        )->end(
                                    )->end(
                                    )->ele( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Twitter`

                                        )->ele( n = `fields` ns = `f`
                                            )->tag( `Input`
                                                )->a( n = `value` v = client->_bind( twitter )

                                        )->end(
                                    )->end(
                                    )->ele( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Email`

                                        )->ele( n = `fields` ns = `f`
                                            )->tag( `Input`
                                                )->a( n = `value` v = client->_bind( email )
                                                )->a( n = `type`  v = `Email`

                                        )->end(
                                    )->end(
                                    )->ele( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Tel.`

                                        )->ele( n = `fields` ns = `f`
                                            )->tag( `Input`
                                                )->a( n = `value` v = client->_bind( tel )
                                                )->a( n = `type`  v = `Tel`

                                        )->end(
                                    )->end(
                                    )->ele( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `SMS`

                                        )->ele( n = `fields` ns = `f`
                                            )->tag( `Input`
                                                )->a( n = `value` v = client->_bind( sms )
                                                )->a( n = `type`  v = `Tel`

                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                            )->ele( n = `FormContainer` ns = `f`
                                )->a( n = `title` v = `Other`

                                )->ele( n = `formElements` ns = `f`
                                    )->ele( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Rating`

                                        )->ele( n = `fields` ns = `f`
                                            )->tag( `RatingIndicator`
                                                )->a( n = `value` v = client->_bind( rating )

                                        )->end(
                                    )->end(
                                    )->ele( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Disposable`

                                        )->ele( n = `fields` ns = `f`
                                            )->tag( `ProgressIndicator`
                                                )->a( n = `percentValue` v = client->_bind( disposable ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `EDIT`.
        " handleEditPress: clone the record, then show the Change form and the
        " Save/Cancel buttons
        backup_suppliername = suppliername.
        backup_street       = street.
        backup_housenumber  = housenumber.
        backup_zipcode      = zipcode.
        backup_city         = city.
        backup_country      = country.
        backup_url          = url.
        backup_twitter      = twitter.
        backup_tel          = tel.
        backup_sms          = sms.
        backup_email        = email.
        backup_rating       = rating.
        backup_disposable   = disposable.
        edit_mode           = abap_true.

      WHEN `SAVE`.
        " handleSavePress: keep the edited values, back to the Display form
        edit_mode = abap_false.

      WHEN `CANCEL`.
        " handleCancelPress: restore the cloned record, back to the Display form
        suppliername = backup_suppliername.
        street       = backup_street.
        housenumber  = backup_housenumber.
        zipcode      = backup_zipcode.
        city         = backup_city.
        country      = backup_country.
        url          = backup_url.
        twitter      = backup_twitter.
        tel          = backup_tel.
        sms          = backup_sms.
        email        = backup_email.
        rating       = backup_rating.
        disposable   = backup_disposable.
        edit_mode    = abap_false.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the original binds /SupplierCollection/0 of the shared demo supplier.json;
    " flattened here to top-level fields the form binds absolutely
    suppliername = `Red Point Stores`.
    street       = `Main St`.
    housenumber  = `1618`.
    zipcode      = `31415`.
    city         = `Maintown`.
    country      = `Germany`.
    url          = `http://www.sap.com`.
    twitter      = `@sap`.
    tel          = `+49 6227 747474`.
    sms          = `+49 173 123456`.
    email        = `john.smith@sap.com`.
    rating       = 4.
    disposable   = 30.

  ENDMETHOD.

ENDCLASS.
