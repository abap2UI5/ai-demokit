CLASS z2ui5_cl_smpc_app_271 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA slider_value    TYPE i.
    DATA container_query TYPE string.
    DATA info_text       TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_271 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      slider_value    = 100.
      container_query = `false`.
      info_text       = `Layout size is: `.
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " onSliderMoved sets the Panel width imperatively - sap.m.Panel has a width
    " property, so it is the bound expression (app 214/270 form).
    " onSegmentedButtonChange calls customLayout.setContainerQuery(key ==
    " 'true'); the SegmentedButton key and the layout's containerQuery share one
    " two-way bound field, so the switch works client-side without a round-trip.
    " layoutChange round-trips the active layout name into the info Text.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:grid` v = `sap.ui.layout.cssgrid`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        " the sample's css/main.css (app 122/124 precedent); braces escaped
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.sapMFlexBox.demoBox\{border-radius:10px;` &&
                                    `background-color:#427cac;text-align:center\}` &&
                                    `.demoBox .sapMText\{color:#ffffff\}` &&
                                    `.sapMText.message\{font-weight:bold\}</style>`

        )->tag( `ToggleButton`
            )->a( n = `id`    v = `revealGrid`
            )->a( n = `text`  v = `Reveal Grid`
            )->a( n = `class` v = `sapUiSmallMargin`

        )->tag( `Slider`
            )->a( n = `value` v = client->_bind( slider_value )
            )->a( n = `class` v = `sapUiSmallMarginBottom`

        )->ele( `Panel`
            )->a( n = `id`    v = `panelCSSGrid`
            )->a( n = `width` v = |\{= ${ client->_bind( slider_value ) } + '%' \}|

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`
                    )->a( n = `height` v = `3rem`

                    )->tag( `Title`
                        )->a( n = `text` v = `GridResponsiveness example`

                )->end(
            )->end(

            )->tag( `Text`
                )->a( n = `class` v = `message sapUiSmallMarginBottom`
                )->a( n = `id`    v = `infoTxt`
                )->a( n = `width` v = `100%`
                )->a( n = `text`  v = client->_bind( info_text )
            )->tag( `Text`
                )->a( n = `text` v = `Responsive behaviour is fully configurable by the developer. It is possible to `
                                  && `pass a GridResponsiveLayout to the customLayout aggregation of the CSSGrid and `
                                  && `configure how it will look in different breakpoints (S, M, L, XL). The breakpoints `
                                  && `can be calculated either by the screen size or by the grid container (with `
                                  && `containerQuery property).`

            )->ele( `HBox`
                )->a( n = `alignItems`  v = `Center`
                )->a( n = `renderType`  v = `Bare`
                )->a( n = `class`       v = `sapUiSmallMarginBottom sapUiSmallMarginTop`

                )->tag( `Text`
                    )->a( n = `text`  v = `GridResponsiveLayout containerQuery:`
                    )->a( n = `class` v = `sapUiTinyMarginEnd`

                )->ele( `SegmentedButton`
                    )->a( n = `selectedKey` v = client->_bind( container_query )

                    )->ele( `items`
                        )->tag( `SegmentedButtonItem`
                            )->a( n = `key`  v = `true`
                            )->a( n = `text` v = `true`
                        )->tag( `SegmentedButtonItem`
                            )->a( n = `key`  v = `false`
                            )->a( n = `text` v = `false`

                    )->end(
                )->end(
            )->end(

            )->ele( n = `CSSGrid` ns = `grid`
                )->a( n = `id` v = `grid1`

                )->ele( n = `customLayout` ns = `grid`
                    )->ele( n = `GridResponsiveLayout` ns = `grid`
                        )->a( n = `containerQuery` v = |\{= ${ client->_bind( container_query ) } === 'true' \}|
                        )->a( n = `layoutChange`   v = client->_event( val   = `LAYOUT_CHANGE`
                                                                       t_arg = VALUE #( ( `${$parameters>/layout}` ) ) )

                        )->ele( n = `layoutS` ns = `grid`
                            )->tag( n = `GridSettings` ns = `grid`
                                )->a( n = `gridTemplateColumns` v = `repeat(auto-fit, 8rem)`
                                )->a( n = `gridAutoRows`        v = `5rem`
                                )->a( n = `gridRowGap`          v = `1rem`
                                )->a( n = `gridColumnGap`       v = `1rem`

                        )->end(

                        )->ele( n = `layout` ns = `grid`
                            )->tag( n = `GridSettings` ns = `grid`
                                )->a( n = `gridTemplateColumns` v = `repeat(auto-fit, 12rem)`
                                )->a( n = `gridAutoRows`        v = `5rem`
                                )->a( n = `gridRowGap`          v = `1rem`
                                )->a( n = `gridColumnGap`       v = `1rem`

                        )->end(

                        )->ele( n = `layoutXL` ns = `grid`
                            )->tag( n = `GridSettings` ns = `grid`
                                )->a( n = `gridTemplateColumns` v = `repeat(auto-fit, 20rem)`
                                )->a( n = `gridAutoRows`        v = `5rem`
                                )->a( n = `gridRowGap`          v = `1rem`
                                )->a( n = `gridColumnGap`       v = `1rem`

                        )->end(
                    )->end(
                )->end(

                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Text`
                        )->a( n = `text`     v = `A`
                        )->a( n = `wrapping` v = `true`

                )->end(

                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Text`
                        )->a( n = `text`     v = `B`
                        )->a( n = `wrapping` v = `true`

                )->end(

                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Text`
                        )->a( n = `text`     v = `C`
                        )->a( n = `wrapping` v = `true`

                )->end(

                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Text`
                        )->a( n = `text`     v = `D`
                        )->a( n = `wrapping` v = `true`

                )->end(

                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Text`
                        )->a( n = `text`     v = `E`
                        )->a( n = `wrapping` v = `true`

                )->end(

                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Text`
                        )->a( n = `text`     v = `F`
                        )->a( n = `wrapping` v = `true`

                )->end(

                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Text`
                        )->a( n = `text`     v = `G`
                        )->a( n = `wrapping` v = `true`

                )->end(

                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Text`
                        )->a( n = `text`     v = `H`
                        )->a( n = `wrapping` v = `true`

                )->end(

                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Text`
                        )->a( n = `text`     v = `I`
                        )->a( n = `wrapping` v = `true`

                )->end(

                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Text`
                        )->a( n = `text`     v = `J`
                        )->a( n = `wrapping` v = `true`

                )->end(

                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Text`
                        )->a( n = `text`     v = `K`
                        )->a( n = `wrapping` v = `true`

                )->end(

                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Text`
                        )->a( n = `text`     v = `L`
                        )->a( n = `wrapping` v = `true`

                        ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `LAYOUT_CHANGE`.
      " onLayoutChange: the info Text names the active GridSettings
      " aggregation; 'layout' covers both M and L
      DATA(lv_layout) = client->get_event_arg( ).
      info_text = COND string( WHEN lv_layout = `layout`
                               THEN `Layout size is: layoutM or layoutL`
                               ELSE |Layout size is: { lv_layout }| ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
