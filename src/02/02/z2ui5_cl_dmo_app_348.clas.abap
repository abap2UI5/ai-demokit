CLASS z2ui5_cl_dmo_app_348 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_dmo_app_348 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      slider_value = 100.             " the Slider's value="100"
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " the ResponsiveColumnLayout demo with its eight f:Cards. The Panel width
    " follows the Slider through an expression binding (roundtrip-free), and
    " the layout's layoutChange carries its layout parameter to the backend so
    " the "Current breakpoint" Text shows it, like the original's model write.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`       v = `sap.m`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:grid`  v = `sap.ui.layout.cssgrid`
        )->a( n = `xmlns:f`     v = `sap.f`
        )->a( n = `xmlns:cards` v = `sap.f.cards`

        )->leaf( `ToggleButton`
            )->a( n = `id`    v = `revealGrid`
            )->a( n = `text`  v = `Reveal Grid`
            )->a( n = `class` v = `sapUiSmallMargin`

        )->leaf( `Slider`
            )->a( n = `value` v = client->_bind( slider_value )
            )->a( n = `class` v = `sapUiSmallMarginBottom`

        )->open( `Panel`
            )->a( n = `width` v = |\{= ${ client->_bind( slider_value ) } + '%'\}|
            )->a( n = `id`    v = `panelCSSGrid`

            )->open( `headerToolbar`
                )->open( `Toolbar`
                    )->a( n = `height` v = `3rem`

                    )->leaf( `Title`
                        )->a( n = `text` v = `Grid with ResponsiveColumnLayout`

                )->shut(
            )->shut(
            )->leaf( `Text`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `text`  v = `ResponsiveColumnLayout represents a layout which is configured to display a variable number of columns depending on available screen size.`

            )->leaf( `Text`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `text`  v = `Grid row's height is dynamically determined by the height of the highest grid element on this row.`

            )->leaf( `Text`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `text`  v = |Current breakpoint: { client->_bind( currentbreakpoint ) }|
                )->a( n = `width` v = `100%`

            )->open( n = `CSSGrid` ns = `grid`
                )->a( n = `id` v = `grid1`

                )->open( n = `customLayout` ns = `grid`
                    )->leaf( n = `ResponsiveColumnLayout` ns = `grid`
                        )->a( n = `layoutChange` v = client->_event( val   = `LAYOUT_CHANGE`
                                                                     t_arg = VALUE #( ( `${$parameters>/layout}` ) ) )

                )->shut(
                )->open( n = `Card` ns = `f`
                    )->open( n = `layoutData` ns = `f`
                        )->leaf( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `4`
                            )->a( n = `rows`    v = `4`

                    )->shut(
                    )->open( n = `content` ns = `f`
                        )->open( `VBox`
                            )->a( n = `class` v = `sapUiSmallMargin`

                            )->leaf( `Title`
                                )->a( n = `text`     v = `4 / 4`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                        )->shut(
                    )->shut(
                )->shut(
                )->open( n = `Card` ns = `f`
                    )->open( n = `layoutData` ns = `f`
                        )->leaf( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `3`
                            )->a( n = `rows`    v = `3`

                    )->shut(
                    )->open( n = `content` ns = `f`
                        )->open( `VBox`
                            )->a( n = `class` v = `sapUiSmallMargin`

                            )->leaf( `Title`
                                )->a( n = `text`     v = `3 / 3`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle Subtitle Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                        )->shut(
                    )->shut(
                )->shut(
                )->open( n = `Card` ns = `f`
                    )->open( n = `layoutData` ns = `f`
                        )->leaf( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `1`
                            )->a( n = `rows`    v = `1`

                    )->shut(
                    )->open( n = `content` ns = `f`
                        )->open( `VBox`
                            )->a( n = `class` v = `sapUiSmallMargin`

                            )->leaf( `Title`
                                )->a( n = `text`     v = `1 / 1`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                        )->shut(
                    )->shut(
                )->shut(
                )->open( n = `Card` ns = `f`
                    )->open( n = `layoutData` ns = `f`
                        )->leaf( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `1`
                            )->a( n = `rows`    v = `1`

                    )->shut(
                    )->open( n = `content` ns = `f`
                        )->open( `VBox`
                            )->a( n = `class` v = `sapUiSmallMargin`

                            )->leaf( `Title`
                                )->a( n = `text`     v = `1 / 1`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                        )->shut(
                    )->shut(
                )->shut(
                )->open( n = `Card` ns = `f`
                    )->open( n = `layoutData` ns = `f`
                        )->leaf( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `1`
                            )->a( n = `rows`    v = `1`

                    )->shut(
                    )->open( n = `content` ns = `f`
                        )->open( `VBox`
                            )->a( n = `class` v = `sapUiSmallMargin`

                            )->leaf( `Title`
                                )->a( n = `text`     v = `1 / 1`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle `
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle `
                                )->a( n = `wrapping` v = `true`

                        )->shut(
                    )->shut(
                )->shut(
                )->open( n = `Card` ns = `f`
                    )->open( n = `layoutData` ns = `f`
                        )->leaf( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `3`
                            )->a( n = `rows`    v = `2`

                    )->shut(
                    )->open( n = `content` ns = `f`
                        )->open( `VBox`
                            )->a( n = `class` v = `sapUiSmallMargin`

                            )->leaf( `Title`
                                )->a( n = `text`     v = `3 / 2`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle Subtitle Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                        )->shut(
                    )->shut(
                )->shut(
                )->open( n = `Card` ns = `f`
                    )->open( n = `layoutData` ns = `f`
                        )->leaf( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `1`
                            )->a( n = `rows`    v = `1`

                    )->shut(
                    )->open( n = `content` ns = `f`
                        )->open( `VBox`
                            )->a( n = `class` v = `sapUiSmallMargin`

                            )->leaf( `Title`
                                )->a( n = `text`     v = `1 / 1`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle Subtitle Subtitle`
                                )->a( n = `wrapping` v = `true`

                        )->shut(
                    )->shut(
                )->shut(
                )->open( n = `Card` ns = `f`
                    )->open( n = `layoutData` ns = `f`
                        )->leaf( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `1`
                            )->a( n = `rows`    v = `1`

                    )->shut(
                    )->open( n = `content` ns = `f`
                        )->open( `VBox`
                            )->a( n = `class` v = `sapUiSmallMargin`

                            )->leaf( `Title`
                                )->a( n = `text`     v = `1 / 1`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle Subtitle Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Subtitle`
                                )->a( n = `wrapping` v = `true`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
        )->shut(
    )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `LAYOUT_CHANGE`.
        " onLayoutChange: setProperty('/currentBreakpoint', event layout)
        currentbreakpoint = client->get_event_arg( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
