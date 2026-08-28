" @keywords parameters sap.ui.core.theming theme info verticallayout messagestrip link
" @summary Sample provides a link to the Theme Parameter Toolbox. There you can easily search, preview, and filter semantic theme parameters.
CLASS z2ui5_cl_smpc_app_131 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_131 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->ele( n = `content` ns = `l`
                )->tag( `MessageStrip`
                    )->a( n = `text`     v = `This sample is replaced with the Theme Parameter Toolbox. You can easily search, preview, and filter semantic theme parameters.`
                    )->a( n = `type`     v = `Information`
                    )->a( n = `showIcon` v = `true`
                    )->a( n = `class`    v = `sapUiMediumMarginBottom`
                )->tag( `Link`
                    )->a( n = `text`   v = `Click here to open the Theme Parameter Toolbox `
                    )->a( n = `target` v = `_blank`
                    " host-relative demokit href rewritten to the OpenUI5 host per the runtime asset-URL rule
                    )->a( n = `href`   v = `https://sdk.openui5.org/test-resources/sap/m/demokit/theming/webapp/index.html` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
