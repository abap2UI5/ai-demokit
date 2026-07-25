CLASS z2ui5_cl_ai_app_191 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product  TYPE string,
        supplier TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_191 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `Table`
            )->a( n = `id`    v = `idProductsTable`
            )->a( n = `items` v = client->_bind( t_products )

            )->open( `columns`
                )->open( `Column`
                    )->leaf( `Text`
                        )->a( n = `text` v = `Products`

                )->shut(
                )->open( `Column`
                    )->leaf( `Text`
                        )->a( n = `text` v = `Supplier`

                )->shut(
                )->open( `Column`
                    )->leaf( `Text`
                        )->a( n = `text` v = `Supplier (active)`

                )->shut(
            )->shut(
            )->open( `ColumnListItem`
                )->leaf( `ObjectIdentifier`
                    )->a( n = `text` v = `{PRODUCT}`
                )->leaf( `ObjectAttribute`
                    )->a( n = `text` v = `{SUPPLIER}`
                )->leaf( `ObjectAttribute`
                    )->a( n = `text`   v = `{SUPPLIER}`
                    )->a( n = `active` v = `true` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    t_products = VALUE #(
      ( product = `Power Projector 4713` supplier = `Robert Brown Entertainment` )
      ( product = `HT-1022`              supplier = `Pear Computing Services` )
      ( product = `Ergo Screen E-III`    supplier = `DelBont Industries` )
      ( product = `Gladiator MX`         supplier = `Asia High tech` )
      ( product = `Hurricane GX`         supplier = `Telecomunicaciones Star` )
      ( product = `Notebook Basic 17`    supplier = `Pear Computing Services` )
      ( product = `ITelO Vault SAT`      supplier = `New Line Design` )
      ( product = `Hurricane GX`         supplier = `Robert Brown Entertainment` )
      ( product = `Webcam`               supplier = `Getränkegroßhandel Janssen` )
      ( product = `Deskjet Super Highspeed` supplier = `Vente Et Réparation de Ordinateur` ) ).

  ENDMETHOD.

ENDCLASS.
