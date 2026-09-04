" @keywords datetime date time sap.ui.model.type typedatetime simpleform label datetimepicker input text
" @summary This sample explains the formatting options of the DateTime type.
CLASS z2ui5_cl_smpc_app_183 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA dtvalue   TYPE string.
    DATA dtpattern TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_183 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      " original seeds the current time (UI5Date.getInstance()) - fixed here for
      " determinism; the placeholder is derived at runtime from the type's
      " getPlaceholderText() in the original - seeded as a static representative
      dtvalue   = `2026-07-24 13:30:00`.
      dtpattern = `e.g. Dec 31, 2026, 11:59:58 PM`.
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " sap.ui.model.type.DateTime data-type binding (TypeDateTime). DateTimeType is
    " pulled via core:require; the DateTimePicker, the Input and the style/pattern/
    " UTC/relative Texts keep the original { path, type: 'DateTimeType', formatOptions }
    " binding 1:1. Each binding carries an added source formatOption so the parseable
    " string model revives into the type (see sidecar) - a literal single-quote in a
    " display pattern keeps the original's backslash escape (\') inside the |...| template.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `core:require` v = `{DateTimeType: 'sap/ui/model/type/DateTime'}`

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
            )->a( n = `title`      v = `Date Input`

            )->ele( n = `content` ns = `form`
                )->tag( `Label`
                    )->a( n = `text` v = `DateTime in DateTimePicker`
                )->tag( `DateTimePicker`
                    )->a( n = `value` v = |\{ path: '{ client->_bind_path( dtvalue ) }', type: 'DateTimeType', formatOptions: \{ source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|
                )->tag( `Label`
                    )->a( n = `text` v = `DateTime in Input`
                )->tag( `Input`
                    )->a( n = `id`          v = `dtInput`
                    )->a( n = `placeholder` v = client->_bind( dtpattern )
                    )->a( n = `value`       v = |\{ path: '{ client->_bind_path( dtvalue ) }', type: 'DateTimeType', formatOptions: \{ source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|

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
                    )->a( n = `text` v = |\{ path: '{ client->_bind_path( dtvalue ) }', type: 'DateTimeType', formatOptions: \{ style: 'short', source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|
                )->tag( `Label`
                    )->a( n = `text` v = `Medium`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind_path( dtvalue ) }', type: 'DateTimeType', formatOptions: \{ style: 'medium', source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|
                )->tag( `Label`
                    )->a( n = `text` v = `Long`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind_path( dtvalue ) }', type: 'DateTimeType', formatOptions: \{ style: 'long', source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|

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
            )->a( n = `title`      v = `Pattern`

            )->ele( n = `content` ns = `form`
                )->tag( `Label`
                    )->a( n = `text` v = `yyyy-MM-dd'T'HH:mm:ss`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind_path( dtvalue ) }', type: 'DateTimeType', formatOptions: \{ pattern: 'yyyy-MM-dd\\'T\\'HH:mm:ss', source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|
                )->tag( `Label`
                    )->a( n = `text` v = `yyyyMMdd HHmmss`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind_path( dtvalue ) }', type: 'DateTimeType', formatOptions: \{ pattern: 'yyyyMMdd HHmmss', source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|
                )->tag( `Label`
                    )->a( n = `text` v = `HH:mm`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind_path( dtvalue ) }', type: 'DateTimeType', formatOptions: \{ pattern: 'HH:mm', source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|

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
            )->a( n = `title`      v = `UTC formatted`

            )->ele( n = `content` ns = `form`
                )->tag( `Label`
                    )->a( n = `text` v = `UTC`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind_path( dtvalue ) }', type: 'DateTimeType', formatOptions: \{ pattern: 'yyyy-MM-dd\\'T\\'HH:mm:ss', UTC: true, source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|

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
                    )->a( n = `text` v = |\{ path: '{ client->_bind_path( dtvalue ) }', type: 'DateTimeType', formatOptions: \{ relative: true, relativeScale: 'auto', source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|

            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
