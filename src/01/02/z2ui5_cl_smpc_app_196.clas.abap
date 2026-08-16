CLASS z2ui5_cl_smpc_app_196 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_number,
        currency TYPE string,
        price    TYPE p LENGTH 9 DECIMALS 7,
      END OF ty_s_number,
      BEGIN OF ty_s_nondecimal,
        currency TYPE string,
        price    TYPE p LENGTH 9 DECIMALS 2,
      END OF ty_s_nondecimal,
      BEGIN OF ty_s_string,
        currency TYPE string,
        price    TYPE string,
      END OF ty_s_string.
    DATA variousnumberdatamodel      TYPE STANDARD TABLE OF ty_s_number WITH EMPTY KEY.
    DATA nondecimalcurrencydatamodel TYPE STANDARD TABLE OF ty_s_nondecimal WITH EMPTY KEY.
    DATA bignumberdatamodel          TYPE STANDARD TABLE OF ty_s_string WITH EMPTY KEY.
    DATA customcurrencydatamodel     TYPE STANDARD TABLE OF ty_s_string WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_196 IMPLEMENTATION.

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
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`

        )->ele( n = `Grid` ns = `l`
            )->a( n = `defaultSpan` v = `XL7 L12 M12 S12`

            )->ele( `List`
                )->a( n = `id`         v = `listOneId`
                )->a( n = `headerText` v = `Various currencies with and without decimals`
                )->a( n = `items`      v = client->_bind( variousnumberdatamodel )

                )->ele( `CustomListItem`
                    )->tag( n = `Currency` ns = `u`
                        )->a( n = `value`     v = `{PRICE}`
                        )->a( n = `currency`  v = `{CURRENCY}`
                        )->a( n = `useSymbol` v = `false`

                )->end(
            )->end(
            )->ele( `List`
                )->a( n = `id`         v = `listTwoId`
                )->a( n = `headerText` v = `Currency without decimals`
                )->a( n = `items`      v = client->_bind( nondecimalcurrencydatamodel )

                )->ele( `CustomListItem`
                    )->tag( n = `Currency` ns = `u`
                        )->a( n = `value`     v = `{PRICE}`
                        )->a( n = `currency`  v = `{CURRENCY}`
                        )->a( n = `useSymbol` v = `false`

                )->end(
            )->end(
            )->ele( `List`
                )->a( n = `id`         v = `listThreeId`
                )->a( n = `headerText` v = `Currency without decimals using maxPrecision`
                )->a( n = `items`      v = client->_bind( nondecimalcurrencydatamodel )

                )->ele( `CustomListItem`
                    )->tag( n = `Currency` ns = `u`
                        )->a( n = `value`        v = `{PRICE}`
                        )->a( n = `currency`     v = `{CURRENCY}`
                        )->a( n = `useSymbol`    v = `false`
                        )->a( n = `maxPrecision` v = `0`

                )->end(
            )->end(
            )->ele( `List`
                )->a( n = `id`         v = `listFourId`
                )->a( n = `headerText` v = `Currency with really big numbers`
                )->a( n = `items`      v = client->_bind( bignumberdatamodel )

                )->ele( `CustomListItem`
                    )->tag( n = `Currency` ns = `u`
                        )->a( n = `stringValue` v = `{PRICE}`
                        )->a( n = `currency`    v = `{CURRENCY}`
                        )->a( n = `useSymbol`   v = `false`

                )->end(
            )->end(
            )->ele( `List`
                )->a( n = `id`         v = `listFiveId`
                )->a( n = `headerText` v = `Custom currencies with decimals`
                )->a( n = `items`      v = client->_bind( customcurrencydatamodel )

                )->ele( `CustomListItem`
                    )->tag( n = `Currency` ns = `u`
                        )->a( n = `stringValue` v = `{PRICE}`
                        )->a( n = `currency`    v = `{CURRENCY}`
                        )->a( n = `useSymbol`   v = `false`

                )->end(
            )->end(
            )->ele( `List`
                )->a( n = `id`         v = `listSixId`
                )->a( n = `headerText` v = `Different currencies with maxPrecision 3`
                )->a( n = `items`      v = client->_bind( variousnumberdatamodel )

                )->ele( `CustomListItem`
                    )->tag( n = `Currency` ns = `u`
                        )->a( n = `stringValue`  v = `{PRICE}`
                        )->a( n = `currency`     v = `{CURRENCY}`
                        )->a( n = `useSymbol`    v = `false`
                        )->a( n = `maxPrecision` v = `3` ).

    client->view_display( view->stringify( ) ).

    " the controller's Formatting.setCustomCurrencies({BGN4:{digits:4},
    " WWWW:{digits:5}}) - list five renders those two codes with 4 and 5
    " decimals instead of the standard digit count
    client->follow_up_action( val   = client->cs_event-control_global
                              t_arg = VALUE #( ( `FORMATTING` )
                                               ( `setCustomCurrencies` )
                                               ( `{"BGN4":{"digits":4},"WWWW":{"digits":5}}` ) ) ).

  ENDMETHOD.


  METHOD model_init.

    " inline mock data of the sample's controller (the four JSONModel arrays).
    " the controller's Formatting.setCustomCurrencies (BGN4/WWWW digit
    " definitions) is reproduced in on_rendering( ), so list five renders
    " those two codes with 4 and 5 decimals like the original
    variousnumberdatamodel = VALUE #(
        ( currency = `EUR` price = `2300.12` )
        ( currency = `EUR` price = `38` )
        ( currency = `JPY` price = `1928472` )
        ( currency = `JPY` price = `233.9385763` )
        ( currency = `USD` price = `125.02` )
        ( currency = `USD` price = `2125.02843` )
        ( currency = `TND` price = `9283` )
        ( currency = `TND` price = `235.0298` ) ).

    nondecimalcurrencydatamodel = VALUE #(
        ( currency = `JPY` price = `2300.12` )
        ( currency = `JPY` price = `38` )
        ( currency = `JPY` price = `1928472` )
        ( currency = `JPY` price = `233` ) ).

    bignumberdatamodel = VALUE #(
        ( currency = `USD` price = `12345678901234567890123` )
        ( currency = `USD` price = `123456789012345678901.23` ) ).

    customcurrencydatamodel = VALUE #(
        ( currency = `BGN4` price = `123.4567` )
        ( currency = `WWWW` price = `123.45676` ) ).

  ENDMETHOD.

ENDCLASS.
