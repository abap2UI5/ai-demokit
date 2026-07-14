"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.ui.model.type.Time - TypeTimeAsTime
"! https://sdk.openui5.org/entity/sap.ui.model.type.Time/sample/sap.ui.core.sample.TypeTimeAsTime
CLASS z2ui5_cl_api_app_509 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA time TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_509 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      " the original binds a JavaScript Date object - here the current time is bound as string
      time = |{ sy-uzeit TIME = ISO }|.

      view_display( ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(time_path) = client->_bind_edit( val  = time
                                          path = abap_true ).

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    " the source pattern is added because the time is available as string instead of a Date object
    view->simple_form(
        width      = `auto`
        class      = `sapUiResponsiveMargin`
        layout     = `ResponsiveGridLayout`
        editable   = abap_true
        labelspanl = `3`
        labelspanm = `3`
        emptyspanl = `4`
        emptyspanm = `4`
        columnsl   = `1`
        columnsm   = `1`
        title      = `Time Input`
        )->content( `form`
        )->label( `Time`
        )->time_picker( |\{ path: '{ time_path }', type: 'sap.ui.model.type.Time', formatOptions: \{ source: \{ pattern: 'HH:mm:ss' \} \} \}| ).

    view->simple_form(
        width      = `auto`
        class      = `sapUiResponsiveMargin`
        layout     = `ResponsiveGridLayout`
        labelspanl = `3`
        labelspanm = `3`
        emptyspanl = `4`
        emptyspanm = `4`
        columnsl   = `1`
        columnsm   = `1`
        title      = `Style`
        )->content( `form`
        )->label( `Short`
        )->text( |\{ path: '{ time_path }', type: 'sap.ui.model.type.Time', formatOptions: \{ style: 'short', source: \{ pattern: 'HH:mm:ss' \} \} \}|
        )->label( `Medium`
        )->text( |\{ path: '{ time_path }', type: 'sap.ui.model.type.Time', formatOptions: \{ style: 'medium', source: \{ pattern: 'HH:mm:ss' \} \} \}|
        )->label( `Long`
        )->text( |\{ path: '{ time_path }', type: 'sap.ui.model.type.Time', formatOptions: \{ style: 'long', source: \{ pattern: 'HH:mm:ss' \} \} \}| ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
