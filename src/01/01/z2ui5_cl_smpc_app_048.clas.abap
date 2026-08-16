" @keywords select sap.m dropdown selects item binding toolbar toolbarspacer hbox vbox label switch
" @summary Illustrates the usage of a Select in header, footer and content of a page. Note the different display options.
CLASS z2ui5_cl_smpc_app_048 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id TYPE string,
        name       TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    DATA selected_product  TYPE string.
    DATA selected_product2 TYPE string.
    DATA selected_product3 TYPE string.
    DATA enabled  TYPE abap_bool.
    DATA editable TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_048 IMPLEMENTATION.

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
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`
            )->a( n = `class`      v = `sapUiContentPadding`

            )->ele( `subHeader`
                )->ele( `Toolbar`
                    )->tag( `ToolbarSpacer`
                    )->ele( `Select`
                        )->a( n = `forceSelection` v = `false`
                        )->a( n = `selectedKey`    v = client->_bind( selected_product )
                        )->a( n = `items`          v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{PRODUCT_ID}`
                            )->a( n = `text` v = `{NAME}`

                    )->end(
                )->end(
            )->end(

            )->ele( `content`
                )->ele( `HBox`
                    )->a( n = `justifyContent` v = `SpaceAround`

                    )->ele( `Select`
                        )->a( n = `enabled`        v = client->_bind( enabled )
                        )->a( n = `editable`       v = client->_bind( editable )
                        )->a( n = `forceSelection` v = `false`
                        )->a( n = `selectedKey`    v = client->_bind( selected_product2 )
                        )->a( n = `items`          v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{PRODUCT_ID}`
                            )->a( n = `text` v = `{NAME}`

                    )->end(

                    )->ele( `VBox`
                        )->ele( `HBox`
                            )->a( n = `alignItems` v = `Center`

                            )->tag( `Label`
                                )->a( n = `text`  v = `Enabled:`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                            )->tag( `Switch`
                                )->a( n = `type`  v = `AcceptReject`
                                )->a( n = `state` v = client->_bind( enabled )

                        )->end(
                        )->ele( `HBox`
                            )->a( n = `alignItems` v = `Center`

                            )->tag( `Label`
                                )->a( n = `text`  v = `Editable:`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                            )->tag( `Switch`
                                )->a( n = `type`  v = `AcceptReject`
                                )->a( n = `state` v = client->_bind( editable )

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `footer`
                )->ele( `Toolbar`
                    )->tag( `ToolbarSpacer`
                    )->ele( `Select`
                        )->a( n = `forceSelection`  v = `false`
                        )->a( n = `selectedKey`     v = client->_bind( selected_product3 )
                        )->a( n = `type`            v = `IconOnly`
                        )->a( n = `icon`            v = `sap-icon://filter`
                        )->a( n = `autoAdjustWidth` v = `true`
                        )->a( n = `items`           v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{PRODUCT_ID}`
                            )->a( n = `text` v = `{NAME}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " Data of the inline JSON model defined in the original sample controller
    selected_product  = `HT-1001`.
    selected_product2 = `HT-1001`.
    selected_product3 = `HT-1001`.
    enabled  = abap_true.
    editable = abap_true.

    " one shared product list feeds all three Selects (the original seeds three
    " byte-identical collections /ProductCollection, /ProductCollection2 and
    " /ProductCollection3); each Select keeps its own selectedKey
    t_products = VALUE #(
      ( product_id = `HT-1000` name = `Notebook Basic 15` )
      ( product_id = `HT-1001` name = `Notebook Basic 17` )
      ( product_id = `HT-1002` name = `Notebook Basic 18` )
      ( product_id = `HT-1003` name = `Notebook Basic 19` )
      ( product_id = `HT-1007` name = `ITelO Vault` ) ).

  ENDMETHOD.

ENDCLASS.
