"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sdk.openui5.org/entity/sap.m.List/sample/sap.m.sample.ListCounter
"! The counter of an item quickly shows how many detail entries are related, without having to
"! navigate to the detail page.
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
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_441 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    " headerLevel="H2" of the original sample is omitted here (available only since UI5 1.117)
    view->open( n = `View` ns = `mvc`
        )->attr( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->attr( n = `xmlns`     v = `sap.m`

        )->open( `List`
            )->attr( n = `headerText` v = `Products`
            )->attr( n = `items`      v = client->_bind( t_products )

            )->leaf( `StandardListItem`
                )->attr( n = `title`   v = `{NAME}`
                )->attr( n = `counter` v = `{QUANTITY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

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

      view_display( client ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
