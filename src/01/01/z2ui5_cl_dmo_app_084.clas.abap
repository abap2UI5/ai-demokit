CLASS z2ui5_cl_dmo_app_084 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_supplier,
        supplier_name TYPE string,
        tel           TYPE string,
        sms           TYPE string,
        email         TYPE string,
        url           TYPE string,
      END OF ty_s_supplier.
    DATA s_supplier TYPE ty_s_supplier.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_084 IMPLEMENTATION.

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
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `List`
            )->a( n = `headerText` v = `{SUPPLIER_NAME}`
            " element binding kept 1:1 - a one-record structure /S_SUPPLIER instead of {/SupplierCollection/0}
            )->a( n = `binding`    v = client->_bind( s_supplier )

            )->open( `items`
                " URLHelper.triggerTel/triggerSms/triggerEmail/redirect map 1:1 to the URLHELPER frontend action
                )->leaf( `DisplayListItem`
                    )->a( n = `label` v = `Telephone`
                    )->a( n = `value` v = `{TEL}`
                    )->a( n = `type`  v = `Active`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-urlhelper
                                                                    t_arg = VALUE #( ( `TRIGGER_TEL` ) ( s_supplier-tel ) ) )
                )->leaf( `DisplayListItem`
                    )->a( n = `label` v = `SMS`
                    )->a( n = `value` v = `{SMS}`
                    )->a( n = `type`  v = `Active`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-urlhelper
                                                                    t_arg = VALUE #( ( `TRIGGER_SMS` ) ( s_supplier-sms ) ) )
                )->leaf( `DisplayListItem`
                    )->a( n = `label` v = `Email`
                    )->a( n = `value` v = `{EMAIL}`
                    )->a( n = `type`  v = `Active`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-urlhelper
                                                                    t_arg = VALUE #( ( `TRIGGER_EMAIL` ) ( |\{ EMAIL: '{ s_supplier-email }', SUBJECT: 'Info Request', NEW_WINDOW: true \}| ) ) )
                )->leaf( `DisplayListItem`
                    )->a( n = `label` v = `Website`
                    )->a( n = `value` v = `{URL}`
                    )->a( n = `type`  v = `Active`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-urlhelper
                                                                    t_arg = VALUE #( ( `REDIRECT` ) ( |\{ URL: '{ s_supplier-url }', NEW_WINDOW: true \}| ) ) )

            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the bound record /SupplierCollection/0 (Red Point Stores) of ui5/mock/supplier.json, verbatim
    s_supplier = VALUE #( supplier_name = `Red Point Stores`
                          tel           = `+49 6227 747474`
                          sms           = `+49 173 123456`
                          email         = `john.smith@sap.com`
                          url           = `http://www.sap.com` ).

  ENDMETHOD.

ENDCLASS.
