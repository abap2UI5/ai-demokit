" @keywords urlhelper sap.m tel sms email url triggers list displaylistitem
" @summary The URL Helper can be used to easily trigger a phone's native apps like Email, Telephone and SMS. It can be used with any UI control but typically an active Display List Item is chosen.
CLASS z2ui5_cl_smpc_app_084 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smpc_app_084 IMPLEMENTATION.

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
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `List`
            )->a( n = `headerText` v = `{SUPPLIER_NAME}`
            " element binding kept 1:1 - a one-record structure /S_SUPPLIER instead of {/SupplierCollection/0}
            )->a( n = `binding`    v = client->_bind( s_supplier )

            )->ele( `items`
                " URLHelper.triggerTel/triggerSms/triggerEmail/redirect map 1:1 to the URLHELPER frontend action
                )->tag( `DisplayListItem`
                    )->a( n = `label` v = `Telephone`
                    )->a( n = `value` v = `{TEL}`
                    )->a( n = `type`  v = `Active`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-urlhelper
                                                                    t_arg = VALUE #( ( `TRIGGER_TEL` ) ( s_supplier-tel ) ) )
                )->tag( `DisplayListItem`
                    )->a( n = `label` v = `SMS`
                    )->a( n = `value` v = `{SMS}`
                    )->a( n = `type`  v = `Active`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-urlhelper
                                                                    t_arg = VALUE #( ( `TRIGGER_SMS` ) ( s_supplier-sms ) ) )
                )->tag( `DisplayListItem`
                    )->a( n = `label` v = `Email`
                    )->a( n = `value` v = `{EMAIL}`
                    )->a( n = `type`  v = `Active`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-urlhelper
                                                                    t_arg = VALUE #( ( `TRIGGER_EMAIL` ) ( |\{ EMAIL: '{ s_supplier-email }', SUBJECT: 'Info Request', NEW_WINDOW: true \}| ) ) )
                )->tag( `DisplayListItem`
                    )->a( n = `label` v = `Website`
                    )->a( n = `value` v = `{URL}`
                    )->a( n = `type`  v = `Active`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-urlhelper
                                                                    t_arg = VALUE #( ( `REDIRECT` ) ( |\{ URL: '{ s_supplier-url }', NEW_WINDOW: true \}| ) ) )

            )->end(
        )->end( ).

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
