" @keywords cssgrid sap.ui.layout.cssgrid gridgap slider panel overflowtoolbar title text label input vbox
" @summary Example of setting the gridGap property and using of Layout Data.
CLASS z2ui5_cl_smpc_app_347 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the width Slider - the Panel's width is an expression binding over it,
    " so the resize is roundtrip-free (the original sets it from onSliderMoved)
    DATA slider_value TYPE i.

    " the three gap Inputs: each one is two-way bound and the CSSGrid binds the
    " matching property to the SAME field, so typing a value reaches the grid
    " without the controller's imperative setGridGap/setGridRowGap/-ColumnGap
    DATA gridgap       TYPE string.
    DATA gridrowgap    TYPE string.
    DATA gridcolumngap TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_347 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " the gridGap demo: the Panel width follows the Slider through an
    " expression binding and the three gap Inputs are bound to the same fields
    " the CSSGrid binds, so both controller handlers become plain bindings.
    " css/main.css is injected through a core:HTML style leaf.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:grid` v = `sap.ui.layout.cssgrid`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`

        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.sapMFlexBox.demoBox\{border-radius:10px;background-color:#427cac;text-align:center\}` &&
                                    `.demoBox .sapMText\{color:#fff\}.sapMText.infoText\{font-style:italic\}</style>`

        )->tag( `Slider`
            )->a( n = `value` v = client->_bind( slider_value )
            )->a( n = `class` v = `sapUiSmallMarginBottom`

        )->ele( `Panel`
            )->a( n = `width` v = |\{= ${ client->_bind( slider_value ) } + '%'\}|
            )->a( n = `id`    v = `panelCSSGrid`

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`
                    )->a( n = `height` v = `3rem`

                    )->tag( `Title`
                        )->a( n = `text` v = ` Property gridGap example`

                )->end(
            )->end(
            )->tag( `Text`
                )->a( n = `class` v = `infoText`
                )->a( n = `text`  v = `The gridGap property sets both Row and Column gap values. Setting gridRowGap or gridColumnGap will overwrite the corresponding gridGap values.`

            )->ele( n = `SimpleForm` ns = `form`
                )->a( n = `editable`                v = `true`
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

                )->tag( `Label`
                    )->a( n = `labelFor` v = `gg`
                    )->a( n = `text`     v = `gridGap`

                )->tag( `Input`
                    )->a( n = `id`    v = `gg`
                    )->a( n = `width` v = `120px`
                    )->a( n = `value` v = client->_bind( gridgap )

                )->tag( `Label`
                    )->a( n = `labelFor` v = `grg`
                    )->a( n = `text`     v = `gridRowGap`

                )->tag( `Input`
                    )->a( n = `id`    v = `grg`
                    )->a( n = `width` v = `60px`
                    )->a( n = `value` v = client->_bind( gridrowgap )

                )->tag( `Label`
                    )->a( n = `labelFor` v = `gcg`
                    )->a( n = `text`     v = `gridColumnGap`

                )->tag( `Input`
                    )->a( n = `id`    v = `gcg`
                    )->a( n = `width` v = `60px`
                    )->a( n = `value` v = client->_bind( gridcolumngap )

            )->end(
            )->ele( n = `CSSGrid` ns = `grid`
                )->a( n = `id`                  v = `grid1`
                )->a( n = `gridAutoFlow`        v = `Column`
                )->a( n = `gridTemplateColumns` v = `repeat(6, minmax(30px,1fr))`
                )->a( n = `gridTemplateRows`    v = `repeat(2, 5rem)`
                )->a( n = `gridAutoRows`        v = `2rem`
                )->a( n = `gridGap`             v = client->_bind( gridgap )
                )->a( n = `gridRowGap`          v = client->_bind( gridrowgap )
                )->a( n = `gridColumnGap`       v = client->_bind( gridcolumngap )

                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->ele( `layoutData`
                        )->tag( n = `GridItemLayoutData` ns = `grid`
                            )->a( n = `gridRow` v = `1 / 3`

                    )->end(
                    )->tag( `Text`
                        )->a( n = `text`     v = `One (2 rows, 1 column)`
                        )->a( n = `wrapping` v = `true`

                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Text`
                        )->a( n = `text`     v = `Two`
                        )->a( n = `wrapping` v = `true`

                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Text`
                        )->a( n = `text`     v = `Three`
                        )->a( n = `wrapping` v = `true`

                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->ele( `layoutData`
                        )->tag( n = `GridItemLayoutData` ns = `grid`
                            )->a( n = `gridColumn` v = `3 / 5`

                    )->end(
                    )->tag( `Text`
                        )->a( n = `text`     v = `Four (1 row, 2 columns)`
                        )->a( n = `wrapping` v = `true`

                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Text`
                        )->a( n = `text`     v = `Five`
                        )->a( n = `wrapping` v = `true`

                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Text`
                        )->a( n = `text`     v = `Six`
                        )->a( n = `wrapping` v = `true`

                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Text`
                        )->a( n = `text`     v = `Seven`
                        )->a( n = `wrapping` v = `true`

                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Text`
                        )->a( n = `text`     v = `Eight`
                        )->a( n = `wrapping` v = `true`

                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Text`
                        )->a( n = `text`     v = `Nine`
                        )->a( n = `wrapping` v = `true`

                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Text`
                        )->a( n = `text`     v = `Ten`
                        )->a( n = `wrapping` v = `true`

                )->end(
            )->end(
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the original's initial values: Slider 100 and the gg Input / grid
    " gridGap at "1rem 0.5rem"; gridRowGap and gridColumnGap start empty,
    " exactly like the two Inputs that carry no value attribute
    slider_value = 100.
    gridgap      = `1rem 0.5rem`.

  ENDMETHOD.

ENDCLASS.
