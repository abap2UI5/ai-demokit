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

    DATA t_customers       TYPE STANDARD TABLE OF ty_s_customer WITH EMPTY KEY.
    DATA t_accountmanagers TYPE STANDARD TABLE OF ty_s_accountmanager WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_265 IMPLEMENTATION.

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
                            )->a( n = `items`          v = |\{ path: '{ client->_bind( val = t_accountmanagers path = abap_true ) }', | &&
                                                           |templateShareable: false, boundFilters: [\{ path: 'REGION', operator: 'EQ', | &&
                                                           |value1: '\{REGION\}' \}] \}|

                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `{ID}`
                                )->a( n = `text` v = |\{parts: ['FIRSTNAME', 'LASTNAME']\}|

                            ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    t_customers = VALUE #(
      ( key = 1  name = `TechCorp Solutions`        region = `Americas` accountmanagerid = 1 )
      ( key = 4  name = `Innovation Systems Inc`    region = `Americas` accountmanagerid = 1 )
      ( key = 2  name = `Global Industries Ltd`     region = `EMEA`     accountmanagerid = 6 )
      ( key = 3  name = `Asia Pacific Ventures`     region = `APJ`      accountmanagerid = 10 )
      ( key = 8  name = `Continental Solutions`     region = `EMEA`     accountmanagerid = 6 )
      ( key = 5  name = `European Tech Group`       region = `EMEA`     accountmanagerid = 8 )
      ( key = 6  name = `Pacific Rim Enterprises`   region = `APJ`      accountmanagerid = 10 )
      ( key = 7  name = `Digital Dynamics Corp`     region = `Americas` accountmanagerid = 3 )
      ( key = 10 name = `Atlantic Technologies`     region = `Americas` accountmanagerid = 3 )
      ( key = 9  name = `Eastern Markets Ltd`       region = `APJ`      accountmanagerid = 11 )
      ( key = 11 name = `Nordic Innovations`        region = `EMEA`     accountmanagerid = 8 )
      ( key = 12 name = `Southeast Asia Holdings`   region = `APJ`      accountmanagerid = 11 )
      ( key = 13 name = `North American Systems`    region = `Americas` accountmanagerid = 5 )
      ( key = 14 name = `Mediterranean Group`       region = `EMEA`     accountmanagerid = 7 )
      ( key = 15 name = `Indo-Pacific Corp`         region = `APJ`      accountmanagerid = 12 )
      ( key = 16 name = `Western Digital Solutions` region = `Americas` accountmanagerid = 2 )
      ( key = 17 name = `Alpine Technologies`       region = `EMEA`     accountmanagerid = 7 )
      ( key = 18 name = `Oceanic Enterprises`       region = `APJ`      accountmanagerid = 12 )
      ( key = 19 name = `Great Lakes Industries`    region = `Americas` accountmanagerid = 2 )
      ( key = 20 name = `Baltic Solutions Ltd`      region = `EMEA`     accountmanagerid = 8 ) ).

    t_accountmanagers = VALUE #(
      ( id = 1  firstname = `John`      lastname = `Smith`    region = `Americas` )
      ( id = 2  firstname = `Sarah`     lastname = `Johnson`  region = `Americas` )
      ( id = 3  firstname = `Mike`      lastname = `Williams` region = `Americas` )
      ( id = 4  firstname = `Jennifer`  lastname = `Brown`    region = `Americas` )
      ( id = 5  firstname = `David`     lastname = `Jones`    region = `Americas` )
      ( id = 6  firstname = `Emma`      lastname = `Anderson` region = `EMEA` )
      ( id = 7  firstname = `Lucas`     lastname = `Mueller`  region = `EMEA` )
      ( id = 8  firstname = `Sophie`    lastname = `Dubois`   region = `EMEA` )
      ( id = 9  firstname = `Marco`     lastname = `Rossi`    region = `EMEA` )
      ( id = 10 firstname = `Yuki`      lastname = `Tanaka`   region = `APJ` )
      ( id = 11 firstname = `Raj`       lastname = `Patel`    region = `APJ` )
      ( id = 12 firstname = `Li`        lastname = `Chen`     region = `APJ` )
      ( id = 13 firstname = `Priya`     lastname = `Sharma`   region = `APJ` ) ).

  ENDMETHOD.

ENDCLASS.
