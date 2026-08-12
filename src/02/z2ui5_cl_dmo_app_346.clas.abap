CLASS z2ui5_cl_dmo_app_346 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_346 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " the two CSSGrid demos (gridAutoRows / gridAutoColumns) with their
    " SimpleForm property tables, 1:1. css/main.css is injected through a
    " core:HTML style leaf (CSS braces escaped so the XMLView parser does not
    " read them as bindings) - without it the demo boxes render unstyled.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:grid` v = `sap.ui.layout.cssgrid`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`

        )->leaf( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.sapMFlexBox.demoBox\{border-radius:10px;background-color:#427cac;text-align:center\}` &&
                                    `.demoBox .sapMText\{color:#fff\}.sapMText.message\{font-weight:bold\}</style>`

        )->open( `Panel`
            )->leaf( `ToggleButton`
                )->a( n = `id`    v = `revealGrid`
                )->a( n = `text`  v = `Reveal Grid`
                )->a( n = `class` v = `sapUiTinyMarginTopBottom sapUiTinyMarginBeginEnd`

        )->shut(
        )->open( `Panel`
            )->open( `headerToolbar`
                )->open( `OverflowToolbar`
                    )->a( n = `height` v = `3rem`

                    )->leaf( `Title`
                        )->a( n = `text` v = ` Property gridAutoRows example`

                )->shut(
            )->shut(
            )->leaf( `Text`
                )->a( n = `class` v = `message sapUiResponsiveMargin`
                )->a( n = `text`  v = `Row dimensions are set to 3rems for the first 2 rows, while extra rows height is set to 1.5rem by gridAutoRows.`

            )->open( n = `SimpleForm` ns = `form`
                )->a( n = `editable`                v = `false`
                )->a( n = `layout`                  v = `ResponsiveGridLayout`
                )->a( n = `labelSpanXL`             v = `4`
                )->a( n = `labelSpanL`              v = `3`
                )->a( n = `labelSpanM`              v = `4`
                )->a( n = `labelSpanS`              v = `12`
                )->a( n = `adjustLabelSpan`         v = `false`
                )->a( n = `emptySpanXL`             v = `0`
                )->a( n = `emptySpanL`              v = `4`
                )->a( n = `emptySpanM`              v = `0`
                )->a( n = `emptySpanS`              v = `0`
                )->a( n = `columnsXL`               v = `2`
                )->a( n = `columnsL`                v = `1`
                )->a( n = `columnsM`                v = `1`
                )->a( n = `singleContainerFullSize` v = `false`

                )->leaf( `Label`
                    )->a( n = `displayOnly` v = `false`
                    )->a( n = `text`        v = `gridTemplateRows is set to`

                )->leaf( `Text`
                    )->a( n = `text` v = `repeat(2, 3rem)`

                )->leaf( `Label`
                    )->a( n = `displayOnly` v = `false`
                    )->a( n = `text`        v = `gridAutoRows is set to`

                )->leaf( `Text`
                    )->a( n = `text` v = `1.5rem`

            )->shut(
            )->open( n = `CSSGrid` ns = `grid`
                )->a( n = `id`                  v = `grid1`
                )->a( n = `gridAutoFlow`        v = `Row`
                )->a( n = `gridTemplateColumns` v = `repeat(4, 10rem)`
                )->a( n = `gridTemplateRows`    v = `repeat(2, 3rem)`
                )->a( n = `gridAutoRows`        v = `1.5rem`
                )->a( n = `gridGap`             v = `1rem`

                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `A`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `B`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `C`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `D`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `E`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `F`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `G`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `H`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `I`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `J`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `K`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `L`
                        )->a( n = `wrapping` v = `true`

                )->shut(
            )->shut(
        )->shut(
        )->open( `Panel`
            )->open( `headerToolbar`
                )->open( `Toolbar`
                    )->a( n = `height` v = `3rem`

                    )->leaf( `Title`
                        )->a( n = `text` v = ` Property gridAutoColumns example`

                )->shut(
            )->shut(
            )->open( n = `SimpleForm` ns = `form`
                )->a( n = `editable`                v = `false`
                )->a( n = `layout`                  v = `ResponsiveGridLayout`
                )->a( n = `labelSpanXL`             v = `4`
                )->a( n = `labelSpanL`              v = `3`
                )->a( n = `labelSpanM`              v = `4`
                )->a( n = `labelSpanS`              v = `12`
                )->a( n = `adjustLabelSpan`         v = `false`
                )->a( n = `emptySpanXL`             v = `0`
                )->a( n = `emptySpanL`              v = `4`
                )->a( n = `emptySpanM`              v = `0`
                )->a( n = `emptySpanS`              v = `0`
                )->a( n = `columnsXL`               v = `2`
                )->a( n = `columnsL`                v = `1`
                )->a( n = `columnsM`                v = `1`
                )->a( n = `singleContainerFullSize` v = `false`

                )->leaf( `Label`
                    )->a( n = `displayOnly` v = `false`
                    )->a( n = `text`        v = `gridTemplateColumns is set to`

                )->leaf( `Text`
                    )->a( n = `text` v = `repeat(3, 10rem)`

                )->leaf( `Label`
                    )->a( n = `displayOnly` v = `false`
                    )->a( n = `text`        v = `gridAutoColumns is set to`

                )->leaf( `Text`
                    )->a( n = `text` v = `5rem`

            )->shut(
            )->leaf( `Text`
                )->a( n = `class` v = `message sapUiResponsiveMargin`
                )->a( n = `text`  v = `Column dimensions are set to 10rems for the first 3 columns, while extra columns width is set to 5rems by gridAutoColumns.`

            )->open( n = `CSSGrid` ns = `grid`
                )->a( n = `id`                  v = `grid2`
                )->a( n = `gridAutoFlow`        v = `Column`
                )->a( n = `gridTemplateRows`    v = `repeat(4, 2rem)`
                )->a( n = `gridTemplateColumns` v = `repeat(3, 10rem)`
                )->a( n = `gridAutoColumns`     v = `5rem`
                )->a( n = `gridGap`             v = `1rem`

                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `M`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `N`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `O`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `P`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `Q`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `R`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `S`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `T`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `U`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `V`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `W`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `X`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `Y`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `Z`
                        )->a( n = `wrapping` v = `true`

                )->shut(
            )->shut(
        )->shut(
    )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
