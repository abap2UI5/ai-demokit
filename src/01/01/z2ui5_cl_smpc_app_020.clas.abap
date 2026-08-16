" @keywords displaylistitem display list item sap.m represent label
" @summary Use the Display List Item for showing name/value pairs.
CLASS z2ui5_cl_smpc_app_020 DEFINITION PUBLIC.

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

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_020 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->ele( n = `content` ns = `l`
                " element binding to the first supplier record, like the original's binding="{/SupplierCollection/0}"
                )->ele( `List`
                    )->a( n = `binding`    v = |\{{ client->_bind( val = t_suppliers path = abap_true ) }/0\}|
                    )->a( n = `headerText` v = `Address`

                    )->tag( `DisplayListItem`
                        )->a( n = `label` v = `Name`
                        )->a( n = `value` v = `{SUPPLIER_NAME}`
                    )->tag( `DisplayListItem`
                        )->a( n = `label` v = `Street`
                        )->a( n = `value` v = `{STREET} {HOUSE_NUMBER}`
                    )->tag( `DisplayListItem`
                        )->a( n = `label` v = `City`
                        )->a( n = `value` v = `{ZIP_CODE} {CITY}`
                        )->a( n = `type`  v = `Navigation`
                    )->tag( `DisplayListItem`
                        )->a( n = `label` v = `Country`
                        )->a( n = `value` v = `{COUNTRY}`
                        )->a( n = `type`  v = `Navigation` ).

    client->view_display( view->stringify( ) ).

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

ENDCLASS.
