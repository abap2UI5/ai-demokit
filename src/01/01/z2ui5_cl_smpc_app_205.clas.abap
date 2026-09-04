" @keywords select sap.m selectwithicons listitem
" @summary Illustrates the usage of a Select with icons
CLASS z2ui5_cl_smpc_app_205 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        productid TYPE string,
        name      TYPE string,
        icon      TYPE string,
      END OF ty_s_product.
    DATA t_productcollection TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
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
                    )->a( n = `items`          v = |\{ path: '{ client->_bind_path( t_productcollection ) }', sorter: \{ path: 'NAME' \} \}|

                    )->tag( n = `ListItem` ns = `core`
                        )->a( n = `key`  v = `{PRODUCTID}`
                        )->a( n = `text` v = `{NAME}`
                        )->a( n = `icon` v = `{ICON}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.
    DATA temp1 LIKE t_productcollection.
    DATA temp2 LIKE LINE OF temp1.

    selectedproduct = `HT-1001`.

    " inline mock from the sample's Page.controller.js (/ProductCollection)
    
    CLEAR temp1.
    
    temp2-productid = `HT-1001`.
    temp2-name = `Notebook Basic 17`.
    temp2-icon = `sap-icon://paper-plane`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1002`.
    temp2-name = `Notebook Basic 18`.
    temp2-icon = `sap-icon://add-document`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1003`.
    temp2-name = `Notebook Basic 19`.
    temp2-icon = `sap-icon://doctor`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1007`.
    temp2-name = `ITelO Vault`.
    temp2-icon = `sap-icon://sys-find-next`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1010`.
    temp2-name = `Notebook Professional 15`.
    temp2-icon = `sap-icon://add-product`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1011`.
    temp2-name = `Notebook Professional 17`.
    temp2-icon = `sap-icon://add-product`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1020`.
    temp2-name = `ITelO Vault Net`.
    temp2-icon = `sap-icon://add-product`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1021`.
    temp2-name = `ITelO Vault SAT`.
    temp2-icon = `sap-icon://add-product`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1022`.
    temp2-name = `Comfort Easy`.
    temp2-icon = `sap-icon://add-product`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1023`.
    temp2-name = `Comfort Senior`.
    temp2-icon = `sap-icon://add-product`.
    INSERT temp2 INTO TABLE temp1.
    t_productcollection = temp1.

  ENDMETHOD.

ENDCLASS.
