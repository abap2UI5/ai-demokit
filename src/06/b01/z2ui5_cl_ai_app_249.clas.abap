CLASS z2ui5_cl_ai_app_249 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    " Smart controls build their UI from OData V2 metadata. The tutorial serves
    " its own metadata.xml from a local mock server (archived beside the template
    " in ui5/sap.ui.comp/SmartForm/) - an ABAP system cannot reproduce that, so the
    " port reads the SAP Gateway demo service GWSAMPLE_BASIC (EPM products)
    " instead: it ships with every on-premise system and only has to be activated
    " once in /IWFND/MAINT_SERVICE. Its entity set is ProductSet, which is why the
    " sample's Products entity set and two of its field names are mapped onto it.
    CONSTANTS c_odata_service TYPE string VALUE `/sap/opu/odata/IWBEP/GWSAMPLE_BASIC/`.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_249 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " The original controller binds one product record onto the page that hosts
    " the form (byId("smartFormPage").bindElement("/Products('4711')")). abap2UI5
    " has no controller, so the element binding is declared on the view root -
    " every SmartField binding ({ProductId}, {Name}, ...) and the form title
    " {Name} are relative to it. The path is an OData entity path, not a path
    " into an ABAP-fed model, so no client->_bind( ) variable backs it.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`            v = `sap.m`
        )->a( n = `xmlns:mvc`        v = `sap.ui.core.mvc`
        )->a( n = `xmlns:smartForm`  v = `sap.ui.comp.smartform`
        )->a( n = `xmlns:smartField` v = `sap.ui.comp.smartfield`
        )->a( n = `binding`          v = `{/ProductSet('HT-1000')}`

        )->open( n = `SmartForm` ns = `smartForm`
            )->a( n = `id`            v = `smartForm`
            )->a( n = `editTogglable` v = `true`
            )->a( n = `title`         v = `{Name}`
            )->a( n = `flexEnabled`   v = `false`

            )->open( n = `Group` ns = `smartForm`
                )->a( n = `label` v = `Product`

                )->open( n = `GroupElement` ns = `smartForm`
                    )->leaf( n = `SmartField` ns = `smartField`
                        )->a( n = `value` v = `{ProductID}`

                )->shut(
                )->open( n = `GroupElement` ns = `smartForm`
                    )->leaf( n = `SmartField` ns = `smartField`
                        )->a( n = `value` v = `{Name}`

                )->shut(
                )->open( n = `GroupElement` ns = `smartForm`
                    )->a( n = `elementForLabel` v = `1`

                    )->leaf( n = `SmartField` ns = `smartField`
                        )->a( n = `value` v = `{Category}`
                    )->leaf( n = `SmartField` ns = `smartField`
                        )->a( n = `value` v = `{Description}`

                )->shut(
                )->open( n = `GroupElement` ns = `smartForm`
                    )->leaf( n = `SmartField` ns = `smartField`
                        )->a( n = `value` v = `{Price}`

                )->shut(
            )->shut(
            )->open( n = `Group` ns = `smartForm`
                )->a( n = `label` v = `Supplier`

                )->open( n = `GroupElement` ns = `smartForm`
                    )->leaf( n = `SmartField` ns = `smartField`
                        )->a( n = `value` v = `{SupplierName}` ).

    client->view_display( val                       = view->stringify( )
                          switch_default_model_path = c_odata_service ).

  ENDMETHOD.

ENDCLASS.
