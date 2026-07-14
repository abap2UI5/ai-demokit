"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.ui.model.type.Currency - TypeCurrency
"! https://sdk.openui5.org/entity/sap.ui.model.type.Currency/sample/sap.ui.core.sample.TypeCurrency
CLASS z2ui5_cl_api_app_503 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA amount TYPE p LENGTH 14 DECIMALS 3.
    DATA currency TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_503 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      amount   = `123456789.123`.
      currency = `USD`.

      view_display( ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(amount_path)   = client->_bind_edit( val  = amount
                                              path = abap_true ).
    DATA(currency_path) = client->_bind_edit( val  = currency
                                              path = abap_true ).
    DATA(parts) = |parts: [ '{ amount_path }', '{ currency_path }' ], type: 'sap.ui.model.type.Currency'|.

    DATA(page) = z2ui5_cl_xml_view=>factory( ).

    page->simple_form(
        title      = `Input`
        editable   = abap_true
        width      = `auto`
        class      = `sapUiResponsiveMargin`
        layout     = `ResponsiveGridLayout`
        labelspanl = `3`
        labelspanm = `3`
        emptyspanl = `4`
        emptyspanm = `4`
        columnsl   = `1`
        columnsm   = `1`
        )->content( `form`
        )->label( `One field`
        )->input( |\{ { parts } \}|
        )->label( `Two field`
        )->input( |\{ { parts }, formatOptions: \{ showMeasure: false \} \}|
        )->input( |\{ { parts }, formatOptions: \{ showNumber: false \} \}| ).

    " The row for the preserveDecimals format option is omitted - the option was introduced after UI5 1.71
    page->simple_form(
        title      = `Format options`
        width      = `auto`
        class      = `sapUiResponsiveMargin`
        layout     = `ResponsiveGridLayout`
        labelspanl = `3`
        labelspanm = `3`
        emptyspanl = `4`
        emptyspanm = `4`
        columnsl   = `1`
        columnsm   = `1`
        )->content( `form`
        )->label( `Default`
        )->text( |\{ { parts } \}|
        )->label( `currencyCode:false`
        )->text( |\{ { parts }, formatOptions: \{ currencyCode: false \} \}|
        )->label( `style:'short'`
        )->text( |\{ { parts }, formatOptions: \{ style: 'short' \} \}|
        )->label( `style:'long'`
        )->text( |\{ { parts }, formatOptions: \{ style: 'long' \} \}| ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
