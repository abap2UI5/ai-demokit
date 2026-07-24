CLASS z2ui5_cl_ai_app_219 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA pic1 TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_219 IMPLEMENTATION.

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
    " ({img>/products/pic1}); abap2UI5 serves one default model, so the picture
    " path is folded into it and bound directly (the 'img>' prefix dropped, last
    " path segment identical - structural-diff matches). The sample's style.css
    " (background colours on the fixed/flexible areas) is injected via a
    " core:HTML <style> node - CSS braces escaped \{ \} so the XMLView parser
    " does not read them as bindings.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `height`     v = `100%`

        )->leaf( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.fixFlexHorizontal>.sapUiFixFlexFixed\{background:#D7E9FF\}` &&
                                    `.fixFlexHorizontal>.sapUiFixFlexFlexible\{background:#A9CFFF\}</style>`

        )->open( n = `FixFlex` ns = `l`
            )->a( n = `class`    v = `fixFlexHorizontal`
            )->a( n = `vertical` v = `false`

            )->open( n = `fixContent` ns = `l`
                )->leaf( `Image`
                    )->a( n = `src`          v = client->_bind( pic1 )
                    )->a( n = `densityAware` v = `true`

            )->shut(
            )->open( n = `flexContent` ns = `l`
                )->leaf( `Text`
                    )->a( n = `class` v = `column1`
                    )->a( n = `text`  v = `This container is flexible and it will adapts its size to fill the remaining size in the FixFlex control`

            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    pic1 = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`.

  ENDMETHOD.

ENDCLASS.
