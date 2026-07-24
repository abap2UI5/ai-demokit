CLASS z2ui5_cl_ai_app_131 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_131 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->open( n = `content` ns = `l`
                )->leaf( `MessageStrip`
                    )->a( n = `text`     v = `This sample is replaced with the Theme Parameter Toolbox. You can easily search, preview, and filter semantic theme parameters.`
                    )->a( n = `type`     v = `Information`
                    )->a( n = `showIcon` v = `true`
                    )->a( n = `class`    v = `sapUiMediumMarginBottom`
                )->leaf( `Link`
                    )->a( n = `text`   v = `Click here to open the Theme Parameter Toolbox `
                    )->a( n = `target` v = `_blank`
                    )->a( n = `href`   v = `test-resources/sap/m/demokit/theming/webapp/index.html` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
