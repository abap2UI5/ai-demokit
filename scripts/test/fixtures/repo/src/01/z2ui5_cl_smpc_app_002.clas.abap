CLASS z2ui5_cl_smpc_app_002 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
    TYPES: BEGIN OF ty_s_prod,
             name  TYPE string,
             city  TYPE string,
             image TYPE string,
           END OF ty_s_prod.
    TYPES ty_t_prod TYPE STANDARD TABLE OF ty_s_prod WITH EMPTY KEY.
    DATA t_prod TYPE ty_t_prod.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_smpc_app_002 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
    " row 2 carries an INVENTED city (the mock says Berlin) - the
    " wrong-neighbour-copy class data-fidelity exists to catch
    t_prod = VALUE #( ( name  = `Gladiator MX`
                        city  = `Hamburg`
                        image = `img/product1.jpg` )
                      ( name  = `Proctra X`
                        city  = `Atlantis`
                        image = `img/product2.jpg` ) ).
    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).
    view->ele( `mvc:View`
      )->ele( `Page`
        )->a( n = `title` v = `Static Title`
        )->tag( `List`
        )->tag( `Button`
          )->a( n = `text` v = `Extra`
          )->a( n = `icon` v = `img/wrong-HT-9999.jpg`
      )->end( )->end( ).
    client->view_display( view->stringify( ) ).
  ENDMETHOD.

ENDCLASS.
