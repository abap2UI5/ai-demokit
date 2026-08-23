" @keywords date sap.ui.model.type typedateasdate simpleform label datepicker text
" @summary This sample explains the formatting options of the Date type with the date being available as date object.
CLASS z2ui5_cl_smpc_app_282 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA date TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_282 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      " original seeds UI5Date.getInstance( ) - a Date object; the ABAP model
      " carries the same day as a yyyy-MM-dd string and a fixed date keeps the
      " port deterministic
      date = `2026-08-02`.
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " sap.ui.model.type.Date over a JSON model (TypeDateAsDate). The original
    " model holds a Date OBJECT, which a JSON round-trip cannot carry, so every
    " binding gains formatOptions.source pattern yyyy-MM-dd - the type then
    " parses the string model value and writes it back in the same form.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `core:require` v = `{DateType: 'sap/ui/model/type/Date'}`

        )->ele( n = `SimpleForm` ns = `form`
            )->a( n = `width`      v = `auto`
            )->a( n = `class`      v = `sapUiResponsiveMargin`
            )->a( n = `layout`     v = `ResponsiveGridLayout`
            )->a( n = `editable`   v = `true`
            )->a( n = `labelSpanL` v = `3`
            )->a( n = `labelSpanM` v = `3`
            )->a( n = `columnsL`   v = `1`
            )->a( n = `columnsM`   v = `1`
            )->a( n = `emptySpanL` v = `4`
            )->a( n = `emptySpanM` v = `4`
            )->a( n = `title`      v = `Date Input`

            )->ele( n = `content` ns = `form`
                )->tag( `Label`
                    )->a( n = `text` v = `Date`
                )->tag( `DatePicker`
                    )->a( n = `value` v = |\{ path: '{ client->_bind( val = date path = abap_true ) }', type: 'DateType', formatOptions: \{ source: \{ pattern: 'yyyy-MM-dd' \} \} \}|

            )->end(
        )->end(

        )->ele( n = `SimpleForm` ns = `form`
            )->a( n = `width`      v = `auto`
            )->a( n = `class`      v = `sapUiResponsiveMargin`
            )->a( n = `layout`     v = `ResponsiveGridLayout`
            )->a( n = `labelSpanL` v = `3`
            )->a( n = `labelSpanM` v = `3`
            )->a( n = `emptySpanL` v = `4`
            )->a( n = `emptySpanM` v = `4`
            )->a( n = `columnsL`   v = `1`
            )->a( n = `columnsM`   v = `1`
            )->a( n = `title`      v = `Format Options`

            )->ele( n = `content` ns = `form`
                )->tag( `Label`
                    )->a( n = `text` v = `Short`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = date path = abap_true ) }', type: 'DateType', formatOptions: \{ style: 'short', source: \{ pattern: 'yyyy-MM-dd' \} \} \}|
                )->tag( `Label`
                    )->a( n = `text` v = `Medium`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = date path = abap_true ) }', type: 'DateType', formatOptions: \{ style: 'medium', source: \{ pattern: 'yyyy-MM-dd' \} \} \}|
                )->tag( `Label`
                    )->a( n = `text` v = `Long`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = date path = abap_true ) }', type: 'DateType', formatOptions: \{ style: 'long', source: \{ pattern: 'yyyy-MM-dd' \} \} \}|
                )->tag( `Label`
                    )->a( n = `text` v = `Full`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = date path = abap_true ) }', type: 'DateType', formatOptions: \{ style: 'full', source: \{ pattern: 'yyyy-MM-dd' \} \} \}|

            )->end(
        )->end(

        )->ele( n = `SimpleForm` ns = `form`
            )->a( n = `width`      v = `auto`
            )->a( n = `class`      v = `sapUiResponsiveMargin`
            )->a( n = `layout`     v = `ResponsiveGridLayout`
            )->a( n = `labelSpanL` v = `3`
            )->a( n = `labelSpanM` v = `3`
            )->a( n = `emptySpanL` v = `4`
            )->a( n = `emptySpanM` v = `4`
            )->a( n = `columnsL`   v = `1`
            )->a( n = `columnsM`   v = `1`
            )->a( n = `title`      v = `Relative Time Format`

            )->ele( n = `content` ns = `form`
                )->tag( `Label`
                    )->a( n = `text` v = `Relative Time`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = date path = abap_true ) }', type: 'DateType', formatOptions: \{ relative: true, relativeScale: 'auto', source: \{ pattern: 'yyyy-MM-dd' \} \} \}|

            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
