CLASS z2ui5_cl_ai_app_248 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    " Smart controls read their metadata from an OData V2 service. The tutorial
    " serves the step's metadata.xml (archived beside the template in
    " ui5/sap.ui.comp/SmartField/) from a local mock server; in an ABAP system
    " the default model is switched to a Gateway service exposing the same
    " Products entity set - adapt the path to the service in your system.
    CONSTANTS c_odata_service TYPE string VALUE `/sap/opu/odata/sap/Z2UI5_SMART_TUT_01_SRV/`.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_248 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " The original controller binds the view to a single product record
    " (getView().bindElement("/Products('4711')")). abap2UI5 has no controller,
    " so the port declares the same element binding on the view root - the
    " SmartField's relative {Price} binding resolves against it. The path is an
    " OData entity path, not a path into an ABAP-fed model, so there is no
    " client->_bind( ) variable to derive it from.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`               v = `sap.m`
        )->a( n = `xmlns:smartForm`     v = `sap.ui.comp.smartform`
        )->a( n = `xmlns:mvc`           v = `sap.ui.core.mvc`
        )->a( n = `xmlns:sap.ui.layout` v = `sap.ui.layout`
        )->a( n = `xmlns:smartField`    v = `sap.ui.comp.smartfield`
        )->a( n = `binding`             v = `{/Products('4711')}`

        )->open( n = `SmartForm` ns = `smartForm`
            )->a( n = `editable` v = `true`

            )->open( n = `layout` ns = `smartForm`
                )->leaf( n = `ColumnLayout` ns = `smartForm`
                    )->a( n = `emptyCellsLarge` v = `4`
                    )->a( n = `labelCellsLarge` v = `4`
                    )->a( n = `columnsM`        v = `1`
                    )->a( n = `columnsL`        v = `1`
                    )->a( n = `columnsXL`       v = `1`

            )->shut(
            )->open( n = `Group` ns = `smartForm`
                )->open( n = `GroupElement` ns = `smartForm`
                    )->leaf( n = `SmartField` ns = `smartField`
                        )->a( n = `value` v = `{Price}`
                        )->a( n = `id`    v = `idPrice` ).

    client->view_display( val                       = view->stringify( )
                          switch_default_model_path = c_odata_service ).

  ENDMETHOD.

ENDCLASS.
