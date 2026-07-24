CLASS z2ui5_cl_ai_app_175 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_ai_app_175 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:f`    v = `sap.ui.layout.form`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->open( n = `SimpleForm` ns = `f`
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

                )->open( n = `toolbar` ns = `f`
                    )->open( `Toolbar`
                        )->a( n = `id` v = `TB1`
                        )->leaf( `Title`
                            )->a( n = `id`   v = `Title1`
                            )->a( n = `text` v = `Address`
                        )->leaf( `ToolbarSpacer`
                        )->leaf( `Button`
                            )->a( n = `icon` v = `sap-icon://settings`
                        )->leaf( `Button`
                            )->a( n = `icon` v = `sap-icon://drop-down-list`

                    )->shut(
                )->shut(

                )->open( n = `content` ns = `f`
                    )->open( `Toolbar`
                        )->a( n = `ariaLabelledBy` v = `Title2`
                        )->leaf( `Title`
                            )->a( n = `id`   v = `Title2`
                            )->a( n = `text` v = `Office`
                        )->leaf( `ToolbarSpacer`
                        )->leaf( `Button`
                            )->a( n = `icon` v = `sap-icon://settings`

                    )->shut(

                    )->leaf( `Label`
                        )->a( n = `text` v = `Name`
                    )->leaf( `Input`
                        )->a( n = `value` v = `{SUPPLIERNAME}`

                    )->leaf( `Label`
                        )->a( n = `text` v = `Street/No.`
                    )->leaf( `Input`
                        )->a( n = `value` v = `{STREET}`
                    )->open( `Input`
                        )->a( n = `value` v = `{HOUSENUMBER}`
                        )->open( `layoutData`
                            )->leaf( n = `GridData` ns = `l`
                                )->a( n = `span` v = `XL2 L1 M3 S4`

                    )->shut(
                    )->shut(

                    )->leaf( `Label`
                        )->a( n = `text` v = `ZIP Code/City`
                    )->open( `Input`
                        )->a( n = `value` v = `{ZIPCODE}`
                        )->open( `layoutData`
                            )->leaf( n = `GridData` ns = `l`
                                )->a( n = `span` v = `XL2 L1 M3 S4`

                    )->shut(
                    )->shut(
                    )->leaf( `Input`
                        )->a( n = `value` v = `{CITY}`

                    )->leaf( `Label`
                        )->a( n = `text` v = `Country`
                    )->open( `Select`
                        )->a( n = `id`          v = `country`
                        )->a( n = `selectedKey` v = `{COUNTRY}`
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

                    )->open( `Toolbar`
                        )->a( n = `ariaLabelledBy` v = `Title3`
                        )->leaf( `Title`
                            )->a( n = `id`   v = `Title3`
                            )->a( n = `text` v = `Online`
                        )->leaf( `ToolbarSpacer`
                        )->leaf( `Button`
                            )->a( n = `icon` v = `sap-icon://settings`

                    )->shut(

                    )->leaf( `Label`
                        )->a( n = `text` v = `Web`
                    )->leaf( `Input`
                        )->a( n = `value` v = `{URL}`
                        )->a( n = `type`  v = `Url`

                    )->leaf( `Label`
                        )->a( n = `text` v = `Twitter`
                    )->leaf( `Input`
                        )->a( n = `value` v = `{TWITTER}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " original controller sets /SupplierCollection/0 via bindElement from the
    " shared demo supplier.json; flattened here to top-level model fields the
    " {…} form bindings resolve against (values are supplier.json row 0)
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
