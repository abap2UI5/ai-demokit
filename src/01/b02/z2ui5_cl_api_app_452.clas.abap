CLASS z2ui5_cl_api_app_452 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id    TYPE string,
        name          TYPE string,
        supplier_name TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_452 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " Data of the mock model /ProductCollection used by the original sample
    DATA temp1 LIKE t_products.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-product_id = `HT-1000`.
    temp2-name = `Notebook Basic 15`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1001`.
    temp2-name = `Notebook Basic 17`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1002`.
    temp2-name = `Notebook Basic 18`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1003`.
    temp2-name = `Notebook Basic 19`.
    temp2-supplier_name = `Smartcards`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1007`.
    temp2-name = `ITelO Vault`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1010`.
    temp2-name = `Notebook Professional 15`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1011`.
    temp2-name = `Notebook Professional 17`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1020`.
    temp2-name = `ITelO Vault Net`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1021`.
    temp2-name = `ITelO Vault SAT`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1022`.
    temp2-name = `Comfort Easy`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1023`.
    temp2-name = `Comfort Senior`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1030`.
    temp2-name = `Ergo Screen E-I`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1031`.
    temp2-name = `Ergo Screen E-II`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1032`.
    temp2-name = `Ergo Screen E-III`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1035`.
    temp2-name = `Flat Basic`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1036`.
    temp2-name = `Flat Future`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_api_xml.
    view = z2ui5_cl_api_xml=>factory( ).

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
                )->a( n = `items` v = |\{ path: '{ client->_bind_edit( val = t_products path = abap_true ) }', sorter: \{ path: 'SUPPLIER_NAME', descending: false, group: true \} \}|

                )->leaf( n = `Item` ns = `core`
                    )->a( n = `key`  v = `{PRODUCT_ID}`
                    )->a( n = `text` v = `{NAME}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
