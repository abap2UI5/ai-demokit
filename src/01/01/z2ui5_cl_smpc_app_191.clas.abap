" @keywords objectattribute object attribute sap.m objectattributeintable table column text columnlistitem objectidentifier
" @summary This is an example of Object Attribute used inside Table.
CLASS z2ui5_cl_smpc_app_191 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product  TYPE string,
        supplier TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_191 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( `Table`
            )->a( n = `id`    v = `idProductsTable`
            )->a( n = `items` v = client->_bind( t_products )

            )->ele( `columns`
                )->ele( `Column`
                    )->tag( `Text`
                        )->a( n = `text` v = `Products`

                )->end(
                )->ele( `Column`
                    )->tag( `Text`
                        )->a( n = `text` v = `Supplier`

                )->end(
                )->ele( `Column`
                    )->tag( `Text`
                        )->a( n = `text` v = `Supplier (active)`

                )->end(
            )->end(
            )->ele( `ColumnListItem`
                )->tag( `ObjectIdentifier`
                    )->a( n = `text` v = `{PRODUCT}`
                )->tag( `ObjectAttribute`
                    )->a( n = `text` v = `{SUPPLIER}`
                )->tag( `ObjectAttribute`
                    )->a( n = `text`   v = `{SUPPLIER}`
                    )->a( n = `active` v = `true` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the original controller's inline /modelData rows, moved verbatim onto the
    " one default model (pure root rename, see sidecar NOTE)
    DATA temp1 LIKE t_products.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-product = `Power Projector 4713`.
    temp2-supplier = `Robert Brown Entertainment`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = `HT-1022`.
    temp2-supplier = `Pear Computing Services`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = `Ergo Screen E-III`.
    temp2-supplier = `DelBont Industries`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = `Gladiator MX`.
    temp2-supplier = `Asia High tech`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = `Hurricane GX`.
    temp2-supplier = `Telecomunicaciones Star`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = `Notebook Basic 17`.
    temp2-supplier = `Pear Computing Services`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = `ITelO Vault SAT`.
    temp2-supplier = `New Line Design`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = `Hurricane GX`.
    temp2-supplier = `Robert Brown Entertainment`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = `Webcam`.
    temp2-supplier = `Getränkegroßhandel Janssen`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = `Deskjet Super Highspeed`.
    temp2-supplier = `Vente Et Réparation de Ordinateur`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.

  ENDMETHOD.

ENDCLASS.
