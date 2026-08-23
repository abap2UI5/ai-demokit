" @keywords simpleform simple form sap.ui.layout.form simpleform_column_threegroups234 bar button vbox title label text link
" @summary Form with three groups in a fullscreen app (with 2 columns in M, 3 columns in L, and 4 columns in XL size).
CLASS z2ui5_cl_smpc_app_335 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smpc_app_335 IMPLEMENTATION.

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
                            " the original enables Edit once the mock request completes;
                            " the ABAP model is seeded synchronously, so it starts enabled
                            )->a( n = `enabled` v = `true`
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

                    )->ele( n = `SimpleForm` ns = `f`
                        )->a( n = `id`        v = `SimpleFormDisplayColumn_threeGroups234`
                        )->a( n = `editable`  v = `false`
                        )->a( n = `layout`    v = `ColumnLayout`
                        )->a( n = `title`     v = `Supplier`
                        )->a( n = `columnsM`  v = `2`
                        )->a( n = `columnsL`  v = `3`
                        )->a( n = `columnsXL` v = `4`

                        )->ele( n = `content` ns = `f`
                            )->tag( n = `Title` ns = `core`
                                )->a( n = `text` v = `Address`
                            )->tag( `Label`
                                )->a( n = `text` v = `Name`
                            )->tag( `Text`
                                )->a( n = `id`   v = `nameText`
                                )->a( n = `text` v = client->_bind( suppliername )
                            )->tag( `Label`
                                )->a( n = `text` v = `Street/No.`
                            )->tag( `Text`
                                )->a( n = `text` v = |{ client->_bind( street ) } { client->_bind( housenumber ) }|
                            )->tag( `Label`
                                )->a( n = `text` v = `ZIP Code/City`
                            )->tag( `Text`
                                )->a( n = `text` v = |{ client->_bind( zipcode ) } { client->_bind( city ) }|
                            )->tag( `Label`
                                )->a( n = `text` v = `Country`
                            )->tag( `Text`
                                )->a( n = `id`   v = `countryText`
                                )->a( n = `text` v = client->_bind( country )
                            )->tag( `Label`
                                )->a( n = `text` v = `Web`
                            )->tag( `Link`
                                )->a( n = `text` v = `Url`
                                )->a( n = `href` v = client->_bind( url )
                            )->tag( n = `Title` ns = `core`
                                )->a( n = `text` v = `Contact`
                            )->tag( `Label`
                                )->a( n = `text` v = `Twitter`
                            )->tag( `Text`
                                )->a( n = `text` v = client->_bind( twitter )
                            )->tag( `Label`
                                )->a( n = `text` v = `Email`
                            )->tag( `Text`
                                )->a( n = `text` v = client->_bind( email )
                            )->tag( `Label`
                                )->a( n = `text` v = `Tel.`
                            )->tag( `Text`
                                )->a( n = `text` v = client->_bind( tel )
                            )->tag( n = `Title` ns = `core`
                                )->a( n = `text` v = `Other`
                            )->tag( `Label`
                                )->a( n = `text` v = `SMS`
                            )->tag( `Text`
                                )->a( n = `text` v = client->_bind( sms )
                            )->tag( `Label`
                                )->a( n = `text` v = `Mobile`
                            )->tag( `Text`
                                )->a( n = `text` v = client->_bind( mobile )
                            )->tag( `Label`
                                )->a( n = `text` v = `Pager`
                            )->tag( `Text`
                                )->a( n = `text` v = client->_bind( pager )
                            )->tag( `Label`
                                )->a( n = `text` v = `Fax`
                            )->tag( `Text`
                                )->a( n = `text` v = client->_bind( fax )

                        )->end(
                    )->end(
                )->end(

                " Change.fragment.xml
                )->ele( `VBox`
                    )->a( n = `class`   v = `sapUiSmallMargin`
                    )->a( n = `visible` v = client->_bind( edit_mode )

                    )->ele( n = `SimpleForm` ns = `f`
                        )->a( n = `id`        v = `SimpleFormChangeColumn_threeGroups234`
                        )->a( n = `editable`  v = `true`
                        )->a( n = `layout`    v = `ColumnLayout`
                        )->a( n = `title`     v = `Supplier`
                        )->a( n = `columnsM`  v = `2`
                        )->a( n = `columnsL`  v = `3`
                        )->a( n = `columnsXL` v = `4`

                        )->ele( n = `content` ns = `f`
                            )->tag( n = `Title` ns = `core`
                                )->a( n = `text` v = `Address`
                            )->tag( `Label`
                                )->a( n = `text` v = `Name`
                            )->tag( `Input`
                                )->a( n = `id`    v = `name`
                                )->a( n = `value` v = client->_bind( suppliername )
                            )->tag( `Label`
                                )->a( n = `text` v = `Street/No.`
                            )->tag( `Input`
                                )->a( n = `value` v = client->_bind( street )

                            )->ele( `Input`
                                )->a( n = `value` v = client->_bind( housenumber )

                                )->ele( `layoutData`
                                    )->tag( n = `ColumnElementData` ns = `f`
                                        )->a( n = `cellsSmall` v = `2`
                                        )->a( n = `cellsLarge` v = `1`

                                )->end(
                            )->end(
                            )->tag( `Label`
                                )->a( n = `text` v = `ZIP Code/City`

                            )->ele( `Input`
                                )->a( n = `value` v = client->_bind( zipcode )

                                )->ele( `layoutData`
                                    )->tag( n = `ColumnElementData` ns = `f`
                                        )->a( n = `cellsSmall` v = `3`
                                        )->a( n = `cellsLarge` v = `2`

                                )->end(
                            )->end(
                            )->tag( `Input`
                                )->a( n = `value` v = client->_bind( city )
                            )->tag( `Label`
                                )->a( n = `text` v = `Country`

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
                            )->tag( `Label`
                                )->a( n = `text` v = `Web`
                            )->tag( `Input`
                                )->a( n = `value` v = client->_bind( url )
                                )->a( n = `type`  v = `Url`
                            )->tag( n = `Title` ns = `core`
                                )->a( n = `text` v = `Contact`
                            )->tag( `Label`
                                )->a( n = `text` v = `Twitter`
                            )->tag( `Input`
                                )->a( n = `value` v = client->_bind( twitter )
                            )->tag( `Label`
                                )->a( n = `text` v = `Email`
                            )->tag( `Input`
                                )->a( n = `value` v = client->_bind( email )
                                )->a( n = `type`  v = `Email`
                            )->tag( `Label`
                                )->a( n = `text` v = `Tel.`
                            )->tag( `Input`
                                )->a( n = `value` v = client->_bind( tel )
                                )->a( n = `type`  v = `Tel`
                            )->tag( n = `Title` ns = `core`
                                )->a( n = `text` v = `Other`
                            )->tag( `Label`
                                )->a( n = `text` v = `SMS`
                            )->tag( `Input`
                                )->a( n = `value` v = client->_bind( sms )
                                )->a( n = `type`  v = `Tel`
                            )->tag( `Label`
                                )->a( n = `text` v = `Mobile`
                            )->tag( `Input`
                                )->a( n = `value` v = client->_bind( mobile )
                                )->a( n = `type`  v = `Tel`
                            )->tag( `Label`
                                )->a( n = `text` v = `Pager`
                            )->tag( `Input`
                                )->a( n = `value` v = client->_bind( pager )
                                )->a( n = `type`  v = `Tel`
                            )->tag( `Label`
                                )->a( n = `text` v = `Fax`
                            )->tag( `Input`
                                )->a( n = `value` v = client->_bind( fax )
                                )->a( n = `type`  v = `Tel` ).

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
