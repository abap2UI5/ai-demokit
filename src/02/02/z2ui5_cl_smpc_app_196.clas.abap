" @keywords currency sap.ui.unified grid list customlistitem
" @summary Display Currencies with proper Alignment
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
    DATA variousnumberdatamodel      TYPE STANDARD TABLE OF ty_s_number WITH DEFAULT KEY.
    DATA nondecimalcurrencydatamodel TYPE STANDARD TABLE OF ty_s_nondecimal WITH DEFAULT KEY.
    DATA bignumberdatamodel          TYPE STANDARD TABLE OF ty_s_string WITH DEFAULT KEY.
    DATA customcurrencydatamodel     TYPE STANDARD TABLE OF ty_s_string WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_196 IMPLEMENTATION.

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
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

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
    " WWWW:{digits:5}}). The original runs it in onInit, BEFORE the view exists;
    " a client action necessarily runs after the render, and sap.ui.unified.Currency
    " caches its NumberFormat in init( ) and implements no localization-change
    " hook - so the two codes still render with the CLDR default digits here.
    " The registration itself is real (it reaches a BOUND
    " sap.ui.model.type.Currency, which does re-format); this control cannot
    " pick it up. Measured 2026-08-23
    
    CLEAR temp1.
    INSERT `FORMATTING` INTO TABLE temp1.
    INSERT `setCustomCurrencies` INTO TABLE temp1.
    INSERT `{"BGN4":{"digits":4},"WWWW":{"digits":5}}` INTO TABLE temp1.
    client->follow_up_action( val   = client->cs_event-control_global
                              t_arg = temp1 ).

  ENDMETHOD.


  METHOD model_init.

    " inline mock data of the sample's controller (the four JSONModel arrays).
    " the Formatting.setCustomCurrencies call sits at the end of view_display( )
    " - see the note there for what it can and cannot reach
    DATA temp3 LIKE variousnumberdatamodel.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 LIKE nondecimalcurrencydatamodel.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp7 LIKE bignumberdatamodel.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp9 LIKE customcurrencydatamodel.
    DATA temp10 LIKE LINE OF temp9.
    CLEAR temp3.
    
    temp4-currency = `EUR`.
    temp4-price = `2300.12`.
    INSERT temp4 INTO TABLE temp3.
    temp4-currency = `EUR`.
    temp4-price = `38`.
    INSERT temp4 INTO TABLE temp3.
    temp4-currency = `JPY`.
    temp4-price = `1928472`.
    INSERT temp4 INTO TABLE temp3.
    temp4-currency = `JPY`.
    temp4-price = `233.9385763`.
    INSERT temp4 INTO TABLE temp3.
    temp4-currency = `USD`.
    temp4-price = `125.02`.
    INSERT temp4 INTO TABLE temp3.
    temp4-currency = `USD`.
    temp4-price = `2125.02843`.
    INSERT temp4 INTO TABLE temp3.
    temp4-currency = `TND`.
    temp4-price = `9283`.
    INSERT temp4 INTO TABLE temp3.
    temp4-currency = `TND`.
    temp4-price = `235.0298`.
    INSERT temp4 INTO TABLE temp3.
    variousnumberdatamodel = temp3.

    
    CLEAR temp5.
    
    temp6-currency = `JPY`.
    temp6-price = `2300.12`.
    INSERT temp6 INTO TABLE temp5.
    temp6-currency = `JPY`.
    temp6-price = `38`.
    INSERT temp6 INTO TABLE temp5.
    temp6-currency = `JPY`.
    temp6-price = `1928472`.
    INSERT temp6 INTO TABLE temp5.
    temp6-currency = `JPY`.
    temp6-price = `233`.
    INSERT temp6 INTO TABLE temp5.
    nondecimalcurrencydatamodel = temp5.

    
    CLEAR temp7.
    
    temp8-currency = `USD`.
    temp8-price = `12345678901234567890123`.
    INSERT temp8 INTO TABLE temp7.
    temp8-currency = `USD`.
    temp8-price = `123456789012345678901.23`.
    INSERT temp8 INTO TABLE temp7.
    bignumberdatamodel = temp7.

    
    CLEAR temp9.
    
    temp10-currency = `BGN4`.
    temp10-price = `123.4567`.
    INSERT temp10 INTO TABLE temp9.
    temp10-currency = `WWWW`.
    temp10-price = `123.45676`.
    INSERT temp10 INTO TABLE temp9.
    customcurrencydatamodel = temp9.

  ENDMETHOD.

ENDCLASS.
