CLASS z2ui5_cl_ai_app_182 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA time TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_182 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      time = `13:30:00`.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " sap.ui.model.type.Time data-type binding (TypeTimeAsTime). TimeType is
    " pulled via core:require; the TimePicker and the three style Texts keep the
    " original { path, type: 'TimeType', formatOptions: { style } } binding 1:1.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `core:require` v = `{TimeType: 'sap/ui/model/type/Time'}`

        )->open( n = `SimpleForm` ns = `form`
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

            )->open( n = `content` ns = `form`
                )->leaf( `Label`
                    )->a( n = `text` v = `Time`
                )->leaf( `TimePicker`
                    )->a( n = `value` v = |\{ path: '{ client->_bind( val = time path = abap_true ) }', type: 'TimeType', formatOptions: \{ source: \{ pattern: 'HH:mm:ss' \} \} \}|

        )->shut(
        )->shut(

        )->open( n = `SimpleForm` ns = `form`
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

            )->open( n = `content` ns = `form`
                )->leaf( `Label`
                    )->a( n = `text` v = `Short`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = time path = abap_true ) }', type: 'TimeType', formatOptions: \{ style: 'short', source: \{ pattern: 'HH:mm:ss' \} \} \}|
                )->leaf( `Label`
                    )->a( n = `text` v = `Medium`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = time path = abap_true ) }', type: 'TimeType', formatOptions: \{ style: 'medium', source: \{ pattern: 'HH:mm:ss' \} \} \}|
                )->leaf( `Label`
                    )->a( n = `text` v = `Long`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = time path = abap_true ) }', type: 'TimeType', formatOptions: \{ style: 'long', source: \{ pattern: 'HH:mm:ss' \} \} \}|

        )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
