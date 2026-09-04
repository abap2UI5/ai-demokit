" @keywords currency sap.ui.unified amounts table column text columnlistitem objectidentifier objectnumber
" @summary Display Currencies in Table
CLASS z2ui5_cl_smpc_app_171 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_transaction_amount,
        size     TYPE p LENGTH 14 DECIMALS 2,
        currency TYPE string,
      END OF ty_s_transaction_amount,
      BEGIN OF ty_s_data,
        expense            TYPE string,
        transaction_amount TYPE ty_s_transaction_amount,
        exchange_rate      TYPE p LENGTH 13 DECIMALS 5,
        amount             TYPE p LENGTH 14 DECIMALS 2,
      END OF ty_s_data.
    DATA t_modeldata TYPE STANDARD TABLE OF ty_s_data WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_171 IMPLEMENTATION.

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
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`

        )->ele( `Table`
            )->a( n = `id`    v = `idProductsTable`
            )->a( n = `items` v = client->_bind( t_modeldata )

            )->ele( `columns`
                )->ele( `Column`
                    )->a( n = `id`     v = `exapnseColumn`
                    )->a( n = `hAlign` v = `Begin`

                    )->tag( `Text`
                        )->a( n = `text` v = `Expense`

                )->end(
                )->ele( `Column`
                    )->a( n = `id`     v = `transactionAmountColumn`
                    )->a( n = `hAlign` v = `End`

                    )->tag( `Text`
                        )->a( n = `text` v = `Transaction amount`

                )->end(
                )->ele( `Column`
                    )->a( n = `id`     v = `exchangeRateColumn`
                    )->a( n = `hAlign` v = `End`

                    )->tag( `Text`
                        )->a( n = `text` v = `Exchange rate`

                )->end(
                )->ele( `Column`
                    )->a( n = `id`     v = `amountColumn`
                    )->a( n = `hAlign` v = `End`

                    )->tag( `Text`
                        )->a( n = `text` v = `Amount`

                )->end(
            )->end(

            )->ele( `items`
                )->ele( `ColumnListItem`
                    )->ele( `cells`
                        )->tag( `ObjectIdentifier`
                            )->a( n = `text` v = `{EXPENSE}`
                        )->tag( n = `Currency` ns = `u`
                            )->a( n = `value`        v = `{TRANSACTION_AMOUNT/SIZE}`
                            )->a( n = `currency`     v = `{TRANSACTION_AMOUNT/CURRENCY}`
                            )->a( n = `maxPrecision` v = `2`
                            )->a( n = `useSymbol`    v = `false`
                        )->tag( `ObjectNumber`
                            )->a( n = `number` v = |\{ path: 'EXCHANGE_RATE', type: 'sap.ui.model.type.Float', formatOptions: \{ minFractionDigits: 5, maxFractionDigits: 5 \} \}|
                        )->tag( `ObjectNumber`
                            )->a( n = `number` v = |\{ path: 'AMOUNT', type: 'sap.ui.model.type.Float', formatOptions: \{ minFractionDigits: 2, maxFractionDigits: 2 \} \}|
                            )->a( n = `unit`   v = `EUR` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " inline mock data of the sample's controller (aData -> /modelData)
    DATA temp1 LIKE t_modeldata.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-expense = `Flight`.
    CLEAR temp2-transaction_amount.
    temp2-transaction_amount-size = `560.67`.
    temp2-transaction_amount-currency = `EUR`.
    temp2-exchange_rate = `1.00000`.
    temp2-amount = `560.67`.
    INSERT temp2 INTO TABLE temp1.
    temp2-expense = `Meals`.
    CLEAR temp2-transaction_amount.
    temp2-transaction_amount-size = `180.50`.
    temp2-transaction_amount-currency = `USD`.
    temp2-exchange_rate = `0.85654`.
    temp2-amount = `154.72`.
    INSERT temp2 INTO TABLE temp1.
    temp2-expense = `Hotel`.
    CLEAR temp2-transaction_amount.
    temp2-transaction_amount-size = `675.00`.
    temp2-transaction_amount-currency = `USD`.
    temp2-exchange_rate = `0.85654`.
    temp2-amount = `578.57`.
    INSERT temp2 INTO TABLE temp1.
    temp2-expense = `Taxi`.
    CLEAR temp2-transaction_amount.
    temp2-transaction_amount-size = `15`.
    temp2-transaction_amount-currency = `USD`.
    temp2-exchange_rate = `0.85654`.
    temp2-amount = `12.86`.
    INSERT temp2 INTO TABLE temp1.
    temp2-expense = `Daily allowance`.
    CLEAR temp2-transaction_amount.
    temp2-transaction_amount-size = `80.00`.
    temp2-transaction_amount-currency = `BGN`.
    temp2-exchange_rate = `0.51129`.
    temp2-amount = `40.90`.
    INSERT temp2 INTO TABLE temp1.
    temp2-expense = `Daily allowance Japan`.
    CLEAR temp2-transaction_amount.
    temp2-transaction_amount-size = `7000`.
    temp2-transaction_amount-currency = `JPY`.
    temp2-exchange_rate = `0.0067`.
    temp2-amount = `46.69`.
    INSERT temp2 INTO TABLE temp1.
    t_modeldata = temp1.

  ENDMETHOD.

ENDCLASS.
