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
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE string_table.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 TYPE string_table.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp7 TYPE string_table.
    DATA temp8 LIKE LINE OF temp7.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `TRIGGER_TEL` INTO TABLE temp1.
    
    temp2 = |\{ TEL: '{ s_supplier-tel }' \}|.
    INSERT temp2 INTO TABLE temp1.
    
    CLEAR temp3.
    INSERT `TRIGGER_SMS` INTO TABLE temp3.
    
    temp4 = |\{ TEL: '{ s_supplier-sms }' \}|.
    INSERT temp4 INTO TABLE temp3.
    
    CLEAR temp5.
    INSERT `TRIGGER_EMAIL` INTO TABLE temp5.
    
    temp6 = |\{ EMAIL: '{ s_supplier-email }', SUBJECT: 'Info Request', NEW_WINDOW: true \}|.
    INSERT temp6 INTO TABLE temp5.
    
    CLEAR temp7.
    INSERT `REDIRECT` INTO TABLE temp7.
    
    temp8 = |\{ URL: '{ s_supplier-url }', NEW_WINDOW: true \}|.
    INSERT temp8 INTO TABLE temp7.
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
                                                                    t_arg = temp1 )
                )->tag( `DisplayListItem`
                    )->a( n = `label` v = `SMS`
                    )->a( n = `value` v = `{SMS}`
                    )->a( n = `type`  v = `Active`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-urlhelper
                                                                    t_arg = temp3 )
                )->tag( `DisplayListItem`
                    )->a( n = `label` v = `Email`
                    )->a( n = `value` v = `{EMAIL}`
                    )->a( n = `type`  v = `Active`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-urlhelper
                                                                    t_arg = temp5 )
                )->tag( `DisplayListItem`
                    )->a( n = `label` v = `Website`
                    )->a( n = `value` v = `{URL}`
                    )->a( n = `type`  v = `Active`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-urlhelper
                                                                    t_arg = temp7 )

            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the bound record /SupplierCollection/0 (Red Point Stores) of ui5/mock/supplier.json, verbatim
    CLEAR s_supplier.
    s_supplier-supplier_name = `Red Point Stores`.
    s_supplier-tel = `+49 6227 747474`.
    s_supplier-sms = `+49 173 123456`.
    s_supplier-email = `john.smith@sap.com`.
    s_supplier-url = `http://www.sap.com`.

  ENDMETHOD.

ENDCLASS.
