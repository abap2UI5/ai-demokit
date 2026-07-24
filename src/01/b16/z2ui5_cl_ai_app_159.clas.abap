CLASS z2ui5_cl_ai_app_159 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_159 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->leaf( `Label`
                )->a( n = `text`     v = `Text`
                )->a( n = `labelFor` v = `inputText`
            )->leaf( `Input`
                )->a( n = `id`          v = `inputText`
                )->a( n = `placeholder` v = `Enter text`
                )->a( n = `class`       v = `sapUiSmallMarginBottom`
            )->leaf( `Label`
                )->a( n = `text`     v = `Email`
                )->a( n = `labelFor` v = `inputEmail`
            )->leaf( `Input`
                )->a( n = `id`          v = `inputEmail`
                )->a( n = `type`        v = `Email`
                )->a( n = `placeholder` v = `Enter email`
                )->a( n = `class`       v = `sapUiSmallMarginBottom`
            )->leaf( `Label`
                )->a( n = `text`     v = `Telephone`
                )->a( n = `labelFor` v = `inputTel`
            )->leaf( `Input`
                )->a( n = `id`          v = `inputTel`
                )->a( n = `type`        v = `Tel`
                )->a( n = `placeholder` v = `Enter telephone number`
                )->a( n = `class`       v = `sapUiSmallMarginBottom`
            )->leaf( `Label`
                )->a( n = `text`     v = `Number`
                )->a( n = `labelFor` v = `inputNumber`
            )->leaf( `Input`
                )->a( n = `id`          v = `inputNumber`
                )->a( n = `type`        v = `Number`
                )->a( n = `placeholder` v = `Enter a number`
                )->a( n = `class`       v = `sapUiSmallMarginBottom`
            )->leaf( `Label`
                )->a( n = `text`     v = `URL`
                )->a( n = `labelFor` v = `inputUrl`
            )->leaf( `Input`
                )->a( n = `id`          v = `inputUrl`
                )->a( n = `type`        v = `Url`
                )->a( n = `placeholder` v = `Enter URL`
                )->a( n = `class`       v = `sapUiSmallMarginBottom` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
