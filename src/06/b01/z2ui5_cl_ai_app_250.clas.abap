CLASS z2ui5_cl_ai_app_250 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    " Smart controls read their metadata from an OData V2 service. The tutorial
    " serves the step's metadata.xml (archived beside the template in
    " ui5/sap.ui.comp/SmartTable/) from a local mock server; in an ABAP system
    " the default model is switched to a Gateway service exposing the same
    " Products entity set - adapt the path to the service in your system.
    " Columns, filters and value helps all come from that metadata: the
    " SmartTable builds its columns from the UI.LineItem annotation and the
    " SmartFilterBar its filter fields from the filterable properties.
    CONSTANTS c_odata_service TYPE string VALUE `/sap/opu/odata/sap/Z2UI5_SMART_TUT_05_SRV/`.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_250 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " No model data and no event wiring: the SmartTable binds itself
    " (enableAutoBinding) and reads the SmartFilterBar's conditions through the
    " smartFilterId association - the whole app is the view plus the service.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`                v = `sap.m`
        )->a( n = `xmlns:mvc`            v = `sap.ui.core.mvc`
        )->a( n = `xmlns:smartFilterBar` v = `sap.ui.comp.smartfilterbar`
        )->a( n = `xmlns:smartTable`     v = `sap.ui.comp.smarttable`

        )->open( n = `SmartFilterBar` ns = `smartFilterBar`
            )->a( n = `id`        v = `smartFilterBar`
            )->a( n = `entitySet` v = `Products`

            )->open( n = `controlConfiguration` ns = `smartFilterBar`
                )->leaf( n = `ControlConfiguration` ns = `smartFilterBar`
                    )->a( n = `key`                                      v = `Category`
                    )->a( n = `visibleInAdvancedArea`                    v = `true`
                    )->a( n = `preventInitialDataFetchInValueHelpDialog` v = `false`

            )->shut(
        )->shut(
        )->leaf( n = `SmartTable` ns = `smartTable`
            )->a( n = `id`                      v = `smartTable_ResponsiveTable`
            )->a( n = `smartFilterId`           v = `smartFilterBar`
            )->a( n = `tableType`               v = `ResponsiveTable`
            )->a( n = `editable`                v = `false`
            )->a( n = `entitySet`               v = `Products`
            )->a( n = `useVariantManagement`    v = `false`
            )->a( n = `useTablePersonalisation` v = `false`
            )->a( n = `header`                  v = `Products`
            )->a( n = `showRowCount`            v = `true`
            )->a( n = `enableExport`            v = `false`
            )->a( n = `enableAutoBinding`       v = `true` ).

    client->view_display( val                       = view->stringify( )
                          switch_default_model_path = c_odata_service ).

  ENDMETHOD.

ENDCLASS.
