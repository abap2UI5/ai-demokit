CLASS z2ui5_cl_ai_app_115 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name     TYPE string,
             supplier TYPE string,
             price    TYPE string,
           END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_115 IMPLEMENTATION.

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
        )->a( n = `xmlns`     v = `sap.ui.table`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `height`    v = `100%`

        )->open( `Table`
            )->a( n = `rows`          v = client->_bind( t_products )
            )->a( n = `selectionMode` v = `MultiToggle`

            )->open( `extension`
                )->open( n = `OverflowToolbar` ns = `m`
                    )->leaf( n = `Title` ns = `m`
                        )->a( n = `text` v = `Products`

            )->shut(
            )->shut(
            )->open( `columns`
                )->open( `Column`
                    )->a( n = `width` v = `11rem`
                    )->leaf( n = `Label` ns = `m`
                        )->a( n = `text` v = `Product Name`

                    )->open( `template`
                        )->leaf( n = `Text` ns = `m`
                            )->a( n = `text`     v = `{NAME}`
                            )->a( n = `wrapping` v = `false`

                )->shut(
                )->shut(
                )->open( `Column`
                    )->a( n = `width` v = `11rem`
                    )->leaf( n = `Label` ns = `m`
                        )->a( n = `text` v = `Supplier`

                    )->open( `template`
                        )->leaf( n = `Text` ns = `m`
                            )->a( n = `text` v = `{SUPPLIER}`

                )->shut(
                )->shut(
                )->open( `Column`
                    )->a( n = `width`  v = `6rem`
                    )->a( n = `hAlign` v = `End`
                    )->leaf( n = `Label` ns = `m`
                        )->a( n = `text` v = `Price`

                    )->open( `template`
                        )->leaf( n = `Text` ns = `m`
                            )->a( n = `text` v = `{PRICE}`

                )->shut(
                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    t_products = VALUE #(
      ( name = `Notebook Basic 15` supplier = `Very Best Screens` price = `956.00` )
      ( name = `Notebook Basic 17` supplier = `Very Best Screens` price = `1249.00` )
      ( name = `Notebook Basic 18` supplier = `Very Best Screens` price = `1570.00` )
      ( name = `ITelO Vault` supplier = `Smartcard Corp` price = `299.00` )
      ( name = `Comfort Easy` supplier = `Technocom` price = `1650.00` ) ).

  ENDMETHOD.

ENDCLASS.
