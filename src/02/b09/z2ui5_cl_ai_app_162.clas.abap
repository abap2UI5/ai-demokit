CLASS z2ui5_cl_ai_app_162 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA widths TYPE string.
    DATA widthm TYPE string.
    DATA widthl TYPE string.
    DATA pic1   TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_162 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " The original binds the image src against a separate 'img' JSON model
    " ({img>/products/pic1}) while the widths come from the default model.
    " abap2UI5 has one default model, so the picture path is folded into it and
    " the src binds it directly (the 'img>' prefix is dropped - last path
    " segment identical, which structural-diff matches). One model of truth,
    " thin frontend.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( n = `HorizontalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`

            )->leaf( `Image`
                )->a( n = `src`          v = client->_bind( pic1 )
                )->a( n = `densityAware` v = `true`
                )->a( n = `width`        v = client->_bind( widths )
            )->leaf( `Image`
                )->a( n = `src`          v = client->_bind( pic1 )
                )->a( n = `densityAware` v = `true`
                )->a( n = `width`        v = client->_bind( widthm )
            )->leaf( `Image`
                )->a( n = `src`          v = client->_bind( pic1 )
                )->a( n = `densityAware` v = `true`
                )->a( n = `width`        v = client->_bind( widthl ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " original widths are Device.system.phone dependent; the desktop values
    " are used here (the phone branch is a client-only decision).
    widths = `5em`.
    widthm = `10em`.
    widthl = `15em`.
    pic1   = `test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.

  ENDMETHOD.

ENDCLASS.
