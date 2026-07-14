"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiInput/sample/sap.m.sample.MultiInput
"! MultiInput provides functionality to add / remove / enter tokens.
CLASS z2ui5_cl_api_app_454 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id TYPE string,
        name       TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS data_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_454 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      data_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD data_init.

    t_products = VALUE #(
      ( product_id = `HT-1000` name = `Notebook Basic 15` )
      ( product_id = `HT-1001` name = `Notebook Basic 17` )
      ( product_id = `HT-1002` name = `Notebook Basic 18` )
      ( product_id = `HT-1003` name = `Notebook Basic 19` )
      ( product_id = `HT-1007` name = `ITelO Vault` )
      ( product_id = `HT-1010` name = `Notebook Professional 15` )
      ( product_id = `HT-1011` name = `Notebook Professional 17` )
      ( product_id = `HT-1020` name = `ITelO Vault Net` )
      ( product_id = `HT-1021` name = `ITelO Vault SAT` )
      ( product_id = `HT-1022` name = `Comfort Easy` )
      ( product_id = `HT-1023` name = `Comfort Senior` )
      ( product_id = `HT-1030` name = `Ergo Screen E-I` )
      ( product_id = `HT-1031` name = `Ergo Screen E-II` )
      ( product_id = `HT-1032` name = `Ergo Screen E-III` )
      ( product_id = `HT-1035` name = `Flat Basic` )
      ( product_id = `HT-1036` name = `Flat Future` ) ).
    SORT t_products BY name.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    " showClearIcon (UI5 1.94) is omitted to stay compatible with UI5 1.71
    view->open( n = `View` ns = `mvc`
                a = VALUE #( ( n = `xmlns`      v = `sap.m` )
                             ( n = `xmlns:mvc`  v = `sap.ui.core.mvc` )
                             ( n = `xmlns:l`    v = `sap.ui.layout` )
                             ( n = `xmlns:core` v = `sap.ui.core` ) )

       )->open( n = `VerticalLayout` ns = `l`
                a = VALUE #( ( n = `class` v = `sapUiContentPadding` )
                             ( n = `width` v = `100%` ) )

          )->leaf( n = `Label`
                   a = VALUE #( ( n = `text`     v = `Enter a search term, e.g. “Notebook”, and add matching products as tokens` )
                                ( n = `width`    v = `100%` )
                                ( n = `labelFor` v = `multiInput` ) )
          )->open( n = `MultiInput`
                   a = VALUE #( ( n = `width`           v = `70%` )
                                ( n = `id`              v = `multiInput` )
                                ( n = `suggestionItems` v = client->_bind( t_products ) )
                                ( n = `placeholder`     v = `Products...` )
                                ( n = `showValueHelp`   v = `false` ) )

             )->leaf( n = `Item` ns = `core`
                      a = VALUE #( ( n = `key`  v = `{PRODUCT_ID}` )
                                   ( n = `text` v = `{NAME}` ) )
          )->shut(
          )->leaf( n = `Label`
                   a = VALUE #( ( n = `text`     v = `MultiInput with pre-selected tokens` )
                                ( n = `labelFor` v = `multiInput1` ) )
          )->leaf( n = `MultiInput`
                   a = VALUE #( ( n = `id`             v = `multiInput1` )
                                ( n = `showSuggestion` v = `false` )
                                ( n = `width`          v = `70%` )
                                ( n = `showValueHelp`  v = `false` ) )
          )->leaf( n = `Label`
                   a = VALUE #( ( n = `text`     v = `MultiInput with single long token` )
                                ( n = `labelFor` v = `multiInput2` ) )
          )->leaf( n = `MultiInput`
                   a = VALUE #( ( n = `id`             v = `multiInput2` )
                                ( n = `showSuggestion` v = `false` )
                                ( n = `width`          v = `300px` )
                                ( n = `showValueHelp`  v = `false` ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
