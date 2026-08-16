" @keywords cssgrid sap.ui.layout.cssgrid layout slider panel overflowtoolbar title
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
      " the original Slider value / Panel width=100%
      slider_value = 100.
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " onSliderMoved sets the Panel width to value + "%" in JS; rebuilt as a
    " two-way bound Slider value plus a width expression binding, so the resize
    " runs on the client (a liveChange round-trip would fire per drag step)
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:grid` v = `sap.ui.layout.cssgrid`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        " the sample's css/main.css, injected via a core:HTML content attribute
        " (see CAPABILITIES.md) - the class the five grid tiles below carry.
        " Literal braces are escaped \{ \} in a backtick literal: the XMLView
        " parser reads an unescaped brace as a binding
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.sapUiLayoutCSSGrid .stylePageLayout\{` &&
                                    `background-color:#3b6f9a;color:#ffffff;border-radius:10px;` &&
                                    `display:flex;align-items:center;justify-content:center\}</style>`

        )->tag( `Slider`
            )->a( n = `value` v = client->_bind( slider_value )
            )->a( n = `class` v = `sapUiSmallMarginBottom`

        )->ele( `Panel`
            )->a( n = `id`     v = `gridLayout`
            )->a( n = `width`  v = |\{= ${ client->_bind( slider_value ) } + '%' \}|
            )->a( n = `height` v = `100%`

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`
                    )->a( n = `height` v = `3rem`
                    )->tag( `Title`
                        )->a( n = `text` v = ` CssGrid Layout example`

                )->end(
            )->end(

            )->ele( n = `CSSGrid` ns = `grid`
                )->a( n = `id`                  v = `grid1`
                )->a( n = `gridTemplateColumns` v = `1fr 2fr 1fr`
                )->a( n = `gridTemplateRows`    v = `50px 200px 50px`
                )->a( n = `gridGap`             v = `1rem`

                )->ele( n = `HTML` ns = `core`
                    )->a( n = `content` v = `<header class="stylePageLayout">Header</header>`
                    )->ele( n = `layoutData` ns = `core`
                        )->tag( n = `GridItemLayoutData` ns = `grid`
                            )->a( n = `gridColumn` v = `1 / 4`

                    )->end(
                )->end(
                )->tag( n = `HTML` ns = `core`
                    )->a( n = `content` v = `<aside  class="stylePageLayout">Navigation</aside >`
                )->tag( n = `HTML` ns = `core`
                    )->a( n = `content` v = `<article class="stylePageLayout">Main Content</article>`
                )->tag( n = `HTML` ns = `core`
                    )->a( n = `content` v = `<aside class="stylePageLayout">Related Links</article>`
                )->ele( n = `HTML` ns = `core`
                    )->a( n = `content` v = `<footer class="stylePageLayout">Footer</footer>`
                    )->ele( n = `layoutData` ns = `core`
                        )->tag( n = `GridItemLayoutData` ns = `grid`
                            )->a( n = `gridColumn` v = `1 / 4` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
