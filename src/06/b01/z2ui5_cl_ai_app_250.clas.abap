CLASS z2ui5_cl_ai_app_250 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    " Smart controls build their UI from OData V2 metadata. The tutorial serves
    " its own metadata.xml from a local mock server (archived beside the template
    " in ui5/sap.ui.comp/SmartTable/) - an ABAP system cannot reproduce that, so the
    " port reads the SAP Gateway demo service GWSAMPLE_BASIC (EPM products)
    " instead: it ships with every on-premise system and only has to be activated
    " once in /IWFND/MAINT_SERVICE. Its entity set is ProductSet, which is why the
    " sample's Products entity set is mapped onto it.
    CONSTANTS c_odata_service TYPE string VALUE `/sap/opu/odata/IWBEP/GWSAMPLE_BASIC/`.

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
            )->a( n = `entitySet` v = `ProductSet`

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
            )->a( n = `entitySet`               v = `ProductSet`
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
