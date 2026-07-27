CLASS z2ui5_cl_ai_app_251 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_ai_app_251 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " Page variant: one SmartVariantManagement in front of the page owns the
    " persistency (PageVariantPKey) and both smart controls register with it
    " through their smartVariant association, each contributing its own
    " persistencyKey. Everything below is metadata-driven - no model data.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`                        v = `sap.m`
        )->a( n = `xmlns:mvc`                    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:html`                   v = `http://www.w3.org/1999/xhtml`
        )->a( n = `xmlns:smartVariantManagement` v = `sap.ui.comp.smartvariants`
        )->a( n = `xmlns:smartFilterBar`         v = `sap.ui.comp.smartfilterbar`
        )->a( n = `xmlns:smartTable`             v = `sap.ui.comp.smarttable`
        )->a( n = `xmlns:core`                   v = `sap.ui.core`

        )->open( `HBox`
            )->a( n = `class` v = `exPageVariantPadding`

            )->leaf( n = `SmartVariantManagement` ns = `smartVariantManagement`
                )->a( n = `id`             v = `pageVariantId`
                )->a( n = `persistencyKey` v = `PageVariantPKey`

        )->shut(
        )->open( n = `SmartFilterBar` ns = `smartFilterBar`
            )->a( n = `id`                     v = `smartFilterBar`
            )->a( n = `entitySet`              v = `ProductSet`
            )->a( n = `persistencyKey`         v = `SmartFilterPKey`
            " The tutorial's onFiltersChanged handler is not published, so there is no
            " original body to rebuild - but the original IS a controller function, i.e.
            " client-side. The wire therefore stays roundtrip-free (control_global
            " MESSAGE_TOAST): a backend round-trip fired in the middle of the variant /
            " filter handshake is exactly what a smart control does not expect.
            )->a( n = `assignedFiltersChanged` v = client->_event_client( val   = client->cs_event-control_global
                                                                          t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Assigned filters changed` ) ) )

            " Page variant + SmartFilterBar, the wiring the SAPUI5 docs describe
            " ("Smart Variant Management", Page Variants): the PAGE variant's key
            " reaches the filter bar through the pageVariantPersistencyKey custom data
            " - the persistencyKey property above only names this control's slice of
            " the stored data. The filter bar then adapts the related SmartTable
            " itself, "and therefore, the smartVariant association doesn't have to be
            " assigned" - which is why neither control carries it here, unlike the
            " tutorial's published view.
            )->open( n = `customData` ns = `smartFilterBar`
                )->leaf( n = `CustomData` ns = `core`
                    )->a( n = `key`   v = `pageVariantPersistencyKey`
                    )->a( n = `value` v = `PageVariantPKey`

            )->shut(
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
            " GWSAMPLE_BASIC carries no UI.LineItem annotation, and without one a
            " SmartTable starts with NO columns at all ("add columns to see the
            " content") - the initially visible fields have to be named. Not part of
            " the sample's view, which gets its four columns from its own annotation.
            )->a( n = `initiallyVisibleFields`  v = `ProductID,Name,Category,SupplierName,Price`
            )->a( n = `useVariantManagement`    v = `true`
            )->a( n = `useTablePersonalisation` v = `true`
            )->a( n = `header`                  v = `Products`
            )->a( n = `showRowCount`            v = `true`
            )->a( n = `enableExport`            v = `false`
            )->a( n = `enableAutoBinding`       v = `true`
            )->a( n = `persistencyKey`          v = `SmartTablePKey` ).

    client->view_display( val                       = view->stringify( )
                          switch_default_model_path = c_odata_service ).

  ENDMETHOD.

ENDCLASS.
