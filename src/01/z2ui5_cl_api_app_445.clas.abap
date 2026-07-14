"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.List - ListNoData
"! https://sdk.openui5.org/entity/sap.m.List/sample/sap.m.sample.ListNoData
CLASS z2ui5_cl_api_app_445 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_445 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->attr( n = `xmlns:l`   v = `sap.ui.layout`
        )->attr( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->attr( n = `xmlns`     v = `sap.m`

        )->leaf( `List`
            )->attr( n = `headerText` v = `Products`
            )->attr( n = `noDataText` v = |No products found!\nPlease change your filter settings.| ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
