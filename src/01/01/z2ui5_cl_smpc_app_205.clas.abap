CLASS z2ui5_cl_smpc_app_205 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        productid TYPE string,
        name      TYPE string,
        icon      TYPE string,
      END OF ty_s_product.
    DATA t_productcollection TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    DATA selectedproduct TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_205 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `height`     v = `100%`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`
            )->a( n = `class`      v = `sapUiContentPadding`

            )->ele( `content`
                )->ele( `Select`
                    )->a( n = `forceSelection` v = `false`
                    )->a( n = `selectedKey`    v = client->_bind( selectedproduct )
                    )->a( n = `items`          v = |\{ path: '{ client->_bind( val = t_productcollection path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|

                    )->tag( n = `ListItem` ns = `core`
                        )->a( n = `key`  v = `{PRODUCTID}`
                        )->a( n = `text` v = `{NAME}`
                        )->a( n = `icon` v = `{ICON}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    selectedproduct = `HT-1001`.

    " inline mock from the sample's Page.controller.js (/ProductCollection)
    t_productcollection = VALUE #(
        ( productid = `HT-1001` name = `Notebook Basic 17`        icon = `sap-icon://paper-plane` )
        ( productid = `HT-1002` name = `Notebook Basic 18`        icon = `sap-icon://add-document` )
        ( productid = `HT-1003` name = `Notebook Basic 19`        icon = `sap-icon://doctor` )
        ( productid = `HT-1007` name = `ITelO Vault`              icon = `sap-icon://sys-find-next` )
        ( productid = `HT-1010` name = `Notebook Professional 15` icon = `sap-icon://add-product` )
        ( productid = `HT-1011` name = `Notebook Professional 17` icon = `sap-icon://add-product` )
        ( productid = `HT-1020` name = `ITelO Vault Net`          icon = `sap-icon://add-product` )
        ( productid = `HT-1021` name = `ITelO Vault SAT`          icon = `sap-icon://add-product` )
        ( productid = `HT-1022` name = `Comfort Easy`             icon = `sap-icon://add-product` )
        ( productid = `HT-1023` name = `Comfort Senior`           icon = `sap-icon://add-product` ) ).

  ENDMETHOD.

ENDCLASS.
