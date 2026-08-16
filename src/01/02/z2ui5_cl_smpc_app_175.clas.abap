CLASS z2ui5_cl_smpc_app_175 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smpc_app_175 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:f`    v = `sap.ui.layout.form`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( n = `SimpleForm` ns = `f`
                )->a( n = `id`                      v = `SimpleFormToolbar`
                )->a( n = `editable`                v = `true`
                )->a( n = `layout`                  v = `ResponsiveGridLayout`
                )->a( n = `labelSpanXL`             v = `4`
                )->a( n = `labelSpanL`              v = `3`
                )->a( n = `labelSpanM`              v = `4`
                )->a( n = `labelSpanS`              v = `12`
                )->a( n = `adjustLabelSpan`         v = `false`
                )->a( n = `emptySpanXL`             v = `0`
                )->a( n = `emptySpanL`              v = `4`
                )->a( n = `emptySpanM`              v = `0`
                )->a( n = `emptySpanS`              v = `0`
                )->a( n = `columnsXL`               v = `2`
                )->a( n = `columnsL`                v = `1`
                )->a( n = `columnsM`                v = `1`
                )->a( n = `singleContainerFullSize` v = `false`
                )->a( n = `ariaLabelledBy`          v = `Title1`

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

                )->ele( n = `content` ns = `f`
                    )->ele( `Toolbar`
                        )->a( n = `ariaLabelledBy` v = `Title2`
                        )->tag( `Title`
                            )->a( n = `id`   v = `Title2`
                            )->a( n = `text` v = `Office`
                        )->tag( `ToolbarSpacer`
                        )->tag( `Button`
                            )->a( n = `icon` v = `sap-icon://settings`

                    )->end(

                    )->tag( `Label`
                        )->a( n = `text` v = `Name`
                    )->tag( `Input`
                        )->a( n = `value` v = client->_bind( suppliername )

                    )->tag( `Label`
                        )->a( n = `text` v = `Street/No.`
                    )->tag( `Input`
                        )->a( n = `value` v = client->_bind( street )
                    )->ele( `Input`
                        )->a( n = `value` v = client->_bind( housenumber )
                        )->ele( `layoutData`
                            )->tag( n = `GridData` ns = `l`
                                )->a( n = `span` v = `XL2 L1 M3 S4`

                        )->end(
                    )->end(

                    )->tag( `Label`
                        )->a( n = `text` v = `ZIP Code/City`
                    )->ele( `Input`
                        )->a( n = `value` v = client->_bind( zipcode )
                        )->ele( `layoutData`
                            )->tag( n = `GridData` ns = `l`
                                )->a( n = `span` v = `XL2 L1 M3 S4`

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

                    )->ele( `Toolbar`
                        )->a( n = `ariaLabelledBy` v = `Title3`
                        )->tag( `Title`
                            )->a( n = `id`   v = `Title3`
                            )->a( n = `text` v = `Online`
                        )->tag( `ToolbarSpacer`
                        )->tag( `Button`
                            )->a( n = `icon` v = `sap-icon://settings`

                    )->end(

                    )->tag( `Label`
                        )->a( n = `text` v = `Web`
                    )->tag( `Input`
                        )->a( n = `value` v = client->_bind( url )
                        )->a( n = `type`  v = `Url`

                    )->tag( `Label`
                        )->a( n = `text` v = `Twitter`
                    )->tag( `Input`
                        )->a( n = `value` v = client->_bind( twitter ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " original controller sets /SupplierCollection/0 via bindElement from the
    " shared demo supplier.json; flattened here to top-level model fields the
    " {...} form bindings resolve against (values are supplier.json row 0)
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
