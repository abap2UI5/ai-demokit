CLASS z2ui5_cl_ai_app_452 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id    TYPE string,
        name          TYPE string,
        supplier_name TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_452 IMPLEMENTATION.

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

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->open( `MultiComboBox`
                )->a( n = `width` v = `500px`
                )->a( n = `items` v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'SUPPLIER_NAME', descending: false, group: true \} \}|

                )->leaf( n = `Item` ns = `core`
                    )->a( n = `key`  v = `{PRODUCT_ID}`
                    )->a( n = `text` v = `{NAME}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
