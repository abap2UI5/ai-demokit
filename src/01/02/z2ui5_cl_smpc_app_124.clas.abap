CLASS z2ui5_cl_smpc_app_124 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA slider_value TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_124 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      slider_value = 100.       " the original Slider value / Panel width=100%
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " onSliderMoved sets the Panel width to value + "%" in JS; rebuilt as a
    " two-way bound Slider value plus a width expression binding, so the resize
    " runs on the client (a liveChange round-trip would fire per drag step)
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:grid` v = `sap.ui.layout.cssgrid`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        " the sample's css/main.css, injected via a core:HTML content attribute
        " (see CAPABILITIES.md) - the class the five grid tiles below carry.
        " Literal braces are escaped \{ \} in a backtick literal: the XMLView
        " parser reads an unescaped brace as a binding
        )->leaf( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.sapUiLayoutCSSGrid .stylePageLayout\{` &&
                                    `background-color:#3b6f9a;color:#ffffff;border-radius:10px;` &&
                                    `display:flex;align-items:center;justify-content:center\}</style>`

        )->leaf( `Slider`
            )->a( n = `value` v = client->_bind( slider_value )
            )->a( n = `class` v = `sapUiSmallMarginBottom`

        )->open( `Panel`
            )->a( n = `id`     v = `gridLayout`
            )->a( n = `width`  v = |\{= ${ client->_bind( slider_value ) } + '%' \}|
            )->a( n = `height` v = `100%`

            )->open( `headerToolbar`
                )->open( `OverflowToolbar`
                    )->a( n = `height` v = `3rem`
                    )->leaf( `Title`
                        )->a( n = `text` v = ` CssGrid Layout example`

                )->shut(
            )->shut(

            )->open( n = `CSSGrid` ns = `grid`
                )->a( n = `id`                  v = `grid1`
                )->a( n = `gridTemplateColumns` v = `1fr 2fr 1fr`
                )->a( n = `gridTemplateRows`    v = `50px 200px 50px`
                )->a( n = `gridGap`             v = `1rem`

                )->open( n = `HTML` ns = `core`
                    )->a( n = `content` v = `<header class="stylePageLayout">Header</header>`
                    )->open( n = `layoutData` ns = `core`
                        )->leaf( n = `GridItemLayoutData` ns = `grid`
                            )->a( n = `gridColumn` v = `1 / 4`

                )->shut(
                )->shut(
                )->leaf( n = `HTML` ns = `core`
                    )->a( n = `content` v = `<aside  class="stylePageLayout">Navigation</aside >`
                )->leaf( n = `HTML` ns = `core`
                    )->a( n = `content` v = `<article class="stylePageLayout">Main Content</article>`
                )->leaf( n = `HTML` ns = `core`
                    )->a( n = `content` v = `<aside class="stylePageLayout">Related Links</article>`
                )->open( n = `HTML` ns = `core`
                    )->a( n = `content` v = `<footer class="stylePageLayout">Footer</footer>`
                    )->open( n = `layoutData` ns = `core`
                        )->leaf( n = `GridItemLayoutData` ns = `grid`
                            )->a( n = `gridColumn` v = `1 / 4` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
