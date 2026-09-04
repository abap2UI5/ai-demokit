" @keywords select sap.m selectvaluestate hbox label item
" @summary Visualizes the validation state of the control, for example, Error, Warning and Success.
CLASS z2ui5_cl_smpc_app_373 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id TYPE string,
        name       TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA selected_error       TYPE string.
    DATA selected_warning     TYPE string.
    DATA selected_success     TYPE string.
    DATA selected_information TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_373 IMPLEMENTATION.

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
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`

            )->ele( `content`
                )->ele( `HBox`
                    )->a( n = `class` v = `sapUiMediumMarginBottom`

                    )->tag( `Label`
                        )->a( n = `text`     v = `Error state`
                        )->a( n = `labelFor` v = `errorSelect`
                        )->a( n = `class`    v = `sapUiTinyMarginEnd sapUiTinyMarginTop`

                    )->ele( `Select`
                        )->a( n = `id`             v = `errorSelect`
                        )->a( n = `forceSelection` v = `true`
                        )->a( n = `selectedKey`    v = client->_bind( selected_error )
                        )->a( n = `valueState`     v = `Error`
                        )->a( n = `valueStateText` v = `error value state text`
                        " the four Selects share one product table (see the sidecar NOTE)
                        )->a( n = `items`          v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{PRODUCT_ID}`
                            )->a( n = `text` v = `{NAME}`

                    )->end(
                )->end(

                )->ele( `HBox`
                    )->a( n = `class` v = `sapUiMediumMarginBottom`

                    )->tag( `Label`
                        )->a( n = `text`     v = `Warning state`
                        )->a( n = `labelFor` v = `warningSelect`
                        )->a( n = `class`    v = `sapUiTinyMarginEnd sapUiTinyMarginTop`

                    )->ele( `Select`
                        )->a( n = `id`             v = `warningSelect`
                        )->a( n = `forceSelection` v = `true`
                        )->a( n = `selectedKey`    v = client->_bind( selected_warning )
                        )->a( n = `valueState`     v = `Warning`
                        )->a( n = `valueStateText` v = `This is a Level 1 explanation. The items Lorem and Ipsum are not recommended from the system.`
                        )->a( n = `items`          v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{PRODUCT_ID}`
                            )->a( n = `text` v = `{NAME}`

                    )->end(
                )->end(

                )->ele( `HBox`
                    )->a( n = `class` v = `sapUiMediumMarginBottom`

                    )->tag( `Label`
                        )->a( n = `text`     v = `Success state`
                        )->a( n = `labelFor` v = `successSelect`
                        )->a( n = `class`    v = `sapUiTinyMarginEnd sapUiTinyMarginTop`

                    )->ele( `Select`
                        )->a( n = `id`             v = `successSelect`
                        )->a( n = `forceSelection` v = `true`
                        )->a( n = `selectedKey`    v = client->_bind( selected_success )
                        )->a( n = `valueState`     v = `Success`
                        )->a( n = `valueStateText` v = `success value state text`
                        )->a( n = `items`          v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{PRODUCT_ID}`
                            )->a( n = `text` v = `{NAME}`

                    )->end(
                )->end(

                )->ele( `HBox`
                    )->a( n = `class` v = `sapUiMediumMarginBottom`

                    )->tag( `Label`
                        )->a( n = `text`     v = `Information state`
                        )->a( n = `labelFor` v = `informationSelect`
                        )->a( n = `class`    v = `sapUiTinyMarginEnd sapUiTinyMarginTop`

                    )->ele( `Select`
                        )->a( n = `id`             v = `informationSelect`
                        )->a( n = `forceSelection` v = `true`
                        )->a( n = `selectedKey`    v = client->_bind( selected_information )
                        )->a( n = `valueState`     v = `Information`
                        )->a( n = `valueStateText` v = `information value state text`
                        )->a( n = `items`          v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{PRODUCT_ID}`
                            )->a( n = `text` v = `{NAME}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.
    DATA temp1 LIKE t_products.
    DATA temp2 LIKE LINE OF temp1.

    " Data of the inline JSON model defined in the original sample controller.
    " The original assigns the very same aProducts array to all four collection
    " keys and gives each Select its own selectedKey.
    selected_error       = `HT-998`.
    selected_warning     = `HT-999`.
    selected_success     = `HT-1000`.
    selected_information = `HT-1007`.

    
    CLEAR temp1.
    
    temp2-product_id = `HT-998`.
    temp2-name = `Notebook Basic 11`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-999`.
    temp2-name = `Notebook Basic 13`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1000`.
    temp2-name = `Notebook Basic 15`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1001`.
    temp2-name = `Notebook Basic 17`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1002`.
    temp2-name = `Notebook Basic 18`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1003`.
    temp2-name = `Notebook Basic 19`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1007`.
    temp2-name = `ITelO Vault`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1008`.
    temp2-name = `Notebook Professional 11`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1009`.
    temp2-name = `Notebook Professional 13`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1010`.
    temp2-name = `Notebook Professional 15`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1011`.
    temp2-name = `Notebook Professional 17`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1012`.
    temp2-name = `Notebook Professional 19`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1020`.
    temp2-name = `ITelO Vault Net`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1021`.
    temp2-name = `ITelO Vault SAT`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1022`.
    temp2-name = `Comfort Easy`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1023`.
    temp2-name = `Comfort Senior`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.

  ENDMETHOD.

ENDCLASS.
