"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.MultiComboBox - MultiComboBoxGrouping
"! https://sdk.openui5.org/entity/sap.m.MultiComboBox/sample/sap.m.sample.MultiComboBoxGrouping
"! API USAGE AUDIT: (a) frontend_action (_event_client): NO | (b) event t_arg: NO
"! NOTES (generation):
"! - IMPROVISED: the original binds items with a model sorter (group: true) and a
"!   groupHeaderFactory, neither of which is expressible in abap2UI5 - so the
"!   grouped items are rendered statically as core:SeparatorItem headers +
"!   core:Item entries, built in a LOOP over the ABAP data instead of a bound
"!   aggregation.
CLASS z2ui5_cl_api_app_452 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    TYPES:
      BEGIN OF ty_s_product,
        product_id    TYPE string,
        name          TYPE string,
        supplier_name TYPE string,
      END OF ty_s_product.

    DATA client TYPE REF TO z2ui5_if_client.
    " not bound - the grouped items are rendered statically into the view (see
    " view_display); kept out of PUBLIC so the round-trip model scan stays small
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    METHODS model_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_452 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " Data of the mock model /ProductCollection used by the original sample
    t_products = VALUE #(
      ( product_id = `HT-1000` name = `Notebook Basic 15`        supplier_name = `Very Best Screens` )
      ( product_id = `HT-1001` name = `Notebook Basic 17`        supplier_name = `Very Best Screens` )
      ( product_id = `HT-1002` name = `Notebook Basic 18`        supplier_name = `Very Best Screens` )
      ( product_id = `HT-1003` name = `Notebook Basic 19`        supplier_name = `Smartcards` )
      ( product_id = `HT-1007` name = `ITelO Vault`              supplier_name = `Technocom` )
      ( product_id = `HT-1010` name = `Notebook Professional 15` supplier_name = `Very Best Screens` )
      ( product_id = `HT-1011` name = `Notebook Professional 17` supplier_name = `Very Best Screens` )
      ( product_id = `HT-1020` name = `ITelO Vault Net`          supplier_name = `Technocom` )
      ( product_id = `HT-1021` name = `ITelO Vault SAT`          supplier_name = `Technocom` )
      ( product_id = `HT-1022` name = `Comfort Easy`             supplier_name = `Technocom` )
      ( product_id = `HT-1023` name = `Comfort Senior`           supplier_name = `Technocom` )
      ( product_id = `HT-1030` name = `Ergo Screen E-I`          supplier_name = `Very Best Screens` )
      ( product_id = `HT-1031` name = `Ergo Screen E-II`         supplier_name = `Very Best Screens` )
      ( product_id = `HT-1032` name = `Ergo Screen E-III`        supplier_name = `Very Best Screens` )
      ( product_id = `HT-1035` name = `Flat Basic`               supplier_name = `Very Best Screens` )
      ( product_id = `HT-1036` name = `Flat Future`              supplier_name = `Very Best Screens` ) ).

    " the original groups the items by SupplierName - the data is sorted in ABAP
    " so the static group headers come out in the right order
    SORT t_products BY supplier_name.

  ENDMETHOD.


  METHOD view_display.

    DATA supplier TYPE string.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    DATA(combo) = view->open( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->open( `MultiComboBox`
                )->a( n = `width` v = `500px` ).

    " group header factory / sorter grouping is not available in abap2UI5 - insert
    " a core:SeparatorItem whenever the supplier changes, then the items below it
    LOOP AT t_products INTO DATA(s_product).

      IF s_product-supplier_name <> supplier.
        supplier = s_product-supplier_name.
        combo->leaf( n = `SeparatorItem` ns = `core`
            )->a( n = `text` v = s_product-supplier_name ).
      ENDIF.

      combo->leaf( n = `Item` ns = `core`
          )->a( n = `key`  v = s_product-product_id
          )->a( n = `text` v = s_product-name ).

    ENDLOOP.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
