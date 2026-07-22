CLASS z2ui5_cl_ai_app_072 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        price         TYPE p LENGTH 8 DECIMALS 2,
        currency_code TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_072 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " the shared Currency number binding (parts Price + CurrencyCode, showMeasure off), reused on every ObjectNumber
    DATA(num) = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCY_CODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|.

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`
            )->leaf( `Label`
                )->a( n = `text`   v = `ObjectNumber`
                )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->a( n = `design` v = `Bold`
            )->open( n = `HorizontalLayout` ns = `l`
                )->a( n = `class` v = `sapUiContentPadding`
                )->leaf( `ObjectNumber`
                    )->a( n = `class`   v = `sapUiSmallMarginBottom`
                    )->a( n = `binding` v = |\{{ client->_bind( val = t_products path = abap_true ) }/0\}|
                    )->a( n = `number`  v = num
                    )->a( n = `unit`    v = `{CURRENCY_CODE}`
                )->leaf( `ObjectNumber`
                    )->a( n = `class`   v = `sapUiSmallMarginBottom`
                    )->a( n = `binding` v = |\{{ client->_bind( val = t_products path = abap_true ) }/1\}|
                    )->a( n = `number`  v = num
                    )->a( n = `unit`    v = `{CURRENCY_CODE}`
                    )->a( n = `state`   v = `Error`
                )->leaf( `ObjectNumber`
                    )->a( n = `class`   v = `sapUiSmallMarginBottom`
                    )->a( n = `binding` v = |\{{ client->_bind( val = t_products path = abap_true ) }/2\}|
                    )->a( n = `number`  v = num
                    )->a( n = `unit`    v = `{CURRENCY_CODE}`
                    )->a( n = `state`   v = `Warning`
                )->leaf( `ObjectNumber`
                    )->a( n = `class`   v = `sapUiSmallMarginBottom`
                    )->a( n = `binding` v = |\{{ client->_bind( val = t_products path = abap_true ) }/3\}|
                    )->a( n = `number`  v = num
                    )->a( n = `unit`    v = `{CURRENCY_CODE}`
                    )->a( n = `state`   v = `Success`
                )->leaf( `ObjectNumber`
                    )->a( n = `class`   v = `sapUiSmallMarginBottom`
                    )->a( n = `binding` v = |\{{ client->_bind( val = t_products path = abap_true ) }/4\}|
                    )->a( n = `number`  v = num
                    )->a( n = `unit`    v = `{CURRENCY_CODE}`
                    )->a( n = `state`   v = `Information`

            )->shut(
        )->shut(

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`
            )->leaf( `Label`
                )->a( n = `text`   v = `Inverted ObjectNumber`
                )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->a( n = `design` v = `Bold`
            )->open( n = `HorizontalLayout` ns = `l`
                )->a( n = `class` v = `sapUiContentPadding`
                )->leaf( `ObjectNumber`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                    )->a( n = `inverted` v = `true`
                    )->a( n = `binding`  v = |\{{ client->_bind( val = t_products path = abap_true ) }/0\}|
                    )->a( n = `number`   v = num
                    )->a( n = `unit`     v = `{CURRENCY_CODE}`
                )->leaf( `ObjectNumber`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                    )->a( n = `inverted` v = `true`
                    )->a( n = `binding`  v = |\{{ client->_bind( val = t_products path = abap_true ) }/1\}|
                    )->a( n = `number`   v = num
                    )->a( n = `unit`     v = `{CURRENCY_CODE}`
                    )->a( n = `state`    v = `Error`
                )->leaf( `ObjectNumber`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                    )->a( n = `inverted` v = `true`
                    )->a( n = `binding`  v = |\{{ client->_bind( val = t_products path = abap_true ) }/2\}|
                    )->a( n = `number`   v = num
                    )->a( n = `unit`     v = `{CURRENCY_CODE}`
                    )->a( n = `state`    v = `Warning`
                )->leaf( `ObjectNumber`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                    )->a( n = `inverted` v = `true`
                    )->a( n = `binding`  v = |\{{ client->_bind( val = t_products path = abap_true ) }/3\}|
                    )->a( n = `number`   v = num
                    )->a( n = `unit`     v = `{CURRENCY_CODE}`
                    )->a( n = `state`    v = `Success`
                )->leaf( `ObjectNumber`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                    )->a( n = `inverted` v = `true`
                    )->a( n = `binding`  v = |\{{ client->_bind( val = t_products path = abap_true ) }/4\}|
                    )->a( n = `number`   v = num
                    )->a( n = `unit`     v = `{CURRENCY_CODE}`
                    )->a( n = `state`    v = `Information`

            )->shut(
        )->shut(

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`
            )->leaf( `Label`
                )->a( n = `text`   v = `Interactive ObjectNumber`
                )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->a( n = `design` v = `Bold`
            )->open( n = `HorizontalLayout` ns = `l`
                )->a( n = `class` v = `sapUiContentPadding`
                )->leaf( `ObjectNumber`
                    )->a( n = `class`   v = `sapUiSmallMarginBottom`
                    )->a( n = `active`  v = `true`
                    )->a( n = `binding` v = |\{{ client->_bind( val = t_products path = abap_true ) }/0\}|
                    )->a( n = `press`   v = client->_event( `PRESS` )
                    )->a( n = `number`  v = num
                    )->a( n = `unit`    v = `{CURRENCY_CODE}`
                )->leaf( `ObjectNumber`
                    )->a( n = `class`   v = `sapUiSmallMarginBottom`
                    )->a( n = `active`  v = `true`
                    )->a( n = `binding` v = |\{{ client->_bind( val = t_products path = abap_true ) }/1\}|
                    )->a( n = `press`   v = client->_event( `PRESS` )
                    )->a( n = `number`  v = num
                    )->a( n = `unit`    v = `{CURRENCY_CODE}`
                    )->a( n = `state`   v = `Error`
                )->leaf( `ObjectNumber`
                    )->a( n = `class`   v = `sapUiSmallMarginBottom`
                    )->a( n = `active`  v = `true`
                    )->a( n = `binding` v = |\{{ client->_bind( val = t_products path = abap_true ) }/2\}|
                    )->a( n = `press`   v = client->_event( `PRESS` )
                    )->a( n = `number`  v = num
                    )->a( n = `unit`    v = `{CURRENCY_CODE}`
                    )->a( n = `state`   v = `Warning`
                )->leaf( `ObjectNumber`
                    )->a( n = `class`   v = `sapUiSmallMarginBottom`
                    )->a( n = `active`  v = `true`
                    )->a( n = `binding` v = |\{{ client->_bind( val = t_products path = abap_true ) }/3\}|
                    )->a( n = `press`   v = client->_event( `PRESS` )
                    )->a( n = `number`  v = num
                    )->a( n = `unit`    v = `{CURRENCY_CODE}`
                    )->a( n = `state`   v = `Success`
                )->leaf( `ObjectNumber`
                    )->a( n = `class`   v = `sapUiSmallMarginBottom`
                    )->a( n = `active`  v = `true`
                    )->a( n = `binding` v = |\{{ client->_bind( val = t_products path = abap_true ) }/4\}|
                    )->a( n = `press`   v = client->_event( `PRESS` )
                    )->a( n = `number`  v = num
                    )->a( n = `unit`    v = `{CURRENCY_CODE}`
                    )->a( n = `state`   v = `Information`

            )->shut(
        )->shut(

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`
            )->leaf( `Label`
                )->a( n = `text`   v = `Inverted Interactive ObjectNumber`
                )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->a( n = `design` v = `Bold`
            )->open( n = `HorizontalLayout` ns = `l`
                )->a( n = `class` v = `sapUiContentPadding`
                )->leaf( `ObjectNumber`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                    )->a( n = `active`   v = `true`
                    )->a( n = `inverted` v = `true`
                    )->a( n = `binding`  v = |\{{ client->_bind( val = t_products path = abap_true ) }/0\}|
                    )->a( n = `press`    v = client->_event( `PRESS` )
                    )->a( n = `number`   v = num
                    )->a( n = `unit`     v = `{CURRENCY_CODE}`
                )->leaf( `ObjectNumber`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                    )->a( n = `active`   v = `true`
                    )->a( n = `inverted` v = `true`
                    )->a( n = `binding`  v = |\{{ client->_bind( val = t_products path = abap_true ) }/1\}|
                    )->a( n = `press`    v = client->_event( `PRESS` )
                    )->a( n = `number`   v = num
                    )->a( n = `unit`     v = `{CURRENCY_CODE}`
                    )->a( n = `state`    v = `Error`
                )->leaf( `ObjectNumber`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                    )->a( n = `active`   v = `true`
                    )->a( n = `inverted` v = `true`
                    )->a( n = `binding`  v = |\{{ client->_bind( val = t_products path = abap_true ) }/2\}|
                    )->a( n = `press`    v = client->_event( `PRESS` )
                    )->a( n = `number`   v = num
                    )->a( n = `unit`     v = `{CURRENCY_CODE}`
                    )->a( n = `state`    v = `Warning`
                )->leaf( `ObjectNumber`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                    )->a( n = `active`   v = `true`
                    )->a( n = `inverted` v = `true`
                    )->a( n = `binding`  v = |\{{ client->_bind( val = t_products path = abap_true ) }/3\}|
                    )->a( n = `press`    v = client->_event( `PRESS` )
                    )->a( n = `number`   v = num
                    )->a( n = `unit`     v = `{CURRENCY_CODE}`
                    )->a( n = `state`    v = `Success`
                )->leaf( `ObjectNumber`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom`
                    )->a( n = `active`   v = `true`
                    )->a( n = `inverted` v = `true`
                    )->a( n = `binding`  v = |\{{ client->_bind( val = t_products path = abap_true ) }/4\}|
                    )->a( n = `press`    v = client->_event( `PRESS` )
                    )->a( n = `number`   v = num
                    )->a( n = `unit`     v = `{CURRENCY_CODE}`
                    )->a( n = `state`    v = `Information`

            )->shut(
        )->shut(

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->leaf( `Label`
                )->a( n = `text`   v = `ObjectNumber with style sapMObjectNumberLarge applied`
                )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->a( n = `design` v = `Bold`
            )->leaf( `ObjectNumber`
                )->a( n = `class`      v = `sapMObjectNumberLarge`
                )->a( n = `binding`    v = |\{{ client->_bind( val = t_products path = abap_true ) }/5\}|
                )->a( n = `number`     v = num
                )->a( n = `unit`       v = `{CURRENCY_CODE}`
                )->a( n = `emphasized` v = `false`
                )->a( n = `state`      v = `None`

            )->leaf( `Label`
                )->a( n = `text`   v = `Interactive ObjectNumber with style sapMObjectNumberLarge applied`
                )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->a( n = `design` v = `Bold`
            )->leaf( `ObjectNumber`
                )->a( n = `class`      v = `sapMObjectNumberLarge`
                )->a( n = `active`     v = `true`
                )->a( n = `binding`    v = |\{{ client->_bind( val = t_products path = abap_true ) }/5\}|
                )->a( n = `press`      v = client->_event( `PRESS` )
                )->a( n = `number`     v = num
                )->a( n = `unit`       v = `{CURRENCY_CODE}`
                )->a( n = `emphasized` v = `false`
                )->a( n = `state`      v = `None`

            )->leaf( `Label`
                )->a( n = `text`   v = `ObjectNumber wrapped via sapMObjectNumberLongText`
                )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->a( n = `design` v = `Bold`
            )->open( `Panel`
                )->a( n = `backgroundDesign` v = `Transparent`
                )->a( n = `width`            v = `100px`
                )->open( `content`
                    )->leaf( `ObjectNumber`
                        )->a( n = `class`      v = `sapMObjectNumberLongText`
                        )->a( n = `active`     v = `true`
                        )->a( n = `binding`    v = |\{{ client->_bind( val = t_products path = abap_true ) }/5\}|
                        )->a( n = `press`      v = client->_event( `PRESS` )
                        )->a( n = `number`     v = `12345678901234567890`
                        )->a( n = `unit`       v = `{CURRENCY_CODE}`
                        )->a( n = `emphasized` v = `false`
                        )->a( n = `state`      v = `None`

                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `PRESS`.
        " the original's onPress - MessageToast.show('PRESS fired!')
        client->message_toast_display( `PRESS fired!` ).
    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " records /ProductCollection/0..5 of ui5/mock/products.json, verbatim (Price + CurrencyCode)
    t_products = VALUE #(
      ( price = '956.00'  currency_code = `EUR` )
      ( price = '1249.00' currency_code = `EUR` )
      ( price = '1570.00' currency_code = `EUR` )
      ( price = '1650.00' currency_code = `EUR` )
      ( price = '299.00'  currency_code = `EUR` )
      ( price = '1999.00' currency_code = `EUR` ) ).

  ENDMETHOD.

ENDCLASS.
