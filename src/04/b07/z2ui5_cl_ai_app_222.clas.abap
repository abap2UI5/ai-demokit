CLASS z2ui5_cl_ai_app_222 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA slider_value TYPE i VALUE 100.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_222 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:grid` v = `sap.ui.layout.cssgrid`
        )->a( n = `xmlns:f`    v = `sap.f`

        )->leaf( `ToggleButton`
            )->a( n = `id`    v = `revealGrid`
            )->a( n = `text`  v = `Reveal Grid`
            )->a( n = `class` v = `sapUiSmallMargin`

        " onSliderMoved sets the width of byId('panelForGridList') - the Panel HAS
        " a width property, so the resize is a roundtrip-free binding pair (the
        " app-176/213 idiom) instead of a jQuery write
        )->leaf( `Slider`
            )->a( n = `value` v = client->_bind( slider_value )

        )->open( `Panel`
            )->a( n = `id`               v = `panelForGridList`
            )->a( n = `width`            v = |\{= ${ client->_bind( slider_value ) } + '%' \}|
            )->a( n = `backgroundDesign` v = `Transparent`

            )->open( `headerToolbar`
                )->open( `Toolbar`
                    )->a( n = `height` v = `3rem`
                    )->leaf( `Title`
                        )->a( n = `text` v = `GridList with ResponsiveColumnLayout`

            )->shut(
            )->shut(

            )->open( n = `GridList` ns = `f`
                )->a( n = `id` v = `grid1`

                )->open( n = `customLayout` ns = `f`
                    )->leaf( n = `ResponsiveColumnLayout` ns = `grid`

                )->shut(

                )->open( n = `GridListItem` ns = `f`
                    )->open( n = `layoutData` ns = `f`
                        )->leaf( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `4`
                            )->a( n = `rows`    v = `4`

                    )->shut(
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

                )->open( n = `GridListItem` ns = `f`
                    )->open( n = `layoutData` ns = `f`
                        )->leaf( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `3`
                            )->a( n = `rows`    v = `2`

                    )->shut(
                    )->open( `VBox`
                        )->a( n = `class` v = `sapUiSmallMargin`
                        )->leaf( `Title`
                            )->a( n = `text`     v = `3 / 2`
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

                )->open( n = `GridListItem` ns = `f`
                    )->open( n = `layoutData` ns = `f`
                        )->leaf( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `3`
                            )->a( n = `rows`    v = `2`

                    )->shut(
                    )->open( `VBox`
                        )->a( n = `class` v = `sapUiSmallMargin`
                        )->leaf( `Title`
                            )->a( n = `text`     v = `3 / 2`
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

                )->open( n = `GridListItem` ns = `f`
                    )->open( n = `layoutData` ns = `f`
                        )->leaf( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `1`
                            )->a( n = `rows`    v = `1`

                    )->shut(
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

                )->open( n = `GridListItem` ns = `f`
                    )->open( n = `layoutData` ns = `f`
                        )->leaf( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `1`
                            )->a( n = `rows`    v = `1`

                    )->shut(
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
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
