CLASS z2ui5_cl_smpc_app_142 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA suppliername TYPE string.
    DATA street       TYPE string.
    DATA housenumber  TYPE string.
    DATA zipcode      TYPE string.
    DATA city         TYPE string.
    DATA country      TYPE string.
    DATA url          TYPE string.
    DATA twitter      TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_142 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:f`    v = `sap.ui.layout.form`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( n = `Form` ns = `f`
                )->a( n = `id`            v = `FormToolbar`
                )->a( n = `editable`      v = `true`
                )->a( n = `ariaLabelledBy` v = `Title1`

                )->ele( n = `toolbar` ns = `f`
                    )->ele( `Toolbar`
                        )->a( n = `id` v = `TB1`
                        )->tag( `Title`
                            )->a( n = `id`   v = `Title1`
                            )->a( n = `text` v = `Address`
                        )->tag( `ToolbarSpacer`
                        )->tag( `Button`
                            )->a( n = `icon` v = `sap-icon://settings`
                        )->tag( `Button`
                            )->a( n = `icon` v = `sap-icon://drop-down-list`

                    )->end(
                )->end(

                )->ele( n = `layout` ns = `f`
                    )->tag( n = `ResponsiveGridLayout` ns = `f`
                        )->a( n = `labelSpanXL`             v = `4`
                        )->a( n = `labelSpanL`              v = `3`
                        )->a( n = `labelSpanM`              v = `4`
                        )->a( n = `labelSpanS`              v = `12`
                        )->a( n = `adjustLabelSpan`         v = `false`
                        )->a( n = `emptySpanXL`             v = `0`
                        )->a( n = `emptySpanL`              v = `4`
                        )->a( n = `emptySpanM`              v = `0`
                        )->a( n = `emptySpanS`              v = `0`
                        )->a( n = `columnsXL`              v = `2`
                        )->a( n = `columnsL`               v = `1`
                        )->a( n = `columnsM`               v = `1`
                        )->a( n = `singleContainerFullSize` v = `false`

                )->end(

                )->ele( n = `formContainers` ns = `f`

                    )->ele( n = `FormContainer` ns = `f`
                        )->a( n = `ariaLabelledBy` v = `Title2`
                        )->ele( n = `toolbar` ns = `f`
                            )->ele( `Toolbar`
                                )->tag( `Title`
                                    )->a( n = `id`   v = `Title2`
                                    )->a( n = `text` v = `Office`
                                )->tag( `ToolbarSpacer`
                                )->tag( `Button`
                                    )->a( n = `icon` v = `sap-icon://settings`

                            )->end(
                        )->end(

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
                                                )->a( n = `span` v = `XL2 L1 M3 S4`

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
                                                )->a( n = `span` v = `XL2 L1 M3 S4`

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
                                        )->a( n = `width`       v = `100%`
                                        )->a( n = `id`          v = `country`
                                        )->a( n = `selectedKey` v = client->_bind( country )
                                        )->tag( n = `Item` ns = `core`
                                            )->a( n = `text` v = `Germany`
                                            )->a( n = `key`  v = `Germany`
                                        )->tag( n = `Item` ns = `core`
                                            )->a( n = `text` v = `USA`
                                            )->a( n = `key`  v = `USA`
                                        )->tag( n = `Item` ns = `core`
                                            )->a( n = `text` v = `England`
                                            )->a( n = `key`  v = `England`

                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(

                    )->ele( n = `FormContainer` ns = `f`
                        )->a( n = `ariaLabelledBy` v = `Title3`
                        )->ele( n = `toolbar` ns = `f`
                            )->ele( `Toolbar`
                                )->tag( `Title`
                                    )->a( n = `id`   v = `Title3`
                                    )->a( n = `text` v = `Online`
                                )->tag( `ToolbarSpacer`
                                )->tag( `Button`
                                    )->a( n = `icon` v = `sap-icon://settings`

                            )->end(
                        )->end(

                        )->ele( n = `formElements` ns = `f`
                            )->ele( n = `FormElement` ns = `f`
                                )->a( n = `label` v = `Web`
                                )->ele( n = `fields` ns = `f`
                                    )->tag( `Input`
                                        )->a( n = `value` v = client->_bind( url )
                                        )->a( n = `type`  v = `Url`
                                        )->a( n = `id`    v = `url`

                                )->end(
                            )->end(
                            )->ele( n = `FormElement` ns = `f`
                                )->a( n = `label` v = `Twitter`
                                )->ele( n = `fields` ns = `f`
                                    )->tag( `Input`
                                        )->a( n = `value` v = client->_bind( twitter )
                                        )->a( n = `id`    v = `twitter` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " original binds /SupplierCollection/0 from the shared demo supplier.json;
    " flattened here to top-level fields the {...} form bindings resolve against.
    suppliername = `Red Point Stores`.
    street       = `Main St`.
    housenumber  = `1618`.
    zipcode      = `31415`.
    city         = `Maintown`.
    country      = `Germany`.
    url          = `http://www.sap.com`.
    twitter      = `@sap`.

  ENDMETHOD.

ENDCLASS.
