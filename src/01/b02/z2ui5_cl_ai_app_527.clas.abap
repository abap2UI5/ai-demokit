CLASS z2ui5_cl_ai_app_527 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id TYPE string,
        name       TYPE string,
      END OF ty_s_product.
    DATA t_products  TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    DATA t_products2 TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    DATA t_products3 TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    DATA selected_product  TYPE string.
    DATA selected_product2 TYPE string.
    DATA selected_product3 TYPE string.
    DATA enabled  TYPE abap_bool.
    DATA editable TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_527 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " Data of the inline JSON model defined in the original sample controller
    selected_product  = `HT-1001`.
    selected_product2 = `HT-1001`.
    selected_product3 = `HT-1001`.
    enabled  = abap_true.
    editable = abap_true.

    t_products = VALUE #(
      ( product_id = `HT-1000` name = `Notebook Basic 15` )
      ( product_id = `HT-1001` name = `Notebook Basic 17` )
      ( product_id = `HT-1002` name = `Notebook Basic 18` )
      ( product_id = `HT-1003` name = `Notebook Basic 19` )
      ( product_id = `HT-1007` name = `ITelO Vault` ) ).

    t_products2 = VALUE #(
      ( product_id = `HT-1000` name = `Notebook Basic 15` )
      ( product_id = `HT-1001` name = `Notebook Basic 17` )
      ( product_id = `HT-1002` name = `Notebook Basic 18` )
      ( product_id = `HT-1003` name = `Notebook Basic 19` )
      ( product_id = `HT-1007` name = `ITelO Vault` ) ).

    t_products3 = VALUE #(
      ( product_id = `HT-1000` name = `Notebook Basic 15` )
      ( product_id = `HT-1001` name = `Notebook Basic 17` )
      ( product_id = `HT-1002` name = `Notebook Basic 18` )
      ( product_id = `HT-1003` name = `Notebook Basic 19` )
      ( product_id = `HT-1007` name = `ITelO Vault` ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( `Page`
            )->a( n = `showHeader` v = `false`
            )->a( n = `class`      v = `sapUiContentPadding`

            )->open( `subHeader`
                )->open( `Toolbar`
                    )->leaf( `ToolbarSpacer`
                    )->open( `Select`
                        )->a( n = `forceSelection` v = `false`
                        )->a( n = `selectedKey`    v = client->_bind_edit( selected_product )
                        )->a( n = `items`          v = |\{ path: '{ client->_bind_edit( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|

                        )->leaf( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{PRODUCT_ID}`
                            )->a( n = `text` v = `{NAME}`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `content`
                )->open( `HBox`
                    )->a( n = `justifyContent` v = `SpaceAround`

                    )->open( `Select`
                        )->a( n = `enabled`        v = client->_bind_edit( enabled )
                        )->a( n = `editable`       v = client->_bind_edit( editable )
                        )->a( n = `forceSelection` v = `false`
                        )->a( n = `selectedKey`    v = client->_bind_edit( selected_product2 )
                        )->a( n = `items`          v = |\{ path: '{ client->_bind_edit( val = t_products2 path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|

                        )->leaf( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{PRODUCT_ID}`
                            )->a( n = `text` v = `{NAME}`

                    )->shut(

                    )->open( `VBox`
                        )->open( `HBox`
                            )->a( n = `alignItems` v = `Center`

                            )->leaf( `Label`
                                )->a( n = `text`  v = `Enabled:`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                            )->leaf( `Switch`
                                )->a( n = `type`  v = `AcceptReject`
                                )->a( n = `state` v = client->_bind_edit( enabled )

                        )->shut(
                        )->open( `HBox`
                            )->a( n = `alignItems` v = `Center`

                            )->leaf( `Label`
                                )->a( n = `text`  v = `Editable:`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                            )->leaf( `Switch`
                                )->a( n = `type`  v = `AcceptReject`
                                )->a( n = `state` v = client->_bind_edit( editable )

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( `footer`
                )->open( `Toolbar`
                    )->leaf( `ToolbarSpacer`
                    )->open( `Select`
                        )->a( n = `forceSelection`  v = `false`
                        )->a( n = `selectedKey`     v = client->_bind_edit( selected_product3 )
                        )->a( n = `type`            v = `IconOnly`
                        )->a( n = `icon`            v = `sap-icon://filter`
                        )->a( n = `autoAdjustWidth` v = `true`
                        )->a( n = `items`           v = |\{ path: '{ client->_bind_edit( val = t_products3 path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|

                        )->leaf( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{PRODUCT_ID}`
                            )->a( n = `text` v = `{NAME}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
