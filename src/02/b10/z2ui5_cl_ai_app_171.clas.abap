CLASS z2ui5_cl_ai_app_171 DEFINITION PUBLIC.

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
    DATA t_modeldata TYPE STANDARD TABLE OF ty_s_data WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_171 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`

        )->open( `Table`
            )->a( n = `id`    v = `idProductsTable`
            )->a( n = `items` v = client->_bind( t_modeldata )

            )->open( `columns`
                )->open( `Column`
                    )->a( n = `id`     v = `exapnseColumn`
                    )->a( n = `hAlign` v = `Begin`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Expense`

                )->shut(
                )->open( `Column`
                    )->a( n = `id`     v = `transactionAmountColumn`
                    )->a( n = `hAlign` v = `End`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Transaction amount`

                )->shut(
                )->open( `Column`
                    )->a( n = `id`     v = `exchangeRateColumn`
                    )->a( n = `hAlign` v = `End`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Exchange rate`

                )->shut(
                )->open( `Column`
                    )->a( n = `id`     v = `amountColumn`
                    )->a( n = `hAlign` v = `End`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Amount`

                )->shut(
            )->shut(

            )->open( `items`
                )->open( `ColumnListItem`
                    )->open( `cells`
                        )->leaf( `ObjectIdentifier`
                            )->a( n = `text` v = `{EXPENSE}`
                        )->leaf( n = `Currency` ns = `u`
                            )->a( n = `value`        v = `{TRANSACTION_AMOUNT/SIZE}`
                            )->a( n = `currency`     v = `{TRANSACTION_AMOUNT/CURRENCY}`
                            )->a( n = `maxPrecision` v = `2`
                            )->a( n = `useSymbol`    v = `false`
                        )->leaf( `ObjectNumber`
                            )->a( n = `number` v = |\{ path: 'EXCHANGE_RATE', type: 'sap.ui.model.type.Float', formatOptions: \{ minFractionDigits: 5, maxFractionDigits: 5 \} \}|
                        )->leaf( `ObjectNumber`
                            )->a( n = `number` v = |\{ path: 'AMOUNT', type: 'sap.ui.model.type.Float', formatOptions: \{ minFractionDigits: 2, maxFractionDigits: 2 \} \}|
                            )->a( n = `unit`   v = `EUR` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " inline mock data of the sample's controller (aData -> /modelData)
    t_modeldata = VALUE #(
        ( expense            = `Flight`
          transaction_amount = VALUE #( size = `560.67` currency = `EUR` )
          exchange_rate      = `1.00000`
          amount             = `560.67` )
        ( expense            = `Meals`
          transaction_amount = VALUE #( size = `180.50` currency = `USD` )
          exchange_rate      = `0.85654`
          amount             = `154.72` )
        ( expense            = `Hotel`
          transaction_amount = VALUE #( size = `675.00` currency = `USD` )
          exchange_rate      = `0.85654`
          amount             = `578.57` )
        ( expense            = `Taxi`
          transaction_amount = VALUE #( size = `15` currency = `USD` )
          exchange_rate      = `0.85654`
          amount             = `12.86` )
        ( expense            = `Daily allowance`
          transaction_amount = VALUE #( size = `80.00` currency = `BGN` )
          exchange_rate      = `0.51129`
          amount             = `40.90` )
        ( expense            = `Daily allowance Japan`
          transaction_amount = VALUE #( size = `7000` currency = `JPY` )
          exchange_rate      = `0.0067`
          amount             = `46.69` ) ).

  ENDMETHOD.

ENDCLASS.
