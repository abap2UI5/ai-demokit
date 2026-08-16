CLASS z2ui5_cl_smpc_app_348 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the width Slider - the Panel's width is an expression binding over it
    DATA slider_value TYPE i.

    " the sample's JSON model: the layout the ResponsiveColumnLayout reports
    DATA currentbreakpoint TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_348 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      " the Slider's value="100"
      slider_value = 100.
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " the ResponsiveColumnLayout demo with its eight f:Cards. The Panel width
    " follows the Slider through an expression binding (roundtrip-free), and
    " the layout's layoutChange carries its layout parameter to the backend so
    " the "Current breakpoint" Text shows it, like the original's model write.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`       v = `sap.m`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:grid`  v = `sap.ui.layout.cssgrid`
        )->a( n = `xmlns:f`     v = `sap.f`
        )->a( n = `xmlns:cards` v = `sap.f.cards`

        )->tag( `ToggleButton`
            )->a( n = `id`    v = `revealGrid`
            )->a( n = `text`  v = `Reveal Grid`
            )->a( n = `class` v = `sapUiSmallMargin`

        )->tag( `Slider`
            )->a( n = `value` v = client->_bind( slider_value )
            )->a( n = `class` v = `sapUiSmallMarginBottom`

        )->ele( `Panel`
            )->a( n = `width` v = |\{= ${ client->_bind( slider_value ) } + '%'\}|
            )->a( n = `id`    v = `panelCSSGrid`

            )->ele( `headerToolbar`
                )->ele( `Toolbar`
                    )->a( n = `height` v = `3rem`

                    )->tag( `Title`
                        )->a( n = `text` v = `Grid with ResponsiveColumnLayout`

                )->end(
            )->end(
            )->tag( `Text`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `text`  v = `ResponsiveColumnLayout represents a layout which is configured to display a variable number of columns depending on available screen size.`

            )->tag( `Text`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `text`  v = `Grid row's height is dynamically determined by the height of the highest grid element on this row.`

            )->tag( `Text`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `text`  v = |Current breakpoint: { client->_bind( currentbreakpoint ) }|
                )->a( n = `width` v = `100%`

            )->ele( n = `CSSGrid` ns = `grid`
                )->a( n = `id` v = `grid1`

                )->ele( n = `customLayout` ns = `grid`
                    )->tag( n = `ResponsiveColumnLayout` ns = `grid`
                        )->a( n = `layoutChange` v = client->_event( val   = `LAYOUT_CHANGE`
                                                                     t_arg = VALUE #( ( `${$parameters>/layout}` ) ) )

                )->end(
                )->ele( n = `Card` ns = `f`
                    )->ele( n = `layoutData` ns = `f`
                        )->tag( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `4`
                            )->a( n = `rows`    v = `4`

                    )->end(
                    )->ele( n = `content` ns = `f`
                        )->ele( `VBox`
                            )->a( n = `class` v = `sapUiSmallMargin`

                            )->tag( `Title`
                                )->a( n = `text`     v = `4 / 4`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                        )->end(
                    )->end(
                )->end(
                )->ele( n = `Card` ns = `f`
                    )->ele( n = `layoutData` ns = `f`
                        )->tag( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `3`
                            )->a( n = `rows`    v = `3`

                    )->end(
                    )->ele( n = `content` ns = `f`
                        )->ele( `VBox`
                            )->a( n = `class` v = `sapUiSmallMargin`

                            )->tag( `Title`
                                )->a( n = `text`     v = `3 / 3`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle Subtitle Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                        )->end(
                    )->end(
                )->end(
                )->ele( n = `Card` ns = `f`
                    )->ele( n = `layoutData` ns = `f`
                        )->tag( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `1`
                            )->a( n = `rows`    v = `1`

                    )->end(
                    )->ele( n = `content` ns = `f`
                        )->ele( `VBox`
                            )->a( n = `class` v = `sapUiSmallMargin`

                            )->tag( `Title`
                                )->a( n = `text`     v = `1 / 1`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                        )->end(
                    )->end(
                )->end(
                )->ele( n = `Card` ns = `f`
                    )->ele( n = `layoutData` ns = `f`
                        )->tag( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `1`
                            )->a( n = `rows`    v = `1`

                    )->end(
                    )->ele( n = `content` ns = `f`
                        )->ele( `VBox`
                            )->a( n = `class` v = `sapUiSmallMargin`

                            )->tag( `Title`
                                )->a( n = `text`     v = `1 / 1`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                        )->end(
                    )->end(
                )->end(
                )->ele( n = `Card` ns = `f`
                    )->ele( n = `layoutData` ns = `f`
                        )->tag( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `1`
                            )->a( n = `rows`    v = `1`

                    )->end(
                    )->ele( n = `content` ns = `f`
                        )->ele( `VBox`
                            )->a( n = `class` v = `sapUiSmallMargin`

                            )->tag( `Title`
                                )->a( n = `text`     v = `1 / 1`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle `
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle `
                                )->a( n = `wrapping` v = `true`

                        )->end(
                    )->end(
                )->end(
                )->ele( n = `Card` ns = `f`
                    )->ele( n = `layoutData` ns = `f`
                        )->tag( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `3`
                            )->a( n = `rows`    v = `2`

                    )->end(
                    )->ele( n = `content` ns = `f`
                        )->ele( `VBox`
                            )->a( n = `class` v = `sapUiSmallMargin`

                            )->tag( `Title`
                                )->a( n = `text`     v = `3 / 2`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle Subtitle Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                        )->end(
                    )->end(
                )->end(
                )->ele( n = `Card` ns = `f`
                    )->ele( n = `layoutData` ns = `f`
                        )->tag( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `1`
                            )->a( n = `rows`    v = `1`

                    )->end(
                    )->ele( n = `content` ns = `f`
                        )->ele( `VBox`
                            )->a( n = `class` v = `sapUiSmallMargin`

                            )->tag( `Title`
                                )->a( n = `text`     v = `1 / 1`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle Subtitle Subtitle`
                                )->a( n = `wrapping` v = `true`

                        )->end(
                    )->end(
                )->end(
                )->ele( n = `Card` ns = `f`
                    )->ele( n = `layoutData` ns = `f`
                        )->tag( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `1`
                            )->a( n = `rows`    v = `1`

                    )->end(
                    )->ele( n = `content` ns = `f`
                        )->ele( `VBox`
                            )->a( n = `class` v = `sapUiSmallMargin`

                            )->tag( `Title`
                                )->a( n = `text`     v = `1 / 1`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle Subtitle Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get( )-event = `LAYOUT_CHANGE`.
      " onLayoutChange: setProperty('/currentBreakpoint', event layout)
      currentbreakpoint = client->get_event_arg( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
