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
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->leaf( `Label`
                )->a( n = `text`     v = `Enter a search term, e.g. “Notebook”, and add matching products as tokens`
                )->a( n = `width`    v = `100%`
                )->a( n = `labelFor` v = `multiInput`

            )->open( `MultiInput`
                )->a( n = `width`           v = `70%`
                )->a( n = `id`              v = `multiInput`
                )->a( n = `suggestionItems` v = client->_bind_edit( t_products )
                )->a( n = `placeholder`     v = `Products...`
                )->a( n = `showValueHelp`   v = `false`

                )->leaf( n = `Item` ns = `core`
                    )->a( n = `key`  v = `{PRODUCT_ID}`
                    )->a( n = `text` v = `{NAME}`

            )->shut(
            )->leaf( `Label`
                )->a( n = `text`     v = `MultiInput with pre-selected tokens`
                )->a( n = `labelFor` v = `multiInput1`
            )->leaf( `MultiInput`
                )->a( n = `id`             v = `multiInput1`
                )->a( n = `showSuggestion` v = `false`
                )->a( n = `width`          v = `70%`
                )->a( n = `showValueHelp`  v = `false`
            )->leaf( `Label`
                )->a( n = `text`     v = `MultiInput with single long token`
                )->a( n = `labelFor` v = `multiInput2`
            )->leaf( `MultiInput`
                )->a( n = `id`             v = `multiInput2`
                )->a( n = `showSuggestion` v = `false`
                )->a( n = `width`          v = `300px`
                )->a( n = `showValueHelp`  v = `false` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
