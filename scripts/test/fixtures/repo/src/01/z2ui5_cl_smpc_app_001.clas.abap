CLASS z2ui5_cl_smpc_app_001 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
    TYPES: BEGIN OF ty_s_prod,
             name  TYPE string,
             city  TYPE string,
             image TYPE string,
           END OF ty_s_prod.
    TYPES ty_t_prod TYPE STANDARD TABLE OF ty_s_prod WITH EMPTY KEY.
    DATA t_prod TYPE ty_t_prod.
    DATA title  TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_smpc_app_001 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
    title  = `Products`.
    t_prod = VALUE #( ( name  = `Gladiator MX`
                        city  = `Hamburg`
                        image = `img/product1.jpg` )
                      ( name  = `Proctra X`
                        city  = `Berlin`
                        image = `img/product2.jpg` ) ).
    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).
    view->ele( `mvc:View`
      )->ele( `Page`
        )->a( n = `title` v = `{TITLE}`
        )->tag( `Text`
          )->a( n = `text` v = `{NAME}`
      )->end( )->end( ).
    client->view_display( view->stringify( ) ).
  ENDMETHOD.

ENDCLASS.
