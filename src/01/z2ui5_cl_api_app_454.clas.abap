"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.MultiInput - MultiInput
"! https://sdk.openui5.org/entity/sap.m.MultiInput/sample/sap.m.sample.MultiInput
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
        )->attr( n = `xmlns`      v = `sap.m`
        )->attr( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->attr( n = `xmlns:l`    v = `sap.ui.layout`
        )->attr( n = `xmlns:core` v = `sap.ui.core`

        )->open( n = `VerticalLayout` ns = `l`
            )->attr( n = `class` v = `sapUiContentPadding`
            )->attr( n = `width` v = `100%`

            )->leaf( `Label`
                )->attr( n = `text`     v = `Enter a search term, e.g. “Notebook”, and add matching products as tokens`
                )->attr( n = `width`    v = `100%`
                )->attr( n = `labelFor` v = `multiInput`

            )->open( `MultiInput`
                )->attr( n = `width`           v = `70%`
                )->attr( n = `id`              v = `multiInput`
                )->attr( n = `suggestionItems` v = client->_bind( t_products )
                )->attr( n = `placeholder`     v = `Products...`
                )->attr( n = `showValueHelp`   v = `false`

                )->leaf( n = `Item` ns = `core`
                    )->attr( n = `key`  v = `{PRODUCT_ID}`
                    )->attr( n = `text` v = `{NAME}`

            )->shut(
            )->leaf( `Label`
                )->attr( n = `text`     v = `MultiInput with pre-selected tokens`
                )->attr( n = `labelFor` v = `multiInput1`
            )->leaf( `MultiInput`
                )->attr( n = `id`             v = `multiInput1`
                )->attr( n = `showSuggestion` v = `false`
                )->attr( n = `width`          v = `70%`
                )->attr( n = `showValueHelp`  v = `false`
            )->leaf( `Label`
                )->attr( n = `text`     v = `MultiInput with single long token`
                )->attr( n = `labelFor` v = `multiInput2`
            )->leaf( `MultiInput`
                )->attr( n = `id`             v = `multiInput2`
                )->attr( n = `showSuggestion` v = `false`
                )->attr( n = `width`          v = `300px`
                )->attr( n = `showValueHelp`  v = `false` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
