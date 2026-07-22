CLASS z2ui5_cl_ai_app_084 DEFINITION PUBLIC.

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
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_084 IMPLEMENTATION.

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

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `List`
            )->a( n = `headerText` v = `{SUPPLIER_NAME}`
            " element binding kept 1:1 - a one-record structure /S_SUPPLIER instead of {/SupplierCollection/0}
            )->a( n = `binding`    v = client->_bind( s_supplier )

            )->open( `items`
                )->leaf( `DisplayListItem`
                    )->a( n = `label` v = `Telephone`
                    )->a( n = `value` v = `{TEL}`
                    )->a( n = `type`  v = `Active`
                    )->a( n = `press` v = client->_event( val = `TEL` t_arg = VALUE #( ( `${$source>/value}` ) ) )
                )->leaf( `DisplayListItem`
                    )->a( n = `label` v = `SMS`
                    )->a( n = `value` v = `{SMS}`
                    )->a( n = `type`  v = `Active`
                    )->a( n = `press` v = client->_event( val = `SMS` t_arg = VALUE #( ( `${$source>/value}` ) ) )
                )->leaf( `DisplayListItem`
                    )->a( n = `label` v = `Email`
                    )->a( n = `value` v = `{EMAIL}`
                    )->a( n = `type`  v = `Active`
                    )->a( n = `press` v = client->_event( val = `EMAIL` t_arg = VALUE #( ( `${$source>/value}` ) ) )
                )->leaf( `DisplayListItem`
                    )->a( n = `label` v = `Website`
                    )->a( n = `value` v = `{URL}`
                    )->a( n = `type`  v = `Active`
                    )->a( n = `press` v = client->_event_client( val   = client->cs_event-open_new_tab
                                                                 t_arg = VALUE #( ( `${$source>/value}` ) ) )

            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    " URLHelper.triggerTel/triggerSms/triggerEmail have no server-side equivalent - shown as a toast; the website uses the open_new_tab frontend action
    CASE client->get( )-event.
      WHEN `TEL`.
        client->message_toast_display( |Call: { client->get_event_arg( ) }| ).
      WHEN `SMS`.
        client->message_toast_display( |SMS: { client->get_event_arg( ) }| ).
      WHEN `EMAIL`.
        client->message_toast_display( |Email: { client->get_event_arg( ) }| ).
    ENDCASE.

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
