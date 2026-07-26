CLASS z2ui5_cl_ai_app_183 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA dtvalue   TYPE string.
    DATA dtpattern TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_183 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      dtvalue   = `2026-07-24 13:30:00`.
      dtpattern = `e.g. Dec 31, 2026, 11:59:58 PM`.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " sap.ui.model.type.DateTime data-type binding (TypeDateTime). DateTimeType is
    " pulled via core:require; the DateTimePicker, the Input and the style/pattern/
    " UTC/relative Texts keep the original { path, type: 'DateTimeType', formatOptions }
    " binding 1:1. Each binding carries an added source formatOption so the parseable
    " string model revives into the type (see sidecar) - a literal single-quote in a
    " display pattern keeps the original's backslash escape (\') inside the |...| template.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `core:require` v = `{DateTimeType: 'sap/ui/model/type/DateTime'}`

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
            )->a( n = `title`      v = `Date Input`

            )->open( n = `content` ns = `form`
                )->leaf( `Label`
                    )->a( n = `text` v = `DateTime in DateTimePicker`
                )->leaf( `DateTimePicker`
                    )->a( n = `value` v = |\{ path: '{ client->_bind( val = dtvalue path = abap_true ) }', type: 'DateTimeType', formatOptions: \{ source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|
                )->leaf( `Label`
                    )->a( n = `text` v = `DateTime in Input`
                )->leaf( `Input`
                    )->a( n = `id`          v = `dtInput`
                    )->a( n = `placeholder` v = client->_bind( dtpattern )
                    )->a( n = `value`       v = |\{ path: '{ client->_bind( val = dtvalue path = abap_true ) }', type: 'DateTimeType', formatOptions: \{ source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|

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
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = dtvalue path = abap_true ) }', type: 'DateTimeType', formatOptions: \{ style: 'short', source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|
                )->leaf( `Label`
                    )->a( n = `text` v = `Medium`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = dtvalue path = abap_true ) }', type: 'DateTimeType', formatOptions: \{ style: 'medium', source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|
                )->leaf( `Label`
                    )->a( n = `text` v = `Long`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = dtvalue path = abap_true ) }', type: 'DateTimeType', formatOptions: \{ style: 'long', source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|

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
            )->a( n = `title`      v = `Pattern`

            )->open( n = `content` ns = `form`
                )->leaf( `Label`
                    )->a( n = `text` v = `yyyy-MM-dd'T'HH:mm:ss`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = dtvalue path = abap_true ) }', type: 'DateTimeType', formatOptions: \{ pattern: 'yyyy-MM-dd\\'T\\'HH:mm:ss', source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|
                )->leaf( `Label`
                    )->a( n = `text` v = `yyyyMMdd HHmmss`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = dtvalue path = abap_true ) }', type: 'DateTimeType', formatOptions: \{ pattern: 'yyyyMMdd HHmmss', source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|
                )->leaf( `Label`
                    )->a( n = `text` v = `HH:mm`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = dtvalue path = abap_true ) }', type: 'DateTimeType', formatOptions: \{ pattern: 'HH:mm', source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|

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
            )->a( n = `title`      v = `UTC formatted`

            )->open( n = `content` ns = `form`
                )->leaf( `Label`
                    )->a( n = `text` v = `UTC`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = dtvalue path = abap_true ) }', type: 'DateTimeType', formatOptions: \{ pattern: 'yyyy-MM-dd\\'T\\'HH:mm:ss', UTC: true, source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|

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
            )->a( n = `title`      v = `Relative Time Format`

            )->open( n = `content` ns = `form`
                )->leaf( `Label`
                    )->a( n = `text` v = `Relative Time`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = dtvalue path = abap_true ) }', type: 'DateTimeType', formatOptions: \{ relative: true, relativeScale: 'auto', source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|

        )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
