" @keywords simpleform simple form sap.ui.layout.form simpleform354 bar button vbox label text input select
" @summary Form with one single group in a fullscreen app with a label field ratio of 3:5:4 in all sizes besides size S (12:12:0).
CLASS z2ui5_cl_smpc_app_325 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA edit_mode    TYPE abap_bool.
    DATA suppliername TYPE string.
    DATA street       TYPE string.
    DATA housenumber  TYPE string.
    DATA zipcode      TYPE string.
    DATA city         TYPE string.
    DATA country      TYPE string.

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

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_325 IMPLEMENTATION.

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
                        " the original enables Edit once the mock request completes; the ABAP model is seeded synchronously, so it starts enabled
                        )->tag( `Button`
                            )->a( n = `id`      v = `edit`
                            )->a( n = `text`    v = `Edit`
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
                        )->a( n = `id`                      v = `SimpleFormDisplay354`
                        )->a( n = `editable`                v = `false`
                        )->a( n = `layout`                  v = `ResponsiveGridLayout`
                        )->a( n = `title`                   v = `Address`
                        )->a( n = `labelSpanXL`             v = `3`
                        )->a( n = `labelSpanL`              v = `3`
                        )->a( n = `labelSpanM`              v = `3`
                        )->a( n = `labelSpanS`              v = `12`
                        )->a( n = `adjustLabelSpan`         v = `false`
                        )->a( n = `emptySpanXL`             v = `4`
                        )->a( n = `emptySpanL`              v = `4`
                        )->a( n = `emptySpanM`              v = `4`
                        )->a( n = `emptySpanS`              v = `0`
                        )->a( n = `columnsXL`               v = `1`
                        )->a( n = `columnsL`                v = `1`
                        )->a( n = `columnsM`                v = `1`
                        )->a( n = `singleContainerFullSize` v = `false`

                        )->ele( n = `content` ns = `f`
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

                        )->end(
                    )->end(
                )->end(
                " Change.fragment.xml
                )->ele( `VBox`
                    )->a( n = `class`   v = `sapUiSmallMargin`
                    )->a( n = `visible` v = client->_bind( edit_mode )

                    )->ele( n = `SimpleForm` ns = `f`
                        )->a( n = `id`                      v = `SimpleFormChange354`
                        )->a( n = `editable`                v = `true`
                        )->a( n = `layout`                  v = `ResponsiveGridLayout`
                        )->a( n = `title`                   v = `Address`
                        )->a( n = `labelSpanXL`             v = `3`
                        )->a( n = `labelSpanL`              v = `3`
                        )->a( n = `labelSpanM`              v = `3`
                        )->a( n = `labelSpanS`              v = `12`
                        )->a( n = `adjustLabelSpan`         v = `false`
                        )->a( n = `emptySpanXL`             v = `4`
                        )->a( n = `emptySpanL`              v = `4`
                        )->a( n = `emptySpanM`              v = `4`
                        )->a( n = `emptySpanS`              v = `0`
                        )->a( n = `columnsXL`               v = `1`
                        )->a( n = `columnsL`                v = `1`
                        )->a( n = `columnsM`                v = `1`
                        )->a( n = `singleContainerFullSize` v = `false`

                        )->ele( n = `content` ns = `f`
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
                                    )->tag( n = `GridData` ns = `l`
                                        )->a( n = `span` v = `XL1 L2 M2 S4`

                                )->end(
                            )->end(
                            )->tag( `Label`
                                )->a( n = `text` v = `ZIP Code/City`

                            )->ele( `Input`
                                )->a( n = `value` v = client->_bind( zipcode )

                                )->ele( `layoutData`
                                    )->tag( n = `GridData` ns = `l`
                                        )->a( n = `span` v = `XL1 L2 M2 S4`

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
                                        )->a( n = `key`  v = `USA` ).

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

  ENDMETHOD.

ENDCLASS.
