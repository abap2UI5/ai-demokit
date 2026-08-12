CLASS z2ui5_cl_dmo_app_323 DEFINITION PUBLIC.

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
    DATA mobile       TYPE string.
    DATA pager        TYPE string.
    DATA fax          TYPE string.
    DATA email        TYPE string.

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
    DATA backup_mobile       TYPE string.
    DATA backup_pager        TYPE string.
    DATA backup_fax          TYPE string.
    DATA backup_email        TYPE string.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_323 IMPLEMENTATION.

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

    " _showFormFragment swaps the Page content between the Display and the Change
    " fragment; both are inlined here and switched by one bound flag instead
    view->open( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:f`    v = `sap.ui.layout.form`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( `Page`
            )->a( n = `id`         v = `page`
            )->a( n = `showHeader` v = `true`

            )->open( `customHeader`
                )->open( `Bar`
                    )->open( `contentRight`
                        " the original enables Edit once the mock request completes; the ABAP model is seeded synchronously, so it starts enabled
                        )->leaf( `Button`
                            )->a( n = `id`      v = `edit`
                            )->a( n = `text`    v = `Edit`
                            )->a( n = `enabled` v = `true`
                            )->a( n = `visible` v = |\{= !${ client->_bind( edit_mode ) }\}|
                            )->a( n = `press`   v = client->_event( `EDIT` )
                        )->leaf( `Button`
                            )->a( n = `id`      v = `save`
                            )->a( n = `text`    v = `Save`
                            )->a( n = `type`    v = `Emphasized`
                            )->a( n = `visible` v = client->_bind( edit_mode )
                            )->a( n = `press`   v = client->_event( `SAVE` )
                        )->leaf( `Button`
                            )->a( n = `id`      v = `cancel`
                            )->a( n = `text`    v = `Cancel`
                            )->a( n = `visible` v = client->_bind( edit_mode )
                            )->a( n = `press`   v = client->_event( `CANCEL` )

                    )->shut(
                )->shut(
            )->shut(
            )->open( `content`
                " Display.fragment.xml
                )->open( `VBox`
                    )->a( n = `class`   v = `sapUiSmallMargin`
                    )->a( n = `visible` v = |\{= !${ client->_bind( edit_mode ) }\}|

                    )->open( n = `Form` ns = `f`
                        )->a( n = `id`       v = `FormDisplayColumn_threeGroups346`
                        )->a( n = `editable` v = `false`

                        )->open( n = `title` ns = `f`
                            )->leaf( n = `Title` ns = `core`
                                )->a( n = `text` v = `Supplier`

                        )->shut(
                        )->open( n = `layout` ns = `f`
                            )->leaf( n = `ColumnLayout` ns = `f`
                                )->a( n = `columnsM`  v = `3`
                                )->a( n = `columnsL`  v = `4`
                                )->a( n = `columnsXL` v = `6`

                        )->shut(
                        )->open( n = `formContainers` ns = `f`
                            )->open( n = `FormContainer` ns = `f`
                                )->a( n = `title` v = `Address`

                                )->open( n = `formElements` ns = `f`
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Name`

                                        )->open( n = `fields` ns = `f`
                                            )->leaf( `Text`
                                                )->a( n = `text` v = client->_bind( suppliername )
                                                )->a( n = `id`   v = `nameText`

                                        )->shut(
                                    )->shut(
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Street`

                                        )->open( n = `fields` ns = `f`
                                            )->leaf( `Text`
                                                )->a( n = `text` v = |{ client->_bind( street ) } { client->_bind( housenumber ) }|

                                        )->shut(
                                    )->shut(
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `ZIP Code/City`

                                        )->open( n = `fields` ns = `f`
                                            )->leaf( `Text`
                                                )->a( n = `text` v = |{ client->_bind( zipcode ) } { client->_bind( city ) }|

                                        )->shut(
                                    )->shut(
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Country`

                                        )->open( n = `fields` ns = `f`
                                            )->leaf( `Text`
                                                )->a( n = `text` v = client->_bind( country )
                                                )->a( n = `id`   v = `countryText`

                                        )->shut(
                                    )->shut(
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Web`

                                        )->open( n = `fields` ns = `f`
                                            )->leaf( `Link`
                                                )->a( n = `text` v = `Url`
                                                )->a( n = `href` v = client->_bind( url )

                                        )->shut(
                                    )->shut(
                                )->shut(
                            )->shut(
                            )->open( n = `FormContainer` ns = `f`
                                )->a( n = `title` v = `Contact`

                                )->open( n = `formElements` ns = `f`
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Twitter`

                                        )->open( n = `fields` ns = `f`
                                            )->leaf( `Text`
                                                )->a( n = `text` v = client->_bind( twitter )

                                        )->shut(
                                    )->shut(
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Email`

                                        )->open( n = `fields` ns = `f`
                                            )->leaf( `Text`
                                                )->a( n = `text` v = client->_bind( email )

                                        )->shut(
                                    )->shut(
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Tel.`

                                        )->open( n = `fields` ns = `f`
                                            )->leaf( `Text`
                                                )->a( n = `text` v = client->_bind( tel )

                                        )->shut(
                                    )->shut(
                                )->shut(
                            )->shut(
                            )->open( n = `FormContainer` ns = `f`
                                )->a( n = `title` v = `Other`

                                )->open( n = `formElements` ns = `f`
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `SMS`

                                        )->open( n = `fields` ns = `f`
                                            )->leaf( `Text`
                                                )->a( n = `text` v = client->_bind( sms )

                                        )->shut(
                                    )->shut(
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Mobile`

                                        )->open( n = `fields` ns = `f`
                                            )->leaf( `Text`
                                                )->a( n = `text` v = client->_bind( mobile )

                                        )->shut(
                                    )->shut(
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Pager`

                                        )->open( n = `fields` ns = `f`
                                            )->leaf( `Text`
                                                )->a( n = `text` v = client->_bind( pager )

                                        )->shut(
                                    )->shut(
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Fax`

                                        )->open( n = `fields` ns = `f`
                                            )->leaf( `Text`
                                                )->a( n = `text` v = client->_bind( fax )

                                        )->shut(
                                    )->shut(
                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(
                " Change.fragment.xml
                )->open( `VBox`
                    )->a( n = `class`   v = `sapUiSmallMargin`
                    )->a( n = `visible` v = client->_bind( edit_mode )

                    )->open( n = `Form` ns = `f`
                        )->a( n = `id`       v = `FormChangeColumn_threeGroups346`
                        )->a( n = `editable` v = `true`

                        )->open( n = `title` ns = `f`
                            )->leaf( n = `Title` ns = `core`
                                )->a( n = `text` v = `Supplier`

                        )->shut(
                        )->open( n = `layout` ns = `f`
                            )->leaf( n = `ColumnLayout` ns = `f`
                                )->a( n = `columnsM`  v = `3`
                                )->a( n = `columnsL`  v = `4`
                                )->a( n = `columnsXL` v = `6`

                        )->shut(
                        )->open( n = `formContainers` ns = `f`
                            )->open( n = `FormContainer` ns = `f`
                                )->a( n = `title` v = `Address`

                                )->open( n = `formElements` ns = `f`
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Name`

                                        )->open( n = `fields` ns = `f`
                                            )->leaf( `Input`
                                                )->a( n = `value` v = client->_bind( suppliername )
                                                )->a( n = `id`    v = `name`

                                        )->shut(
                                    )->shut(
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Street`

                                        )->open( n = `fields` ns = `f`
                                            )->leaf( `Input`
                                                )->a( n = `value` v = client->_bind( street )

                                            )->open( `Input`
                                                )->a( n = `value` v = client->_bind( housenumber )

                                                )->open( `layoutData`
                                                    )->leaf( n = `ColumnElementData` ns = `f`
                                                        )->a( n = `cellsSmall` v = `2`
                                                        )->a( n = `cellsLarge` v = `1`

                                                )->shut(
                                            )->shut(
                                        )->shut(
                                    )->shut(
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `ZIP Code/City`

                                        )->open( n = `fields` ns = `f`
                                            )->open( `Input`
                                                )->a( n = `value` v = client->_bind( zipcode )

                                                )->open( `layoutData`
                                                    )->leaf( n = `ColumnElementData` ns = `f`
                                                        )->a( n = `cellsSmall` v = `3`
                                                        )->a( n = `cellsLarge` v = `2`

                                                )->shut(
                                            )->shut(
                                            )->leaf( `Input`
                                                )->a( n = `value` v = client->_bind( city )

                                        )->shut(
                                    )->shut(
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Country`

                                        )->open( n = `fields` ns = `f`
                                            )->open( `Select`
                                                )->a( n = `id`          v = `country`
                                                )->a( n = `selectedKey` v = client->_bind( country )

                                                )->open( `items`
                                                    )->leaf( n = `Item` ns = `core`
                                                        )->a( n = `text` v = `England`
                                                        )->a( n = `key`  v = `England`
                                                    )->leaf( n = `Item` ns = `core`
                                                        )->a( n = `text` v = `Germany`
                                                        )->a( n = `key`  v = `Germany`
                                                    )->leaf( n = `Item` ns = `core`
                                                        )->a( n = `text` v = `USA`
                                                        )->a( n = `key`  v = `USA`

                                                )->shut(
                                            )->shut(
                                        )->shut(
                                    )->shut(
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Web`

                                        )->open( n = `fields` ns = `f`
                                            )->leaf( `Input`
                                                )->a( n = `value` v = client->_bind( url )
                                                )->a( n = `type`  v = `Url`

                                        )->shut(
                                    )->shut(
                                )->shut(
                            )->shut(
                            )->open( n = `FormContainer` ns = `f`
                                )->a( n = `title` v = `Contact`

                                )->open( n = `formElements` ns = `f`
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Twitter`

                                        )->open( n = `fields` ns = `f`
                                            )->leaf( `Input`
                                                )->a( n = `value` v = client->_bind( twitter )

                                        )->shut(
                                    )->shut(
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Email`

                                        )->open( n = `fields` ns = `f`
                                            )->leaf( `Input`
                                                )->a( n = `value` v = client->_bind( email )
                                                )->a( n = `type`  v = `Email`

                                        )->shut(
                                    )->shut(
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Tel.`

                                        )->open( n = `fields` ns = `f`
                                            )->leaf( `Input`
                                                )->a( n = `value` v = client->_bind( tel )
                                                )->a( n = `type`  v = `Tel`

                                        )->shut(
                                    )->shut(
                                )->shut(
                            )->shut(
                            )->open( n = `FormContainer` ns = `f`
                                )->a( n = `title` v = `Other`

                                )->open( n = `formElements` ns = `f`
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `SMS`

                                        )->open( n = `fields` ns = `f`
                                            )->leaf( `Input`
                                                )->a( n = `value` v = client->_bind( sms )
                                                )->a( n = `type`  v = `Tel`

                                        )->shut(
                                    )->shut(
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Mobile`

                                        )->open( n = `fields` ns = `f`
                                            )->leaf( `Input`
                                                )->a( n = `value` v = client->_bind( mobile )
                                                )->a( n = `type`  v = `Tel`

                                        )->shut(
                                    )->shut(
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Pager`

                                        )->open( n = `fields` ns = `f`
                                            )->leaf( `Input`
                                                )->a( n = `value` v = client->_bind( pager )
                                                )->a( n = `type`  v = `Tel`

                                        )->shut(
                                    )->shut(
                                    )->open( n = `FormElement` ns = `f`
                                        )->a( n = `label` v = `Fax`

                                        )->open( n = `fields` ns = `f`
                                            )->leaf( `Input`
                                                )->a( n = `value` v = client->_bind( fax )
                                                )->a( n = `type`  v = `Tel` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

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
        backup_mobile       = mobile.
        backup_pager        = pager.
        backup_fax          = fax.
        backup_email        = email.
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
        mobile       = backup_mobile.
        pager        = backup_pager.
        fax          = backup_fax.
        email        = backup_email.
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
    mobile       = `+49 173 123456`.
    pager        = `+49 173 123456`.
    fax          = `+49 123 456789`.
    email        = `john.smith@sap.com`.

  ENDMETHOD.

ENDCLASS.
