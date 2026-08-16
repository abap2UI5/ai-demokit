CLASS z2ui5_cl_smpc_app_349 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the width Slider - the Panel's width is an expression binding over it
    DATA slider_value TYPE i.

    " the two template ComboBoxes: each one is two-way bound and the CSSGrid
    " binds the matching property to the SAME field, so picking a template
    " reaches the grid without the controller's setGridTemplateRows/-Columns
    DATA rowstemplate    TYPE string.
    DATA columnstemplate TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_349 IMPLEMENTATION.

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

    " the gridTemplateRows / gridTemplateColumns demo: the Panel width follows
    " the Slider through an expression binding, and each ComboBox value is
    " bound to the same field the CSSGrid binds, so both controller handlers
    " become plain bindings. css/main.css is injected as a core:HTML style leaf.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:grid` v = `sap.ui.layout.cssgrid`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`

        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.sapMFlexBox.demoBox\{border-radius:10px;background-color:#427cac;text-align:center\}` &&
                                    `.demoBox .sapMTitle,.demoBox .sapMText\{color:#fff\}</style>`

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
                        )->a( n = `text` v = `Properties gridTemplateRows and gridTemplateColumns example`

                )->end(
            )->end(
            )->ele( n = `SimpleForm` ns = `form`
                )->a( n = `editable`    v = `true`
                )->a( n = `layout`      v = `ResponsiveGridLayout`
                )->a( n = `labelSpanXL` v = `3`
                )->a( n = `labelSpanL`  v = `3`
                )->a( n = `labelSpanM`  v = `4`
                )->a( n = `labelSpanS`  v = `12`

                )->tag( `Label`
                    )->a( n = `text` v = `Change the value of Rows Template`

                )->ele( `ComboBox`
                    )->a( n = `id`          v = `rTem`
                    )->a( n = `width`       v = `40%`
                    )->a( n = `selectedKey` v = `rFr`
                    )->a( n = `value`       v = client->_bind( rowstemplate )

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `1fr 2fr 1fr`
                        )->a( n = `key`  v = `rFr`

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `1fr 3fr 1fr`

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `1fr 2fr 3fr`

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `auto`

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `40px 4em 40px`

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `25% 40% 25%`

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `minmax(10px, 100px) auto auto`

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `repeat(3, 50px)`

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `repeat(3, minmax(40px, 60px))`

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `repeat(auto-fill, 50px)`

                )->end(
                )->tag( `Label`
                    )->a( n = `text` v = `Change the value of Columns Template`

                )->ele( `ComboBox`
                    )->a( n = `id`          v = `cTem`
                    )->a( n = `width`       v = `40%`
                    )->a( n = `selectedKey` v = `cFr`
                    )->a( n = `value`       v = client->_bind( columnstemplate )

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `1fr 1fr`
                        )->a( n = `key`  v = `cFr`

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `1fr 2fr`

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `auto`

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `400px auto`

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `25% 50%`

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `minmax(100px, 200px) auto`

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `repeat(2, 150px)`

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `repeat(2, minmax(120px, 1fr))`

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `repeat(auto-fill, 200px)`

                )->end(
            )->end(
            )->ele( n = `CSSGrid` ns = `grid`
                )->a( n = `id`                  v = `grid1`
                )->a( n = `gridTemplateRows`    v = client->_bind( rowstemplate )
                )->a( n = `gridTemplateColumns` v = client->_bind( columnstemplate )
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

                    )->tag( `Title`
                        )->a( n = `text`     v = `D Box`
                        )->a( n = `wrapping` v = `true`

                    )->tag( `Text`
                        )->a( n = `text`     v = `D Box subtitle`
                        )->a( n = `wrapping` v = `true`

                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Title`
                        )->a( n = `text`     v = `E Box`
                        )->a( n = `wrapping` v = `true`

                    )->tag( `Text`
                        )->a( n = `text`     v = `E Box subtitle`
                        )->a( n = `wrapping` v = `true`

                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->tag( `Title`
                        )->a( n = `text`     v = `F Box`
                        )->a( n = `wrapping` v = `true`

                    )->tag( `Text`
                        )->a( n = `text`     v = `F Box subtitle`
                        )->a( n = `wrapping` v = `true`

                )->end(
            )->end(
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the original's initial values: Slider 100, and the two ComboBoxes on
    " their preselected keys rFr / cFr, whose item texts are the templates
    slider_value    = 100.
    rowstemplate    = `1fr 2fr 1fr`.
    columnstemplate = `1fr 1fr`.

  ENDMETHOD.

ENDCLASS.
