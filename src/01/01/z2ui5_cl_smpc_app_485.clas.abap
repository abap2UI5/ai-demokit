" @keywords textarea text area sap.m textareamaxlength
" @summary Shows the behavior of the control with the new showExceededText property (since 1.48) and maxLength = true
CLASS z2ui5_cl_smpc_app_485 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA value TYPE string.
  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_485 IMPLEMENTATION.

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

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Text`
                )->a( n = `text`  v = `showExceededText = true; with data binding`
                )->a( n = `class` v = `sapUiTinyMarginTop`
            " the bound TextArea keeps the original's own valueState expression over
            " the SAME bound value, so handleLiveChange has nothing left to do here
            )->tag( `TextArea`
                )->a( n = `id`               v = `textAreaWithBinding2`
                )->a( n = `value`            v = client->_bind( value )
                )->a( n = `showExceededText` v = `true`
                )->a( n = `maxLength`        v = `40`
                )->a( n = `width`            v = `100%`
                )->a( n = `valueState`       v = |\{= ${ client->_bind( value ) }.length > 40 ? 'Warning' : 'None' \}|
                )->a( n = `valueLiveUpdate`  v = `false`
            )->tag( `Text`
                )->a( n = `text`  v = `showExceededText = true; without data binding`
                )->a( n = `class` v = `sapUiTinyMarginTop`
            )->tag( `TextArea`
                )->a( n = `id`               v = `textAreaWithoutBinding`
                )->a( n = `value`            v = `Lorem ipsum dolor sit amet, consectetur el`
                )->a( n = `showExceededText` v = `true`
                )->a( n = `maxLength`        v = `40`
                )->a( n = `width`            v = `100%`
                )->a( n = `valueState`       v = `Warning`
                )->a( n = `valueLiveUpdate`  v = `true`
            )->tag( `Text`
                )->a( n = `text`  v = `showExceededText = false;`
                )->a( n = `class` v = `sapUiTinyMarginTop`
            )->tag( `TextArea`
                )->a( n = `value`     v = `Lorem ipsum dolor sit amet, consectetur el`
                )->a( n = `maxLength` v = `40`
                )->a( n = `width`     v = `100%` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " onInit seeds the model with the same 42-character value
    value = `Lorem ipsum dolor sit amet, consectetur el`.

  ENDMETHOD.

ENDCLASS.
