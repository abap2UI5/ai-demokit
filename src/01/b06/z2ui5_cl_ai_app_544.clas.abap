CLASS z2ui5_cl_ai_app_544 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_supplier,
        supplier_name TYPE string,
        street        TYPE string,
        house_number  TYPE string,
        zip_code      TYPE string,
        city          TYPE string,
        country       TYPE string,
      END OF ty_s_supplier.
    DATA t_suppliers TYPE STANDARD TABLE OF ty_s_supplier WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_544 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " the single record of the shared mock supplier.json /SupplierCollection, bound columns only
    t_suppliers = VALUE #(
      ( supplier_name = `Red Point Stores`
        street        = `Main St`
        house_number  = `1618`
        zip_code      = `31415`
        city          = `Maintown`
        country       = `Germany` ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->open( n = `content` ns = `l`
                " element binding to the first supplier record, like the original's binding="{/SupplierCollection/0}"
                )->open( `List`
                    )->a( n = `binding`    v = |\{{ client->_bind( val = t_suppliers path = abap_true ) }/0\}|
                    )->a( n = `headerText` v = `Address`

                    )->leaf( `DisplayListItem`
                        )->a( n = `label` v = `Name`
                        )->a( n = `value` v = `{SUPPLIER_NAME}`
                    )->leaf( `DisplayListItem`
                        )->a( n = `label` v = `Street`
                        )->a( n = `value` v = `{STREET} {HOUSE_NUMBER}`
                    )->leaf( `DisplayListItem`
                        )->a( n = `label` v = `City`
                        )->a( n = `value` v = `{ZIP_CODE} {CITY}`
                        )->a( n = `type`  v = `Navigation`
                    )->leaf( `DisplayListItem`
                        )->a( n = `label` v = `Country`
                        )->a( n = `value` v = `{COUNTRY}`
                        )->a( n = `type`  v = `Navigation` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
