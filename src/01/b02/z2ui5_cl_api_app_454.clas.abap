CLASS z2ui5_cl_api_app_454 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id TYPE string,
        name       TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_454 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    DATA temp1 LIKE t_products.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-product_id = `HT-1000`.
    temp2-name = `Notebook Basic 15`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1001`.
    temp2-name = `Notebook Basic 17`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1002`.
    temp2-name = `Notebook Basic 18`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1003`.
    temp2-name = `Notebook Basic 19`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1007`.
    temp2-name = `ITelO Vault`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1010`.
    temp2-name = `Notebook Professional 15`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1011`.
    temp2-name = `Notebook Professional 17`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1020`.
    temp2-name = `ITelO Vault Net`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1021`.
    temp2-name = `ITelO Vault SAT`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1022`.
    temp2-name = `Comfort Easy`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1023`.
    temp2-name = `Comfort Senior`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1030`.
    temp2-name = `Ergo Screen E-I`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1031`.
    temp2-name = `Ergo Screen E-II`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1032`.
    temp2-name = `Ergo Screen E-III`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1035`.
    temp2-name = `Flat Basic`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1036`.
    temp2-name = `Flat Future`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.
    SORT t_products BY name.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_api_xml.
    view = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
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
                )->a( n = `showClearIcon`   v = `true`
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

            " the tokens the original controller pre-sets in onInit
            )->open( `MultiInput`
                )->a( n = `id`             v = `multiInput1`
                )->a( n = `showSuggestion` v = `false`
                )->a( n = `width`          v = `70%`
                )->a( n = `showValueHelp`  v = `false`

                )->open( `tokens`
                    )->leaf( `Token`
                        )->a( n = `key`  v = `0001`
                        )->a( n = `text` v = `Token 1`
                    )->leaf( `Token`
                        )->a( n = `key`  v = `0002`
                        )->a( n = `text` v = `Token 2`
                    )->leaf( `Token`
                        )->a( n = `key`  v = `0003`
                        )->a( n = `text` v = `Token 3`
                    )->leaf( `Token`
                        )->a( n = `key`  v = `0004`
                        )->a( n = `text` v = `Token 4`
                    )->leaf( `Token`
                        )->a( n = `key`  v = `0005`
                        )->a( n = `text` v = `Token 5`
                    )->leaf( `Token`
                        )->a( n = `key`  v = `0006`
                        )->a( n = `text` v = `Token 6`

                )->shut(
            )->shut(
            )->leaf( `Label`
                )->a( n = `text`     v = `MultiInput with single long token`
                )->a( n = `labelFor` v = `multiInput2`

            )->open( `MultiInput`
                )->a( n = `id`             v = `multiInput2`
                )->a( n = `showSuggestion` v = `false`
                )->a( n = `width`          v = `300px`
                )->a( n = `showValueHelp`  v = `false`

                )->open( `tokens`
                    )->leaf( `Token`
                        )->a( n = `key`  v = `longText`
                        )->a( n = `text` v = `Very long long long long long long long text` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
