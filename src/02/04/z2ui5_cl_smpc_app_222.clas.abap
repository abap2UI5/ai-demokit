" @keywords gridlist grid list sap.f gridlistresponsivecolumnlayout togglebutton slider panel toolbar title responsivecolumnlayout gridlistitem
" @summary This layout displays a variable number of grid columns depending on available screen size. Grid row's height is dynamically determined by the height of the highest grid element on this row.
CLASS z2ui5_cl_smpc_app_222 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA slider_value TYPE i VALUE 100.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_222 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:grid` v = `sap.ui.layout.cssgrid`
        )->a( n = `xmlns:f`    v = `sap.f`

        )->tag( `ToggleButton`
            )->a( n = `id`    v = `revealGrid`
            )->a( n = `text`  v = `Reveal Grid`
            )->a( n = `class` v = `sapUiSmallMargin`

        " onSliderMoved sets the width of byId('panelForGridList') - the Panel HAS
        " a width property, so the resize is a roundtrip-free binding pair (the
        " app-176/213 idiom) instead of a jQuery write
        )->tag( `Slider`
            )->a( n = `value` v = client->_bind( slider_value )

        )->ele( `Panel`
            )->a( n = `id`               v = `panelForGridList`
            )->a( n = `width`            v = |\{= ${ client->_bind( slider_value ) } + '%' \}|
            )->a( n = `backgroundDesign` v = `Transparent`

            )->ele( `headerToolbar`
                )->ele( `Toolbar`
                    )->a( n = `height` v = `3rem`
                    )->tag( `Title`
                        )->a( n = `text` v = `GridList with ResponsiveColumnLayout`

                )->end(
            )->end(

            )->ele( n = `GridList` ns = `f`
                )->a( n = `id` v = `grid1`

                )->ele( n = `customLayout` ns = `f`
                    )->tag( n = `ResponsiveColumnLayout` ns = `grid`

                )->end(

                )->ele( n = `GridListItem` ns = `f`
                    )->ele( n = `layoutData` ns = `f`
                        )->tag( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `4`
                            )->a( n = `rows`    v = `4`

                    )->end(
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

                )->ele( n = `GridListItem` ns = `f`
                    )->ele( n = `layoutData` ns = `f`
                        )->tag( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `3`
                            )->a( n = `rows`    v = `2`

                    )->end(
                    )->ele( `VBox`
                        )->a( n = `class` v = `sapUiSmallMargin`
                        )->tag( `Title`
                            )->a( n = `text`     v = `3 / 2`
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

                )->ele( n = `GridListItem` ns = `f`
                    )->ele( n = `layoutData` ns = `f`
                        )->tag( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `3`
                            )->a( n = `rows`    v = `2`

                    )->end(
                    )->ele( `VBox`
                        )->a( n = `class` v = `sapUiSmallMargin`
                        )->tag( `Title`
                            )->a( n = `text`     v = `3 / 2`
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

                )->ele( n = `GridListItem` ns = `f`
                    )->ele( n = `layoutData` ns = `f`
                        )->tag( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `1`
                            )->a( n = `rows`    v = `1`

                    )->end(
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

                )->ele( n = `GridListItem` ns = `f`
                    )->ele( n = `layoutData` ns = `f`
                        )->tag( n = `ResponsiveColumnItemLayoutData` ns = `grid`
                            )->a( n = `columns` v = `1`
                            )->a( n = `rows`    v = `1`

                    )->end(
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
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
