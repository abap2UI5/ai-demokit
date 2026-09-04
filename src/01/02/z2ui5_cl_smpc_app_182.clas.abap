" @keywords time sap.ui.model.type typetimeastime simpleform label timepicker text
" @summary This sample explains the formatting options of the Time type.
CLASS z2ui5_cl_smpc_app_182 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA time TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_182 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      " original seeds the current time (UI5Date.getInstance()); a fixed time
      " is used here so the port is deterministic
      time = `13:30:00`.
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " sap.ui.model.type.Time data-type binding (TypeTimeAsTime). TimeType is
    " pulled via core:require; the TimePicker and the three style Texts keep the
    " original { path, type: 'TimeType', formatOptions: { style } } binding, each
    " with an ADDED source formatOption { source: { pattern: 'HH:mm:ss' } } so the
    " parseable string model revives into the type (see sidecar IMPROVISED - the
    " original model value is a JS Date object abap2UI5 cannot hold).
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `core:require` v = `{TimeType: 'sap/ui/model/type/Time'}`

        )->ele( n = `SimpleForm` ns = `form`
            )->a( n = `width`      v = `auto`
            )->a( n = `class`      v = `sapUiResponsiveMargin`
            )->a( n = `layout`     v = `ResponsiveGridLayout`
            )->a( n = `editable`   v = `true`
            )->a( n = `labelSpanL` v = `3`
            )->a( n = `labelSpanM` v = `3`
            )->a( n = `emptySpanL` v = `4`
            )->a( n = `emptySpanM` v = `4`
            )->a( n = `columnsL`   v = `1`
            )->a( n = `columnsM`   v = `1`
            )->a( n = `title`      v = `Time Input`

            )->ele( n = `content` ns = `form`
                )->tag( `Label`
                    )->a( n = `text` v = `Time`
                )->tag( `TimePicker`
                    )->a( n = `value` v = |\{ path: '{ client->_bind_path( time ) }', type: 'TimeType', formatOptions: \{ source: \{ pattern: 'HH:mm:ss' \} \} \}|

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
            )->a( n = `title`      v = `Style`

            )->ele( n = `content` ns = `form`
                )->tag( `Label`
                    )->a( n = `text` v = `Short`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind_path( time ) }', type: 'TimeType', formatOptions: \{ style: 'short', source: \{ pattern: 'HH:mm:ss' \} \} \}|
                )->tag( `Label`
                    )->a( n = `text` v = `Medium`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind_path( time ) }', type: 'TimeType', formatOptions: \{ style: 'medium', source: \{ pattern: 'HH:mm:ss' \} \} \}|
                )->tag( `Label`
                    )->a( n = `text` v = `Long`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind_path( time ) }', type: 'TimeType', formatOptions: \{ style: 'long', source: \{ pattern: 'HH:mm:ss' \} \} \}|

            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
