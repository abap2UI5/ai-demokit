" @keywords input sap.m types verticallayout label
" @summary Input type corresponds to the type attribute of the HTML input tag. On touch devices, it controls the keyboard layout. On desktop, the effect of this setting is browser dependent.
CLASS z2ui5_cl_smpc_app_159 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_159 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Label`
                )->a( n = `text`     v = `Text`
                )->a( n = `labelFor` v = `inputText`
            )->tag( `Input`
                )->a( n = `id`          v = `inputText`
                )->a( n = `placeholder` v = `Enter text`
                )->a( n = `class`       v = `sapUiSmallMarginBottom`
            )->tag( `Label`
                )->a( n = `text`     v = `Email`
                )->a( n = `labelFor` v = `inputEmail`
            )->tag( `Input`
                )->a( n = `id`          v = `inputEmail`
                )->a( n = `type`        v = `Email`
                )->a( n = `placeholder` v = `Enter email`
                )->a( n = `class`       v = `sapUiSmallMarginBottom`
            )->tag( `Label`
                )->a( n = `text`     v = `Telephone`
                )->a( n = `labelFor` v = `inputTel`
            )->tag( `Input`
                )->a( n = `id`          v = `inputTel`
                )->a( n = `type`        v = `Tel`
                )->a( n = `placeholder` v = `Enter telephone number`
                )->a( n = `class`       v = `sapUiSmallMarginBottom`
            )->tag( `Label`
                )->a( n = `text`     v = `Number`
                )->a( n = `labelFor` v = `inputNumber`
            )->tag( `Input`
                )->a( n = `id`          v = `inputNumber`
                )->a( n = `type`        v = `Number`
                )->a( n = `placeholder` v = `Enter a number`
                )->a( n = `class`       v = `sapUiSmallMarginBottom`
            )->tag( `Label`
                )->a( n = `text`     v = `URL`
                )->a( n = `labelFor` v = `inputUrl`
            )->tag( `Input`
                )->a( n = `id`          v = `inputUrl`
                )->a( n = `type`        v = `Url`
                )->a( n = `placeholder` v = `Enter URL`
                )->a( n = `class`       v = `sapUiSmallMarginBottom` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
