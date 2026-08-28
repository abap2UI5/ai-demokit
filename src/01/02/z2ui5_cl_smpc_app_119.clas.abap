" @keywords fixflex fix flex sap.ui.layout layout html image text
" @summary Shows a FixFlex control with a vertical layout.
CLASS z2ui5_cl_smpc_app_119 DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    METHODS view_display.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_smpc_app_119 IMPLEMENTATION.
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
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `height`    v = `100%`

        " the sample's css/style.css (loaded via the manifest resources.css),
        " injected through a core:HTML content attribute - the documented way to
        " carry a stylesheet into an abap2UI5 view (CAPABILITIES 'Custom CSS',
        " apps 026/028/169). Literal braces are escaped \{ \} or the XMLView
        " binding parser reads them as a binding and the view dies
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.fixFlexVertical > .sapUiFixFlexFixed \{background: #D7E9FF;\} .fixFlexVertical > .sapUiFixFlexFlexible \{background: #A9CFFF;\}</style>`
        )->ele( n = `FixFlex` ns = `l`
            )->a( n = `class` v = `fixFlexVertical`
            )->ele( n = `fixContent` ns = `l`
                )->tag( `Image`
                    )->a( n = `src`          v = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`
                    )->a( n = `densityAware` v = `true`

            )->end(
            )->ele( n = `flexContent` ns = `l`
                )->tag( `Text`
                    )->a( n = `class` v = `column1`
                    )->a( n = `text`  v = `This container is flexible and it will adapt its size to fill the remaining size in the FixFlex control` ).
    client->view_display( view->stringify( ) ).
  ENDMETHOD.
ENDCLASS.
