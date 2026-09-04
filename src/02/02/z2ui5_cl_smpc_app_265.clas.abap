" @keywords filter sap.ui.model boundfilters.filteredlistintable table title column label text select item
" @summary This sample shows how bound filters work. It features a table of customers with a 'Select' control in each row. The 'Select' control uses the customer's region to filter the list of available account managers.
CLASS z2ui5_cl_smpc_app_265 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_customer,
             key              TYPE i,
             name             TYPE string,
             region           TYPE string,
             accountmanagerid TYPE i,
           END OF ty_s_customer.

    TYPES: BEGIN OF ty_s_accountmanager,
             id        TYPE i,
             firstname TYPE string,
             lastname  TYPE string,
             region    TYPE string,
           END OF ty_s_accountmanager.

    DATA t_customers       TYPE STANDARD TABLE OF ty_s_customer WITH DEFAULT KEY.
    DATA t_accountmanagers TYPE STANDARD TABLE OF ty_s_accountmanager WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_265 IMPLEMENTATION.

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

    " The Select's items binding carries a boundFilters entry whose value1 is
    " the RELATIVE row field {REGION} - each row's Select therefore lists only
    " the account managers of that row's region, and re-filters when the row's
    " region changes. Passed through 1:1 as a raw binding-info string.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `class`       v = `sapUiSizeCompact`
        )->a( n = `xmlns`       v = `sap.m`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:table` v = `sap.ui.table`
        )->a( n = `xmlns:core`  v = `sap.ui.core`

        )->ele( n = `Table` ns = `table`
            )->a( n = `id`   v = `myTable`
            )->a( n = `rows` v = client->_bind( t_customers )

            )->ele( n = `extension` ns = `table`
                )->tag( `Title`
                    )->a( n = `id`   v = `title`
                    )->a( n = `text` v = `Customers`

            )->end(

            )->ele( n = `columns` ns = `table`
                )->ele( n = `Column` ns = `table`
                    )->tag( `Label`
                        )->a( n = `text` v = `Customer`

                    )->ele( n = `template` ns = `table`
                        )->tag( `Text`
                            )->a( n = `text` v = `{NAME}`

                    )->end(
                )->end(

                )->ele( n = `Column` ns = `table`
                    )->tag( `Label`
                        )->a( n = `text` v = `Region`

                    )->ele( n = `template` ns = `table`
                        )->tag( `Text`
                            )->a( n = `text` v = `{REGION}`

                    )->end(
                )->end(

                )->ele( n = `Column` ns = `table`
                    )->tag( `Label`
                        )->a( n = `text` v = `Key Account Manager (filtered by region)`

                    )->ele( n = `template` ns = `table`
                        )->ele( `Select`
                            )->a( n = `forceSelection` v = `false`
                            )->a( n = `selectedKey`    v = `{ACCOUNTMANAGERID}`
                            )->a( n = `items`          v = |\{ path: '{ client->_bind_path( t_accountmanagers ) }', | &&
                                                           |templateShareable: false, boundFilters: [\{ path: 'REGION', operator: 'EQ', | &&
                                                           |value1: '\{REGION\}' \}] \}|

                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `{ID}`
                                )->a( n = `text` v = |\{parts: ['FIRSTNAME', 'LASTNAME']\}|

                            ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    DATA temp1 LIKE t_customers.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 LIKE t_accountmanagers.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp1.
    
    temp2-key = 1.
    temp2-name = `TechCorp Solutions`.
    temp2-region = `Americas`.
    temp2-accountmanagerid = 1.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = 4.
    temp2-name = `Innovation Systems Inc`.
    temp2-region = `Americas`.
    temp2-accountmanagerid = 1.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = 2.
    temp2-name = `Global Industries Ltd`.
    temp2-region = `EMEA`.
    temp2-accountmanagerid = 6.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = 3.
    temp2-name = `Asia Pacific Ventures`.
    temp2-region = `APJ`.
    temp2-accountmanagerid = 10.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = 8.
    temp2-name = `Continental Solutions`.
    temp2-region = `EMEA`.
    temp2-accountmanagerid = 6.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = 5.
    temp2-name = `European Tech Group`.
    temp2-region = `EMEA`.
    temp2-accountmanagerid = 8.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = 6.
    temp2-name = `Pacific Rim Enterprises`.
    temp2-region = `APJ`.
    temp2-accountmanagerid = 10.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = 7.
    temp2-name = `Digital Dynamics Corp`.
    temp2-region = `Americas`.
    temp2-accountmanagerid = 3.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = 10.
    temp2-name = `Atlantic Technologies`.
    temp2-region = `Americas`.
    temp2-accountmanagerid = 3.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = 9.
    temp2-name = `Eastern Markets Ltd`.
    temp2-region = `APJ`.
    temp2-accountmanagerid = 11.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = 11.
    temp2-name = `Nordic Innovations`.
    temp2-region = `EMEA`.
    temp2-accountmanagerid = 8.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = 12.
    temp2-name = `Southeast Asia Holdings`.
    temp2-region = `APJ`.
    temp2-accountmanagerid = 11.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = 13.
    temp2-name = `North American Systems`.
    temp2-region = `Americas`.
    temp2-accountmanagerid = 5.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = 14.
    temp2-name = `Mediterranean Group`.
    temp2-region = `EMEA`.
    temp2-accountmanagerid = 7.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = 15.
    temp2-name = `Indo-Pacific Corp`.
    temp2-region = `APJ`.
    temp2-accountmanagerid = 12.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = 16.
    temp2-name = `Western Digital Solutions`.
    temp2-region = `Americas`.
    temp2-accountmanagerid = 2.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = 17.
    temp2-name = `Alpine Technologies`.
    temp2-region = `EMEA`.
    temp2-accountmanagerid = 7.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = 18.
    temp2-name = `Oceanic Enterprises`.
    temp2-region = `APJ`.
    temp2-accountmanagerid = 12.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = 19.
    temp2-name = `Great Lakes Industries`.
    temp2-region = `Americas`.
    temp2-accountmanagerid = 2.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = 20.
    temp2-name = `Baltic Solutions Ltd`.
    temp2-region = `EMEA`.
    temp2-accountmanagerid = 8.
    INSERT temp2 INTO TABLE temp1.
    t_customers = temp1.

    
    CLEAR temp3.
    
    temp4-id = 1.
    temp4-firstname = `John`.
    temp4-lastname = `Smith`.
    temp4-region = `Americas`.
    INSERT temp4 INTO TABLE temp3.
    temp4-id = 2.
    temp4-firstname = `Sarah`.
    temp4-lastname = `Johnson`.
    temp4-region = `Americas`.
    INSERT temp4 INTO TABLE temp3.
    temp4-id = 3.
    temp4-firstname = `Mike`.
    temp4-lastname = `Williams`.
    temp4-region = `Americas`.
    INSERT temp4 INTO TABLE temp3.
    temp4-id = 4.
    temp4-firstname = `Jennifer`.
    temp4-lastname = `Brown`.
    temp4-region = `Americas`.
    INSERT temp4 INTO TABLE temp3.
    temp4-id = 5.
    temp4-firstname = `David`.
    temp4-lastname = `Jones`.
    temp4-region = `Americas`.
    INSERT temp4 INTO TABLE temp3.
    temp4-id = 6.
    temp4-firstname = `Emma`.
    temp4-lastname = `Anderson`.
    temp4-region = `EMEA`.
    INSERT temp4 INTO TABLE temp3.
    temp4-id = 7.
    temp4-firstname = `Lucas`.
    temp4-lastname = `Mueller`.
    temp4-region = `EMEA`.
    INSERT temp4 INTO TABLE temp3.
    temp4-id = 8.
    temp4-firstname = `Sophie`.
    temp4-lastname = `Dubois`.
    temp4-region = `EMEA`.
    INSERT temp4 INTO TABLE temp3.
    temp4-id = 9.
    temp4-firstname = `Marco`.
    temp4-lastname = `Rossi`.
    temp4-region = `EMEA`.
    INSERT temp4 INTO TABLE temp3.
    temp4-id = 10.
    temp4-firstname = `Yuki`.
    temp4-lastname = `Tanaka`.
    temp4-region = `APJ`.
    INSERT temp4 INTO TABLE temp3.
    temp4-id = 11.
    temp4-firstname = `Raj`.
    temp4-lastname = `Patel`.
    temp4-region = `APJ`.
    INSERT temp4 INTO TABLE temp3.
    temp4-id = 12.
    temp4-firstname = `Li`.
    temp4-lastname = `Chen`.
    temp4-region = `APJ`.
    INSERT temp4 INTO TABLE temp3.
    temp4-id = 13.
    temp4-firstname = `Priya`.
    temp4-lastname = `Sharma`.
    temp4-region = `APJ`.
    INSERT temp4 INTO TABLE temp3.
    t_accountmanagers = temp3.

  ENDMETHOD.

ENDCLASS.
