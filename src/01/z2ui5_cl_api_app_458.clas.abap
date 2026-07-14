"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.MultiInput - MultiInputMaxTokens
"! https://sdk.openui5.org/entity/sap.m.MultiInput/sample/sap.m.sample.MultiInputMaxTokens
CLASS z2ui5_cl_api_app_458 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name       TYPE string,
        product_id TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_458 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    t_products = VALUE #(
        ( name = `Notebook Basic 15`        product_id = `HT-1000` )
        ( name = `Notebook Basic 17`        product_id = `HT-1001` )
        ( name = `Notebook Basic 18`        product_id = `HT-1002` )
        ( name = `Notebook Basic 19`        product_id = `HT-1003` )
        ( name = `ITelO Vault`              product_id = `HT-1007` )
        ( name = `Notebook Professional 15` product_id = `HT-1010` )
        ( name = `Notebook Professional 17` product_id = `HT-1011` )
        ( name = `ITelO Vault Net`          product_id = `HT-1020` )
        ( name = `ITelO Vault SAT`          product_id = `HT-1021` )
        ( name = `Comfort Easy`             product_id = `HT-1022` )
        ( name = `Comfort Senior`           product_id = `HT-1023` )
        ( name = `Ergo Screen E-I`          product_id = `HT-1030` )
        ( name = `Flat Basic`               product_id = `HT-1035` )
        ( name = `Flat Future`              product_id = `HT-1036` ) ).

    " the original sorts the suggestion items by name via a model sorter - the data is sorted in ABAP instead
    SORT t_products BY name.

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(layout) = view->vertical_layout(
        class = `sapUiContentPadding`
        width = `100%` ).

    layout->label(
        text     = `No more than 2 products can be added`
        width    = `100%`
        labelfor = `multiInput1` ).

    " maxTokens is not part of the typed MultiInput method - built generically
    layout->_generic(
        name   = `MultiInput`
        t_prop = VALUE #( ( n = `id`              v = `multiInput1` )
                          ( n = `width`           v = `70%` )
                          ( n = `maxTokens`       v = `2` )
                          ( n = `showValueHelp`   v = `false` )
                          ( n = `suggestionItems` v = client->_bind( t_products ) ) )
        )->item(
            key  = `{PRODUCT_ID}`
            text = `{NAME}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
