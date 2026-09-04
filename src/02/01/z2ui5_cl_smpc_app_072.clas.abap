" @keywords objectnumber object number sap.m states inverted interactive styles verticallayout label horizontallayout panel
" @summary The object number is a small building block representing an important, numerical attribute of an object together with it's unit. Often it is used in the last column of a table.
CLASS z2ui5_cl_smpc_app_072 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        price         TYPE p LENGTH 8 DECIMALS 2,
        currency_code TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_072 IMPLEMENTATION.

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
    DATA num TYPE string.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    DATA temp5 TYPE string_table.
    DATA temp6 TYPE string_table.
    DATA temp7 TYPE string_table.
    DATA temp8 TYPE string_table.
    DATA temp9 TYPE string_table.
    DATA temp10 TYPE string_table.
    DATA temp11 TYPE string_table.
    DATA temp12 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " the shared Currency number binding (parts Price + CurrencyCode, showMeasure off), reused on every ObjectNumber
    
    num = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCY_CODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|.

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `PRESS fired!` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `PRESS fired!` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `PRESS fired!` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `MESSAGE_TOAST` INTO TABLE temp4.
    INSERT `show` INTO TABLE temp4.
    INSERT `PRESS fired!` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `MESSAGE_TOAST` INTO TABLE temp5.
    INSERT `show` INTO TABLE temp5.
    INSERT `PRESS fired!` INTO TABLE temp5.
    
    CLEAR temp6.
    INSERT `MESSAGE_TOAST` INTO TABLE temp6.
    INSERT `show` INTO TABLE temp6.
    INSERT `PRESS fired!` INTO TABLE temp6.
    
    CLEAR temp7.
    INSERT `MESSAGE_TOAST` INTO TABLE temp7.
    INSERT `show` INTO TABLE temp7.
    INSERT `PRESS fired!` INTO TABLE temp7.
    
    CLEAR temp8.
    INSERT `MESSAGE_TOAST` INTO TABLE temp8.
    INSERT `show` INTO TABLE temp8.
    INSERT `PRESS fired!` INTO TABLE temp8.
    
    CLEAR temp9.
    INSERT `MESSAGE_TOAST` INTO TABLE temp9.
    INSERT `show` INTO TABLE temp9.
    INSERT `PRESS fired!` INTO TABLE temp9.
    
    CLEAR temp10.
    INSERT `MESSAGE_TOAST` INTO TABLE temp10.
    INSERT `show` INTO TABLE temp10.
    INSERT `PRESS fired!` INTO TABLE temp10.
    
    CLEAR temp11.
    INSERT `MESSAGE_TOAST` INTO TABLE temp11.
    INSERT `show` INTO TABLE temp11.
    INSERT `PRESS fired!` INTO TABLE temp11.
    
    CLEAR temp12.
    INSERT `MESSAGE_TOAST` INTO TABLE temp12.
    INSERT `show` INTO TABLE temp12.
    INSERT `PRESS fired!` INTO TABLE temp12.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`
            )->tag( `Label`
                )->a( n = `text`   v = `ObjectNumber`
                )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->a( n = `design` v = `Bold`
            )->ele( n = `HorizontalLayout` ns = `l`
                )->a( n = `class` v = `sapUiContentPadding`
                " element binding kept 1:1 - each ObjectNumber index-binds a record of the default-model table T_PRODUCTS (see sidecar)
                )->tag( `ObjectNumber`
                    )->a( n = `class`   v = `sapUiSmallMarginBottom`
                    )->a( n = `binding` v = |\{{ client->_bind_path( t_products ) }/0\}|
                    )->a( n = `number`  v = num
                    )->a( n = `unit`    v = `{CURRENCY_CODE}`
                )->tag( `ObjectNumber`
                    )->a( n = `class`   v = `sapUiSmallMarginBottom`
                    )->a( n = `binding` v = |\{{ client->_bind_path( t_products ) }/1\}|
                    )->a( n = `number`  v = num
                    )->a( n = `unit`    v = `{CURRENCY_CODE}`
                    )->a( n = `state`   v = `Error`
                )->tag( `ObjectNumber`
                    )->a( n = `class`   v = `sapUiSmallMarginBottom`
                    )->a( n = `binding` v = |\{{ client->_bind_path( t_products ) }/2\}|
                    )->a( n = `number`  v = num
                    )->a( n = `unit`    v = `{CURRENCY_CODE}`
                    )->a( n = `state`   v = `Warning`
                )->tag( `ObjectNumber`
                    )->a( n = `class`   v = `sapUiSmallMarginBottom`
                    )->a( n = `binding` v = |\{{ client->_bind_path( t_products ) }/3\}|
                    )->a( n = `number`  v = num
                    )->a( n = `unit`    v = `{CURRENCY_CODE}`
                    )->a( n = `state`   v = `Success`
                )->tag( `ObjectNumber`
                    )->a( n = `class`   v = `sapUiSmallMarginBottom`
                    )->a( n = `binding` v = |\{{ client->_bind_path( t_products ) }/4\}|
                    )->a( n = `number`  v = num
                    )->a( n = `unit`    v = `{CURRENCY_CODE}`
                    )->a( n = `state`   v = `Information`

            )->end(
        )->end(

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`
            )->tag( `Label`
                )->a( n = `text`   v = `Inverted ObjectNumber`
                )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->a( n = `design` v = `Bold`
            )->ele( n = `HorizontalLayout` ns = `l`
                )->a( n = `class` v = `sapUiContentPadding`
                " POST-1.71: inverted, active and press (since UI5 1.86) kept 1:1
                )->tag( `ObjectNumber`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                    )->a( n = `inverted` v = `true`
                    )->a( n = `binding`  v = |\{{ client->_bind_path( t_products ) }/0\}|
                    )->a( n = `number`   v = num
                    )->a( n = `unit`     v = `{CURRENCY_CODE}`
                )->tag( `ObjectNumber`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                    )->a( n = `inverted` v = `true`
                    )->a( n = `binding`  v = |\{{ client->_bind_path( t_products ) }/1\}|
                    )->a( n = `number`   v = num
                    )->a( n = `unit`     v = `{CURRENCY_CODE}`
                    )->a( n = `state`    v = `Error`
                )->tag( `ObjectNumber`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                    )->a( n = `inverted` v = `true`
                    )->a( n = `binding`  v = |\{{ client->_bind_path( t_products ) }/2\}|
                    )->a( n = `number`   v = num
                    )->a( n = `unit`     v = `{CURRENCY_CODE}`
                    )->a( n = `state`    v = `Warning`
                )->tag( `ObjectNumber`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                    )->a( n = `inverted` v = `true`
                    )->a( n = `binding`  v = |\{{ client->_bind_path( t_products ) }/3\}|
                    )->a( n = `number`   v = num
                    )->a( n = `unit`     v = `{CURRENCY_CODE}`
                    )->a( n = `state`    v = `Success`
                )->tag( `ObjectNumber`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                    )->a( n = `inverted` v = `true`
                    )->a( n = `binding`  v = |\{{ client->_bind_path( t_products ) }/4\}|
                    )->a( n = `number`   v = num
                    )->a( n = `unit`     v = `{CURRENCY_CODE}`
                    )->a( n = `state`    v = `Information`

            )->end(
        )->end(

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`
            )->tag( `Label`
                )->a( n = `text`   v = `Interactive ObjectNumber`
                )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->a( n = `design` v = `Bold`
            )->ele( n = `HorizontalLayout` ns = `l`
                )->a( n = `class` v = `sapUiContentPadding`
                )->tag( `ObjectNumber`
                    )->a( n = `class`   v = `sapUiSmallMarginBottom`
                    )->a( n = `active`  v = `true`
                    )->a( n = `binding` v = |\{{ client->_bind_path( t_products ) }/0\}|
                    )->a( n = `press`   v = client->follow_up_action( val   = client->cs_event-control_global
                                                                      t_arg = temp1 )
                    )->a( n = `number`  v = num
                    )->a( n = `unit`    v = `{CURRENCY_CODE}`
                )->tag( `ObjectNumber`
                    )->a( n = `class`   v = `sapUiSmallMarginBottom`
                    )->a( n = `active`  v = `true`
                    )->a( n = `binding` v = |\{{ client->_bind_path( t_products ) }/1\}|
                    )->a( n = `press`   v = client->follow_up_action( val   = client->cs_event-control_global
                                                                      t_arg = temp2 )
                    )->a( n = `number`  v = num
                    )->a( n = `unit`    v = `{CURRENCY_CODE}`
                    )->a( n = `state`   v = `Error`
                )->tag( `ObjectNumber`
                    )->a( n = `class`   v = `sapUiSmallMarginBottom`
                    )->a( n = `active`  v = `true`
                    )->a( n = `binding` v = |\{{ client->_bind_path( t_products ) }/2\}|
                    )->a( n = `press`   v = client->follow_up_action( val   = client->cs_event-control_global
                                                                      t_arg = temp3 )
                    )->a( n = `number`  v = num
                    )->a( n = `unit`    v = `{CURRENCY_CODE}`
                    )->a( n = `state`   v = `Warning`
                )->tag( `ObjectNumber`
                    )->a( n = `class`   v = `sapUiSmallMarginBottom`
                    )->a( n = `active`  v = `true`
                    )->a( n = `binding` v = |\{{ client->_bind_path( t_products ) }/3\}|
                    )->a( n = `press`   v = client->follow_up_action( val   = client->cs_event-control_global
                                                                      t_arg = temp4 )
                    )->a( n = `number`  v = num
                    )->a( n = `unit`    v = `{CURRENCY_CODE}`
                    )->a( n = `state`   v = `Success`
                )->tag( `ObjectNumber`
                    )->a( n = `class`   v = `sapUiSmallMarginBottom`
                    )->a( n = `active`  v = `true`
                    )->a( n = `binding` v = |\{{ client->_bind_path( t_products ) }/4\}|
                    )->a( n = `press`   v = client->follow_up_action( val   = client->cs_event-control_global
                                                                      t_arg = temp5 )
                    )->a( n = `number`  v = num
                    )->a( n = `unit`    v = `{CURRENCY_CODE}`
                    )->a( n = `state`   v = `Information`

            )->end(
        )->end(

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`
            )->tag( `Label`
                )->a( n = `text`   v = `Inverted Interactive ObjectNumber`
                )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->a( n = `design` v = `Bold`
            )->ele( n = `HorizontalLayout` ns = `l`
                )->a( n = `class` v = `sapUiContentPadding`
                )->tag( `ObjectNumber`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                    )->a( n = `active`   v = `true`
                    )->a( n = `inverted` v = `true`
                    )->a( n = `binding`  v = |\{{ client->_bind_path( t_products ) }/0\}|
                    )->a( n = `press`    v = client->follow_up_action( val   = client->cs_event-control_global
                                                                       t_arg = temp6 )
                    )->a( n = `number`   v = num
                    )->a( n = `unit`     v = `{CURRENCY_CODE}`
                )->tag( `ObjectNumber`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                    )->a( n = `active`   v = `true`
                    )->a( n = `inverted` v = `true`
                    )->a( n = `binding`  v = |\{{ client->_bind_path( t_products ) }/1\}|
                    )->a( n = `press`    v = client->follow_up_action( val   = client->cs_event-control_global
                                                                       t_arg = temp7 )
                    )->a( n = `number`   v = num
                    )->a( n = `unit`     v = `{CURRENCY_CODE}`
                    )->a( n = `state`    v = `Error`
                )->tag( `ObjectNumber`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                    )->a( n = `active`   v = `true`
                    )->a( n = `inverted` v = `true`
                    )->a( n = `binding`  v = |\{{ client->_bind_path( t_products ) }/2\}|
                    )->a( n = `press`    v = client->follow_up_action( val   = client->cs_event-control_global
                                                                       t_arg = temp8 )
                    )->a( n = `number`   v = num
                    )->a( n = `unit`     v = `{CURRENCY_CODE}`
                    )->a( n = `state`    v = `Warning`
                )->tag( `ObjectNumber`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                    )->a( n = `active`   v = `true`
                    )->a( n = `inverted` v = `true`
                    )->a( n = `binding`  v = |\{{ client->_bind_path( t_products ) }/3\}|
                    )->a( n = `press`    v = client->follow_up_action( val   = client->cs_event-control_global
                                                                       t_arg = temp9 )
                    )->a( n = `number`   v = num
                    )->a( n = `unit`     v = `{CURRENCY_CODE}`
                    )->a( n = `state`    v = `Success`
                )->tag( `ObjectNumber`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                    )->a( n = `active`   v = `true`
                    )->a( n = `inverted` v = `true`
                    )->a( n = `binding`  v = |\{{ client->_bind_path( t_products ) }/4\}|
                    )->a( n = `press`    v = client->follow_up_action( val   = client->cs_event-control_global
                                                                       t_arg = temp10 )
                    )->a( n = `number`   v = num
                    )->a( n = `unit`     v = `{CURRENCY_CODE}`
                    )->a( n = `state`    v = `Information`

            )->end(
        )->end(

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Label`
                )->a( n = `text`   v = `ObjectNumber with style sapMObjectNumberLarge applied`
                )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->a( n = `design` v = `Bold`
            )->tag( `ObjectNumber`
                )->a( n = `class`      v = `sapMObjectNumberLarge`
                )->a( n = `binding`    v = |\{{ client->_bind_path( t_products ) }/5\}|
                )->a( n = `number`     v = num
                )->a( n = `unit`       v = `{CURRENCY_CODE}`
                )->a( n = `emphasized` v = `false`
                )->a( n = `state`      v = `None`

            )->tag( `Label`
                )->a( n = `text`   v = `Interactive ObjectNumber with style sapMObjectNumberLarge applied`
                )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->a( n = `design` v = `Bold`
            )->tag( `ObjectNumber`
                )->a( n = `class`      v = `sapMObjectNumberLarge`
                )->a( n = `active`     v = `true`
                )->a( n = `binding`    v = |\{{ client->_bind_path( t_products ) }/5\}|
                )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global
                                                                     t_arg = temp11 )
                )->a( n = `number`     v = num
                )->a( n = `unit`       v = `{CURRENCY_CODE}`
                )->a( n = `emphasized` v = `false`
                )->a( n = `state`      v = `None`

            )->tag( `Label`
                )->a( n = `text`   v = `ObjectNumber wrapped via sapMObjectNumberLongText`
                )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->a( n = `design` v = `Bold`
            )->ele( `Panel`
                )->a( n = `backgroundDesign` v = `Transparent`
                )->a( n = `width`            v = `100px`
                )->ele( `content`
                    )->tag( `ObjectNumber`
                        )->a( n = `class`      v = `sapMObjectNumberLongText`
                        )->a( n = `active`     v = `true`
                        )->a( n = `binding`    v = |\{{ client->_bind_path( t_products ) }/5\}|
                        )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global
                                                                             t_arg = temp12 )
                        )->a( n = `number`     v = `12345678901234567890`
                        )->a( n = `unit`       v = `{CURRENCY_CODE}`
                        )->a( n = `emphasized` v = `false`
                        )->a( n = `state`      v = `None`

                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " records /ProductCollection/0..5 of ui5/mock/products.json, verbatim (Price + CurrencyCode)
    DATA temp3 LIKE t_products.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp3.
    
    temp4-price = '956.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-price = '1249.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-price = '1570.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-price = '1650.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-price = '299.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-price = '1999.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    t_products = temp3.

  ENDMETHOD.

ENDCLASS.
