CLASS z2ui5_cl_ai_app_142 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_ai_app_142 IMPLEMENTATION.

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
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:f`    v = `sap.ui.layout.form`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->open( n = `Form` ns = `f`
                )->a( n = `id`            v = `FormToolbar`
                )->a( n = `editable`      v = `true`
                )->a( n = `ariaLabelledBy` v = `Title1`

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

                )->open( n = `layout` ns = `f`
                    )->leaf( n = `ResponsiveGridLayout` ns = `f`
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

                )->shut(

                )->open( n = `formContainers` ns = `f`

                    )->open( n = `FormContainer` ns = `f`
                        )->a( n = `ariaLabelledBy` v = `Title2`
                        )->open( n = `toolbar` ns = `f`
                            )->open( `Toolbar`
                                )->leaf( `Title`
                                    )->a( n = `id`   v = `Title2`
                                    )->a( n = `text` v = `Office`
                                )->leaf( `ToolbarSpacer`
                                )->leaf( `Button`
                                    )->a( n = `icon` v = `sap-icon://settings`

                        )->shut(
                        )->shut(

                        )->open( n = `formElements` ns = `f`
                            )->open( n = `FormElement` ns = `f`
                                )->a( n = `label` v = `Name`
                                )->open( n = `fields` ns = `f`
                                    )->leaf( `Input`
                                        )->a( n = `value` v = `{SUPPLIERNAME}`
                                        )->a( n = `id`    v = `name`

                            )->shut(
                            )->shut(
                            )->open( n = `FormElement` ns = `f`
                                )->a( n = `label` v = `Street`
                                )->open( n = `fields` ns = `f`
                                    )->leaf( `Input`
                                        )->a( n = `value` v = `{STREET}`
                                    )->open( `Input`
                                        )->a( n = `value` v = `{HOUSENUMBER}`
                                        )->open( `layoutData`
                                            )->leaf( n = `GridData` ns = `l`
                                                )->a( n = `span` v = `XL2 L1 M3 S4`

                                    )->shut(
                                    )->shut(
                            )->shut(
                            )->shut(
                            )->open( n = `FormElement` ns = `f`
                                )->a( n = `label` v = `ZIP Code/City`
                                )->open( n = `fields` ns = `f`
                                    )->open( `Input`
                                        )->a( n = `value` v = `{ZIPCODE}`
                                        )->open( `layoutData`
                                            )->leaf( n = `GridData` ns = `l`
                                                )->a( n = `span` v = `XL2 L1 M3 S4`

                                    )->shut(
                                    )->shut(
                                    )->leaf( `Input`
                                        )->a( n = `value` v = `{CITY}`

                            )->shut(
                            )->shut(
                            )->open( n = `FormElement` ns = `f`
                                )->a( n = `label` v = `Country`
                                )->open( n = `fields` ns = `f`
                                    )->open( `Select`
                                        )->a( n = `width`       v = `100%`
                                        )->a( n = `id`          v = `country`
                                        )->a( n = `selectedKey` v = `{COUNTRY}`
                                        )->leaf( n = `Item` ns = `core`
                                            )->a( n = `text` v = `Germany`
                                            )->a( n = `key`  v = `Germany`
                                        )->leaf( n = `Item` ns = `core`
                                            )->a( n = `text` v = `USA`
                                            )->a( n = `key`  v = `USA`
                                        )->leaf( n = `Item` ns = `core`
                                            )->a( n = `text` v = `England`
                                            )->a( n = `key`  v = `England`

                            )->shut(
                            )->shut(
                            )->shut(
                        )->shut(
                    )->shut(

                    )->open( n = `FormContainer` ns = `f`
                        )->a( n = `ariaLabelledBy` v = `Title3`
                        )->open( n = `toolbar` ns = `f`
                            )->open( `Toolbar`
                                )->leaf( `Title`
                                    )->a( n = `id`   v = `Title3`
                                    )->a( n = `text` v = `Online`
                                )->leaf( `ToolbarSpacer`
                                )->leaf( `Button`
                                    )->a( n = `icon` v = `sap-icon://settings`

                        )->shut(
                        )->shut(

                        )->open( n = `formElements` ns = `f`
                            )->open( n = `FormElement` ns = `f`
                                )->a( n = `label` v = `Web`
                                )->open( n = `fields` ns = `f`
                                    )->leaf( `Input`
                                        )->a( n = `value` v = `{URL}`
                                        )->a( n = `type`  v = `Url`
                                        )->a( n = `id`    v = `url`

                            )->shut(
                            )->shut(
                            )->open( n = `FormElement` ns = `f`
                                )->a( n = `label` v = `Twitter`
                                )->open( n = `fields` ns = `f`
                                    )->leaf( `Input`
                                        )->a( n = `value` v = `{TWITTER}`
                                        )->a( n = `id`    v = `twitter` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " original binds /SupplierCollection/0 from the shared demo supplier.json;
    " flattened here to top-level fields the {…} form bindings resolve against.
    suppliername = `Titanium`.
    street       = `Star Street`.
    housenumber  = `12`.
    zipcode      = `12345`.
    city         = `Walldorf`.
    country      = `Germany`.
    url          = `http://www.sap.com`.
    twitter      = `@sap`.

  ENDMETHOD.

ENDCLASS.
