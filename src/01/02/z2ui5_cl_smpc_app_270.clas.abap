CLASS z2ui5_cl_smpc_app_270 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA slider_value TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_270 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      slider_value = 100.
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " onSliderMoved sets the Panel's width imperatively; sap.m.Panel HAS a
    " width property, so the slider value is two-way bound and the width is an
    " expression binding over it (app 214 precedent) - no round-trip needed.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:grid` v = `sap.ui.layout.cssgrid`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        " the sample's css/main.css, injected via a core:HTML content attribute
        " (app 122/124 precedent); literal braces are escaped \{ \} in a
        " backtick literal - the XMLView parser reads an unescaped brace as a
        " binding
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.sapMFlexBox.demoBox\{border-radius:10px;` &&
                                    `background-color:#427cac;text-align:center\}` &&
                                    `.demoBox .sapMTitle,.demoBox .sapMText\{color:#ffffff\}` &&
                                    `.sapMFlexBox.sapMFlexBoxWrapNoWrap.sapMVBox .demoInnerBox\{` &&
                                    `background:lightblue;border-radius:10px\}` &&
                                    `.sapMFlexBox.sapMFlexBoxWrapNoWrap.sapMVBox .demoInnerBox .sapMTitle,` &&
                                    `.sapMFlexBox.sapMFlexBoxWrapNoWrap.sapMVBox .demoInnerBox .sapMText\{` &&
                                    `color:#333333\}</style>`

        )->tag( `Slider`
            )->a( n = `value` v = client->_bind( slider_value )
            )->a( n = `class` v = `sapUiSmallMarginBottom`

        )->ele( `Panel`
            )->a( n = `id`     v = `panelCSSGrid`
            )->a( n = `width`  v = |\{= ${ client->_bind( slider_value ) } + '%' \}|
            )->a( n = `height` v = `100%`

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`
                    )->a( n = `height` v = `3rem`

                    )->tag( `Title`
                        )->a( n = `text` v = `CSS Grid Nested grids example`

                )->end(
            )->end(

            )->ele( n = `CSSGrid` ns = `grid`
                )->a( n = `id`                  v = `grid1`
                )->a( n = `gridTemplateColumns` v = `repeat(2,minmax(250px, 1fr))`
                )->a( n = `gridTemplateRows`    v = `1fr 3fr`
                )->a( n = `gridGap`             v = `1rem`

                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Title`
                        )->a( n = `text`     v = `A Box`
                        )->a( n = `wrapping` v = `true`
                    )->tag( `Text`
                        )->a( n = `text`     v = `A Box subtitle`
                        )->a( n = `wrapping` v = `true`

                )->end(

                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Title`
                        )->a( n = `text`     v = `B Box`
                        )->a( n = `wrapping` v = `true`
                    )->tag( `Text`
                        )->a( n = `text`     v = `B Box subtitle`
                        )->a( n = `wrapping` v = `true`

                )->end(

                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Title`
                        )->a( n = `text`     v = `C Box`
                        )->a( n = `wrapping` v = `true`
                    )->tag( `Text`
                        )->a( n = `text`     v = `C Box subtitle`
                        )->a( n = `wrapping` v = `true`

                )->end(

                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->ele( n = `CSSGrid` ns = `grid`
                        )->a( n = `gridTemplateColumns` v = `repeat(2,minmax(120px, 1fr))`
                        )->a( n = `gridGap`             v = `0.5rem`

                        )->ele( `VBox`
                            )->a( n = `class` v = `sapUiSmallMarginTop sapUiSmallMarginBegin sapUiSmallMarginEnd demoInnerBox`

                            )->ele( `layoutData`
                                )->tag( n = `GridItemLayoutData` ns = `grid`
                                    )->a( n = `gridColumn` v = `1 / 3`
                                    )->a( n = `gridRow`    v = `1`

                            )->end(

                            )->tag( `Title`
                                )->a( n = `text`     v = `E Box`
                                )->a( n = `wrapping` v = `true`
                            )->tag( `Text`
                                )->a( n = `text`     v = `E Box subtitle`
                                )->a( n = `wrapping` v = `true`

                        )->end(

                        )->ele( `VBox`
                            )->a( n = `class` v = `sapUiSmallMarginBegin demoInnerBox`

                            )->ele( `layoutData`
                                )->tag( n = `GridItemLayoutData` ns = `grid`
                                    )->a( n = `gridColumn` v = `1`
                                    )->a( n = `gridRow`    v = `2`

                            )->end(

                            )->tag( `Title`
                                )->a( n = `text`     v = `F Box`
                                )->a( n = `wrapping` v = `true`
                            )->tag( `Text`
                                )->a( n = `text`     v = `F Box subtitle`
                                )->a( n = `wrapping` v = `true`

                        )->end(

                        )->ele( `VBox`
                            )->a( n = `class` v = `sapUiSmallMarginEnd demoInnerBox`

                            )->ele( `layoutData`
                                )->tag( n = `GridItemLayoutData` ns = `grid`
                                    )->a( n = `gridColumn` v = `2`
                                    )->a( n = `gridRow`    v = `2`

                            )->end(

                            )->tag( `Title`
                                )->a( n = `text`     v = `G Box`
                                )->a( n = `wrapping` v = `true`
                            )->tag( `Text`
                                )->a( n = `text`     v = `G Box subtitle`
                                )->a( n = `wrapping` v = `true`

                            ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
