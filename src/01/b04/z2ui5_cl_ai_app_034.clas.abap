CLASS z2ui5_cl_ai_app_034 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name     TYPE string,
        quantity TYPE i,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_034 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    t_products = VALUE #(
      ( name = `Notebook Basic 15`        quantity = 10 )
      ( name = `Notebook Basic 17`        quantity = 20 )
      ( name = `Notebook Basic 18`        quantity = 10 )
      ( name = `Notebook Basic 19`        quantity = 15 )
      ( name = `ITelO Vault`              quantity = 15 )
      ( name = `Notebook Professional 15` quantity = 16 )
      ( name = `Notebook Professional 17` quantity = 17 )
      ( name = `ITelO Vault Net`          quantity = 14 )
      ( name = `ITelO Vault SAT`          quantity = 50 )
      ( name = `Comfort Easy`             quantity = 30 )
      ( name = `Comfort Senior`           quantity = 24 ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `List`
            )->a( n = `headerText`  v = `Products`
            )->a( n = `headerLevel` v = `H2`
            )->a( n = `items`       v = client->_bind( t_products )

            )->leaf( `StandardListItem`
                )->a( n = `title`   v = `{NAME}`
                )->a( n = `counter` v = `{QUANTITY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
