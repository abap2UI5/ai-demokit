CLASS z2ui5_cl_dmo_app_312 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_dmo_app_312 IMPLEMENTATION.

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
                        )->leaf( `Button`
                            )->a( n = `id`      v = `edit`
                            )->a( n = `text`    v = `Edit`
                            " the original enables Edit once the mock request completes;
                            " the ABAP model is seeded synchronously, so it starts enabled
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
                        )->a( n = `id`       v = `FormDisplay354`
                        )->a( n = `editable` v = `false`

                        )->open( n = `title` ns = `f`
                            )->leaf( n = `Title` ns = `core`
                                )->a( n = `text` v = `Address`

                        )->shut(
                        )->open( n = `layout` ns = `f`
                            )->leaf( n = `ResponsiveGridLayout` ns = `f`
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

                        )->shut(
                        )->open( n = `formContainers` ns = `f`
                            )->open( n = `FormContainer` ns = `f`
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
                        )->a( n = `id`       v = `FormChange354`
                        )->a( n = `editable` v = `true`

                        )->open( n = `title` ns = `f`
                            )->leaf( n = `Title` ns = `core`
                                )->a( n = `text` v = `Address`

                        )->shut(
                        )->open( n = `layout` ns = `f`
                            )->leaf( n = `ResponsiveGridLayout` ns = `f`
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

                        )->shut(
                        )->open( n = `formContainers` ns = `f`
                            )->open( n = `FormContainer` ns = `f`
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
                                                    )->leaf( n = `GridData` ns = `l`
                                                        )->a( n = `span` v = `XL1 L2 M2 S4`

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
                                                    )->leaf( n = `GridData` ns = `l`
                                                        )->a( n = `span` v = `XL1 L2 M2 S4`

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
                                                        )->a( n = `key`  v = `USA` ).

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
