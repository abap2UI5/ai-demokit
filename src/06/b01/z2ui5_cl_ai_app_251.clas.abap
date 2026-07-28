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

        )->open( `HBox`
            )->a( n = `class` v = `exPageVariantPadding`

            )->leaf( n = `SmartVariantManagement` ns = `smartVariantManagement`
                )->a( n = `id`             v = `pageVariantId`
                )->a( n = `persistencyKey` v = `PageVariantPKey`

        )->shut(
        )->open( n = `SmartFilterBar` ns = `smartFilterBar`
            )->a( n = `id`                     v = `smartFilterBar`
            )->a( n = `entitySet`              v = `ProductSet`
            )->a( n = `smartVariant`           v = `pageVariantId`
            )->a( n = `persistencyKey`         v = `SmartFilterPKey`
            " The tutorial's onFiltersChanged handler is not published, so there is no
            " original body to rebuild - but the original IS a controller function, i.e.
            " client-side. The wire therefore stays roundtrip-free (control_global
            " MESSAGE_TOAST): a backend round-trip fired in the middle of the variant /
            " filter handshake is exactly what a smart control does not expect.
            )->a( n = `assignedFiltersChanged` v = client->_event_client( val   = client->cs_event-control_global
                                                                          t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Assigned filters changed` ) ) )

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
            )->a( n = `smartVariant`            v = `pageVariantId`
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

    " The handshake a controller would do: without initialise( ) the page variant
    " never gets a personalizable control, so saving a view dies in sap.ui.fl and
    " stored views are never loaded (measured 2026-07-28; the action waits for the
    " smart controls to register, which they do once their metadata has arrived).
    client->follow_up_action( val   = client->cs_event-smart_variant_init
                              t_arg = VALUE #( ( `pageVariantId` ) ( `smartFilterBar` ) ) ).

  ENDMETHOD.

ENDCLASS.
