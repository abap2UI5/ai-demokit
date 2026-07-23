CLASS z2ui5_cl_ai_app_145 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_145 IMPLEMENTATION.

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

        )->leaf( `ToggleButton`
            )->a( n = `id`    v = `revealGrid`
            )->a( n = `text`  v = `Reveal Grid`
            )->a( n = `press` v = client->_event( `REVEAL` )
            )->a( n = `class` v = `sapUiSmallMargin`

        )->open( `Panel`
            )->a( n = `width`  v = `100%`
            )->a( n = `height` v = `100%`

            )->open( `headerToolbar`
                )->open( `OverflowToolbar`
                    )->a( n = `height` v = `3rem`
                    )->leaf( `Title`
                        )->a( n = `text` v = `gridAutoFlow property example`

            )->shut(
            )->shut(

            )->open( `RadioButtonGroup`
                )->a( n = `class`  v = `sapUiSmallMargin`
                )->a( n = `select` v = client->_event( `RB_SELECT` )
                )->leaf( `RadioButton`
                    )->a( n = `text` v = `Column - Vertical placement in columns`
                )->leaf( `RadioButton`
                    )->a( n = `text` v = `ColumnDense - Vertical placement in columns and filling empty spaces`
                )->leaf( `RadioButton`
                    )->a( n = `text` v = `Row - Horizontal placement in rows`
                )->leaf( `RadioButton`
                    )->a( n = `text` v = `RowDense - Horizontal placement in rows and filling empty spaces`

            )->shut(

            )->open( n = `CSSGrid` ns = `grid`
                )->a( n = `id`                  v = `grid1`
                )->a( n = `gridAutoFlow`        v = `Column`
                )->a( n = `gridTemplateColumns` v = `repeat(7, 1fr)`
                )->a( n = `gridTemplateRows`    v = `repeat(2, 5rem)`
                )->a( n = `gridAutoRows`        v = `5rem`
                )->a( n = `gridAutoColumns`     v = `1fr`
                )->a( n = `gridGap`             v = `0.5rem`

            )->open( `VBox`
                )->a( n = `class` v = `demoBox`
                )->open( `layoutData`
                    )->leaf( n = `GridItemLayoutData` ns = `grid`
                        )->a( n = `gridRow` v = `span 2`

                )->shut(
                )->leaf( `Text`
                    )->a( n = `text`     v = `One (2 rows)`
                    )->a( n = `wrapping` v = `true`

            )->shut(
            )->open( `VBox`
                )->a( n = `class` v = `demoBox`
                )->leaf( `Text`
                    )->a( n = `text`     v = `Two`
                    )->a( n = `wrapping` v = `true`

            )->shut(
            )->open( `VBox`
                )->a( n = `class` v = `demoBox`
                )->open( `layoutData`
                    )->leaf( n = `GridItemLayoutData` ns = `grid`
                        )->a( n = `gridRow` v = `span 2`

                )->shut(
                )->leaf( `Text`
                    )->a( n = `text`     v = `Three (2 rows)`
                    )->a( n = `wrapping` v = `true`

            )->shut(
            )->open( `VBox`
                )->a( n = `class` v = `demoBox`
                )->open( `layoutData`
                    )->leaf( n = `GridItemLayoutData` ns = `grid`
                        )->a( n = `gridColumn` v = `span 2`

                )->shut(
                )->leaf( `Text`
                    )->a( n = `text`     v = `Four (2 columns)`
                    )->a( n = `wrapping` v = `true`

            )->shut(
            )->open( `VBox`
                )->a( n = `class` v = `demoBox`
                )->leaf( `Text`
                    )->a( n = `text`     v = `Five`
                    )->a( n = `wrapping` v = `true`

            )->shut(
            )->open( `VBox`
                )->a( n = `class` v = `demoBox`
                )->open( `layoutData`
                    )->leaf( n = `GridItemLayoutData` ns = `grid`
                        )->a( n = `gridColumn` v = `span 2`

                )->shut(
                )->leaf( `Text`
                    )->a( n = `text`     v = `Six (2 columns)`
                    )->a( n = `wrapping` v = `true`

            )->shut(
            )->open( `VBox`
                )->a( n = `class` v = `demoBox`
                )->leaf( `Text`
                    )->a( n = `text`     v = `Seven`
                    )->a( n = `wrapping` v = `true`

            )->shut(
            )->open( `VBox`
                )->a( n = `class` v = `demoBox`
                )->leaf( `Text`
                    )->a( n = `text`     v = `Eight`
                    )->a( n = `wrapping` v = `true`

            )->shut(
            )->open( `VBox`
                )->a( n = `class` v = `demoBox`
                )->leaf( `Text`
                    )->a( n = `text`     v = `Nine`
                    )->a( n = `wrapping` v = `true`

            )->shut(
            )->open( `VBox`
                )->a( n = `class` v = `demoBox`
                )->leaf( `Text`
                    )->a( n = `text`     v = `Ten`
                    )->a( n = `wrapping` v = `true` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
