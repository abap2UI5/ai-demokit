CLASS z2ui5_cl_ai_app_249 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    " Smart controls read their metadata from an OData V2 service. The tutorial
    " serves the step's metadata.xml (archived beside the template in
    " ui5/sap.ui.comp/SmartForm/) from a local mock server; in an ABAP system
    " the default model is switched to a Gateway service exposing the same
    " Products entity set - adapt the path to the service in your system.
    CONSTANTS c_odata_service TYPE string VALUE `/sap/opu/odata/sap/Z2UI5_SMART_TUT_04_SRV/`.

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
        )->a( n = `binding`          v = `{/Products('4711')}`

        )->open( n = `SmartForm` ns = `smartForm`
            )->a( n = `id`            v = `smartForm`
            )->a( n = `editTogglable` v = `true`
            )->a( n = `title`         v = `{Name}`
            )->a( n = `flexEnabled`   v = `false`

            )->open( n = `Group` ns = `smartForm`
                )->a( n = `label` v = `Product`

                )->open( n = `GroupElement` ns = `smartForm`
                    )->leaf( n = `SmartField` ns = `smartField`
                        )->a( n = `value` v = `{ProductId}`

                )->shut(
                )->open( n = `GroupElement` ns = `smartForm`
                    )->leaf( n = `SmartField` ns = `smartField`
                        )->a( n = `value` v = `{Name}`

                )->shut(
                )->open( n = `GroupElement` ns = `smartForm`
                    )->a( n = `elementForLabel` v = `1`

                    )->leaf( n = `SmartField` ns = `smartField`
                        )->a( n = `value` v = `{CategoryName}`
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
