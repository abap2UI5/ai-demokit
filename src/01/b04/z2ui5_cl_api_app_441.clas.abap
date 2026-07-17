CLASS z2ui5_cl_api_app_441 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name     TYPE string,
        quantity TYPE i,
      END OF ty_s_product.
    DATA t_products TYPE TABLE OF ty_s_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_441 IMPLEMENTATION.

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
    
    temp2-name = `Notebook Basic 15`.
    temp2-quantity = 10.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 17`.
    temp2-quantity = 20.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 18`.
    temp2-quantity = 10.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 19`.
    temp2-quantity = 15.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault`.
    temp2-quantity = 15.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 15`.
    temp2-quantity = 16.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 17`.
    temp2-quantity = 17.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault Net`.
    temp2-quantity = 14.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault SAT`.
    temp2-quantity = 50.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Comfort Easy`.
    temp2-quantity = 30.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Comfort Senior`.
    temp2-quantity = 24.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_api_xml.
    view = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `List`
            )->a( n = `headerText`  v = `Products`
            )->a( n = `headerLevel` v = `H2`
            )->a( n = `items`       v = client->_bind_edit( t_products )

            )->leaf( `StandardListItem`
                )->a( n = `title`   v = `{NAME}`
                )->a( n = `counter` v = `{QUANTITY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
