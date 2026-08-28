" @keywords multiinput multi input sap.m multiinputvaluestates verticallayout label
" @summary This sample illustrates the different value states of the sap.m.MultiInput control.
CLASS z2ui5_cl_smpc_app_386 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_386 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Label`
                )->a( n = `text`     v = `MultiInput with value state 'Warning'`
                )->a( n = `labelFor` v = `multiInput`
            )->tag( `MultiInput`
                )->a( n = `id`             v = `multiInput`
                )->a( n = `valueState`     v = `Warning`
                )->a( n = `showSuggestion` v = `false`
                )->a( n = `showValueHelp`  v = `false`
                )->a( n = `width`          v = `70%`
            )->tag( `Label`
                )->a( n = `text`     v = `MultiInput with value state 'Error'`
                )->a( n = `labelFor` v = `multiInput1`
            )->tag( `MultiInput`
                )->a( n = `id`             v = `multiInput1`
                )->a( n = `valueState`     v = `Error`
                )->a( n = `showSuggestion` v = `false`
                )->a( n = `showValueHelp`  v = `false`
                )->a( n = `width`          v = `70%`
            )->tag( `Label`
                )->a( n = `text`     v = `MultiInput with value state 'Success'`
                )->a( n = `labelFor` v = `multiInput2`
            )->tag( `MultiInput`
                )->a( n = `id`             v = `multiInput2`
                )->a( n = `valueState`     v = `Success`
                )->a( n = `showSuggestion` v = `false`
                )->a( n = `showValueHelp`  v = `false`
                )->a( n = `width`          v = `70%`
            )->tag( `Label`
                )->a( n = `text`     v = `MultiInput with value state 'Information'`
                )->a( n = `labelFor` v = `multiInput3`
            )->tag( `MultiInput`
                )->a( n = `id`             v = `multiInput3`
                )->a( n = `valueState`     v = `Information`
                )->a( n = `showSuggestion` v = `false`
                )->a( n = `showValueHelp`  v = `false`
                )->a( n = `width`          v = `70%` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
